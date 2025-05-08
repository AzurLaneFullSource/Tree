local var0_0 = class("IslandTask", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id

	arg0_1:InitEndTime()
	arg0_1:UpdateTargetData(arg1_1.process_list)
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_task
end

function var0_0.InitEndTime(arg0_3)
	local var0_3 = arg0_3:getConfig("unlock_condition")

	if var0_3 == "" or #var0_3 == 0 then
		arg0_3.endTime = 0
	end

	local var1_3 = underscore.detect(var0_3, function(arg0_4)
		return arg0_4[1] == IslandFutureTask.CONDITION_TYPE.IN_TIME
	end)

	if not var1_3 then
		arg0_3.endTime = 0
	else
		arg0_3.endTime = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_3[2][2])
	end
end

function var0_0.SetEndTime(arg0_5, arg1_5)
	arg0_5.endTime = arg1_5
end

function var0_0.UpdateTargetData(arg0_6, arg1_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in ipairs(arg1_6) do
		var0_6[iter1_6.target_id] = iter1_6
	end

	arg0_6.targetList = {}

	for iter2_6, iter3_6 in ipairs(arg0_6:getConfig("target_id")) do
		table.insert(arg0_6.targetList, IslandTaskTarget.New(var0_6[iter3_6] or {
			target_id = iter3_6
		}))
	end
end

function var0_0.GetTargetList(arg0_7)
	return arg0_7.targetList
end

function var0_0.GetRecycleItemInfos(arg0_8)
	local var0_8 = {}

	underscore.each(arg0_8.targetList, function(arg0_9)
		if arg0_9:GetType() == IslandTaskTarget.RECYCLE then
			table.insert(var0_8, Drop.New({
				type = DROP_TYPE_ISLAND_ITEM,
				id = arg0_9:GetTargetId(),
				count = arg0_9:GetTargetNum()
			}))
		end
	end)

	return var0_8
end

function var0_0.ExistInteractionTarget(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.targetList) do
		if not iter1_10:IsFinish() and iter1_10:IsInteractionObject(arg1_10) then
			return true, iter1_10
		end
	end

	return false
end

function var0_0.ExistApproachTarget(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.targetList) do
		if not iter1_11:IsFinish() and iter1_11:IsApproachObject(arg1_11) then
			return true, iter1_11
		end
	end

	return false
end

function var0_0.GetRemainTimeStr(arg0_12)
	local var0_12 = arg0_12.endTime - pg.TimeMgr.GetInstance():GetServerTime()
	local var1_12 = math.floor(var0_12 / 86400)
	local var2_12 = math.floor(var0_12 % 86400 / 3600)

	return i18n1(var1_12 .. "天" .. var2_12 .. "小时")
end

function var0_0.IsFinish(arg0_13)
	return underscore.all(arg0_13.targetList, function(arg0_14)
		return arg0_14:IsFinish()
	end)
end

function var0_0.IsSubmitImmediately(arg0_15)
	return arg0_15:getConfig("complete_type") == 2 and arg0_15:getConfig("complete_data") == 0
end

function var0_0.GetFinishedDesc(arg0_16)
	return arg0_16:getConfig("complete_tips")
end

function var0_0.InTime(arg0_17)
	if arg0_17.endTime == 0 then
		return true
	end

	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_17.endTime
end

function var0_0.GetType(arg0_18)
	return arg0_18:getConfig("type")
end

function var0_0.GetShowType(arg0_19)
	return IslandTaskType.Type2ShowType[arg0_19:getConfig("type")]
end

function var0_0.GetName(arg0_20)
	return arg0_20:getConfig("name")
end

function var0_0.GetDesc(arg0_21)
	return arg0_21:getConfig("task_desc")
end

function var0_0.IsSeries(arg0_22)
	return arg0_22:getConfig("series") ~= ""
end

function var0_0.GetSeriesTitle(arg0_23)
	return arg0_23:getConfig("series") .. " " .. arg0_23:getConfig("series_name")
end

function var0_0.GetAddedStory(arg0_24)
	return arg0_24:getConfig("rec_perform")
end

function var0_0.GetSubmitStory(arg0_25)
	return arg0_25:getConfig("com_perform")
end

function var0_0.GetTraceId(arg0_26)
	return arg0_26:getConfig("navigation")
end

function var0_0.GetTraceParam(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.targetList) do
		if not iter1_27:IsFinish() then
			return iter1_27:GetTrackParma(), iter0_27
		end
	end

	return ""
end

function var0_0.GetAwards(arg0_28)
	return underscore.map(arg0_28:getConfig("reward"), function(arg0_29)
		return Drop.Create(arg0_29)
	end)
end

return var0_0
