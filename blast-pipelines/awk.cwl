#!/usr/bin/env cwl-runner

# Run awk on blast results
# awk_script.sh INPUT OUTPUT
#    
cwlVersion: v1.0
class: CommandLineTool
baseCommand: /home/madden/SIMPLE_STEPS/awk_script.sh
inputs:
  b_flag:
    type: File
    inputBinding:
        position: 1
  out_flag:
    type: string
    default: "awk_blast.txt"
    inputBinding:
        position: 2

outputs:
  awk_results:
     type: File
     outputBinding:
        glob: $(inputs.out_flag)
