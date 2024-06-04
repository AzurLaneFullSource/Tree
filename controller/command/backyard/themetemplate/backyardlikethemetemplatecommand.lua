local var0 = class("BackYardLikeThemeTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.templateId
	local var2 = var0.uploadTime

	local function var3(arg0)
		local var0 = getProxy(DormProxy)
		local var1 = var0:GetCollectionThemeTemplateById(var1)

		if var1 then
			var1:AddLike()
			var0:UpdateCollectionThemeTemplate(var1)
		end

		local var2 = var0:GetShopThemeTemplateById(var1)

		if var2 then
			var2:AddLike()
			var0:UpdateShopThemeTemplate(var2)
		end

		arg0:sendNotification(GAME.BACKYARD_LIKE_THEME_TEMPLATE_DONE)
	end

	pg.ConnectionMgr.GetInstance():Send(19121, {
		theme_id = var1,
		upload_time = var2
	}, 19122, function(arg0)
		if arg0.result == 0 then
			var3(arg0)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
