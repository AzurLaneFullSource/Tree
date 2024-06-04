local var0 = class("EducatePlanIndexConst")

var0.TypeScholl = bit.lshift(1, 0)
var0.TypeInterest = bit.lshift(1, 1)
var0.TypeCommunity = bit.lshift(1, 2)
var0.TypeFreetime = bit.lshift(1, 3)
var0.TypeIndexs = {
	var0.TypeScholl,
	var0.TypeInterest,
	var0.TypeCommunity,
	var0.TypeFreetime
}
var0.TypeAll = IndexConst.BitAll(var0.TypeIndexs)

table.insert(var0.TypeIndexs, 1, var0.TypeAll)

var0.TypeNames = {
	i18n("index_all"),
	i18n("child_plan_type1"),
	i18n("child_plan_type2"),
	i18n("child_plan_type3"),
	i18n("child_plan_type4")
}

function var0.filterByType(arg0, arg1)
	if not arg1 or arg1 == var0.TypeAll then
		return true
	end

	for iter0 = 2, #var0.CONFIG.type do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = var0.CONFIG.type[iter0].types

			if table.contains(var1, arg0:GetType()) then
				return true
			end
		end
	end

	return false
end

var0.CostMoney = bit.lshift(1, 0)
var0.CostMood = bit.lshift(1, 1)
var0.CostIndexs = {
	var0.CostMoney,
	var0.CostMood
}
var0.CostAll = IndexConst.BitAll(var0.CostIndexs)

table.insert(var0.CostIndexs, 1, var0.CostAll)

var0.CostNames = {
	i18n("index_all"),
	pg.child_resource[EducateChar.RES_MONEY_ID].name,
	pg.child_resource[EducateChar.RES_MOOD_ID].name
}

function var0.filterByCost(arg0, arg1)
	if not arg1 or arg1 == var0.CostAll then
		return true
	end

	for iter0 = 2, #var0.CONFIG.cost do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = var0.CONFIG.cost[iter0].names

			for iter1, iter2 in ipairs(var1) do
				if arg0:getConfig(iter2) > 0 then
					return true
				end
			end
		end
	end

	return false
end

var0.AwardRes_Money = bit.lshift(1, 0)
var0.AwardRes_Mood = bit.lshift(1, 1)
var0.AwardResIndexs = {
	var0.AwardRes_Money,
	var0.AwardRes_Mood
}
var0.AwardResAll = IndexConst.BitAll(var0.AwardResIndexs)

table.insert(var0.AwardResIndexs, 1, var0.AwardResAll)

var0.AwardResNames = {
	i18n("child_filter_award_res"),
	pg.child_resource[EducateChar.RES_MONEY_ID].name,
	pg.child_resource[EducateChar.RES_MOOD_ID].name
}

function var0.filterByAwardRes(arg0, arg1)
	if not arg1 or arg1 == var0.AwardResAll then
		return true
	end

	return var0.filterByAward(arg0, arg1, "awardRes")
end

var0.AwardNature_Wukou = bit.lshift(1, 0)
var0.AwardNature_Kailang = bit.lshift(1, 1)
var0.AwardNature_Wenrou = bit.lshift(1, 2)
var0.AwardNatureIndexs = {
	var0.AwardNature_Wukou,
	var0.AwardNature_Kailang,
	var0.AwardNature_Wenrou
}
var0.AwardNatureAll = IndexConst.BitAll(var0.AwardNatureIndexs)

table.insert(var0.AwardNatureIndexs, 1, var0.AwardNatureAll)

var0.AwardNatureNames = {
	i18n("child_filter_award_nature"),
	pg.child_attr[201].name,
	pg.child_attr[202].name,
	pg.child_attr[203].name
}

function var0.filterByAwardNature(arg0, arg1)
	if not arg1 or arg1 == var0.AwardNatureAll then
		return true
	end

	return var0.filterByAward(arg0, arg1, "awardNature")
end

var0.AwardAttr1_Meili = bit.lshift(1, 0)
var0.AwardAttr1_Tineng = bit.lshift(1, 1)
var0.AwardAttr1_Zhishi = bit.lshift(1, 2)
var0.AwardAttr1_Ganzhi = bit.lshift(1, 3)
var0.AwardAttr1Indexs = {
	var0.AwardAttr1_Meili,
	var0.AwardAttr1_Tineng,
	var0.AwardAttr1_Zhishi,
	var0.AwardAttr1_Ganzhi
}
var0.AwardAttr1All = IndexConst.BitAll(var0.AwardAttr1Indexs)

table.insert(var0.AwardAttr1Indexs, 1, var0.AwardAttr1All)

var0.AwardAttr1Names = {
	i18n("child_filter_award_attr1"),
	pg.child_attr[101].name,
	pg.child_attr[102].name,
	pg.child_attr[103].name,
	pg.child_attr[104].name
}

function var0.filterByAwardAttr1(arg0, arg1)
	if not arg1 or arg1 == var0.AwardAttr1All then
		return true
	end

	return var0.filterByAward(arg0, arg1, "awardAttr1")
end

var0.AwardAttr2_Biaoxianli = bit.lshift(1, 0)
var0.AwardAttr2_Xiangxiang = bit.lshift(1, 1)
var0.AwardAttr2_Yinyue = bit.lshift(1, 2)
var0.AwardAttr2_Xixin = bit.lshift(1, 3)
var0.AwardAttr2_Yundong = bit.lshift(1, 4)
var0.AwardAttr2_Shijian = bit.lshift(1, 5)
var0.AwardAttr2Indexs = {
	var0.AwardAttr2_Biaoxianli,
	var0.AwardAttr2_Xiangxiang,
	var0.AwardAttr2_Yinyue,
	var0.AwardAttr2_Xixin,
	var0.AwardAttr2_Yundong,
	var0.AwardAttr2_Shijian
}
var0.AwardAttr2All = IndexConst.BitAll(var0.AwardAttr2Indexs)

table.insert(var0.AwardAttr2Indexs, 1, var0.AwardAttr2All)

var0.AwardAttr2Names = {
	i18n("child_filter_award_attr2"),
	pg.child_attr[301].name,
	pg.child_attr[302].name,
	pg.child_attr[303].name,
	pg.child_attr[304].name,
	pg.child_attr[305].name,
	pg.child_attr[306].name
}

function var0.filterByAwardAttr2(arg0, arg1)
	if not arg1 or arg1 == var0.AwardAttr2All then
		return true
	end

	return var0.filterByAward(arg0, arg1, "awardAttr2")
end

function var0.filterByAward(arg0, arg1, arg2)
	for iter0 = 2, #var0.CONFIG[arg2] do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = var0.CONFIG[arg2][iter0]

			for iter1, iter2 in ipairs(var1.ids) do
				if arg0:CheckResult(var1.type, iter2) then
					return true
				end
			end
		end
	end

	return false
end

var0.CONFIG = {
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

return var0
