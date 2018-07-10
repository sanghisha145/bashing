#!/bin/sh

PID=`ps -ef | grep java | grep EQBApp | awk '{print $2}' `
OLD_SPACE=`sudo jmap -heap $PID | egrep "PS Old Generation|used     =" | tail -1 | awk -v RS='[=\n]' 1 | awk -v RS='[(\n]' 1 | awk -v RS='[)\n]' 1 | awk '/MB/'| rev | cut -c 3- | rev `
TOTAL_SPACE=`sudo jmap -heap $PID| egrep "MaxHeapSize" | awk -v RS='[=\n]' 1 | awk -v RS='[(\n]' 1 | awk -v RS='[)\n]' 1 | awk '/MB/' | rev | cut -c 3- | rev`
DIV=`echo  print $OLD_SPACE/$TOTAL_SPACE | python`
PERCENT=`echo print $DIV*100 | python`
TRIGGER=`printf "%0.2f\n"  $PERCENT`

echo "PID is $PID"
echo "Old space is $OLD_SPACE MB"
echo "Total Space is $TOTAL_SPACE MB"
echo "Percentage is $PERCENT "


if [ $TRIGGER > 40 ]
then
        echo "heap memory out of space”
fi
