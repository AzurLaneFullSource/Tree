local var0_0 = class("LinerActivity", import("model.vo.Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.curFinishEvents = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.date1_key_value_list or {}) do
		if not arg0_1.curFinishEvents[iter1_1.key] then
			arg0_1.curFinishEvents[iter1_1.key] = {}
		end

		table.insert(arg0_1.curFinishEvents[iter1_1.key], iter1_1.value)
	end

	arg0_1.timeGroupIds = arg0_1:getConfig("config_data")[1]
	arg0_1.roomGroupIds = arg0_1:getConfig("config_data")[2]
	arg0_1.eventGroupIds = arg0_1:getConfig("config_data")[3]
	arg0_1.times = {}
	arg0_1.timeMaxIdx = 1
	arg0_1.timeIdx2Day = {}

	local var0_1 = 1

	for iter2_1, iter3_1 in ipairs(arg0_1.timeGroupIds) do
		for iter4_1, iter5_1 in ipairs(pg.activity_liner_time_group[iter3_1].ids) do
			arg0_1.timeMaxIdx = var0_1
			arg0_1.times[var0_1] = LinerTime.New(iter5_1)
			arg0_1.timeIdx2Day[var0_1] = iter2_1
			var0_1 = var0_1 + 1
		end
	end

	if arg0_1.data2 == 0 then
		arg0_1.data2 = 1
	end
end

function var0_0.GetTimeGroupIds(arg0_2)
	return arg0_2.timeGroupIds
end

function var0_0.GetRoomGroupIds(arg0_3)
	return arg0_3.roomGroupIds
end

function var0_0.GetEventGroupIds(arg0_4)
	return arg0_4.eventGroupIds
end

function var0_0.UpdateRoomIdx(arg0_5, arg1_5)
	arg0_5.data2 = arg1_5 and 1 or arg0_5.data2 + 1
end

function var0_0.GetRoomIdx(arg0_6)
	return arg0_6.data2
end

function var0_0.UpdateTimeIdx(arg0_7)
	arg0_7.data1 = arg0_7.data1 + 1

	arg0_7:ClearCurEventInfo()
end

function var0_0.GetCurIdx(arg0_8)
	return math.min(arg0_8.data1, arg0_8.timeMaxIdx)
end

function var0_0.GetTimeMaxIdx(arg0_9)
	return arg0_9.timeMaxIdx
end

function var0_0.IsFinishAllTime(arg0_10)
	return arg0_10.data1 > arg0_10.timeMaxIdx
end

function var0_0.GetFinishTimeIds(arg0_11)
	local var0_11 = {}
	local var1_11 = arg0_11:GetCurIdx()

	for iter0_11 = 1, arg0_11.data1 - 1 do
		table.insert(var0_11, arg0_11.times[iter0_11].id)
	end

	return var0_11
end

function var0_0.GetDayByIdx(arg0_12, arg1_12)
	return arg0_12.timeIdx2Day[arg1_12]
end

function var0_0.GetTimeByIdx(arg0_13, arg1_13)
	return arg0_13.times[arg1_13]
end

function var0_0.GetCurTime(arg0_14)
	return arg0_14.times[arg0_14:GetCurIdx()]
end

function var0_0.CheckTimeFinish(arg0_15, arg1_15)
	local var0_15 = arg1_15 or arg0_15:GetCurTime()

	return switch(var0_15:GetType(), {
		[LinerTime.TYPE.TARGET] = function()
			return pg.NewStoryMgr.GetInstance():IsPlayed(var0_15:GetStory())
		end,
		[LinerTime.TYPE.EXPLORE] = function()
			return arg0_15:GetRemainExploreCnt() == 0
		end,
		[LinerTime.TYPE.EVENT] = function()
			local var0_18 = var0_15:GetParamInfo()

			if arg0_15:GetRoomIdx() ~= #var0_18 then
				return false
			else
				return arg0_15:CheckRoomFinish(arg1_15)
			end
		end,
		[LinerTime.TYPE.STORY] = function()
			return pg.NewStoryMgr.GetInstance():IsPlayed(var0_15:GetStory())
		end
	}, function()
		return false
	end)
end

function var0_0.CheckRoomFinish(arg0_21, arg1_21)
	local var0_21 = arg1_21 or arg0_21:GetCurTime()

	if var0_21:GetType() ~= LinerTime.TYPE.EVENT then
		return false
	end

	local var1_21 = var0_21:GetParamInfo()[arg0_21:GetRoomIdx()]

	if var1_21[2] == LinerTime.EVENT_SUB_TYPE.CLUE then
		local var2_21 = arg0_21:GetCurEventInfo()

		return underscore.all(var1_21[4], function(arg0_22)
			local var0_22 = var1_21[1]

			if not var2_21[var0_22] then
				return false
			end

			return table.contains(var2_21[var0_22], arg0_22)
		end)
	elseif var1_21[2] == LinerTime.EVENT_SUB_TYPE.STORY then
		return pg.NewStoryMgr.GetInstance():IsPlayed(var1_21[3])
	end

	return false
end

function var0_0.GetRemainExploreCnt(arg0_23)
	local var0_23 = 0

	for iter0_23 = 1, arg0_23:GetCurIdx() do
		var0_23 = var0_23 + arg0_23.times[iter0_23]:GetExploreCnt()
	end

	return var0_23 - #arg0_23:GetExploredRoomIds()
end

function var0_0.GetTimeId2ExploredIds(arg0_24)
	local var0_24 = {}
	local var1_24 = 1
	local var2_24 = arg0_24:GetExploredRoomIds()

	for iter0_24 = 1, arg0_24:GetCurIdx() do
		local var3_24 = arg0_24.times[iter0_24]

		if var3_24:GetType() == LinerTime.TYPE.EXPLORE then
			var0_24[var3_24.id] = {}

			local var4_24 = var3_24:GetExploreCnt()

			for iter1_24 = var1_24, math.min(var1_24 + var4_24 - 1, #var2_24) do
				table.insert(var0_24[var3_24.id], var2_24[iter1_24])
			end

			var1_24 = var1_24 + var4_24
		end
	end

	return var0_24
end

function var0_0.GetExploredRoomIds(arg0_25)
	return arg0_25.data4_list
end

function var0_0.AddExploredRoom(arg0_26, arg1_26)
	table.insert(arg0_26:GetExploredRoomIds(), arg1_26)
end

function var0_0.GetCurEventInfo(arg0_27)
	return arg0_27.curFinishEvents
end

function var0_0.ClearCurEventInfo(arg0_28)
	arg0_28.curFinishEvents = {}
end

function var0_0.AddEvent(arg0_29, arg1_29, arg2_29)
	if not arg0_29.curFinishEvents[arg1_29] then
		arg0_29.curFinishEvents[arg1_29] = {}
	end

	table.insert(arg0_29.curFinishEvents[arg1_29], arg2_29)
end

function var0_0.GetFinishEventIds(arg0_30)
	local var0_30 = {}

	for iter0_30 = 1, arg0_30:GetCurIdx() - 1 do
		local var1_30 = arg0_30.times[iter0_30]

		var0_30 = table.mergeArray(var0_30, var1_30:GetEventIds(), true)
	end

	for iter1_30, iter2_30 in pairs(arg0_30:GetCurEventInfo()) do
		var0_30 = table.mergeArray(var0_30, iter2_30, true)
	end

	return var0_30
end

function var0_0.AddTimeAwardFlag(arg0_31, arg1_31)
	arg0_31.data1_list[arg1_31] = 1
end

function var0_0.IsGotTimeAward(arg0_32, arg1_32)
	return arg0_32.data1_list[arg1_32] and arg0_32.data1_list[arg1_32] ~= 0
end

function var0_0.AddRoomAwardFlag(arg0_33, arg1_33)
	arg0_33.data2_list[arg1_33] = 1
end

function var0_0.IsGotRoomAward(arg0_34, arg1_34)
	return arg0_34.data2_list[arg1_34] and arg0_34.data2_list[arg1_34] ~= 0
end

function var0_0.AddEventAwardFlag(arg0_35, arg1_35, arg2_35)
	arg0_35.data3_list[arg1_35] = arg2_35
end

function var0_0.IsGotEventAward(arg0_36, arg1_36)
	return arg0_36.data3_list[arg1_36] and arg0_36.data3_list[arg1_36] ~= 0
end

function var0_0.GetEventAwardFlag(arg0_37, arg1_37)
	return arg0_37.data3_list[arg1_37]
end

function var0_0.GetAllExploreRoomIds(arg0_38)
	local var0_38 = {}

	for iter0_38, iter1_38 in ipairs(arg0_38.roomGroupIds) do
		var0_38 = table.mergeArray(var0_38, pg.activity_liner_room_group[iter1_38].ids, true)
	end

	return var0_38
end

function var0_0.GetBgmName(arg0_39)
	local var0_39 = arg0_39:getConfig("config_client").endingstory[1]

	if arg0_39:IsFinishAllTime() and pg.NewStoryMgr.GetInstance():IsPlayed(var0_39) then
		local var1_39 = os.date("*t", os.time()).hour
		local var2_39 = arg0_39:GetReallyTimeType(var1_39)

		return arg0_39:GetCurTime():GetBgm(var2_39)
	else
		return arg0_39:GetCurTime():GetBgm()
	end
end

function var0_0.GetReallyTimeType(arg0_40, arg1_40)
	local var0_40 = arg0_40:getConfig("config_client").endingtime

	for iter0_40, iter1_40 in ipairs(var0_40) do
		local var1_40 = iter1_40[1]

		if arg1_40 >= var1_40[1] and arg1_40 < var1_40[2] then
			return iter1_40[2]
		end
	end

	return LinerTime.BG_TYPE.DAY
end

return var0_0
