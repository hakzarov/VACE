#!/bin/bash

# Example of using the new prompt_file parameter
# This demonstrates how to use a text file as the source for the prompt

# Using the test prompt file with the inpainting example
python vace/vace_wan_inference.py \
  --src_video "benchmarks/VACE-Benchmark/assets/examples/inpainting/src_video.mp4" \
  --src_mask "benchmarks/VACE-Benchmark/assets/examples/inpainting/src_mask.mp4" \
  --prompt_file "test_prompt.txt"

# You can also combine prompt_file with other parameters
# python vace/vace_wan_inference.py \
#   --src_video "benchmarks/VACE-Benchmark/assets/examples/outpainting/src_video.mp4" \
#   --src_mask "benchmarks/VACE-Benchmark/assets/examples/outpainting/src_mask.mp4" \
#   --prompt_file "test_prompt.txt" \
#   --sample_steps 60
