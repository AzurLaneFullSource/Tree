local var0_0 = class("GetThemeTemplatePlayerInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.templateId
	local var3_1 = var0_1.userId
	local var4_1 = var0_1.callback
	local var5_1 = getProxy(DormProxy)

	if var1_1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP or var1_1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		local function var6_1(arg0_2)
			local var0_2 = CourtYardThemeOwner.New(arg0_2.player)
			local var1_2 = var5_1:GetShopThemeTemplateById(var2_1)

			if var1_2 then
				var1_2:SetPlayerInfo(var0_2)
				var5_1:UpdateShopThemeTemplate(var1_2)
			end

			local var2_2 = var5_1:GetCollectionThemeTemplateById(var2_1)

			if var2_2 then
				var2_2:SetPlayerInfo(var0_2)
				var5_1:UpdateCollectionThemeTemplate(var2_2)
			end

			if var4_1 then
				var4_1(var0_2)
			end
		end

		pg.ConnectionMgr.GetInstance():Send(50113, {
			user_id = var3_1
		}, 50114, function(arg0_3)
			if arg0_3.result == 0 then
				var6_1(arg0_3)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
			end
		end)
	elseif var1_1 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		local var7_1 = getProxy(PlayerProxy):getData()
		local var8_1 = var5_1:GetCustomThemeTemplateById(var2_1)

		if var8_1 then
			var8_1:SetPlayerInfo(var7_1)
			var5_1:UpdateCustomThemeTemplate(var8_1)
		end

		if var4_1 then
			var4_1(var7_1)
		end
	end
end

return var0_0
