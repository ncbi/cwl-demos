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

# run makeblastdb program using ncbi/blast:latest docker image
# input: database.fasta
# output: ./blastdb/user_db.* 
# attention:
#       in this example output BLAST DB name is 'user_db'
# command line (example): makeblastdb -in database.fasta -out user_db  -dbtype nucl

if [ ! -d blastdb ] ; then
	mkdir blastdb
	if [ -d blastdb ] ; then
		echo "INFO: local 'blastdb' dicrectory created"
	else
		echo "ERROR: can't create 'blastdb' directory in current location:"
		pwd
		exit 1
	fi	
fi	
#
# docker file system mount instructions:
#  current directory will be mounted read/write under name '/in_out' inside docker image
#
DOCKER_MOUNT_1=`pwd`:/in_out:rw
#DEBUG/INFO: show files in output directory: docker run  --rm -ti --volume $DOCKER_MOUNT_1 ncbi/blast:latest  bash -c "ls -l /in_out/blastdb/"
docker run  --rm -ti --volume $DOCKER_MOUNT_1 ncbi/blast:latest makeblastdb -in /in_out/database.fasta -out /in_out/blastdb/user_db  -dbtype nucl
if [ ! -f ./blastdb/user_db.nhr ] ; then
	echo "ERROR: file ./blastdb/user_db.nhr  is missing, most likely BLAST DB creation step FAILED"
	exit 1
fi	
echo "INFO: generated BLASTDB files:"
ls -l ./blastdb
