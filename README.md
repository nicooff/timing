# timing
Nek timing using CTIMER

# Compile case:
 # go to compile directory:
cd compile

 # modify SOURCE_ROOT in setup.sh

 # copy local copy of nek:
./setup.sh copy_src

 # compile:
./setup.sh compile

# Run case:
 # copy executable "nek5000" in /bin folder to /test folder 

 # run case normally

# Timing analysis
 # just run the Python script in the case folder
 # for more info, cf. comments in script
./timing.py
