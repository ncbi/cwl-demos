#!/usr/bin/env cwl-runner

# Nested CWL file that runs BlastP twice and then runs the RBH_python script to compares results in tab delimited file.
# This workflow has three steps:
# 1) run BLAST for sequence 1
# 2) run BLAST for sequence 2
# 3) run a python script for RBH

cwlVersion: v1.0
class: Workflow
label: BlastP_RBH_workflow
inputs:
  user_db_dir: Directory
  user_query1: File
  user_query2: File
  user_db_flag:   string
  user_outfmt_flag: string
  user_out_results: string
  user_taxid_flag1: string
  user_taxid_flag2: string
  user_num_threads_flag: int?
  user_out_flag1: string
  user_out_flag2: string



outputs:
  blast_out_class:
    type: File
    outputSource: rbh_python/rbh

requirements:
  SubworkflowFeatureRequirement: {}

steps:
  blast_step1:
    run: blastp_docker.cwl
    in:
      query_flag: user_query1
      db_flag: user_db_flag
      blastdb_dir: user_db_dir
      taxid_flag: user_taxid_flag1
      num_threads_flag: user_num_threads_flag
      outfmt_flag: user_outfmt_flag
      out_flag: user_out_flag1
    out: [blast_results]

  blast_step2:
    run: blastp_docker.cwl
    in:
      query_flag: user_query2
      db_flag: user_db_flag
      blastdb_dir: user_db_dir
      taxid_flag: user_taxid_flag2
      num_threads_flag: user_num_threads_flag
      outfmt_flag: user_outfmt_flag
      out_flag: user_out_flag2
    out: [blast_results]

  rbh_python:
    run: python_step.cwl
    in:
      blast_output_1: blast_step1/blast_results
      blast_output_2: blast_step2/blast_results
      out_file: user_out_results
    out: [rbh]
