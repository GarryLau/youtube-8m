
CUDA_VISIBLE_DEVICES=0 python train.py \
	--train_dir="../model/lstmmemory_moe8_lowres/" \
	--frame_features=True \
	--feature_names="rgb,audio" \
	--feature_sizes="1024,128" \
	--train_data_pattern="/Youtube-8M/data/frame/train/train*" \
	--batch_size=256 \
	--moe_num_mixtures=8 \
	--model=LstmMemoryModel \
	--feature_transformer=ResolutionTransformer \
	--num_readers=4 \
	--base_learning_rate=0.0008 \
	--lstm_cells=1024 \
	--lstm_layers=2 \
	--rnn_swap_memory=True
