# PKI Voting System 💻

This is a demonstration of a secure online voting system, using public-key infrastructure technologies.

## How it works

Similar to the Estonian i-voting system, this system has two layers. The first layer takes the input vote and encrypts it with the central, root server public key. This provides confidentially, ensuring no unauthorised person can view what the vote is, so long as the root server private key is not compromised. The second layer then provides the means to authenticate the voter. This is achieved by taking the encrypted vote from the first layer, hashing it with SHA-256 and then signing it with the voter's private key, thereby creating a digital signature. Anyone can then verify that the vote is indeed from the voter by using the voter's public key to decrypt the signature, thereby unwrapping the encryption and revealing the SHA-256 hash of the encrypted vote. This hash can then be comapred with the provided encrypted vote after it has been hashed with SHA-256.