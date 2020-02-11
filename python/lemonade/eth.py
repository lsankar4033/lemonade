from web3 import Web3


GANACHE_URI = 'http://127.0.0.1:8545'


def get_ganache_web3():
    return Web3(Web3.HTTPProvider(GANACHE_URI))
