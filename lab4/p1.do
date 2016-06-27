# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog p1.v

# Load simulation using mux as the top level simulation module.
vsim p1

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {SW[1]} 1'b1
force {SW[0]} 1'b0
run 1ns
force {SW[0]} 1'b1

force {KEY[0]} 0 0 ns, 1 25 ns -r 50

run 2000ns
