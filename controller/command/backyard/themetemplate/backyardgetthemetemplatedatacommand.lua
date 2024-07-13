local var0_0 = class("BackYardGetThemeTemplateDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.templateId
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(19113, {
		theme_id = var1_1
	}, 19114, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = arg0_2.theme
			local var1_2 = arg0_2.has_fav and 1 or 0
			local var2_2 = arg0_2.has_like and 1 or 0
			local var3_2 = BackYardThemeTemplate.New({
				is_fetch = true,
				id = var0_2.id,
				name = var0_2.name,
				furniture_put_list = var0_2.furniture_put_list,
				user_id = var0_2.user_id,
				pos = var0_2.pos,
				like_count = var0_2.like_count,
				fav_count = var0_2.fav_count,
				upload_time = var0_2.upload_time,
				is_collection = var1_2,
				is_like = var2_2,
				image_md5 = var0_2.image_md5,
				icon_image_md5 = var0_2.icon_image_md5
			})
			local var4_2 = getProxy(DormProxy)

			if var4_2:GetShopThemeTemplateById(var1_1) then
				var4_2:UpdateShopThemeTemplate(var3_2)
			end

			if var4_2:GetCollectionThemeTemplateById(var1_1) then
				var4_2:UpdateCollectionThemeTemplate(var3_2)
			end

			if var2_1 then
				var2_1(var3_2)
			end

			arg0_1:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DATA_DONE, {
				template = var3_2
			})
		elseif arg0_2.result == 20 then
			local var5_2 = getProxy(DormProxy)

			if var5_2:GetShopThemeTemplateById(var1_1) then
				var5_2:DeleteShopThemeTemplate(var1_1)
			end

			if var5_2:GetCollectionThemeTemplateById(var1_1) then
				var5_2:DeleteCollectionThemeTemplate(var1_1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("Backyard_theme_template_be_delete_tip"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
