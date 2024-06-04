local var0 = class("BackYardGetThemeTemplateDataCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.templateId
	local var2 = var0.callback

	pg.ConnectionMgr.GetInstance():Send(19113, {
		theme_id = var1
	}, 19114, function(arg0)
		if arg0.result == 0 then
			local var0 = arg0.theme
			local var1 = arg0.has_fav and 1 or 0
			local var2 = arg0.has_like and 1 or 0
			local var3 = BackYardThemeTemplate.New({
				is_fetch = true,
				id = var0.id,
				name = var0.name,
				furniture_put_list = var0.furniture_put_list,
				user_id = var0.user_id,
				pos = var0.pos,
				like_count = var0.like_count,
				fav_count = var0.fav_count,
				upload_time = var0.upload_time,
				is_collection = var1,
				is_like = var2,
				image_md5 = var0.image_md5,
				icon_image_md5 = var0.icon_image_md5
			})
			local var4 = getProxy(DormProxy)

			if var4:GetShopThemeTemplateById(var1) then
				var4:UpdateShopThemeTemplate(var3)
			end

			if var4:GetCollectionThemeTemplateById(var1) then
				var4:UpdateCollectionThemeTemplate(var3)
			end

			if var2 then
				var2(var3)
			end

			arg0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DATA_DONE, {
				template = var3
			})
		elseif arg0.result == 20 then
			local var5 = getProxy(DormProxy)

			if var5:GetShopThemeTemplateById(var1) then
				var5:DeleteShopThemeTemplate(var1)
			end

			if var5:GetCollectionThemeTemplateById(var1) then
				var5:DeleteCollectionThemeTemplate(var1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("Backyard_theme_template_be_delete_tip"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
