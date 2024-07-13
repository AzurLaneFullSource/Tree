local var0_0 = class("GetCommanderHomeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(CommanderProxy)

	if var1_1:GetCommanderHome() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25026, {
		type = 0
	}, 25027, function(arg0_2)
		local var0_2 = CommanderHome.New(arg0_2)

		var1_1:AddCommanderHome(var0_2)

		for iter0_2, iter1_2 in ipairs(arg0_2.slots) do
			if iter1_2.commander_id ~= 0 and iter1_2.commander_level and iter1_2.commander_level ~= 0 and iter1_2.commander_exp then
				arg0_1:UpdateCommanderLevelAndExp(iter1_2.commander_id, iter1_2.commander_level, iter1_2.commander_exp)
			end
		end
	end)
end

function var0_0.UpdateCommanderLevelAndExp(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = getProxy(CommanderProxy)
	local var1_3 = var0_3:getCommanderById(arg1_3)

	if var1_3 then
		var1_3:UpdateLevelAndExp(arg2_3, arg3_3)
		var0_3:updateCommander(var1_3)
	end
end

return var0_0
