// SPDX-License-Identifier: MIT
// remove this line 
pragma solidity ^0.8.18;
//spdx
import {Test, console} from "forge-std/Test.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationsTest is Test {
    DeployMoodNft public deployer;
    MoodNft public moodNft;
    address public USER = makeAddr("USER");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURI() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipMoodIntegration() public {
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory sadSvgImageUri = deployer.svgToImageURI(sadSvg);
        string memory expectedTokenUri = _expectedTokenUri(sadSvgImageUri);

        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        string memory actualTokenUri = moodNft.tokenURI(0);
        console.log(actualTokenUri);

        assertEq(keccak256(abi.encodePacked(actualTokenUri)), keccak256(abi.encodePacked(expectedTokenUri)));
    }

    function _expectedTokenUri(string memory imageUri) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"Mood NFT", "description":"An NFT that reflects your mood!", "attributes":[{"trait_type":"Mood", "value":100}], "image":"',
                            imageUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
