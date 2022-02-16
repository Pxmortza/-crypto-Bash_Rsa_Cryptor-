#!/usr/bin/env bash


#Creator _| mortza |_
#Contact to me only in discord( mortza#3700 )
#cryptor File only for _|_-Tutorial-_|_


green='\e[0;34m'
red='\e[1;31m'


CIPHERMODE="esa-121-fhd"
RSA='esa121fhd'
#$TARMODE=0



 spinner() 
{
    #local pid=$$
    local process='openssl'
    local delay=0.50
    local spinstr='/-\|'
	while [ "$(ps a | awk '{print $5}' | grep $process)" ]; do

        local temp=${spinstr#?}
        printf " [%c]  " "${spinstr}"

        local spinstr=${temp}${spinstr%"$temp}"}
        sleep ${delay}
        printf "\b\b\b\b\b\b"
    done
        printf "    \b\b\b\b"
}

 usage() 
{

    echo -e $green

	echo "Usage: ./crypto [OPTION] -i INPUT -o OUTPUT"
        echo "-------------"
	echo "-p	use public/privatekey for encryption/decryption"
	echo "-e	encrypt"
	echo "-d	decrypt"
	echo "-i	input"
	echo "-o	output"
	echo "-s	create shasum"
	echo "-t	directory will be archived"
	echo "-h	help message"
        echo "-------------"
	echo "Exampels:"
	echo "./crypto -e -s -p publickey.pem -i secretfile.txt -o foofile"
	echo "./crypto -e -i secretfile.txt -o foofile"
	echo "./crypto -d -p privatekey.pem -i foofile -o secretfile.txt"
	echo "./crypto -d -i foofile -o secretfile.txt"
    echo ""
}



 function encrypt()
{
    echo -e $green
    echo "[+] ENCRYPT"
    echo "[+] INPUT:  "$INPUT_FILE
    echo "[+] OUTPUT: "$OUTPUT_FILE
    echo ""
    echo "-------------"
    echo -e $red
    echo "[!] Your file will be encypted now!"
    echo "-------------"
	 
    echo ""

    
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
		# If input is a directory and 'tarmode' is set to 1, create tar.gz and encrypt it 
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
		# If input is a directory and 'tarmode' is set to 1, create tar.gz and encrypt it    
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
    echo "[+] Done!"
}

function decrypt() {
    echo -e $green
    echo "[+] DECRYPT"
    echo "[+] INPUT:  "$INPUT_FILE
    echo "[+] OUTPUT: "$OUTPUT_FILE
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
       		echo "[+] inputfile found!"
            echo ""
        elif [[ -d $INPUT_FILE ]] ; then
        	echo -e $green
            echo "[+] directory found!"
            echo ""
			DIRMODE=1
        else
			echo -e $red
            echo "[!] INPUT NOT FOUND!"
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
            echo "Keyfile not found"
            echo ""
            exit -1
        fi;;
	H|h)
                usage
        exit -1;;
	\?)
                usage
        exit -1;;
   esac
done



if [[ $MODE -eq 1 ]]; then
    encrypt
elif [[ $MODE -eq 2 ]]; then
    decrypt
else
    echo -e $red "FAILURE"
fi
