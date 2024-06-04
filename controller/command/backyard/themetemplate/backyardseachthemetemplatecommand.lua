local var0 = class("BackYardSeachThemeTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().str

	if not var0 or var0 == "" then
		arg0:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE_ERRO)

		return
	end

	local function var1(arg0)
		local var0 = arg0.theme
		local var1 = arg0.has_fav and 1 or 0
		local var2 = arg0.has_like and 1 or 0
		local var3 = BackYardThemeTemplate.New({
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

		arg0:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE_DONE, {
			template = var3
		})
	end

	local function var2(arg0)
		arg0:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE_ERRO)
	end

	pg.ConnectionMgr.GetInstance():Send(19113, {
		theme_id = var0
	}, 19114, function(arg0)
		if arg0.result == 0 then
			var1(arg0)
		else
			var2(arg0)

			if arg0.result == 20 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_not_found_theme_template"))
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end
	end)
end

return var0
