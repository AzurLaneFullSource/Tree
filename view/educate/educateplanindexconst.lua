local var0_0 = class("EducatePlanIndexConst")

var0_0.TypeScholl = bit.lshift(1, 0)
var0_0.TypeInterest = bit.lshift(1, 1)
var0_0.TypeCommunity = bit.lshift(1, 2)
var0_0.TypeFreetime = bit.lshift(1, 3)
var0_0.TypeIndexs = {
	var0_0.TypeScholl,
	var0_0.TypeInterest,
	var0_0.TypeCommunity,
	var0_0.TypeFreetime
}
var0_0.TypeAll = IndexConst.BitAll(var0_0.TypeIndexs)

table.insert(var0_0.TypeIndexs, 1, var0_0.TypeAll)

var0_0.TypeNames = {
	i18n("index_all"),
	i18n("child_plan_type1"),
	i18n("child_plan_type2"),
	i18n("child_plan_type3"),
	i18n("child_plan_type4")
}

function var0_0.filterByType(arg0_1, arg1_1)
	if not arg1_1 or arg1_1 == var0_0.TypeAll then
		return true
	end

	for iter0_1 = 2, #var0_0.CONFIG.type do
		local var0_1 = bit.lshift(1, iter0_1 - 2)

		if bit.band(var0_1, arg1_1) > 0 then
			local var1_1 = var0_0.CONFIG.type[iter0_1].types

			if table.contains(var1_1, arg0_1:GetType()) then
				return true
			end
		end
	end

	return false
end

var0_0.CostMoney = bit.lshift(1, 0)
var0_0.CostMood = bit.lshift(1, 1)
var0_0.CostIndexs = {
	var0_0.CostMoney,
	var0_0.CostMood
}
var0_0.CostAll = IndexConst.BitAll(var0_0.CostIndexs)

table.insert(var0_0.CostIndexs, 1, var0_0.CostAll)

var0_0.CostNames = {
	i18n("index_all"),
	pg.child_resource[EducateChar.RES_MONEY_ID].name,
	pg.child_resource[EducateChar.RES_MOOD_ID].name
}

function var0_0.filterByCost(arg0_2, arg1_2)
	if not arg1_2 or arg1_2 == var0_0.CostAll then
		return true
	end

	for iter0_2 = 2, #var0_0.CONFIG.cost do
		local var0_2 = bit.lshift(1, iter0_2 - 2)

		if bit.band(var0_2, arg1_2) > 0 then
			local var1_2 = var0_0.CONFIG.cost[iter0_2].names

			for iter1_2, iter2_2 in ipairs(var1_2) do
				if arg0_2:getConfig(iter2_2) > 0 then
					return true
				end
			end
		end
	end

	return false
end

var0_0.AwardRes_Money = bit.lshift(1, 0)
var0_0.AwardRes_Mood = bit.lshift(1, 1)
var0_0.AwardResIndexs = {
	var0_0.AwardRes_Money,
	var0_0.AwardRes_Mood
}
var0_0.AwardResAll = IndexConst.BitAll(var0_0.AwardResIndexs)

table.insert(var0_0.AwardResIndexs, 1, var0_0.AwardResAll)

var0_0.AwardResNames = {
	i18n("child_filter_award_res"),
	pg.child_resource[EducateChar.RES_MONEY_ID].name,
	pg.child_resource[EducateChar.RES_MOOD_ID].name
}

function var0_0.filterByAwardRes(arg0_3, arg1_3)
	if not arg1_3 or arg1_3 == var0_0.AwardResAll then
		return true
	end

	return var0_0.filterByAward(arg0_3, arg1_3, "awardRes")
end

var0_0.AwardNature_Wukou = bit.lshift(1, 0)
var0_0.AwardNature_Kailang = bit.lshift(1, 1)
var0_0.AwardNature_Wenrou = bit.lshift(1, 2)
var0_0.AwardNatureIndexs = {
	var0_0.AwardNature_Wukou,
	var0_0.AwardNature_Kailang,
	var0_0.AwardNature_Wenrou
}
var0_0.AwardNatureAll = IndexConst.BitAll(var0_0.AwardNatureIndexs)

table.insert(var0_0.AwardNatureIndexs, 1, var0_0.AwardNatureAll)

var0_0.AwardNatureNames = {
	i18n("child_filter_award_nature"),
	pg.child_attr[201].name,
	pg.child_attr[202].name,
	pg.child_attr[203].name
}

function var0_0.filterByAwardNature(arg0_4, arg1_4)
	if not arg1_4 or arg1_4 == var0_0.AwardNatureAll then
		return true
	end

	return var0_0.filterByAward(arg0_4, arg1_4, "awardNature")
end

var0_0.AwardAttr1_Meili = bit.lshift(1, 0)
var0_0.AwardAttr1_Tineng = bit.lshift(1, 1)
var0_0.AwardAttr1_Zhishi = bit.lshift(1, 2)
var0_0.AwardAttr1_Ganzhi = bit.lshift(1, 3)
var0_0.AwardAttr1Indexs = {
	var0_0.AwardAttr1_Meili,
	var0_0.AwardAttr1_Tineng,
	var0_0.AwardAttr1_Zhishi,
	var0_0.AwardAttr1_Ganzhi
}
var0_0.AwardAttr1All = IndexConst.BitAll(var0_0.AwardAttr1Indexs)

table.insert(var0_0.AwardAttr1Indexs, 1, var0_0.AwardAttr1All)

var0_0.AwardAttr1Names = {
	i18n("child_filter_award_attr1"),
	pg.child_attr[101].name,
	pg.child_attr[102].name,
	pg.child_attr[103].name,
	pg.child_attr[104].name
}

function var0_0.filterByAwardAttr1(arg0_5, arg1_5)
	if not arg1_5 or arg1_5 == var0_0.AwardAttr1All then
		return true
	end

	return var0_0.filterByAward(arg0_5, arg1_5, "awardAttr1")
end

var0_0.AwardAttr2_Biaoxianli = bit.lshift(1, 0)
var0_0.AwardAttr2_Xiangxiang = bit.lshift(1, 1)
var0_0.AwardAttr2_Yinyue = bit.lshift(1, 2)
var0_0.AwardAttr2_Xixin = bit.lshift(1, 3)
var0_0.AwardAttr2_Yundong = bit.lshift(1, 4)
var0_0.AwardAttr2_Shijian = bit.lshift(1, 5)
var0_0.AwardAttr2Indexs = {
	var0_0.AwardAttr2_Biaoxianli,
	var0_0.AwardAttr2_Xiangxiang,
	var0_0.AwardAttr2_Yinyue,
	var0_0.AwardAttr2_Xixin,
	var0_0.AwardAttr2_Yundong,
	var0_0.AwardAttr2_Shijian
}
var0_0.AwardAttr2All = IndexConst.BitAll(var0_0.AwardAttr2Indexs)

table.insert(var0_0.AwardAttr2Indexs, 1, var0_0.AwardAttr2All)

var0_0.AwardAttr2Names = {
	i18n("child_filter_award_attr2"),
	pg.child_attr[301].name,
	pg.child_attr[302].name,
	pg.child_attr[303].name,
	pg.child_attr[304].name,
	pg.child_attr[305].name,
	pg.child_attr[306].name
}

function var0_0.filterByAwardAttr2(arg0_6, arg1_6)
	if not arg1_6 or arg1_6 == var0_0.AwardAttr2All then
		return true
	end

	return var0_0.filterByAward(arg0_6, arg1_6, "awardAttr2")
end

function var0_0.filterByAward(arg0_7, arg1_7, arg2_7)
	for iter0_7 = 2, #var0_0.CONFIG[arg2_7] do
		local var0_7 = bit.lshift(1, iter0_7 - 2)

		if bit.band(var0_7, arg1_7) > 0 then
			local var1_7 = var0_0.CONFIG[arg2_7][iter0_7]

			for iter1_7, iter2_7 in ipairs(var1_7.ids) do
				if arg0_7:CheckResult(var1_7.type, iter2_7) then
					return true
				end
			end
		end
	end

	return false
end

var0_0.CONFIG = {
	type = {
		{
			types = {}
		},
		{
			types = {
				EducatePlan.TYPE_SCHOOL
			}
		},
		{
			types = {
				EducatePlan.TYPE_INTEREST
			}
		},
		{
			types = {
				EducatePlan.TYPE_COMMUNITY
			}
		},
		{
			types = {
				EducatePlan.TYPE_FREETIME
			}
		}
	},
	cost = {
		{
			names = {}
		},
		{
			names = {
				"cost_resource1"
			}
		},
		{
			names = {
				"cost_resource2"
			}
		}
	},
	awardRes = {
		{
			type = EducateConst.DROP_TYPE_RES,
			ids = {
				EducateChar.RES_MONEY_ID,
				EducateChar.RES_MOOD_ID,
				EducateChar.RES_FAVOR_ID
			}
		},
		{
			type = EducateConst.DROP_TYPE_RES,
			ids = {
				EducateChar.RES_MONEY_ID
			}
		},
		{
			type = EducateConst.DROP_TYPE_RES,
			ids = {
				EducateChar.RES_MOOD_ID
			}
		}
	},
	awardNature = {
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				201,
				202,
				203
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				201
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				202
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				203
			}
		}
	},
	awardAttr1 = {
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				101,
				102,
				103,
				104
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				101
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				102
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				103
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				104
			}
		}
	},
	awardAttr2 = {
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				301,
				302,
				303,
				304,
				305,
				306
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				301
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				302
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				303
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				304
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				305
			}
		},
		{
			type = EducateConst.DROP_TYPE_ATTR,
			ids = {
				306
			}
		}
	}
}

return var0_0
