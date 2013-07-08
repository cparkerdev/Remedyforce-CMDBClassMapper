/**
	* RSCMDB_Reporting_Batch - <description>
	* @author: Collin Parker
	* @version: 1.0
*/

global class RSCMDB_Reporting_Batch implements Database.Batchable<sObject> {

	public String className {get; set;}
	public final String query = 'Select Id, BMCServiceDesk__InstanceID__c from BMCServiceDesk__BMC_BaseElement__c where BMCServiceDesk__ClassName__c = :className';
	public RSCMDB_Report_Config__c cfg {get; set;}
	
	
	global RSCMDB_Reporting_Batch(Id cfgId) {
		cfg = [Select Class_Name__c, FK_Field__c, Id from RSCMDB_Report_Config__c where Id = :cfgId];
		className = cfg.Class_Name__c;
	}
	
	
	global Database.QueryLocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator(query);
   	}

	
   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		RSCMDB_Utils.relate( scope, 'BMCServiceDesk__'+className+'__c', 'BMCServiceDesk__InstanceID__c', cfg.FK_Field__c );
	}	
	
	
	global void finish(Database.BatchableContext BC) {
	   System.debug('Batched Finished');
   	}
		
}