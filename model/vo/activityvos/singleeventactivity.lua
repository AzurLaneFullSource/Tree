local var0 = class("SingleEventActivity", import("model.vo.Activity"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.eventData = {}

	for iter0, iter1 in ipairs(arg0:GetAllEventIds()) do
		local var0 = SingleEvent.New({
			id = iter1
		})

		if var0:IsMain() then
			arg0.eventData[iter1] = var0
		end
	end

	for iter2, iter3 in ipairs(arg0:GetDailyEventIds()) do
		local var1 = SingleEvent.New({
			id = iter3
		})

		if var1:IsDaily() then
			arg0.eventData[iter3] = var1
		end
	end
end

function var0.GetEventById(arg0, arg1)
	return arg0.eventData[arg1]
end

function var0.GetAllEventIds(arg0)
	return arg0:getConfig("config_data")
end

function var0.GetFinishMainIds(arg0)
	return arg0.data1_list
end

function var0.AddFinishMainId(arg0, arg1)
	if not table.contains(arg0:GetFinishMainIds(), arg1) then
		table.insert(arg0:GetFinishMainIds(), arg1)
	end
end

function var0.IsFinish(arg0, arg1)
	local var0 = arg0:GetEventById(arg1)

	if var0:IsMain() then
		return table.contains(arg0:GetFinishMainIds(), arg1)
	end

	if var0:IsDaily() then
		return table.contains(arg0:GetDailyEventIds(), arg1) and not table.contains(arg0:GetUnFinishDailyIds(), arg1)
	end

	return false
end

function var0.IsFinishAllMain(arg0)
	for iter0, iter1 in pairs(arg0.eventData) do
		if iter1:IsMain() and not arg0:IsFinish(iter1.id) then
			return false
		end
	end

	return true
end

function var0.CheckDailyEventRequest(arg0)
	return #arg0:GetDailyEventIds() == 0
end

function var0.SetDailyEventIds(arg0, arg1)
	for iter0, iter1 in pairs(arg0.eventData) do
		if iter1:IsDaily() then
			arg0.eventData[iter0] = nil
		end
	end

	arg0.data2_list = {}
	arg0.data3_list = {}

	for iter2, iter3 in ipairs(arg1) do
		table.insert(arg0.data2_list, iter3)
		table.insert(arg0.data3_list, iter3)

		local var0 = SingleEvent.New({
			id = iter3
		})

		if var0:IsDaily() then
			arg0.eventData[iter3] = var0
		end
	end
end

function var0.GetDailyEventIds(arg0)
	return arg0.data2_list
end

function var0.GetUnFinishDailyIds(arg0)
	return arg0.data3_list
end

function var0.RemoveFinishDailyId(arg0, arg1)
	if table.contains(arg0:GetUnFinishDailyIds(), arg1) then
		table.removebyvalue(arg0:GetUnFinishDailyIds(), arg1)
	end
end

function var0.CheckTrigger(arg0, arg1)
	if not arg0.eventData[arg1] then
		return false
	end

	if arg0:IsFinish(arg1) then
		return false
	end

	local var0 = arg0.eventData[arg1]:GetPreEventId()

	return var0 == 0 or arg0:IsFinish(var0)
end

function var0.AddFinishEvent(arg0, arg1)
	local var0 = arg0:GetEventById(arg1)

	if var0:IsMain() then
		arg0:AddFinishMainId(arg1)
	end

	if var0:IsDaily() then
		arg0:RemoveFinishDailyId(arg1)
	end
end

function var0.GetUnlockMapAreas(arg0)
	local var0 = {}

	underscore.each(arg0:GetFinishMainIds(), function(arg0)
		local var0 = pg.activity_single_event[arg0].map_options

		if var0 == "" then
			return
		end

		local var1 = tonumber(var0)

		if not table.contains(var0, var1) then
			table.insert(var0, var1)
		end
	end)

	return var0
end

function var0.GetLastShowConfig(arg0)
	local var0 = arg0:GetFinishMainIds()

	if #var0 == 0 then
		return {}
	end

	table.sort(var0)

	for iter0 = #var0 - 1, 1, -1 do
		local var1 = pg.activity_single_event[var0[iter0]].options

		if #var1 > 0 then
			return var1
		end
	end

	return pg.activity_single_event[var0[1]].options
end

function var0.GetShowConfig(arg0)
	local var0 = arg0:GetFinishMainIds()

	if #var0 == 0 then
		return {}
	end

	table.sort(var0)

	for iter0 = #var0, 1, -1 do
		local var1 = pg.activity_single_event[var0[iter0]].options

		if #var1 > 0 then
			return var1
		end
	end

	return pg.activity_single_event[var0[1]].options
end

function var0.IsShowMapAnim(arg0, arg1)
	if not arg0:GetEventById(arg1):IsMain() then
		return false
	end

	local var0 = arg0:GetFinishMainIds()
	local var1 = arg0:GetUnlockMapAreas()
	local var2 = {}
	local var3 = {}

	for iter0 = 1, #var0 - 1 do
		table.insert(var2, var0[iter0])
	end

	underscore.each(var2, function(arg0)
		local var0 = pg.activity_single_event[arg0].map_options

		if var0 == "" then
			return
		end

		local var1 = tonumber(var0)

		if not table.contains(var3, var1) then
			table.insert(var3, var1)
		end
	end)

	return #var1 ~= #var3
end

return var0
