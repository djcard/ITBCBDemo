component {
    property name='ConfigService' inject='ConfigService';
    function run(required string sitename, required string servername=''){
        var configSettings=ConfigService.getconfigSettings();
        var fakerCOSettings=configSettings.modules.fakerCO;
        //print.line("to=#sitename#");
        command("cfconfig set adminUserIDRequired=false to=#servername#").run();
        command("cfconfig set adminPassword=#fakerCOSettings.adminPasswords[sitename]# to=#servername#").run();
        print.line("Local Admin Password set");
        print.line("************************************************");
    }
}
