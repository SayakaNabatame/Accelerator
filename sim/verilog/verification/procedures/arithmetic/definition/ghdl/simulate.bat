@echo off
call ../../../../../../../settings64_ghdl.bat

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/pkg/accelerator_arithmetic_pkg.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/scalar/accelerator_scalar_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/scalar/accelerator_scalar_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/scalar/accelerator_scalar_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/vector/accelerator_vector_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/vector/accelerator_vector_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/vector/accelerator_vector_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/matrix/accelerator_matrix_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/matrix/accelerator_matrix_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/matrix/accelerator_matrix_float_divider.vhd

ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/tensor/accelerator_tensor_float_adder.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/tensor/accelerator_tensor_float_multiplier.vhd
ghdl -a --std=08 ../../../../../../../rtl/vhdl/code/math/definition/tensor/accelerator_tensor_float_divider.vhd

ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/math/float/accelerator_float_pkg.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/math/float/accelerator_float_stimulus.vhd
ghdl -a --std=08 ../../../../../../../bench/vhdl/code/baremetal/design/math/float/accelerator_float_testbench.vhd
ghdl -m --std=08 accelerator_float_testbench
ghdl -r --std=08 accelerator_float_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > accelerator_float_testbench.tree
pause
