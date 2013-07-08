/**
	* RSCMDB_Reporting_Sync - <description>
	* @author: Collin Parker
	* @version: 1.0
*/

trigger RSCMDB_Reporting_Sync on BMCServiceDesk__BMC_BaseElement__c bulk (after insert) {

	Map<String,List<sObject>> classMap = RSCMDB_Utils.toMapList( trigger.new, new List<String>{'BMCServiceDesk__ClassName__c'} );
	Set<String> classSet = classMap.keySet();
	System.debug('Class Set: '+ classSet);
	List<sObject> cfgs = Database.query('Select Id, Class_Name__c, FK_Field__c from RSCMDB_Report_Config__c where Class_Name__c IN :classSet');
	for (sObject cfg : cfgs) {
		
		String className = String.valueOf( cfg.get('Class_Name__c') );
		String fkField = String.valueOf( cfg.get('FK_Field__c') );
		
		List<sObject> beList = classMap.get( className );
		Set<String> beIds = RSCMDB_Utils.toStringSet(beList,'Id');
		
		if (beIds.size() > 0) RSCMDB_ClassSync.exec( beIds, 'BMCServiceDesk__BMC_BaseElement__c','BMCServiceDesk__'+className+'__c', 'BMCServiceDesk__InstanceID__c', fkField );
		
		
		
	}

}