component {
    fileList= {
        mainSite:[
            "/build/mainsite/Application.cfc",
            "/build/mainsite/box.json",
            "/build/mainsite/server.json",
            "/build/mainsite/TestSiteSettingsLive.json",
            "/build/mainsite/index.cfm"
            ],
        newApp:[
            "/build/newproduct/Application.cfc",
            "/build/newproduct/index.cfm",
            "/build/newproduct/server.json"
            ],
        webapp:[
            "/build/webapp/Application.cfc",
            "/build/webapp/index.cfm",
            "/build/webapp/server.json"
            ],
        restservices:[
            "/build/restservices/Application.cfc",
            "/build/restservices/index.cfm",
            "/build/restservices/server.json"
            ]
    };

    function run(){
        var configSettings=ConfigService.getconfigSettings();
        for(var loc in fileList){
            print.line("outside array each: " & loc );
            arrayEach(fileList[loc],function(item){
                print.line(loc);
                print.line(item);
                print.line("copy #item# from #configSettings.modules.fakerco.sitepaths.repo#/ITBFakerCoSites#item# to #configSettings.modules.fakerco.sitepaths[loc]# ");
                filecopy("#configSettings.modules.fakerco.sitepaths.repo#/ITBFakerCoSites#item#",#configSettings.modules.fakerco.sitepaths[loc]#);
            });
        }
    }
}
