#!/usr/bin/env cwl-runner

# using dockerized version of score_blast.py
# score_blast.py -q query.fasta -b blast.out -out outlier.txt
# docker:
#   ncbi/outlier-hit-detection
#    
cwlVersion: v1.0
class: CommandLineTool
baseCommand: score_blast.py
hints:
  DockerRequirement:
    dockerPull: ncbi/outlier-hit-detection
inputs:
  q_flag:
    type: File?
    inputBinding:
        position: 1
        prefix: -q
  b_flag:
    type: File?
    inputBinding:
        position: 2
        prefix: -b
  out_flag:
    type: string
    default: "outlier.txt"
    inputBinding:
        position: 3
        prefix: -out

outputs:
  outlier_results:
     type: File
     outputBinding:
        glob: $(inputs.out_flag)

