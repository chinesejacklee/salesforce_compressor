public class UnicodeCharacter {

public transient blob uploadedfile {get;set;}
public string filename {get;set;}
public Integer filesize {get;set;}

public  String OriginalText {get;set;}
public  String CompressedText {get;set;}
public  String DecompressedText {get;set;}

public  Integer OriLength {get;set;}
public  Integer ComLength {get;set;}
public  Integer DecomLength {get;set;}

public void submit(){
	//system.debug('*************************:'+EncodingUtil.base64Encode(uploadedfile).length());
}

public  void  CompressAndDecompress(){
	OriLength=OriginalText.length();
	list<integer> ints=compress(OriginalText);
	
	string s='';
	for(Integer i:ints){
		s=s+i+',';
	}
	s=s.substring(0,s.length()-1);
	CompressedText=s;
	ComLength=s.length();
	
	DecompressedText=decompress(ints);
	DecomLength=DecompressedText.length();
	
}

public  String fromCharCode(Integer aChar){
    Integer[] singleItemIntegerArray = new Integer[]{aChar};
    return string.fromCharArray(singleItemIntegerArray);
} 

public  String fromCharCode(Integer[] aCharArray){
    return string.fromCharArray(aCharArray);
}

public  String isUnicodeString(string strInput) {


        string rtn = '';
        string strChar = '';
        string strHex = '';
        if (strInput == null || strInput == '' || blob.valueOf(strInput).size() == strInput.length()) return rtn;

        //system.debug('Length of string: ' + strInput + ' = ' + strInput.length());
        for (integer nCol = 0; nCol <> strInput.length(); nCol++) {
            strChar = strInput.substring(nCol, (nCol + 1));
            //system.debug('Testing Character: ' + strChar);
            strHex = encodingUtil.convertToHex(blob.valueOf(strChar));
            if (strHex.length() > 2 && strHex.substring(0, 2) <> 'c2' && strHex.substring(0, 2) <> 'c3' && strHex.substring(0, 2) <> 'c4') {
                //system.debug('Unicode found - Hex equivalent: ' + strHex);
                rtn += strChar;
            }
        }

        return rtn;
    }
    private  Map<string,integer> dicoCompress = new Map<string,integer>();
    private  Map<integer,string> dicoDecompress = new Map<integer,string>();
    

    private  Map<string,integer> hexMap = new Map<string,integer>();
	
	 {
		for (Integer i = 0; i < 256; i++)
        {
            dicoCompress.put(fromCharCode(i),i);
        }
        
        for (Integer i = 0; i < 256; i++)
        {
            dicoDecompress.put(i,fromCharCode(i));
        }
		
	    hexMap.put('0',0);
	    hexMap.put('1',1);
	    hexMap.put('2',2);
	    hexMap.put('3',3);
	    hexMap.put('4',4);
	    hexMap.put('5',5);
	    hexMap.put('6',6);
	    hexMap.put('7',7);
	    hexMap.put('8',8);
	    hexMap.put('9',9);
	    hexMap.put('A',10);
	    hexMap.put('B',11);
	    hexMap.put('C',12);
	    hexMap.put('D',13);
	    hexMap.put('E',14);
	    hexMap.put('F',15);
	    hexMap.put('a',10);
	    hexMap.put('b',11);
	    hexMap.put('c',12);
	    hexMap.put('d',13);
	    hexMap.put('e',14);
	    hexMap.put('f',15);
	}
    
    public String charAtZero(string strInput){
    	return strInput.substring(0,1);
    }
    
    public  Integer charCodeAt(string strInput, Integer charIndex){

        
        return StringToAscWCode(strInput.substring(charIndex,charIndex+1))[0];
        
    }

    public  Integer[] StringToAscWCode(string strInput) {
        system.debug('///:'+strInput);
        string strHex = '0123456789ABCDEF';
        LIST<Integer> codeLIST = new LIST<Integer>();

        strHex = EncodingUtil.convertToHex(Blob.valueOf(strInput));
        if (strInput == null || strInput == '') return codeLIST;

        LIST<Integer> charLIST = new List<Integer>();
        Integer increment = 2;
        for(Integer i = 0; i < strHex.length(); i += increment) {
            Integer out = 0;
            //system.debug('>>>>>>>>>>>>>>>>>>>'+strHex.subString(i,i + 1));
            //system.debug('>>>>>>>>>>>>>>>>>>>'+hexMAP.get('5'));
            Integer c1 = (hexMAP.get(strHex.subString(i,i + 1)) * 16) + (hexMAP.get(strHex.subString(i + 1,i + 2)));
            Integer c2 = 0;         
            Integer c3 = 0;
            Integer c4 = 0;
            if(c1 <128) {
            	//Binary 	            Hex 	Decimal Interpretation
            	//00000000-01111111 	00-7F 	0-127 	Single-byte encoding (compatible with US-ASCII)
                charList.add(c1);
                increment = 2;
                continue;
            }
            if(c1 > 127 && c1 < 192) {
            	//10000000-10111111 	80-BF 	128-191 	Second, third, or fourth byte of a multi-byte sequence
                //throw new InvalidArgumentException('Error parsing HEX, probably not a UTF8 HEX string');
                continue;
            }
            if(c1 > 193 && c1 < 224) {
                //11000010-11011111 	C2-DF 	194-223 	Start of 2-byte sequence
                // first of 2
                increment = 4;              
            }
            if(c1 > 223 && c1 < 240) {
            	//11100000-11101111 	E0-EF 	224-239 	Start of 3-byte sequence
                // first of 3
                increment = 6;
            }
            if(c1 > 239 && c1 < 245) {
            	//11110000-11110100 	F0-F4 	240-244 	Start of 4-byte sequence
                // first of 4
                increment = 8;
            }
            
            c2 = (hexMAP.get(strHex.subString(i + 2,i + 3)) * 16) + (hexMAP.get(strHex.subString(i + 3,i + 4)));                        
            if(increment == 4) {
                out = (c1 - 192) * 64 + c2 - 128;
            }
            if(increment == 6) {
                c3 = (hexMAP.get(strHex.subString(i + 4,i + 5)) * 16) + (hexMAP.get(strHex.subString(i + 5,i + 6)));
                out = (c1-224)*4096 + (c2-128)*64 + c3 - 128;
            }
            if(increment == 8) {
                c4 = (hexMAP.get(strHex.subString(i + 6,i + 7)) * 16) + (hexMAP.get(strHex.subString(i + 7,i + 8)));
                out = (c1 - 240) * 262144 + (c2 - 128) * 4096 + (c3 - 128) * 64 + c4 - 128; 
            }
            charLIST.add(out);
        }       
        return charList;
    } 

     public  String LZWCompressString(String str){
        
        Integer skipnum = 5;

        String res = '';
        String txt2encode = str;
        String[] splitStr = txt2encode.split('');
        //there is bug in apex, it add a null into the first [0] after you use split('');
        splitStr.remove(0);
        Integer len = splitStr.size();
        Integer nbChar = 256+skipnum; 
        String buffer = '';
        //system.debug('len:'+len);
        for (Integer i = 0; i <= len; i++)
        {
            if(i<=len-1){
                String current = splitStr[i];
                if (dicoCompress.get(buffer + current) <> null)
	            {
	                buffer += current;
	            }
	            else
	            {
	               //enable 1, use '–' as input will throw an error
	              /*1*/ res += fromCharCode(dicoCompress.get(buffer)); 
	              //system.debug('???????????:'+dicoCompress.get(buffer));
	              /*2*/ dicoCompress.put(buffer + current,nbChar);
	              /*3*/ nbChar++;
	              /*4*/ buffer = current;
	            }
            }
            else{
            	    String current ='null';
            	    //system.debug('$$$$$$$$$$$$$:'+dicoCompress.get(buffer));
                    res += fromCharCode(dicoCompress.get(buffer));
                    dicoCompress.put(buffer + current,nbChar);
                    nbChar++;
                    buffer = current;
            }
            
            
        }
        return res;
    }
    
    public  String LZWDecompressString(String str)
	{
		Integer skipnum = 5;
		String txt2encode = str;
		String[] splitStr = txt2encode.split('');
		splitStr.remove(0);
		Integer length = splitStr.size();
		Integer nbChar = 256+skipnum;
		String buffer = '';
		String chaine = '';
		String result = '';
		for (Integer i = 0; i < length; i++)
		{
			Integer code = charCodeAt(txt2encode,i);
			String current = dicoDecompress.get(code);
			if (buffer == '')
			{
				buffer = current;
				result += current;
			}
			else
			{
				if (code <= 255+skipnum)
				{
					result += current;
					chaine = buffer + current;
					dicoDecompress.put(nbChar,chaine);
					nbChar++;
					buffer = current;
				}
				else
				{
					chaine = dicoDecompress.get(code);
					if (chaine == 'null') chaine = buffer + buffer.substring(0,1);
					result += chaine;
					dicoDecompress.put(nbChar,buffer + chaine.substring(0, 1));
					nbChar++;
					buffer = chaine;
					
				}
			}
		}
		return result;
	}
	
	   // from http://msdn.microsoft.com/en-us/goglobal/cc305145.aspx

    private static boolean IsLegalWindows1252(integer character)

    {

        return

            (

                /* 0x01-- */

                character == 338 /* LATIN CAPITAL LIGATURE OE */         ||

                character == 339 /* LATIN SMALL LIGATURE OE */           ||

                character == 352 /* LATIN CAPITAL LETTER S WITH CARON */ ||

                character == 353 /* LATIN SMALL LETTER S WITH CARON */   ||

                character == 376 /* LATIN CAPITAL LETTER Y WITH DIAERESIS */ ||

                character == 381 /* LATIN CAPITAL LETTER Z WITH CARON */ ||

                character == 382 /* LATIN SMALL LETTER Z WITH CARON */   ||

                character == 402 /* LATIN SMALL LETTER F WITH HOOK */    ||

                /* 0x02-- */

                character == 710 /* MODIFIER LETTER CIRCUMFLEX ACCENT */ ||

                character == 732 /* SMALL TILDE */                       ||

                /* 0x2--- */

                character == 8211 /* EN DASH */                           ||

                character == 8212 /* EM DASH */                           ||

                character == 8216 /* LEFT SINGLE QUOTATION MARK */        ||

                character == 8217 /* RIGHT SINGLE QUOTATION MARK */       ||

                character == 8218 /* SINGLE LOW-9 QUOTATION MARK */       ||

                character == 8220 /* LEFT DOUBLE QUOTATION MARK */        ||

                character == 8221 /* RIGHT DOUBLE QUOTATION MARK */       ||

                character == 8222 /* DOUBLE LOW-9 QUOTATION MARK */       ||

                character == 8224 /* DAGGER */                            ||

                character == 8225 /* DOUBLE DAGGER */                     ||

                character == 8226 /* BULLET */                            ||

                character == 8230 /* HORIZONTAL ELLIPSIS */               ||

                character == 8240 /* PER MILLE SIGN */                    ||

                character == 8249 /* SINGLE LEFT-POINTING ANGLE QUOTATION MARK */     ||

                character == 8250 /* SINGLE RIGHT-POINTING ANGLE QUOTATION MARK */    ||

                character == 8364 /* EURO SIGN */                         ||

                character == 8482 /* TRADE MARK SIGN */

            );

    }
    
     private static boolean IsLegalXmlChar(integer character)
    {
        return
            (
                character == 9 /* == '\t' == 9   */        ||
                character == 10 /* == '\n' == 10  */        ||
                character == 13 /* == '\r' == 13  */        ||
                (character >= 32 && character <= 55295) ||
                (character >= 57344 && character <= 65533) ||
                (character >= 65536 && character <= 1114111)
            );
    }
    
    public static LIST<Integer> StringToIntegerList(String strInput) {
 
              LIST<Integer> charLIST = new List<Integer>();
             
              if (strInput == null || strInput == '') return charLIST;
             
              string strHex = EncodingUtil.convertToHex(Blob.valueOf(strInput));
              if (strHex == null || strHex == '') return charLIST;
 
              // Build map to convert hex to decimal         
              Map<String,Integer> hexMAP = new Map<String,Integer>();
              for (integer nLoop = 0; nLoop < 16; nLoop++){          
                     hexMAP.put('0123456789abcdef'.subString(nLoop, nLoop+1), nLoop);
              }
 
              Integer increment = 2;
              for(Integer i = 0; i < strHex.length(); i += increment) {
                     Integer out = 0;
                    
                     Integer c1 = (hexMAP.get(strHex.subString(i,i + 1)) * 16) + (hexMAP.get(strHex.subString(i + 1,i + 2)));
                     Integer c2 = 0;                  
                     Integer c3 = 0;
                     Integer c4 = 0;
                     if(c1 <128) {
                           out = c1;
                           increment = 2;
                     }
                     else
                     {
                           if(c1 > 193 && c1 < 224) {
                                  // first of 2
                                  increment = 4;                          
                           }
                           if(c1 > 223 && c1 < 240) {
                                  // first of 3
                                  increment = 6;
                           }
                           if(c1 > 239 && c1 < 245) {
                                  // first of 4
                                  increment = 8;
                           }
 
                           c2 = (hexMAP.get(strHex.subString(i + 2,i + 3)) * 16) + (hexMAP.get(strHex.subString(i + 3,i + 4)));                                     
                           if(increment == 4) {
                                  out = (c1 - 192) * 64 + c2 - 128;
                           }
                           else if(increment == 6) {
                                  c3 = (hexMAP.get(strHex.subString(i + 4,i + 5)) * 16) + (hexMAP.get(strHex.subString(i + 5,i + 6)));
                                  out = (c1-224)*4096 + (c2-128)*64 + c3 - 128;
                           }
                           else if(increment == 8) {
                                  c4 = (hexMAP.get(strHex.subString(i + 6,i + 7)) * 16) + (hexMAP.get(strHex.subString(i + 7,i + 8)));
                                  out = (c1 - 240) * 262144 + (c2 - 128) * 4096 + (c3 - 128) * 64 + c4 - 128;
                           }
                     }
                    
                     if ((out != 0) && IsLegalXmlChar(out) && IsLegalWindows1252(out))
                           charLIST.add(out);
              }            
              return charList;
       }
       
       public string utf8_encode (string mm) {
       	
        string s= mm.replaceAll('/\r\n/g','\n');
        //system.debug('s:::::::'+s);
        String utftext = '';
 
        for (integer n = 0; n < s.length(); n++) {
 
            integer c = charCodeAt(s,n);
 
            if (c < 128) {
                utftext += fromCharCode(c);
            }
            else if((c > 127) && (c < 2048)) {
                utftext += fromCharCode((c >> 6) | 192);
                utftext += fromCharCode((c & 63) | 128);
            }
            else {
                utftext += fromCharCode((c >> 12) | 224);
                utftext += fromCharCode(((c >> 6) & 63) | 128);
                utftext += fromCharCode((c & 63) | 128);
            }
 
        }
 
        return utftext;
    }
    
    public List<Integer> compress(string uncompressed){
    	
    	Integer dictSize = 256;
		Map<String,Integer> dictionary = new Map<String,Integer>{};
		for (Integer i = 0; i < 256; i++)
		        {   
		        	
		            dictionary.put(''+fromCharCode(i),i);
		        }
		String w ='';
		List<integer> result = new list<integer>();
		Integer i=0;
		string[] stringlist=uncompressed.split('');
		//system.debug('stringlist size():'+stringlist.size());
		//system.debug('stringlist[0]:'+stringlist[0]);
		stringlist.remove(0);
		//system.debug('stringlist size():'+stringlist.size());
		//system.debug('stringlist[0]:'+stringlist[0]);
		for (string c:stringlist) 
		        {
		        		i=i+1;
		        		//system.debug('?????????????? c:'+c+'    w:'+w); 
		        		string wc = w + c;
		        		//system.debug('>>>>>>>>>>>>>> wc:'+wc); 
			            if (dictionary.containsKey(wc)){
			                //System.debug('contains the key:'+wc);
			                w = wc;
			            }
			            else {
			            	//system.debug('$$$$$$$$$$$$$$$$$$ w:'+w); 
			                result.add(dictionary.get(w));
			                //system.debug('>>>>>>>>>>>>>> result:'+dictionary.get(w)); 
			                // Add wc to the dictionary.
			                dictionary.put(wc,dictSize++);
			                w = ''+c;
			            }
		 }
		 
		 // Output the code for w.
		 if (!w.equals('')){
		            result.add(dictionary.get(w));
		 }
		            //system.debug('dictionary size:'+dictionary.size());
		            //system.debug('i:'+i); 
		        return result;
    	
    	
    }
    
     public String decompress(List<Integer> compressed) {
        // Build the dictionary.
        integer dictSize = 256;
        Map<Integer,String> dictionary = new Map<Integer,String>();
        for (integer i = 0; i < 256; i++){
            dictionary.put(i, '' + fromCharCode(i));
        }
            
		//system.debug('dictionary.containsKey(256):'+dictionary.containsKey(256));
        String w = '' + fromCharCode(compressed[0]);
        compressed.remove(0);
        String result = w;
        for (integer k : compressed) {
            String entry;
            if(k==256){system.debug('dictionary.containsKey(256):'+dictionary.containsKey(256));}
            if (dictionary.containsKey(k)){
            	//system.debug('k:'+k);
                entry = dictionary.get(k);
                //system.debug('entry 1:'+entry);
            }
            else if (k == dictSize){
                entry = w + charAtZero(w);
                //system.debug('entry 2:'+entry);
            }
            
            result += entry;
 
            // Add w+entry[0] to the dictionary.
            if(dictSize==256)system.debug('dictSize++');
            System.debug('entry:'+entry);
            System.debug('entry.charAtZero(0):'+charAtZero(entry));
            System.debug('w + entry.charAtZero(0):'+w + charAtZero(entry));
            dictionary.put(dictSize++, w + charAtZero(entry));
 
            w = entry;
        }
        return result;
    }
    
    /*
    UnicodeCharacter cc=new UnicodeCharacter();
	
	string s='';
	for(Integer i:cc.compress('TOBEORNOT') ){
		s=s+i+',';
	}
	s=s.substring(s.length()-1,s.length());
	system.debug('************:'+s);
	
	system.debug('~~~~~~~~~~~~~~~~~~~~~~:'+cc.decompress(cc.compress('The end begins as Harry, Ron, and Hermione go back to Hogwarts to find and destroy Voldemorts final horcruxes, but when Voldemort finds out about their mission, the biggest battle begins and life as they know it will never be the same again.')));
	
	//UnicodeCharacter cc=new UnicodeCharacter();
	//system.debug(cc.StringToAscWCode('O'));
    */
}