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

        bytes memory data = abi.encodePacked(nonce, val);
        bytes32 hashed = keccak256(data);

        address signer = ecrecover(hashed, v, r, s);
        require(signer == owner, "Data must be signed by contract owner");

        msg.sender.transfer(val);
    }
}
