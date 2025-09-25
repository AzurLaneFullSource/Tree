local var0_0 = class("IslandAccessOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1
	local var2_1 = {}
	local var3_1 = getProxy(IslandProxy):GetIsland():GetAccessAgency()

	if var0_1.op == IslandConst.ACCESS_OP_ADD_WHITELIST then
		var1_1 = IslandConst.ACCESS_OP_SET_WHITELIST
		var2_1 = arg0_1:AddWhiteList(var3_1, var0_1.list)
	elseif var0_1.op == IslandConst.ACCESS_OP_DEL_WHITELIST then
		var1_1 = IslandConst.ACCESS_OP_SET_WHITELIST
		var2_1 = arg0_1:RemoveWhiteList(var3_1, var0_1.list)
	elseif var0_1.op == IslandConst.ACCESS_OP_ADD_BLACKLIST then
		var1_1 = IslandConst.ACCESS_OP_KICKANDBLACKLIST
		var2_1 = arg0_1:AddBlackList(var3_1, var0_1.list)
	elseif var0_1.op == IslandConst.ACCESS_OP_DEL_BLACKLIST then
		var1_1 = IslandConst.ACCESS_OP_SET_BLACKLIST
		var2_1 = arg0_1:RemoveBlackList(var3_1, var0_1.list)
	else
		var1_1 = var0_1.op
		var2_1 = var0_1.list
	end

	assert(var1_1 and var2_1, "op or list is nil")

	local var4_1 = pg.island_set.whit_list_max_cnt.key_value_int

	if var1_1 == IslandConst.ACCESS_OP_SET_WHITELIST then
		if var4_1 < #var2_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_white_list_full"))

			return
		end
	elseif var1_1 == IslandConst.ACCESS_OP_SET_BLACKLIST then
		if var4_1 < #var2_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_black_list_full"))

			return
		end
	elseif var1_1 == IslandConst.ACCESS_OP_KICKANDBLACKLIST and var4_1 < #var2_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_black_list_full"))

		var1_1 = IslandConst.ACCESS_OP_KICK
	end

	seriesAsync({
		function(arg0_2)
			arg0_1:Send(var3_1, var1_1, var2_1, arg0_2)
		end,
		function(arg0_3)
			local var0_3, var1_3, var2_3 = arg0_1:CheckReSend(var3_1, var1_1, var2_1)

			if not var0_3 then
				arg0_3()

				return
			end

			arg0_1:Send(var3_1, var1_3, var2_3, arg0_3)
		end
	}, function()
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP_DONE, {
			op = var1_1,
			clientOp = var0_1.op
		})
	end)
end

function var0_0.CheckReSend(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = false
	local var1_5
	local var2_5 = {}

	if arg2_5 == IslandConst.ACCESS_OP_SET_WHITELIST then
		local var3_5 = arg1_5:GetBlackList()

		for iter0_5, iter1_5 in ipairs(var3_5) do
			if table.contains(arg3_5, iter1_5) then
				var0_5 = true
				var1_5 = IslandConst.ACCESS_OP_SET_BLACKLIST
			else
				table.insert(var2_5, iter1_5)
			end
		end
	elseif arg2_5 == IslandConst.ACCESS_OP_SET_BLACKLIST or arg2_5 == IslandConst.ACCESS_OP_KICKANDBLACKLIST then
		local var4_5 = arg1_5:GetWhiteList()

		for iter2_5, iter3_5 in ipairs(var4_5) do
			if table.contains(arg3_5, iter3_5) then
				var0_5 = true
				var1_5 = IslandConst.ACCESS_OP_SET_WHITELIST
			else
				table.insert(var2_5, iter3_5)
			end
		end
	end

	return var0_5, var1_5, var2_5
end

function var0_0.Send(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	pg.ConnectionMgr.GetInstance():Send(21302, {
		cmd = arg2_6,
		user_id_list = arg3_6
	}, 21303, function(arg0_7)
		if arg0_7.result == 0 then
			if arg2_6 == IslandConst.ACCESS_OP_SET_WHITELIST then
				arg1_6:SetWhiteList(arg3_6)
			elseif arg2_6 == IslandConst.ACCESS_OP_SET_BLACKLIST then
				arg1_6:SetBlackList(arg3_6)
			elseif arg2_6 == IslandConst.ACCESS_OP_KICK then
				-- block empty
			elseif arg2_6 == IslandConst.ACCESS_OP_KICKANDBLACKLIST then
				arg1_6:AddBlackList(arg3_6)
			end

			arg4_6()
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip6"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_7.result] .. arg0_7.ret)
		end
	end)
end

function var0_0.AddWhiteList(arg0_8, arg1_8, arg2_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg1_8:GetWhiteList()) do
		table.insert(var0_8, iter1_8)
	end

	for iter2_8, iter3_8 in ipairs(arg2_8) do
		if not table.contains(var0_8, iter3_8) then
			table.insert(var0_8, iter3_8)
		end
	end

	return var0_8
end

function var0_0.RemoveWhiteList(arg0_9, arg1_9, arg2_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg1_9:GetWhiteList()) do
		table.insert(var0_9, iter1_9)
	end

	for iter2_9 = #var0_9, 1, -1 do
		local var1_9 = var0_9[iter2_9]

		if table.contains(arg2_9, var1_9) then
			table.remove(var0_9, iter2_9)
		end
	end

	return var0_9
end

function var0_0.AddBlackList(arg0_10, arg1_10, arg2_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg1_10:GetBlackList()) do
		table.insert(var0_10, iter1_10)
	end

	for iter2_10, iter3_10 in ipairs(arg2_10) do
		if not table.contains(var0_10, iter3_10) then
			table.insert(var0_10, iter3_10)
		end
	end

	return var0_10
end

function var0_0.RemoveBlackList(arg0_11, arg1_11, arg2_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in ipairs(arg1_11:GetBlackList()) do
		table.insert(var0_11, iter1_11)
	end

	for iter2_11 = #var0_11, 1, -1 do
		local var1_11 = var0_11[iter2_11]

		if table.contains(arg2_11, var1_11) then
			table.remove(var0_11, iter2_11)
		end
	end

	return var0_11
end

return var0_0
