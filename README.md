#  crypto Bash Rsa Cryptor
## Warning This source code is designed and built for educational purposes only. Please do not use it in a bad way!

## editor and creator mortza
contact to me Only in discord (mortza#3700)
For GuardIran...

## Options
 ```bash      
          ____  ____    _    ____  _   _ 
         |  _ \/ ___|  / \  / ___|| | | |
         | |_) \___ \ / _ \ \___ \| |_| |
         |  _ < ___) / ___ \ ___) |  _  |
         |_| \_\____/_/   \_\____/|_| |_|
              Created For Guardiran     
    ----------------------------------------------------
	baraye estefadeh: ./crypto [OPTION] -i vorody -o khoroji

	 -p   use public/privatekey for encryption/decryption
	   -e    encrypt
	    -d    decrypt
	     -i    input(vorody)
	      -o	output(khoroji)
	       -s	 create shasum
	        -t	  directory will be archived
	         -h	    help message
 ```      
Encrypt by generating a private or public key.

### Create public or private key
```
# Create public/private key
openssl req -x509 -nodes -newkey rsa:4096 -keyout privatekey.pem -out publickey.pem
```

Thank you _acidwars_
