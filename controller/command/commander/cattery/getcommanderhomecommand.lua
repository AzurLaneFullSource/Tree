local var0 = class("GetCommanderHomeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(CommanderProxy)

	if var1:GetCommanderHome() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25026, {
		type = 0
	}, 25027, function(arg0)
		local var0 = CommanderHome.New(arg0)

		var1:AddCommanderHome(var0)

		for iter0, iter1 in ipairs(arg0.slots) do
			if iter1.commander_id ~= 0 and iter1.commander_level and iter1.commander_level ~= 0 and iter1.commander_exp then
				arg0:UpdateCommanderLevelAndExp(iter1.commander_id, iter1.commander_level, iter1.commander_exp)
			end
		end
	end)
end

function var0.UpdateCommanderLevelAndExp(arg0, arg1, arg2, arg3)
	local var0 = getProxy(CommanderProxy)
	local var1 = var0:getCommanderById(arg1)

	if var1 then
		var1:UpdateLevelAndExp(arg2, arg3)
		var0:updateCommander(var1)
	end
end

return var0
