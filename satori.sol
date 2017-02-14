pragma solidity ^0.4.2;

// I'd have an apostrophe s...but programming
contract satoris {
    // other owners of the Satori economy...if he deems fit
    address public satoriWallet;
    mapping (address => bool) private owners;

    function satoris() {
        satoriWallet = 0x662f46ec437916b181f0ced5cef1ed43a10d859a;     //Forever Satori's Coin -- hardcoded this shit
    }

    modifier onlyOwners {
        if (!owners[msg.sender] && msg.sender != satoriWallet) throw;
        _;
    }

    // The onlySatori modifier ;)
    modifier onlySatori {
        if (msg.sender != satoriWallet) throw;
        _;
    }

    // Only Satori himself can add or remove owners
    function addOwner(address newOwner) onlySatori {
        owners[newOwner] = true;
    }

    // What'd you do to get on Satori's bad side?
    function removeOwner(address shitOwner) onlySatori {
        delete owners[shitOwner];
    }
}

// A Satori...the root of what makes up the great Satori economy
contract Satori is satoris {
    // token veresion
    string public version = 'Satori v0.2b-rc21';
    // other properties and shiz
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    struct SatoriIlluminati {
        string      name;
        uint256     satoriBalance;
    }

    // banned peeps
    mapping (address => bool) public banned;
    // the illuminati of Satoris
    mapping (address => SatoriIlluminati) public illuminati;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event BanHammer(address indexed banner, address indexed hammered);
    event BanLifted(address indexed lifter, address indexed unhammered);
    event SatoriIlluminatiConfirmed(address indexed member, string alias);
    event TransferIlluminatiOwnership(address indexed oldAddress, address indexed newAddress);

    // The constructor...where it all began
    // Hard coding for assurance that this coin will not be tampered with
    function Satori() {
        totalSupply = 0;                        // Update total supply
        name = 'Satori';                                    // Satoris
        symbol = 'SAT';                                     // SATs
        decimals = 0;                                       // Round numbers bitch
        illuminati[0x662f46ec437916b181f0ced5cef1ed43a10d859a] = SatoriIlluminati('Satori', 0); // The Satori Himself
        SatoriIlluminatiConfirmed(0x662f46ec437916b181f0ced5cef1ed43a10d859a, 'Satori');
    }

    // Be wary of being banned...
    modifier notBanned {
        if (banned[msg.sender]) throw;
        _;
    }

    // Illuminati Only...
    modifier isIlluminati {
        if (bytes(illuminati[msg.sender].name).length == 0) throw;
        _;
    }

    // What can owners do?  Mint SATs of course.
    function mintSatoris(address target, uint256 mintedAmount) onlyOwners {
        illuminati[target].satoriBalance += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, msg.sender, mintedAmount);
        Transfer(msg.sender, target, mintedAmount);
    }

    // And give the BANHAMMER
    function banHammer(address bannedAddress) onlyOwners {
        banned[bannedAddress] = true;
        BanHammer(msg.sender, bannedAddress);
    }

    // Or be benevolent leaders
    function banLifted(address unbannedAddress) onlyOwners {
        delete banned[unbannedAddress];
        BanLifted(msg.sender, unbannedAddress);
    }

    function changeSatoriAddress(address newSatori) onlySatori {
        illuminati[newSatori] = SatoriIlluminati(illuminati[satoriWallet].name, illuminati[satoriWallet].satoriBalance);
        delete illuminati[satoriWallet];
        satoriWallet = newSatori;
    }

    // Only through trade can the Satori market flourish
    function transfer(address _to, uint256 _value) notBanned isIlluminati {
        if (_value < 0) throw;                               // Cannot transfer negative balance
        // setup the new following...
        if (bytes(illuminati[_to].name).length == 0) {
            illuminati[_to] = SatoriIlluminati('New Follower', 0);
        }

        if (illuminati[msg.sender].satoriBalance < _value) throw;           // Check if the sender has enough
        if (illuminati[_to].satoriBalance + _value < illuminati[_to].satoriBalance) throw; // Check for overflows
        illuminati[msg.sender].satoriBalance -= _value;                     // Subtract from the sender
        illuminati[_to].satoriBalance += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Everyone must know of the Satori trades
    }

    // Identify yourself...
    function setAlias(string alias) notBanned {
        if (bytes(illuminati[msg.sender].name).length == 0) {
            illuminati[msg.sender] = SatoriIlluminati(alias, 0);
        } else {
            illuminati[msg.sender].name = alias;
        }
        SatoriIlluminatiConfirmed(msg.sender, alias);
    }

    function transferIlluminatiAddressOwnership(address newAddress) notBanned isIlluminati {
        illuminati[newAddress] = SatoriIlluminati(illuminati[msg.sender].name, illuminati[msg.sender].satoriBalance);
        delete illuminati[msg.sender];
        TransferIlluminatiOwnership(msg.sender, newAddress);
    }

    // WTF?!
    function () {
        throw;     // WAI?!?
    }
}
