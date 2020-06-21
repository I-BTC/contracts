## Sūrya's Description Report

### Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| contracts/treasury/Treasury.sol | 258795f2b5800469915ac58709aaa73f7e7ea3b7 |


### Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **Treasury** | Implementation | Treasury_ds |||
| └ | \<Constructor\> | Public ❗️ | 🛑  | |
| └ | setParent | Internal 🔒 | 🛑  | |
| └ | setLevels | Internal 🔒 | 🛑  | isSameLength |
| └ | setupTreasury | Public ❗️ | 🛑  | isInActive isOwner |
| └ | calcRate | Public ❗️ |   |NO❗️ |
| └ | LoopFx | Internal 🔒 | 🛑  | |
| └ | LevelChange | Internal 🔒 | 🛑  | |
| └ | purchase | Public ❗️ |  💵 | isActive isVaildReferer |
| └ | iMint | Internal 🔒 | 🛑  | isSaleClose |
| └ | claim | Public ❗️ |  💵 | isVaildClaim |
| └ | viewStatus | Public ❗️ |   |NO❗️ |
| └ | checkRef | Public ❗️ |   |NO❗️ |


### Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |
