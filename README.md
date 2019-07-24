# Robotics4fun

This is a homemade robotics library made using trustworthy literature on Robotics. However, it is a WIP, though already advanced, and contributions are welcome. In case you are interested on a more mature material, take a look at http://petercorke.com/wordpress/toolboxes/robotics-toolbox :) 

If the reader is already familiar with github, skip the next steps. To clone this repository, type the following commands on linux:

```
mkdir ~/rob4fun 
cd ~/rob4fun
git clone git@github.com:brunolnetto/Robotics4fun.git 
```

Most likely, the reader may use Windows. For such, the author recommends either the Git Bash or Tortoise Git as source management software.

# Installation

If you wish to use it, follow the instructions:

1) Open Matlab up to the version 2015x, x = a, b;
2) Before calling the functions, type on MATLAB shell 

```
addpath('$ROB4FUN_PATH')
addpath(genpath('$ROB4FUN_PATH'))
savepath
``` 

where ```$ROB4FUN_PATH``` stands for the path where you cloned the repository, ```addpath``` add the provided path to ```MATLABPATH``` and ```genpath``` generate all paths of subfolders within ```$ROB4FUN_PATH```. If the reader followed the steps from previous section, the ```ROB4FUN_PATH``` corresponds to ```~/rob4fun```


3) Have fun and may the force be with you.

# Documentation
It is still small, but take a look at wiki: https://github.com/brunolnetto/Robotics4fun/wiki

# Reference

- John J. Craig. 1989. Introduction to Robotics: Mechanics and Control (2nd ed.). Addison-Wesley Longman Publishing Co., Inc., Boston, MA, USA.
- Slotine classes: http://web.mit.edu/nsl/www/videos/lectures.html 
- SLOTINE, J. J.; LI, W.; "Applied nonlinear control", Prentice Hall, 1st Ed., 1991.
- Alberto Isidori. 1995. Nonlinear Control Systems (3rd ed.). M. Thoma, E. D. Sontag, B. W. Dickinson, A. Fettweis, J. L. Massey, and J. W. Modestino (Eds.). Springer-Verlag, Berlin, Heidelberg.
- Baruh, Haim. Analytical dynamics. Boston: WCB/McGraw-Hill, 1999. 
