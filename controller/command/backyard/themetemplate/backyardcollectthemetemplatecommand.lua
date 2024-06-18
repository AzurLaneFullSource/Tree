local var0_0 = class("BackYardCollectThemeTemplateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.templateId
	local var2_1 = var0_1.uploadTime
	local var3_1 = var0_1.isCancel

	local function var4_1(arg0_2)
		local var0_2 = getProxy(DormProxy)
		local var1_2 = var0_2:GetCollectionThemeTemplateById(var1_1)

		if var1_2 and var3_1 then
			var0_2:DeleteCollectionThemeTemplate(var1_2.id)
		elseif var1_2 and not var3_1 then
			var1_2:AddCollection()
			var0_2:UpdateCollectionThemeTemplate(var1_2)
		end

		local var2_2 = var0_2:GetShopThemeTemplateById(var1_1)

		if var2_2 and var3_1 then
			var2_2:CancelCollection()
		elseif var2_2 and not var3_1 then
			var2_2:AddCollection()
			var0_2:AddCollectionThemeTemplate(var2_2)
		end

		if var2_2 then
			var0_2:UpdateShopThemeTemplate(var2_2)
		end

		arg0_1:sendNotification(GAME.BACKYARD_COLLECT_THEME_TEMPLATE_DONE)
	end

	if var3_1 then
		pg.ConnectionMgr.GetInstance():Send(19127, {
			theme_id = var1_1
		}, 19128, function(arg0_3)
			if arg0_3.result == 0 then
				var4_1(arg0_3)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
			end
		end)
	else
		if getProxy(DormProxy):GetThemeTemplateCollectionCnt() >= BackYardConst.MAX_COLLECTION_CNT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_template_collection_cnt_max"))

			return
		end

		pg.ConnectionMgr.GetInstance():Send(19119, {
			theme_id = var1_1,
			upload_time = var2_1
		}, 19120, function(arg0_4)
			if arg0_4.result == 0 then
				var4_1(arg0_4)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
			end
		end)
	end
end

return var0_0
