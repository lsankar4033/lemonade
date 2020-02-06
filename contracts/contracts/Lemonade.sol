pragma solidity ^0.6.2;

contract Lemonade {
    address owner;
    uint128 public nextNonce;

    constructor() public {
        owner = msg.sender;
        nextNonce = 0;
    }

    function verify(uint128 nonce, uint128 val, uint8 v, bytes32 r, bytes32 s) external {
        require(nonce == nextNonce, "Nonce must be the expected next nonce");
        require(address(this).balance > val, "Contract must have enough balance to cover val");

        bytes32 hash = create_prefixed_hash(nonce, val);
        address signer = ecrecover(hash, v, r, s);
        require(signer == owner, "Data must be signed by contract owner");

        nextNonce += 1;
        msg.sender.transfer(val);
    }

    // TODO: Remove. This is just for testing signing + recovery. I.e. determining whether I need a normal Eth
    // prefix. Same for 'recover'
    function recover_nv(uint128 nonce, uint128 val, uint8 v, bytes32 r, bytes32 s) external pure returns (address) {
        bytes32 hash = create_prefixed_hash(nonce, val);
        address signer = ecrecover(hash, v, r, s);

        return signer;
    }


    // method that creates the bytes object that we expect the signature to be of
    function create_prefixed_hash(uint128 nonce, uint128 val) public pure returns (bytes32) {
        // NOTE: packing nonce and val into a nice 32byte array
        //bytes memory data = abi.encodePacked(nonce, val);
        //require(data.length == 32, "packed data should be 32 bytes");

        //bytes32 message;

        //assembly {
            //message := mload(add(data, 0x20))
        //}

        bytes memory hashPrefix = "\x19Ethereum Signed Message:\n32";
        bytes memory message = abi.encodePacked(hashPrefix, nonce, val);

        bytes32 prefixedHash = keccak256(message);

        return prefixedHash;
    }
}
