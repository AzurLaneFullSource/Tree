local var0_0 = class("SetComanderPrefabFleetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.commanders
	local var3_1 = getProxy(CommanderProxy)
	local var4_1 = {}

	for iter0_1, iter1_1 in pairs(var2_1) do
		table.insert(var4_1, {
			id = iter1_1.id,
			pos = iter0_1
		})
	end

	if #var4_1 == 0 or _.all(var4_1, function(arg0_2)
		return arg0_2.id == 0
	end) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25022, {
		id = var1_1,
		commandersid = var4_1
	}, 25023, function(arg0_3)
		if arg0_3.result == 0 then
			local var0_3 = var3_1:getPrefabFleetById(var1_1)

			var0_3:updateCommanders(var2_1)
			var3_1:updatePrefabFleet(var0_3)
			arg0_1:sendNotification(GAME.SET_COMMANDER_PREFAB_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result])
		end
	end)
end

return var0_0
