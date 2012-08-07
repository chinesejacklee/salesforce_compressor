global class BatchCompressFile implements Database.Batchable<sObject>{ 
        public String query; 
        public String email; 
        public Id toUserId;  
        public Id fromUserId; 

     global database.querylocator start(Database.BatchableContext BC){ 
          return Database.getQueryLocator(query);
     } 

     global void execute(Database.BatchableContext BC, List<sObject> scope){ 
     	
     	   
     	
     	
            for(sObject s : scope){
            	Document a  =(Document)s;
            	
            	  
            	  UnicodeCharacter aaa=new UnicodeCharacter();
            	  string sss=aaa.LZWdecompressString(EncodingUtil.base64Encode(a.body));
            	
            	  
             } 
    
        
        /*
         Attachment adoc=[Select a.ParentId, a.ContentType, a.Body From Attachment a where id='00PA0000000yxmh'];
        String body=adoc.Body.tostring();
        
        UnicodeCharacter aaa=new UnicodeCharacter();
        
        aaa.OriginalText=body;
        //aaa.CompressAndDecompress();
        //System.debug('*************body.length():'+body.length());
        //System.debug('*************OriLength:'+aaa.OriLength);
        //System.debug('*************ComLength:'+aaa.ComLength);
        //System.debug('*************DecomLength:'+UnicodeCharacter.DecomLength);
        Blob ablob=blob.valueOf(aaa.LZWCompressString(body));
        Attachment bdoc=new Attachment(body=ablob,parentid=adoc.ParentId,contenttype=adoc.ContentType,name='CompressedTest4.txt');
       insert bdoc;
       
       system.debug('????????????????:'+bdoc.body.tostring().length());
       */

     } 
     
     global void finish(Database.BatchableContext BC){ 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
	    mail.setToAddresses(new String[] {email}); 
        mail.setSenderDisplayName('Batch Processing'); 
        mail.setSubject('Batch Process Completed'); 
        mail.setPlainTextBody('Batch Process has completed'); 

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    } 
}