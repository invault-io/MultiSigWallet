# 以太坊多签智能合约

## 关于

适用于冷热钱包的多签智能合约. 

## 本合约的一些特性

1. 可用作任意n-of-m多签模式.
2. 支持ETH及其ERC20代币.
3. 防重放攻击. 
4. 主流硬件钱包支持(Trezor,Ledger).
5. 交易日志.

## 测试
A test suite is included through the use of the truffle framework, providing coverage for methods in the wallet.

### Installation

NodeJS 8.9.0 is recommended.

```shell
npm install
```

This installs truffle and an Ethereum test RPC client.

### Wallet Solidity Contract

Find it at [contracts/IvtMultiSigWallet.sol]

### Running tests

The truffle framework will depend on the Web3 interface to a local Web3 Ethereum JSON-RPC. If you've followed the above steps, run the following to start testrpc. 

```shell
npm run truffle-testrpc
```

You should verify that you are not already running geth, as this will cause the tests to run against that interface. 

In a **separate terminal window**, run the following command to initiate the test suite, which will run against the RPC:

```shell
npm run truffle-test
```


## 贡献

欢迎以github的形式对本项目贡献问题和改进.
当提交push请求时，请务必考虑修复单个bug或新增一个功能，在提交前请确保您已充分测试并提供相应的测试数据。


## 免责声明

此项目正处于开发阶段，仅供评估和测试。
作者不提供任何形式的保证。所有与使用本合约相关的直接风险均由用户承担。不对性能、适用性或/及其他方面提供任何保证。
如果您发现此项目内容包含错误，请联系我们以便这些错误得到及时的更正，Invault-io@invault.io。