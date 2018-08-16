#!/bin/bash
set -e
while getopts "r:s:e:m:" opt; do
   case $opt in
    r) runcmd="$OPTARG"
      ;;
    s) squadname="$OPTARG"
      ;;
    e) envname="$OPTARG"
      ;;
    \?) echo "Invalid option -$OPTARG" >&2
       ;;
  esac
done

if [ -z ${runcmd} ] || [ -z ${squadname} ] || [ -z ${envname} ]  ; then
    printf "\n"
    printf "Please provide squad and env and terraform command \n\n"
    printf "./provision.sh -s devops -e dev -r init -m vpc \n"
    printf "valid squad values is devops \n"
    printf "\n"
elif [ "${squadname}" != "devops" ]; then
    printf "\n"
    printf "!!! invalid squad entry !!! \n"
    printf "valid squad values is  devops \n"

elif [ "${runcmd}" != "init" ] && [  "${runcmd}" != "plan" ] && [  "${runcmd}" != "apply" ]  && [  "${runcmd}" != "destroy_prereq" ] && [  "${runcmd}" != "destroy_eks" ] && [  "${runcmd}" != "validate" ] && [  "${runcmd}" != "kubeconfig" ]; then
    printf "\n"
    printf "!!! invalid terrafrom command entry !!! \n"
    printf "Valid terrafrom command to run this script is:  init,plan,apply or destroy or output \n"  
else

    if [ ${runcmd} == "init" ];then
       rm -rf .terraform/
       yes yes |  TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd}  
    
    elif [ ${runcmd} == "destroy_prereq" ];then
          S3_BUCKET_NAME=TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} s3_bucket_name
          aws s3 rm s3://${S3_BUCKET_NAME} --recursive 
       TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} -var-file="variables/$squadname/$envname.tfvars" -var "terraform_user_arn=${TERRAFORM_USER_ARN}" -var "max-size=${NO_OF_WORKER_NODE}" -force
    elif [ ${runcmd} == "destroy_eks" ];then     
       
       TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} -var-file="variables/$squadname/$envname.tfvars" -var "terraform_user_arn=${TERRAFORM_USER_ARN}" -var "max-size=${NO_OF_WORKER_NODE}" -force

     elif [ ${runcmd} == "apply" ];then 
        TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} -var-file="variables/$squadname/$envname.tfvars" -var "terraform_user_arn=${TERRAFORM_USER_ARN}" -var "max-size=${NO_OF_WORKER_NODE}" -auto-approve  
    elif [ ${runcmd} == "kubeconfig" ];then
        mkdir -p ~/.kube     
        TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} kubeconfig > ~/.kube/eks-cluster
        export KUBECONFIG=~/.kube/eks-cluster
        TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} config-map > config-map-aws-auth.yaml
        kubectl apply -f config-map-aws-auth.yaml
        kubectl get nodes --watch    
    else
       TF_WORKSPACE=${envname}-${squadname} /usr/local/bin/terraform ${runcmd} -var-file="variables/$squadname/$envname.tfvars" -var "terraform_user_arn=${TERRAFORM_USER_ARN}" -var "max-size=${NO_OF_WORKER_NODE}"
    fi
    cd $WORKSPACE
fi