# general
iverilog -o tests/3a src/phase2/proc_tb_3a.v
iverilog -o tests/3b src/phase2/proc_tb_3b.v
iverilog -o tests/3c src/phase2/proc_tb_3c.v
iverilog -o tests/3d src/phase2/proc_tb_3d.v
iverilog -o tests/3e src/phase2/proc_tb_3e.v
iverilog -o tests/3f src/phase2/proc_tb_3f.v
iverilog -o tests/3g src/phase2/proc_tb_3g.v

iverilog -o tests/register src/register_tb.v
iverilog -o tests/two_register src/two_register_tb.v
iverilog -o tests/busmux src/busmux_tb.v
iverilog -o tests/memdataregister src/memdataregister_tb.v

# ALU
iverilog -o tests/alu_ANDer src/alu/ANDer_tb.v
iverilog -o tests/alu_ORer src/alu/ORer_tb.v
iverilog -o tests/fulladder src/alu/fulladder_tb.v
iverilog -o tests/carrylookahead src/alu/carrylookahead_tb.v
iverilog -o tests/boothmult src/alu/boothmult_tb.v
iverilog -o tests/lookahead_cell src/alu/lookahead_cell_tb.v
iverilog -o tests/lookahead_generator src/alu/lookahead_generator_tb.v
iverilog -o tests/lookahead_generator_16 src/alu/lookahead_generator_16_tb.v
iverilog -o tests/division src/alu/division_tb.v
iverilog -o tests/adder_32 src/alu/adder_32_tb.v
iverilog -o tests/shift src/alu/shift_tb.v
iverilog -o tests/rotate src/alu/rotate_tb.v
iverilog -o tests/register64 src/register64_tb.v

# Phase 2
iverilog -o tests/ram src/ram_tb.v
iverilog -o tests/ir_decoder src/decode/ir_decoder_tb.v
iverilog -o tests/con_ff src/con_ff_tb.v
iverilog -o tests/selectAndEncode src/decode/selectAndEncode_tb.v


iverilog -o tests/alu src/alu/alu_tb.v

# Phase 3
iverilog -o tests/control_unit src/control_unit_tb.v
iverilog -o tests/phase_3 src/phase3_tb.v