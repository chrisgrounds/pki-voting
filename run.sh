NAME=$1
MSG=$2
ENCRYPTED_MSG=$NAME/msg.enc
HASHED_ENCRYPTED_MSG=$NAME/hashed-msg.enc

ROOT_PRIVATE_KEY=root-server/root-key.pem
ROOT_PUBLIC_KEY=root-server/root-key.pub.pem

VOTER_PRIVATE_KEY=$NAME/key.pem
VOTER_PUBLIC_KEY=$NAME/key.pub.pem
VOTER_SIGNATURE=$NAME/signature.sign

rm -rf root-server
rm -rf $NAME

mkdir root-server
mkdir $NAME

function generateRSAPrivateKey {
    local outFile=$1

    openssl genrsa -out $outFile 4096 >& /dev/null
}

function extractPublicKeyFromPrivateKey {
    local inPrivateKey=$1
    local outFile=$2

    openssl rsa -in $inPrivateKey -pubout >& $outFile
}

function encryptWithRootPrivateKey {
    echo $MSG | openssl enc -aes-256-cbc -pass file:$ROOT_PRIVATE_KEY -out $ENCRYPTED_MSG
}

function createHash {
    cat $ENCRYPTED_MSG | shasum -a 256 > $HASHED_ENCRYPTED_MSG
}

function createSignature {
    openssl dgst -sha256 -sign $VOTER_PRIVATE_KEY $HASHED_ENCRYPTED_MSG > $VOTER_SIGNATURE
}

function verifySignature {
    openssl dgst -sha256 -verify $VOTER_PUBLIC_KEY -signature $VOTER_SIGNATURE $HASHED_ENCRYPTED_MSG
}

#### Key creation ####
generateRSAPrivateKey $ROOT_PRIVATE_KEY
extractPublicKeyFromPrivateKey $ROOT_PRIVATE_KEY $ROOT_PUBLIC_KEY

generateRSAPrivateKey $VOTER_PRIVATE_KEY
extractPublicKeyFromPrivateKey $VOTER_PRIVATE_KEY $VOTER_PUBLIC_KEY

#### Encyrpting ####
encryptWithRootPrivateKey 

#### Signing ####
createHash
createSignature

verifySignature
