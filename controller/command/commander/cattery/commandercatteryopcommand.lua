local var0_0 = class("CommanderCatteryOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().op
	local var1_1 = getProxy(CommanderProxy):GetCommanderHome()

	pg.ConnectionMgr.GetInstance():Send(25028, {
		type = var0_1
	}, 25029, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.awards)
			local var1_2 = 0
			local var2_2 = 0
			local var3_2 = {}

			if var0_1 == 1 then
				var1_1:IncCleanValue()
			elseif var0_1 == 2 then
				var3_2 = arg0_1:AddCommanderExpByFeed()
			elseif var0_1 == 3 then
				-- block empty
			end

			local var4_2 = var1_1:GetCatteries()
			local var5_2 = {}

			for iter0_2, iter1_2 in pairs(var4_2) do
				if iter1_2:ExistOP(var0_1) and iter1_2:CommanderCanOP(var0_1) then
					local var6_2 = iter1_2:GetCommander()

					iter1_2:ClearOP(var0_1)
					var6_2:UpdateHomeOpTime(var0_1, arg0_2.op_time)
					getProxy(CommanderProxy):updateCommander(var6_2)
					table.insert(var5_2, iter1_2.id)
				end
			end

			local var7_2 = Clone(var1_1)

			var1_1:UpdateExpAndLevel(arg0_2.level, arg0_2.exp)

			if var1_1.level > var7_2.level then
				var2_2 = var7_2:GetNextLevelExp() - var7_2.exp + var1_1.exp
			else
				var2_2 = var1_1.exp - var7_2.exp
			end

			arg0_1:sendNotification(GAME.COMMANDER_CATTERY_OP_DONE, {
				awards = var0_2,
				cmd = var0_1,
				opCatteries = var5_2,
				commanderExps = var3_2,
				homeExp = var2_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.AddCommanderExpByFeed(arg0_3)
	local var0_3 = {}

	local function var1_3(arg0_4, arg1_4)
		local var0_4 = arg0_4:GetCommanderId()
		local var1_4 = getProxy(CommanderProxy)
		local var2_4 = var1_4:getCommanderById(var0_4)
		local var3_4 = var2_4:isMaxLevel()

		if var3_4 then
			arg1_4 = 0
		end

		var2_4:addExp(arg1_4)

		if not var3_4 and var2_4:isMaxLevel() then
			arg1_4 = arg1_4 - var2_4.exp
		end

		table.insert(var0_3, {
			id = arg0_4.id,
			value = arg1_4
		})
		var1_4:updateCommander(var2_4)
	end

	local var2_3 = getProxy(CommanderProxy):GetCommanderHome()
	local var3_3 = var2_3:GetCatteries()
	local var4_3 = var2_3:getConfig("feed_level")[2]

	for iter0_3, iter1_3 in pairs(var3_3) do
		if iter1_3:ExistCommander() and iter1_3:ExiseFeedOP() then
			var1_3(iter1_3, var4_3)
		end
	end

	return var0_3
end

return var0_0
