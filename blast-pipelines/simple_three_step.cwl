#!/usr/bin/env cwl-runner
# This is a simple workflow that consists of three steps:
#  1.) run BLAST of some flavor.
#  2.) parse the output based on length, %id of matches
#  3.) do something with the information from 2.)
#
# In this case, the second step is a python script and
# the third step calls blastdbcmd

cwlVersion: v1.0
class: Workflow
label: BLASTP, parse, dump FASTA
inputs:
  user_db_dir: Directory?
  user_query: File
  user_search_db:   string
  user_parse_results: string
  user_outfmt_flag: string
  user_length_flag: int
  user_percent_flag: float
  user_idsonly_flag: int
  user_fasta_results: File
  user_target_flag: boolean?

outputs:
  blast_out_class:
    type: File
    outputSource: blastdbcmd_step/blastdbcmd_results

steps:
    blast_step:
      run: blastp_docker.cwl
      in:
         query_flag: user_query
         db_flag: user_search_db
         blastdb_dir: user_db_dir
         outfmt_flag: user_outfmt_flag
      out : [blast_results]
    parse_blast_step:
      run: parse_blast_report.cwl
      in:
        length_flag: user_length_flag
        percent_flag: user_percent_flag
        idsonly_flag: user_idsonly_flag
        in_flag: blast_step/blast_results
        out_flag: user_parse_results
      out: [parse_blast_results]
    blastdbcmd_step:
      run: blastdbcmd_docker.cwl
      in:
        entry_batch_flag: parse_blast_step/parse_blast_results
        db_flag: user_search_db
        blastdb_dir: user_db_dir
        target_flag: user_target_flag
      out: [blastdbcmd_results]
