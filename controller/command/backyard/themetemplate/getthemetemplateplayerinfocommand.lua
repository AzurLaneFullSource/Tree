local var0 = class("GetThemeTemplatePlayerInfoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type
	local var2 = var0.templateId
	local var3 = var0.userId
	local var4 = var0.callback
	local var5 = getProxy(DormProxy)

	if var1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP or var1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		local function var6(arg0)
			local var0 = CourtYardThemeOwner.New(arg0.player)
			local var1 = var5:GetShopThemeTemplateById(var2)

			if var1 then
				var1:SetPlayerInfo(var0)
				var5:UpdateShopThemeTemplate(var1)
			end

			local var2 = var5:GetCollectionThemeTemplateById(var2)

			if var2 then
				var2:SetPlayerInfo(var0)
				var5:UpdateCollectionThemeTemplate(var2)
			end

			if var4 then
				var4(var0)
			end
		end

		pg.ConnectionMgr.GetInstance():Send(50113, {
			user_id = var3
		}, 50114, function(arg0)
			if arg0.result == 0 then
				var6(arg0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	elseif var1 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		local var7 = getProxy(PlayerProxy):getData()
		local var8 = var5:GetCustomThemeTemplateById(var2)

		if var8 then
			var8:SetPlayerInfo(var7)
			var5:UpdateCustomThemeTemplate(var8)
		end

		if var4 then
			var4(var7)
		end
	end
end

return var0
