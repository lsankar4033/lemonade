usePlugin("@nomiclabs/buidler-solhint");
usePlugin("@nomiclabs/buidler-truffle5");
usePlugin("@nomiclabs/buidler-ethers");
usePlugin("@nomiclabs/buidler-ganache");

module.exports = {
  defaultNetwork: "localhost", // NOTE: until buidlerevm can be exposed to multiple services
  solc: {
    version: "0.6.2"
  }
};
