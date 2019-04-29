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
            "/build/newproduct/Application.cfc",
            "/build/newproduct/index.cfm",
            "/build/newproduct/server.json"
            ],
        restservices:[
            "/build/newproduct/Application.cfc",
            "/build/newproduct/index.cfm",
            "/build/newproduct/server.json"
            ]
    };

    function run(){
        var configSettings=ConfigService.getconfigSettings();
        for(var loc in fileList){
            arrayEach(fileList[loc],function(item){
                print.line("copy #item# from #configSettings.modules.fakerco.sitepaths.repo#/ITBFakerCoSites#item# to #configSettings.modules.fakerco.sitepaths[loc]# ");
                filecopy("#configSettings.modules.fakerco.sitepaths.repo#/ITBFakerCoSites#item#",#configSettings.modules.fakerco.sitepaths[loc]#);
            });
        }
    }
}
