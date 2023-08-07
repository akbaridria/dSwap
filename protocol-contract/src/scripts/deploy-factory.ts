import { ethers, run} from 'hardhat'
import * as fs from 'fs'
import * as path from 'path'
import chains from '../data/list-chains.json'
import { DSwapFactory__factory } from '../../typechain-types';

async function main() {
  const chain = chains.filter((item: any) => item.chainName === "Base")[0];
  // deploy factory contract with admin
  console.log('--------------------------------------');
  console.log("deploying factory contract...");
  console.log('--------------------------------------');
  const Factory:DSwapFactory__factory = await ethers.getContractFactory('DSwapFactory')
  const factory = await Factory.deploy(
    chain.admin
  )
  // deloy reward contract

  // set protocol fee address

  // verify contracts on etherscan

  const filePath = path.join(__dirname, "../data/chains.json");
  await fs.writeFileSync(filePath, JSON.stringify(chains, null, 2));
  console.log("done");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
