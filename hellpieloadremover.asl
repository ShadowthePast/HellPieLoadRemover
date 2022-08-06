state("HellPie-Win64-Shipping", "v1.1.3.202208041009")
{
	//Patch 3, version 1.1.3
	bool loadScreen: 0x04FDFC28, 0xA8;
	
	int isPaused: 0x04EC7E88, 0x3C0, 0x8;
}

state("HellPie-Win64-Shipping", "v1.1.2.202208011127")
{
	//Patch 2, mini unlisted patch
	bool loadScreen: 0x04FDDAE8, 0xA8;
}

state("HellPie-Win64-Shipping", "v1.1.2.202208011127 old")
{
	//Patch 1
	bool loadScreen: 0x04FEBBE8, 0xA8;
}

state("HellPie-Win64-Shipping", "v1.1.2.202207181555")
{
	//Unpatched (i.e. day 1 version)
	bool loadScreen: 0x5096078, 0xA8;
}

startup
{
	//Settings menu
	settings.Add("settings", true, "Settings");
	settings.CurrentDefaultParent = "settings";
	settings.Add("settings_newFileStart", true, "Auto-start timer upon starting a save file");
}

start
{
	//if was on main menu, then starts timer. (Probably starts timer even when loading save
	if(old.isPaused == 429 && (current.isPaused == 157 || current.isPaused == 16))
	{
		return settings["settings_newFileStart"];
	}
}

init
{
	//Hash of the game's exe to determine which version it matches with
	string MD5Hash;
	using (var md5 = System.Security.Cryptography.MD5.Create())
	using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
	MD5Hash = md5.ComputeHash(s).Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
	switch(MD5Hash){
		case "3F487A324406A8D8EA01C2794B9D1E4C": version = "v1.1.3.202208041009"; break; //unlisted patch on 8/4/2022
		case "36241BB60C1FD03414A4861C01D66B61": version = "v1.1.2.202208011127"; break; //mini patch on 8/3/2022
		case "BB43ADD505C76D9B0B56307A9CA529C7": version = "v1.1.2.202208011127 old"; break; //patch from 8/2/2022
		case "3516D20141D68EEC29F7E6D64F97618F": version = "v1.1.2.202207181555"; break; //day 1
		default: version = "Unknown (did a patch just come out?)"; break; //unknown
	}
}

isLoading
{
	//I haven't setup pausing the timer on the pause menu for pre-patch yet
	if (version == "v1.1.3.202208041009"){
		//16=not paused, 17 = collecting ing, 20 = tutorial menu, 21 = crossing off ing, 445-447=esc, 128=map/skill menu, 18=return to chef, any choice dialogue, 429=main menu
		if (current.isPaused == 445 || current.isPaused == 446 || current.isPaused == 447 || current.isPaused == 128 || current.isPaused == 429)
		{
			return true;
		}
	}
	
	return current.loadScreen;
}
