#!/bin/bash
set -e

function do_help {
  echo HELP:
  echo "Supported commands:"
  echo "   flume                  - Start flume"
#  echo "   hive-metastore         - Start Hive Metastore"
#  echo "   impala-state-store     - Start Impala Statestore"
#  echo "   impala-catalog         - Start Impala Catalog"
#  echo "   impala-server          - Start Impala Server and Hadoop Datanode"
#  echo "   standalone             - Start Standalone mode for Impala for Test"
  echo "   help                   - print useful information and exit"
  echo ""
  echo "Other commands can be specified to run shell commands."
  #echo "Set the environment variable KUDU_OPTS to pass additional"
  #echo "arguments to the kudu process. DEFAULT_KUDU_OPTS contains"
  echo "a recommended base set of options."

  exit 0
}


chmod +x /wait-for-it.sh


if [[ "$1" == "flume" ]]; then

  /etc/init.d/flume-ng-agent start

elif [[ "$1" == "help" ]]; then
  print_help
  exit 0
fi


# Container Run without stopping
tail -f /dev/null

