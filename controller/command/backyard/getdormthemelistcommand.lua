local var0 = class("GetDormThemeListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = 0
	local var2

	if var0 and type(var0) == "table" then
		var2 = var0.callback
	else
		var1 = var0 or 0
	end

	pg.ConnectionMgr.GetInstance():Send(19018, {
		id = var1
	}, 19019, function(arg0)
		local var0 = getProxy(DormProxy)

		if var1 == 0 then
			var0:initThemes(arg0.theme_list or {})
		else
			for iter0, iter1 in ipairs(arg0.theme_list) do
				var0:updateTheme(iter1)
			end
		end

		arg0:sendNotification(GAME.GET_DORMTHEME_DONE)

		if var2 then
			var2()
		end
	end)
end

return var0
