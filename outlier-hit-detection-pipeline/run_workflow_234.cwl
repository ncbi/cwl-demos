#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
inputs:
  user_db_dir: Directory?
  user_query: File?
  user_search_db:   string
  user_search_db_tsv:   File?
  user_workflow_results: string

outputs:
  blast_out_class:
    type: File
    outputSource: assign_taxon_step/assign_taxon_results

steps:
    blast_step:
      run: blastn_docker.cwl
      in:
         query_flag: user_query
         db_flag: user_search_db
         blastdb_dir: user_db_dir
      out : [blast_results]
    outlier_step:
      run: outlier_docker.cwl
      in:
        q_flag: user_query
        b_flag: blast_step/blast_results
      out: [outlier_results]
    assign_taxon_step:
      run: assign_taxon_docker.cwl
      in:
         t_flag: user_search_db_tsv
         o_flag: outlier_step/outlier_results
         out_flag: user_workflow_results
      out: [assign_taxon_results]

