#!/bin/bash

read -p 'Enter View: ' VIEW
read -p 'Enter Component: ' COMPONENT
read -p 'Enter Scale: ' SCALE
read -p 'Enter Count: ' COUNT

if [ -z "$VIEW" ] || [ -z "$COMPONENT" ] || [ -z $SCALE ] 
then 
    echo 'Inputs cannot be blank please give input' 
    exit 0 
fi 

if ! [[ "$COUNT" =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]
then
    echo "Count must be a numbers"
    exit 0
fi

if [ "$VIEW" == "Auction" ]
then
	component=`cat sig.conf | egrep -i $COMPONENT | awk -F ';' '{print $3}'`
	component1=`cat sig.conf | egrep -i $COMPONENT | awk -F ';' '{print $3}' | head -1`
	if [ "$component" == "INGESTOR" ]
	then
		initial_count=`cat sig.conf | grep -i $component | awk -F '=' '{print $2}'`
                scale=`cat sig.conf | grep -i $component | awk -F ';' '{print $2}'`
                #cat sig.conf | grep -i $component >>new.txt
		sed -i -e "/INGESTOR/s/$initial_count/$COUNT/" sig.conf
		#cat sig.conf | grep -i $component >>new.txt
		sed -i -e "/INGESTOR/s/$scale/$SCALE/" sig.conf
	elif [ "$component" == "JOINER" ]
	then 
		initial_count=`cat sig.conf | grep -i $component | awk -F '=' '{print $2}'`
                scale=`cat sig.conf | grep -i $component | awk -F ';' '{print $2}'`
                sed -i "/JOINER/s/$initial_count/$COUNT/" sig.conf
                sed -i "/JOINER/s/$scale/$SCALE/" sig.conf
	elif [ "$component1" == "WRANGLER" ]
        then
                initial_count=`cat sig.conf | grep -i $component1 | awk -F '=' '{print $2}' | head -1`
                scale=`cat sig.conf | grep -i $component1 | awk -F ';' '{print $2}' | head -1`
                sed -i "/3s/$initial_count/$COUNT/" sig.conf
                sed -i "/3s/$scale/$SCALE/" sig.conf
        elif [ "$component1" == "VALIDATOR" ]
        then
                initial_count=`cat sig.conf | grep -i $component1 | awk -F '=' '{print $2}' | head -1`
                scale=`cat sig.conf | grep -i $component1 | awk -F ';' '{print $2}' | head -1`
                sed -i "5s/$initial_count/$COUNT/" sig.conf
                sed -i "5s/$scale/$SCALE/" sig.conf


	fi

elif [ "$VIEW" == "Bid" ]
then
	      component=`cat sig.conf | egrep -i $COMPONENT | awk -F ';' '{print $3}' | tail -1`
	if [ "$component" == "WRANGLER" ]
	then
	       initial_count=`cat sig.conf | grep -i $component | awk -F '=' '{print $2}' | tail -1`
	       scale=`cat sig.conf | grep -i $component | awk -F ';' '{print $2}' | tail -1`
               sed -i "/4s/$initial_count/$COUNT/" sig.conf
               sed -i "/4s/$scale/$SCALE/" sig.conf
        elif [ "$component" == "VALIDATOR" ]
	then
	       initial_count=`cat sig.conf | grep -i $component | awk -F '=' '{print $2}' | tail -1`
               scale=`cat sig.conf | grep -i $component | awk -F ';' '{print $2}' | tail -1`
               sed -i "6s/$initial_count/$COUNT/" sig.conf
               sed -i "6s/$scale/$SCALE/" sig.conf
         fi
else 
	 echo "enter input in the given format"
fi


cat sig.conf

