local var0_0 = type
local var1_0 = string.byte
local var2_0 = string.format
local var3_0 = string.match
local var4_0 = string.gmatch
local var5_0 = string.gsub
local var6_0 = table.concat
local var7_0 = require("bit")
local var8_0 = var7_0.band
local var9_0 = var7_0.bor
local var10_0 = var7_0.tohex
local var11_0 = var7_0.lshift
local var12_0 = var7_0.rshift
local var13_0 = var7_0.arshift
local var14_0 = {
	[0] = "mcrfXX",
	[129] = "crandcCCC",
	[257] = "crandCCC",
	[225] = "crnandCCC",
	mask = 1023,
	[150] = "isync",
	[289] = "creqv|crsetCCC%",
	[16] = "b_lrKB",
	[33] = "crnor|crnotCCC=",
	[528] = "b_ctrKB",
	[193] = "crxor|crclrCCC%",
	[449] = "cror|crmoveCCC=",
	[417] = "crorcCCC",
	shift = 1
}
local var15_0 = setmetatable({
	shift = 0,
	mask = -1
}, {
	__index = function(arg0_1, arg1_1)
		local var0_1 = var8_0(var12_0(arg1_1, 11), 31)
		local var1_1 = var8_0(var12_0(arg1_1, 6), 31)
		local var2_1 = var8_0(var12_0(arg1_1, 1), 31)

		if var1_1 == 0 and var2_1 == 31 - var0_1 then
			return "slwiRR~A."
		elseif var2_1 == 31 and var1_1 == 32 - var0_1 then
			return "srwiRR~-A."
		else
			return "rlwinmRR~AAA."
		end
	end
})
local var16_0 = {
	[0] = "rldiclRR~HM.",
	"rldicrRR~HM.",
	"rldicRR~HM.",
	"rldimiRR~HM.",
	{
		[0] = "rldclRR~RM.",
		"rldcrRR~RM.",
		shift = 1,
		mask = 1
	},
	shift = 2,
	mask = 7
}
local var17_0 = setmetatable({
	[0] = "cmp_YLRR",
	nil,
	nil,
	nil,
	"twARR",
	nil,
	nil,
	nil,
	"subfcRRR.",
	"mulhduRRR.",
	"addcRRR.",
	"mulhwuRRR.",
	nil,
	nil,
	nil,
	"iselltRRR",
	nil,
	nil,
	nil,
	[144] = {
		[0] = "mtcrfRZ~",
		"mtocrfRZ~",
		shift = 20,
		mask = 1
	},
	{
		[0] = "mfcrR",
		"mfocrfRZ",
		shift = 20,
		mask = 1
	},
	"lwarxRR0R",
	"ldxRR0R",
	nil,
	"lwzxRR0R",
	"slwRR~R.",
	nil,
	"cntlzwRR~",
	"sldRR~R.",
	"andRR~R.",
	nil,
	nil,
	nil,
	"cmpl_YLRR",
	[232] = "subfmeRR.",
	[824] = "srawiRR~A.",
	[233] = "mulldRRR.",
	[136] = "subfeRRR.",
	[457] = "divduRRR.",
	[470] = "dcbi-RR",
	[86] = "dcbf-R0R",
	[58] = "cntlzdRR~",
	[119] = "lbzuxRRR",
	[341] = "lwaxRR0R",
	[87] = "lbzxRR0R",
	[343] = "lhaxRR0R",
	[316] = "xorRR~R.",
	[79] = "iseleqRRR",
	[84] = "ldarxRR0R",
	[476] = "nandRR~R.",
	[444] = "or|mrRR~R=.",
	[854] = "eieio",
	[214] = "stdcxRR0R.",
	mask = 1023,
	[616] = "negoRR.",
	[459] = "divwuRRR.",
	[597] = "lswiRR0A",
	[150] = "stwcxRR0R.",
	[75] = "mulhwRRR.",
	[661] = "stswxRR0R",
	[662] = "stwbrxRR0R",
	[631] = "lfduxFRR",
	[154] = "prtywRR~",
	[533] = "lswxRR0R",
	[53] = "lduxRRR",
	[278] = "dcbt-R0R",
	[73] = "mulhdRRR.",
	[648] = "subfeoRRR.",
	[104] = "negRR.",
	[663] = "stfsxFR0R",
	[599] = "lfdxFR0R",
	[650] = "addeoRRR.",
	[54] = "dcbst-R0R",
	[759] = "stfduxFR0R",
	[438] = "ecowxRR0R",
	[439] = "sthuxRRR",
	[310] = "eciwxRR0R",
	[311] = "lhzuxRRR",
	[660] = "stdbrxRR0R",
	[969] = "divduoRRR.",
	[55] = "lwzuxRRR",
	[712] = "subfzeoRR.",
	[407] = "sthxRR0R",
	[918] = "sthbrxRR0R",
	[149] = "stdxRR0R",
	[68] = "tdARR",
	[215] = "stbxRR0R",
	[855] = "lfiwaxFR0R",
	[151] = "stwxRR0R",
	[792] = "srawRR~R.",
	[982] = "icbi-R0R",
	[183] = "stwuxRRR",
	[534] = "lwbrxRR0R",
	[695] = "stfsuxFRR",
	[279] = "lhzxRR0R",
	[200] = "subfzeRR.",
	[1001] = "divdoRRR.",
	[744] = "subfmeoRR.",
	[746] = "addmeoRR.",
	[202] = "addzeRR.",
	[266] = "addRRR.",
	[522] = "addcoRRR.",
	[567] = "lfsuxFRR",
	[412] = "orcRR~R.",
	[971] = "divwouRRR.",
	[284] = "eqvRR~R.",
	[714] = "addzeoRR.",
	[725] = "stswiRR0A",
	[727] = "stfdxFR0R",
	[552] = "subfoRRR.",
	[827] = "sradiRR~H.",
	[922] = "extshRR~.",
	[986] = "extswRR~.",
	[954] = "extsbRR~.",
	[983] = "stfiwxFR0R",
	[536] = "srwRR~R.",
	[539] = "srdRR~R.",
	[138] = "addeRRR.",
	[535] = "lfsxFR0R",
	[532] = "ldbrxRR0R",
	[1003] = "divwoRRR.",
	[745] = "mulldoRRR.",
	[747] = "mullwoRRR.",
	[60] = "andcRR~R.",
	[758] = "dcba-RR",
	[520] = "subfcoRRR.",
	[826] = "sradiRR~H.",
	[122] = "popcntbRR~",
	[512] = "mcrxrX",
	[186] = "prtydRR~",
	[1014] = "dcbz-R0R",
	[508] = "cmpbRR~R",
	[375] = "lhauxRRR",
	[40] = "subfRRR.",
	[246] = "dcbtst-R0R",
	shift = 1,
	[778] = "addoRRR.",
	[790] = "lhbrxRR0R",
	[47] = "iselgtRRR",
	[373] = "lwauxRRR",
	[794] = "sradRR~R.",
	[181] = "stduxRRR",
	[247] = "stbuxRRR",
	[491] = "divwRRR.",
	[124] = "nor|notRR~R=.",
	[489] = "divdRRR.",
	[234] = "addmeRR.",
	[235] = "mullwRRR.",
	[371] = {
		shift = 11,
		[392] = "mftbR",
		[424] = "mftbuR",
		mask = 1023
	},
	[339] = {
		[256] = "mflrR",
		shift = 11,
		[16] = "mfspefscrR",
		mask = 1023,
		[288] = "mfctrR",
		[32] = "mferR"
	},
	[467] = {
		[256] = "mtlrR",
		shift = 11,
		[16] = "mtspefscrR",
		mask = 1023,
		[288] = "mtctrR",
		[32] = "mtxerR"
	},
	[598] = {
		[0] = "sync",
		"lwsync",
		"ptesync",
		shift = 21,
		mask = 3
	}
}, {
	__index = function(arg0_2, arg1_2)
		if var8_0(arg1_2, 31) == 15 then
			return "iselRRRC"
		end
	end
})
local var18_0 = {
	[0] = "ldRRE",
	"lduRRE",
	"lwaRRE",
	shift = 0,
	mask = 3
}
local var19_0 = {
	[0] = "stdRRE",
	"stduRRE",
	shift = 0,
	mask = 3
}
local var20_0 = {
	{
		[0] = false,
		false,
		"fdivsFFF.",
		false,
		"fsubsFFF.",
		"faddsFFF.",
		"fsqrtsF-F.",
		false,
		"fresF-F.",
		"fmulsFF-F.",
		"frsqrtesF-F.",
		false,
		"fmsubsFFFF~.",
		"fmaddsFFFF~.",
		"fnmsubsFFFF~.",
		"fnmaddsFFFF~.",
		shift = 1,
		mask = 15
	},
	shift = 5,
	mask = 1
}
local var21_0 = {
	[0] = {
		[0] = "fcmpuXFF",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"fcpsgnFFF.",
		nil,
		nil,
		nil,
		"frspF-F.",
		nil,
		"fctiwF-F.",
		"fctiwzF-F.",
		[38] = "mtfsb1A.",
		[392] = "frinF-F.",
		[711] = "mtfsfZF.",
		[583] = "mffsF.",
		mask = 1023,
		[846] = "fcfidF-F.",
		[814] = "fctidF-F.",
		[134] = "mtfsfiA>>-A>",
		[32] = "fcmpoXFF",
		[40] = "fnegF-F.",
		[424] = "frizF-F.",
		[70] = "mtfsb0A.",
		[456] = "fripF-F.",
		[488] = "frimF-F.",
		[815] = "fctidzF-F.",
		[136] = "fnabsF-F.",
		[64] = "mcrfsXX",
		[264] = "fabsF-F.",
		[72] = "fmrF-F.",
		shift = 1
	},
	{
		[0] = false,
		false,
		"fdivFFF.",
		false,
		"fsubFFF.",
		"faddFFF.",
		"fsqrtF-F.",
		"fselFFFF~.",
		"freF-F.",
		"fmulFF-F.",
		"frsqrteF-F.",
		false,
		"fmsubFFFF~.",
		"fmaddFFFF~.",
		"fnmsubFFFF~.",
		"fnmaddFFFF~.",
		shift = 1,
		mask = 15
	},
	shift = 5,
	mask = 1
}
local var22_0 = {
	[1037] = "evmhosmiRRR",
	[1284] = "evmhousiaawRRR",
	[1069] = "evmhosmiaRRR",
	[564] = "evcmpeqYRR",
	[712] = "efsmulRRR",
	[556] = "evmergehiRRR",
	[1453] = "evmhogsmianRRR",
	[720] = "efscfuiR-R",
	[518] = "evsubiwRAR~",
	[548] = "evslwRRR",
	[728] = "efsctuizR-R",
	[736] = "efdaddRRR",
	[524] = "evrndwRR",
	[520] = "evabsRR",
	[1421] = "evmhosmianwRRR",
	[764] = "efdtstgtYRR",
	[1413] = "evmhossianwRRR",
	[1323] = "evmhegsmfaaRRR",
	[1283] = "evmhessfaawRRR",
	[1291] = "evmhesmfaawRRR",
	[659] = "evfscfsfR-R",
	[563] = "evcmpltsYRR",
	[555] = "evsplatfiRS",
	[739] = "efdcfsidR-R",
	[747] = "efdctsidzR-R",
	[523] = "evextshRR",
	[755] = "efdcfsfR-R",
	[784] = "evlwhexRR0R",
	[633] = "evselRRRW",
	[1222] = "evdivwsRRR",
	[637] = "evselRRRW",
	shift = 0,
	[1481] = "evmwlsmianwRRR",
	[640] = "evfsaddRRR",
	[1473] = "evmwlssianwRRR",
	[1033] = "evmhesmiRRR",
	[644] = "evfsabsRR",
	[1280] = "evmheusiaawRRR",
	[648] = "evfsmulRRR",
	[1324] = "evmhogumiaaRRR",
	[652] = "evfscmpgtYRR",
	[718] = "efscmpeqYRR",
	[656] = "evfscfuiR-R",
	[726] = "efsctufR-R",
	[660] = "evfsctuiR-R",
	[550] = "evslwiRRA",
	[664] = "evfsctuizR-R",
	[1292] = "evmhoumiaawRRR",
	[668] = "evfststgtYRR",
	[734] = "efststeqYRR",
	[730] = "efsctsizR-R",
	[534] = "evxorRRR",
	[750] = "efdcmpeqYRR",
	[746] = "efdctuidzR-R",
	[758] = "efdctufR-R",
	[1217] = "evaddssiaawRR",
	[1101] = "evmwhsmiRRR",
	[1480] = "evmwlumianwRRR",
	[1225] = "evaddsmiaawRR",
	[653] = "evfscmpltYRR",
	[657] = "evfscfsiR-R",
	[1071] = "evmhosmfaRRR",
	[561] = "evcmpgtsYRR",
	[557] = "evmergeloRRR",
	[1133] = "evmwhsmiaRRR",
	[708] = "efsabsRR",
	[553] = "evsplatiRS",
	[704] = "efsaddRRR",
	[737] = "efdsubRRR",
	[716] = "efscmpgtYRR",
	[1452] = "evmhogumianRRR",
	[560] = "evcmpgtuYRR",
	[745] = "efddivRRR",
	[724] = "efsctuiR-R",
	[757] = "efdctsiR-R",
	[552] = "evrlwRRR",
	[753] = "efdcfsiR-R",
	[732] = "efststgtYRR",
	[1420] = "evmhoumianwRRR",
	[544] = "evsrwuRRR",
	[1412] = "evmhousianwRRR",
	[740] = "efdabsRR",
	[1223] = "evdivwuRRR",
	[536] = "evnor|evnotRRR=",
	[748] = "efdcmpgtYRR",
	[744] = "efdmulRRR",
	[756] = "efdctuiR-R",
	[752] = "efdcfuiR-R",
	[516] = "evsubwRRR~",
	[512] = "evaddwRRR",
	[760] = "efdctuizR-R",
	[773] = "evldhRR8",
	[769] = "evlddRR8",
	[781] = "evlhhousplatRR2",
	[1036] = "evmhoumiRRR",
	[777] = "evlhhesplatRR2",
	[789] = "evlwhouRR4",
	[785] = "evlwheRR4",
	[797] = "evlwhsplatRR4",
	[1068] = "evmhoumiaRRR",
	[793] = "evlwwsplatRR4",
	[805] = "evstdhRR8",
	[801] = "evstddRR8",
	[1100] = "evmwhumiRRR",
	[821] = "evstwhoRR4",
	[817] = "evstwheRR4",
	[829] = "evstwwoRR4",
	[1132] = "evmwhumiaRRR",
	[825] = "evstwweRR4",
	[1363] = "evmwssfaaRRR",
	[1371] = "evmwsmfaaRRR",
	[1451] = "evmhegsmfanRRR",
	[1419] = "evmhesmfanwRRR",
	[1411] = "evmhessfanwRRR",
	[632] = "evselRRR",
	[1220] = "evmraRR",
	[636] = "evselRRRW",
	[1499] = "evmwsmfanRRR",
	[1491] = "evmwssfanRRR",
	[1035] = "evmhesmfRRR",
	[1027] = "evmhessfRRR",
	[663] = "evfsctsfR-R",
	[1067] = "evmhesmfaRRR",
	[1059] = "evmhessfaRRR",
	[1115] = "evmwsmfRRR",
	[1107] = "evmwssfRRR",
	[1147] = "evmwsmfaRRR",
	[1139] = "evmwssfaRRR",
	[719] = "efscfdR-R",
	[559] = "evmergelohiRRR",
	[727] = "efsctsfR-R",
	[723] = "efscfsfR-R",
	[547] = "evsrwisRRA",
	[539] = "evorcRRR",
	[535] = "evor|evmrRRR=",
	[751] = "efdcfsR-R",
	[527] = "brincRRR",
	[759] = "efdctsfR-R",
	[1219] = "evsubfssiaawRR",
	[1227] = "evsubfsmiaawRR",
	[772] = "evldhxRR0R",
	[768] = "evlddxRR0R",
	[780] = "evlhhousplatxRR0R",
	[1321] = "evmhegsmiaaRRR",
	[776] = "evlhhesplatxRR0R",
	[788] = "evlwhouxRR0R",
	[1281] = "evmhessiaawRRR",
	[796] = "evlwhsplatxRR0R",
	[1289] = "evmhesmiaawRRR",
	[792] = "evlwwsplatxRR0R",
	[804] = "evstdhxRR0R",
	[800] = "evstddxRR0R",
	[820] = "evstwhoxRR0R",
	[816] = "evstwhexRR0R",
	[1345] = "evmwlssiaawRRR",
	[828] = "evstwwoxRR0R",
	[1353] = "evmwlsmiaawRRR",
	[824] = "evstwwexRR0R",
	[1369] = "evmwsmiaaRRR",
	[1449] = "evmhegsmianRRR",
	[1417] = "evmhesmianwRRR",
	[1409] = "evmhessianwRRR",
	mask = 2047,
	[1218] = "evsubfusiaawRR",
	[635] = "evselRRRW",
	[1226] = "evsubfumiaawRR",
	[639] = "evselRRRW",
	[1497] = "evmwsmianRRR",
	[646] = "evfsnegRR",
	[654] = "evfscmpeqYRR",
	[1320] = "evmhegumiaaRRR",
	[658] = "evfscfufR-R",
	[662] = "evfsctufR-R",
	[666] = "evfsctsizR-R",
	[670] = "evfststeqYRR",
	[1288] = "evmheumiaawRRR",
	[1065] = "evmhesmiaRRR",
	[1113] = "evmwsmiRRR",
	[1145] = "evmwsmiaRRR",
	[1344] = "evmwlusiaawRRR",
	[1352] = "evmwlumiaawRRR",
	[710] = "efsnegRR",
	[1368] = "evmwumiaaRRR",
	[1448] = "evmhegumianRRR",
	[562] = "evcmpltuYRR",
	[558] = "evmergehiloRRR",
	[554] = "evrlwiRRA",
	[722] = "efscfufR-R",
	[1416] = "evmheumianwRRR",
	[546] = "evsrwiuRRA",
	[1408] = "evmheusianwRRR",
	[542] = "evnandRRR",
	[742] = "efdnegRR",
	[738] = "efdcfuidR-R",
	[530] = "evandcRRR",
	[526] = "evcntlswRR",
	[522] = "evextsbRR",
	[754] = "efdcfufR-R",
	[514] = "evaddiwRAR~",
	[766] = "efdtsteqYRR",
	[1472] = "evmwlusianwRRR",
	[762] = "efdctsizR-R",
	[1496] = "evmwumianRRR",
	[771] = "evldwRR8",
	[783] = "evlhhossplatRR2",
	[1327] = "evmhogsmfaaRRR",
	[1032] = "evmheumiRRR",
	[791] = "evlwhosRR4",
	[1287] = "evmhossfaawRRR",
	[1295] = "evmhosmfaawRRR",
	[1064] = "evmheumiaRRR",
	[803] = "evstdwRR8",
	[1112] = "evmwumiRRR",
	[1096] = "evmwlumiRRR",
	[1144] = "evmwumiaRRR",
	[1128] = "evmwlumiaRRR",
	[1455] = "evmhogsmfanRRR",
	[1423] = "evmhosmfanwRRR",
	[1415] = "evmhossfanwRRR",
	[1216] = "evaddusiaawRR",
	[634] = "evselRRRW",
	[1224] = "evaddumiaawRR",
	[638] = "evselRRRW",
	[641] = "evfssubRRR",
	[645] = "evfsnabsRR",
	[649] = "evfsdivRRR",
	[1039] = "evmhosmfRRR",
	[1031] = "evmhossfRRR",
	[661] = "evfsctsiR-R",
	[669] = "evfststltYRR",
	[1063] = "evmhossfaRRR",
	[1103] = "evmwhsmfRRR",
	[1095] = "evmwhssfRRR",
	[1135] = "evmwhsmfaRRR",
	[709] = "efsnabsRR",
	[1127] = "evmwhssfaRRR",
	[705] = "efssubRRR",
	[717] = "efscmpltYRR",
	[713] = "efsdivRRR",
	[725] = "efsctsiR-R",
	[721] = "efscfsiR-R",
	[733] = "efststltYRR",
	[545] = "evsrwsRRR",
	[741] = "efdnabsRR",
	[537] = "eveqvRRR",
	[749] = "efdcmpltYRR",
	[529] = "evandRRR",
	[525] = "evcntlzwRR",
	[521] = "evnegRR",
	[765] = "efdtstltYRR",
	[770] = "evldwxRR0R",
	[782] = "evlhhossplatxRR0R",
	[1325] = "evmhogsmiaaRRR",
	[790] = "evlwhosxRR0R",
	[1285] = "evmhossiaawRRR",
	[1293] = "evmhosmiaawRRR",
	[802] = "evstdwxRR0R"
}
local var23_0 = {
	[0] = false,
	false,
	"tdiARI",
	"twiARI",
	var22_0,
	false,
	false,
	"mulliRRI",
	"subficRRI",
	false,
	"cmpl_iYLRU",
	"cmp_iYLRI",
	"addicRRI",
	"addic.RRI",
	"addi|liRR0I",
	"addis|lisRR0I",
	"b_KBJ",
	"sc",
	"bKJ",
	var14_0,
	"rlwimiRR~AAA.",
	var15_0,
	false,
	"rlwnmRR~RAA.",
	"oriNRR~U",
	"orisRR~U",
	"xoriRR~U",
	"xorisRR~U",
	"andi.RR~U",
	"andis.RR~U",
	var16_0,
	var17_0,
	"lwzRRD",
	"lwzuRRD",
	"lbzRRD",
	"lbzuRRD",
	"stwRRD",
	"stwuRRD",
	"stbRRD",
	"stbuRRD",
	"lhzRRD",
	"lhzuRRD",
	"lhaRRD",
	"lhauRRD",
	"sthRRD",
	"sthuRRD",
	"lmwRRD",
	"stmwRRD",
	"lfsFRD",
	"lfsuFRD",
	"lfdFRD",
	"lfduFRD",
	"stfsFRD",
	"stfsuFRD",
	"stfdFRD",
	"stfduFRD",
	false,
	false,
	var18_0,
	var20_0,
	false,
	false,
	var19_0,
	var21_0
}
local var24_0 = {
	[0] = "r0",
	"sp",
	"r2",
	"r3",
	"r4",
	"r5",
	"r6",
	"r7",
	"r8",
	"r9",
	"r10",
	"r11",
	"r12",
	"r13",
	"r14",
	"r15",
	"r16",
	"r17",
	"r18",
	"r19",
	"r20",
	"r21",
	"r22",
	"r23",
	"r24",
	"r25",
	"r26",
	"r27",
	"r28",
	"r29",
	"r30",
	"r31"
}
local var25_0 = {
	[0] = "lt",
	"gt",
	"eq",
	"so",
	"ge",
	"le",
	"ne",
	"ns"
}

local function var26_0(arg0_3)
	if arg0_3 <= 3 then
		return var25_0[var8_0(arg0_3, 3)]
	else
		return var2_0("4*cr%d+%s", var12_0(arg0_3, 2), var25_0[var8_0(arg0_3, 3)])
	end
end

local function var27_0(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.pos
	local var1_4 = ""

	if arg0_4.rel then
		local var2_4 = arg0_4.symtab[arg0_4.rel]

		if var2_4 then
			var1_4 = "\t->" .. var2_4
		end
	end

	if arg0_4.hexdump > 0 then
		arg0_4.out(var2_0("%08x  %s  %-7s %s%s\n", arg0_4.addr + var0_4, var10_0(arg0_4.op), arg1_4, var6_0(arg2_4, ", "), var1_4))
	else
		arg0_4.out(var2_0("%08x  %-7s %s%s\n", arg0_4.addr + var0_4, arg1_4, var6_0(arg2_4, ", "), var1_4))
	end

	arg0_4.pos = var0_4 + 4
end

local function var28_0(arg0_5)
	return var27_0(arg0_5, ".long", {
		"0x" .. var10_0(arg0_5.op)
	})
end

local function var29_0(arg0_6)
	local var0_6 = arg0_6.pos
	local var1_6, var2_6, var3_6, var4_6 = var1_0(arg0_6.code, var0_6 + 1, var0_6 + 4)
	local var5_6 = var9_0(var11_0(var1_6, 24), var11_0(var2_6, 16), var11_0(var3_6, 8), var4_6)
	local var6_6 = {}
	local var7_6
	local var8_6 = 21

	arg0_6.op = var5_6
	arg0_6.rel = nil

	local var9_6 = var23_0[var12_0(var1_6, 2)]

	while var0_0(var9_6) ~= "string" do
		if not var9_6 then
			return var28_0(arg0_6)
		end

		var9_6 = var9_6[var8_0(var12_0(var5_6, var9_6.shift), var9_6.mask)]
	end

	local var10_6, var11_6 = var3_0(var9_6, "^([a-z0-9_.]*)(.*)")
	local var12_6, var13_6 = var3_0(var11_6, "|([a-z0-9_.]*)(.*)")

	if var12_6 then
		var11_6 = var13_6
	end

	for iter0_6 in var4_0(var11_6, ".") do
		local var14_6

		if iter0_6 == "R" then
			var14_6 = var24_0[var8_0(var12_0(var5_6, var8_6), 31)]
			var8_6 = var8_6 - 5
		elseif iter0_6 == "F" then
			var14_6 = "f" .. var8_0(var12_0(var5_6, var8_6), 31)
			var8_6 = var8_6 - 5
		elseif iter0_6 == "A" then
			var14_6 = var8_0(var12_0(var5_6, var8_6), 31)
			var8_6 = var8_6 - 5
		elseif iter0_6 == "S" then
			var14_6 = var13_0(var11_0(var5_6, 27 - var8_6), 27)
			var8_6 = var8_6 - 5
		elseif iter0_6 == "I" then
			var14_6 = var13_0(var11_0(var5_6, 16), 16)
		elseif iter0_6 == "U" then
			var14_6 = var8_0(var5_6, 65535)
		elseif iter0_6 == "D" or iter0_6 == "E" then
			local var15_6 = var13_0(var11_0(var5_6, 16), 16)

			if iter0_6 == "E" then
				var15_6 = var8_0(var15_6, -4)
			end

			if var7_6 == "r0" then
				var7_6 = "0"
			end

			var6_6[#var6_6] = var2_0("%d(%s)", var15_6, var7_6)
		elseif iter0_6 >= "2" and iter0_6 <= "8" then
			local var16_6 = var8_0(var12_0(var5_6, var8_6), 31) * iter0_6

			if var7_6 == "r0" then
				var7_6 = "0"
			end

			var6_6[#var6_6] = var2_0("%d(%s)", var16_6, var7_6)
		elseif iter0_6 == "H" then
			var14_6 = var8_0(var12_0(var5_6, var8_6), 31) + var11_0(var8_0(var5_6, 2), 4)
			var8_6 = var8_6 - 5
		elseif iter0_6 == "M" then
			var14_6 = var8_0(var12_0(var5_6, var8_6), 31) + var8_0(var5_6, 32)
		elseif iter0_6 == "C" then
			var14_6 = var26_0(var8_0(var12_0(var5_6, var8_6), 31))
			var8_6 = var8_6 - 5
		elseif iter0_6 == "B" then
			local var17_6 = var12_0(var5_6, 21)
			local var18_6 = var8_0(var12_0(var5_6, 16), 31)
			local var19_6 = ""

			var8_6 = var8_6 - 10

			if var8_0(var17_6, 4) == 0 then
				var19_6 = var8_0(var17_6, 2) == 0 and "dnz" or "dz"

				if var8_0(var17_6, 16) == 0 then
					var19_6 = var19_6 .. (var8_0(var17_6, 8) == 0 and "f" or "t")
				end

				if var8_0(var17_6, 16) == 0 then
					var14_6 = var26_0(var18_6)
				end

				var10_6 = var10_6 .. (var8_0(var17_6, 1) == var8_0(var12_0(var5_6, 15), 1) and "-" or "+")
			elseif var8_0(var17_6, 16) == 0 then
				var19_6 = var25_0[var8_0(var18_6, 3) + (var8_0(var17_6, 8) == 0 and 4 or 0)]

				if var18_6 > 3 then
					var14_6 = "cr" .. var12_0(var18_6, 2)
				end

				var10_6 = var10_6 .. (var8_0(var17_6, 1) == var8_0(var12_0(var5_6, 15), 1) and "-" or "+")
			end

			var10_6 = var5_0(var10_6, "_", var19_6)
		elseif iter0_6 == "J" then
			var14_6 = var13_0(var11_0(var5_6, 27 - var8_6), 29 - var8_6) * 4

			if var8_0(var5_6, 2) == 0 then
				var14_6 = arg0_6.addr + var0_6 + var14_6
			end

			arg0_6.rel = var14_6
			var14_6 = "0x" .. var10_0(var14_6)
		elseif iter0_6 == "K" then
			if var8_0(var5_6, 1) ~= 0 then
				var10_6 = var10_6 .. "l"
			end

			if var8_0(var5_6, 2) ~= 0 then
				var10_6 = var10_6 .. "a"
			end
		elseif iter0_6 == "X" or iter0_6 == "Y" then
			var14_6 = var8_0(var12_0(var5_6, var8_6 + 2), 7)
			var14_6 = (var14_6 ~= 0 or iter0_6 ~= "Y" or nil) and "cr" .. var14_6
			var8_6 = var8_6 - 5
		elseif iter0_6 == "W" then
			var14_6 = "cr" .. var8_0(var5_6, 7)
		elseif iter0_6 == "Z" then
			var14_6 = var8_0(var12_0(var5_6, var8_6 - 4), 255)
			var8_6 = var8_6 - 10
		elseif iter0_6 == ">" then
			var6_6[#var6_6] = var12_0(var6_6[#var6_6], 1)
		elseif iter0_6 == "0" then
			if var7_6 == "r0" then
				var6_6[#var6_6] = nil

				if var12_6 then
					var10_6 = var12_6
				end
			end
		elseif iter0_6 == "L" then
			var10_6 = var5_0(var10_6, "_", var8_0(var5_6, 2097152) ~= 0 and "d" or "w")
		elseif iter0_6 == "." then
			if var8_0(var5_6, 1) == 1 then
				var10_6 = var10_6 .. "."
			end
		elseif iter0_6 == "N" then
			if var5_6 == 1610612736 then
				var10_6 = "nop"

				break
			end
		elseif iter0_6 == "~" then
			local var20_6 = #var6_6

			var6_6[var20_6 - 1], var6_6[var20_6] = var6_6[var20_6], var6_6[var20_6 - 1]
		elseif iter0_6 == "=" then
			local var21_6 = #var6_6

			if var7_6 == var6_6[var21_6 - 1] then
				var6_6[var21_6] = nil
				var10_6 = var12_6
			end
		elseif iter0_6 == "%" then
			local var22_6 = #var6_6

			if var7_6 == var6_6[var22_6 - 1] and var7_6 == var6_6[var22_6 - 2] then
				var6_6[var22_6] = nil
				var6_6[var22_6 - 1] = nil
				var10_6 = var12_6
			end
		elseif iter0_6 == "-" then
			var8_6 = var8_6 - 5
		else
			assert(false)
		end

		if var14_6 then
			var6_6[#var6_6 + 1] = var14_6
			var7_6 = var14_6
		end
	end

	return var27_0(arg0_6, var10_6, var6_6)
end

local function var30_0(arg0_7, arg1_7, arg2_7)
	arg1_7 = arg1_7 or 0

	local var0_7 = arg2_7 and arg1_7 + arg2_7 or #arg0_7.code
	local var1_7 = var0_7 - var0_7 % 4

	arg0_7.pos = arg1_7 - arg1_7 % 4
	arg0_7.rel = nil

	while var1_7 > arg0_7.pos do
		var29_0(arg0_7)
	end
end

local function var31_0(arg0_8, arg1_8, arg2_8)
	local var0_8 = {
		code = arg0_8,
		addr = arg1_8 or 0,
		out = arg2_8 or io.write,
		symtab = {},
		disass = var30_0
	}

	var0_8.hexdump = 8

	return var0_8
end

local function var32_0(arg0_9, arg1_9, arg2_9)
	var31_0(arg0_9, arg1_9, arg2_9):disass()
end

local function var33_0(arg0_10)
	if arg0_10 < 32 then
		return var24_0[arg0_10]
	end

	return "f" .. arg0_10 - 32
end

return {
	create = var31_0,
	disass = var32_0,
	regname = var33_0
}
