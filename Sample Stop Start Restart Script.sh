DEF=`tput sgr0`
MAG=`tput setaf 6`
BGR=`tput setaf 2`
BOLD=`tput bold`

function goto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
 
ENV=${1:-"ENV"}
CATEGORY=${1:-"CATEGORY"} 

action( )
{
#####  <ENV1> #######
if [  $env_choice = 1 -a $cat_choice = 1 ] then var=<ENV1>-<LAYER1>
elif [  $env_choice = 1 -a $cat_choice = 2 ] then var=<ENV1>-<LAYER2>
#####  END - <ENV1> #######
#####  <ENV2> #######
elif [  $env_choice = 2 -a $cat_choice = 1 ] then var=<ENV2>-<LAYER1>
elif [  $env_choice = 2 -a $cat_choice = 2 ] then var=<ENV2>-<LAYER2>
#####  END - <ENV2> #######
else
exit
fi
return $var;
}

ENV: 
clear
printf "${BOLD} ${MAG} ##### ENVIRONMENT ##### ${DEF}\n"
printf "${BOLD} ${MAG} ------------------------------------- ${DEF}\n\n"
printf "\n ${BOLD} 1) <ENV1> ${DEF} \n"
printf "\n ${BOLD} 2) <ENV2> ${DEF} \n"
printf "\n ${BOLD} 3) EXIT ${DEF} \n"
printf "\n\n 1)%-1s Enter your choice: \n"  
read env_choice
if [ $env_choice -eq 3 ]
then
exit;
elif [ $env_choice -gt 13 ]
then
printf "Invalid Option\n"
sleep 2
goto ENV
else
continue;
fi

CATEGORY:
clear
printf "${BOLD} ${MAG} ##### LAYER FOR ACTION ##### ${DEF}\n"
printf "${BOLD} ${MAG} ------------------------------------- ${DEF}\n\n"
printf "\n ${BOLD} 1)<LAYER1> ${DEF} \n"
printf "\n ${BOLD} 2)<LAYER2> ${DEF} \n"
printf "\n ${BOLD} 3)Back To ENVIRONMENT Menu ${DEF} \n"
printf "\n\n1)%-1s Enter your choice: \n"  
read cat_choice
if [ $cat_choice -eq 3 ]
then
goto ENV
elif [ $cat_choice -gt 3 ]
then
printf "Invalid Option\n"
sleep 2
goto ENV
else
continue;
fi

clear
printf "${BOLD} ${MAG} #####   SELECT AN ACTION TYPE   ##### ${DEF}\n"
printf "${BOLD} ${MAG} ------------------------------------- ${DEF}\n\n"
printf "\n\n  ${BOLD} 1)STOP ${DEF} \n"
printf "\n\n  ${BOLD} 2)START ${DEF} \n"
printf "\n\n  ${BOLD} 3)RESTART ${DEF} \n"
printf "\n\n  ${BOLD} 4)Back to LAYER Menu ${DEF} \n"
printf "\n\n1)%-1s Enter your Action: \n"
read action_choice

if [ $action_choice = 1 ]
then
action env_choice cat_choice
case $var in 
######## <ENV1> STOP #########
<ENV1>-<LAYER1>)
<Script_path>/<ENV1>/<ENV1><LAYER1>_stop.sh
goto ENV
;;

<ENV1>-<LAYER2>)
<Script_path>/<ENV1>/<ENV1><LAYER2>_stop.sh
goto ENV
;;
######## END <ENV1> STOP #########
######## <ENV2> STOP #########
<ENV2>-<LAYER1>)
<Script_path>/<ENV2>/<ENV2><LAYER1>_stop.sh
goto ENV
;;

<ENV2>-<LAYER2>)
<Script_path>/<ENV2>/<ENV2><LAYER2>_stop.sh
goto ENV
;;
######## END <ENV2> STOP #########
esac

elif [ $action_choice = 2 ]
then
action env_choice cat_choice
case $var in
########  <ENV1> START #########
<ENV1>-<LAYER1>)
<Script_path>/<ENV1>/<ENV1><LAYER1>_start.sh
goto ENV
;;

<ENV1>-<LAYER2>)
<Script_path>/<ENV1>/<ENV1><LAYER2>_start.sh
goto ENV
;;
########  END - <ENV1> START #########
########  <ENV2> START #########
<ENV2>-<LAYER1>)
<Script_path>/<ENV2>/<ENV2><LAYER1>_start.sh
goto ENV
;;

<ENV2>-<LAYER2>)
<Script_path>/<ENV2>/<ENV2><LAYER2>_start.sh
goto ENV
;;
########  END - <ENV2> START #########
esac

elif [ $action_choice = 3 ]
then
action env_choice cat_choice
case $var in
######### <ENV1> RESTART ########
<ENV1>-<LAYER1>)
<Script_path>/<ENV1>/<ENV1><LAYER1>_restart.sh
goto ENV
;;

<ENV1>-<LAYER2>)
<Script_path>/<ENV1>/<ENV1><LAYER2>_restart.sh
goto ENV
;;
######### END - <ENV1> RESTART ##
######### <ENV2> RESTART ########
<ENV2>-<LAYER1>)
<Script_path>/<ENV2>/<ENV2><LAYER1>_restart.sh
goto ENV
;;

<ENV2>-<LAYER2>)
<Script_path>/<ENV2>/<ENV2><LAYER2>_restart.sh
goto ENV
;;
######### END - <ENV2> RESTART ######## 
esac 

elif [ $action_choice -eq 4 ]
then
goto CATEGORY

elif [ $action_choice -gt 4 ]
then
printf "Invalid Option\n"
sleep 2
goto CATEGORY
else
exit
fi
