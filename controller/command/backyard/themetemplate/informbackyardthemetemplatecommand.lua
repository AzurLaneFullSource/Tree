local var0 = class("InformBackYardThemeTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.playerName

	if getProxy(PlayerProxy):getRawData().level < 20 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("inform_level_limit"))

		return
	end

	local var2 = var0.uid
	local var3 = var0.tid
	local var4 = 0

	for iter0, iter1 in ipairs(var0.content) do
		var4 = iter1 + var4
	end

	local var5 = getProxy(DormProxy)
	local var6 = var5:GetShopThemeTemplateById(var3) or var5:GetCollectionThemeTemplateById(var3)

	if not var6 or not var6.name then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(19129, {
		target_id = var2,
		target_name = var1,
		theme_id = var3,
		theme_name = var6.name,
		reason = var4
	}, 19130, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ChatProxy)

			table.insert(var0.informs, var2 .. var3)
			arg0:sendNotification(GAME.INFORM_THEME_TEMPLATE_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_sueecss"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
