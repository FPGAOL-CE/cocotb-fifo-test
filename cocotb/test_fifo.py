import logging
import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge, Timer, with_timeout

from cocotbext.axi import AxiStreamBus, AxiStreamFrame, AxiStreamSource, AxiStreamSink

class Tester():
    def __init__(self, dut):
        self.dut = dut

        self.log = logging.getLogger("cocotb.tb")
        self.log.setLevel(logging.DEBUG)

        # Clock generation for s_axis_aclk
        S_AXIS_CLK_PERIOD = 8.77               # ~114MHz
        cocotb.start_soon(Clock(self.dut.s_axis_aclk, S_AXIS_CLK_PERIOD, units="ns").start())

        # Clock generation for m_axis_aclk
        M_AXIS_CLK_PERIOD = 13.47              # ~74.25MHz
        cocotb.start_soon(Clock(self.dut.m_axis_aclk, M_AXIS_CLK_PERIOD, units="ns").start())

        # Attach buses
        self.source = AxiStreamSource(AxiStreamBus.from_prefix(self.dut, "s_axis"), self.dut.s_axis_aclk, self.dut.s_axis_aresetn, False,  byte_lanes=1)
        self.sink = AxiStreamSink(AxiStreamBus.from_prefix(self.dut, "m_axis"), self.dut.m_axis_aclk, self.dut.m_axis_aresetn, False, byte_lanes=1)

    async def reset(self):
        self.dut.s_axis_aresetn.value = 1
        await ClockCycles(self.dut.s_axis_aclk, 2)
        self.dut.s_axis_aresetn.value = 0
        await ClockCycles(self.dut.s_axis_aclk, 2)
        self.dut.s_axis_aresetn.value = 1

        await RisingEdge(self.dut.m_axis_aresetn)
        s = ClockCycles(self.dut.s_axis_aclk, 2)
        m = ClockCycles(self.dut.m_axis_aclk, 2)
        await cocotb.triggers.Combine(s, m)

    def set_idle_generator(self, generator=None):
        if generator:
            self.source.set_pause_generator(generator())

    def set_backpressure_generator(self, generator=None):
        if generator:
            self.sink.set_pause_generator(generator())


def rand_generator():
    while True:
        yield random.randint(0, 1)

def zero_generator():
    while True:
        yield 0

def one_generator():
    while True:
        yield 1

@cocotb.test()
async def test_fifo(dut):
    # initializer tester
    tb = Tester(dut)
    await tb.reset()
    
    # Pause RX & TX
    tb.set_idle_generator(one_generator)
    tb.set_backpressure_generator(one_generator)

    # send N test frames
    n_vectors = 1500  # send n vectors = test frames
    tb.set_idle_generator(rand_generator) # schmoo backpressure & starvation
    test_frames = []
    for test_data in range(n_vectors):
        test_frame = AxiStreamFrame([test_data])
        await tb.source.send(test_frame)
        test_frames.append(test_frame)

    # start receveing the test frames after a bunch of cycles
    await ClockCycles(dut.s_axis_aclk, n_vectors)
    tb.set_backpressure_generator(rand_generator) # schmoo backpressure & starvation
    rx_frames = []
    for test_frame in test_frames:
        rx_frame = await tb.sink.recv()
        rx_frames.append(rx_frame)
        
    # Pause the receiver
    tb.set_backpressure_generator(one_generator)

    # Check results
    assert test_frames == rx_frames
    assert tb.sink.empty()
    assert tb.source.empty()

    await ClockCycles(dut.s_axis_aclk, 50)
