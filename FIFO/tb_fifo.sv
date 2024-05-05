`timescale 1ns / 1ps

module tb_fifo;

    parameter int DATA_WIDTH = 24;
    parameter real S_AXIS_CLK_PERIOD = 8.771;  // ~114MHz
    parameter real M_AXIS_CLK_PERIOD = 13.468; // ~74.25MHz
    parameter int TOTAL_WRITES = 1000;
    parameter int START_READ_AFTER = 500;

    // Testbench signals
    logic s_axis_aresetn;
    logic s_axis_aclk;
    logic s_axis_tvalid;
    logic s_axis_tready;
    logic [DATA_WIDTH-1:0] s_axis_tdata;

    logic m_axis_aclk;
    logic m_axis_tready;
    logic m_axis_tvalid;
    logic [DATA_WIDTH-1:0] m_axis_tdata;
    
    logic [13:0] axis_rd_data_count;
    int write_count;

    // Instantiate the module
    axis_data_fifo_0 dut (
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tdata(s_axis_tdata),
        .m_axis_aclk(m_axis_aclk),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .m_axis_tdata(m_axis_tdata),
        .axis_rd_data_count(axis_rd_data_count)
    );

    // Clock generation for s_axis_aclk
    initial begin
        s_axis_aclk = 0;
        forever #(S_AXIS_CLK_PERIOD / 2) s_axis_aclk = ~s_axis_aclk;
    end

    // Clock generation for m_axis_aclk
    initial begin
        m_axis_aclk = 0;
        forever #(M_AXIS_CLK_PERIOD / 2) m_axis_aclk = ~m_axis_aclk;
    end

    // Test sequence
    initial begin
        // Initialize signals
        s_axis_aresetn = 0;
        s_axis_tvalid = 0;
        m_axis_tready = 0;
        s_axis_tdata = 0;

        // Wait for reset
        #(S_AXIS_CLK_PERIOD * 100);
        s_axis_aresetn = 1;
        s_axis_tvalid = 1; // Keep tvalid high for continuous write
        m_axis_tready = 0; // Initially, tready is low

        // Continuous write process
        #(S_AXIS_CLK_PERIOD * 1000);
        write_count = 0;
        forever begin
            @(posedge s_axis_aclk);
            if (write_count < 1000) begin
                s_axis_tdata = write_count; // Example data pattern
                write_count++;
                // Start reading after a certain number of writes
                if (write_count == 200) begin
                    m_axis_tready = 1; // Enable reading
                end
                if (write_count == 400) begin
                    m_axis_tready = 0; // Enable reading
                end
                if (write_count == 600) begin
                    m_axis_tready = 1; // Enable reading
                end
            end      
            else begin
                // Stop writing after TOTAL_WRITES
                s_axis_tvalid = 0;
                $finish;
            end
        end
    end

endmodule
