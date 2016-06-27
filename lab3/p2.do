# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog p2.v

# Load simulation using mux as the top level simulation module.
vsim p2

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {SW[9]} 1'b1
force {SW[3:0]} 4'b0010

force {KEY[0]} 0 0 ns, 1 50 ns -r 100

force {KEY[3:1]} 3'b000
run 100ns

force {KEY[3:1]} 3'b001
run 100ns

force {KEY[3:1]} 3'b010
run 100ns

force {KEY[3:1]} 3'b011
run 100ns

force {KEY[3:1]} 3'b100
run 100ns

force {KEY[3:1]} 3'b101
run 100ns

force {KEY[3:1]} 3'b110
run 100ns

force {KEY[3:1]} 3'b111
run 100ns