#!/usr/bin/env cwl-runner

# Runs a BLASTX search producing tabular output.  
# 6 qseqid sseqid bitscore pident qcovhsp qlen length
#
# blastx -query query.fasta  -db database.fasta  -num_threads 4 
#  -out blast.out
# -outfmt " 6 qseqid sseqid bitscore pident qcovhsp qlen length "

cwlVersion: v1.0
class: CommandLineTool
label: BLASTX search.
baseCommand: blastx
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
    type: File
    inputBinding:
        position: 1
        prefix: -query
  db_flag:
    type: string 
    inputBinding:
        position: 2
        prefix: -db
#        valueFrom: $(inputs.blastdb_dir.path)/$(inputs.db_flag)
  num_threads_flag:
    type: int? 
    default: 4
    inputBinding:
        position: 3
        prefix: -num_threads
  taxid_flag:
     type: string?
     inputBinding:
        position: 5
        prefix: -taxids
  out_flag:
    type: string 
    default: "blastx.out"
    inputBinding:
        position: 6
        prefix: -out
  outfmt_flag:
    type: string 
    default: "6 qaccver saccver bitscore pident qcovhsp qlen length"
    inputBinding:
        position: 7
        prefix: -outfmt

outputs:
  blast_results:
     type: File
     outputBinding:
        glob: $(inputs.out_flag) 

