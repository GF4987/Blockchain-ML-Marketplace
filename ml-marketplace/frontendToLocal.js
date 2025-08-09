import Web3 from "web3";
import ContractABI from "./contracts/YourContract.json";

async function loadBlockchain() {
    // Connecting to local Ganache
    const web3 = new Web3(Web3.givenProvider || "hhtp://127.0.0.1:7545");
    const accounts = await web3.eth.requestAccounts();

    //Loading Contract
    const networkID = await web3.eth.net.getId();
    const deployedNetwork = ContractABI.networks[networkID];
    const contract = new web3.eth.Contract(ContractABI.abi, deployedNetwork && deployedNetwork.address);


    console.log("Contract loaded:", contract);
}