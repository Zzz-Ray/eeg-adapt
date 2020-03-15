hostname
nvidia-smi
# Container starting directory determined by settings in Docker image
# For NVIDIA NGC containers this is normally /workspace
echo Container starts in the directory:
pwd
# Install required packages
# Set environment variable to install packages to world-writable location inside container
export PYTHONUSERBASE=/workspace/.local
# Escaping PYTHONUSERBASE in the next line so that it is expanded inside docker and take the value set inside the container
mkdir -p $PYTHONUSERBASE/bin
export PATH=$PATH:$PYTHONUSERBASE/bin
echo PATH inside container
echo PATH=$PATH
pip install -U -q --no-cache-dir --user braindecode

# change directory to correct location if required
cd /home/users/ntu/kzhang01/hbm/transfer
echo Changed working directory to
pwd

datapath=/home/users/ntu/kzhang01/scratch/KU_mi_smt.h5
modelpath=/home/users/ntu/kzhang01/hbm/transfer/result_base
logpath=/home/users/ntu/kzhang01/hbm/transfer/tasks_adapt
# Fix file locking disabled on this file system (/scratch) when reading hdf5
export HDF5_USE_FILE_LOCKING='FALSE'

python train_adapt.py $datapath $modelpath ./result_adapt/r90 -scheme 1 -trfrate 90 -gpu 0 > $logpath/stdout.r90.out &
python train_adapt.py $datapath $modelpath ./result_adapt/r100 -scheme 1 -trfrate 100 -gpu 1 > $logpath/stdout.r100.out &
wait