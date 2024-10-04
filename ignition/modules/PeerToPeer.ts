import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from "hardhat";

const PeerToPeerLendingModule = buildModule("PeerToPeerLendingModule", (m) => {
    const deployPeerToPeerLending = m.contract("PeerToPeerLending", []);

    return { deployPeerToPeerLending};
});

export default PeerToPeerLendingModule;