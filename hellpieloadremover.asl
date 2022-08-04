state("HellPie-Win64-Shipping", "v1.1.3.202208041009")
{
	//Patch 3, version 1.1.3
	bool loadScreen: 0x04FDFC28, 0xA8;
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
	return current.loadScreen;
}
