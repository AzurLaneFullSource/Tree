local var0_0 = class("GetDormThemeListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = 0
	local var2_1

	if var0_1 and type(var0_1) == "table" then
		var2_1 = var0_1.callback
	else
		var1_1 = var0_1 or 0
	end

	pg.ConnectionMgr.GetInstance():Send(19018, {
		id = var1_1
	}, 19019, function(arg0_2)
		local var0_2 = getProxy(DormProxy)

		if var1_1 == 0 then
			var0_2:initThemes(arg0_2.theme_list or {})
		else
			for iter0_2, iter1_2 in ipairs(arg0_2.theme_list) do
				var0_2:updateTheme(iter1_2)
			end
		end

		arg0_1:sendNotification(GAME.GET_DORMTHEME_DONE)

		if var2_1 then
			var2_1()
		end
	end)
end

return var0_0
