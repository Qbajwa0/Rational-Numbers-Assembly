.macro PRINT_STRING
    li $v0, 4               # Syscall code for printing string
    syscall                  # Perform the system call
.end_macro

.macro READ_INTEGER
    li $v0, 5               # Syscall code for reading an integer
    syscall                  # Read int input from user
.end_macro

.macro PRINT_NEWLINE
    li $v0, 4               # Syscall code for printing string
    la $a0, newline         
    syscall                  # Print newline
.end_macro

.macro PRINT_RATIONAL
    move $a0, $t8            # Move numerator into $a0 for printing
    li $v0, 1               # Syscall code for printing an integer
    syscall                  # Print numerator

    li $v0, 4               # Syscall code for printing string
    la $a0, slash           # Load / symbol to print
    syscall                  # Print slash

    move $a0, $t9            # Move denominator into $a0 for printing
    li $v0, 1               # Syscall code for printing an integer
    syscall                  # Print denominator

    PRINT_NEWLINE            # Print newline at the end
.end_macro

# Data section where strings and messages are stored
.data
    prompt1:      .asciiz "Enter the first rational number (numerator1 denominator1): "
    prompt2:      .asciiz "Enter the second rational number (numerator2 denominator2): "
    op_prompt:    .asciiz "Choose operation: 1) addition 2) subtraction 3) multiplication 4) division: "
    error_div_by_zero: .asciiz "Error: Denominator cannot be zero! Re-enter the rational number.\n"
    result_prompt: .asciiz "The result is: "
    slash:        .asciiz "/"
    newline:      .asciiz "\n"

.text
.globl main
main:
    # Get the first rational number (numerator1/denominator1)
get_first_rational:
    la $a0, prompt1          # Load the first prompt message
    PRINT_STRING             # Print the prompt

    READ_INTEGER             # Read numerator1
    move $t0, $v0            # Store numerator1 in $t0

    READ_INTEGER             # Read denominator1
    move $t1, $v0            # Store denominator1 in $t1
    beq $t1, $zero, div_zero_error1  # If denominator1 is zero, go to error handler

    # Get the second rational number (numerator2/denominator2)
get_second_rational:
    la $a0, prompt2          # Load the second prompt message
    PRINT_STRING             # Print the prompt

    READ_INTEGER             # Read numerator2
    move $t2, $v0            # Store numerator2 in $t2

    READ_INTEGER             # Read denominator2
    move $t3, $v0            # Store denominator2 in $t3
    beq $t3, $zero, div_zero_error2  # If denominator2 is zero, go to error handler

    # Ask user for the operation choice
    la $a0, op_prompt        # Load the operation prompt
    PRINT_STRING             # Print the operation prompt

    READ_INTEGER             # Read operation choice
    move $t4, $v0            # Store operation choice in $t4

    # Perform the selected operation
    li $t5, 1                # Load 1 (operation choice for addition)
    beq $t4, $t5, add_op     # If operation choice == 1, go to addition

    li $t5, 2                # Load 2 (operation choice for subtraction)
    beq $t4, $t5, sub_op     # If operation choice == 2, go to subtraction

    li $t5, 3                # Load 3 (operation choice for multiplication)
    beq $t4, $t5, mul_op     # If operation choice == 3, go to multiplication

    li $t5, 4                # Load 4 (operation choice for division)
    beq $t4, $t5, div_op     # If operation choice == 4, go to division

    j end                    # End program if invalid operation is selected

# Addition Operation
add_op:
    mul $t6, $t0, $t3        # t6 = p1 * q2
    mul $t7, $t2, $t1        # t7 = p2 * q1
    add $t8, $t6, $t7        # t8 = (p1 * q2) + (p2 * q1)
    mul $t9, $t1, $t3        # t9 = q1 * q2
    j print_result           # Jump to print result

# Subtraction Operation
sub_op:
    mul $t6, $t0, $t3        # t6 = p1 * q2
    mul $t7, $t2, $t1        # t7 = p2 * q1
    sub $t8, $t6, $t7        # t8 = (p1 * q2) - (p2 * q1)
    mul $t9, $t1, $t3        # t9 = q1 * q2
    j print_result           # Jump to print result

# Multiplication Operation
mul_op:
    mul $t8, $t0, $t2        # t8 = p1 * p2
    mul $t9, $t1, $t3        # t9 = q1 * q2
    j print_result           # Jump to print result

# Division Operation
div_op:
    mul $t8, $t0, $t3        # t8 = p1 * q2
    mul $t9, $t1, $t2        # t9 = q1 * p2
    j print_result           # Jump to print result

# Print the result
print_result:
    la $a0, result_prompt     # Load result prompt
    PRINT_STRING              # Print result prompt
    PRINT_RATIONAL            # Print the rational number result
    j end                     # End the program

# Error Handling for Denominator = 0
div_zero_error1:
    la $a0, error_div_by_zero # Load error message
    PRINT_STRING              # Print error message
    j get_first_rational       # Jump back to get first rational number

div_zero_error2:
    la $a0, error_div_by_zero # Load error message
    PRINT_STRING              # Print error message
    j get_second_rational      # Jump back to get second rational number

# End program
end:
    li $v0, 10                # Syscall code for exit
    syscall                   # Exit the program
