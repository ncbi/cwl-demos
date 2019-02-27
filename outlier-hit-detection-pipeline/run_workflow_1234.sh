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
# this script will run
# a) BLAST DB creation step using dockerized version of the blastmakedb utility
# b) three steps: blast, outliers and final assign taxonomy
# using CWL and dockerized version of BLAST cli utilities and python post processing steps.
#
# BLAST DB location provided to CWL as an absolute path ( in other words as string parameter)
#
# ATTENTION:
# input YML file will be modified on-the-fly. The PATH-TO-BLASTDB will be substituted
#  by current absolute location  of the  'blastdb' directory
#

CWL_PROG="run_workflow_234.cwl"
CWL_INPUT="run_workflow_234_input.yml"

VENV=.venv

#
# input:
#       run_workflow_234.cwl
#       run_workflow_234_input.yml
#       ./blastdb/* 
#       database_taxonomy.tsv
#
# output:
#      consensus_taxonomy.txt -- as specified in CWL_INPUT yml file,  user_workflow_results
#

#
# create Python virtual environment and install nesessary packageg
#
./step_add_virtualenv.sh $VENV



# same for database.fasta
#   wget https://raw.githubusercontent.com/shahnidhi/outlier_in_BLAST_hits/master/example/database.fasta
#
# query.fasta
#   wget https://raw.githubusercontent.com/shahnidhi/outlier_in_BLAST_hits/master/example/query.fasta
#

ARTICLE_FILES="database.fasta query.fasta database_taxonomy.tsv"
for article_item in $ARTICLE_FILES
do
	if [ ! -f ${article_item}  ] ; then
		echo "INFO: missing ${article_item} . linking to a project on GitHUB..."
		ln -s ./outlier_in_BLAST_hits/example/${article_item} .
		if [ -f ${article_item}  ] ; then
	  		echo "INFO: ${article_item} linked. continue"	
		else	
	  		echo "ERROR: can't run: missing: ${article_item}"
	  		exit 1
       		fi  
	fi
done	
#
# STEP#1.0 make BLASTD DB
#
./step_makeblastdb.sh

#STEP #1.1 - modify CWL_INPUTi, substitute PATH-TO-BLASTDB by $PWD/blastdb
if [ ! -f $CWL_INPUT ] ; then
	echo "ERROR: can't find $CWL_INPUT"
	exit 1
fi       
sed -i "s,PATH-TO-BLASTDB, ${PWD}/blastdb," $CWL_INPUT


#
# STEPS 234
#      run blastn and two post processing scripts, all in dockers via CWL workflow
#
. ${VENV}/bin/activate && cwl-runner ${CWL_PROG} ${CWL_INPUT}
