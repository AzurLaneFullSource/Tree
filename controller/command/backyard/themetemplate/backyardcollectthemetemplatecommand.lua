local var0 = class("BackYardCollectThemeTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.templateId
	local var2 = var0.uploadTime
	local var3 = var0.isCancel

	local function var4(arg0)
		local var0 = getProxy(DormProxy)
		local var1 = var0:GetCollectionThemeTemplateById(var1)

		if var1 and var3 then
			var0:DeleteCollectionThemeTemplate(var1.id)
		elseif var1 and not var3 then
			var1:AddCollection()
			var0:UpdateCollectionThemeTemplate(var1)
		end

		local var2 = var0:GetShopThemeTemplateById(var1)

		if var2 and var3 then
			var2:CancelCollection()
		elseif var2 and not var3 then
			var2:AddCollection()
			var0:AddCollectionThemeTemplate(var2)
		end

		if var2 then
			var0:UpdateShopThemeTemplate(var2)
		end

		arg0:sendNotification(GAME.BACKYARD_COLLECT_THEME_TEMPLATE_DONE)
	end

	if var3 then
		pg.ConnectionMgr.GetInstance():Send(19127, {
			theme_id = var1
		}, 19128, function(arg0)
			if arg0.result == 0 then
				var4(arg0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	else
		if getProxy(DormProxy):GetThemeTemplateCollectionCnt() >= BackYardConst.MAX_COLLECTION_CNT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_template_collection_cnt_max"))

			return
		end

		pg.ConnectionMgr.GetInstance():Send(19119, {
			theme_id = var1,
			upload_time = var2
		}, 19120, function(arg0)
			if arg0.result == 0 then
				var4(arg0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	end
end

return var0
