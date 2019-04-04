#!/usr/bin/env cwl-runner

# Runs a magicblast search and produces SAM output
#
# magicblast -query query.fasta -db database.fasta  -num_threads 4 
#  -out blast.out

cwlVersion: v1.0
class: CommandLineTool
label: Example CWL script to run a BLAST search in docker
baseCommand: magicblast
hints:
  DockerRequirement:
    dockerPull: ncbi/magicblast
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
  sra_flag:
    type: string?
    inputBinding:
        position: 2
        prefix: -sra
  db_flag:
    type: string 
    inputBinding:
        position: 3
        prefix: -db
  num_threads_flag:
    type: int? 
    default: 4
    inputBinding:
        position: 4
        prefix: -num_threads
  taxid_flag:
     type: string?
     inputBinding:
        position: 5
        prefix: -taxids
  out_flag:
    type: string 
    default: "magicblast.sam"
    inputBinding:
        position: 6
        prefix: -out
  outfmt_flag:
    type: string 
    default: "sam"
    inputBinding:
        position: 7
        prefix: -outfmt

outputs:
  magicblast_results:
     type: File
     outputBinding:
        glob: $(inputs.out_flag) 

