GPU_ID=1
EVERY=1000
MODEL=MoeDistillChainModel
MODEL_DIR="../model/frame_level_lstm_multiscale_distillchain_model"
EVAL_DIR="../model/frame_level_lstm_multiscale_distillchain_model"
start=0
DIR="$(pwd)"

for checkpoint in $(cd $MODEL_DIR && python ${DIR}/training_utils/select.py $EVERY); do
 	echo $checkpoint;
	if [[ $checkpoint -gt $start ]]; then

 		echo $checkpoint;
		CUDA_VISIBLE_DEVICES=$GPU_ID python eval_distill.py \
 			 --train_dir="$EVAL_DIR" \
			--model_checkpoint_path="${MODEL_DIR}/model.ckpt-${checkpoint}" \
			--eval_data_pattern="/Youtube-8M/data/frame/validate/validatea*" \
			--distill_data_pattern="/Youtube-8M/model_predictions/validatea/distillation/ensemble_mean_model/*.tfrecord" \
			--frame_features=True \
			--feature_names="rgb,audio" \
			--distill_names="predictions" \
			--feature_sizes="1024,128" \
			--distill_sizes="4716" \
			--batch_size=64 \
			--model=$MODEL \
			--moe_num_extend=2 \
			--moe_num_mixtures=4 \
			--cnn_cells=256 \
			--distillation_features=True \
		   	--distillation_type=0 \
			--ensemble_w=0.2 \
			--train=False \
			--run_once=True
	fi
done