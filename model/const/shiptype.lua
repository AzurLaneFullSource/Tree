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

function var0_0.ContainInLimitBundle(arg0_6, arg1_6)
	if type(arg0_6) == "string" then
		for iter0_6, iter1_6 in ipairs(var0_0.BundleList[arg0_6]) do
			if iter1_6 == arg1_6 then
				return true
			end
		end
	elseif type(arg0_6) == "number" then
		return arg0_6 == 0 or arg1_6 == arg0_6
	end

	return false
end

var0_0.CloakShipTypeList = {
	var0_0.QingHang,
	var0_0.ZhengHang,
	var0_0.DaoQuM
}

function var0_0.CloakShipType(arg0_7)
	return table.contains(var0_0.CloakShipTypeList, arg0_7)
end

var0_0.QuZhuShipType = {}

for iter0_0, iter1_0 in ipairs(var0_0.BundleList.quzhu) do
	var0_0.QuZhuShipType[iter1_0] = true
end

function var0_0.IsTypeQuZhu(arg0_8)
	return var0_0.QuZhuShipType[arg0_8]
end

function var0_0.FilterOverQuZhuType(arg0_9)
	local var0_9 = false

	return underscore.filter(arg0_9, function(arg0_10)
		if not var0_9 or not var0_0.IsTypeQuZhu(arg0_10) then
			var0_9 = var0_9 or var0_0.IsTypeQuZhu(arg0_10)

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

function var0_0.IsTypeFengFan(arg0_11)
	return var0_0.FengFanType[arg0_11]
end

function var0_0.FilterOverFengFanType(arg0_12)
	local var0_12 = false

	return underscore.filter(arg0_12, function(arg0_13)
		if not var0_12 or not var0_0.IsTypeFengFan(arg0_13) then
			var0_12 = var0_12 or var0_0.IsTypeFengFan(arg0_13)

			return true
		else
			return false
		end
	end)
end

function var0_0.MergeFengFanType(arg0_14, arg1_14, arg2_14)
	local var0_14 = var0_0.BundleList.fengfan[1]

	if underscore.all(var0_0.BundleList.fengfan, function(arg0_15)
		return arg1_14[var0_14] == arg1_14[arg0_15] and arg2_14[var0_14] == arg2_14[arg0_15]
	end) then
		local var1_14 = table.indexof(arg0_14, var0_14)

		arg0_14 = underscore.filter(arg0_14, function(arg0_16)
			return not table.contains(var0_0.BundleList.fengfan, arg0_16)
		end)

		table.insert(arg0_14, var1_14, "fengfan")

		arg1_14.fengfan = arg1_14[var0_14]
		arg2_14.fengfan = arg2_14[var0_14]
	end

	return arg0_14
end

return var0_0
