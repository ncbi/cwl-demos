class: CommandLineTool
cwlVersion: v1.0
label: Process two tabular BLAST outputs and return RBHs
doc: Process two tabular BLAST outputs and return RBHs
# Path needs to be changed prior to demo
baseCommand: blast_rbh_report.py

inputs:
    blast_output_1:
        type: File
        inputBinding:
            position: 2
    blast_output_2:
        type: File
        inputBinding:
            position: 3
    out_file:
        type: string
        inputBinding:
            position: 1
            prefix: -o

outputs:
    rbh:
        type: File
        outputBinding:
            glob: $(inputs.out_file)


