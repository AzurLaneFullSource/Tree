local var0 = class("MiniGameModifyDataCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.map
	local var3 = getProxy(MiniGameProxy):GetMiniGameData(var1)

	for iter0, iter1 in pairs(var2) do
		var3:SetRuntimeData(iter0, iter1)
	end

	arg0:sendNotification(GAME.MODIFY_MINI_GAME_DATA_DONE, {
		id = var1,
		map = var2
	})
end

return var0
