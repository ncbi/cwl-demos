#!/bin/bash

# From http://bioinformatics.cvr.ac.uk/blog/essential-awk-commands-for-next-generation-sequence-analysis/
# Get all reads, excluding headers.
#
cat $1 | awk '$1!~/^@/' > $2
