component {
    property name='ConfigService' inject='ConfigService';
    function run(){
        var configSettings=ConfigService.getconfigSettings();
        var currFolder=getcwd();
            command("cd #configSettings.modules.FakerCo.sitepaths.repo#").run();
        print.line("");
        print.line("Checking if git repository at #configSettings.modules.FakerCo.sitepaths.repo# exists");
        print.line("");
        if(directoryExists('#configSettings.modules.FakerCo.sitepaths.repo#\ITBFakerCoSites')){
            print.line("Repo exists so pulling, not cloning");
                command("cd #configSettings.modules.FakerCo.sitepaths.repo#\ITBFakerCoSites").run();
                command("!git pull").run();
        }
        else{
            print.line("Repo doesn't exist locally so cloning into #configSettings.modules.FakerCo.sitepaths.repo#");
                command("cd #configSettings.modules.FakerCo.sitepaths.repo#").run();
                command("!git clone https://github.com/djcard/ITBFakerCoSites.git").run();
        }
        try{command("cd #currFolder#").run();}catch(any err){}
    }
}