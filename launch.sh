#!/bin/bash

startfilename="app.js"
projectname="km_weixin"

if [ -z "$1" -o "$1" == "start" ]
  then echo "" > /dev/null
elif [ "$1" == "stop" ]
  then pm2 stop $projectname
  exit 1
elif [ "$1" == "restart" ]
  then pm2 restart $projectname
  exit 2
elif [ "$1" == "delete" ]
  then pm2 delete $projectname
  exit 3
elif [ "$1" == "-h" -o "$1" == "--help" ]
  then 
  echo "all params list:"
  echo -e "\t(\e[1;32m--help\e[0m) help message"
  echo -e "\t(\e[1;32mstart\e[0m) start the project"
  echo -e "\t(\e[1;32mstop\e[0m) stop the project, but still using the port"
  echo -e "\t(\e[1;32mrestart\e[0m) restart the project"
  echo -e "\t(\e[1;32mdelete\e[0m) delete the project"
  exit 4
elif [ "$1" == "cluster" ]
  then startfilename="run-cluster.js"
else
  echo "$1 is a not normal params, please --help to get params"
  exit 5
fi

startapp() {
  if (($pmv >= "$tarpmver"))
    then pm2 start dist/$startfilename --name $projectname
  else
    node dist/$startfilename
  fi
}

set process.env.NODE_ENV = production

tarver=4
tarpmver=1
ver=$(node --version)

if [ -z "$ver" -o "${ver:0:1}" != "v" ]
  then echo "请先安装nodejs环境，建议版本在4.0以上"
else
  pm=$(pm2 --version | grep -v PM2)
  pmv=${pm:0:1}
  if [ -z "$pmv" ]
    then pmv=0
  fi
  if (("${ver:1:1}" >= "$tarver"))
    then startapp
  else
    if read -t 15 -p "目前nodejs的版本过低，建议安装4.0以上，是否启动（y/n,15秒后自动启动）:" run
      then if [ "$run" == "y" ]
        then startapp
      else
        echo "stop run the node project"
      fi
    else
      startapp
    fi
  fi
fi