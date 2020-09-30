#!/usr/bin/env cwl-runner
#
# Run magic-BLAST and convert the SAM file into an indexed BAM.
# Also requires workflows and docker from 
# https://github.com/common-workflow-library/bio-cwl-tools

cwlVersion: v1.0
class: Workflow
inputs:
  user_db_dir: Directory
  user_query: File?
  user_sra_flag: string?
  user_max_intron_flag: int?
  user_num_threads_flag: int?
  user_search_db:   string
  user_outfmt_flag: string
  user_outflag: string

outputs:
  magicblast_out_class:
    type: File
    outputSource: samtools_index_step/bam_sorted_indexed
    

steps:
    magicblast_step:
      run: magicblast_docker.cwl
      in:
         query_flag: user_query
         sra_flag: user_sra_flag
         db_flag: user_search_db
         blastdb_dir: user_db_dir
         num_threads_flag: user_num_threads_flag
         max_intron_flag: user_max_intron_flag
         outfmt_flag: user_outfmt_flag
         out_flag: user_outflag
      out : [magicblast_results]
    samtools_view_step:
      run: samtools_view_sam2bam.cwl
      in:
        sam: magicblast_step/magicblast_results
      out: [bam]
    samtools_sort_step:
      run: samtools_sort.cwl
      in: 
        bam_unsorted: samtools_view_step/bam
      out: [bam_sorted]
    samtools_index_step:
      run: samtools_index.cwl
      in:
        bam_sorted: samtools_sort_step/bam_sorted
      out: [bam_sorted_indexed]

