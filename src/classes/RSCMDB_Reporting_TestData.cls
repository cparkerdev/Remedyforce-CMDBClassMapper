/**
	* RSCMDB_Reporting_TestData - <description>
	* @author: Collin Parker
	* @version: 1.0
*/

@isTest
public class RSCMDB_Reporting_TestData {

	
	public static void createTestSettings() {
		RSCMDB_Report_Config__c cfg = new RSCMDB_Report_Config__c(Class_Name__c='BMC_ComputerSystem',FK_Field__c='BMCServiceDesk__Site__c');
		insert cfg;
	}
	
	
	public static void createTestCMDBClassesandCIs() {
	
		BMCServiceDesk__CMDB_Class__c csClass = new BMCServiceDesk__CMDB_Class__c(
			BMCServiceDesk__Abstract__c=false,
			BMCServiceDesk__ClassID__c='BMC_COMPUTERSYSTEM',
			BMCServiceDesk__ClassName__c='BMC_ComputerSystem',
			BMCServiceDesk__Namespace__c='BMC.CORE',
			BMCServiceDesk__ClassType__c='Class',
			BMCServiceDesk__SuperClass__c='BMC_System'
		);
		
		BMCServiceDesk__CMDB_Class__c beClass = new BMCServiceDesk__CMDB_Class__c(
			BMCServiceDesk__Abstract__c=false,
			BMCServiceDesk__ClassID__c='BMC_BASEELEMENT',
			BMCServiceDesk__ClassName__c='BMC_BaseElement',
			BMCServiceDesk__Namespace__c='BMC.CORE',
			BMCServiceDesk__ClassType__c='Class',
			BMCServiceDesk__SuperClass__c=''
		);
		
		insert csClass;
		insert beClass;
		
		List<BMCServiceDesk__BMC_BaseElement__c> beList = new List<BMCServiceDesk__BMC_BaseElement__c>();
		List<BMCServiceDesk__BMC_ComputerSystem__c> csList = new List<BMCServiceDesk__BMC_ComputerSystem__c>();
	
		for ( Integer i = 0; i < 5; i++ ) {
			BMCServiceDesk__BMC_BaseElement__c testbe = new BMCServiceDesk__BMC_BaseElement__c(
      			BMCServiceDesk__CMDB_Class__c = csClass.Id,
      			BMCServiceDesk__Name__c = 'testBE'+i,
				BMCServiceDesk__InstanceID__c=String.valueOf(i)
    		);
      		
			
			BMCServiceDesk__BMC_ComputerSystem__c testcs = new BMCServiceDesk__BMC_ComputerSystem__c(
      			BMCServiceDesk__InstanceID__c = String.valueOf(i)
    		);
			
			insert testbe;
			insert testcs;
			
		}
		
	}
	
	
}