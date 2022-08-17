cwlVersion: v1.2
class: CommandLineTool

#baseCommand: [/bin/bash, '-c']
baseCommand: ["python", "/mothra-src/mothra/pipeline.py", "-p", "-csv", "./results.csv"]

doc: |
  This tool runs the mothra image recognition and processing tool


hints:
  DockerRequirement:
    dockerPull: oliverwoolland/mothra:latest
    #dockerPull: alpine:3.14

#requirements:
#  LoadListingRequirement:
#    loadListing: shallow_listing
#  InitialWorkDirRequirement:
#      - entry: $(inputs.inputImages.listing)
#        entryname: mothra-inputs

# arguments: 
#   - valueFrom: "/input_images"
#     position: 2

inputs:
  inputImages:
    type: Directory
    inputBinding:
      position: 6
      prefix: '-i'
  outputImages:
    type: Directory
    inputBinding:
      position: 8
      prefix: '-o'

# outputs:
#   outputImages:
#     type:
#       type: array
#       items: File
#     outputBinding:
#       glob: "*.JPG"
#   csv:
#     type: File
#     outputBinding:
#       glob: "results.csv"

outputs:
  example_out:
    type: stdout
