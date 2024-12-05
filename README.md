# The Fox and the Geese

## Introduction

The Fox and the Geese is a 2-player game in which one player controls the "Fox" and the other controls the "Geese."

To win, the Fox has to hunt 12 of the Geese. On the other hand, the Geese win if they manage to trap the Fox so that he can no longer move.

This project was developed together with 4 colleagues from the university, its base statement is found in the "Statement" folder.

In addition, the code has a self-contained report, in which each function, declaration of particular variables and points of attention has comments that clarify the total functioning of each part of the program.

---

# Report

First of all, this was a project for the university, so the code is written in spanish.

With this clarified, we move on to the report.

## Statement

In this folder you will find the base statement of the project carried out in "pdf" format.

## Program

In this folder are all the files made for the project.

An important clarification, in this folder are all the ".asm", ".o" files, the executable and the base saved games, but for the basic operation of the game simply the 2 ".asm" files are enough, with the During the compilation process, the rest of the files corresponding to the execution of the program will be created, and with the development of the game, the game save files will be created.

---

# Explanation of execution

To execute the program you must follow the following steps:
- Download the "Program" folder in its entirety.
- Enter from the "Linux" console (Operating System on which we rely to carry out the project) to the downloaded directory.
- Run the commands:
    - nasm -f elf64 -o main.o main.asm
    - nasm -f elf64 -o procedimientoDelJuego.o procedimientoDelJuego.asm
    - gcc -no-pie -o main.out main.o procedimientoDelJuego.o
    - ./main.out

---

# Explanation of each file (External path and "main" program)

## Main
In this main file all the logic for initialization, customization, saving the game, loading the game and modifying the board is implemented.

## procedimientoDelJuego

In this external route all the game logic is implemented (movements, victory and loss conditions, board updating, etc.).
