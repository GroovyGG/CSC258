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

force {SW} 4b'0010
force {KEY} 4b'0000

force {KEY[0]} 0
run 5ns
force {KEY[0]} 1
run 5ns

force {KEY[0]} 0
run 5ns
force {KEY[0]} 1
run 5ns

force {KEY[3:1]} 3b'010
force {KEY[0]} 0
run 5ns
force {KEY[0]} 1
run 5ns

force {KEY[3:1]} 3b'110
force {KEY[0]} 0
run 5ns
force {KEY[0]} 1
run 5ns

