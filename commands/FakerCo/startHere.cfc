component {
    property name='ConfigService' inject='ConfigService';
    property name="serverService" inject='ServerService';
    property name="systemconsts" inject="system@constants";

    function run(){
        print.line("hello");
        //Opening Text
        showOpeningText();
        confirm(message="To Start press any key: ",defaultResponse="Y");
        print.line("ok, let's get started");

        //Ask for the Settings and Create Folder Structure
        askForSettings();

        //Install dependencies
        installDependencies();

        sleep(2000);
        print.line("The various sites will be set up here:");
        print.line("");

        command("config show modules.fakerco.sitepaths").run();
        print.line("");

        makeFolders();


        //Pull from repos
        pullSite();

        //Move “index” files over
        copyFiles();

        //Run “install” to install dependencies
        runInstall();
       //Start/stop Servers
        print.line("Restarting each server");
        command("fakerCo deploy restartEachServer").run();
        //Import settings
        //Specific Settings
        print.line("deploying main site settings");
        command("fakerCo deploy deployMainSiteSettings").run();
        print.line("deploying restservices settings");
        command("fakerCo deploy deployRestServicesSettings").run();

    }


    function showOpeningText(){
        print.line("This process will set up the FakerCo Development environment on your local computer. Before starting you will want to have the following installed:");
        print.line("It is important that you are running CommandBox as either the Administrator (windows) or sudo (everything else).");
        print.line("1. Git (The Mac will download a tool automatically. Git For Windows is recommended for PCs (https://git-scm.com/downloads). Source Tree is fine as an additional tool.");
        print.line("2. Have access to a local version of the database (or a blank) MSSQL database");
        print.line("");
        print.line("You will be asked for a number of items including:");
        print.line("1. A folder which will be the root of your environment");
        print.line("2. Credentials for your local MSSQL installation");
        print.line("3. The location of your local MSSQL installation");
        print.line("4. A default Admin Password for your sites");

        print.line("");

    }

    function installDependencies(){
        print.line("First we need to install some modules");
        print.line("Installing HostUpdater");
        command("install").params("commandbox-hostupdater").run();
        print.line("Installing CFConfig");
        command("install").params("commandbox-cfconfig").run();
    }

    function askForSettings(){
        createFakerCoStructure();
        makeRootFolder();
        assignFolders();
        adminPassword();
        addDatabaseInfo();
    }

    function createFakerCoStructure(){
        var configSettings=ConfigService.getconfigSettings();
        configSettings.modules=structKeyExists(configSettings,"modules") ? configSettings.modules : {};
        configsettings.modules.FakerCo=structKeyExists(configSettings.modules,"FakerCo") ? configsettings.modules.FakerCo : emptyFakerCo();
        configsettings.modules.FakerCo.sitepaths = structKeyExists(configSettings.modules.FakerCo,"sitepaths") ? configsettings.modules.FakerCo.sitepaths : {"root":"","repo":"","mainsite":"","restservices":"","newapp":"","webapp":""} ;
        configsettings.modules.FakerCo.adminpasswords = structKeyExists(configSettings.modules.FakerCo,"adminpasswords") ? configsettings.modules.FakerCo.adminpasswords : {"root":"","repo":"","mainsite":"","restservices":"","newapp":"","webapp":""};
        configsettings.modules.FakerCo.LocalDB = structKeyExists(configSettings.modules.FakerCo,"LocalDB") ? configsettings.modules.FakerCo.localdb : {"DBADDRESS":"","PASSWORD":"","SCHEMA":"","PORT":"","USERNAME":""};
        ConfigService.setConfigSettings(configSettings);
    }

    function emptyFakerCo(){
        return {
        "AdminPasswords":{"default":"AppleStrudel","mainsite":"","restservices":"","newapp":"","webapp":""},
        "SitePaths":{"root":"","repo":"","mainsite":"","restservices":"","newapp":"","webapp":""},
        "LocalDB":{"DBADDRESS":"","PASSWORD":"","SCHEMA":"","PORT":"","USERNAME":""}
        };
    }

    function makeRootFolder(){
        var configSettings=ConfigService.getconfigSettings();
        var rootlocation=ask(message="Where do you want the root of the install to be? ",defaultResponse=configsettings.modules.FakerCo.sitepaths.root);
        print.line("");
        print.line("ok, we'll make #rootlocation# the root of the install.");
        command("config set modules.FakerCo.sitepaths.root=#rootlocation#").run();
        print.line("***********************************************");
        print.line("");
    }

    function assignFolders(){
        configSettings=ConfigService.getconfigSettings();
        var rootlocation=configSettings.modules.FakerCo.sitepaths.root;
            command("config set modules.FakerCo.sitepaths.repo=#rootlocation#/repo").run();
            command("config set modules.FakerCo.sitepaths.mainsite=#rootlocation#/mainsite").run();
            command("config set modules.FakerCo.sitepaths.newapp=#rootlocation#/newapp").run();
            command("config set modules.FakerCo.sitepaths.webapp=#rootlocation#/webapp").run();
            command("config set modules.FakerCo.sitepaths.restservices=#rootlocation#/restservices").run();
        print.line("***********************************************");
        print.line("");
    }

    function makeFolders(){
        configSettings=ConfigService.getconfigSettings();
        var osname=systemconsts.Properties["os.name"];
        try{command("mkdir #configSettings.modules.FakerCo.sitepaths.restservices#").run();}catch( any err){}
        try {command("mkdir #configSettings.modules.FakerCo.sitepaths.mainsite#").run();}catch( any err){}
        try {command("mkdir #configSettings.modules.FakerCo.sitepaths.repo#").run();}catch( any err){}
        try {command("mkdir #configSettings.modules.FakerCo.sitepaths.newapp#").run(); }catch( any err){}
        try {command("mkdir #configSettings.modules.FakerCo.sitepaths.webapp#").run();}catch( any err){}
        if(findnocase("windows",osname) eq 0){
                command("!chmod 777 restservices").run();
                command("!chmod 777 mainsite").run();
                command("!chmod 777 repo").run();
                command("!chmod 777 newapp").run();
                command("!chmod 777 webapp").run();

        }
    }

    function adminPassword(){
        var configSettings=ConfigService.getconfigSettings();
        var defresponse=structKeyExists(configsettings.modules.FakerCo,"AdminPasswords") and
            structKeyExists(configsettings.modules.FakerCo.adminpasswords,"default") ? configSettings.modules.FakerCo.AdminPasswords.default : "AppleStrudel";
        var defAdmin=ask(message="What do you want the default AdminPassword to be for your servers? ",defaultResponse=defresponse);
            command("config set modules.FakerCo.AdminPasswords.default=#defadmin#").run();
            command("config set modules.FakerCo.AdminPasswords.mainsite=#defadmin#").run();
            command("config set modules.FakerCo.AdminPasswords.restservices=#defadmin#").run();
            command("config set modules.FakerCo.AdminPasswords.newapp=#defadmin#").run();
            command("config set modules.FakerCo.AdminPasswords.webapp=#defadmin#").run();
        print.line("***********************************************");
        print.line("");
    }

    function addDatabaseInfo(){
        var configSettings=ConfigService.getconfigSettings();
        var FakerCoSettings=configSettings.modules.FakerCo;
            command("config set modules.FakerCo.localdb.dbaddress=#ask(message="What is the address to the local DB?  ", defaultresponse="127.0.0.1")#").run();
            command('config set modules.FakerCo.localdb.port=#ask(message="What port at #FakerCoSettings.localdb.dbaddress# do you want to use?  ", defaultresponse="1433")#').run();
            command('config set modules.FakerCo.localdb.username=#ask(message="What username at #FakerCoSettings.localdb.dbaddress# do you want to use? ", defaultresponse=structkeyexists(FakerCoSettings.localdb,"username") ? FakerCoSettings.localdb.username : "")#').run();
            command('config set modules.FakerCo.localdb.password=#ask(message="What is the password to the #FakerCoSettings.localdb.username# to be?  ", defaultresponse=(structKeyExists(FakerCoSettings.localdb,"password") ? FakerCoSettings.localdb.password : ''),mask="*")# --quiet').run();
            command('config set modules.FakerCo.localdb.schema=#ask(message="What schema do you want to use? ", defaultresponse=(structKeyExists(FakerCoSettings.localdb,"schema") ? FakerCoSettings.localdb.schema : FakerCoSettings.localdb.username))#').run();
        print.line("settings to local DB configured");
        print.line("************************************************");
    }

    function pullSite(configSettings){
            command("FakerCo deploy pullSitesFromRepo").run();
        var postGit=ask(message="Press Y to keep going: ",defaultResponse="Y");
    }

    function copyFiles(){
        command("FakerCo deploy copyIndexFiles").run();
    }

    function runInstall(){
        command("FakerCo deploy installDependencies");
    }

    function startEach(){
        command("FakerCo deploy startEach");
    }
}
