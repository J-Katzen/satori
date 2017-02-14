pragma solidity ^0.4.2;

contract SatoriRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }

contract satoris {
    mapping (address => bool) private owners;

    public function owned() {
        owners[0x662f46ec437916b181f0ced5cef1ed43a10d859a] = true;     //Forever Satori's Coin -- hardcoded this shit
    }

    modifier onlyOwners {
        if (!owners[msg.sender]) throw;
        _;
    }

    // The onlySatori modifier ;)
    modifier onlySatori {
        if (msg.sender != 0x662f46ec437916b181f0ced5cef1ed43a10d859a) throw;
        _;
    }

    function addOwner(address newOwner) onlySatori {
        owners[newOwner] = true;
    }

    function removeOwner(address shitOwner) onlySatori {
        delete owners[shitOwner];
    }
}

contract Satori is satoris {
    /* Public variables of the token */
    string public standard = 'Satori v0.2b-rc21';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    // banned peeps
    mapping (address => bool) public banned;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event BanHammer(address indexed banner, address index hammered);
    event BanLifted(address indexed lifter, address index unhammered);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function Satori() {
        balanceOf[msg.sender] = 0;                          // Give the creator all initial tokens
        totalSupply = 0;                        // Update total supply
        name = 'Satori';                                    // Satoris
        symbol = 'SAT';                                     // SATs
        decimals = 0;                                       // Round numbers bitch
    }

    modifier nonBanned {
        if (banned[msg.sender]) throw;
        _;
    }

    function mintSatoris(address target, uint256 mintedAmount) onlyOwners {
        balaneceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, msg.sender, mintedAmount);
        Transfer(msg.sender, target, mintedAmount);
    }

    function banHammer(address bannedAddress) onlyOwners {
        banned[bannedAddress] = true;
        BanHammer(msg.sender, bannedAddress);
    }

    function banLifted(address unbannedAddress) onlyOwners {
        delete banned[bannedAddress];
        BanLifted(msg.sender, unbannedAddress);
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) notBanned {
        if (_value < 0) throw;                               // Cannot transfer negative balance
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }
    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        throw;     // Prevents accidental sending of ether
    }
}
