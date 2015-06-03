# Changelog

## SSA


|Date   |Name   |New File or Revision   |File Name   |Branch   |Changes   |Problems Remaining   |
|:-:|:---:|:---:|:---:|:---:|:---:|:---:|
| May 26, 2015  | Ella  | New File  | TauLeapVectorized  |  Master |  Vectorized the loops |  Make compatible for more than 3 reactions |
| May 26, 2015  | Ella  | New File  | SSATestTauLeap  | Master  | Uses vectorization to calc. tau leap faster. Added an additional symbol for plotting 5 simulation.  | Method to prevent a substance from depletion. Consistency between simulations.  |
| May 27, 2015  | Chris/Ella  | Revision  | SSATestTauLeap  | Master |  Changed colours to ['b','r','g'] for [x1,x2,y] plots. Also added a list of symbols randomly selected when plotting. Changed symbol plot size to 12. | Incorporate modified poisson for determining critical reactions.  |
| May 27, 2015  | Ella |  New File |  genRj | Master  | Determines critical reations. Outputs a vector of 0's and 1's indicating which reactions are critical.   |  Integrating with main program. Using the outputed variable to determine whether tau generation needs to include critical reactions. Using Vectorization. |
| May 28, 2015  | Chris  |New File   |  Smallep_1sim.fig |  Master | Added figure of a plot with a small epsilon  | Speed up time |
| May 28, 2015  | Ella  |  New File | genTauPrime  | Master  | Add function to generate tau prime using non-critical reactions for j'  |  Integrating in main program |
| May 28, 2015 |  Ella | New File  | genTauDoublePrime  | Master  | Add function to generate tau double prime using exponential distribution  | Integrating in main program  |
|  May 28, 2015 | Ella  |New File   |  SSATestModifiedTau | Master  | Main program for modified tau leaping | Adding changes to X due to reactions during tau leap  |
|  May 28, 2015 |  Ella |  New File | amountChanges  | Master  |Generates the changes in amount of each substance during a give time period, tau   |  Error being generated when used with the genRj function (producing an empty matrix)  |
| May 28, 2015  | Ella  | Revision  | SSATestModifiedTau  | Master  | Added changes in x due to reactions when tau prime is used for tau | Add changes in x due to reactions when tau double prime is used for tau. Check to make sure reactants are not running out.  |
| May 29, 2015  | Ella |  New File | amountChangesDouble  | Master  | Generates changes in amounts of each species if tau is selected as tau double prime. One non-critical reaction occurs  | Integrating function in main program  |
| May 29, 2015  | Ella  | Revision  | SSATestModifiedTau  | Master  | Includes integration of function for changes in amounts of each species if tau = tau double prime  | Amounts of species is still going below 0  |
| May 29, 2015  | Ella  | Revision  | SSATestModifiedTau  | Master  | Reduced number of SSA steps to prevent amount of species from dropping below zero  | Test different numbers of SSA steps  (ie 30, 5) |
| June 2, 2015 | Ella |Revision| SSATestModifiedTau | Master | Changed number of SSA steps to 5| The time is going over the max time defined at the beginning of the program|
| June 2, 2015 | Ella | New File | genEis | Master | Add function to generate epsilon value for each species (to be used for binomial tau leaping) | Integrate with main program. Input orders of each reaction instead of calculating in the program|
| June 2, 2015 | Ella | Revision | genEis | Master | Change to using case instead of if statements. Will allow for higher order reactions to be added later if needed | Integrating with main program | 
| June 3, 2015 | Ella | Revision | genEis | Master | Add an output of gis since it is required for the tau prime generation | Integrating with main program | 
| June 3, 2015 | Ella | New File | SSATestTauBinomial | Master | Uses new method for calculating tau prime | Increasing speed for longer time periods. Enabling longer time periods | 
| June 3, 2015 | Ella | New File | genMeanVar | Master | Generate tau prime using new method | Checking the formulas for the max term in the means and variances|
