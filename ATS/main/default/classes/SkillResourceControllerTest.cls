@isTest
public class SkillResourceControllerTest {
   
    @isTest
    public static void insertSkillResourceRecordsTest(){
        User adminUser = createAdminUser('Admin', 'User');
        insert adminUser;
        
        assignpermissionSetForAdmin(adminUser);
        System.runAs(adminUser){
            Resource__c resource1 = createResource();
            insert resource1;
       
            Skill__c skill1 = createSkill('.Net Developer');
            Skill__c skill2 = createSkill('Salesforce Developer');
            Skill__c skill3 = createSkill('Salesforce Admin');
            insert new List<Skill__c>{skill1, skill2, skill3};
           
            List<Skill_Resource__c> skillResourceList = new List<Skill_Resource__c>();
            Skill_Resource__c skillRes1 = createSkillResource(resource1.Id, skill1.Id, '02/2022', null, null, 'Beginner');
            Skill_Resource__c skillRes2 = createSkillResource(resource1.Id, skill2.Id, '02/2022', '02/2023', null, 'Intermediate');
            Skill_Resource__c skillRes3 = createSkillResource(resource1.Id, skill3.Id, null, null, '2 Years 5 Months', 'Expert');
            skillResourceList.addAll(new List<Skill_Resource__c>{skillRes1, skillRes2, skillRes3});
            
            String jsonData = JSON.serialize(skillResourceList);
       
            Test.startTest();
            SkillResourceController.updateSkillResourceRecords(jsonData, null);
            Test.stopTest();
       
            List<Skill_Resource__c> result = [SELECT Id FROM Skill_Resource__c WHERE Resource__c = :resource1.Id];
            System.assertEquals(3, result.size(), 'Record Count is not Matching in Insert Operation');
        }
    }

    @isTest
    public static void deleteSkillResourceRecordsTest(){
        User adminUser = createAdminUser('Admin', 'User');
        insert adminUser;
        
        assignpermissionSetForAdmin(adminUser);
        System.runAs(adminUser){
            Resource__c resource1 = createResource();
            insert resource1;
           
            Skill__c skill1 = createSkill('.Net Developer');
            Skill__c skill2 = createSkill('Salesforce Associate');
            insert new List<Skill__c>{skill1, skill2};
       
            Skill_Resource__c skillResource1 = createSkillResource(resource1.Id, skill1.Id, '06/2021', '02/2023', null, 'Intermediate');
            Skill_Resource__c skillResource2 = createSkillResource(resource1.Id, skill2.Id, '05/2021', null, null, 'Beginner');
            insert new List<Skill_Resource__c>{skillResource1, skillResource2};
       
            String[] rectoDelete = new List<String>{skillResource1.Id};
       
            Test.startTest();
            SkillResourceController.updateSkillResourceRecords(null, rectoDelete);
            Test.stopTest();
       
            List<Skill_Resource__c> result1 = [SELECT Id FROM Skill_Resource__c WHERE Resource__c = :resource1.Id];
            System.assertEquals(1, result1.size(), 'Record Count is not Matching in delete Operation-result1');
        }
    }

    @isTest
    public static void getSkillResourceRecordTest(){
        User adminUser = createAdminUser('Admin', 'User');
        insert adminUser;
        
        assignpermissionSetForAdmin(adminUser);
        System.runAs(adminUser){
            Resource__c resource1 = createResource();
            insert resource1;
           
            Skill__c skill1 = createSkill('.Net Developer');
            Skill__c skill2 = createSkill('Salesforce Associate');
            insert new List<Skill__c>{skill1, skill2};
       
            Skill_Resource__c skillResource1 = createSkillResource(resource1.Id, skill1.Id, '06/2021', '02/2023', null, 'Intermediate');
            Skill_Resource__c skillResource2 = createSkillResource(resource1.Id, skill2.Id, '05/2021', null, null, 'Beginner');
            insert new List<Skill_Resource__c>{skillResource1, skillResource2};
       
            Test.startTest();
            SkillResourceController.getSkillResources(resource1.Id);
            Test.stopTest();
       
            List<Skill_Resource__c> result1 = SkillResourceController.getSkillResources(resource1.Id);
            System.assertEquals(2, result1.size(), 'Record Count is not Matching in Get Operation');
        }
    }

    @isTest
    public static void insertAndDeleteSkillResourceRecordsTest(){
        User adminUser = createAdminUser('Admin', 'User');
        insert adminUser;
        
        assignpermissionSetForAdmin(adminUser);
        System.runAs(adminUser){
            Resource__c resource1 = createResource();
            insert resource1;
            
            Skill__c skill1 = createSkill('.Net Developer');
            Skill__c skill2 = createSkill('Salesforce Developer');
            Skill__c skill3 = createSkill('Salesforce Admin');
            Skill__c skill4 = createSkill('Business Analysis');
            insert new List<Skill__c>{skill1, skill2, skill3, skill4};
     
            List<Skill_Resource__c> skillResourceList = new List<Skill_Resource__c>();
            Skill_Resource__c skillRes1 = createSkillResource(resource1.Id, skill1.Id, '02/2022', null, null, 'Beginner');
            insert skillRes1;
       
            Skill_Resource__c skillRes2 = createSkillResource(resource1.Id, skill2.Id, '02/2022', '02/2023', null, 'Intermediate');
            insert skillRes2;
       
            Skill_Resource__c skillRes3 = createSkillResource(resource1.Id, skill3.Id, null, null, '2 Years 5 Months', 'Expert');
            Skill_Resource__c skillRes4 = createSkillResource(resource1.Id, skill4.Id, '06/2022', '05/2023', null, 'Expert');
            skillResourceList.addAll(new List<Skill_Resource__c>{skillRes3, skillRes4});

            String[] rectoDelete = new List<String>{skillRes1.Id};
            String jsonData = JSON.serialize(skillResourceList);
       
            Test.startTest();
            SkillResourceController.updateSkillResourceRecords(jsonData, rectoDelete);
            Test.stopTest();
       
            List<Skill_Resource__c> result = [SELECT Id FROM Skill_Resource__c WHERE Resource__c = :resource1.Id];
            System.assertEquals(3, result.size(), 'Record Count is not Matching in Insert Operation');
        }
    }

    // --- Helper Methods ---
    private static Skill_Resource__c createSkillResource(Id resourceId, Id skillId, String startDate, String endDate, String experience, String levelofExperience){ // NOPMD
        Skill_Resource__c skillResourceRec = new Skill_Resource__c();
        skillResourceRec.Resource__c = resourceId;
        skillResourceRec.Skill__c = skillId;
        skillResourceRec.Start_date__c = startDate;
        skillResourceRec.End_date__c = endDate;
        skillResourceRec.Experience__c = experience;
        skillResourceRec.Level_of_Experience__c = levelofExperience;
        return skillResourceRec;
    }

    private static Resource__c createResource(){
        Resource__c resource = new Resource__c();
        resource.Name = 'Test Resource';
        resource.Phone_Number__c = '1234567898';
        resource.Primary_Email__c = 'testresourceemail@' + DateTime.now().format('hh.mm.ss.SSS');
        resource.Source__c = 'Dice';
        resource.City__c = 'San Antonio, TX';
        resource.Country__c = 'USA';
        return resource;
    }
   
    private static Skill__c createSkill(String name){
        Skill__c skillCreation = new Skill__c();
        skillCreation.Name = name;
        return skillCreation;
    }

    private static User createAdminUser(String firstName, String lastName){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User();
        u.Email = 'testEmail@' + Datetime.now().format('hh.mm.ss.SSS') + '.com';
        u.ProfileId = p.Id;
        u.Username = 'testUserName' + Datetime.now().format('hh.mm.ss.SSS') + '@testmail.com';
        u.Alias = 'abcd';
        u.CommunityNickname = 'nickName' + Datetime.now().format('hh.mm.ss.SSS');
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ManagerId = UserInfo.getUserId();
        u.LanguageLocaleKey = 'en_US';
        u.FirstName = firstName;
        u.LastName = lastName;
        u.Phone = '9876543210';
        return u;
    }

    private static void assignpermissionSetForAdmin(User u){
        Id userId = UserInfo.getUserId();
        User user = [SELECT Id FROM User WHERE Id = :userId];
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'ATS_App_Permission_set_new'];
        System.runAs(user){
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.PermissionSetId = ps.Id;
            psa.AssigneeId = u.Id;
            insert psa;
        }
    }
}
