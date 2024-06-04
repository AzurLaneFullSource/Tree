local var0 = class("SetComanderPrefabFleetCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.commanders
	local var3 = getProxy(CommanderProxy)
	local var4 = {}

	for iter0, iter1 in pairs(var2) do
		table.insert(var4, {
			id = iter1.id,
			pos = iter0
		})
	end

	if #var4 == 0 or _.all(var4, function(arg0)
		return arg0.id == 0
	end) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25022, {
		id = var1,
		commandersid = var4
	}, 25023, function(arg0)
		if arg0.result == 0 then
			local var0 = var3:getPrefabFleetById(var1)

			var0:updateCommanders(var2)
			var3:updatePrefabFleet(var0)
			arg0:sendNotification(GAME.SET_COMMANDER_PREFAB_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result])
		end
	end)
end

return var0
