-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                  SystemVerilog / Verilog Snippets                         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

-- Helper to get filename without extension
local function get_module_name()
  local filename = vim.fn.expand("%:t:r")
  return filename ~= "" and filename or "module_name"
end

local verilog_snippets = {
  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Module Templates                                                       │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("mod", fmt([[
module {} #(
  parameter {} = {}
) (
  input  logic       clk,
  input  logic       rst_n,
  {}
);

  {}

endmodule : {}
]], {
    f(function() return get_module_name() end),
    i(1, "WIDTH"),
    i(2, "8"),
    i(3, "// ports"),
    i(4, "// logic"),
    f(function() return get_module_name() end),
  })),



  s("modmin", fmt([[
module {} (
  {}
);

  {}

endmodule : {}
]], {
    f(function() return get_module_name() end),
    i(1, "// ports"),
    i(2, "// logic"),
    f(function() return get_module_name() end),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Always Blocks                                                          │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("alwff", fmt([[
always_ff @(posedge {} or negedge {}) begin
  if (!{}) begin
    {}
  end else begin
    {}
  end
end
]], {
    i(1, "clk"),
    i(2, "rst_n"),
    rep(2),
    i(3, "// reset"),
    i(4, "// logic"),
  })),

  s("alwffp", fmt([[
always_ff @(posedge {}) begin
  {}
end
]], {
    i(1, "clk"),
    i(2, "// logic"),
  })),

  s("alwcb", fmt([[
always_comb begin
  {}
end
]], {
    i(1, "// logic"),
  })),

  s("alwl", fmt([[
always_latch begin
  {}
end
]], {
    i(1, "// logic"),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Control Flow                                                           │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("ife", fmt([[
if ({}) begin
  {}
end else begin
  {}
end
]], {
    i(1, "condition"),
    i(2, "// then"),
    i(3, "// else"),
  })),

  s("case", fmt([[
case ({})
  {}: begin
    {}
  end
  default: begin
    {}
  end
endcase
]], {
    i(1, "sel"),
    i(2, "value"),
    i(3, "// action"),
    i(4, "// default"),
  })),

  s("casex", fmt([[
casex ({})
  {}: begin
    {}
  end
  default: begin
    {}
  end
endcase
]], {
    i(1, "sel"),
    i(2, "pattern"),
    i(3, "// action"),
    i(4, "// default"),
  })),

  s("casez", fmt([[
casez ({})
  {}: begin
    {}
  end
  default: begin
    {}
  end
endcase
]], {
    i(1, "sel"),
    i(2, "pattern"),
    i(3, "// action"),
    i(4, "// default"),
  })),

  s("unique", fmt([[
unique case ({})
  {}: begin
    {}
  end
  default: begin
    {}
  end
endcase
]], {
    i(1, "sel"),
    i(2, "value"),
    i(3, "// action"),
    i(4, "// default"),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Generate                                                               │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("genfor", fmt([[
generate
  for (genvar {} = 0; {} < {}; {}++) begin : gen_{}
    {}
  end
endgenerate
]], {
    i(1, "i"),
    rep(1),
    i(2, "N"),
    rep(1),
    i(3, "loop"),
    i(4, "// generated logic"),
  })),

  s("genif", fmt([[
generate
  if ({}) begin : gen_{}
    {}
  end else begin : gen_{}
    {}
  end
endgenerate
]], {
    i(1, "condition"),
    i(2, "true"),
    i(3, "// if true"),
    i(4, "false"),
    i(5, "// if false"),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Types and Declarations                                                 │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("logic", fmt("logic [{}-1:0] {};", { i(1, "WIDTH"), i(2, "signal") })),
  s("logicu", fmt("logic [{}-1:0] {} [0:{}-1];", { i(1, "WIDTH"), i(2, "mem"), i(3, "DEPTH") })),
  
  s("enum", fmt([[
typedef enum logic [{}-1:0] {{
  {} = {}'b{},
  {}
}} {}_t;
]], {
    i(1, "2"),
    i(2, "IDLE"),
    rep(1),
    i(3, "00"),
    i(4, "// states"),
    i(5, "state"),
  })),

  s("struct", fmt([[
typedef struct packed {{
  logic [{}-1:0] {};
  {}
}} {}_t;
]], {
    i(1, "WIDTH"),
    i(2, "field"),
    i(3, "// fields"),
    i(4, "name"),
  })),

  s("union", fmt([[
typedef union packed {{
  logic [{}-1:0] {};
  {}
}} {}_t;
]], {
    i(1, "WIDTH"),
    i(2, "field"),
    i(3, "// fields"),
    i(4, "name"),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ FSM                                                                    │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("fsm", fmt([[
// FSM States
typedef enum logic [{}:0] {{
  IDLE    = {}'b{},
  {}
}} state_t;

state_t state_q, state_d;

// State register
always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    state_q <= IDLE;
  end else begin
    state_q <= state_d;
  end
end

// Next state logic
always_comb begin
  state_d = state_q;  // Default: stay in current state
  
  unique case (state_q)
    IDLE: begin
      if ({}) begin
        state_d = {};
      end
    end
    
    {}: begin
      {}
    end
    
    default: begin
      state_d = IDLE;
    end
  endcase
end

// Output logic
always_comb begin
  // Default outputs
  {}
  
  unique case (state_q)
    IDLE: begin
      {}
    end
    
    default: begin
    end
  endcase
end
]], {
    i(1, "1"),
    rep(1),
    i(2, "00"),
    i(3, "STATE1 = 2'b01"),
    i(4, "start"),
    i(5, "STATE1"),
    i(6, "STATE1"),
    i(7, "// transitions"),
    i(8, "// outputs = 0"),
    i(9, "// idle outputs"),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Interfaces                                                             │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("intf", fmt([[
interface {} #(
  parameter {} = {}
) (
  input logic clk,
  input logic rst_n
);

  logic [{}-1:0] {};
  {}

  modport master (
    input  clk, rst_n,
    output {}
  );

  modport slave (
    input  clk, rst_n,
    input  {}
  );

endinterface : {}
]], {
    f(function() return get_module_name() end),
    i(1, "WIDTH"),
    i(2, "8"),
    rep(1),
    i(3, "data"),
    i(4, "// signals"),
    rep(3),
    rep(3),
    f(function() return get_module_name() end),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Assertions                                                             │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("assert", fmt([[
{}: assert property (@(posedge {}) {})
  else $error("{}: Assertion failed!");
]], {
    i(1, "assert_name"),
    i(2, "clk"),
    i(3, "condition"),
    rep(1),
  })),

  s("asserti", fmt([[
{}: assert property (@(posedge {}) 
  {} |-> {}
) else $error("{}: {} did not follow {}!");
]], {
    i(1, "assert_name"),
    i(2, "clk"),
    i(3, "antecedent"),
    i(4, "consequent"),
    rep(1),
    rep(4),
    rep(3),
  })),

  s("cover", fmt([[
{}: cover property (@(posedge {}) {});
]], {
    i(1, "cover_name"),
    i(2, "clk"),
    i(3, "condition"),
  })),

  s("assume", fmt([[
{}: assume property (@(posedge {}) {});
]], {
    i(1, "assume_name"),
    i(2, "clk"),
    i(3, "condition"),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Testbench                                                              │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("tb", fmt([[
`timescale 1ns / 1ps

module {}_tb;

  // Parameters
  parameter CLK_PERIOD = 10;
  
  // Signals
  logic clk;
  logic rst_n;
  {}

  // DUT instantiation
  {} dut (
    .clk    (clk),
    .rst_n  (rst_n){}
  );

  // Clock generation
  initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // Reset generation
  task reset();
    rst_n = 1'b0;
    repeat(5) @(posedge clk);
    rst_n = 1'b1;
    @(posedge clk);
  endtask

  // Test sequence
  initial begin
    $display("Starting testbench...");
    
    // Initialize
    rst_n = 1'b0;
    {}
    
    // Reset
    reset();
    
    // Test cases
    {}
    
    // End simulation
    repeat(10) @(posedge clk);
    $display("Testbench completed!");
    $finish;
  end

  // Monitor
  initial begin
    $monitor("Time=%0t rst_n=%b {}", $time, rst_n{});
  end

endmodule : {}_tb
]], {
    f(function() return get_module_name():gsub("_tb$", "") end),
    i(1, "// signal declarations"),
    f(function() return get_module_name():gsub("_tb$", "") end),
    i(2, ""),
    i(3, "// signal init"),
    i(4, "// tests"),
    i(5, ""),
    i(6, ""),
    f(function() return get_module_name():gsub("_tb$", "") end),
  })),

  s("clkgen", fmt([[
// Clock generation
initial begin
  {} = 1'b0;
  forever #({}/2) {} = ~{};
end
]], {
    i(1, "clk"),
    i(2, "CLK_PERIOD"),
    rep(1),
    rep(1),
  })),

  s("task", fmt([[
task {}({});
  begin
    {}
  end
endtask : {}
]], {
    i(1, "task_name"),
    i(2, ""),
    i(3, "// body"),
    rep(1),
  })),

  s("func", fmt([[
function {} {}({});
  begin
    {}
  end
endfunction : {}
]], {
    i(1, "logic [7:0]"),
    i(2, "func_name"),
    i(3, "input logic [7:0] arg"),
    i(4, "// body"),
    rep(2),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Common Patterns                                                        │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("fifo", fmt([[
// FIFO logic
logic [{}-1:0] fifo_mem [0:{}-1];
logic [$clog2({})-1:0] wr_ptr, rd_ptr;
logic [$clog2({}):0] count;
logic full, empty;

assign full  = (count == {});
assign empty = (count == 0);

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    wr_ptr <= '0;
    rd_ptr <= '0;
    count  <= '0;
  end else begin
    // Write
    if ({} && !full) begin
      fifo_mem[wr_ptr] <= {};
      wr_ptr <= wr_ptr + 1;
    end
    // Read
    if ({} && !empty) begin
      rd_ptr <= rd_ptr + 1;
    end
    // Count update
    case ({{ {}, {} }})
      2'b10: count <= count + 1;
      2'b01: count <= count - 1;
      default: count <= count;
    endcase
  end
end

assign {} = fifo_mem[rd_ptr];
]], {
    i(1, "WIDTH"),
    i(2, "DEPTH"),
    rep(2),
    rep(2),
    rep(2),
    i(3, "wr_en"),
    i(4, "wr_data"),
    i(5, "rd_en"),
    rep(3),
    rep(5),
    i(6, "rd_data"),
  })),

  s("counter", fmt([[
// Counter
logic [{}-1:0] count_q;
logic count_en, count_clr;

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    count_q <= '0;
  end else if (count_clr) begin
    count_q <= '0;
  end else if (count_en) begin
    count_q <= count_q + 1'b1;
  end
end
]], {
    i(1, "WIDTH"),
  })),

  s("shiftreg", fmt([[
// Shift register
logic [{}-1:0] shift_q;

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    shift_q <= '0;
  end else if ({}) begin
    shift_q <= {{ shift_q[{}-2:0], {} }};
  end
end
]], {
    i(1, "WIDTH"),
    i(2, "shift_en"),
    rep(1),
    i(3, "shift_in"),
  })),

  -- ┌────────────────────────────────────────────────────────────────────────┐
  -- │ Comments and Headers                                                   │
  -- └────────────────────────────────────────────────────────────────────────┘
  
  s("header", fmt([[
//------------------------------------------------------------------------------
// Module:      {}
// Description: {}
// Author:      {}
// Date:        {}
//------------------------------------------------------------------------------
]], {
    f(function() return get_module_name() end),
    i(1, "Module description"),
    i(2, "Author Name"),
    f(function() return os.date("%Y-%m-%d") end),
  })),

  s("section", fmt([[
//------------------------------------------------------------------------------
// {}
//------------------------------------------------------------------------------
]], {
    i(1, "Section Name"),
  })),

  s("todo", t("// TODO: ")),
  s("fixme", t("// FIXME: ")),
  s("note", t("// NOTE: ")),
}

-- Register snippets for both verilog and systemverilog
ls.add_snippets("verilog", verilog_snippets)
ls.add_snippets("systemverilog", verilog_snippets)

return {}
