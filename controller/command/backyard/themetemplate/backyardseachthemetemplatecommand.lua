local var0_0 = class("BackYardSeachThemeTemplateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().str

	if not var0_1 or var0_1 == "" then
		arg0_1:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE_ERRO)

		return
	end

	local function var1_1(arg0_2)
		local var0_2 = arg0_2.theme
		local var1_2 = arg0_2.has_fav and 1 or 0
		local var2_2 = arg0_2.has_like and 1 or 0
		local var3_2 = BackYardThemeTemplate.New({
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

		arg0_1:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE_DONE, {
			template = var3_2
		})
	end

	local function var2_1(arg0_3)
		arg0_1:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE_ERRO)
	end

	pg.ConnectionMgr.GetInstance():Send(19113, {
		theme_id = var0_1
	}, 19114, function(arg0_4)
		if arg0_4.result == 0 then
			var1_1(arg0_4)
		else
			var2_1(arg0_4)

			if arg0_4.result == 20 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_not_found_theme_template"))
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
			end
		end
	end)
end

return var0_0
