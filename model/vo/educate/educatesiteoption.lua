local var0 = class("EducateSiteOption", import("model.vo.BaseVO"))

var0.TYPE_SHOP = 1
var0.TYPE_EVENT = 2
var0.TYPE_SITE = 3

function var0.Ctor(arg0, arg1, arg2)
	arg0.id = arg1
	arg0.configId = arg0.id
	arg0.usedCnt = arg2 or 0
	arg0.remainCnt = arg0:GetOriginalCnt() - arg0.usedCnt
	arg0.curTime = getProxy(EducateProxy):GetCurTime()

	arg0:initTime()
	arg0:initRefreshTime()
end

function var0.bindConfigTable(arg0)
	return pg.child_site_option
end

function var0.initTime(arg0)
	if arg0:IsLimitTime() then
		local var0 = arg0:getConfig("time_limit")

		arg0.startTime, arg0.endTime = EducateHelper.CfgTime2Time(var0)
	end
end

function var0.initRefreshTime(arg0)
	if arg0:IsEventType() and arg0:IsCountLimit() then
		arg0.refreshWeeks = {}

		local var0 = 9
		local var1 = 60
		local var2 = arg0:getConfig("count_limit")[2]

		table.insert(arg0.refreshWeeks, var0)

		while var0 < var1 do
			var0 = var0 + var2

			table.insert(arg0.refreshWeeks, var0)
		end
	end
end

function var0.IsShowLimit(arg0)
	return arg0:getConfig("is_limit") == 1 and arg0.remainCnt > 0
end

function var0.IsLimitTime(arg0)
	return #arg0:getConfig("time_limit") ~= 0
end

function var0.IsCountLimit(arg0)
	return arg0:getConfig("count_limit") ~= "" and #arg0:getConfig("count_limit") == 2
end

function var0.IsShow(arg0)
	if arg0:IsLimitTime() then
		return EducateHelper.InTime(arg0.curTime, arg0.startTime, arg0.endTime)
	else
		return true
	end
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.IsEventType(arg0)
	return arg0:getConfig("type") == var0.TYPE_EVENT
end

function var0.IsReplace(arg0)
	return arg0:getConfig("replace") ~= 0
end

function var0.GetCost(arg0)
	return arg0:getConfig("cost")
end

function var0.GetLinkId(arg0)
	return arg0:getConfig("param")[1]
end

function var0.GetOriginalCnt(arg0)
	return arg0:IsCountLimit() and arg0:getConfig("count_limit")[1] or 999
end

function var0.GetRemainCnt(arg0)
	return arg0.remainCnt
end

function var0.GetCntText(arg0)
	if not arg0:IsCountLimit() then
		return ""
	end

	return string.format("(%d/%d)", arg0.remainCnt, arg0:getConfig("count_limit")[1])
end

function var0.CanTrigger(arg0)
	return arg0.remainCnt > 0
end

function var0.ReduceCnt(arg0)
	arg0.remainCnt = arg0.remainCnt - 1
end

function var0.IsShowPolaroid(arg0)
	if #arg0:getConfig("polarid_list") == 0 then
		return false
	end

	return underscore.any(arg0:getConfig("polarid_list"), function(arg0)
		return not getProxy(EducateProxy):IsExistPolaroidByGroup(arg0) and getProxy(EducateProxy):CanGetPolaroidByGroup(arg0)
	end)
end

function var0.GetResults(arg0)
	if EducateHelper.IsShowNature() then
		return arg0:getConfig("result_display")
	else
		return underscore.select(arg0:getConfig("result_display"), function(arg0)
			return arg0[1] ~= EducateConst.DROP_TYPE_ATTR or not getProxy(EducateProxy):GetCharData():IsPersonalityAttr(arg0[2])
		end)
	end
end

function var0.IsResetWeek(arg0, arg1)
	return table.contains(arg0.refreshWeeks, arg1)
end

function var0.OnWeekUpdate(arg0, arg1)
	arg0.curTime = arg1

	arg0:CheckCntReset()
end

function var0.CheckCntReset(arg0)
	if arg0:IsEventType() and arg0:IsCountLimit() then
		local var0 = EducateHelper.GetWeekIdxWithTime(arg0.curTime)

		if arg0:IsResetWeek(var0) then
			arg0.remainCnt = arg0:GetOriginalCnt()
		end
	end
end

return var0
