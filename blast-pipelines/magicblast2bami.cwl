#!/usr/bin/env cwl-runner
#
# Run magic-BLAST and convert the SAM file into an indexed BAM.
# Also requires workflows and docker from 
# https://github.com/common-workflow-language/workflows/tree/master/tools

cwlVersion: v1.0
class: Workflow
inputs:
  user_db_dir: Directory
  user_query: File?
  user_sra_flag: string?
  user_num_threads_flag: int?
  user_search_db:   string
  user_outfmt_flag: string
  user_isbam_flag: boolean
  user_view_results: string
  user_sort_results: string

outputs:
  magicblast_out_class:
    type: File
    outputSource: samtools_index_step/alignments_with_index
    

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
    samtools_view_step:
      run: samtools-view.cwl
      in:
        isbam_flag: user_isbam_flag
        input: magicblast_step/magicblast_results
        output_name: user_view_results
      out: [output]
    samtools_sort_step:
      run: samtools-sort.cwl
      in: 
        input: samtools_view_step/output
        output_name: user_sort_results
      out: [sorted]
    samtools_index_step:
      run: samtools-index.cwl
      in:
        alignments: samtools_sort_step/sorted
      out: [alignments_with_index]
