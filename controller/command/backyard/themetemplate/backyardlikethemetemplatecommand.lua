local var0_0 = class("BackYardLikeThemeTemplateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.templateId
	local var2_1 = var0_1.uploadTime

	local function var3_1(arg0_2)
		local var0_2 = getProxy(DormProxy)
		local var1_2 = var0_2:GetCollectionThemeTemplateById(var1_1)

		if var1_2 then
			var1_2:AddLike()
			var0_2:UpdateCollectionThemeTemplate(var1_2)
		end

		local var2_2 = var0_2:GetShopThemeTemplateById(var1_1)

		if var2_2 then
			var2_2:AddLike()
			var0_2:UpdateShopThemeTemplate(var2_2)
		end

		arg0_1:sendNotification(GAME.BACKYARD_LIKE_THEME_TEMPLATE_DONE)
	end

	pg.ConnectionMgr.GetInstance():Send(19121, {
		theme_id = var1_1,
		upload_time = var2_1
	}, 19122, function(arg0_3)
		if arg0_3.result == 0 then
			var3_1(arg0_3)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

return var0_0
