$description=How to build and compile software on linux
$keywords=build, compile
$title=Packages, Building & Compiling


There are two basic ways to install software on a Linux server: 1) to use the in-built package manager (yum, apt, pacman, etc) and 2) to build the application from the source code using a compiler (gcc, gcc-c++, etc).


The package manager is the quickest and easiest way to install (and update) software, however the latest releases of software are often slow to migrate into the package managers. If you want total control over the version and any addon modules included when installing software, you should compile it yourself.


#### Building & Compiling

There are lots of different compilers, langauges, etc, but for the most part Linux software can be built and installed like so:

    ./configure <any config options>
    make
    sudo make install


The first command sets up the 'build plan' if you like, telling the compiler where various files are located, which addons to compile, etc, etc. The second command "make" does the actual compiling. Finally "make install" installs the application you just built to the default location (unless changed in the ./configure stage).