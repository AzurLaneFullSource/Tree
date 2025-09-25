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
	local var0_4 = arg0_4:getConfig("unlock_time")

	if var0_4 == "always" then
		arg0_4.endTime = 0
	else
		arg0_4.endTime = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_4[2])
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

function var0_0.GetTargetById(arg0_8, arg1_8)
	return underscore.detect(arg0_8.targetList, function(arg0_9)
		return arg0_9.id == arg1_8
	end)
end

function var0_0.GetRecycleItemInfos(arg0_10)
	local var0_10 = {}

	underscore.each(arg0_10.targetList, function(arg0_11)
		if arg0_11:GetType() == IslandTaskTargetType.RECYCLE then
			table.insert(var0_10, Drop.New({
				type = DROP_TYPE_ISLAND_ITEM,
				id = arg0_11:GetTargetId(),
				count = arg0_11:GetTargetNum()
			}))
		end
	end)

	return var0_10
end

function var0_0.ExistTargetType(arg0_12, arg1_12)
	return underscore.any(arg0_12.targetList, function(arg0_13)
		return arg0_13:GetType() == arg1_12
	end)
end

function var0_0.GetTargetIdByTypeAndParam(arg0_14, arg1_14, arg2_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14.targetList) do
		if iter1_14:CheckTypeAndTargetId(arg1_14, arg2_14) and not table.contains(var0_14, iter1_14.id) then
			table.insert(var0_14, iter1_14.id)
		end
	end

	return var0_14
end

function var0_0.GetRemainTimeStr(arg0_15)
	local var0_15 = arg0_15.endTime - pg.TimeMgr.GetInstance():GetServerTime()
	local var1_15 = math.floor(var0_15 / 86400)
	local var2_15 = math.floor(var0_15 % 86400 / 3600)

	return i18n("island_task_lefttime", var1_15, var2_15)
end

function var0_0.IsFinish(arg0_16)
	return underscore.all(arg0_16.targetList, function(arg0_17)
		return arg0_17:IsFinish()
	end)
end

function var0_0.IsSubmitOnUI(arg0_18)
	return arg0_18:getConfig("complete_type") == 3
end

function var0_0.GetSubmitObjectId(arg0_19)
	return arg0_19:getConfig("complete_data")
end

function var0_0.IsSubmitImmediately(arg0_20)
	return arg0_20:getConfig("complete_type") == 2 and arg0_20:GetSubmitObjectId() == 0
end

function var0_0.CheckSubmitOnApproach(arg0_21, arg1_21)
	return arg0_21:GetSubmitObjectId() == arg1_21 and arg0_21:getConfig("complete_type") == 2
end

function var0_0.GetFinishedDesc(arg0_22)
	return arg0_22:getConfig("complete_tips")
end

function var0_0.InTime(arg0_23)
	if arg0_23.endTime == 0 then
		return true
	end

	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_23.endTime
end

function var0_0.GetType(arg0_24)
	return arg0_24:getConfig("type")
end

function var0_0.GetShowType(arg0_25)
	return IslandTaskType.Type2ShowType[arg0_25:getConfig("type")]
end

function var0_0.GetName(arg0_26)
	return arg0_26:getConfig("name")
end

function var0_0.GetDesc(arg0_27)
	return arg0_27:getConfig("task_desc")
end

function var0_0.IsSeries(arg0_28)
	return arg0_28:getConfig("series") ~= ""
end

function var0_0.GetSeriesTitle(arg0_29)
	return arg0_29:getConfig("series") .. " " .. arg0_29:getConfig("series_name")
end

function var0_0.GetAddedStory(arg0_30)
	return arg0_30:getConfig("rec_perform")
end

function var0_0.GetSubmitStory(arg0_31)
	return arg0_31:getConfig("com_perform")
end

function var0_0.GetTraceParam(arg0_32)
	for iter0_32, iter1_32 in ipairs(arg0_32.targetList) do
		if not iter1_32:IsFinish() then
			return iter1_32:GetTrackParma(), iter0_32
		end
	end

	return arg0_32:GetSubmitObjectId() ~= 0 and arg0_32:GetSubmitObjectId() or ""
end

function var0_0.GetAwards(arg0_33)
	local var0_33 = arg0_33:getConfig("reward_show")
	local var1_33 = {}

	if type(var0_33) == "table" then
		var1_33 = underscore.map(var0_33, function(arg0_34)
			return Drop.Create(arg0_34)
		end)
	end

	if arg0_33:GetExpAward() then
		table.insert(var1_33, arg0_33:GetExpAward())
	end

	return var1_33
end

function var0_0.GetExp(arg0_35)
	return arg0_35:getConfig("reward_exp")
end

function var0_0.GetExpAward(arg0_36)
	if arg0_36:GetExp() ~= 0 then
		return {
			id = 2,
			type = DROP_TYPE_ISLAND_ITEM,
			count = arg0_36:GetExp()
		}
	end

	return nil
end

function var0_0.GetAwardsStatic(arg0_37)
	local var0_37 = pg.island_task[arg0_37].reward_show
	local var1_37 = pg.island_task[arg0_37].reward_exp
	local var2_37 = {}

	if type(var0_37) == "table" then
		var2_37 = underscore.map(pg.island_task[arg0_37].reward_show, function(arg0_38)
			return Drop.Create(arg0_38)
		end)
	end

	if var1_37 ~= 0 then
		table.insert(var2_37, {
			id = 2,
			type = DROP_TYPE_ISLAND_ITEM,
			count = var1_37
		})
	end

	return var2_37
end

function var0_0.GetSubmitPlayInfo(arg0_39)
	local var0_39 = pg.island_task[arg0_39].com_perform

	if var0_39 == "" or #var0_39 == 0 then
		return nil
	end

	return var0_39[1], var0_39[2]
end

return var0_0
