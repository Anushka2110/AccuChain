const chai = require('chai');
const {createMockProvider, deployContract, getWallets, solidity} = require('ethereum-waffle');
const MockContract = require('../build/Main');


chai.use(solidity);
const {expect} = chai;

describe('Testing smart contract', () => {
    let provider = createMockProvider();
    let [wallet, walletTo] = getWallets(provider);
    let contract;

    let transcriptHash = "0xca44444444444444444444444435b7d915458ef540ade6068dfe2f44e8fa733c";
    let v = 28;
    let r = '0xb07b415aacb80e5277ca1ed4f31ec801bae0c8df86840eee1fd11c28ef247a3c';
    let s = '0x54aaf2ef0f59cf1f17f81115cd4cf4691ed800af22f3f829bd80640b28dbd1e5';
    let signer = '0x24390B7f592839F644Ea46cea832A2450418dC7d'
  
    beforeEach(async () => {
      contract = await deployContract(wallet, MockContract);
    });

    it('Registers institute', async () => {
        const now = Math.floor((new Date()).getTime() / 1000);
        await expect(contract.registerInstitute()).to.emit(contract, 'instituteAdded').withArgs(1, wallet.address, now);
    });

    it('Adds transcript successfully', async () => {
        const now = Math.floor((new Date()).getTime() / 1000);
        await contract.registerInstitute()
        await expect(contract.addTranscript(1, transcriptHash, v, r, s)).to.emit(contract, 'transcriptAdded');
    });

    it('Adding transcript reverts with error', async () => {
        await expect(contract.addTranscript(1, transcriptHash, v, r, s)).to.be.revertedWith("institute does not exist");
    });

    it('Verifies transcript', async () => {
        expect(await contract.isTranscriptAuthentic(transcriptHash, signer, v, r, s)).to.eq(true);
    });

    it('gets the wrong institute', async () => {
        await expect(contract.getInstituteById(5)).to.be.reverted;
    });

    it('gets transcript by id', async() => {
        await expect(contract.getTranscriptById(1)).to.be.reverted;
    });

})