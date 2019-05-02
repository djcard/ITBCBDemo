component {
    property name='ConfigService' inject='ConfigService';
    property name="serverService" inject='ServerService';

    function run(boolean force=false){
        try {
            var configSettings = ConfigService.getconfigSettings();
            var fakerCOSettings = configSettings.modules.fakerCO;
            var serverInfo=serverService.resolveServerDetails({directory:configSettings.modules.fakerCO.sitepaths.mainsite});
            var currentDir=getcwd();
                command("cd #fakerCOsettings.sitepaths.restservices#").run();


            //Copy downloaded server config to live server config
            print.line("Setting robust exception on");
            command(" cfconfig set robustExceptionEnabled=true").run();
            sleep(250);
            //disable all scheduled tasks
            //Handled in the server.json

            print.line("setting live host to fakerCo.local");
            command("server set web.host=restservices.fakerCo.local").run();


            //Change Admin Password to local password
            print.line("Changing admin passwords");
                command("fakerCo deploy setAdminPassword restservices #serverInfo.defaultname#").run();
            sleep(250);

            //Remove cfcfonig from server.json so it uses the cfconfigs we set instead of the ones from the repo
            print.line("Removing cfconfig file from server.json");
            try{command("server clear cfconfigfile").run();}catch(any err){};

            addCustomTagPath();

            sleep(250);
            print.line("Adding Mappings and Aliases");
            addMapping("restservice",fakerCOSettings.sitepaths.repo & "/ITBFakerCoSites/restservice");
            addAlias("restservice",fakerCOSettings.sitepaths.repo & "/ITBFakerCoSites/restservice");
            sleep(250);

            addDatasource();

            var restartme=arguments.force ? arguments.force : confirm("The Server needs to restart. Restart now [y/n]?");
            if(restartme) {
                    command("server restart").run();
                print.line("Server restarting");
            }

            print.line("************************************************");
                command("cd #currentDir#").run();

        }
        catch(any err){
            print.line(err.message);
        }
    }

    function addMapping(name,physical)
    {
        print.line("Setting mapping for #arguments.name# to #arguments.physical#");
            command("cfconfig cfmapping save virtual=/#arguments.name# physical=#arguments.physical#").run();
        print.line("mapping set");
    }

    function addAlias(name,physical){
            command("server set web.aliases./#arguments.name#=#arguments.physical#").run();
    }

    function addCustomTagPath(){
        var configSettings = ConfigService.getconfigSettings();
        var fakerCOSettings = configSettings.modules.fakerCO;

        print.line("Adding customtag path");
            command('cfconfig customtagpath save physical=#fakerCOSettings.sitepaths.repo#/fakerCO/customTags primary=Physical').run();
    }

    function addDatasource(){
        var configSettings = ConfigService.getconfigSettings();
        var fakerCOSettings = configSettings.modules.fakerCO.localdb;
                command("cfconfig datasource save").params(name="fakeDS",
                dbdriver="mysql",
                host=fakerCOSettings.dbaddress,
                port=fakerCOSettings.port,
                database=fakerCOSettings.SCHEMA,
                username=fakerCOSettings.USERNAME,
                password=fakerCOSettings.PASSWORD,
                custom="allowMultiQueries=true",
                dsn="jdbc:mysql://#fakerCOSettings.dbaddress#:#fakerCOSettings.port#/#fakerCOSettings.SCHEMA#?tinyInt1isBit=false&allowMultiQueries=true").run();

                command("cfconfig datasource save").params(name="fakerCo",
                dbdriver="mssql",
                host="#fakerCOSettings.dbaddress#",
                port="#fakerCOSettings.port#",
                database="#fakerCOSettings.SCHEMA#",
                username="#fakerCOSettings.USERNAME#",
                password="#fakerCOSettings.password#").run();
    }

}
