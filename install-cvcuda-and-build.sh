#/bin/bash
# Download cuda 11.7
set -x
TARGET_DIR=${HOME}/.local
if [ "${1}" != "" ]; then
    TARGET_DIR=${1}
fi
CUDA_INSTALLER="cuda_11.7.0_515.43.04_linux.run"
CUDNN_TAR_BALL="cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz"
TensorRT_TAR_BALL="TensorRT-8.5.2.2.Linux.x86_64-gnu.cuda-11.8.cudnn8.6.tar.gz"
if [ ! -f ${CUDA_INSTALLER} ]; then
    wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/${CUDA_INSTALLER}
fi
# Download cudnn 
if [ ! -f ${CUDNN_TAR_BALL} ]; then
    wget https://developer.nvidia.com/compute/cudnn/secure/8.6.0/local_installers/11.8/${CUDNN_TAR_BALL}
fi
# Download TensorRT 8.5.2.2
if [ ! -f ${TensorRT_TAR_BALL} ]; then
    wget https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/secure/8.5.2/tars/${TensorRT_TAR_BALL}
fi

# Prepare the base directory
mkdir -p ${TARGET_DIR}

# Install CUDA 11.7
chmod +x ${CUDA_INSTALLER}
CUDA_ROOT=${TARGET_DIR}/cuda_11.7
./${CUDA_INSTALLER} --toolkit --toolkitpath=${CUDA_ROOT} --silent

# Install CUDNN 8.6.0
CUDNN_ROOT=${TARGET_DIR}/cudnn-8.6.0
mkdir -p ${CUDNN_ROOT}
tar xf ${CUDNN_TAR_BALL} -C ${CUDNN_ROOT} --strip-components=1

# Install TensorRT
TensorRT_ROOT=${TARGET_DIR}/TensorRT-8.5.2.2
mkdir -p ${TensorRT_ROOT}
tar xzf ${TensorRT_TAR_BALL} -C ${TensorRT_ROOT} --strip-components=1
set +x

echo ""
echo "Please go to https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html#installing-tar and follow more steps for python environment"
echo "and add this block to your environment file or run all from a shell"
echo ""
echo "export PATH=${CUDA_ROOT}/bin:\$PATH"
echo "export LD_LIBRARY_PATH=${CUDA_ROOT}/lib64:\$LD_LIBRARY_PATH"
echo "export LD_LIBRARY_PATH=${CUDNN_ROOT}/lib:\$LD_LIBRARY_PATH"
echo "export C_INCLUDE_PATH=${CUDNN_ROOT}/include:\$C_INCLUDE_PATH"
echo "export PATH=${TensorRT_ROOT}/bin:\$PATH"
echo "export LD_LIBRARY_PATH=${TensorRT_ROOT}/lib:\$LD_LIBRARY_PATH"

export PATH=${CUDA_ROOT}/bin:$PATH
export LD_LIBRARY_PATH=${CUDA_ROOT}/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${CUDNN_ROOT}/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=${CUDNN_ROOT}/include:$C_INCLUDE_PATH
export PATH=${TensorRT_ROOT}/bin:$PATH
export LD_LIBRARY_PATH=${TensorRT_ROOT}/lib:$LD_LIBRARY_PATH

# Download cvcuda and build it as 'release' mode
git clone https://github.com/CVCUDA/CV-CUDA cvcuda
cd cvcuda
./init_repo.sh
MAKE_OPTS="-j8" ./ci/build.sh build
./ci/build_samples.sh build \
    -DCMAKE_PREFIX_PATH=${TensorRT_ROOT}/lib \
    -DTensorRT_INCLUDE_DIR=${TensorRT_ROOT}/include