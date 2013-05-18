export DELETE=--delete-removed
export INVALIDATE=--cf-invalidate
export WORKING_DIR=`pwd`
export SCRIPTS_DIR=`dirname $0`
cd $SCRIPTS_DIR
bash ./raw-publish.sh
