export PROJECT=${5:-"jwst-cal"}
export VERSION=${1:-`cat ${PROJECT}/VERSION`}
export REPO=${2:-"jwst-cal"}
export ACCOUNT=${3:-"162808325377.dkr.ecr.us-east-1.amazonaws.com"}
export REGION=${4:-"us-east-1"}

export TAG=${ACCOUNT}/${REPO}:${VERSION}
export LATEST=${ACCOUNT}/${REPO}:latest
