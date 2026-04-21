---
title: Lab 3
weight: 4
math: true
toc: true
---

# Lab 3: Stable relationships

## Overview

In this last minilab3 we will pick up on the system you evolved in minilab1 and follow its further evolution into a double black hole binary. Remember that at the end of your minilab1 you had a system with the properties listed in the below [Table 1](#table-binary).

<div style="display: flex; justify-content: center;">
<table id="table-binary" style="margin:auto; text-align:center;">
  <tr>
    <th></th>
    <th>Primary (Donor)</th>
    <th>Secondary (Accretor)</th>
  </tr>
  <tr>
    <td>Mass</td>
    <td>18 M☉</td>
    <td>38 M☉</td>
  </tr>
  <tr>
    <td>Ω / Ωcrit</td>
    <td>0.02</td>
    <td>0.1</td>
  </tr>
  <tr>
    <td>Orbital Period</td>
    <td colspan="2" style="text-align:center;">6.8 days</td>
  </tr>
  <tr>
    <td>Mass ratio</td>
    <td colspan="2" style="text-align:center;">0.47</td>
  <tr>
  <td>Final model</td>
  <td>
    <a href="/files/final1_caseA.mod" download>
      <code>final1_caseA.mod</code>
    </a>
  </td>
  <td>
    <a href="/files/final2_caseA.mod" download>
      <code>final2_caseA.mod</code>
    </a>
  </td>
</tr>
<caption id="table-binary"><strong>Table 1:</strong> Your binary at the end of minilab1.</caption>
</table>
</div>

This system has a rapidly rotating (spun-up) secondary that has accreted a lot of mass from the primary; it is, therefore, "rejuvenated" (fresh fuel has prolonged its Main Sequence lifetime), and is happily burning hydrogen (H) in its core. The primary, on the other hand, has already depleted helium (He) in its core and has been "stripped" off its H-rich envelope. 


## 1. Stable mass transfer

Let's start from the standard work directory from ```$MESA_DIR```:

<!-- <pre style="background:#0b0f14;color:#d6deeb;padding:1rem;border-radius:6px;overflow-x:auto;font-family:ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', monospace;">
$ cp -r $MESA_DIR/binary/work template
$ cd template
</pre> -->

<div style="display:flex;justify-content:center;">

<div style="
  background:#0b0f14 !important;
  color:#d6deeb;
  padding:1rem;
  overflow-x:auto;
  width:100%;
  max-width:1200px;
  border-radius:0 !important;
  box-shadow:none !important;
">

```bash
cp -r $MESA_DIR/binary/work stable_MT
cd stable_MT
```
</div> </div>
Inspect the inlists:

### The primary becomes a BH companion
After He depletion in its core, the primary star has a very short remaining lifetime: for a star of total mass ~ 20 $M_{\odot}$ (and He-core mass of ~ X $M_{\odot}$), you can expect it to live only another ~ 300 years! For simplicity, we will just assume that the properties at core He depletion can be representative of those at the end of the star's life. Additionally, we will assume that all the mass contained in the primary directly collapses to form a BH.

Find the mass of the primary at core He depletion from your <code>minilab1</code> and make it directly collapse into a BH.

### How does the orbit shrink?
Let's compare how much orbital shrinkage you get with Eddington-limited accretion with respect to what you saw in Minilab1
Let's make them realize that Eddington-limited in practice means fully non-conservative, and let's have them check with a higher beta instead what changes.

### The time delay and final mass ratio
Let's compute the time delay of your BH + BH system to see if it will merge within the age of the Universe, in the beta>0 and Eddington-limited case. Compare!
Maybe let's find a GW signal that can be matchy-matchy

<div style="
  max-width: 600px;
  margin: 20px auto;
  border: 1px solid #d9534f;
  border-radius: 8px;
  background-color: #f5c2c2;
  overflow: hidden;
  color: black;
  font-family: sans-serif;
">

  <!-- Header -->
  <div style="
    background-color: #d9534f;
    color: black;
    font-weight: bold;
    text-align: center;
    padding: 8px;
  ">
    RUN 1 (4 minutes on 4 cores)
  </div>

  <!-- Body -->
  <div style="
    padding: 15px;
    text-align: center;
  ">
    <p style="margin: 0;">
      Run your star + BH model.<br>
      In case you're lost, complete inlists for this run:
      <a href="/thursday/lab3/stable_MT_SOL.zip" download>
        <code>stable_MT_SOL.zip</code>
      </a>
    </p>
  </div>

</div>

### Orbital tightening from L2 mass loss
L2 shrinkage! Implementation in run_binary_extras.f90

<div style="
  max-width: 600px;
  margin: 20px auto;
  border: 1px solid #4fa2d9;
  border-radius: 8px;
  background-color: #e8f6ff;
  overflow: hidden;
  color: black;
  font-family: sans-serif;
">

  <!-- Header -->
  <div style="
    background-color: #4fa2d9;
    color: black;
    font-weight: bold;
    text-align: center;
    padding: 8px;
  ">
    RUN 2 (x minutes on 4 cores)
  </div>

  <!-- Body -->
  <div style="
    padding: 15px;
    text-align: center;
  ">
    <p style="margin: 0;">
      Run your star + BH model with L2 outflow.<br>
      In case you're lost, complete inlists for this run:
      <a href="/thursday/lab3/stable_MT_L2_SOL.zip" download>
        <code>stable_MT_L2_SOL.zip</code>
      </a>
    </p>
  </div>

</div>

#### ➕ BONUS: CASE B comparison!
Only if they had the time in minilab1 to do caseB.


## 2. Common envelope evolution
Brief explanation of the energy formalism

### The unstable mass transfer rate
Here we will define and implement what is an unstable mass transfer rate. run_binary_extras.f90 with a factor 10xthermal timescale, or x_ctrl(1) with a fixed number? We also implement a stopping condition at CE onset.

### The binding energy of the envelope
Implementation in run_star_extras.f90

### A lower mass ratio favors instability!
Here we will tell them to change the q. We want to give them a number that we know the outcome of. Then they run the model.

<div style="
  max-width: 600px;
  margin: 20px auto;
  border: 1px solid #4fd99f;
  border-radius: 8px;
  background-color: #cdffea;
  overflow: hidden;
  color: black;
  font-family: sans-serif;
">

  <!-- Header -->
  <div style="
    background-color: #4fd99f;
    color: black;
    font-weight: bold;
    text-align: center;
    padding: 8px;
  ">
    RUN 3 (x minutes on 4 cores)
  </div>

  <!-- Body -->
  <div style="
    padding: 15px;
    text-align: center;
  ">
    <p style="margin: 0;">
      Run your common envelope model.<br>
      In case you're lost, complete inlists for this run:
      <a href="/thursday/lab3/common_envelope_SOL.zip" download>
        <code>common_envelope_SOL.zip</code>
      </a>
    </p>
  </div>

</div>

### The orbital shrinkage
Comparison with stable mass transfer. The idea is that they will use the energy formalism to get the post-CE orbital separation.

### The time delay and final mass ratio
In the CE case, compare with stable mass transfer.

#### ➕ BONUS1: CASE B comparison!
Only if they had the time in minilab1 to do caseA.

#### ➕➕ BONUS2: Delayed mass transfer instability
Have them look into the timescale of when instability develops, and the shift in properties (mass and orbital separation) from RLOF to CE onset

## 3. Spinning black holes!

