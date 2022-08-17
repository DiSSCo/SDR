cwlVersion: v1.2
class: CommandLineTool

baseCommand: [/bin/bash, '-c']

doc: |
  Creates an output folder for Mothra

hints:
  DockerRequirement:
    dockerPull: oliverwoolland/mothra:latest

inputs:
  generate_metdir:
    type: boolean

  script:
    type: string?
    default: |
      mkdir ./mothra-output
    inputBinding:
      position: 1

outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: "mothra-output"
