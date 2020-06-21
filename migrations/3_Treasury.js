const IBTCToken = artifacts.require("IBTCToken");
const Treasury = artifacts.require("Treasury");

module.exports = function( deployer ,network , accounts ) {
  console.log("Contract Deployment Started - Treasury ")
  deployer.deploy( Treasury ).then( async function ( TreasuryC ) {
    console.log("Contract Setup Started - Treasury ");

    const SToken = await IBTCToken.at( IBTCToken.address );

    console.log(network)
    if( network === 'local' ){
      await SToken.setTreasury( TreasuryC.address  ).then(function (rec) { console.log(rec.tx + " - IBTCToken Setup - setTreasury " ) });
      await TreasuryC.setupTreasury(
          IBTCToken.address,
          "101000000000000000000000000",
          "10000000000000000",
          ["5000" , "6000" , "6500" , "7000" , "7500" , "8000" , "8500" , "9000" , "9500" , "10000" ],
          ["50000000000000000000" , "500000000000000000000" , "5000000000000000000000" ,"50000000000000000000000" , "100000000000000000000000" ,"200000000000000000000000" ,"400000000000000000000000" ,"800000000000000000000000" , "16000000000000000000000000" , "32000000000000000000000000" ],
          accounts[0]
      ).then(function (rec) { console.log(rec.tx + " - Treasury Setup - setupTreasury " ) });

    }else{
      await SToken.setTreasury( TreasuryC.address  ).then(function (rec) { console.log(rec.tx + " - IBTCToken Setup - setTreasury " ) });
      await TreasuryC.setupTreasury(
          IBTCToken.address,
          "101000000000000000000000000",
          "10000000000000000",
          ["5000" , "6000" , "6500" , "7000" , "7500" , "8000" , "8500" , "9000" , "9500" , "10000" ],
          ["50000000000000000000" , "500000000000000000000" , "5000000000000000000000" ,"50000000000000000000000" , "100000000000000000000000" ,"200000000000000000000000" ,"400000000000000000000000" ,"800000000000000000000000" , "16000000000000000000000000" , "32000000000000000000000000" ],
          "0xD5f3b639910C223fE6aC290C5f9dbC5903ac572E"
      ).then(function (rec) { console.log(rec.tx + " - Treasury Setup - setupTreasury " ) });

    }
    console.log("Contract Setup Ended - Treasury ")
  });
  console.log("Contract Deployment Ended - Treasury ")
};
