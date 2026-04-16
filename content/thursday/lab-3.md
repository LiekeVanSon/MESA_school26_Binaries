---
title: Lab 3
weight: 4
math: true
toc: true
---

# Lab 3: Stable relationships

1:00 PM–3:30 PM 
10 min lecture + 2.15 h MESA material. 

Or alternatively "Sticking together until the end"

## Overview

SCIENCE BIT, not much because the lecture will cover it 

<!-- ANNACHIARA -->

## 1. Stable mass transfer

### Spun-up accretor with a BH companion
The secondary of your minilab1 will be evolved from its saved final model.
Find the mass of the primary at He-depletion from your Minilab1 and make it directly collapse into a BH.

### The orbital shrinkage
Let's compare how much orbital shrinkage you get with Eddington-limited accretion with respect to what you saw in Minilab1
Let's make them realize that Eddington-limited in practice means fully non-conservative, and let's have them check with a higher beta instead what changes.

### The time delay and final mass ratio
Let's compute the time delay of your BH + BH system to see if it will merge within the age of the Universe, in the beta>0 and Eddington-limited case. Compare!
Maybe let's find a GW signal that can be matchy-matchy

### Orbital tightening from L2 mass loss
L2 shrinkage! Implementation in run_binary_extras.f90

#### ➕ BONUS: CASE A comparison!
Only if they had the time in minilab1 to do caseA.


## 2. Common envelope evolution
Brief explanation of the energy formalism

### The unstable mass transfer rate
Here we will define and implement what is an unstable mass transfer rate. run_binary_extras.f90 with a factor 10xthermal timescale, or x_ctrl(1) with a fixed number? We also implement a stopping condition at CE onset.

### A lower mass ratio favors instability!
Here we will tell them to change the q. We want to give them a number that we know the outcome of. Then they run the model.

### The orbital shrinkage
Comparison with stable mass transfer. The idea is that they will use the energy formalism to get the post-CE orbital separation.

### The time delay and final mass ratio
In the CE case, compare with stable mass transfer.

#### ➕ BONUS1: CASE A comparison!
Only if they had the time in minilab1 to do caseA.

#### ➕ BONUS2: Delayed mass transfer instability
Have them look into the timescale of when instability develops, and the shift in properties (mass and orbital separation) from RLOF to CE onset

## 3. Spinning black holes!

## Files

Supporting starter files for this lab are available here:

- [inlist](/thursday/lab3/inlist)
- [inlist_project](/thursday/lab3/inlist_project)
- [inlist_pgstar](/thursday/lab3/inlist_pgstar)

Notes for this lab remain in [content/thursday/lab3/notes.md](content/thursday/lab3/notes.md).
