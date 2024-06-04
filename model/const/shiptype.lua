local var0 = class("ShipType")

var0.QuZhu = 1
var0.QingXun = 2
var0.ZhongXun = 3
var0.ZhanXun = 4
var0.ZhanLie = 5
var0.QingHang = 6
var0.ZhengHang = 7
var0.QianTing = 8
var0.HangXun = 9
var0.HangZhan = 10
var0.LeiXun = 11
var0.WeiXiu = 12
var0.ZhongPao = 13
var0.QianMu = 17
var0.ChaoXun = 18
var0.Yunshu = 19
var0.DaoQuV = 20
var0.DaoQuM = 21
var0.FengFanS = 22
var0.FengFanV = 23
var0.FengFanM = 24
var0.YuLeiTing = 14
var0.JinBi = 15
var0.ZiBao = 16
var0.WeiZhi = 25
var0.AllShipType = {
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
var0.SpecificTypeTable = {
	auxiliary = "AUX",
	gunner = "GNR",
	torpedo = "TORP"
}
var0.SpecificTableTips = {
	GNR = "breakout_tip_ultimatebonus_gunner",
	TORP = "breakout_tip_ultimatebonus_torpedo",
	AUX = "breakout_tip_ultimatebonus_aux"
}

function var0.Type2Name(arg0)
	return pg.ship_data_by_type[arg0].type_name
end

function var0.Type2Print(arg0)
	if not var0.prints then
		var0.prints = {
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

	return var0.prints[arg0]
end

function var0.Type2BattlePrint(arg0)
	if not var0.bprints then
		var0.bprints = {
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

	return var0.bprints[arg0]
end

function var0.Type2CNLabel(arg0)
	if not var0.cnLabel then
		var0.cnLabel = {
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

	return var0.cnLabel[arg0]
end

var0.BundleBattleShip = "zhan"
var0.BundleAircraftCarrier = "hang"
var0.BundleSubmarine = "qian"
var0.BundleLargeCrusier = "zhong"
var0.BundleAntiSubmarine = "fanqian"
var0.BundleList = {
	zhan = {
		var0.ZhanXun,
		var0.ZhanLie
	},
	hang = {
		var0.QingHang,
		var0.ZhengHang
	},
	qian = {
		var0.QianTing,
		var0.QianMu,
		var0.FengFanS
	},
	zhong = {
		var0.ZhongXun,
		var0.ChaoXun
	},
	fanqian = {
		var0.QuZhu,
		var0.QingXun,
		var0.DaoQuV
	},
	quzhu = {
		var0.QuZhu,
		var0.DaoQuM,
		var0.DaoQuV
	},
	fengfan = {
		var0.FengFanS,
		var0.FengFanV,
		var0.FengFanM
	}
}

function var0.BundleType2CNLabel(arg0)
	if not var0.bundleLabel then
		var0.bundleLabel = {
			zhong = "label_13",
			qian = "label_8",
			zhan = "label_11",
			fanqian = "label_55",
			hang = "label_12",
			quzhu = "label_1"
		}
	end

	return var0.bundleLabel[arg0]
end

function var0.ContainInLimitBundle(arg0, arg1)
	if type(arg0) == "string" then
		for iter0, iter1 in ipairs(var0.BundleList[arg0]) do
			if iter1 == arg1 then
				return true
			end
		end
	elseif type(arg0) == "number" then
		return arg0 == 0 or arg1 == arg0
	end

	return false
end

var0.CloakShipTypeList = {
	var0.QingHang,
	var0.ZhengHang,
	var0.DaoQuM
}

function var0.CloakShipType(arg0)
	return table.contains(var0.CloakShipTypeList, arg0)
end

var0.QuZhuShipType = {}

for iter0, iter1 in ipairs(var0.BundleList.quzhu) do
	var0.QuZhuShipType[iter1] = true
end

function var0.IsTypeQuZhu(arg0)
	return var0.QuZhuShipType[arg0]
end

function var0.FilterOverQuZhuType(arg0)
	local var0 = false

	return underscore.filter(arg0, function(arg0)
		if not var0 or not var0.IsTypeQuZhu(arg0) then
			var0 = var0 or var0.IsTypeQuZhu(arg0)

			return true
		else
			return false
		end
	end)
end

var0.FengFanType = {}

for iter2, iter3 in ipairs(var0.BundleList.fengfan) do
	var0.FengFanType[iter3] = true
end

function var0.IsTypeFengFan(arg0)
	return var0.FengFanType[arg0]
end

function var0.FilterOverFengFanType(arg0)
	local var0 = false

	return underscore.filter(arg0, function(arg0)
		if not var0 or not var0.IsTypeFengFan(arg0) then
			var0 = var0 or var0.IsTypeFengFan(arg0)

			return true
		else
			return false
		end
	end)
end

function var0.MergeFengFanType(arg0, arg1, arg2)
	local var0 = var0.BundleList.fengfan[1]

	if underscore.all(var0.BundleList.fengfan, function(arg0)
		return arg1[var0] == arg1[arg0] and arg2[var0] == arg2[arg0]
	end) then
		local var1 = table.indexof(arg0, var0)

		arg0 = underscore.filter(arg0, function(arg0)
			return not table.contains(var0.BundleList.fengfan, arg0)
		end)

		table.insert(arg0, var1, "fengfan")

		arg1.fengfan = arg1[var0]
		arg2.fengfan = arg2[var0]
	end

	return arg0
end

return var0
