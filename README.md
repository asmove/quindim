# Quindim

## Introduction

The funny name for this library comes from the phonetic word-trick which emerges from prefix of words ´´kinematics" and ´´dynamics". In fact, this is a robotics library made using trustworthy literature on Robotics during the course "Multibody dynamics and its applications in Robotics and automobile Engineering". However, it is a WIP, though already advanced. Hence, contributions are welcome. In case you are interested on contributing with a comment, issue or pull request, report on the issue tab or make a pull request.

In case you are interested on a more mature material, take a look at http://petercorke.com/wordpress/toolboxes/robotics-toolbox :) 

### Linux users

If the reader is already familiar with github, skip the next steps. To clone this repository, type the following commands on linux:

```
mkdir ~/github
cd ~/github
git clone git@github.com:brunolnetto/quindim.git 
```

### Windows users

Most likely, the reader may use Windows. For such, the author recommends either the [Git bash](https://gitforwindows.org/) or [Tortoise Git](https://tortoisegit.org/) as source management software. Git bash is a terminal and the copy-paste of above commands works the same manner as for linux terminal. Typically the home path given by tilde '~' lays on ```$PROGRAM_FILES/Users```

## Additional libraries

There are two utilitaries for the current library, which are not on it to avoid a greater library than it is already. Follow the instructions below:

1) Clone the repositories below in the same manner as in the "Introduction" section:
    - ```matlab-utils```: ```https://github.com/brunolnetto/matils```;
    
2) Add the repositories to MATLAB path as on "Installation" section.

## Installation

If you wish to use it, follow the instructions:

1) Open Matlab up to the version 2017x, x = a, b;
2) Change directory with ```cd ~/quindim/```;
3) Type "loadlibs.m", without quotes.

## Reproduce an example

Go to folder ```$QUINDIM_PATH/examples```, choose one of them, open the folder ```code``` and run ```main``` command on MATLAB terminal line.

## Documentation
It is still small, but take a look at wiki: https://github.com/asmove/quindim/wiki

## Reference

- Alberto Isidori. 1995. Nonlinear Control Systems (3rd ed.). M. Thoma, E. D. Sontag, B. W. Dickinson, A. Fettweis, J. L. Massey, and J. W. Modestino (Eds.). Springer-Verlag, Berlin, Heidelberg.
- A Jazar, Reza N; T Vehicle dynamics: theory and application; D 2017; I Springer;
- Baruh, Haim. Analytical dynamics. Boston: WCB/McGraw-Hill, 1999.
- Bloch, A. M. (2003). Nonholonomic mechanics. In Nonholonomic mechanics and control (pp. 207-276). Springer, New York, NY.
- John J. Craig. 1989. Introduction to Robotics: Mechanics and Control (2nd ed.). Addison-Wesley Longman Publishing Co., Inc., Boston, MA, USA.;
- Slotine, J. J.; LI, W.; "Applied nonlinear control", Prentice Hall, 1st Ed., 1991.



