# https://forums.developer.nvidia.com/t/enabling-disk-encryption-doesnt-boot-the-device-jetson-xavier-nx-p3668-0001/208615
GEN_EKB_PATH=Linux_for_Tegra/source/public/trusty/app/nvidia-sample/hwkey-agent/CA_sample/tool/gen_ekb/
python3 $GEN_EKB_PATH/gen_ekb.py -kek2_key ./kek2_hex_file -fv ./fv_ekb_hex_file -in_sym_key ./user_key_for_eks_hex_file -in_sym_key2 ./ekb.key -out eks.img
