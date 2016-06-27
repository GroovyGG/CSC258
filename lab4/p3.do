# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog p3.v

# Load simulation using mux as the top level simulation module.
vsim p3

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {CLOCK_50} 0 0 ns, 1 1 ns -r 2

force {disp} 1
force {SW} 000
run 1ns
force {disp} 0
run 100ns

force {disp} 1
force {SW} 001
run 1ns
force {disp} 0
run 100ns

force {disp} 1
force {SW} 010
run 1ns
force {disp} 0
run 100ns

force {disp} 1
force {SW} 011
run 1ns
force {disp} 0
run 100ns

force {disp} 1
force {SW} 100
run 1ns
force {disp} 0
run 100ns

force {disp} 1
force {SW} 101
run 1ns
force {disp} 0
run 100ns

force {disp} 1
force {SW} 110
run 1ns
force {disp} 0
run 100ns

force {disp} 1
force {SW} 111
run 1ns
force {disp} 0
run 100ns
