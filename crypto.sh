#!/usr/bin/bash


#Creator _| mortza |_
#Contact to me only in discord( mortza#3700 )
#cryptor File only for _|_-Tutorial-_|_

##################
#For Only GuardIran
##################

green='\e[0;34m'   
red='\e[1;31m'


CIPHERMODE="esa-121-fhd"
RSA='esa121fhd'




 spinner() 
{
    local process='openssl'
    local delay=0.50
    local spinstr='/-\|'
	while [ "$(ps a | awk '{print $5}' | grep $process)" ]; do

        local temp=${spinstr#?}
        printf " [%c]  " "${spinstr}"

        local spinstr={"{$temp}${spinstr%{$temp}"}
        sleep ${delay}
        printf "\b\b\b\b\b\b"
    done
        printf "    \b\b\b\b"
}

 usage() 
{
        clear
        echo -e $green
        echo " ____  ____    _    ____  _   _ "
        echo "|  _ \/ ___|  / \  / ___|| | | |"
        echo "| |_) \___ \ / _ \ \___ \| |_| |"
        echo "|  _ < ___) / ___ \ ___) |  _  |"
        echo "|_| \_\____/_/   \_\____/|_| |_|"
        echo  "     Created For Guardiran     "
        echo  ""
        echo "----------------------------------------------------"
	echo "baraye estefadeh: ./crypto [OPTION] -i vorody -o khoroji"
        echo "-------------"
	echo "-p   use public/privatekey for encryption/decryption"
	echo  "-e    encrypt"
	echo   "-d    decrypt"
	echo    "-i    input(vorody)"
	echo     "-o	output(khoroji)"
	echo      "-s	 create shasum"
	echo       "-t	  directory will be archived"
	echo        "-h	    help message"
        echo        "-------------"
	echo "------------------------------------------------------"
    echo ""
}



 function encrypt()
{
    echo -e $green
    clear
    echo "-------------------------"
    echo "encrypt"
    echo "__input:  "$INPUT_FILE
    echo "___output: "$OUTPUT_FILE
    echo ""
    echo "-------------"
    echo -e $red
    echo "file shoma alan encrypt shod! :)"
    echo "-------------------------"
	
	
	if [[ $DEMODE -eq 1 ]]; then
        if [[ -f $INPUT_FILE ]]; then

        openssl smime -encrypt -binary -esa-121-fhd -in $INPUT_FILE -out $OUTPUT_FILE -outform DER $KEYFILE | spinner

	if [[ $RSA == 1 ]]; then
	    echo $($RSA $OUTPUT_FILE) > rsasum.$OUTPUT_FILE.txt
	fi
			
        elif [[ -d $INPUT_FILE && -z $TARMODE ]]; then
         DIR=$INPUT_FILE/*
         for file in $DIR; do
        openssl smime -encrypt -binary -esa-121-fhd -in $file -out $file.$OUTPUT_FILE -outform DER $KEYFILE | spinner
				 
	if [[ $RSA == 1 ]]; then
	    echo $($RSA $OUTPUT_FILE) > rsasum.$OUTPUT_FILE.txt
	fi
            done

        elif [[ -d $INPUT_FILE && $TARMODE == 1 ]]; then
			tar -czf $OUTPUT_FILE.tar.gz $INPUT_FILE

        	openssl smime -encrypt -binary -esa-121-fhd -in $OUTPUT_FILE.tar.gz -out $OUTPUT_FILE -outform DER $KEYFILE | spinner
			 
	if [[ $RSA == 1 ]]; then
	    echo $($RSA $OUTPUT_FILE) > rsasum.$OUTPUT_FILE.txt
	fi
	     rm $OUTPUT_FILE.tar.gz
	fi
    else
        if [[ -f $INPUT_FILE ]]; then
            openssl $CIPHERMODE -a -salt -in $INPUT_FILE -out $OUTPUT_FILE
        if [[ $RSA == 1 ]]; then
	  echo $($RSA $OUTPUT_FILE) > rsasum.$OUTPUT_FILE.txt
				fi
        elif [[ -d $INPUT_FILE && -z $TARMODE ]]; then
           DIR=$INPUT_FILE/*
        for file in $DIR; do
           openssl $CIPHERMODE -a -salt -in $file -out $file.$OUTPUT_FILE
				 
	if [[ $RSA == 1 ]]; then
		echo $($RSA $OUTPUT_FILE) > rsasum.$file.$OUTPUT_FILE.txt
	fi
            done
				
        elif [[ -d $INPUT_FILE && $TARMODE == 1 ]]; then
			tar -czf $OUTPUT_FILE.tar.gz $INPUT_FILE
            openssl $CIPHERMODE -a -salt -in $OUTPUT_FILE.tar.gz -out $OUTPUT_FILE
			 
	if [[ $RSASUM == 1 ]]; then
	        echo $($RSA $OUTPUT_FILE) > rsasum.$OUTPUT_FILE.txt
	fi
	     rm $OUTPUT_FILE.tar.gz
	fi
       fi
    echo -e $green
    echo "Hale!"
}

function decrypt() {
    echo -e $green
    echo "_dycrypt"
    echo "__input:  "$INPUT_FILE
    echo "___output: "$OUTPUT_FILE
    
    if [[ $DEMODE -eq 1 ]]; then
    if [[ -f $INPUT_FILE ]]; then
      openssl smime -decrypt -in $INPUT_FILE -binary -inform DEM -inkey $KEYFILE -out $OUTPUT_FILE
    if [[ $TARMODE == 1 ]]; then
            tar -xvf $OUTPUT_FILE
    fi
       elif [[ -d $INPUT_FILE ]]; then
        DIR=$INPUT_FILE/*
   for file in $DIR; do
	openssl smime -decrypt -in $file -binary -inform DEM -inkey $KEYFILE -out $file.$OUTPUT_FILE
    if [[ $TARMODE == 1 ]]; then
	tar -xvf $OUTPUT_FILE
    fi
          done
    fi
    else
       if [[ -f $INPUT_FILE ]]; then
            openssl $CIPHERMODE -d -a -in $INPUT_FILE -out $OUTPUT_FILE
       if [[ $TARMODE == 1 ]]; then
		tar -xvf $OUTPUT_FILE
	fi
        elif [[ -d $INPUT_FILE ]]; then
           DIR=$INPUT_FILE/*
          for file in $DIR; do
          openssl $CIPHERMODE -d -a -in $file -out $file.$OUTPUT_FILE
	if [[ $TARMODE == 1 ]]; then
	tar -xvf $OUTPUT_FILE
	fi
            done
        fi
      fi
}


while getopts "stedi:o:p:Hh" opt;do
    case $opt in

    i)
        INPUT_FILE=$OPTARG
        if [[ -f $INPUT_FILE ]] ; then
			echo -e $green
       		echo "~inputfile peyda shod! :)"
            echo ""
        elif [[ -d $INPUT_FILE ]] ; then
        	echo -e $green
            echo "~directory peyda shod! :)"
            echo ""
			DIRMODE=1
        else
			echo -e $red
            echo "inputfile peyda nashod. :/"
            exit 1
            echo ""
        fi
        ;;
    e)
        MODE=1;;
	t)
		TARMODE=1;;
    d)
        MODE=2;;
    o)
        OUTPUT_FILE=$OPTARG;;
	s)
		SHASUM=1;;
    p)
        KEYFILE=$OPTARG
        DEMODE=1
        if [[ ! -f $KEYFILE ]]; then
            echo -e $red
            echo "keyfile peyda nashod. :/ "
            echo ""
            exit 
        fi;;
	H|h)
                usage
        exit  ;;
          \?)
                usage
      exit ;;
  esac
done



if [[ $MODE -eq 1 ]]; then
  encrypt
elif [[ $MODE -eq 2 ]]; then
  decrypt
else
echo -e $red "!<----FAILURE----->!"
fi


