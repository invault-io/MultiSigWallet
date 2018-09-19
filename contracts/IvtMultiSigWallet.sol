pragma solidity ^0.4.21;

import "../library/RLPEncode.sol";
//https://github.com/sammayo/solidity-rlp-encoder

import "./TypeConv.sol";

contract IvtMultiSigWallet {
    
    event Deposit(address _sender, uint256 _value);
    event Transacted(address _to, address _tokenContractAddress, uint256 _value);

    mapping (address => bool) private signers;
    mapping (uint256 => bool) private transactions;
    mapping (address => bool) private signedAddresses;

    address private owner;
    uint8 private required;

    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    constructor(address[] _signers, uint8 _required) public{
        require(_required <= _signers.length && _required > 0 && _signers.length > 0);

        for (uint8 i = 0; i < _signers.length; i++){
            require(_signers[i] != address(0));
            signers[_signers[i]] = true;
        }
        required = _required;
        owner = msg.sender;
    }

    function() payable public{
        if (msg.value > 0)
            emit Deposit(msg.sender, msg.value);
    }

    function submitTransaction(address _destination, string _value, string _strTransactionData, uint8[] _v, bytes32[] _r, bytes32[] _s) onlyOwner public{
        processAndCheckParam(_destination, _strTransactionData, _v, _r, _s);

        uint256 transactionValue = TypeConv.stringToUint(_value);
        bytes32 _msgHash = getMsgHash(_destination, _value, _strTransactionData);
        verifySignatures(_msgHash, _v, _r, _s);

        _destination.transfer(transactionValue);

        emit Transacted(_destination, 0, transactionValue);
    }

    function submitTransactionToken(address _destination, address _tokenContractAddress, string _value, string _strTransactionData, uint8[] _v, bytes32[] _r,bytes32[] _s) onlyOwner public{
        processAndCheckParam(_destination, _strTransactionData, _v, _r, _s);

        uint256 transactionValue = TypeConv.stringToUint(_value);
        bytes32 _msgHash = getMsgHash(_destination, _value, _strTransactionData);
        verifySignatures(_msgHash, _v, _r, _s);

        ERC20Interface instance = ERC20Interface(_tokenContractAddress);
        require(instance.transfer(_destination, transactionValue));

        emit Transacted(_destination, _tokenContractAddress, transactionValue);
    }

    function getMsgHash(address _destination, string _value, string _strTransactionData) constant internal returns (bytes32){
        bytes[] memory rawTx = new bytes[](9);
        bytes[] memory bytesArray = new bytes[](9);

        rawTx[0] = hex"09";
        rawTx[1] = hex"09502f9000";
        rawTx[2] = hex"5208";
        rawTx[3] = TypeConv.addressToBytes(_destination);
        rawTx[4] = TypeConv.strToBytes(_value);
        rawTx[5] = TypeConv.strToBytes(_strTransactionData);
        rawTx[6] = hex"03"; //03=testnet,01=mainnet

        for(uint8 i = 0; i < 9; i++){
            bytesArray[i] = RLPEncode.encodeBytes(rawTx[i]);
        }

        bytes memory bytesList = RLPEncode.encodeList(bytesArray);

        return keccak256(bytesList);
    }

    function processAndCheckParam(address _destination, string _strTransactionData, uint8[] _v, bytes32[] _r, bytes32[] _s)  internal{
        require(_destination != 0 && _destination != address(this) && _v.length == _r.length && _v.length == _s.length && _v.length > 0);

        string memory strTransactionTime = TypeConv.subString(_strTransactionData, 40, 48);
        uint256 transactionTime = TypeConv.stringToUint(strTransactionTime);
        require(!transactions[transactionTime]);

        string memory strTransactionAddress = TypeConv.subString(_strTransactionData, 0, 40);
        address contractAddress = TypeConv.stringToAddr(strTransactionAddress);
        require(contractAddress == address(this));

        transactions[transactionTime] = true;

    }

    function verifySignatures(bytes32 _msgHash, uint8[] _v, bytes32[] _r,bytes32[] _s) view private{
        uint8 hasConfirmed = 0;
        address[] memory  tempAddresses = new address[](_v.length);
        address tempAddress;

        for (uint8 i = 0; i < _v.length; i++){
            tempAddress = ecrecover(_msgHash, _v[i], _r[i], _s[i]);
            tempAddresses[i] = tempAddress;

            require(signers[tempAddress] && (!signedAddresses[tempAddress]));
            signedAddresses[tempAddress] = true;
            hasConfirmed++;
        }
        
        for (uint8 j = 0; j < _v.length; j++){
            delete (signedAddresses[tempAddresses[j]]);
        }

        require(hasConfirmed >= required);
    }
}


contract ERC20Interface {
    function transfer(address _to, uint256 _value) public returns (bool success);
    function balanceOf(address _owner) public constant returns (uint256 balance);
}
