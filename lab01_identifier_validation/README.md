# Lab 01 — Identifier Validation in C

## 1. Objective

To write a C program that accepts an identifier from the keyboard and validates
it according to the rules of the C programming language.

## 2. Theory

An **identifier** in C is a name used to identify variables, functions,
arrays, structures, and other user-defined items. The C standard defines a
strict set of rules for what constitutes a valid identifier:

1. The first character must be an alphabet (`A`–`Z`, `a`–`z`) or an
   underscore (`_`).
2. Subsequent characters may contain alphabets, digits (`0`–`9`), or
   underscores.
3. The identifier must not match any of the reserved C keywords
   (e.g. `int`, `if`, `return`).
4. The identifier must not contain whitespace or special characters such
   as `#`, `$`, `-`, `!`, etc.
5. Although the C standard only requires support for **31 significant
   characters**, modern compilers accept much longer names.

The **lexical analyzer** (the first phase of a compiler) is responsible for
checking these rules. Identifier validation is a foundational operation in
compiler design because it determines whether a token sequence starts with a
legal name.

## 3. Algorithm

```
Step 1: Start
Step 2: Read identifier string from the user.
Step 3: If the string is empty, print "Invalid" and stop.
Step 4: If the first character is NOT a letter or underscore,
        print "Invalid" and stop.
Step 5: For each subsequent character,
        if it is NOT a letter, digit, or underscore, print "Invalid" and stop.
Step 6: If the identifier matches any reserved C keyword,
        print "Invalid" and stop.
Step 7: Otherwise, print "Valid Identifier".
Step 8: Stop
```

### Flowchart (text representation)

```
[Start]
   |
   v
[Read identifier]
   |
   v
[Empty?]--Yes-->[Invalid]
   |
   No
   v
[First char letter/_?]--No-->[Invalid]
   |
   Yes
   v
[All chars alphanumeric/_?]--No-->[Invalid]
   |
   Yes
   v
[Reserved keyword?]--Yes-->[Invalid]
   |
   No
   v
[Valid]
   |
   v
[End]
```

## 4. Source Code

See `program.c`. The program is fully commented and modular.

### Compilation Commands

```bash
gcc -Wall -Wextra -std=c11 -O2 -o program program.c
```

### Execution Commands

```bash
./program
```

Or, using the helper script:

```bash
chmod +x run.sh
./run.sh
./run.sh my_variable
```

## 5. Sample Input and Output

### Sample Input

The `sample_input.txt` file contains a list of test cases, one per run.
A few are:

- `valid_identifier`  -> **Valid**
- `123abc`            -> **Invalid** (starts with digit)
- `if`                -> **Invalid** (reserved keyword)
- `_sum`              -> **Valid**
- `my-var`            -> **Invalid** (contains hyphen)
- `hello world`       -> **Invalid** (contains whitespace)
- `return`            -> **Invalid** (reserved keyword)

### Sample Output (excerpt)

```
=========================================
 Lab 01 - C Identifier Validator
=========================================
Enter an identifier: valid_identifier
[OK] "valid_identifier" is a VALID C identifier.
```

The full expected output for every test case is in `sample_output.txt`.

## 6. Explanation

- The program reads a single line from standard input using `fgets`.
- It first checks for empty input and whitespace inside the identifier.
- `isalpha` and `isalnum` from `<ctype.h>` are used to validate individual
  characters.
- A static array of C reserved keywords is searched linearly. If a match
  is found, the identifier is rejected.
- The program finally prints a colored success or failure message and
  exits with code 0.

## 7. Time Complexity

- Let `n` be the length of the identifier and `k` the number of reserved
  keywords (currently 37).
- **Time:** `O(n + k)` per validation.
- The linear scan of the identifier is `O(n)` and the keyword table
  lookup is `O(k)`.

## 8. Space Complexity

- **Auxiliary space:** `O(1)` — only a few variables and constant-size
  keyword table.
- **Input storage:** `O(n)` for the input buffer.

## 9. Observation

Identifiers starting with a digit are immediately rejected, as in `1abc`.
Reserved keywords such as `if`, `else`, `return`, and `while` are rejected.
Underscores are allowed as the first character (`_sum`, `_var2`).
Special characters such as `$`, `-`, `#`, and `@` are not allowed.

## 10. Conclusion

This lab demonstrates the first step of lexical analysis: identifying
whether a stream of characters forms a valid token name. The same logic
is used by the lexical analyzer in real compilers before a symbol-table
lookup is performed.

## 11. Files in this Lab

| File              | Purpose                                    |
|-------------------|--------------------------------------------|
| `program.c`       | Source code for the identifier validator.  |
| `run.sh`          | Compiles and runs the program.             |
| `sample_input.txt`| List of test identifiers.                  |
| `sample_output.txt`| Expected output for each test case.       |
| `README.md`       | This documentation file.                   |

## 12. Author

`riftbond007` — abdullah.al.rifat2239@gmail.com
