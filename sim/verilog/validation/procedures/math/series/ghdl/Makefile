all: build simulate

build:
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_arithmetic_verilog_pkg.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/pkg/model_math_verilog_pkg.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_adder.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_multiplier.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/scalar/model_scalar_float_divider.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_adder.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_multiplier.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/vector/model_vector_float_divider.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_adder.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_multiplier.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/float/matrix/model_matrix_float_divider.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_cosh_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_exponentiator_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_logarithm_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_sinh_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/scalar/model_scalar_tanh_function.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_cosh_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_exponentiator_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_logarithm_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_sinh_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/vector/model_vector_tanh_function.vhd

    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_cosh_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_exponentiator_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_logarithm_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_sinh_function.vhd
    ghdl -a --std=08 ../../../../../../../model/vhdl/code/math/series/matrix/model_matrix_tanh_function.vhd

    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/series/model_series_pkg.vhd
    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/series/model_series_stimulus.vhd
    ghdl -a --std=08 ../../../../../../../bench/vhdl/code/procedures/model/math/series/model_series_testbench.vhd

simulate:
	ghdl -m --std=08 model_series_testbench
	ghdl -r --std=08 model_series_testbench --ieee-asserts=disable-at-0 --disp-tree=inst > model_series_testbench.tree

clean:
	rm -f *.cf *.tree
