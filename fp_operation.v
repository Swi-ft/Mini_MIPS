module fp_adder(
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] sum
);

  reg         a_sign, b_sign;
  reg [7:0]   a_exp,  b_exp;
  reg [22:0]  a_frac, b_frac;
  reg [23:0]  a_mant, b_mant;

  reg         op1_sel;
  reg         op1_sign, op2_sign;
  reg [7:0]   exp_large;
  reg [23:0]  op1_mant, op2_mant;
  reg [7:0]   exp_diff;

  reg [27:0]  op1_ext, op2_ext;
  reg [27:0]  mant_sum;
  reg         result_sign;

  reg [27:0]  mant_norm;     // Normalized mantissa
  reg [7:0]   exp_result;    // Adjusted exponent after normalization
  integer i;
  integer found;           // Flag to indicate first '1' found
  integer shift;           // Number of positions to shift for normalization

  // Rounding signals
  reg [23:0]  mantissa_final; // 24-bit mantissa (1 implicit bit + 23 fraction bits)
  reg [2:0]   round_bits;     // Guard, round, and sticky bits

  // Main combinational block
  always @(*) begin
    // 1. Extract the fields of both operands.
    a_sign = a[31];
    b_sign = b[31];
    a_exp  = a[30:23];
    b_exp  = b[30:23];
    a_frac = a[22:0];
    b_frac = b[22:0];

    // For normalized numbers, the implicit MSB is 1.
    a_mant = (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
    b_mant = (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // 2. Determine which operand has the larger magnitude.
    if ((a_exp > b_exp) || ((a_exp == b_exp) && (a_mant >= b_mant))) begin
      op1_sel   = 1;        // A is larger
      op1_sign  = a_sign;
      op2_sign  = b_sign;
      exp_large = a_exp;
      op1_mant  = a_mant;
      op2_mant  = b_mant;
      exp_diff  = a_exp - b_exp;
    end
    else begin
      op1_sel   = 0;        // B is larger
      op1_sign  = b_sign;
      op2_sign  = a_sign;
      exp_large = b_exp;
      op1_mant  = b_mant;
      op2_mant  = a_mant;
      exp_diff  = b_exp - a_exp;
    end

    // 3. Align the mantissas.
    // Extend 24-bit mantissas to 28 bits: one extra MSB and 3 LSB guard bits.
    op1_ext = {1'b0, op1_mant, 3'b000};
    op2_ext = {1'b0, op2_mant, 3'b000} >> exp_diff;

    // 4. Perform addition or subtraction.
    if (op1_sign == op2_sign) begin
      mant_sum    = op1_ext + op2_ext;
      result_sign = op1_sign;  // Same sign: straightforward addition.
    end
    else begin
      // Subtraction: since op1 is the larger magnitude, subtract op2 from op1.
      mant_sum    = op1_ext - op2_ext;
      result_sign = op1_sign;
    end

    // 5. Normalize the result.
    if (mant_sum[27] == 1'b1) begin
      // If there's a carry-out, shift right by 1 and increment the exponent.
      mant_norm  = mant_sum >> 1;
      exp_result = exp_large + 1;
    end
    else begin
      if (mant_sum != 0) begin
        shift = 0;
        found = 0;        // Initialize the flag.
        mant_norm = mant_sum;
        // Find the position of the first '1' in bits [26:0]
        for (i = 26; i >= 0; i = i - 1) begin
          if (!found && mant_norm[i] == 1'b1) begin
            shift = 26 - i;
            found = 1;  // Mark that the first '1' has been found.
          end
        end
        mant_norm  = mant_norm << shift;
        exp_result = exp_large - shift;
      end
      else begin
        // If the result is zero.
        mant_norm  = 0;
        exp_result = 0;
      end
    end

    // 6. Rounding: use bits [26:3] for the 24-bit mantissa; bits [2:0] are for rounding.
    mantissa_final = mant_norm[26:3];
    round_bits     = mant_norm[2:0];

    // Round-to-nearest, ties-to-even.
    if ((round_bits > 3'b100) ||
        ((round_bits == 3'b100) && (mantissa_final[0] == 1'b1))) begin
      mantissa_final = mantissa_final + 1;
      // Handle rounding overflow (e.g., rounding causes a carry).
      if (mantissa_final == 24'h800000) begin
        mantissa_final = mantissa_final >> 1;
        exp_result = exp_result + 1;
      end
    end

    // 7. Pack the result into IEEE-754 format.
    // Drop the implicit bit: use lower 23 bits of mantissa_final.
    sum = {result_sign, exp_result, mantissa_final[22:0]};
  end

endmodule

module fp_comparator (
    input  [31:0] a,   // First floating-point number in IEEE-754 format
    input  [31:0] b,   // Second floating-point number in IEEE-754 format
    output        eq,  // '1' if a equals b
    output        lt,  // '1' if a is less than b
    output        gt,  // '1' if a is greater than b
    output        le,  // '1' if a is less than or equal to b
    output        ge   // '1' if a is greater than or equal to b
    );

  // Extract sign, exponent and fraction parts
  wire        a_sign, b_sign;
  wire [7:0]  a_exp, b_exp;
  wire [22:0] a_frac, b_frac;

  assign a_sign = a[31];
  assign b_sign = b[31];
  assign a_exp  = a[30:23];
  assign b_exp  = b[30:23];
  assign a_frac = a[22:0];
  assign b_frac = b[22:0];

  // Equality can be determined by simple bitwise comparison
  assign eq = (a == b);

  // Internal registers for less-than and greater-than results
  reg lt_int, gt_int;

  // Combinational block to compare 'a' and 'b'
  always @(*) begin
    // Default assignments for the flags
    lt_int = 1'b0;
    gt_int = 1'b0;

    // If the numbers are exactly equal, no further comparison is needed.
    if (a == b) begin
      lt_int = 1'b0;
      gt_int = 1'b0;
    end else begin
      // Compare the sign bits
      if (a_sign != b_sign) begin
        // If signs differ, the negative number is less
        lt_int = a_sign;
        gt_int = b_sign;
      end
      else begin
        // Both numbers have the same sign
        // For positive numbers, larger exponent or fraction means a larger number.
        if (a_sign == 1'b0) begin
          if (a_exp < b_exp)
            lt_int = 1'b1;
          else if (a_exp > b_exp)
            gt_int = 1'b1;
          else begin
            // Exponents are equal, compare fraction (mantissa)
            if (a_frac < b_frac)
              lt_int = 1'b1;
            else if (a_frac > b_frac)
              gt_int = 1'b1;
          end
        end
        // For negative numbers, the comparison is reversed
        else begin
          if (a_exp < b_exp)
            gt_int = 1'b1;
          else if (a_exp > b_exp)
            lt_int = 1'b1;
          else begin
            if (a_frac < b_frac)
              gt_int = 1'b1;
            else if (a_frac > b_frac)
              lt_int = 1'b1;
          end
        end
      end
    end
  end

  // Drive outputs from the internal registers and computed equality
  assign lt = lt_int;
  assign gt = gt_int;
  assign le = lt_int || eq; // a is less than or equal to b when it's less than or exactly equal to b
  assign ge = gt_int || eq; // a is greater than or equal to b when it's greater than or exactly equal to b

endmodule