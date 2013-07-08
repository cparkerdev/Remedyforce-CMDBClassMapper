/**
	* RSCMDB_Utils - <description>
	* @author: Collin Parker
	* @version: 1.0
*/

public class RSCMDB_Utils {

	
	static public List<SelectOption> toSelOpts (List<String> vals) {
	
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','<Select Value>'));
			
		for (String v : vals) { 
			options.add(new SelectOption(v,v));
		}
		
		return options; 
	}
	static public List<SelectOption> toSelOpts (List<sObject> sObjs, String key, String val) 
	{
	
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','<Select Value>'));
			
		for (sObject sObj : sObjs) { 
			options.add(new SelectOption(String.valueOf(sObj.get(key)),String.valueOf(sObj.get(val))));
		}
		
		return options; 
	}
	
	static public List<String> getObjFields (String objName) {
	
		List<String> fields = new List<String>();
		sObjectType sType = Schema.getGlobalDescribe().get(objName);
			
		if (sType != null) {
				
			for (sObjectField sField : sType.getDescribe().fields.getMap().values()) {
				fields.add(sField.getDescribe().getName());	
			}
		}
		
		return fields; 
	}
	static public List<String> getObjLookupFields (String objName) {
	
		List<String> fields = new List<String>();
		sObjectType sType = Schema.getGlobalDescribe().get(objName);
			
		if (sType != null) {
				
			for (sObjectField sField : sType.getDescribe().fields.getMap().values()) {
				DescribeFieldResult res = sField.getDescribe();
				if (res.getType() == Schema.DisplayType.Reference) fields.add(res.getName());	
			}
		}
		
		return fields; 
	}
	
	static public Map<String,sObject> toStringSObjMap(List<sObject> sObjs, String keyField) {
	
		Map<String,sObject> retMap = new Map<String,sObject>();
		
		for (SObject sObj : sObjs) {
			if ( exists(getFieldValue(keyField,sObj)) ) {
				retMap.put( String.valueOf(getFieldValue(keyField,sObj)), sObj );
			}
		}
		
		return retMap;
		
	}
	static public Set<String> toStringSet( List<sObject> sObjs, String fieldName  ) {
		Set<String> objSet = new Set<String>();
		for (sObject sObj : sObjs) {
			Object val = sObj.get(fieldName);
			if(val != null) objSet.add(String.valueOf(val));
		}
		return objSet;
	}
	static public Map<String,List<sObject>> toMapList (List<sObject> sObjs, String[] keys) {
		
		Map<String,List<sObject>> ret = new Map<String,List<sObject>>();
		for (sObject sObj : sObjs) {
			
			String key = concat(pluck(sObj, keys));
			if ( ret.containsKey(key) ) {
				ret.get(key).add(sObj);
			} else {
				List<sObject> newList = new List<sObject>();
				newList.add(sObj);
				ret.put(key, newList);
			}
			
		}
		return ret;
	}
	
	static public List<SelectOption> sort (List<SelectOption> opts) {
		opts.sort();
		return opts;
	}
	
	static public List<Object> pluck(sObject sObj, String[] fields) {
	
		List<Object> ret = new List<Object>();

		for (String f : fields) {		
			Object fVal = sObj.get(f);
			ret.add(fVal);
		}
		return ret;
	}
	static public String concat (List<Object> vals) {
		String retStr;
		for ( Object v :  vals ) {
			if (retStr == null) {
				retStr = String.valueOf(v);
			} else {
				retStr += String.valueOf(v);
			}
		}
		return retStr;
	}
	
	static public void relate( List<sObject> sObjs, String childObjName, String joinKey, String childFKField ) {
		
		Set<String> instIds = toStringSet( sObjs, joinKey );
		String query = String.format('select Id, {0} from {1} where {0} IN :instIds', new List<String>{joinKey,childObjName});
		System.debug('CPDEBUG:');
		System.debug(query);

		List<sObject> classObjs =  Database.query(query);
		System.debug(classObjs);
		System.debug(instIds);
		Map<String,sObject> classObjMap = toStringSObjMap(classObjs, joinKey);
		
		for (sObject sObj : sObjs) {
			String instId = String.valueOf(sObj.get(joinKey));
			System.debug(classObjMap);
			Id classId = classObjMap.get(instId).Id;
			
			sObj.put( childFKField, classId );
		}
		
		update sObjs;
		
	}
	
	
	static Object getFieldValue(String fieldName, sObject sObj) {
	
		Integer dotIndex = fieldName.indexOf('.');

		if ( dotIndex == -1 ) {
			return sObj.get(fieldName);
		} else {
			
			List<String> fieldNames = fieldName.split('\\.');
			SObject childSObj = sObj.getsObject(fieldNames[0]);
			if (childSObj != null) {
				return childSObj.get(fieldNames[1]);
			} else {
				return null;	
			}
		}
	}
	static public Boolean exists(Object val) {
		
		if (val != null && String.valueOf(val) != '' ) {
			return true;	
		} else {
			return false;
		}
		
	}
}