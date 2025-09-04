local var0_0 = class("IslandTask", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.acceptTime = arg1_1.timestamp or 0

	arg0_1:InitEndTime()
	arg0_1:UpdateTargetData(arg1_1.process_list)
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_task
end

function var0_0.GetAcceptTime(arg0_3)
	return arg0_3.acceptTime
end

function var0_0.InitEndTime(arg0_4)
	local var0_4 = arg0_4:getConfig("unlock_condition")

	if var0_4 == "" or #var0_4 == 0 then
		arg0_4.endTime = 0
	end

	local var1_4 = underscore.detect(var0_4, function(arg0_5)
		return arg0_5[1] == IslandTaskConditionType.IN_TIME
	end)

	if not var1_4 then
		arg0_4.endTime = 0
	else
		arg0_4.endTime = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_4[2][2])
	end
end

function var0_0.SetEndTime(arg0_6, arg1_6)
	arg0_6.endTime = arg1_6
end

function var0_0.UpdateTargetData(arg0_7, arg1_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		var0_7[iter1_7.target_id] = iter1_7
	end

	arg0_7.targetList = {}

	for iter2_7, iter3_7 in ipairs(arg0_7:getConfig("target_id")) do
		table.insert(arg0_7.targetList, IslandTaskTarget.New(var0_7[iter3_7] or {
			target_id = iter3_7
		}))
	end
end

function var0_0.GetTargetList(arg0_8)
	return arg0_8.targetList
end

function var0_0.GetTargetById(arg0_9, arg1_9)
	return underscore.detect(arg0_9.targetList, function(arg0_10)
		return arg0_10.id == arg1_9
	end)
end

function var0_0.GetRecycleItemInfos(arg0_11)
	local var0_11 = {}

	underscore.each(arg0_11.targetList, function(arg0_12)
		if arg0_12:GetType() == IslandTaskTargetType.RECYCLE then
			table.insert(var0_11, Drop.New({
				type = DROP_TYPE_ISLAND_ITEM,
				id = arg0_12:GetTargetId(),
				count = arg0_12:GetTargetNum()
			}))
		end
	end)

	return var0_11
end

function var0_0.ExistTargetType(arg0_13, arg1_13)
	return underscore.any(arg0_13.targetList, function(arg0_14)
		return arg0_14:GetType() == arg1_13
	end)
end

function var0_0.GetTargetIdByTypeAndParam(arg0_15, arg1_15, arg2_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.targetList) do
		if iter1_15:CheckTypeAndTargetId(arg1_15, arg2_15) and not table.contains(var0_15, iter1_15.id) then
			table.insert(var0_15, iter1_15.id)
		end
	end

	return var0_15
end

function var0_0.GetRemainTimeStr(arg0_16)
	local var0_16 = arg0_16.endTime - pg.TimeMgr.GetInstance():GetServerTime()
	local var1_16 = math.floor(var0_16 / 86400)
	local var2_16 = math.floor(var0_16 % 86400 / 3600)

	return i18n("island_task_lefttime", var1_16, var2_16)
end

function var0_0.IsFinish(arg0_17)
	return underscore.all(arg0_17.targetList, function(arg0_18)
		return arg0_18:IsFinish()
	end)
end

function var0_0.IsSubmitOnUI(arg0_19)
	return arg0_19:getConfig("complete_type") == 3
end

function var0_0.GetSubmitObjectId(arg0_20)
	return arg0_20:getConfig("complete_data")
end

function var0_0.IsSubmitImmediately(arg0_21)
	return arg0_21:getConfig("complete_type") == 2 and arg0_21:GetSubmitObjectId() == 0
end

function var0_0.CheckSubmitOnApproach(arg0_22, arg1_22)
	return arg0_22:GetSubmitObjectId() == arg1_22 and arg0_22:getConfig("complete_type") == 2
end

function var0_0.GetFinishedDesc(arg0_23)
	return arg0_23:getConfig("complete_tips")
end

function var0_0.InTime(arg0_24)
	if arg0_24.endTime == 0 then
		return true
	end

	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_24.endTime
end

function var0_0.GetType(arg0_25)
	return arg0_25:getConfig("type")
end

function var0_0.GetShowType(arg0_26)
	return IslandTaskType.Type2ShowType[arg0_26:getConfig("type")]
end

function var0_0.GetName(arg0_27)
	return arg0_27:getConfig("name")
end

function var0_0.GetDesc(arg0_28)
	return arg0_28:getConfig("task_desc")
end

function var0_0.IsSeries(arg0_29)
	return arg0_29:getConfig("series") ~= ""
end

function var0_0.GetSeriesTitle(arg0_30)
	return arg0_30:getConfig("series") .. " " .. arg0_30:getConfig("series_name")
end

function var0_0.GetAddedStory(arg0_31)
	return arg0_31:getConfig("rec_perform")
end

function var0_0.GetSubmitStory(arg0_32)
	return arg0_32:getConfig("com_perform")
end

function var0_0.GetTraceId(arg0_33)
	return arg0_33:getConfig("navigation")
end

function var0_0.GetTraceParam(arg0_34)
	for iter0_34, iter1_34 in ipairs(arg0_34.targetList) do
		if not iter1_34:IsFinish() then
			return iter1_34:GetTrackParma(), iter0_34
		end
	end

	return arg0_34:GetSubmitObjectId() ~= 0 and arg0_34:GetSubmitObjectId() or ""
end

function var0_0.GetAwards(arg0_35)
	local var0_35 = underscore.map(arg0_35:getConfig("reward_show"), function(arg0_36)
		return Drop.Create(arg0_36)
	end)

	if arg0_35:GetExpAward() then
		table.insert(var0_35, arg0_35:GetExpAward())
	end

	return var0_35
end

function var0_0.GetExp(arg0_37)
	return arg0_37:getConfig("reward_exp")
end

function var0_0.GetExpAward(arg0_38)
	if arg0_38:GetExp() ~= 0 then
		return {
			id = 2,
			type = DROP_TYPE_ISLAND_ITEM,
			count = arg0_38:GetExp()
		}
	end

	return nil
end

function var0_0.GetAwardsStatic(arg0_39)
	return underscore.map(pg.island_task[arg0_39].reward_show, function(arg0_40)
		return Drop.Create(arg0_40)
	end)
end

function var0_0.GetSubmitPlayInfo(arg0_41)
	local var0_41 = pg.island_task[arg0_41].com_perform

	if var0_41 == "" or #var0_41 == 0 then
		return nil
	end

	return var0_41[1], var0_41[2]
end

return var0_0
