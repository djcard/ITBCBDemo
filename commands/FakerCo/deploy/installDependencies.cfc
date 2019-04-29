component {
    property name='ConfigService' inject='ConfigService';
    function run(){
        var configSettings=ConfigService.getconfigSettings();
        var currentFolder=getcwd();
        var siteArray=["mainsite","restservices","newapp","webapp"];
        arrayEach(siteArray,function(item){
           print.line("changing to #configSettings.modules.fakerco.sitepaths[item]#");
           command("cd #configSettings.modules.fakerco.sitepaths[item]#").run();
           print.line("#getcwd()#");
           command("install").run();
        });
        command("cd #currentFolder#");

    }
}
