# CMEPractice
Practice work for stochastic simulation

## Pre-face

Work here was completed largely by Ella Thomson and Chris Cadonic for practicing the simulation of the chemical master equation. 

## SSA

The stochastic simulation algorithm (SSA) was setup as described in Gillespie (2007), and run using the bare-bones design for generating *&#964;* and *j*. The algorithm was described for an arbitrary reaction set involving *x1*, *x2* and *y*.

## *&#964;*-leaping

Practice incorporating *&#964;*-leaping into the ssa to facilitate efficient simulation for larger and/or more complicated systems. Different schemes for *&#964;* generation were tested and compared, including poisson and binomial distribtuion. These schemes were taken from Cao et al (2006). 
