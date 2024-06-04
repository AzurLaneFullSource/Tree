local var0 = class("LinerActivity", import("model.vo.Activity"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.curFinishEvents = {}

	for iter0, iter1 in ipairs(arg1.date1_key_value_list or {}) do
		if not arg0.curFinishEvents[iter1.key] then
			arg0.curFinishEvents[iter1.key] = {}
		end

		table.insert(arg0.curFinishEvents[iter1.key], iter1.value)
	end

	arg0.timeGroupIds = arg0:getConfig("config_data")[1]
	arg0.roomGroupIds = arg0:getConfig("config_data")[2]
	arg0.eventGroupIds = arg0:getConfig("config_data")[3]
	arg0.times = {}
	arg0.timeMaxIdx = 1
	arg0.timeIdx2Day = {}

	local var0 = 1

	for iter2, iter3 in ipairs(arg0.timeGroupIds) do
		for iter4, iter5 in ipairs(pg.activity_liner_time_group[iter3].ids) do
			arg0.timeMaxIdx = var0
			arg0.times[var0] = LinerTime.New(iter5)
			arg0.timeIdx2Day[var0] = iter2
			var0 = var0 + 1
		end
	end

	if arg0.data2 == 0 then
		arg0.data2 = 1
	end
end

function var0.GetTimeGroupIds(arg0)
	return arg0.timeGroupIds
end

function var0.GetRoomGroupIds(arg0)
	return arg0.roomGroupIds
end

function var0.GetEventGroupIds(arg0)
	return arg0.eventGroupIds
end

function var0.UpdateRoomIdx(arg0, arg1)
	arg0.data2 = arg1 and 1 or arg0.data2 + 1
end

function var0.GetRoomIdx(arg0)
	return arg0.data2
end

function var0.UpdateTimeIdx(arg0)
	arg0.data1 = arg0.data1 + 1

	arg0:ClearCurEventInfo()
end

function var0.GetCurIdx(arg0)
	return math.min(arg0.data1, arg0.timeMaxIdx)
end

function var0.GetTimeMaxIdx(arg0)
	return arg0.timeMaxIdx
end

function var0.IsFinishAllTime(arg0)
	return arg0.data1 > arg0.timeMaxIdx
end

function var0.GetFinishTimeIds(arg0)
	local var0 = {}
	local var1 = arg0:GetCurIdx()

	for iter0 = 1, arg0.data1 - 1 do
		table.insert(var0, arg0.times[iter0].id)
	end

	return var0
end

function var0.GetDayByIdx(arg0, arg1)
	return arg0.timeIdx2Day[arg1]
end

function var0.GetTimeByIdx(arg0, arg1)
	return arg0.times[arg1]
end

function var0.GetCurTime(arg0)
	return arg0.times[arg0:GetCurIdx()]
end

function var0.CheckTimeFinish(arg0, arg1)
	local var0 = arg1 or arg0:GetCurTime()

	return switch(var0:GetType(), {
		[LinerTime.TYPE.TARGET] = function()
			return pg.NewStoryMgr.GetInstance():IsPlayed(var0:GetStory())
		end,
		[LinerTime.TYPE.EXPLORE] = function()
			return arg0:GetRemainExploreCnt() == 0
		end,
		[LinerTime.TYPE.EVENT] = function()
			local var0 = var0:GetParamInfo()

			if arg0:GetRoomIdx() ~= #var0 then
				return false
			else
				return arg0:CheckRoomFinish(arg1)
			end
		end,
		[LinerTime.TYPE.STORY] = function()
			return pg.NewStoryMgr.GetInstance():IsPlayed(var0:GetStory())
		end
	}, function()
		return false
	end)
end

function var0.CheckRoomFinish(arg0, arg1)
	local var0 = arg1 or arg0:GetCurTime()

	if var0:GetType() ~= LinerTime.TYPE.EVENT then
		return false
	end

	local var1 = var0:GetParamInfo()[arg0:GetRoomIdx()]

	if var1[2] == LinerTime.EVENT_SUB_TYPE.CLUE then
		local var2 = arg0:GetCurEventInfo()

		return underscore.all(var1[4], function(arg0)
			local var0 = var1[1]

			if not var2[var0] then
				return false
			end

			return table.contains(var2[var0], arg0)
		end)
	elseif var1[2] == LinerTime.EVENT_SUB_TYPE.STORY then
		return pg.NewStoryMgr.GetInstance():IsPlayed(var1[3])
	end

	return false
end

function var0.GetRemainExploreCnt(arg0)
	local var0 = 0

	for iter0 = 1, arg0:GetCurIdx() do
		var0 = var0 + arg0.times[iter0]:GetExploreCnt()
	end

	return var0 - #arg0:GetExploredRoomIds()
end

function var0.GetTimeId2ExploredIds(arg0)
	local var0 = {}
	local var1 = 1
	local var2 = arg0:GetExploredRoomIds()

	for iter0 = 1, arg0:GetCurIdx() do
		local var3 = arg0.times[iter0]

		if var3:GetType() == LinerTime.TYPE.EXPLORE then
			var0[var3.id] = {}

			local var4 = var3:GetExploreCnt()

			for iter1 = var1, math.min(var1 + var4 - 1, #var2) do
				table.insert(var0[var3.id], var2[iter1])
			end

			var1 = var1 + var4
		end
	end

	return var0
end

function var0.GetExploredRoomIds(arg0)
	return arg0.data4_list
end

function var0.AddExploredRoom(arg0, arg1)
	table.insert(arg0:GetExploredRoomIds(), arg1)
end

function var0.GetCurEventInfo(arg0)
	return arg0.curFinishEvents
end

function var0.ClearCurEventInfo(arg0)
	arg0.curFinishEvents = {}
end

function var0.AddEvent(arg0, arg1, arg2)
	if not arg0.curFinishEvents[arg1] then
		arg0.curFinishEvents[arg1] = {}
	end

	table.insert(arg0.curFinishEvents[arg1], arg2)
end

function var0.GetFinishEventIds(arg0)
	local var0 = {}

	for iter0 = 1, arg0:GetCurIdx() - 1 do
		local var1 = arg0.times[iter0]

		var0 = table.mergeArray(var0, var1:GetEventIds(), true)
	end

	for iter1, iter2 in pairs(arg0:GetCurEventInfo()) do
		var0 = table.mergeArray(var0, iter2, true)
	end

	return var0
end

function var0.AddTimeAwardFlag(arg0, arg1)
	arg0.data1_list[arg1] = 1
end

function var0.IsGotTimeAward(arg0, arg1)
	return arg0.data1_list[arg1] and arg0.data1_list[arg1] ~= 0
end

function var0.AddRoomAwardFlag(arg0, arg1)
	arg0.data2_list[arg1] = 1
end

function var0.IsGotRoomAward(arg0, arg1)
	return arg0.data2_list[arg1] and arg0.data2_list[arg1] ~= 0
end

function var0.AddEventAwardFlag(arg0, arg1, arg2)
	arg0.data3_list[arg1] = arg2
end

function var0.IsGotEventAward(arg0, arg1)
	return arg0.data3_list[arg1] and arg0.data3_list[arg1] ~= 0
end

function var0.GetEventAwardFlag(arg0, arg1)
	return arg0.data3_list[arg1]
end

function var0.GetAllExploreRoomIds(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.roomGroupIds) do
		var0 = table.mergeArray(var0, pg.activity_liner_room_group[iter1].ids, true)
	end

	return var0
end

function var0.GetBgmName(arg0)
	local var0 = arg0:getConfig("config_client").endingstory[1]

	if arg0:IsFinishAllTime() and pg.NewStoryMgr.GetInstance():IsPlayed(var0) then
		local var1 = os.date("*t", os.time()).hour
		local var2 = arg0:GetReallyTimeType(var1)

		return arg0:GetCurTime():GetBgm(var2)
	else
		return arg0:GetCurTime():GetBgm()
	end
end

function var0.GetReallyTimeType(arg0, arg1)
	local var0 = arg0:getConfig("config_client").endingtime

	for iter0, iter1 in ipairs(var0) do
		local var1 = iter1[1]

		if arg1 >= var1[1] and arg1 < var1[2] then
			return iter1[2]
		end
	end

	return LinerTime.BG_TYPE.DAY
end

return var0
