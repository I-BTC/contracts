const IBTCToken = artifacts.require("IBTCToken");

module.exports = function( deployer ) {
  console.log("Contract Deployment Started - IBTCToken ")
  deployer.deploy( IBTCToken ).then( async function ( govC ) {
    console.log("Contract Setup Started - IBTCToken ")


    console.log("Contract Setup Ended - IBTCToken ")
  });
  console.log("Contract Deployment Ended - IBTCToken ")
};
