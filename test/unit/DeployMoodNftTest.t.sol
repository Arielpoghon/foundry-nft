// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
//netlify

import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {Test} from "forge-std/Test.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testConvertSvgToUri() public view {
        string memory expectedUri =
            "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MDAiIGhlaWdodD0iNTAwIj4KPHRleHQgeD0iMjAwIiB5PSIyNTAiIGZpbGw9ImJsYWNrIj5IaSEgWW91IGRlY29kZWQgdGhpcyEgPC90ZXh0Pgo8L3N2Zz4=";
        string memory svg = string.concat(
            '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500">\n',
            '<text x="200" y="250" fill="black">Hi! You decoded this! </text>\n',
            "</svg>"
        );

        string memory actualUri = deployer.svgToImageURI(svg);

        assertEq(keccak256(abi.encodePacked(expectedUri)), keccak256(abi.encodePacked(actualUri)));
    }
}
