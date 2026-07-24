# Lab 02 — Character, Word, and Line Counter

## 1. Objective

To write a C program that reads a text file and counts its total number of
characters, words, and lines.

## 2. Theory

Counting characters, words, and lines is a classic introductory compiler-lab
exercise. It demonstrates character classification, state tracking, and
line-by-line input handling.

The program reads the user input one line at a time using `fgets`:

- Every character typed (including spaces and tabs) is counted.
- A line is counted for every non-empty line entered.
- A word is a maximal sequence of non-whitespace characters. Whitespace
  (spaces, tabs, newline) separates words.

The `isspace()` function from `<ctype.h>` recognizes whitespace characters.
The `in_word` flag prevents consecutive characters within one word from being
counted as multiple words.

Input ends when the user presses **Enter on an empty line**, which is the
standard "blank line ends input" convention used by many command-line tools.

## 3. Algorithm

```text
Step 1: Start.
Step 2: Display the interactive prompt.
Step 3: Initialize character, word, and line counters to zero.
Step 4: Read one line from stdin.
Step 5: If the line is empty, go to Step 9.
Step 6: Increment the line counter.
Step 7: For every character in the line:
        - Increment the character counter.
        - If the character is whitespace, mark that we are outside a word.
        - Otherwise, if we were outside a word, increment the word counter
          and mark that we are inside a word.
Step 8: Repeat from Step 4.
Step 9: Display all counters.
Step 10: Stop.
```

### Flowchart (text representation)

```text
[Start]
   |
   v
[Print prompt]
   |
   v
[Read line]
   |
   v
[Empty line?] -- Yes --> [Display results] --> [End]
   |
   No
   v
[Increment line count]
   |
   v
[For each character]
   |
   v
[Whitespace?] -- Yes --> [in_word = 0] ----+
   |                                      |
   No                                     |
   |                                      v
[New word?] -- Yes --> [word_count++]     [next char]
   |
   v
[Next character] <-----+
   |
   v
[Done?]--No-->[Next iteration]
   |
   Yes
   v
[Display results]
   |
   v
[End]
```
```

## 4. Source Code

The complete implementation is in `program.c`.

### Compilation Commands

```bash
gcc -Wall -Wextra -std=c11 -O2 -o program program.c
```

### Execution Commands

Run the interactive script:

```bash
chmod +x run.sh
./run.sh
```

The program asks you to type text one line at a time. Press **Enter on an
empty line** to finish input and display the counts.

Example session:

```text
Type your text line by line.
Press ENTER on an empty line to finish.
-----------------------------------------
Hello world
This is line two
Line three here

-----------------------------------------
Characters   : 42
Words        : 9
Lines        : 3
```

The compiled `program` binary is removed automatically after execution.

## 5. Sample Input

The program is interactive. The user types lines of text one at a time. To
finish, the user presses **Enter on an empty line**.

Example input session:

```text
Hello world.
This is a sample text.
It contains three lines of text.
```

## 6. Sample Output

```text
=========================================
 Lab 02 - Character / Word / Line Counter
=========================================
Type your text line by line.
Press ENTER on an empty line to finish.
-----------------------------------------
Hello world.
This is a sample text.
It contains three lines of text.

-----------------------------------------
=========================================
 Lab 02 - Character / Word / Line Counter
=========================================
Characters   : 42
Words        : 9
Lines        : 3
=========================================
```

The expected output for a longer typed example is stored in `sample_output.txt`.

## 7. Explanation

The program reads the user's input one line at a time using `fgets`. Each
non-empty line increments the line counter.

Inside each line, the `char_count` variable is incremented for every
character typed. The `in_word` state variable is initially false. When a
non-whitespace character appears while `in_word` is false, a new word has
begun, so the word counter is incremented and `in_word` becomes true. Any
whitespace character resets `in_word` back to false.

The program ends when the user presses Enter on an empty line — this is the
standard "blank line ends input" convention used by many command-line tools.

## 8. Time Complexity

For `n` characters typed in total:

- **Time complexity:** `O(n)`
- Every character is examined a constant number of times.

## 9. Space Complexity

- **Auxiliary space complexity:** `O(1)` (only the current line buffer
  plus a few counters are kept in memory, regardless of input size).

## 10. Observation

Whitespace separates words, but it is still included in the character count.
Tabs and multiple spaces do not create empty words. The empty line that ends
input is **not** counted as a line. The interactive prompt gives immediate
feedback, which is useful for live compiler-lab sessions.

## 11. Conclusion

This experiment demonstrates interactive line-by-line input handling and basic
lexical state tracking. The same single-pass scanning technique is used in
compiler front ends when source files are converted into streams of tokens.

## 12. Files in this Lab

| File | Purpose |
|---|---|
| `program.c` | Interactive C implementation of the counter. |
| `run.sh` | Compiles, runs the program, and cleans up. |
| `sample_output.txt` | Example expected output for a sample session. |
| `README.md` | Theory, algorithm, usage, and analysis. |

## 13. Author

`riftbond007` — abdullah.al.rifat2239@gmail.com
