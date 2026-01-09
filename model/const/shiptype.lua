local var0_0 = class("ShipType")

var0_0.QuZhu = 1
var0_0.QingXun = 2
var0_0.ZhongXun = 3
var0_0.ZhanXun = 4
var0_0.ZhanLie = 5
var0_0.QingHang = 6
var0_0.ZhengHang = 7
var0_0.QianTing = 8
var0_0.HangXun = 9
var0_0.HangZhan = 10
var0_0.LeiXun = 11
var0_0.WeiXiu = 12
var0_0.ZhongPao = 13
var0_0.QianMu = 17
var0_0.ChaoXun = 18
var0_0.Yunshu = 19
var0_0.DaoQuV = 20
var0_0.DaoQuM = 21
var0_0.FengFanS = 22
var0_0.FengFanV = 23
var0_0.FengFanM = 24
var0_0.YuLeiTing = 14
var0_0.JinBi = 15
var0_0.ZiBao = 16
var0_0.WeiZhi = 25
var0_0.AllShipType = {
	1,
	2,
	3,
	18,
	4,
	5,
	6,
	7,
	10,
	17,
	13,
	8,
	12,
	19,
	20,
	21,
	22,
	23,
	24
}
var0_0.SpecificTypeTable = {
	auxiliary = "AUX",
	gunner = "GNR",
	torpedo = "TORP"
}
var0_0.SpecificTableTips = {
	GNR = "breakout_tip_ultimatebonus_gunner",
	TORP = "breakout_tip_ultimatebonus_torpedo",
	AUX = "breakout_tip_ultimatebonus_aux"
}

function var0_0.Type2Name(arg0_1)
	return pg.ship_data_by_type[arg0_1].type_name
end

function var0_0.Type2Print(arg0_2)
	if not var0_0.prints then
		var0_0.prints = {
			"quzhu",
			"qingxun",
			"zhongxun",
			"zhanlie",
			"zhanlie",
			"hangmu",
			"hangmu",
			"qianting",
			"zhanlie",
			"hangzhan",
			"zhanlie",
			"weixiu",
			"zhongpao",
			"quzhu",
			"battle_jinbi",
			"battle_zibao",
			"qianmu",
			"chaoxun",
			"yunshu",
			"daoquv",
			"daoqum",
			"fengfans",
			"fengfanv",
			"fengfanm",
			"weizhi"
		}
	end

	return var0_0.prints[arg0_2]
end

function var0_0.Type2BattlePrint(arg0_3)
	if not var0_0.bprints then
		var0_0.bprints = {
			"battle_quzhu",
			"battle_qingxun",
			"battle_zhongxun",
			"battle_zhanlie",
			"battle_zhanlie",
			"battle_hangmu",
			"battle_hangmu",
			"battle_qianting",
			"battle_zhanlie",
			"battle_hangmu",
			"battle_zhanlie",
			"battle_weixiu",
			"battle_zhanlie",
			"battle_quzhu",
			"battle_jinbi",
			"battle_zibao",
			"battle_hangmu",
			"battle_zhanlie",
			"battle_yunshu",
			"battle_daoqu",
			"battle_daoqu",
			"battle_fengfans",
			"battle_fengfanv",
			"battle_fengfanm",
			"battle_weizhi"
		}
	end

	return var0_0.bprints[arg0_3]
end

function var0_0.Type2CNLabel(arg0_4)
	if not var0_0.cnLabel then
		var0_0.cnLabel = {
			"label_1",
			"label_2",
			"label_3",
			"label_4",
			"label_5",
			"label_6",
			"label_7",
			"label_19",
			"label_3",
			"label_10",
			"label_3",
			"label_20",
			"label_21",
			"label_1",
			"label_1",
			"label_1",
			"label_17",
			"label_18",
			"label_22",
			"label_23",
			"label_23",
			"label_24",
			"label_25",
			"label_26",
			fengfan = "label_27"
		}
	end

	return var0_0.cnLabel[arg0_4]
end

var0_0.BundleBattleShip = "zhan"
var0_0.BundleAircraftCarrier = "hang"
var0_0.BundleSubmarine = "qian"
var0_0.BundleLargeCrusier = "zhong"
var0_0.BundleAntiSubmarine = "fanqian"
var0_0.BundleList = {
	zhan = {
		var0_0.ZhanXun,
		var0_0.ZhanLie
	},
	hang = {
		var0_0.QingHang,
		var0_0.ZhengHang
	},
	qian = {
		var0_0.QianTing,
		var0_0.QianMu,
		var0_0.FengFanS
	},
	zhong = {
		var0_0.ZhongXun,
		var0_0.ChaoXun
	},
	fanqian = {
		var0_0.QuZhu,
		var0_0.QingXun,
		var0_0.DaoQuV
	},
	quzhu = {
		var0_0.QuZhu,
		var0_0.DaoQuM,
		var0_0.DaoQuV
	},
	fengfan = {
		var0_0.FengFanS,
		var0_0.FengFanV,
		var0_0.FengFanM
	}
}

function var0_0.BundleType2CNLabel(arg0_5)
	if not var0_0.bundleLabel then
		var0_0.bundleLabel = {
			zhong = "label_13",
			qian = "label_8",
			zhan = "label_11",
			fanqian = "label_55",
			hang = "label_12",
			quzhu = "label_1"
		}
	end

	return var0_0.bundleLabel[arg0_5]
end

function var0_0.GetShipTypesFromLimit(arg0_6)
	if type(arg0_6) == "string" then
		return var0_0.BundleList[arg0_6]
	elseif type(arg0_6) == "number" then
		if arg0_6 == 0 then
			return "all"
		else
			return {
				arg0_6
			}
		end

		return arg0_6 == 0 or shipType == arg0_6
	else
		assert(false)
	end
end

function var0_0.ContainInLimitBundle(arg0_7, arg1_7)
	local var0_7 = var0_0.GetShipTypesFromLimit(arg0_7)

	if var0_7 == "all" then
		return true
	else
		return underscore.any(var0_7, function(arg0_8)
			return arg0_8 == arg1_7
		end)
	end
end

var0_0.CloakShipTypeList = {
	var0_0.QingHang,
	var0_0.ZhengHang,
	var0_0.DaoQuM
}

function var0_0.CloakShipType(arg0_9)
	return table.contains(var0_0.CloakShipTypeList, arg0_9)
end

var0_0.QuZhuShipType = {}

for iter0_0, iter1_0 in ipairs(var0_0.BundleList.quzhu) do
	var0_0.QuZhuShipType[iter1_0] = true
end

function var0_0.IsTypeQuZhu(arg0_10)
	return var0_0.QuZhuShipType[arg0_10]
end

function var0_0.FilterOverQuZhuType(arg0_11)
	local var0_11 = false

	return underscore.filter(arg0_11, function(arg0_12)
		if not var0_11 or not var0_0.IsTypeQuZhu(arg0_12) then
			var0_11 = var0_11 or var0_0.IsTypeQuZhu(arg0_12)

			return true
		else
			return false
		end
	end)
end

var0_0.FengFanType = {}

for iter2_0, iter3_0 in ipairs(var0_0.BundleList.fengfan) do
	var0_0.FengFanType[iter3_0] = true
end

function var0_0.IsTypeFengFan(arg0_13)
	return var0_0.FengFanType[arg0_13]
end

function var0_0.FilterOverFengFanType(arg0_14)
	local var0_14 = false

	return underscore.filter(arg0_14, function(arg0_15)
		if not var0_14 or not var0_0.IsTypeFengFan(arg0_15) then
			var0_14 = var0_14 or var0_0.IsTypeFengFan(arg0_15)

			return true
		else
			return false
		end
	end)
end

function var0_0.MergeFengFanType(arg0_16, arg1_16, arg2_16)
	local var0_16 = var0_0.BundleList.fengfan[1]

	if underscore.all(var0_0.BundleList.fengfan, function(arg0_17)
		return arg1_16[var0_16] == arg1_16[arg0_17] and arg2_16[var0_16] == arg2_16[arg0_17]
	end) then
		local var1_16 = table.indexof(arg0_16, var0_16)

		arg0_16 = underscore.filter(arg0_16, function(arg0_18)
			return not table.contains(var0_0.BundleList.fengfan, arg0_18)
		end)

		table.insert(arg0_16, var1_16, "fengfan")

		arg1_16.fengfan = arg1_16[var0_16]
		arg2_16.fengfan = arg2_16[var0_16]
	end

	return arg0_16
end

var0_0.VanguardShipType = {
	var0_0.QuZhu,
	var0_0.QingXun,
	var0_0.ZhongXun,
	var0_0.HangXun,
	var0_0.LeiXun,
	var0_0.ChaoXun,
	var0_0.Yunshu,
	var0_0.DaoQuV,
	var0_0.FengFanV
}
var0_0.MainShipType = {
	var0_0.ZhanXun,
	var0_0.ZhanLie,
	var0_0.QingHang,
	var0_0.ZhengHang,
	var0_0.HangZhan,
	var0_0.WeiXiu,
	var0_0.ZhongPao,
	var0_0.DaoQuM,
	var0_0.FengFanM
}
var0_0.SubShipType = {
	var0_0.QianTing,
	var0_0.QianMu,
	var0_0.FengFanS
}

local var1_0

function var0_0.GetTeamFromShipType(arg0_19)
	if not var1_0 then
		var1_0 = {}

		for iter0_19, iter1_19 in pairs({
			[TeamType.Vanguard] = var0_0.VanguardShipType,
			[TeamType.Main] = var0_0.MainShipType,
			[TeamType.Submarine] = var0_0.SubShipType
		}) do
			for iter2_19, iter3_19 in ipairs(iter1_19) do
				var1_0[iter3_19] = iter0_19
			end
		end
	end

	return var1_0[arg0_19]
end

return var0_0
