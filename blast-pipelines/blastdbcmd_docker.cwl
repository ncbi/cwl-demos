#!/usr/bin/env cwl-runner

# Runs blastdbcmd 

cwlVersion: v1.0
class: CommandLineTool
label: Blastdbcmd to dump seqs/info.
baseCommand: blastdbcmd
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
    type: Directory
  entry_flag:
    type: string?
    inputBinding:
        position: 1
        prefix: -entry
  entry_batch_flag:
    type: File?
    inputBinding:
        position: 2
        prefix: -entry_batch
  db_flag:
    type: string 
    inputBinding:
        position: 3
        prefix: -db
  taxids_flag:
     type: string?
     inputBinding:
        position: 4
        prefix: -taxids
  target_flag:
     type: boolean?
     inputBinding:
        position: 4
        prefix: -target_only
  out_flag:
    type: string 
    default: "blastdbcmd.out"
    inputBinding:
        position: 5
        prefix: -out
  outfmt_flag:
    type: string? 
    inputBinding:
        position: 6
        prefix: -outfmt

outputs:
  blastdbcmd_results:
     type: File
     outputBinding:
        glob: $(inputs.out_flag) 

