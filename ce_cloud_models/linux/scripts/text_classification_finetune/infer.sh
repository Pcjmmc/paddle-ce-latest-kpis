#unset http_proxy
HTTPPROXY=$http_proxy
HTTPSPROXY=$https_proxy
unset http_proxy
unset https_proxy

#外部传入参数说明
# $1:  $XPU = gpu or cpu
#获取当前路径
cur_path=`pwd`
model_name=${PWD##*/}

echo "$model_name 模型样例测试阶段"

#路径配置
root_path=$cur_path/../../
code_path=$cur_path/../../models_repo/examples/text_classification/pretrained_models/
log_path=$root_path/log/$model_name/
mkdir -p $log_path
#临时环境更改
cd $root_path/models_repo

#访问RD程序
cd $code_path

DEVICE=$1
if [[ ${DEVICE} == "gpu" ]]; then
N_GPU=1
else
N_GPU=0
fi
MULTI=$2
if [[ ${MULTI} == "multi" ]]; then
N_GPU=2
fi

print_info(){
if [ $1 -ne 0 ];then
    cat ${log_path}/$2.log
    echo "exit_code: 1.0" >> ${log_path}/$2.log
else
    echo "exit_code: 0.0" >> ${log_path}/$2.log
fi
}

python predict.py \
  --params_path checkpoints/model_300/model_state.pdparams \
  --device ${DEVICE} > $log_path/infer_${DEVICE}.log 2>&1

print_info $? infer_${DEVICE}

if [[ ${MULTI} == "multi" ]]; then
    mv $log_path/infer_${DEVICE}.log $log_path/infer_${DEVICE}_multi.log
fi

#set http_proxy
export http_proxy=$HTTPPROXY
export https_proxy=$HTTPSPROXY
