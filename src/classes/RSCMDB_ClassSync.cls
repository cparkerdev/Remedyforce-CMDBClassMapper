/**
	* RSCMDB_ClassSync - <description>
	* @author: Collin Parker
	* @version: 1.0
*/

global class RSCMDB_ClassSync {

	@future
	global static void exec( Set<String> objIds, String objName, String childObjName, String joinKey, String childFKField ) {
		List<sObject> sObjs = Database.query('select Id, '+joinKey+' from BMCServiceDesk__BMC_BaseElement__c where Id IN :objIds');
		RSCMDB_Utils.relate( sObjs, childObjName, joinKey, childFKField );
		
	}
	
}