// We require the Buidler Runtime Environment explicitly here. This is optional
// when running the script with `buidler run <script>`: you'll find the Buidler
// Runtime Environment's members available as global variable in that case.
const bre = require("@nomiclabs/buidler");

async function main() {
  // You can run Buidler tasks from a script.
  // For example, we make sure everything is compiled by running "compile"
  await bre.run("compile");

  // We require the artifacts once our contracts are compiled
  const Lemonade = bre.artifacts.require("Lemonade");
  const lemonade = await Lemonade.new();

  console.log("Lemonade address:", greeter.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
