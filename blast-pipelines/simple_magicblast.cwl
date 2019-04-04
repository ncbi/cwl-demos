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
  user_query: File?
  user_sra_flag: string?
  user_num_threads_flag: int?
  user_search_db:   string
  user_awk_results: string
  user_outfmt_flag: string

outputs:
  magicblast_out_class:
    type: File
    outputSource: awk_step/awk_results

steps:
    magicblast_step:
      run: magicblast_docker.cwl
      in:
         query_flag: user_query
         sra_flag: user_sra_flag
         db_flag: user_search_db
         blastdb_dir: user_db_dir
         num_threads_flag: user_num_threads_flag
         outfmt_flag: user_outfmt_flag
      out : [magicblast_results]
    awk_step:
      run: awk.cwl
      in:
        b_flag: magicblast_step/magicblast_results
        out_flag: user_awk_results
      out: [awk_results]
