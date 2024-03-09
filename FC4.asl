/*
Created by Binslev, credit to Meta, Wub, AlexYeahNot, Vlad2D, Sviat and Ero
Load remover for version 1.4, 1.7 and 1.10
Autosplitter for version 1.4 and 1.10
Last updated 09-03-2024 (DD-MM-YYYY)
"loading" variables always equals 2 during load screens, and 0 otherwise
"mainmission" variables start at 0, and go up by 1 every time a main story mission is completed
*/

state("FarCry4", "v1.4")
{
	int loading : "FC64.dll", 0x02D99470, 0x20, 0x2C0;
	int mainmission : "FC64.dll", 0x02DA0EA8, 0x30, 0x18, 0x188, 0x18, 0x60, 0x70, 0x18;
}

state("FarCry4", "v1.7")
{
	int loading : "FC64.dll", 0x02CC4480, 0x10, 0x30, 0x1B0, 0x1E4;
}

state("FarCry4", "v1.10")
{
	int loading : "FC64.dll", 0x02E23C98, 0x20, 0x18, 0x30, 0x18, 0x24;
    	int mainmission : "FC64.dll", 0X02E2C0A0, 0x70, 0x18;
}



startup
{
    {
    // Loads Settings.xml into Livesplit using "asl-help".

        Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
        vars.Helper.GameName = "Far Cry 4";
        vars.Helper.Settings.CreateFromXml("Components/FC4.Settings.xml");
    }

    {
    // Asks user to change to game time if LiveSplit is currently set to real time.

	    vars.Helper.AlertLoadless();
    }
}



init
{
//switches between versions via the MD5 hash of the FC64.DLL file, used by the currently running game version.

    string MD5Hash = vars.Helper.GetMD5Hash("FC64.dll").ToLower();

    switch (MD5Hash)
    {
        case "f3fc6a3c6e1fd99711e53686dd80d2fb": version = "v1.4"; break;
        case "1c16edfb3bb6ca77811602c660f4ac3c": version = "v1.7"; break;
        case "cbfccf70b8811d26c4dc5acf753c159a": version = "v1.10"; break;
    }
}



onStart
{
    // This makes sure the timer always starts at 0.00.

    timer.IsGameTimePaused = true;
}



start
{
	return (old.loading == 2 && current.loading == 0 && current.mainmission == 0);
}



split 
{ 	
//split every time mainmission variable goes up by 1, if the setting for that specific split is checked in the settings.

    if (current.mainmission == old.mainmission + 1 && settings["MM" + current.mainmission])
    {
        return true;
    }
}



isLoading
{
	return current.loading == 2;
}
