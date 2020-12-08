#!/usr/bin/env cwl-runner

# Runs blast_formatter to produce output
# 6 qseqid sseqid bitscore pident qcovhsp qlen length
#
# blast_formatter -archive 
#  -out blast.out
# -outfmt "7 std sscinames"

cwlVersion: v1.0
class: CommandLineTool
label: blast_formatter
baseCommand: blast_formatter
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
  archive_flag:
    type: File
    inputBinding:
        position: 1
        prefix: -archive
  out_flag:
    type: string 
    default: "blast.tab"
    inputBinding:
        position: 2
        prefix: -out
  outfmt_flag:
    type: string 
    default: "7"
    inputBinding:
        position: 3
        prefix: -outfmt

outputs:
  blast_results:
     type: File
     outputBinding:
        glob: $(inputs.out_flag) 

