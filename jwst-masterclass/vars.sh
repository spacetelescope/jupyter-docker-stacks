export PROJECT=${5:-"jwst-masterclass"}
export VERSION=${1:-`cat ${PROJECT}/VERSION`}
export REPO=${2:-"jwst-masterclass"}
export ACCOUNT=${3:-"162808325377.dkr.ecr.us-east-1.amazonaws.com"}
export REGION=${4:-"us-east-1"}

export TAG=${ACCOUNT}/${REPO}:${VERSION}
