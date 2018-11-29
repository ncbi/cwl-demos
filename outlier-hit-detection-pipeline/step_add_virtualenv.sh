#!/bin/sh
#
# this script is an example and part of complex workflow
# descrived in article:
# "Outlier detection in BLAST hits" 
# by Shah N, Altschul SF, Pop M
#
# PMID: 29588650 PMCID: PMC5863388 DOI: 10.1186/s13015-018-0126-3
# https://www.ncbi.nlm.nih.gov/pubmed/29588650
#
# sources:
# https://github.com/shahnidhi/outlier_in_BLAST_hits
#
#

#
# this script will install Python virtual environment to the MY_VENV directory
# input: MY_VENV - directory provided via environment

if [  "X$1" = "X" ] ; then
	echo "ERROR: please set call this script with directory name"
	exit 1
fi

VENV=$1

if [ ! -d ${VENV} ] ; then
	virtualenv -p python ${VENV}
fi

if [ ! -f "${VENV}/bin/activate" ] ; then
	echo "ERROR: Can't create virtual environment in $VENV"
	exit 1
fi

. ${VENV}/bin/activate && pip install -q -r requirements.txt

exit 0

