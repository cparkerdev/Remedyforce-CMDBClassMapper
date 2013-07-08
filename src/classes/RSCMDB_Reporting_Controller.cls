/**
	* RSCMDB_Reporting_Controller - <description>
	* @author: Collin Parker
	* @version: 1.0
*/

public class RSCMDB_Reporting_Controller {

	final String srcObjName = 'BMCServiceDesk__BMC_BaseElement__c';
	
	public Boolean displayPop {get; set;}
	public Boolean displayExec {get; set;}
	
	public RSCMDB_Report_Config__c newCfg {get; set;}
	public Id cfgId {get; set;}
	
	
	public List<RSCMDB_Report_Config__c> getConfigs () {
		return [Select Class_Name__c, FK_Field__c, Id from RSCMDB_Report_Config__c];
	}
	
	public List<SelectOption> getCMDBClassSelect () {
		List<sObject> classList = [select Id, BMCServiceDesk__ClassName__c from BMCServiceDesk__CMDB_Class__c where BMCServiceDesk__Abstract__c = false and BMCServiceDesk__ClassType__c = 'Class' order by BMCServiceDesk__ClassName__c];
		return RSCMDB_Utils.toSelOpts(classList,'BMCServiceDesk__ClassName__c','BMCServiceDesk__ClassName__c');
	}
	
	public List<SelectOption> getFields () {
			return RSCMDB_Utils.sort( RSCMDB_Utils.toSelOpts( RSCMDB_Utils.getObjLookupFields('BMCServiceDesk__BMC_BaseElement__c') ) );
	}
	
	
	public void addNew () {
		newCfg = new RSCMDB_Report_Config__c();
		showPop();
	}
	public void edit () {
		newCfg = [Select R.Class_Name__c, R.FK_Field__c, R.Id from RSCMDB_Report_Config__c R where R.Id = :cfgId LIMIT 1];	
		showPop();
	}
	public void save () {
		upsert newCfg;
		hidePop();
	}
	public void del () {
		delete new RSCMDB_Report_Config__c(Id=cfgId);
	}
	
	
	public void showPop() {
		displayPop = true;	
	}
	public void hidePop() {
		displayPop = false;
	}
	
	public void showExec() {
		displayExec = true;
	}
	public void hideExec() {
		displayExec = false;
	}
	
	public void execBatch() {
		RSCMDB_Reporting_Batch batchJob = new RSCMDB_Reporting_Batch(cfgId);
		Database.executeBatch(batchJob);
		hideExec();
	}
	
	
}