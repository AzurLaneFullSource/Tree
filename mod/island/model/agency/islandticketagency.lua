local var0_0 = class("IslandTicketAgency", import(".IslandBaseAgency"))

var0_0.REMIND_TIP_KEY = "IslandTicketAgency.REMIND_TIP_KEY"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.data = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.speed_tickets) do
		local var0_1 = iter1_1.key.speed_id
		local var1_1 = iter1_1.key.end_time
		local var2_1 = iter1_1.num

		if not arg0_1.data[var0_1] then
			arg0_1.data[var0_1] = {}
		end

		arg0_1.data[var0_1][var1_1] = IslandTicket.New(var0_1, var1_1, var2_1)
	end

	arg0_1.localTipKey = var0_0.REMIND_TIP_KEY .. "_" .. getProxy(PlayerProxy):getRawData().id
end

function var0_0.AddTicket(arg0_2, arg1_2, arg2_2, arg3_2)
	if not arg0_2.data[arg1_2] then
		arg0_2.data[arg1_2] = {}
	end

	if arg0_2.data[arg1_2][arg2_2] then
		arg0_2.data[arg1_2][arg2_2]:AddCount(arg3_2)
	else
		arg0_2.data[arg1_2][arg2_2] = IslandTicket.New(arg1_2, arg2_2, arg3_2)
	end
end

function var0_0.ReduceTicket(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3.data[arg1_3] then
		return
	end

	local var0_3 = arg0_3.data[arg1_3][arg2_3]

	if not var0_3 then
		return
	end

	if arg3_3 > var0_3:GetCount() then
		return
	end

	var0_3:ReduceCount(arg3_3)

	if var0_3:IsEmpty() then
		arg0_3:RemoveTicket(arg1_3, arg2_3)
	else
		arg0_3.data[arg1_3][arg2_3] = var0_3
	end
end

function var0_0.RemoveTicket(arg0_4, arg1_4, arg2_4)
	arg0_4.data[arg1_4][arg2_4] = nil
end

function var0_0.GetAllTicketList(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.data) do
		for iter2_5, iter3_5 in pairs(iter1_5) do
			table.insert(var0_5, iter3_5)
		end
	end

	return var0_5
end

function var0_0.GetTicketData(arg0_6)
	return arg0_6.data
end

function var0_0.GetTikcetListById(arg0_7, arg1_7)
	if not arg0_7.data[arg1_7] then
		return {}
	end

	return underscore.values(arg0_7.data[arg1_7])
end

function var0_0.GetExpiredTickets(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.data) do
		for iter2_8, iter3_8 in pairs(iter1_8) do
			if iter3_8:IsExpired() then
				table.insert(var0_8, iter3_8)
			end
		end
	end

	return var0_8
end

function var0_0.GetExpireRemindTickets(arg0_9)
	local var0_9 = {}

	if PlayerPrefs.GetInt(arg0_9.localTipKey .. "_" .. GetZeroTime()) == 1 then
		return var0_9
	end

	for iter0_9, iter1_9 in pairs(arg0_9.data) do
		for iter2_9, iter3_9 in pairs(iter1_9) do
			if iter3_9:WillExpire() then
				table.insert(var0_9, iter3_9)
			end
		end
	end

	return var0_9
end

function var0_0.SetRemindFlag(arg0_10)
	PlayerPrefs.SetInt(arg0_10.localTipKey .. "_" .. GetZeroTime(), 1)
	PlayerPrefs.Save()
end

return var0_0
