#!/usr/bin/env cwl-runner

# 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qseq sseq qlen
#
# blastn -query query.fasta  -db database.fasta  -num_threads 4 -task megablast
#  -out blast.out
# -outfmt " 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qseq sseq qlen "
cwlVersion: v1.0
class: CommandLineTool
label: Example CWL script to run a BLAST search in docker
baseCommand: blastn
hints:
  DockerRequirement:
    dockerPull: ncbi/blast
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
        valueFrom: $(inputs.blastdb_dir.path)/$(inputs.db_flag)
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
    default: "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qseq sseq qlen"
    inputBinding:
        position: 6
        prefix: -outfmt

outputs:
  blast_results:
     type: File
     outputBinding:
        glob: $(inputs.out_flag) 

