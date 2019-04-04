#!/usr/bin/env cwl-runner

# Run PYTHON script on blast results
# parse_blast_report.py 150 40 blastp.out temp.out 
#   blastp.out should be tabular output 

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /home/madden/CWL_FILES/parse_blast_report.py
inputs:
  length_flag:
    type: int
    inputBinding:
      position: 1
  percent_flag:
    type: float
    inputBinding:
      position: 2
  idsonly_flag:
    type: int
    inputBinding:
      position: 3
  in_flag:
    type: File
    inputBinding:
      position: 4
  out_flag:
    type: string
    default: "parse_blast.tab"
    inputBinding:
      position: 5

outputs:
  parse_blast_results:
     type: File
     outputBinding:
        glob: $(inputs.out_flag)
