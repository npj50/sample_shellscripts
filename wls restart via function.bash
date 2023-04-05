#!/bin/bash

DEF=`tput sgr0`
MAG=`tput setaf 6`
BGR=`tput setaf 2`
BOLD=`tput bold`

APPlog="/opt/weblogic/script_files/logs/APPlog"
APPlock="/opt/weblogic/script_files/lock/APPlock"
APPpid="/opt/weblogic/script_files/pids/APPpid"
APPlst="/opt/weblogic/script_files/lst/APP.lst"

# Stop function
app_stop ()
{
echo "Add this" >> $APPlock
>$APPlog
>$APPpid

PID_Value=`ssh app@$server "ps -ef | grep -i /opt/isv/weblogic/app/logs/app.pid | grep -v grep"`
Value_BR=`echo $PID_Value | awk '{ print $2 }'`
PID_BR=`echo $PID_Value | awk '{ print $5 }'`
echo "${MAG} ##### APP before stop in "$server" : PID "$Value_BR" - "$PID_BR" ##### ${DEF}"

ssh app@$server "ps -ef | grep -i /opt/isv/weblogic/app/ | grep -v grep" >>$APPlog
cat $APPlog | awk '{print $2}' >> $APPpid
for PID in `cat $APPpid `do
ssh -tt app@$server "sudo -u weblogic /bin/bash << 'EOF'
kill -9 "$PID";
cd /opt/isv/weblogic/app/work/Catalina/;
rm -fr *;
EOF"
done
echo "APP: Force-Stop and Cleanup done in "$server""

sleep 5

ssh -tt app@$server "sudo -u weblogic /bin/bash << 'EOF'
cd /opt/isv/weblogic/app/;
bin/wrapper.sh status;
EOF"

echo "APP stopped in "$server""
sleep 5
> $APPlock
}

# Start function
app_start ()
{
echo "Add this" >> $APPlock
>$APPlog
>$APPpid
echo "${BOLD} Starting JVM - APP in "$server" ${DEF}"
ssh -tt app@$server "sudo -u weblogic /bin/bash << 'EOF'
cd /opt/isv/weblogic/app/;
bin/wrapper.sh start;
sleep 5
bin/wrapper.sh status;
EOF"

echo "APP started in "$server""
PID_Value=`ssh app@$server "ps -ef | grep -i /opt/isv/weblogic/app/logs/app.pid | grep -v grep"`
Value_AR=`echo $PID_Value | awk '{ print $2 }'`
PID_AR=`echo $PID_Value | awk '{ print $5 }'`
echo "${MAG} ##### APP after start in "$server" : PID "$Value_AR" - "$PID_AR" ##### ${DEF}"
> $APPlock
}

# Restart function
app_restart ()
{
echo "Add this" >> $APPlock
>$APPlog
>APPpid
echo "${BOLD} Restarting JVM - APP in "$server" ${DEF}"
PID_Value=`ssh app@$server "ps -ef | grep -i /opt/isv/weblogic/app/logs/app.pid | grep -v grep"`
Value_BR=`echo $PID_Value | awk '{ print $2 }'`
PID_BR=`echo $PID_Value | awk '{ print $5 }'`
echo "${MAG} ##### APP before stop in "$server" : PID "$Value_BR" - "$PID_BR" ##### ${DEF}"
echo "${BOLD} Restarting JVM"

ssh app@$server "ps -ef | grep -i /opt/isv/weblogic/app/ | grep -v grep" >>$APPlog
cat $APPog | awk '{print $2}' >> $APPpid
for PID in `cat $APPpid`
do
ssh -tt app@$server "sudo -u weblogic /bin/bash << 'EOF'
kill -9 "$PID";
cd /opt/isv/weblogic/app/work/Catalina;
rm -fr *;
EOF"
done
echo "APP: Force-Stop and Cleanup done in "$server""

sleep 5

ssh -tt app@$server "sudo -u weblogic /bin/bash << 'EOF'
cd /opt/isv/weblogic/app;
bin/wrapper.sh start;
sleep 5;
bin/wrapper.sh status;
EOF"

echo "APP restarted in "$server""
sleep 5
PID_Value1=`ssh app@$server "ps -ef | grep -i /opt/isv/weblogic/akm/logs/app.pid | grep -v grep"`
Value_AR=`echo $PID_Value1 | awk '{ print $2 }'`
PID_AR=`echo $PID_Value | awk '{ print $5 }'`
echo "${MAG} ##### APP after start in "$server" : PID "$Value_AR" - "$PID_AR" ##### ${DEF}"
> $CDAlock
}


# Restart All function
app_restartall ()
{
echo "Add this" >> $APPlock
for i in `cat $APPlst`
do
if ssh -o BatchMode=yes app@$i true 2>/dev/null
then
{
>$APPlog
>$APPpid
echo "${BOLD} Restarting JVM - APP in "$i" ${DEF}"
PID_Value=`ssh app@$i "ps -ef | grep -i /opt/isv/weblogic/app/logs/app.pid | grep -v grep"`
Value_BR=`echo $PID_Value | awk '{ print $2 }'`
PID_BR=`echo $PID_Value | awk '{ print $5 }'`
echo "${MAG} ##### APP before stop in "$i" : PID "$Value_BR" - "$PID_BR" ##### ${DEF}"
echo "${BOLD} Restarting JVM"

ssh app@$i "ps -ef | grep -i /opt/isv/weblogic/app/ | grep -v grep" >>$APPlog
cat $APPlog | awk '{print $2}' >> $APPpid
for PID in `cat $APPpid`
do
ssh -tt app@$i "sudo -u weblogic /bin/bash << 'EOF'
kill -9 "$PID";
cd /opt/isv/weblogic/app/work/Catalina/;
rm -fr *;
EOF"
done
echo "APP: Force-Stop and Cleanup done in "$server""

sleep 5

ssh -tt app@$i"sudo -u weblogic /bin/bash << 'EOF'
cd /opt/isv/weblogic/app/;
bin/wrapper.sh start;
sleep 5;
bin/wrapper.sh status;
EOF"

PID_Value1=`ssh app@$i "ps -ef | grep -i /opt/isv/weblogic/APP/logs/app.pid | grep -v grep"`
Value_AR=`echo $PID_Value1 | awk '{ print $2 }'`
PID_AR=`echo $PID_Value1 | awk '{ print $5 }'`
echo "${MAG} ##### Alm after start in "$i" : PID "$Value_AR" - "$PID_AR" ##### ${DEF}"
echo "##### APP restarted in "$i" #####"
}
fi
done
echo "##### All of APP restarted in all APP hosts #####"
> $APPlock
}

echo "${BOLD} ${MAG} OPTION SELECTED: APP ${DEF}"

echo "${BOLD} Check this script's output at $APPlog ${DEF}"

printf "${BOLD} Script's lock file: $APPlock \n ${DEF} "

value=`cksum $APPlock | awk '{print $2}'`

if [ $value -ne 0 ]
then
{
printf "${BOLD} Please hold - APP script is on the run already \n\n ${DEF}"
sleep 5
exit
}
else
{
printf "APP hosts: Enter any 1"
printf "${BOLD} ############## \n ${DEF} "
cat $APPlst
printf "${BOLD} ############## \n ${DEF} "
echo "ENTER APP SERVER:"
read server
grep -iw $server $APPlst
if [ $? -eq 0 ]
then
{
echo "Select Choice: 1 - STOP, 2 - START, 3 - RESTART and 4 - RESTART ALL"

read choice

printf "\n\n"

case "$choice" in

1)
app_stop $server
printf "\n\n\n"
;;

2)
app_start $server
printf "\n\n\n"
;;

3)
app_restart $server
printf "\n\n\n"
;;

4)
app_restartall
echo "APP restarted in all servers"
printf "\n\n\n"
;;

*)
echo "Invalid Selection - Quit"
sleep 2
exit
;;

esac
}
else
{
echo "ENTERED SERER NOT IN THE  LIST"
printf "\n\n"
exit
}
fi
}
fi
