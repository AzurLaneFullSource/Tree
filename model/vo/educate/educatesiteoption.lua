local var0_0 = class("EducateSiteOption", import("model.vo.BaseVO"))

var0_0.TYPE_SHOP = 1
var0_0.TYPE_EVENT = 2
var0_0.TYPE_SITE = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
	arg0_1.usedCnt = arg2_1 or 0
	arg0_1.remainCnt = arg0_1:GetOriginalCnt() - arg0_1.usedCnt
	arg0_1.curTime = getProxy(EducateProxy):GetCurTime()

	arg0_1:initTime()
	arg0_1:initRefreshTime()
end

function var0_0.bindConfigTable(arg0_2)
	return pg.child_site_option
end

function var0_0.initTime(arg0_3)
	if arg0_3:IsLimitTime() then
		local var0_3 = arg0_3:getConfig("time_limit")

		arg0_3.startTime, arg0_3.endTime = EducateHelper.CfgTime2Time(var0_3)
	end
end

function var0_0.initRefreshTime(arg0_4)
	if arg0_4:IsEventType() and arg0_4:IsCountLimit() then
		arg0_4.refreshWeeks = {}

		local var0_4 = 9
		local var1_4 = 60
		local var2_4 = arg0_4:getConfig("count_limit")[2]

		table.insert(arg0_4.refreshWeeks, var0_4)

		while var0_4 < var1_4 do
			var0_4 = var0_4 + var2_4

			table.insert(arg0_4.refreshWeeks, var0_4)
		end
	end
end

function var0_0.IsShowLimit(arg0_5)
	return arg0_5:getConfig("is_limit") == 1 and arg0_5.remainCnt > 0
end

function var0_0.IsLimitTime(arg0_6)
	return #arg0_6:getConfig("time_limit") ~= 0
end

function var0_0.IsCountLimit(arg0_7)
	return arg0_7:getConfig("count_limit") ~= "" and #arg0_7:getConfig("count_limit") == 2
end

function var0_0.IsShow(arg0_8)
	if arg0_8:IsLimitTime() then
		return EducateHelper.InTime(arg0_8.curTime, arg0_8.startTime, arg0_8.endTime)
	else
		return true
	end
end

function var0_0.GetType(arg0_9)
	return arg0_9:getConfig("type")
end

function var0_0.IsEventType(arg0_10)
	return arg0_10:getConfig("type") == var0_0.TYPE_EVENT
end

function var0_0.IsReplace(arg0_11)
	return arg0_11:getConfig("replace") ~= 0
end

function var0_0.GetCost(arg0_12)
	return arg0_12:getConfig("cost")
end

function var0_0.GetLinkId(arg0_13)
	return arg0_13:getConfig("param")[1]
end

function var0_0.GetOriginalCnt(arg0_14)
	return arg0_14:IsCountLimit() and arg0_14:getConfig("count_limit")[1] or 999
end

function var0_0.GetRemainCnt(arg0_15)
	return arg0_15.remainCnt
end

function var0_0.GetCntText(arg0_16)
	if not arg0_16:IsCountLimit() then
		return ""
	end

	return string.format("(%d/%d)", arg0_16.remainCnt, arg0_16:getConfig("count_limit")[1])
end

function var0_0.CanTrigger(arg0_17)
	return arg0_17.remainCnt > 0
end

function var0_0.ReduceCnt(arg0_18)
	arg0_18.remainCnt = arg0_18.remainCnt - 1
end

function var0_0.IsShowPolaroid(arg0_19)
	if #arg0_19:getConfig("polarid_list") == 0 then
		return false
	end

	return underscore.any(arg0_19:getConfig("polarid_list"), function(arg0_20)
		return not getProxy(EducateProxy):IsExistPolaroidByGroup(arg0_20) and getProxy(EducateProxy):CanGetPolaroidByGroup(arg0_20)
	end)
end

function var0_0.GetResults(arg0_21)
	if EducateHelper.IsShowNature() then
		return arg0_21:getConfig("result_display")
	else
		return underscore.select(arg0_21:getConfig("result_display"), function(arg0_22)
			return arg0_22[1] ~= EducateConst.DROP_TYPE_ATTR or not getProxy(EducateProxy):GetCharData():IsPersonalityAttr(arg0_22[2])
		end)
	end
end

function var0_0.IsResetWeek(arg0_23, arg1_23)
	return table.contains(arg0_23.refreshWeeks, arg1_23)
end

function var0_0.OnWeekUpdate(arg0_24, arg1_24)
	arg0_24.curTime = arg1_24

	arg0_24:CheckCntReset()
end

function var0_0.CheckCntReset(arg0_25)
	if arg0_25:IsEventType() and arg0_25:IsCountLimit() then
		local var0_25 = EducateHelper.GetWeekIdxWithTime(arg0_25.curTime)

		if arg0_25:IsResetWeek(var0_25) then
			arg0_25.remainCnt = arg0_25:GetOriginalCnt()
		end
	end
end

return var0_0
