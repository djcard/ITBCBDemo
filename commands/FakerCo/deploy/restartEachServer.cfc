component {
    property name='ConfigService' inject='ConfigService';
    property name="serverService" inject='ServerService';
    property name="systemconsts" inject="system@constants";


    function run()
    {
        configSettings=ConfigService.getconfigSettings();
        var currentdir=getcwd();

        command("cd #configSettings.modules.fakerco.sitepaths.mainsite#");
        var mainSiteServerInfo=serverService.resolveServerDetails({directory:configSettings.modules.fakerCO.sitepaths.mainsite});
        //print.line("#structkeylist(mainSiteServerInfo)#");
        print.line("#mainSiteServerInfo.DEFAULTSERVERCONFIGFILE#");
        command("server restart serverconfigfile=#mainSiteServerInfo.DEFAULTSERVERCONFIGFILE#").run();

        command("cd #configSettings.modules.fakerco.sitepaths.restservices#");
        var restservicesSiteServerInfo=serverService.resolveServerDetails({directory:configSettings.modules.fakerCO.sitepaths.restservices});
        print.line("#restservicesSiteServerInfo.DEFAULTSERVERCONFIGFILE#");
        command("server restart serverconfigfile=#restservicesSiteServerInfo.DEFAULTSERVERCONFIGFILE#").run();

        command("cd #configSettings.modules.fakerco.sitepaths.webapp#");
        var webAppSiteServerInfo=serverService.resolveServerDetails({directory:configSettings.modules.fakerCO.sitepaths.webapp});
        print.line("#webAppSiteServerInfo.DEFAULTSERVERCONFIGFILE#");
            command("server restart serverconfigfile=#webAppSiteServerInfo.DEFAULTSERVERCONFIGFILE#").run();


        command("cd #configSettings.modules.fakerco.sitepaths.newapp#");
        var newappSiteServerInfo=serverService.resolveServerDetails({directory:configSettings.modules.fakerCO.sitepaths.newapp});
        print.line("#newappSiteServerInfo.DEFAULTSERVERCONFIGFILE#");
            command("server restart serverconfigfile=#newappSiteServerInfo.DEFAULTSERVERCONFIGFILE#").run();
    }
}
