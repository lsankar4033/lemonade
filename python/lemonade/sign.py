from eth_abi.packed import encode_abi_packed
from eth_account.messages import encode_defunct
from hashlib import sha3_256

from web3 import Web3
from web3.auto import w3

ganache_privkey = bytes.fromhex('f85ea1dfdee17cde71ec01ca3f333d40b58fa6501df928393416115924d75daf')


def to_32byte_hex(val):
    return Web3.toHex(Web3.toBytes(val).rjust(32, b'\0'))


def pack_data(nonce, val):
    return encode_abi_packed(['uint128', 'uint128'], (nonce, val))


# NOTE: Doesn't do 'Ethereum signed message: ' prefixing yet!
def sign_data(packed_data, privkey=ganache_privkey):
    signable_message = encode_defunct(primitive=packed_data)

    signed = w3.eth.account.sign_message(signable_message, private_key=privkey)
    return (
        Web3.toHex(signed.messageHash),
        signed.v,
        to_32byte_hex(signed.r),
        to_32byte_hex(signed.s)
    )


def get_signed_data(nonce, val, privkey=ganache_privkey):
    pd = pack_data(nonce, val)
    return sign_data(pd, privkey)
