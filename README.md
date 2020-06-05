# PKI Voting System 💻

This is a demonstration of a secure online voting system, using public-key infrastructure technologies.

## How it works

Similar to the Estonian i-voting system, this system has two layers. 

The first layer takes the input vote and encrypts it with the central, root server public key. This provides confidentially, ensuring no unauthorised person can view what the vote is, so long as the root server private key is not compromised. Of course, not all voting systems will care about confidentiality - such as votes in the House of Commons, which are public knowledge. So this layer can potentially be disregarded if confidentiality is not a concern.

The second layer then provides the means to authenticate the voter. This is achieved by taking the encrypted vote from the first layer, hashing it with SHA-256 and then signing (encrypting) it with the voter's private key, thereby creating a digital signature. Anyone can then verify that the vote is indeed from the voter by using the voter's public key to decrypt the signature, thereby unwrapping the encryption and revealing the SHA-256 hash of the encrypted vote. This hash can then be comapred to the provided encrypted vote after it has also been hashed with SHA-256.

All in all, this means the voter sends their encrypted vote along with their signature. The root server verifies the signature and then if the checksum (hashed value) matches decrypts the vote, adding it to the voting tally.
