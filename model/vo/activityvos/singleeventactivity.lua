local var0_0 = class("SingleEventActivity", import("model.vo.Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.eventData = {}

	for iter0_1, iter1_1 in ipairs(arg0_1:GetAllEventIds()) do
		local var0_1 = SingleEvent.New({
			id = iter1_1
		})

		if var0_1:IsMain() then
			arg0_1.eventData[iter1_1] = var0_1
		end
	end

	for iter2_1, iter3_1 in ipairs(arg0_1:GetDailyEventIds()) do
		local var1_1 = SingleEvent.New({
			id = iter3_1
		})

		if var1_1:IsDaily() then
			arg0_1.eventData[iter3_1] = var1_1
		end
	end
end

function var0_0.GetEventById(arg0_2, arg1_2)
	return arg0_2.eventData[arg1_2]
end

function var0_0.GetAllEventIds(arg0_3)
	return arg0_3:getConfig("config_data")
end

function var0_0.GetFinishMainIds(arg0_4)
	return arg0_4.data1_list
end

function var0_0.AddFinishMainId(arg0_5, arg1_5)
	if not table.contains(arg0_5:GetFinishMainIds(), arg1_5) then
		table.insert(arg0_5:GetFinishMainIds(), arg1_5)
	end
end

function var0_0.IsFinish(arg0_6, arg1_6)
	local var0_6 = arg0_6:GetEventById(arg1_6)

	if var0_6:IsMain() then
		return table.contains(arg0_6:GetFinishMainIds(), arg1_6)
	end

	if var0_6:IsDaily() then
		return table.contains(arg0_6:GetDailyEventIds(), arg1_6) and not table.contains(arg0_6:GetUnFinishDailyIds(), arg1_6)
	end

	return false
end

function var0_0.IsFinishAllMain(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.eventData) do
		if iter1_7:IsMain() and not arg0_7:IsFinish(iter1_7.id) then
			return false
		end
	end

	return true
end

function var0_0.CheckDailyEventRequest(arg0_8)
	return #arg0_8:GetDailyEventIds() == 0
end

function var0_0.SetDailyEventIds(arg0_9, arg1_9)
	for iter0_9, iter1_9 in pairs(arg0_9.eventData) do
		if iter1_9:IsDaily() then
			arg0_9.eventData[iter0_9] = nil
		end
	end

	arg0_9.data2_list = {}
	arg0_9.data3_list = {}

	for iter2_9, iter3_9 in ipairs(arg1_9) do
		table.insert(arg0_9.data2_list, iter3_9)
		table.insert(arg0_9.data3_list, iter3_9)

		local var0_9 = SingleEvent.New({
			id = iter3_9
		})

		if var0_9:IsDaily() then
			arg0_9.eventData[iter3_9] = var0_9
		end
	end
end

function var0_0.GetDailyEventIds(arg0_10)
	return arg0_10.data2_list
end

function var0_0.GetUnFinishDailyIds(arg0_11)
	return arg0_11.data3_list
end

function var0_0.RemoveFinishDailyId(arg0_12, arg1_12)
	if table.contains(arg0_12:GetUnFinishDailyIds(), arg1_12) then
		table.removebyvalue(arg0_12:GetUnFinishDailyIds(), arg1_12)
	end
end

function var0_0.CheckTrigger(arg0_13, arg1_13)
	if not arg0_13.eventData[arg1_13] then
		return false
	end

	if arg0_13:IsFinish(arg1_13) then
		return false
	end

	local var0_13 = arg0_13.eventData[arg1_13]:GetPreEventId()

	return var0_13 == 0 or arg0_13:IsFinish(var0_13)
end

function var0_0.AddFinishEvent(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetEventById(arg1_14)

	if var0_14:IsMain() then
		arg0_14:AddFinishMainId(arg1_14)
	end

	if var0_14:IsDaily() then
		arg0_14:RemoveFinishDailyId(arg1_14)
	end
end

function var0_0.GetUnlockMapAreas(arg0_15)
	local var0_15 = {}

	underscore.each(arg0_15:GetFinishMainIds(), function(arg0_16)
		local var0_16 = pg.activity_single_event[arg0_16].map_options

		if var0_16 == "" then
			return
		end

		local var1_16 = tonumber(var0_16)

		if not table.contains(var0_15, var1_16) then
			table.insert(var0_15, var1_16)
		end
	end)

	return var0_15
end

function var0_0.GetLastShowConfig(arg0_17)
	local var0_17 = arg0_17:GetFinishMainIds()

	if #var0_17 == 0 then
		return {}
	end

	table.sort(var0_17)

	for iter0_17 = #var0_17 - 1, 1, -1 do
		local var1_17 = pg.activity_single_event[var0_17[iter0_17]].options

		if #var1_17 > 0 then
			return var1_17
		end
	end

	return pg.activity_single_event[var0_17[1]].options
end

function var0_0.GetShowConfig(arg0_18)
	local var0_18 = arg0_18:GetFinishMainIds()

	if #var0_18 == 0 then
		return {}
	end

	table.sort(var0_18)

	for iter0_18 = #var0_18, 1, -1 do
		local var1_18 = pg.activity_single_event[var0_18[iter0_18]].options

		if #var1_18 > 0 then
			return var1_18
		end
	end

	return pg.activity_single_event[var0_18[1]].options
end

function var0_0.IsShowMapAnim(arg0_19, arg1_19)
	if not arg0_19:GetEventById(arg1_19):IsMain() then
		return false
	end

	local var0_19 = arg0_19:GetFinishMainIds()
	local var1_19 = arg0_19:GetUnlockMapAreas()
	local var2_19 = {}
	local var3_19 = {}

	for iter0_19 = 1, #var0_19 - 1 do
		table.insert(var2_19, var0_19[iter0_19])
	end

	underscore.each(var2_19, function(arg0_20)
		local var0_20 = pg.activity_single_event[arg0_20].map_options

		if var0_20 == "" then
			return
		end

		local var1_20 = tonumber(var0_20)

		if not table.contains(var3_19, var1_20) then
			table.insert(var3_19, var1_20)
		end
	end)

	return #var1_19 ~= #var3_19
end

return var0_0
