local var0 = class("CommanderCatteryOPCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().op
	local var1 = getProxy(CommanderProxy):GetCommanderHome()

	pg.ConnectionMgr.GetInstance():Send(25028, {
		type = var0
	}, 25029, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.awards)
			local var1 = 0
			local var2 = 0
			local var3 = {}

			if var0 == 1 then
				var1:IncCleanValue()
			elseif var0 == 2 then
				var3 = arg0:AddCommanderExpByFeed()
			elseif var0 == 3 then
				-- block empty
			end

			local var4 = var1:GetCatteries()
			local var5 = {}

			for iter0, iter1 in pairs(var4) do
				if iter1:ExistOP(var0) and iter1:CommanderCanOP(var0) then
					local var6 = iter1:GetCommander()

					iter1:ClearOP(var0)
					var6:UpdateHomeOpTime(var0, arg0.op_time)
					getProxy(CommanderProxy):updateCommander(var6)
					table.insert(var5, iter1.id)
				end
			end

			local var7 = Clone(var1)

			var1:UpdateExpAndLevel(arg0.level, arg0.exp)

			if var1.level > var7.level then
				var2 = var7:GetNextLevelExp() - var7.exp + var1.exp
			else
				var2 = var1.exp - var7.exp
			end

			arg0:sendNotification(GAME.COMMANDER_CATTERY_OP_DONE, {
				awards = var0,
				cmd = var0,
				opCatteries = var5,
				commanderExps = var3,
				homeExp = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

function var0.AddCommanderExpByFeed(arg0)
	local var0 = {}

	local function var1(arg0, arg1)
		local var0 = arg0:GetCommanderId()
		local var1 = getProxy(CommanderProxy)
		local var2 = var1:getCommanderById(var0)
		local var3 = var2:isMaxLevel()

		if var3 then
			arg1 = 0
		end

		var2:addExp(arg1)

		if not var3 and var2:isMaxLevel() then
			arg1 = arg1 - var2.exp
		end

		table.insert(var0, {
			id = arg0.id,
			value = arg1
		})
		var1:updateCommander(var2)
	end

	local var2 = getProxy(CommanderProxy):GetCommanderHome()
	local var3 = var2:GetCatteries()
	local var4 = var2:getConfig("feed_level")[2]

	for iter0, iter1 in pairs(var3) do
		if iter1:ExistCommander() and iter1:ExiseFeedOP() then
			var1(iter1, var4)
		end
	end

	return var0
end

return var0
