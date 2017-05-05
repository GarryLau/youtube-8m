
GPU_ID="1"
EVERY=100
MODEL=LstmMemoryModel
MODEL_DIR="../model/lstmmemory_moe8_feature"

start=$1
DIR="$(pwd)"

for checkpoint in $(cd $MODEL_DIR && python ${DIR}/training_utils/select.py $EVERY); do
	echo $checkpoint;
	if [ $checkpoint -gt $start ]; then
		echo $checkpoint;
		CUDA_VISIBLE_DEVICES=$GPU_ID python eval.py \
			--train_dir="$MODEL_DIR" \
			--model_checkpoint_path="${MODEL_DIR}/model.ckpt-${checkpoint}" \
			--eval_data_pattern="/Youtube-8M/data/frame/validate/validatea*" \
			--frame_features=True \
			--feature_names="rgb,audio" \
			--feature_sizes="1024,128" \
			--feature_transformer=EngineerTransformer \
			--engineer_types="identical,avg,std,diff" \
			--batch_size=32 \
			--model=$MODEL \
			--moe_num_mixtures=8 \
			--lstm_layers=2 \
			--rnn_swap_memory=True \
			--run_once=True
	fi
done

