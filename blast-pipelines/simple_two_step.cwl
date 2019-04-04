#!/usr/bin/env cwl-runner
# This is a simple workflow that consists of two steps:
#  1.) run BLAST of some flavor.
#  2.) Do something with the output. 
#
#  The second step may be as easy as running an awk script, but 
#  demonstrates the principle and the second step can be modified 
#  to do something more interesting.

cwlVersion: v1.0
class: Workflow
inputs:
  user_db_dir: Directory?
  user_query: File
  user_search_db:   string
  user_parse_results: string
  user_outfmt_flag: string
  user_length_flag: int
  user_percent_flag: float
  user_idsonly_flag: int

outputs:
  blast_out_class:
    type: File
    outputSource: parse_blast_step/parse_blast_results

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
