# Ticket-To-Space-NFT MoonDAO
#Project Dir
```
├─ IERC20.sol
├─ MoonMeta.sol
├─ TransferHelper.sol
├─ artifacts
│    ├─ MoonMeta.json
│    ├─ MoonMeta_metadata.json
│    ├─ TransferHelper.json
│    └─ TransferHelper_metadata.json
├─ package-lock.json
└─ package.json
```

#At the begin
The main program is **MoonMeta.sol**
Use Remix set-up on the **Rinkerby test net**
Contract can set whether begin to mint and whether reveal now

##Can use writabel program to set
```
MAX_SUPPLY = 10000; //maximum supply number
mintPrice = 0.05 ether; //unit price
maxBalance = 2; //Maximum amount of NFT per address
maxMint = 2;  //Maximum amount mint at a time
MooneyCost = 5000*1e18;  //the number of MOONEY will burn
Mooney=0x2A6C3C56BbfEa0ce7A541C34feF7Ca4Ab0DcC9B2; //Contract address of MOONEY
```
##There are two steps to mint:
- You need to authorize $MOONEY ERC20 address 0x2A6C3C56BbfEa0ce7A541C34feF7Ca4Ab0DcC9B2 (on Rinkeby) first
-  If you need to mint number X that input the X in 'mintMoonMeta' (X is number)
