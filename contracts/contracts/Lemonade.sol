pragma solidity ^0.6.2;

contract Lemonade {
    address owner;
    uint128 public nextNonce;

    constructor() public {
        owner = msg.sender;
        nextNonce = 0;
    }

    function verify(uint128 nonce, uint128 val, uint8 v, bytes32 r, bytes32 s) external {
        require(check_nonce(nonce), "Nonce must be the expected next nonce");
        require(check_val(val), "Contract must have enough balance to cover val");

        require(check_signature(nonce, val, v, r, s), "Signature must be valid!");

        nextNonce += 1;
        msg.sender.transfer(val);
    }

    function check_nonce(uint128 nonce) public view returns (bool) {
        return nonce == nextNonce;
    }

    function check_val(uint128 val) public view returns (bool) {
        return address(this).balance >= val;
    }

    function check_balance() public view returns (uint256) {
        return address(this).balance;
    }

    function check_signature(uint128 nonce, uint128 val, uint8 v, bytes32 r, bytes32 s) public view returns (bool) {
        bytes32 hash = create_prefixed_hash(nonce, val);
        address signer = ecrecover(hash, v, r, s);

        return signer == owner;
    }

    // method that creates the bytes object that we expect the signature to be of
    function create_prefixed_hash(uint128 nonce, uint128 val) public pure returns (bytes32) {
        bytes memory hashPrefix = "\x19Ethereum Signed Message:\n32";
        bytes memory message = abi.encodePacked(hashPrefix, nonce, val);

        bytes32 prefixedHash = keccak256(message);

        return prefixedHash;
    }

    function withdraw() external {
        msg.sender.transfer(address(this).balance);
    }

    receive() external payable {
    }
}
