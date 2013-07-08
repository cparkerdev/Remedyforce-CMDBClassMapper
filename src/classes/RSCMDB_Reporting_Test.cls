/**
	* RSCMDB_Reporting_Test - <description>
	* @author: Collin Parker
	* @version: 1.0
*/

@isTest
private class RSCMDB_Reporting_Test {
	
	static testMethod void triggerTest() {
		
		RSCMDB_Reporting_TestData.createTestSettings();
		
		Test.StartTest();
			RSCMDB_Reporting_TestData.createTestCMDBClassesandCIs();
		Test.StopTest();
		
		List<sObject> beObjs = Database.query('select Id, BMCServiceDesk__Site__c, BMCServiceDesk__InstanceID__c from BMCServiceDesk__BMC_BaseElement__c');
		for (sObject beObj : beObjs) {
			System.assertNotEquals(null,beObj.get('BMCServiceDesk__Site__c'));
		}
		
	}
	
	
	static testMethod void batchTest() {
		
		RSCMDB_Reporting_TestData.createTestCMDBClassesandCIs();
		RSCMDB_Reporting_TestData.createTestSettings();
		
		RSCMDB_Report_Config__c cfg = [Select Id from RSCMDB_Report_Config__c LIMIT 1];
		
		
		Test.StartTest();
		
			RSCMDB_Reporting_Batch batchJob = new RSCMDB_Reporting_Batch(cfg.Id);
			Database.executeBatch(batchJob);
		
		Test.StopTest();

		
		List<sObject> beObjs = Database.query('select Id, BMCServiceDesk__Site__c, BMCServiceDesk__InstanceID__c from BMCServiceDesk__BMC_BaseElement__c');
		for (sObject beObj : beObjs) {
			System.assertNotEquals(null,beObj.get('BMCServiceDesk__Site__c'));
		}

	}
	
	
	static testMethod void adminTest() {
		
		RSCMDB_Reporting_TestData.createTestCMDBClassesandCIs();
		RSCMDB_Reporting_TestData.createTestSettings();
		
		RSCMDB_Reporting_Controller rptCtr = new RSCMDB_Reporting_Controller();
		
		List<RSCMDB_Report_Config__c> cfgs = rptCtr.getConfigs();
		rptCtr.newCfg = cfgs[0];
		rptCtr.cfgId = rptCtr.newCfg.Id;
		
		List<SelectOption> classOpts = rptCtr.getCMDBClassSelect();
		List<SelectOption> fieldOpts =  rptCtr.getFields();
		
		
		rptCtr.showExec();
		rptCtr.showPop();
		rptCtr.edit();
		rptCtr.save();
		rptCtr.hidePop();
		rptCtr.hideExec();
		
		Test.StartTest();
			rptCtr.execBatch();
		Test.StopTest();
		
		rptCtr.del();
		rptCtr.addNew();
		
		
	}
	
}