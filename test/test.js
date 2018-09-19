var IvtMultiSigWallet= artifacts.require('./IvtMultiSigWallet.sol');

contract("IvtMultiSigWallet", function(accounts) {

    it("Contract deploy success", function() {
    return IvtMultiSigWallet.deployed(["0xcD63f1F9D5ecf522208c978a76679A573D0466E0"],1).then(function(instance) {
      assert.notEqual(IvtMultiSigWallet, null);
    });
  });
    //.....more code


});