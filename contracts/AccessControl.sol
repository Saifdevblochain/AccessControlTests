// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/IAccessControl.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
 
 contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping(address => bool) members;
        bytes32 ADMIN;
    }

    mapping(bytes32 => RoleData) public _roles;

    // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32  public constant ADMIN = keccak256("ADMIN");

    // 0x97c877e40edb41710f0baf588c878ee15a04499b06ae8c98cf488875d91a7213
        bytes32 public constant MY_ROLE = keccak256("MY_ROLE");


     constructor(  address account){
       
    //   bytes32  ADMIN = keccak256("ADMIN");   
       _grantRole( ADMIN,   account);
        _setRoleAdmin( ADMIN,   ADMIN);
     }
 
    
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }

     
    function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
        return _roles[role].members[account];
    }

    
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }
 
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        Strings.toHexString(account),
                        " is missing role ",
                        Strings.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

     
    function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
        return _roles[role].ADMIN;
    }
 
    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    
    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    
    function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }
 
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].ADMIN = ADMIN;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }
 
    function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }
 
    function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}