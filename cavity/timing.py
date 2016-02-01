#!/usr/bin/python

import numpy 
import matplotlib.pyplot as plt

# List of log files where timers are written
file_list = ['logs/cavity_xxt_np2.log', 'logs/cavity_xxt_np6.log']
# List of patterns to identify the different timers
pattern_list = ['tcrsl_min:', 'tcrsl_max:', 'tcrsl_avg:']

# Array containing all timers
# - i = file
# - j = pattern
# - tot_timer[i][j] : array of all timers for file i and pattern j
tot_timer = [[[] for j in range(len(pattern_list))] for i in \
    range(len(file_list))]

# Go through all files
for f in file_list:
    fid = open(f, 'r')
    i = file_list.index(f)
    # Look if pattern is in line   
    for line in fid.readlines():
        for p in pattern_list:
            # If pattern in line, extract time step number and time
            # Append time to tot_timer
            if p in line:
                line = line.split()
                niter = line[0]
                time = line[-1]
                tot_timer[i][pattern_list.index(p)].append(time)

# Go through all files and all patterns and plot corresponding results
for i in range(len(file_list)):
    plt.figure()
    f = file_list[i]
    for j in range(len(pattern_list)):
        p = pattern_list[j]
        plt.plot(range(len(tot_timer[i][j][:])), tot_timer[i][j][:], label=p)
    plt.legend()
    plt.xlabel('Time steps number')
    plt.ylabel('Time [s]')
    plt.title(['Cumulated time (' + f + ')'])
    plt.show()
