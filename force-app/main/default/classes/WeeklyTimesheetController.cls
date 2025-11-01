public with sharing class WeeklyTimesheetController {

     @AuraEnabled(cacheable=true)
    public static dbt__Timesheet__c getTimesheet(Id timesheetId){
        System.debug('begin getTimesheet: '+timesheetId);
        dbt__Timesheet__c timesheet = [select Id,
                name,
                dbt__Employee__c, 
                dbt__Start_Date__c, 
                dbt__End_Date__c 
                from dbt__Timesheet__c 
                WHERE Id = :timesheetId
                WITH SECURITY_ENFORCED];


        System.debug('after getTimesheet: '+timesheet);
        return timesheet;
    }

    @AuraEnabled(cacheable=true)
    public static List<dbt__Timesheet__c> getEmployeeTimesheetItems(String empId, String recordId){
        System.debug('begin getEmployeeTimesheetItems: '+empId);
        List<dbt__Timesheet__c> emp = [select Id,
                Name,
                dbt__Employee__c, 
                dbt__Start_Date__c, 
                dbt__End_Date__c 
                from dbt__Timesheet__c 
                WHERE dbt__Employee__c = :empId
                and id != :recordId
                WITH SECURITY_ENFORCED
                ORDER BY dbt__Start_Date__c DESC
                LIMIT 10
                ];

        System.debug('after getEmployeeTimesheetItems: '+emp);
        return emp;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<dbt__Project_Employee__c> getProjects(String empId){
        System.debug('begin getProjects: '+empId);
        List<dbt__Project_Employee__c> projects = [SELECT Id,
                Name, 
                dbt__Project__c, 
                dbt__Project__r.Name, 
                dbt__Employee__c,
                dbt__Hourly_Rate__c,
                dbt__Project__r.dbt__Billable__c
                FROM dbt__Project_Employee__c 
                WHERE dbt__Employee__c = :empId
                WITH SECURITY_ENFORCED];
        
                System.debug('after getProjects: '+projects);
                return projects;
    }
    
    @AuraEnabled
    public static List<dbt__Timesheet_Line_Item__c> getWeeklyTimesheetItems(Id timesheetId){
        System.debug('begin getWeeklyTimesheetItems: '+timesheetId);
        List<dbt__Timesheet_Line_Item__c> week = [SELECT Id,
                dbt__Type__c, 
                dbt__Timesheet__c,
                dbt__Date__c,
                dbt__Project__c,
                dbt__Activity__c,
                dbt__Absence_Category__c,
                dbt__Description__c,
                dbt__Duration__c,
                dbt__Project__r.dbt__Billable__c
                FROM dbt__Timesheet_Line_Item__c
                WHERE dbt__Timesheet__c = :timesheetId
                WITH SECURITY_ENFORCED
                ORDER BY dbt__Date__c ASC];

        System.debug('after getWeeklyTimesheetItems: '+week);
        return week;
    }
    
    @AuraEnabled
    public static String upsertLineItems(List<dbt__Timesheet_Line_Item__c> lineItems) {
        System.debug('begin upsertLineItems: '+lineItems);
        
        if(lineItems == null || lineItems.isEmpty()){
            return 'Error: No Timesheet Line Items provided.';
        }
        
        String result = 'Success';

        try {
            SObjectAccessDecision decision =
            Security.stripInaccessible(
                AccessType.CREATABLE,
                lineItems,
                true
            );
            upsert decision.getRecords();
        } catch(Exception e) {
            result = 'Error: ' + e.getMessage();
        }
        System.debug('after upsertLineItems: '+result);
        return result;
    }

    @AuraEnabled
    public static String deleteTimesheetLineItems(List<dbt__Timesheet_Line_Item__c> lineItemIds) {
        System.debug('begin deleteTimesheetLineItems: '+lineItemIds);

        if(lineItemIds == null || lineItemIds.isEmpty()){
            return 'Error: No Timesheet Line Items provided.';
        }

        try {
            delete as user lineItemIds;
        } catch(Exception e) {
            return 'Error: ' + e.getMessage();
        }
        System.debug('after deleteTimesheetLineItems');
        return 'Success';
    }

}