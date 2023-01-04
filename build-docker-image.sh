#/bin/bash
# Download cuda 11.7
set -x
CUDA_INSTALLER="cuda_11.7.0_515.43.04_linux.run"
CUDNN_TAR_BALL="cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz"
TensorRT_TAR_BALL="TensorRT-8.5.2.2.Linux.x86_64-gnu.cuda-11.8.cudnn8.6.tar.gz"
if [ ! -f ${CUDA_INSTALLER} ]; then
    #echo "Get https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/${CUDA_INSTALLER}" 
    wget http://10.169.20.114:20080/nvidia/cuda/11/${CUDA_INSTALLER}
fi
# Download cudnn 
if [ ! -f ${CUDNN_TAR_BALL} ]; then
    #echo "Get  https://developer.nvidia.com/compute/cudnn/secure/8.6.0/local_installers/11.8/${CUDNN_TAR_BALL} on Web Browser and copy it here"
    wget http://10.169.20.114:20080/nvidia/cudnn/8.6/${CUDNN_TAR_BALL}
fi
# Download TensorRT 8.5.2.2
if [ ! -f ${TensorRT_TAR_BALL} ]; then
    #echo "Get https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/secure/8.5.2/tars/${TensorRT_TAR_BALL} on web browser and copy it here"
    wget http://10.169.20.114:20080/nvidia/TensorRT/8.5/${TensorRT_TAR_BALL}
fi
set +x
docker build . -t testimage:latest