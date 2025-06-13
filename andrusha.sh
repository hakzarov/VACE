#!/usr/bin/env bash

source .venv/bin/activate

# export CUDA_VISIBLE_DEVICES=0,1

# python vace/vace_pipeline.py \
#  --base wan \
#  --task depth \
#  --video assets/videos/andrusha-fuck-0.mp4 \
#  --prompt "The person eats its own middle finger"

#  --prompt "The person turns camera and exposes nuclear explosion"
#  --prompt "Andrusha turns into a monster with 10 tentacles and eats cars"
#  --prompt "The sky is red. There's nuclear explosion mushroom growing in the background. Cars start catching fire and eventually explode."

# python vace/vace_ltx_inference.py \
#  --src_video "assets/videos/andrusha-1.mp4" \
#  --prompt "The sky is red. There's nuclear explosion mushroom growing in the background. Cars start catching fire and eventually explode."


# python vace/vace_ltx_inference.py \
#  --src_ref_images "assets/videos/andrusha-face-0.png" \
#  --prompt "The person laughs and turns camera exposing nuclear explosion over Toronto"

# while :; do
#     python vace/vace_wan_inference.py \
#     --src_ref_images "assets/images/andrusha-face-1.jpg" \
#     --prompt "" 
# done
    # --prompt "Andrei is screaming like in Van Gogh's painting" 
    
    # --use_prompt_extend wan_en

# torchrun --nproc_per_node=2 vace/vace_wan_inference.py \
#  --dit_fsdp \
#  --t5_fsdp \
#  --ulysses_size 2 \
#  --ring_size 1 \
#  --size 720p \
#  --model_name 'vace-14B' \
#  --ckpt_dir 'models/Wan2.1-VACE-14B/' \
#  --src_video 'assets/videos/andrusha-fuck-0.mp4' \
#  --src_ref_images assets/images/andrusha-face-1.jpg \
#  --prompt "The person eats its own middle finger" \
#  2>&1

# #  --src_mask <path-to-src-mask> \
#  --ckpt_dir 'models/Wan2.1-VACE-14B/...' \

# python vace/vace_wan_inference.py \
#  --ckpt_dir 'models/Wan2.1-VACE-1.3B/' \
#  --src_video 'assets/videos/andrusha-fuck-0.mp4' \
#  --src_ref_images assets/images/andrusha-face-1.jpg \
#  --prompt "The person eats its own middle finger"

# torchrun \
#  --nproc_per_node=8 \
#  vace/vace_wan_inference.py \
#  --dit_fsdp \
#  --t5_fsdp \
#  --ulysses_size 1 \
#  --ring_size 8 \
#  --ckpt_dir 'models/Wan2.1-VACE-1.3B/' \
#  --src_video 'assets/videos/andrusha-fuck-0.mp4' \
#  --src_ref_images assets/images/andrusha-face-1.jpg \
#  --prompt "The person eats his own middle finger"

while :; do
    for prompt_file in $(ls assets/prompts/*); do
        echo "Processing ${prompt_file}"
        filename=$(basename "$prompt_file")
        echo "Filename: ${filename}"
        # python vace/vace_wan_inference.py \
        #     --src_ref_images "assets/images/andrusha-face-1.jpg" \
        #     --frame_num 240 \
        #     --prompt_file "${prompt_file}"w
        # pip install "xfuser>=0.4.1"
        torchrun --nproc_per_node=2 \
            vace/vace_wan_inference.py \
            --dit_fsdp \
            --t5_fsdp \
            --ulysses_size 1 \
            --ring_size 2 \
            --ckpt_dir "models/Wan2.1-VACE-1.3B/" \
            --src_ref_images "assets/images/andrusha-face-1.jpg" \
            --prompt_file "${prompt_file}" 

        echo "Moving..."
        mv "/home/user/projects/VACE/assets/prompts/${filename}" \
           "/home/user/projects/VACE/assets/prompts/used/${filename}"
    done
    echo "\n\n\!nERROR\!n\n\n"
    # python vace/vace_wan_inference.py \
    #     --src_ref_images "assets/images/andrusha-face-1.jpg" \
    #     --frame_num 48 \
    #     --prompt "" # random.
done