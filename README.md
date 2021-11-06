#  crypto Bash Rsa Cryptor
## Warning This source code is designed and built for educational purposes only. Please do not use it in a bad way!

## editor and creator mortza
contact to me Only in discord (mortza#3700)


## Options
```bash
Usage: crypto [OPTION] -i INPUT -o OUTPUT
-p	use public/privatekey for encryption/decryption
-e	encrypt
-d	decrypt
-i	input
-o	output
-s	create shasum
-t  tarmode
-h	help message
```
Encrypt by generating a private or public key.

### Create public/private key
```bash
# Create public/private key
openssl req -x509 -nodes -newkey rsa:4096 -keyout privatekey.pem -out publickey.pem
# Create public/private key with password protection
openssl req -x509 -newkey rsa:4096 -keyout privatekey.pem -out publickey.pem
```

### Encrypt
```bash
# encrypt with a password:
./crypto -e -i test.txt -o test.txt.enc
# encrypt all files in a folder
./crypto -e -i dir -o enc
# encrypt with your public key:
./crypto -e -p public.pem -i test.txt -o ultrasecret.dat
# encrypt all files in a folder
./crypto -e -p public.pem -i dir -o ultrasecret.dat
```

### Decrypt
```bash
# decrypt with password:
./crypto -d -i test.txt.enc -o plain.txt
# decrypt with private key:
./crypto -d -p private.pem -i ultrasecret.dat -o plain.txt
```
Thank you _acidwars_
