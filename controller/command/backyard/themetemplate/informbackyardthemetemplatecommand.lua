local var0_0 = class("InformBackYardThemeTemplateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.playerName

	if getProxy(PlayerProxy):getRawData().level < 20 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("inform_level_limit"))

		return
	end

	local var2_1 = var0_1.uid
	local var3_1 = var0_1.tid
	local var4_1 = 0

	for iter0_1, iter1_1 in ipairs(var0_1.content) do
		var4_1 = iter1_1 + var4_1
	end

	local var5_1 = getProxy(DormProxy)
	local var6_1 = var5_1:GetShopThemeTemplateById(var3_1) or var5_1:GetCollectionThemeTemplateById(var3_1)

	if not var6_1 or not var6_1.name then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(19129, {
		target_id = var2_1,
		target_name = var1_1,
		theme_id = var3_1,
		theme_name = var6_1.name,
		reason = var4_1
	}, 19130, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ChatProxy)

			table.insert(var0_2.informs, var2_1 .. var3_1)
			arg0_1:sendNotification(GAME.INFORM_THEME_TEMPLATE_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_sueecss"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
