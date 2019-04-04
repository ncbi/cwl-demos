#!/usr/bin/env python3
""" Parse BLAST output and return only matches that meet
    a specific length (or coverage) and identity requirement.
    Three arguments should be provided on the command-line:
       length 
       identity
       tabular BLAST input file
       output file

    tabular file should have output compatible with:
       "6 qaccver saccver bitscore pident qcovhsp qlen length staxids sscinames"
"""
import sys

# parses tabular output looking for matches that meet criteria, returns 
# dictionary of matches
def parse_report(length, identity, ids_only, in_file):
# Loosely based on best_hits loop from PJC
    results = dict()
    with open(in_file) as h:
        for line in h:
            if line.startswith("#"):
                continue
            line.strip("\n\t")
            parts = line.split()
            if int(parts[5]) < length or float(parts[3]) < identity :
                continue
            if ids_only == 1:
                results[parts[1]] = parts[1]
            else:
                results[parts[1]] = line
    return results


def main():
    if len(sys.argv) != 6:
        print("Usage: %s length, identity (percent), subjectIDsOnly(1=true,0=false) infile, outfile \n", sys.argv[0])
        sys.exit()

    length = int(sys.argv[1])
    identity = float(sys.argv[2])
    ids_only = int(sys.argv[3])
    in_file = sys.argv[4]
    out_file = sys.argv[5]
    results = parse_report(length, identity, ids_only, in_file)
    with open(out_file, "w") as out:
         for value in results.values():
            out.write(value)
            if ids_only == 1:
                out.write("\n")

if __name__ == '__main__':
        main()

