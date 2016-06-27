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

force {CLOCK_50} 0 0 ns, 1 1 ns -r 2

force {SW} 2'b00
run 100ns

force {SW} 2'b01
run 200ns

force {SW} 2'b10
run 300ns

force {SW} 2'b11
run 400ns
