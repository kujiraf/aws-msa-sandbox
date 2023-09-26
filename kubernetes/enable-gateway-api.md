https://www.gateway-api-controller.eks.aws.dev/deploy/

```bash
kubectl create ns aws-application-networking-system
```

```bash
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::$(aws sts get-caller-identity --query "Account" --output text):role/MaFurukawatkrForGwApiController
  name: gateway-api-controller
  namespace: aws-application-networking-system
EOF
```

```bash
export AWS_REGION=ap-northeast-1
export CLUSTER_NAME=ma-furukawatkr-eks-cluster
```

```bash
PREFIX_LIST_ID=$(aws ec2 describe-managed-prefix-lists --query "PrefixLists[?PrefixListName=="\'com.amazonaws.$AWS_REGION.vpc-lattice\'"].PrefixListId" | jq -r '.[]')
MANAGED_PREFIX=$(aws ec2 get-managed-prefix-list-entries --prefix-list-id $PREFIX_LIST_ID --output json  | jq -r '.Entries[0].Cidr')
CLUSTER_SG=$(aws eks describe-cluster --name $CLUSTER_NAME --output json| jq -r '.cluster.resourcesVpcConfig.clusterSecurityGroupId')
aws ec2 authorize-security-group-ingress --group-id $CLUSTER_SG --cidr $MANAGED_PREFIX --protocol -1
```

```bash
# CRDインストール
kubectl apply -f examples/deploy-v0.0.16.yaml

# デモアプリケーション作成
kubectl apply -f examples/parking.yaml
kubectl apply -f examples/review.yaml
kubectl apply -f examples/inventory-ver1.yaml
kubectl apply -f examples/inventory-ver2.yaml

# GatewayClass
kubectl apply -f examples/gatewayclass.yaml

# Gateway
kubectl apply -f examples/my-hotel-gateway.yaml

# HTTPRoute
kubectl apply -f examples/rate-route-path.yaml
kubectl apply -f examples/inventory-route-bluegreen-single-cluster.yaml
```
