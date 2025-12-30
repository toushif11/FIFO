module sync_fifo(
  input        clk,
  input        rst_n,
  input        we,
  input  [7:0] data_i,
  output reg   full,

  input        re,
  output reg [7:0] data_o,
  output reg   empty
);

  // FIFO memory
  reg [7:0] fifo [0:15];

  // Write and Read pointers (extra MSB for full/empty)
  reg [4:0] w_ptr;
  reg [4:0] r_ptr;

  reg read_en;
  reg write_en;

  // Enable logic
  always @(*) begin
    read_en  = re && !empty;
    write_en = we && !full;
  end

  // Empty condition
  always @(*) begin
    empty = (w_ptr == r_ptr);
  end

  // Full condition
  always @(*) begin
    full = (r_ptr == {~w_ptr[4], w_ptr[3:0]});
  end

  integer i;

  // Sequential logic
  always @(posedge clk) begin
    if (!rst_n) begin
      w_ptr  <= 5'b0;
      r_ptr  <= 5'b0;
      data_o <= 8'b0;
      for (i = 0; i < 16; i = i + 1)
        fifo[i] <= 8'b0;
    end
    else begin
      if (write_en) begin
        fifo[w_ptr[3:0]] <= data_i;
        w_ptr <= w_ptr + 1'b1;
      end
      if (read_en) begin
        data_o <= fifo[r_ptr[3:0]];
        r_ptr <= r_ptr + 1'b1;
      end
    end
  end

endmodule

