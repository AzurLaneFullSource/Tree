local var0_0 = class("IslandDelAgoraThemeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	print("del------------->", var0_1)
	getProxy(IslandProxy):GetIsland():GetAgoraAgency():DelTheme(var0_1)
	arg0_1:sendNotification(GAME.ISLAND_DEL_AGORA_THEME_DONE)
end

return var0_0
