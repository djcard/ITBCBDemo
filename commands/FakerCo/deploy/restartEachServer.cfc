component {
    property name='ConfigService' inject='ConfigService';
    property name="serverService" inject='ServerService';
    property name="systemconsts" inject="system@constants";


    function run()
    {
        configSettings=ConfigService.getconfigSettings();
        var currentdir=getcwd();
        sitearray=["mainsite","restservices","webapp","newapp"];

        for(var x in sitearray) {
            command("cd #configSettings.modules.fakerco.sitepaths.mainsite#");
            var ServerInfo = serverService.resolveServerDetails({directory:configSettings.modules.fakerCO.sitepaths[x]});
//print.line("#structkeylist(mainSiteServerInfo)#");

            if (!ServerInfo.serverisnew) {
                print.line("restarting");
                    command("server restart serverconfigfile=#ServerInfo.DEFAULTSERVERCONFIGFILE#").run();
            }
            else {
                print.line("starting");
                    command("server start serverconfigfile=#ServerInfo.DEFAULTSERVERCONFIGFILE#").run();
            }
        }
        /*
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
*/
    }
}
