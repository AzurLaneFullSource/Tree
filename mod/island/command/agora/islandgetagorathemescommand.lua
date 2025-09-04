local var0_0 = class("IslandGetAgoraThemesCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback
	local var1_1 = getProxy(IslandProxy):GetIsland()

	if var1_1:GetAgoraAgency():IsUpdateThemes() then
		if var0_1 then
			var0_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21321, {
		id = var1_1.id
	}, 21322, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.theme_list) do
			table.insert(var0_2, IslandTheme.New(iter1_2))
		end

		var1_1:GetAgoraAgency():SetThemes(var0_2)

		if var0_1 then
			var0_1()
		end

		arg0_1:sendNotification(GAME.ISLAND_GET_AGORA_THEME_DONE)
	end)
end

return var0_0
