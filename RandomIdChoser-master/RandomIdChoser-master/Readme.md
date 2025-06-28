# RandomIdChoser

## What is it?

The RandomIdChoser is a [LIGGGHTS(R)](https://github.com/CFDEMproject/LIGGGHTS-PUBLIC/) case that chooses a random particle. It was first used in the [CFDEM(R)Workshop](http://www.cfdem.com) 2017 where "The Award" was first given out.

## How can I run it?

```
liggghts -in in.random_id_choser -st
```

## How can I visualize my results?

Open ParaView (preferably version 5.4) and open the *pv_state.pvsm* state file. The spreadsheet view on the top right hand side should show the id at the end (step 250).

## Who is behind this?

This case was developed by Arno Mayrhofer at [DCS Computing GmbH](http://www.dcs-computing.com). DCS is the main developer behind LIGGGHTS(R) and CFDEM(R)coupling.
