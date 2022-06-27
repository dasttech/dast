// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
import "./Utils.sol";

library Hashing  {
    using Utils for *;

   function reverseValue(string memory _base) internal pure returns(string memory){
        bytes memory _baseBytes = bytes(_base);
        assert(_baseBytes.length > 0);

        string memory _tempValue = new string(_baseBytes.length);
        bytes memory _newValue = bytes(_tempValue);

        for(uint i=0;i<_baseBytes.length;i++){
            _newValue[ _baseBytes.length - i - 1] = _baseBytes[i];
        }

        return string(_newValue);
    }
    
    function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
    bytes memory strBytes = bytes(str);
    bytes memory result = new bytes(endIndex-startIndex);
    for(uint i = startIndex; i < endIndex; i++) {
        result[i-startIndex] = strBytes[i];
    }
    return string(result);
}

    function hash(string memory token, string memory body) public pure returns(string memory){
     
        uint256 bodylen = bytes(body).length;
        uint256 halflen= (bodylen/2)+(bodylen%2);
        
        body = reverseValue(body);
        string memory part1 = substring(body,0,halflen);
        string memory part2 = substring(body,halflen,bodylen);
        body = string(abi.encodePacked(part2, part1));

        string[] memory tokenArr = new string[](5); 
        bytes memory tokens = bytes(token);
        uint256 tokenlen = tokens.length;
        uint tokenmod = tokenlen%5;

        uint start = 0;
        uint end = 2;

       for(uint i =0; i<5; i++){
           if(tokenmod>0){
               end+=1;
               tokenmod-=1;
           }

           tokenArr[i] = substring(token,start,end);

           start = end;
           end +=2;
       }

        string[] memory body2 = new string[](bodylen);
        bytes memory body3 = bytes(body);
       for(uint256 i = 0; i < body2.length; i++){
           string memory str =string(abi.encodePacked(body3[i]));
         
          if(Utils.compareStrings("a",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[0],"}}"));
          }
          else if(Utils.compareStrings("A",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[0],"cp}}"));
          }

         else if(Utils.compareStrings("e",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[1],"}}"));
          }
          else if(Utils.compareStrings("E",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[1],"cp}}"));
          }

          else if(Utils.compareStrings("i",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[2],"}}"));
          }
          else if(Utils.compareStrings("I",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[2],"cp}}"));
          }

          else if(Utils.compareStrings("o",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[3],"}}"));
          }
          else if(Utils.compareStrings("O",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[3],"cp}}"));
          }

          else if(Utils.compareStrings("u",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[4],"}}"));
          }
          else if(Utils.compareStrings("U",str)){
              body2[i] = string(abi.encodePacked("{{",tokenArr[4],"cp}}"));
          }

          else if(Utils.compareStrings(" ",str)){
              body2[i] = string(abi.encodePacked("{{","}}"));
          }
          else{
              body2[i] = str;
          }
       }
    string memory body4 = "";

    for (uint256 i = 0; i< body2.length; i++){
        body4 = string(abi.encodePacked(body4,body2[i]));
    }
        return body4;
    }

    function dehash(string memory token, string memory body) 
        public pure returns(string memory){

        string[] memory tokenArr = new string[](5); 
        bytes memory tokens = bytes(token);
        uint256 tokenlen = tokens.length;
        uint tokenmod = tokenlen%5;

        uint start = 0;
        uint end = 2;


        for(uint i =0; i<5; i++){
           if(tokenmod>0){
               end+=1;
               tokenmod-=1;
           }

           tokenArr[i] = substring(token,start,end);

           start = end;
           end +=2;
       }

        string memory body1;
        bytes memory body2 = bytes(body);
        uint256 tempCount = 0;
        string memory nextTemp;

       for(uint256 i = 0; i < body2.length; i++){
           string memory str =string(abi.encodePacked(body2[i]));
         
          if(Utils.compareStrings("{",str)){
              tempCount+=1;
              nextTemp = string(abi.encodePacked(nextTemp,"{"));
          }
          else if(Utils.compareStrings("}",str)){
              tempCount+=1;
              nextTemp = string(abi.encodePacked(nextTemp,"}"));

              if(tempCount==4){
                  if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[0],"}}"))
                      )){
                body1= string(abi.encodePacked(body1,"a"));
             }
                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[0],"cp}}"))
                      )){
                body1= string(abi.encodePacked(body1,"A"));
             }
                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[1],"}}"))
                      )){
                body1= string(abi.encodePacked(body1,"e"));
             }
                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[1],"cp}}"))
                      )){
                body1= string(abi.encodePacked(body1,"E"));
             }

                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[2],"}}"))
                      )){
                body1= string(abi.encodePacked(body1,"i"));
             }
                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[2],"cp}}"))
                      )){
               body1= string(abi.encodePacked(body1,"I"));
                      }

                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[3],"}}"))
                      )){
               body1= string(abi.encodePacked(body1,"o"));
                
             }
                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[3],"cp}}"))
                      )){
               body1= string(abi.encodePacked(body1,"O"));
                
             }

                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[4],"}}"))
                      )){
               body1= string(abi.encodePacked(body1,"u"));
                
             }
                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{",tokenArr[4],"cp}}"))
                      )){
                body1= string(abi.encodePacked(body1,"U"));
                
             }

                else if(Utils.compareStrings(
                      nextTemp,
                      string(abi.encodePacked("{{","}}"))
                      )){
                body1= string(abi.encodePacked(body1," "));
                
             }

            tempCount = 0;
            nextTemp = "";            

              }
          }

         else if(tempCount>0){
              nextTemp = string(abi.encodePacked(nextTemp,str));
          }
          else{
              body1= string(abi.encodePacked(body1,str));
          }
       }
    bytes memory body11 = bytes(body1);
    string memory body3 = "";


    for (uint256 i = 0; i< body11.length; i++){
        body3 = string(abi.encodePacked(body3,body11[i]));
    }
        
        uint256 bodylen = bytes(body3).length;
        string memory part2 = substring(body3,0,bodylen/2);
        string memory part1 = substring(body3,bodylen/2,bodylen);
        body3 = string(abi.encodePacked(part1, part2));
        body3 = reverseValue(body3);
        return body3;


    }

}