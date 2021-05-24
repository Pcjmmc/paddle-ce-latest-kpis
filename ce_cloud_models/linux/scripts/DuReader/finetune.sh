#外部传入参数说明
# $1: 'single' 单卡训练； 'multi' 多卡训练； 'recv' 恢复训练
# $2:  $XPU = gpu or cpu
#获取当前路径
cur_path=`pwd`
model_name=${PWD##*/}

echo "$model_name 模型训练阶段"

#取消代理
HTTPPROXY=$http_proxy
HTTPSPROXY=$https_proxy
unset http_proxy
unset https_proxy

#路径配置
root_path=$cur_path/../../
code_path=$cur_path/../../models_repo/examples/machine_reading_comprehension/DuReader/
log_path=$root_path/log/$model_name/
if [ ! -d $log_path ]; then
  mkdir -p $log_path
fi

#访问RD程序
cd $code_path

if [[ ${DEVICE} == "gpu" ]]; then
N_GPU=1
else
N_GPU=0
fi
MULTI=$2
if [[ ${MULTI} == "multi" ]]; then
N_GPU=2
fi

python -u ./run_du.py \
    --model_type bert \
    --model_name_or_path bert-base-chinese \
    --max_seq_length 512 \
    --batch_size 16 \
    --learning_rate 5e-5 \
    --num_train_epochs 4 \
    --logging_steps 1000 \
    --save_steps 1000 \
    --warmup_proportion 0.1 \
    --weight_decay 0.01 \
    --output_dir ./tmp/dureader/ \
    --n_gpu $N_GPU > $log_path/finetune_$2_$1.log 2>&1
#cat $model_name-base_finetune.log
export http_proxy=$HTTPPROXY
export https_proxy=$HTTPSPROXY
