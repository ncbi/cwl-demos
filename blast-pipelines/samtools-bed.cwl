#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: samtools-docker.yml
- class: InlineJavascriptRequirement

stdout: $(inputs.output_file)
inputs:
  bedfile:
    type: File
    inputBinding:
      position: 1
  input:
    type: File
    secondaryFiles: .bai
    inputBinding:
      position: 4
  output_file:
    type: string
    default: bedcov.out

outputs:
  output:
    type: stdout

baseCommand: [samtools, bedcov]
$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/docs/schema_org_rdfa.html

s:mainEntity:
  $import: samtools-metadata.yaml

