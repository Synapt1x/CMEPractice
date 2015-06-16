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
| June 4, 2015 | Ella | Revision | genMeanVar | Master | Changed equations for mean and variance so that the search for "max" only checks the top term | Increasing speed | 
| June 4, 2015 | Ella | New File | evalDerivs | Master | Evaluates the derivatives for the reactions | Implementing in main program | 
| June 4, 2015 | Ella | Revision | genMeanVar | Master | Removes the derivative evaluations, and instead receives the partial derivatives as inputs in a cell | Implementing in main program | 
| June 4, 2015 | Ella | Revision | SSATestTauBinomial | Master | Moves derivative calculations to outside main loop. Increases speed | Stress testing | 
| June 5, 2015 | Ella | Revision | SSATestTauBinomial | Master | | Getting stuck in symbolic calculations |
| June 5, 2015 | Ella | Revision | genRj| Checking whether lj is empty | Getting Stuck|
| June 5, 2015 | Ella | New File | TauAndJGen | | | 
| June 8, 2015 | Ella | New File | evalCrit | Master | Evaluates the critical threshold as 10% of the average of the initial quantities of all species| |
| June 8, 2015 | Ella | Revision | SSATestTauBinomial, genRj, genMeanVar | Master | Changed main program so that aj is evaluated once and is inputed to the rest of the functions | Checking for longer time periods. Adding additional reactions |
| June 9, 2015 | Ella | New File | SSATestTauAverages | Master | Calculates and plots average values for x1, X2 and y over the whole time period | Testing for longer time periods. Adding additional reactions |
| June 10, 2015 | Ella | Revision | SSATestTauAverages, genMeanVar | Master | Added corrective check to ensure infinity is not generated for tau prime | |
| June 10, 2015 | Ella | Revision | SSATestTauAverages | Master | Added corrective check to ensure species concentrations do not drop below 0 | Fixing plots for average species amounts |
| June 10, 2015 | Ella | Revision | SSATestTauAverages, all functions other than initializeParameters | Master | numSpecies and numReactions are defined in the initializeParameters function and are called as an input to all other functions when necessary | Expanding to more than 3 reactions. The described changes will facilitate this. However, the aj's for additional reactions will still need to be added individually in genRj |
| June 10, 2015 | Ella | Revision | genEis | Master | Separated the values for numSpecies and numRx | Test with a higher number of species and reactions |
| June 10, 2015 | Ella | Revision | SSATestTauAverages, genEis | Master | Make changes so the program is comaptible with any number of reactions and species | Testing with greater than 4 reactions and species |
| June 11, 2015 | Ella | Revision | SSATestTauAverages | Master | Add calculations and plotting  for a moving mean using set time intervals | Variance calculations. Moving mean using set number of points. Testing for longer time periods|
| June 11, 2015 | Ella | New File | SSATestMultiSims | Master | Calculations for variances added over fixed time intervals | Calculate mean and variance using fixed number of steps |
| June 11, 2015 | Ella | Revision | SSATestMultiSims | Master | Added calculations for means and variances using a set number of points, instead of a time period. Testing indicates that "steps" are producing more consistent results than time intervals. Intervals of 1% of all steps/ total time are producing consistent results. | Testing for 10,000 + number of simulations. Adding an additional species (4 species, 4 reactions) | 
| June 15, 2015 | Ella | New File | SSATestMultiSimsVector| Master | Mean and variances values for all species are stored in a matrix (time intervals) | Storing mean and variance values for step intervals in a matrix | 
| June 15, 2015 | Ella | New File | TimeMeanVar | Master | Function to calculate mean and variance for time intervals | Function for mean and variance for step intervals |
| June 15, 2015 | Ella | New Files | SSATestMultiSimsFn, TimeMeanVar, StepsMeanVar | Master | Main program uses function to evaluate means and variacnes with step and time intervals | Testing for larger number of simulations |
| June 15, 2015 | Ella | New File | SSATestMultiSimsSteps | Master | Calculates mean and varaince using step intervals only | Testing for longer simulation numbers |
| June 15, 2015 | Ella | New File and Revision | SSATestMultiSimsStDev, StepsMeanVar | Master | Add calculations and plotting for mean +/- standard deviation | Adding more reactions and species |
| June 16, 2015 | Ella | Revision | SSATestMultiSimsStDev, StepsMeanVar, genRj, initializeParameters | Master | Add a fifth species | Add additinal reactions |
| June 16, 2015 | Ella | Revision | SSATestMultiSimsStDev | Master | Add loops for plotting means and variances to increase speed | |
