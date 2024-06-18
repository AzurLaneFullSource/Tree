local var0_0 = class("MiniGameModifyDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.map
	local var3_1 = getProxy(MiniGameProxy):GetMiniGameData(var1_1)

	for iter0_1, iter1_1 in pairs(var2_1) do
		var3_1:SetRuntimeData(iter0_1, iter1_1)
	end

	arg0_1:sendNotification(GAME.MODIFY_MINI_GAME_DATA_DONE, {
		id = var1_1,
		map = var2_1
	})
end

return var0_0
