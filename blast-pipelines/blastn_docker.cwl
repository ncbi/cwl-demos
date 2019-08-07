#!/usr/bin/env cwl-runner

# 7 qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore
#
# blastn -query query.fasta  -db database.fasta  -num_threads 4 -task megablast
#  -out blast.out
# -outfmt "7 qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore"
cwlVersion: v1.0
class: CommandLineTool
label: Example CWL script to run a BLAST search in docker
baseCommand: blastn
hints:
  DockerRequirement:
    dockerPull: ncbi/blast
requirements:
- class: EnvVarRequirement
  envDef:
  - envName: BLASTDB
    envValue: $(inputs.blastdb_dir.path)
inputs:
  blastdb_dir:
    type: Directory?
  query_flag:
    type: File?
    inputBinding:
        position: 1
        prefix: -query
  db_flag:
    type: string 
    inputBinding:
        position: 2
        prefix: -db
  num_threads_flag:
    type: int 
    default: 4
    inputBinding:
        position: 3
        prefix: -num_threads
  task_flag:
    type: string 
    default: "megablast"
    inputBinding:
        position: 4
        prefix: -task
  out_flag:
    type: string 
    default: "blast.out"
    inputBinding:
        position: 5
        prefix: -out
  outfmt_flag:
    type: string 
    default: "7 qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore"
    inputBinding:
        position: 6
        prefix: -outfmt

outputs:
  blast_results:
     type: File
     outputBinding:
        glob: $(inputs.out_flag) 

