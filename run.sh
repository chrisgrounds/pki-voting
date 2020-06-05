NAME=$1
MSG=$2
ENCRYPTED_MSG=$NAME/msg.enc
HASHED_ENCRYPTED_MSG=$NAME/hashed-msg.enc

ROOT_PRIVATE_KEY=root-server/root-key.pem
ROOT_PUBLIC_KEY=root-server/root-key.pub.pem

PRIVATE_KEY=$NAME/key.pem
PUBLIC_KEY=$NAME/key.pub.pem
SIGNATURE=$NAME/signature.sign

rm -rf root-server
rm -rf $NAME

mkdir root-server
mkdir $NAME

#### Key creation ####
# Generate RSA private key for root server
openssl genrsa -out $ROOT_PRIVATE_KEY 4096 >& /dev/null
# Generate public key from private key for root server
openssl rsa -in $ROOT_PRIVATE_KEY -pubout >& $ROOT_PUBLIC_KEY

# Generate RSA private key for voter
openssl genrsa -out $PRIVATE_KEY 4096 >& /dev/null
# Generate public key for voter from voter's private key
openssl rsa -in $PRIVATE_KEY -pubout >& $PUBLIC_KEY

#### Encyrpting ####
# Use the root public key to encrypt the message
echo $MSG | openssl enc -aes-256-cbc -pass file:$ROOT_PRIVATE_KEY -out $ENCRYPTED_MSG

#### Signing ####
# Use SHA-256 to hash STDIN and write to file
cat $ENCRYPTED_MSG | shasum -a 256 > $HASHED_ENCRYPTED_MSG
# Encrypt the hashed_encrypted_msg with the voter's private key to create a digital signature
openssl dgst -sha256 -sign $PRIVATE_KEY $HASHED_ENCRYPTED_MSG > $SIGNATURE

# We can now verify that the message comes from the source
# They send the message with the signature, and we can verify the signature, thereby verifying they created it (by using their public key to decrypt it and comparing it to the message hash)
# The purpose of the signature is to *authenticate*
# Verify signature by decrypting the signature with voter's public key and comparing the hash with the encrypted_hashed_message
openssl dgst -sha256 -verify $PUBLIC_KEY -signature $SIGNATURE $HASHED_ENCRYPTED_MSG

