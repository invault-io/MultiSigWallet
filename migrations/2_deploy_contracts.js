var IvtMultiSigWallet =  artifacts.require("./IvtMultiSigWallet.sol");
module.exports = function(deployer) {
	const args = process.argv.slice()
  deployer.deploy(IvtMultiSigWallet,["0xcD63f1F9D5ecf522208c978a76679A573D0466E0"],1);
};
