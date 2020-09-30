#!/usr/bin/env cwl-runner

# From http://bioinformatics.cvr.ac.uk/blog/essential-awk-commands-for-next-generation-sequence-analysis/
# Get all reads, excluding headers.
#
cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["sh", "awk_script.sh"]
inputs:
  b_flag:
    type: File
    inputBinding:
        position: 1
  out_flag:
    type: string
    default: awk_out.txt
    inputBinding:
        position: 2

requirements:
    InitialWorkDirRequirement:
        listing:
           - entryname: awk_script.sh
             entry: |-
                cat $(inputs.b_flag.path) | awk '$1!~/^@/' 


outputs:
  awk_results:
     type: stdout
stdout: $(inputs.out_flag)
