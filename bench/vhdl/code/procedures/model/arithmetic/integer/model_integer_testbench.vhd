--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              Peripheral-NTM for MPSoC                                      --
--              Neural Turing Machine for MPSoC                               --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2020-2021 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.model_arithmetic_vhdl_pkg.all;
use work.model_integer_pkg.all;

entity model_integer_testbench is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE    : integer := 64;
    CONTROL_SIZE : integer := 4;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- i in 0 to R-1

    -- SCALAR-FUNCTIONALITY
    ENABLE_NTM_SCALAR_INTEGER_ADDER_TEST      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_SCALAR_INTEGER_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_SCALAR_INTEGER_DIVIDER_CASE_1    : boolean := false;

    -- VECTOR-FUNCTIONALITY
    ENABLE_NTM_VECTOR_INTEGER_ADDER_TEST      : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_VECTOR_INTEGER_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_VECTOR_INTEGER_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_VECTOR_INTEGER_DIVIDER_CASE_1    : boolean := false;

    -- MATRIX-FUNCTIONALITY
    ENABLE_NTM_MATRIX_INTEGER_ADDER_TEST      : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_MATRIX_INTEGER_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_MATRIX_INTEGER_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_MATRIX_INTEGER_DIVIDER_CASE_1    : boolean := false;

    -- TENSOR-FUNCTIONALITY
    ENABLE_NTM_TENSOR_INTEGER_ADDER_TEST      : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_MULTIPLIER_TEST : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_DIVIDER_TEST    : boolean := false;

    ENABLE_NTM_TENSOR_INTEGER_ADDER_CASE_0      : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_MULTIPLIER_CASE_0 : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_DIVIDER_CASE_0    : boolean := false;

    ENABLE_NTM_TENSOR_INTEGER_ADDER_CASE_1      : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_MULTIPLIER_CASE_1 : boolean := false;
    ENABLE_NTM_TENSOR_INTEGER_DIVIDER_CASE_1    : boolean := false
    );
end model_integer_testbench;

architecture model_integer_testbench_architecture of model_integer_testbench is

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------

  constant EMPTY : std_logic_vector(DATA_SIZE-1 downto 0) := (others => '0');

  constant CONTROL_X : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));
  constant CONTROL_Y : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));
  constant CONTROL_Z : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));
  constant CONTROL_L : std_logic_vector(CONTROL_SIZE-1 downto 0) := std_logic_vector(to_unsigned(CONTROL_SIZE, CONTROL_SIZE));

  -- SCALAR
  constant SCALAR_ADDER_OUTPUT_0 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_integer_adder('0', SCALAR_SAMPLE_A, SCALAR_SAMPLE_B);
  constant SCALAR_ADDER_OUTPUT_1 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_integer_adder('0', SCALAR_SAMPLE_B, SCALAR_SAMPLE_A);

  constant SCALAR_MULTIPLIER_OUTPUT_0 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_integer_multiplier(SCALAR_SAMPLE_A, SCALAR_SAMPLE_B);
  constant SCALAR_MULTIPLIER_OUTPUT_1 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_integer_multiplier(SCALAR_SAMPLE_B, SCALAR_SAMPLE_A);

  constant SCALAR_DIVIDER_OUTPUT_0 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_integer_divider(SCALAR_SAMPLE_A, SCALAR_SAMPLE_B);
  constant SCALAR_DIVIDER_OUTPUT_1 : std_logic_vector(DATA_SIZE-1 downto 0) := function_scalar_integer_divider(SCALAR_SAMPLE_B, SCALAR_SAMPLE_A);

  -- VECTOR
  constant VECTOR_ADDER_OUTPUT_0 : vector_buffer := function_vector_integer_adder('0', CONTROL_L, VECTOR_SAMPLE_A, VECTOR_SAMPLE_B);
  constant VECTOR_ADDER_OUTPUT_1 : vector_buffer := function_vector_integer_adder('0', CONTROL_L, VECTOR_SAMPLE_B, VECTOR_SAMPLE_A);

  constant VECTOR_MULTIPLIER_OUTPUT_0 : vector_buffer := function_vector_integer_multiplier(CONTROL_L, VECTOR_SAMPLE_A, VECTOR_SAMPLE_B);
  constant VECTOR_MULTIPLIER_OUTPUT_1 : vector_buffer := function_vector_integer_multiplier(CONTROL_L, VECTOR_SAMPLE_B, VECTOR_SAMPLE_A);

  constant VECTOR_DIVIDER_OUTPUT_0 : vector_buffer := function_vector_integer_divider(CONTROL_L, VECTOR_SAMPLE_A, VECTOR_SAMPLE_B);
  constant VECTOR_DIVIDER_OUTPUT_1 : vector_buffer := function_vector_integer_divider(CONTROL_L, VECTOR_SAMPLE_B, VECTOR_SAMPLE_A);

  -- MATRIX
  constant MATRIX_ADDER_OUTPUT_0 : matrix_buffer := function_matrix_integer_adder('0', CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A, MATRIX_SAMPLE_B);
  constant MATRIX_ADDER_OUTPUT_1 : matrix_buffer := function_matrix_integer_adder('0', CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B, MATRIX_SAMPLE_A);

  constant MATRIX_MULTIPLIER_OUTPUT_0 : matrix_buffer := function_matrix_integer_multiplier(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A, MATRIX_SAMPLE_B);
  constant MATRIX_MULTIPLIER_OUTPUT_1 : matrix_buffer := function_matrix_integer_multiplier(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B, MATRIX_SAMPLE_A);

  constant MATRIX_DIVIDER_OUTPUT_0 : matrix_buffer := function_matrix_integer_divider(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_A, MATRIX_SAMPLE_B);
  constant MATRIX_DIVIDER_OUTPUT_1 : matrix_buffer := function_matrix_integer_divider(CONTROL_X, CONTROL_Y, MATRIX_SAMPLE_B, MATRIX_SAMPLE_A);

  -- TENSOR
  constant TENSOR_ADDER_OUTPUT_0 : tensor_buffer := function_tensor_integer_adder('0', CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A, TENSOR_SAMPLE_B);
  constant TENSOR_ADDER_OUTPUT_1 : tensor_buffer := function_tensor_integer_adder('0', CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B, TENSOR_SAMPLE_A);

  constant TENSOR_MULTIPLIER_OUTPUT_0 : tensor_buffer := function_tensor_integer_multiplier(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A, TENSOR_SAMPLE_B);
  constant TENSOR_MULTIPLIER_OUTPUT_1 : tensor_buffer := function_tensor_integer_multiplier(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B, TENSOR_SAMPLE_A);

  constant TENSOR_DIVIDER_OUTPUT_0 : tensor_buffer := function_tensor_integer_divider(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_A, TENSOR_SAMPLE_B);
  constant TENSOR_DIVIDER_OUTPUT_1 : tensor_buffer := function_tensor_integer_divider(CONTROL_X, CONTROL_Y, CONTROL_Z, TENSOR_SAMPLE_B, TENSOR_SAMPLE_A);

  ------------------------------------------------------------------------------
  -- Signals
  ------------------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_integer_adder : std_logic;
  signal ready_scalar_integer_adder : std_logic;

  signal operation_scalar_integer_adder : std_logic;

  -- DATA
  signal data_a_in_scalar_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_integer_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_integer_adder : std_logic;

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_integer_multiplier : std_logic;
  signal ready_scalar_integer_multiplier : std_logic;

  -- DATA
  signal data_a_in_scalar_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_integer_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_scalar_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR DIVIDER
  -- CONTROL
  signal start_scalar_integer_divider : std_logic;
  signal ready_scalar_integer_divider : std_logic;

  -- DATA
  signal data_a_in_scalar_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_scalar_integer_divider      : std_logic_vector(DATA_SIZE-1 downto 0);
  signal remainder_out_scalar_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_integer_adder : std_logic;
  signal ready_vector_integer_adder : std_logic;

  signal operation_vector_integer_adder : std_logic;

  signal data_a_in_enable_vector_integer_adder : std_logic;
  signal data_b_in_enable_vector_integer_adder : std_logic;

  signal data_out_enable_vector_integer_adder : std_logic;

  -- DATA
  signal size_in_vector_integer_adder   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_integer_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_integer_adder : std_logic;

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_integer_multiplier : std_logic;
  signal ready_vector_integer_multiplier : std_logic;

  signal data_a_in_enable_vector_integer_multiplier : std_logic;
  signal data_b_in_enable_vector_integer_multiplier : std_logic;

  signal data_out_enable_vector_integer_multiplier : std_logic;

  -- DATA
  signal size_in_vector_integer_multiplier   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_integer_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_vector_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR DIVIDER
  -- CONTROL
  signal start_vector_integer_divider : std_logic;
  signal ready_vector_integer_divider : std_logic;

  signal data_a_in_enable_vector_integer_divider : std_logic;
  signal data_b_in_enable_vector_integer_divider : std_logic;

  signal data_out_enable_vector_integer_divider : std_logic;

  -- DATA
  signal size_in_vector_integer_divider   : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_vector_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_vector_integer_divider      : std_logic_vector(DATA_SIZE-1 downto 0);
  signal remainder_out_vector_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX ADDER
  -- CONTROL
  signal start_matrix_integer_adder : std_logic;
  signal ready_matrix_integer_adder : std_logic;

  signal operation_matrix_integer_adder : std_logic;

  signal data_a_in_i_enable_matrix_integer_adder : std_logic;
  signal data_a_in_j_enable_matrix_integer_adder : std_logic;
  signal data_b_in_i_enable_matrix_integer_adder : std_logic;
  signal data_b_in_j_enable_matrix_integer_adder : std_logic;

  signal data_out_i_enable_matrix_integer_adder : std_logic;
  signal data_out_j_enable_matrix_integer_adder : std_logic;

  -- DATA
  signal size_i_in_matrix_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_integer_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_integer_adder : std_logic;

  -- MATRIX MULTIPLIER
  -- CONTROL
  signal start_matrix_integer_multiplier : std_logic;
  signal ready_matrix_integer_multiplier : std_logic;

  signal data_a_in_i_enable_matrix_integer_multiplier : std_logic;
  signal data_a_in_j_enable_matrix_integer_multiplier : std_logic;
  signal data_b_in_i_enable_matrix_integer_multiplier : std_logic;
  signal data_b_in_j_enable_matrix_integer_multiplier : std_logic;

  signal data_out_i_enable_matrix_integer_multiplier : std_logic;
  signal data_out_j_enable_matrix_integer_multiplier : std_logic;

  -- DATA
  signal size_i_in_matrix_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_integer_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_matrix_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX DIVIDER
  -- CONTROL
  signal start_matrix_integer_divider : std_logic;
  signal ready_matrix_integer_divider : std_logic;

  signal data_a_in_i_enable_matrix_integer_divider : std_logic;
  signal data_a_in_j_enable_matrix_integer_divider : std_logic;
  signal data_b_in_i_enable_matrix_integer_divider : std_logic;
  signal data_b_in_j_enable_matrix_integer_divider : std_logic;

  signal data_out_i_enable_matrix_integer_divider : std_logic;
  signal data_out_j_enable_matrix_integer_divider : std_logic;

  -- DATA
  signal size_i_in_matrix_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_matrix_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_matrix_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_matrix_integer_divider      : std_logic_vector(DATA_SIZE-1 downto 0);
  signal remainder_out_matrix_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR ADDER
  -- CONTROL
  signal start_tensor_integer_adder : std_logic;
  signal ready_tensor_integer_adder : std_logic;

  signal operation_tensor_integer_adder : std_logic;

  signal data_a_in_i_enable_tensor_integer_adder : std_logic;
  signal data_a_in_j_enable_tensor_integer_adder : std_logic;
  signal data_a_in_k_enable_tensor_integer_adder : std_logic;
  signal data_b_in_i_enable_tensor_integer_adder : std_logic;
  signal data_b_in_j_enable_tensor_integer_adder : std_logic;
  signal data_b_in_k_enable_tensor_integer_adder : std_logic;

  signal data_out_i_enable_tensor_integer_adder : std_logic;
  signal data_out_j_enable_tensor_integer_adder : std_logic;
  signal data_out_k_enable_tensor_integer_adder : std_logic;

  -- DATA
  signal size_i_in_tensor_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_integer_adder : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_integer_adder : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_integer_adder     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_integer_adder : std_logic;

  -- TENSOR MULTIPLIER
  -- CONTROL
  signal start_tensor_integer_multiplier : std_logic;
  signal ready_tensor_integer_multiplier : std_logic;

  signal data_a_in_i_enable_tensor_integer_multiplier : std_logic;
  signal data_a_in_j_enable_tensor_integer_multiplier : std_logic;
  signal data_a_in_k_enable_tensor_integer_multiplier : std_logic;
  signal data_b_in_i_enable_tensor_integer_multiplier : std_logic;
  signal data_b_in_j_enable_tensor_integer_multiplier : std_logic;
  signal data_b_in_k_enable_tensor_integer_multiplier : std_logic;

  signal data_out_i_enable_tensor_integer_multiplier : std_logic;
  signal data_out_j_enable_tensor_integer_multiplier : std_logic;
  signal data_out_k_enable_tensor_integer_multiplier : std_logic;

  -- DATA
  signal size_i_in_tensor_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_integer_multiplier : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_integer_multiplier     : std_logic_vector(DATA_SIZE-1 downto 0);
  signal overflow_out_tensor_integer_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);

  -- TENSOR DIVIDER
  -- CONTROL
  signal start_tensor_integer_divider : std_logic;
  signal ready_tensor_integer_divider : std_logic;

  signal data_a_in_i_enable_tensor_integer_divider : std_logic;
  signal data_a_in_j_enable_tensor_integer_divider : std_logic;
  signal data_a_in_k_enable_tensor_integer_divider : std_logic;
  signal data_b_in_i_enable_tensor_integer_divider : std_logic;
  signal data_b_in_j_enable_tensor_integer_divider : std_logic;
  signal data_b_in_k_enable_tensor_integer_divider : std_logic;

  signal data_out_i_enable_tensor_integer_divider : std_logic;
  signal data_out_j_enable_tensor_integer_divider : std_logic;
  signal data_out_k_enable_tensor_integer_divider : std_logic;

  -- DATA
  signal size_i_in_tensor_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_j_in_tensor_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal size_k_in_tensor_integer_divider : std_logic_vector(CONTROL_SIZE-1 downto 0);
  signal data_a_in_tensor_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_tensor_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

  signal data_out_tensor_integer_divider      : std_logic_vector(DATA_SIZE-1 downto 0);
  signal remainder_out_tensor_integer_divider : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Body
  ------------------------------------------------------------------------------

  integer_stimulus : model_integer_stimulus
    generic map (
      -- SYSTEM-SIZE
      DATA_SIZE    => DATA_SIZE,
      CONTROL_SIZE => CONTROL_SIZE,

      X => X,
      Y => Y,
      N => N,
      W => W,
      L => L,
      R => R
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      ------------------------------------------------------------------------------
      -- STIMULUS SCALAR
      ------------------------------------------------------------------------------

      -- SCALAR ADDER
      -- CONTROL
      SCALAR_INTEGER_ADDER_START => start_scalar_integer_adder,
      SCALAR_INTEGER_ADDER_READY => ready_scalar_integer_adder,

      SCALAR_INTEGER_ADDER_OPERATION => operation_scalar_integer_adder,

      -- DATA
      SCALAR_INTEGER_ADDER_DATA_A_IN => data_a_in_scalar_integer_adder,
      SCALAR_INTEGER_ADDER_DATA_B_IN => data_b_in_scalar_integer_adder,

      SCALAR_INTEGER_ADDER_DATA_OUT     => data_out_scalar_integer_adder,
      SCALAR_INTEGER_ADDER_OVERFLOW_OUT => overflow_out_scalar_integer_adder,

      -- SCALAR MULTIPLIER
      -- CONTROL
      SCALAR_INTEGER_MULTIPLIER_START => start_scalar_integer_multiplier,
      SCALAR_INTEGER_MULTIPLIER_READY => ready_scalar_integer_multiplier,

      -- DATA
      SCALAR_INTEGER_MULTIPLIER_DATA_A_IN => data_a_in_scalar_integer_multiplier,
      SCALAR_INTEGER_MULTIPLIER_DATA_B_IN => data_b_in_scalar_integer_multiplier,

      SCALAR_INTEGER_MULTIPLIER_DATA_OUT     => data_out_scalar_integer_multiplier,
      SCALAR_INTEGER_MULTIPLIER_OVERFLOW_OUT => overflow_out_scalar_integer_multiplier,

      -- SCALAR DIVIDER
      -- CONTROL
      SCALAR_INTEGER_DIVIDER_START => start_scalar_integer_divider,
      SCALAR_INTEGER_DIVIDER_READY => ready_scalar_integer_divider,

      -- DATA
      SCALAR_INTEGER_DIVIDER_DATA_A_IN => data_a_in_scalar_integer_divider,
      SCALAR_INTEGER_DIVIDER_DATA_B_IN => data_b_in_scalar_integer_divider,

      SCALAR_INTEGER_DIVIDER_DATA_OUT      => data_out_scalar_integer_divider,
      SCALAR_INTEGER_DIVIDER_REMAINDER_OUT => remainder_out_scalar_integer_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS VECTOR
      ------------------------------------------------------------------------------

      -- VECTOR ADDER
      -- CONTROL
      VECTOR_INTEGER_ADDER_START => start_vector_integer_adder,
      VECTOR_INTEGER_ADDER_READY => ready_vector_integer_adder,

      VECTOR_INTEGER_ADDER_OPERATION => operation_vector_integer_adder,

      VECTOR_INTEGER_ADDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_adder,
      VECTOR_INTEGER_ADDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_adder,

      VECTOR_INTEGER_ADDER_DATA_OUT_ENABLE => data_out_enable_vector_integer_adder,

      -- DATA
      VECTOR_INTEGER_ADDER_SIZE_IN   => size_in_vector_integer_adder,
      VECTOR_INTEGER_ADDER_DATA_A_IN => data_a_in_vector_integer_adder,
      VECTOR_INTEGER_ADDER_DATA_B_IN => data_b_in_vector_integer_adder,

      VECTOR_INTEGER_ADDER_DATA_OUT     => data_out_vector_integer_adder,
      VECTOR_INTEGER_ADDER_OVERFLOW_OUT => overflow_out_vector_integer_adder,

      -- VECTOR MULTIPLIER
      -- CONTROL
      VECTOR_INTEGER_MULTIPLIER_START => start_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_READY => ready_vector_integer_multiplier,

      VECTOR_INTEGER_MULTIPLIER_DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_multiplier,

      VECTOR_INTEGER_MULTIPLIER_DATA_OUT_ENABLE => data_out_enable_vector_integer_multiplier,

      -- DATA
      VECTOR_INTEGER_MULTIPLIER_SIZE_IN   => size_in_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_DATA_A_IN => data_a_in_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_DATA_B_IN => data_b_in_vector_integer_multiplier,

      VECTOR_INTEGER_MULTIPLIER_DATA_OUT     => data_out_vector_integer_multiplier,
      VECTOR_INTEGER_MULTIPLIER_OVERFLOW_OUT => overflow_out_vector_integer_multiplier,

      -- VECTOR DIVIDER
      -- CONTROL
      VECTOR_INTEGER_DIVIDER_START => start_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_READY => ready_vector_integer_divider,

      VECTOR_INTEGER_DIVIDER_DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_divider,

      VECTOR_INTEGER_DIVIDER_DATA_OUT_ENABLE => data_out_enable_vector_integer_divider,

      -- DATA
      VECTOR_INTEGER_DIVIDER_SIZE_IN   => size_in_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_DATA_A_IN => data_a_in_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_DATA_B_IN => data_b_in_vector_integer_divider,

      VECTOR_INTEGER_DIVIDER_DATA_OUT      => data_out_vector_integer_divider,
      VECTOR_INTEGER_DIVIDER_REMAINDER_OUT => remainder_out_vector_integer_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS MATRIX
      ------------------------------------------------------------------------------

      -- MATRIX ADDER
      -- CONTROL
      MATRIX_INTEGER_ADDER_START => start_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_READY => ready_matrix_integer_adder,

      MATRIX_INTEGER_ADDER_OPERATION => operation_matrix_integer_adder,

      MATRIX_INTEGER_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_adder,

      MATRIX_INTEGER_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_adder,

      -- DATA
      MATRIX_INTEGER_ADDER_SIZE_I_IN => size_i_in_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_SIZE_J_IN => size_j_in_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_A_IN => data_a_in_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_DATA_B_IN => data_b_in_matrix_integer_adder,

      MATRIX_INTEGER_ADDER_DATA_OUT     => data_out_matrix_integer_adder,
      MATRIX_INTEGER_ADDER_OVERFLOW_OUT => overflow_out_matrix_integer_adder,

      -- MATRIX MULTIPLIER
      -- CONTROL
      MATRIX_INTEGER_MULTIPLIER_START => start_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_READY => ready_matrix_integer_multiplier,

      MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_multiplier,

      MATRIX_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_multiplier,

      -- DATA
      MATRIX_INTEGER_MULTIPLIER_SIZE_I_IN => size_i_in_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_SIZE_J_IN => size_j_in_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_A_IN => data_a_in_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_DATA_B_IN => data_b_in_matrix_integer_multiplier,

      MATRIX_INTEGER_MULTIPLIER_DATA_OUT     => data_out_matrix_integer_multiplier,
      MATRIX_INTEGER_MULTIPLIER_OVERFLOW_OUT => overflow_out_matrix_integer_multiplier,

      -- MATRIX DIVIDER
      -- CONTROL
      MATRIX_INTEGER_DIVIDER_START => start_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_READY => ready_matrix_integer_divider,

      MATRIX_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_divider,

      MATRIX_INTEGER_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_divider,

      -- DATA
      MATRIX_INTEGER_DIVIDER_SIZE_I_IN => size_i_in_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_SIZE_J_IN => size_j_in_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_A_IN => data_a_in_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_DATA_B_IN => data_b_in_matrix_integer_divider,

      MATRIX_INTEGER_DIVIDER_DATA_OUT      => data_out_matrix_integer_divider,
      MATRIX_INTEGER_DIVIDER_REMAINDER_OUT => remainder_out_matrix_integer_divider,

      ------------------------------------------------------------------------------
      -- STIMULUS TENSOR
      ------------------------------------------------------------------------------

      -- TENSOR ADDER
      -- CONTROL
      TENSOR_INTEGER_ADDER_START => start_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_READY => ready_tensor_integer_adder,

      TENSOR_INTEGER_ADDER_OPERATION => operation_tensor_integer_adder,

      TENSOR_INTEGER_ADDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_adder,

      TENSOR_INTEGER_ADDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_adder,

      -- DATA
      TENSOR_INTEGER_ADDER_SIZE_I_IN => size_i_in_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_SIZE_J_IN => size_j_in_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_SIZE_K_IN => size_k_in_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_A_IN => data_a_in_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_DATA_B_IN => data_b_in_tensor_integer_adder,

      TENSOR_INTEGER_ADDER_DATA_OUT     => data_out_tensor_integer_adder,
      TENSOR_INTEGER_ADDER_OVERFLOW_OUT => overflow_out_tensor_integer_adder,

      -- TENSOR MULTIPLIER
      -- CONTROL
      TENSOR_INTEGER_MULTIPLIER_START => start_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_READY => ready_tensor_integer_multiplier,

      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_multiplier,

      TENSOR_INTEGER_MULTIPLIER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_multiplier,

      -- DATA
      TENSOR_INTEGER_MULTIPLIER_SIZE_I_IN => size_i_in_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_SIZE_J_IN => size_j_in_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_SIZE_K_IN => size_k_in_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_A_IN => data_a_in_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_DATA_B_IN => data_b_in_tensor_integer_multiplier,

      TENSOR_INTEGER_MULTIPLIER_DATA_OUT     => data_out_tensor_integer_multiplier,
      TENSOR_INTEGER_MULTIPLIER_OVERFLOW_OUT => overflow_out_tensor_integer_multiplier,

      -- TENSOR DIVIDER
      -- CONTROL
      TENSOR_INTEGER_DIVIDER_START => start_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_READY => ready_tensor_integer_divider,

      TENSOR_INTEGER_DIVIDER_DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_divider,

      TENSOR_INTEGER_DIVIDER_DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_divider,

      -- DATA
      TENSOR_INTEGER_DIVIDER_SIZE_I_IN => size_i_in_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_SIZE_J_IN => size_j_in_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_SIZE_K_IN => size_k_in_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_A_IN => data_a_in_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_DATA_B_IN => data_b_in_tensor_integer_divider,

      TENSOR_INTEGER_DIVIDER_DATA_OUT      => data_out_tensor_integer_divider,
      TENSOR_INTEGER_DIVIDER_REMAINDER_OUT => remainder_out_tensor_integer_divider
      );

  ------------------------------------------------------------------------------
  -- SCALAR
  ------------------------------------------------------------------------------

  -- SCALAR ADDER
  model_scalar_integer_adder_test : if (ENABLE_NTM_SCALAR_INTEGER_ADDER_TEST) generate
    scalar_integer_adder : model_scalar_integer_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_integer_adder,
        READY => ready_scalar_integer_adder,

        OPERATION => operation_scalar_integer_adder,

        -- DATA
        DATA_A_IN => data_a_in_scalar_integer_adder,
        DATA_B_IN => data_b_in_scalar_integer_adder,

        DATA_OUT     => data_out_scalar_integer_adder,
        OVERFLOW_OUT => overflow_out_scalar_integer_adder
        );
  end generate model_scalar_integer_adder_test;

  -- SCALAR MULTIPLIER
  model_scalar_integer_multiplier_test : if (ENABLE_NTM_SCALAR_INTEGER_MULTIPLIER_TEST) generate
    scalar_integer_multiplier : model_scalar_integer_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_integer_multiplier,
        READY => ready_scalar_integer_multiplier,

        -- DATA
        DATA_A_IN => data_a_in_scalar_integer_multiplier,
        DATA_B_IN => data_b_in_scalar_integer_multiplier,

        DATA_OUT     => data_out_scalar_integer_multiplier,
        OVERFLOW_OUT => overflow_out_scalar_integer_multiplier
        );
  end generate model_scalar_integer_multiplier_test;

  -- SCALAR DIVIDER
  model_scalar_integer_divider_test : if (ENABLE_NTM_SCALAR_INTEGER_DIVIDER_TEST) generate
    scalar_integer_divider : model_scalar_integer_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_scalar_integer_divider,
        READY => ready_scalar_integer_divider,

        -- DATA
        DATA_A_IN => data_a_in_scalar_integer_divider,
        DATA_B_IN => data_b_in_scalar_integer_divider,

        DATA_OUT      => data_out_scalar_integer_divider,
        REMAINDER_OUT => remainder_out_scalar_integer_divider
        );
  end generate model_scalar_integer_divider_test;

  scalar_assertion : process (CLK, RST)
  begin
    if rising_edge(CLK) then
      if (ready_scalar_integer_adder = '1') then
        assert data_out_scalar_integer_adder = SCALAR_ADDER_OUTPUT_0
          report "SCALAR ADDER: CALCULATED = " & to_string(data_out_scalar_integer_adder) & "; CORRECT = " & to_string(SCALAR_ADDER_OUTPUT_0)
          severity error;
      end if;

      if (ready_scalar_integer_multiplier = '1') then
        assert data_out_scalar_integer_multiplier = SCALAR_MULTIPLIER_OUTPUT_0
          report "SCALAR MULTIPLIER: CALCULATED = " & to_string(data_out_scalar_integer_multiplier) & "; CORRECT = " & to_string(SCALAR_MULTIPLIER_OUTPUT_0)
          severity error;
      end if;

      if (ready_scalar_integer_divider = '1') then
        assert data_out_scalar_integer_divider = SCALAR_DIVIDER_OUTPUT_0
          report "SCALAR DIVIDER: CALCULATED = " & to_string(data_out_scalar_integer_divider) & "; CORRECT = " & to_string(SCALAR_DIVIDER_OUTPUT_0)
          severity error;
      end if;
    end if;
  end process scalar_assertion;

  ------------------------------------------------------------------------------
  -- VECTOR
  ------------------------------------------------------------------------------

  -- VECTOR ADDER
  model_vector_integer_adder_test : if (ENABLE_NTM_VECTOR_INTEGER_ADDER_TEST) generate
    vector_integer_adder : model_vector_integer_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_integer_adder,
        READY => ready_vector_integer_adder,

        OPERATION => operation_vector_integer_adder,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_adder,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_adder,

        DATA_OUT_ENABLE => data_out_enable_vector_integer_adder,

        -- DATA
        SIZE_IN   => size_in_vector_integer_adder,
        DATA_A_IN => data_a_in_vector_integer_adder,
        DATA_B_IN => data_b_in_vector_integer_adder,

        DATA_OUT     => data_out_vector_integer_adder,
        OVERFLOW_OUT => overflow_out_vector_integer_adder
        );
  end generate model_vector_integer_adder_test;

  -- VECTOR MULTIPLIER
  model_vector_integer_multiplier_test : if (ENABLE_NTM_VECTOR_INTEGER_MULTIPLIER_TEST) generate
    vector_integer_multiplier : model_vector_integer_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_integer_multiplier,
        READY => ready_vector_integer_multiplier,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_multiplier,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_multiplier,

        DATA_OUT_ENABLE => data_out_enable_vector_integer_multiplier,

        -- DATA
        SIZE_IN   => size_in_vector_integer_multiplier,
        DATA_A_IN => data_a_in_vector_integer_multiplier,
        DATA_B_IN => data_b_in_vector_integer_multiplier,

        DATA_OUT     => data_out_vector_integer_multiplier,
        OVERFLOW_OUT => overflow_out_vector_integer_multiplier
        );
  end generate model_vector_integer_multiplier_test;

  -- VECTOR DIVIDER
  model_vector_integer_divider_test : if (ENABLE_NTM_VECTOR_INTEGER_DIVIDER_TEST) generate
    vector_integer_divider : model_vector_integer_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_vector_integer_divider,
        READY => ready_vector_integer_divider,

        DATA_A_IN_ENABLE => data_a_in_enable_vector_integer_divider,
        DATA_B_IN_ENABLE => data_b_in_enable_vector_integer_divider,

        DATA_OUT_ENABLE => data_out_enable_vector_integer_divider,

        -- DATA
        SIZE_IN   => size_in_vector_integer_divider,
        DATA_A_IN => data_a_in_vector_integer_divider,
        DATA_B_IN => data_b_in_vector_integer_divider,

        DATA_OUT      => data_out_vector_integer_divider,
        REMAINDER_OUT => remainder_out_vector_integer_divider
        );
  end generate model_vector_integer_divider_test;

  vector_assertion : process (CLK, RST)
    variable i : integer := 0;
  begin
    if rising_edge(CLK) then
      if (ready_vector_integer_adder = '1' and data_out_enable_vector_integer_adder = '1') then
        assert data_out_vector_integer_adder = VECTOR_ADDER_OUTPUT_0(i)
          report "VECTOR ADDER: CALCULATED = " & to_string(data_out_vector_integer_adder) & "; CORRECT = " & to_string(VECTOR_ADDER_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_integer_adder = '1' and not data_out_vector_integer_adder = ZERO_DATA) then
        assert data_out_vector_integer_adder = VECTOR_ADDER_OUTPUT_0(i)
          report "VECTOR ADDER: CALCULATED = " & to_string(data_out_vector_integer_adder) & "; CORRECT = " & to_string(VECTOR_ADDER_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_vector_integer_multiplier = '1' and data_out_enable_vector_integer_multiplier = '1') then
        assert data_out_vector_integer_multiplier = VECTOR_MULTIPLIER_OUTPUT_0(i)
          report "VECTOR MULTIPLIER: CALCULATED = " & to_string(data_out_vector_integer_multiplier) & "; CORRECT = " & to_string(VECTOR_MULTIPLIER_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_integer_multiplier = '1' and not data_out_vector_integer_multiplier = ZERO_DATA) then
        assert data_out_vector_integer_multiplier = VECTOR_MULTIPLIER_OUTPUT_0(i)
          report "VECTOR MULTIPLIER: CALCULATED = " & to_string(data_out_vector_integer_multiplier) & "; CORRECT = " & to_string(VECTOR_MULTIPLIER_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;

      if (ready_vector_integer_divider = '1' and data_out_enable_vector_integer_divider = '1') then
        assert data_out_vector_integer_divider = VECTOR_DIVIDER_OUTPUT_0(i)
          report "VECTOR DIVIDER: CALCULATED = " & to_string(data_out_vector_integer_divider) & "; CORRECT = " & to_string(VECTOR_DIVIDER_OUTPUT_0(i))
          severity error;

        i := 0;
      elsif (data_out_enable_vector_integer_divider = '1' and not data_out_vector_integer_divider = ZERO_DATA) then
        assert data_out_vector_integer_divider = VECTOR_DIVIDER_OUTPUT_0(i)
          report "VECTOR DIVIDER: CALCULATED = " & to_string(data_out_vector_integer_divider) & "; CORRECT = " & to_string(VECTOR_DIVIDER_OUTPUT_0(i))
          severity error;

        i := i + 1;
      end if;
    end if;
  end process vector_assertion;

  ------------------------------------------------------------------------------
  -- MATRIX
  ------------------------------------------------------------------------------

  -- MATRIX ADDER
  model_matrix_integer_adder_test : if (ENABLE_NTM_MATRIX_INTEGER_ADDER_TEST) generate
    matrix_integer_adder : model_matrix_integer_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_integer_adder,
        READY => ready_matrix_integer_adder,

        OPERATION => operation_matrix_integer_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_adder,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_integer_adder,
        SIZE_J_IN => size_j_in_matrix_integer_adder,
        DATA_A_IN => data_a_in_matrix_integer_adder,
        DATA_B_IN => data_b_in_matrix_integer_adder,

        DATA_OUT     => data_out_matrix_integer_adder,
        OVERFLOW_OUT => overflow_out_matrix_integer_adder
        );
  end generate model_matrix_integer_adder_test;

  -- MATRIX MULTIPLIER
  model_matrix_integer_multiplier_test : if (ENABLE_NTM_MATRIX_INTEGER_MULTIPLIER_TEST) generate
    matrix_integer_multiplier : model_matrix_integer_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_integer_multiplier,
        READY => ready_matrix_integer_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_integer_multiplier,
        SIZE_J_IN => size_j_in_matrix_integer_multiplier,
        DATA_A_IN => data_a_in_matrix_integer_multiplier,
        DATA_B_IN => data_b_in_matrix_integer_multiplier,

        DATA_OUT     => data_out_matrix_integer_multiplier,
        OVERFLOW_OUT => overflow_out_matrix_integer_multiplier
        );
  end generate model_matrix_integer_multiplier_test;

  -- MATRIX DIVIDER
  model_matrix_integer_divider_test : if (ENABLE_NTM_MATRIX_INTEGER_DIVIDER_TEST) generate
    matrix_integer_divider : model_matrix_integer_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_matrix_integer_divider,
        READY => ready_matrix_integer_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_integer_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_integer_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_integer_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_integer_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_matrix_integer_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_matrix_integer_divider,

        -- DATA
        SIZE_I_IN => size_i_in_matrix_integer_divider,
        SIZE_J_IN => size_j_in_matrix_integer_divider,
        DATA_A_IN => data_a_in_matrix_integer_divider,
        DATA_B_IN => data_b_in_matrix_integer_divider,

        DATA_OUT      => data_out_matrix_integer_divider,
        REMAINDER_OUT => remainder_out_matrix_integer_divider
        );
  end generate model_matrix_integer_divider_test;

  matrix_assertion : process (CLK, RST)
    variable i : integer := 0;
    variable j : integer := 0;
  begin
    if rising_edge(CLK) then
      if (ready_matrix_integer_adder = '1' and data_out_i_enable_matrix_integer_adder = '1' and data_out_j_enable_matrix_integer_adder = '1') then
        assert data_out_matrix_integer_adder = MATRIX_ADDER_OUTPUT_0(i, j)
          report "MATRIX ADDER: CALCULATED = " & to_string(data_out_matrix_integer_adder) & "; CORRECT = " & to_string(MATRIX_ADDER_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_integer_adder = '1' and data_out_j_enable_matrix_integer_adder = '1' and not data_out_matrix_integer_adder = ZERO_DATA) then
        assert data_out_matrix_integer_adder = MATRIX_ADDER_OUTPUT_0(i, j)
          report "MATRIX ADDER: CALCULATED = " & to_string(data_out_matrix_integer_adder) & "; CORRECT = " & to_string(MATRIX_ADDER_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_integer_adder = '1' and not data_out_matrix_integer_adder = ZERO_DATA) then
        assert data_out_matrix_integer_adder = MATRIX_ADDER_OUTPUT_0(i, j)
          report "MATRIX ADDER: CALCULATED = " & to_string(data_out_matrix_integer_adder) & "; CORRECT = " & to_string(MATRIX_ADDER_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_matrix_integer_multiplier = '1' and data_out_i_enable_matrix_integer_multiplier = '1' and data_out_j_enable_matrix_integer_multiplier = '1') then
        assert data_out_matrix_integer_multiplier = MATRIX_MULTIPLIER_OUTPUT_0(i, j)
          report "MATRIX MULTIPLIER: CALCULATED = " & to_string(data_out_matrix_integer_multiplier) & "; CORRECT = " & to_string(MATRIX_MULTIPLIER_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_integer_multiplier = '1' and data_out_j_enable_matrix_integer_multiplier = '1' and not data_out_matrix_integer_multiplier = ZERO_DATA) then
        assert data_out_matrix_integer_multiplier = MATRIX_MULTIPLIER_OUTPUT_0(i, j)
          report "MATRIX MULTIPLIER: CALCULATED = " & to_string(data_out_matrix_integer_multiplier) & "; CORRECT = " & to_string(MATRIX_MULTIPLIER_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_integer_multiplier = '1' and not data_out_matrix_integer_multiplier = ZERO_DATA) then
        assert data_out_matrix_integer_multiplier = MATRIX_MULTIPLIER_OUTPUT_0(i, j)
          report "MATRIX MULTIPLIER: CALCULATED = " & to_string(data_out_matrix_integer_multiplier) & "; CORRECT = " & to_string(MATRIX_MULTIPLIER_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;

      if (ready_matrix_integer_divider = '1' and data_out_i_enable_matrix_integer_divider = '1' and data_out_j_enable_matrix_integer_divider = '1') then
        assert data_out_matrix_integer_divider = MATRIX_DIVIDER_OUTPUT_0(i, j)
          report "MATRIX DIVIDER: CALCULATED = " & to_string(data_out_matrix_integer_divider) & "; CORRECT = " & to_string(MATRIX_DIVIDER_OUTPUT_0(i, j))
          severity error;

        i := 0;
        j := 0;
      elsif (data_out_i_enable_matrix_integer_divider = '1' and data_out_j_enable_matrix_integer_divider = '1' and not data_out_matrix_integer_divider = ZERO_DATA) then
        assert data_out_matrix_integer_divider = MATRIX_DIVIDER_OUTPUT_0(i, j)
          report "MATRIX DIVIDER: CALCULATED = " & to_string(data_out_matrix_integer_divider) & "; CORRECT = " & to_string(MATRIX_DIVIDER_OUTPUT_0(i, j))
          severity error;

        i := i + 1;
        j := 0;
      elsif (data_out_j_enable_matrix_integer_divider = '1' and not data_out_matrix_integer_divider = ZERO_DATA) then
        assert data_out_matrix_integer_divider = MATRIX_DIVIDER_OUTPUT_0(i, j)
          report "MATRIX DIVIDER: CALCULATED = " & to_string(data_out_matrix_integer_divider) & "; CORRECT = " & to_string(MATRIX_DIVIDER_OUTPUT_0(i, j))
          severity error;

        j := j + 1;
      end if;
    end if;
  end process matrix_assertion;

  ------------------------------------------------------------------------------
  -- TENSOR
  ------------------------------------------------------------------------------

  -- TENSOR ADDER
  model_tensor_integer_adder_test : if (ENABLE_NTM_TENSOR_INTEGER_ADDER_TEST) generate
    tensor_integer_adder : model_tensor_integer_adder
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_integer_adder,
        READY => ready_tensor_integer_adder,

        OPERATION => operation_tensor_integer_adder,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_adder,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_adder,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_adder,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_adder,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_adder,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_adder,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_adder,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_adder,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_adder,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_integer_adder,
        SIZE_J_IN => size_j_in_tensor_integer_adder,
        SIZE_K_IN => size_k_in_tensor_integer_adder,
        DATA_A_IN => data_a_in_tensor_integer_adder,
        DATA_B_IN => data_b_in_tensor_integer_adder,

        DATA_OUT     => data_out_tensor_integer_adder,
        OVERFLOW_OUT => overflow_out_tensor_integer_adder
        );
  end generate model_tensor_integer_adder_test;

  -- TENSOR MULTIPLIER
  model_tensor_integer_multiplier_test : if (ENABLE_NTM_TENSOR_INTEGER_MULTIPLIER_TEST) generate
    tensor_integer_multiplier : model_tensor_integer_multiplier
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_integer_multiplier,
        READY => ready_tensor_integer_multiplier,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_multiplier,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_multiplier,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_multiplier,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_multiplier,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_multiplier,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_multiplier,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_multiplier,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_multiplier,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_multiplier,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_integer_multiplier,
        SIZE_J_IN => size_j_in_tensor_integer_multiplier,
        SIZE_K_IN => size_k_in_tensor_integer_multiplier,
        DATA_A_IN => data_a_in_tensor_integer_multiplier,
        DATA_B_IN => data_b_in_tensor_integer_multiplier,

        DATA_OUT     => data_out_tensor_integer_multiplier,
        OVERFLOW_OUT => overflow_out_tensor_integer_multiplier
        );
  end generate model_tensor_integer_multiplier_test;

  -- TENSOR DIVIDER
  model_tensor_integer_divider_test : if (ENABLE_NTM_TENSOR_INTEGER_DIVIDER_TEST) generate
    tensor_integer_divider : model_tensor_integer_divider
      generic map (
        DATA_SIZE    => DATA_SIZE,
        CONTROL_SIZE => CONTROL_SIZE
        )
      port map (
        -- GLOBAL
        CLK => CLK,
        RST => RST,

        -- CONTROL
        START => start_tensor_integer_divider,
        READY => ready_tensor_integer_divider,

        DATA_A_IN_I_ENABLE => data_a_in_i_enable_tensor_integer_divider,
        DATA_A_IN_J_ENABLE => data_a_in_j_enable_tensor_integer_divider,
        DATA_A_IN_K_ENABLE => data_a_in_k_enable_tensor_integer_divider,
        DATA_B_IN_I_ENABLE => data_b_in_i_enable_tensor_integer_divider,
        DATA_B_IN_J_ENABLE => data_b_in_j_enable_tensor_integer_divider,
        DATA_B_IN_K_ENABLE => data_b_in_k_enable_tensor_integer_divider,

        DATA_OUT_I_ENABLE => data_out_i_enable_tensor_integer_divider,
        DATA_OUT_J_ENABLE => data_out_j_enable_tensor_integer_divider,
        DATA_OUT_K_ENABLE => data_out_k_enable_tensor_integer_divider,

        -- DATA
        SIZE_I_IN => size_i_in_tensor_integer_divider,
        SIZE_J_IN => size_j_in_tensor_integer_divider,
        SIZE_K_IN => size_k_in_tensor_integer_divider,
        DATA_A_IN => data_a_in_tensor_integer_divider,
        DATA_B_IN => data_b_in_tensor_integer_divider,

        DATA_OUT      => data_out_tensor_integer_divider,
        REMAINDER_OUT => remainder_out_tensor_integer_divider
        );
  end generate model_tensor_integer_divider_test;

  tensor_assertion : process (CLK, RST)
    variable i : integer := 0;
    variable j : integer := 0;
    variable k : integer := 0;
  begin
    if rising_edge(CLK) then
      if (ready_tensor_integer_adder = '1' and data_out_i_enable_tensor_integer_adder = '1' and data_out_j_enable_tensor_integer_adder = '1' and data_out_k_enable_tensor_integer_adder = '1') then
        assert data_out_tensor_integer_adder = TENSOR_ADDER_OUTPUT_0(i, j, k)
          report "TENSOR ADDER: CALCULATED = " & to_string(data_out_tensor_integer_adder) & "; CORRECT = " & to_string(TENSOR_ADDER_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_integer_adder = '1' and data_out_j_enable_tensor_integer_adder = '1' and data_out_k_enable_tensor_integer_adder = '1' and not data_out_tensor_integer_adder = ZERO_DATA) then
        assert data_out_tensor_integer_adder = TENSOR_ADDER_OUTPUT_0(i, j, k)
          report "TENSOR ADDER: CALCULATED = " & to_string(data_out_tensor_integer_adder) & "; CORRECT = " & to_string(TENSOR_ADDER_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_integer_adder = '1' and data_out_k_enable_tensor_integer_adder = '1' and not data_out_tensor_integer_adder = ZERO_DATA) then
        assert data_out_tensor_integer_adder = TENSOR_ADDER_OUTPUT_0(i, j, k)
          report "TENSOR ADDER: CALCULATED = " & to_string(data_out_tensor_integer_adder) & "; CORRECT = " & to_string(TENSOR_ADDER_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_integer_adder = '1' and not data_out_tensor_integer_adder = ZERO_DATA) then
        assert data_out_tensor_integer_adder = TENSOR_ADDER_OUTPUT_0(i, j, k)
          report "TENSOR ADDER: CALCULATED = " & to_string(data_out_tensor_integer_adder) & "; CORRECT = " & to_string(TENSOR_ADDER_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;

      if (ready_tensor_integer_multiplier = '1' and data_out_i_enable_tensor_integer_multiplier = '1' and data_out_j_enable_tensor_integer_multiplier = '1' and data_out_k_enable_tensor_integer_multiplier = '1') then
        assert data_out_tensor_integer_multiplier = TENSOR_MULTIPLIER_OUTPUT_0(i, j, k)
          report "TENSOR MULTIPLIER: CALCULATED = " & to_string(data_out_tensor_integer_multiplier) & "; CORRECT = " & to_string(TENSOR_MULTIPLIER_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_integer_multiplier = '1' and data_out_j_enable_tensor_integer_multiplier = '1' and data_out_k_enable_tensor_integer_multiplier = '1' and not data_out_tensor_integer_multiplier = ZERO_DATA) then
        assert data_out_tensor_integer_multiplier = TENSOR_MULTIPLIER_OUTPUT_0(i, j, k)
          report "TENSOR MULTIPLIER: CALCULATED = " & to_string(data_out_tensor_integer_multiplier) & "; CORRECT = " & to_string(TENSOR_MULTIPLIER_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_integer_multiplier = '1' and data_out_k_enable_tensor_integer_multiplier = '1' and not data_out_tensor_integer_multiplier = ZERO_DATA) then
        assert data_out_tensor_integer_multiplier = TENSOR_MULTIPLIER_OUTPUT_0(i, j, k)
          report "TENSOR MULTIPLIER: CALCULATED = " & to_string(data_out_tensor_integer_multiplier) & "; CORRECT = " & to_string(TENSOR_MULTIPLIER_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_integer_multiplier = '1' and not data_out_tensor_integer_multiplier = ZERO_DATA) then
        assert data_out_tensor_integer_multiplier = TENSOR_MULTIPLIER_OUTPUT_0(i, j, k)
          report "TENSOR MULTIPLIER: CALCULATED = " & to_string(data_out_tensor_integer_multiplier) & "; CORRECT = " & to_string(TENSOR_MULTIPLIER_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;

      if (ready_tensor_integer_divider = '1' and data_out_i_enable_tensor_integer_divider = '1' and data_out_j_enable_tensor_integer_divider = '1' and data_out_k_enable_tensor_integer_divider = '1') then
        assert data_out_tensor_integer_divider = TENSOR_DIVIDER_OUTPUT_0(i, j, k)
          report "TENSOR DIVIDER: CALCULATED = " & to_string(data_out_tensor_integer_divider) & "; CORRECT = " & to_string(TENSOR_DIVIDER_OUTPUT_0(i, j, k))
          severity error;

        i := 0;
        j := 0;
        k := 0;
      elsif (data_out_i_enable_tensor_integer_divider = '1' and data_out_j_enable_tensor_integer_divider = '1' and data_out_k_enable_tensor_integer_divider = '1' and not data_out_tensor_integer_divider = ZERO_DATA) then
        assert data_out_tensor_integer_divider = TENSOR_DIVIDER_OUTPUT_0(i, j, k)
          report "TENSOR DIVIDER: CALCULATED = " & to_string(data_out_tensor_integer_divider) & "; CORRECT = " & to_string(TENSOR_DIVIDER_OUTPUT_0(i, j, k))
          severity error;

        i := i + 1;
        j := 0;
        k := 0;
      elsif (data_out_j_enable_tensor_integer_divider = '1' and data_out_k_enable_tensor_integer_divider = '1' and not data_out_tensor_integer_divider = ZERO_DATA) then
        assert data_out_tensor_integer_divider = TENSOR_DIVIDER_OUTPUT_0(i, j, k)
          report "TENSOR DIVIDER: CALCULATED = " & to_string(data_out_tensor_integer_divider) & "; CORRECT = " & to_string(TENSOR_DIVIDER_OUTPUT_0(i, j, k))
          severity error;

        j := j + 1;
        k := 0;
      elsif (data_out_k_enable_tensor_integer_divider = '1' and not data_out_tensor_integer_divider = ZERO_DATA) then
        assert data_out_tensor_integer_divider = TENSOR_DIVIDER_OUTPUT_0(i, j, k)
          report "TENSOR DIVIDER: CALCULATED = " & to_string(data_out_tensor_integer_divider) & "; CORRECT = " & to_string(TENSOR_DIVIDER_OUTPUT_0(i, j, k))
          severity error;

        k := k + 1;
      end if;
    end if;
  end process tensor_assertion;

end model_integer_testbench_architecture;
