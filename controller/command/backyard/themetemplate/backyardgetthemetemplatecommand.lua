local var0_0 = class("BackYardGetThemeTemplateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(DormProxy)

	local function var4_1(arg0_2, arg1_2)
		if var1_1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.theme_id_list or {}) do
				local var1_2
				local var2_2 = BackYardThemeTemplate.New({
					id = iter1_2
				})

				var2_2:SetSortIndex(iter0_2)

				var0_2[var2_2.id] = var2_2
			end

			var3_1:SetShopThemeTemplates(var0_2)
		elseif var1_1 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			local var3_2 = {}

			for iter2_2, iter3_2 in ipairs(arg0_2.theme_list or {}) do
				local var4_2
				local var5_2 = BackYardSelfThemeTemplate.New(iter3_2)

				var3_2[var5_2.id] = var5_2
			end

			var3_1:SetCustomThemeTemplates(var3_2)
		elseif var1_1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
			local var6_2 = {}

			for iter4_2, iter5_2 in ipairs(arg0_2.theme_profile_list or {}) do
				local var7_2
				local var8_2 = BackYardThemeTemplate.New({
					id = iter5_2.id,
					upload_time = iter5_2.upload_time
				})

				var6_2[var8_2.id] = var8_2
			end

			var3_1:SetCollectionThemeTemplates(var6_2)
		end

		if arg1_2 then
			arg1_2()
		end
	end

	local function var5_1(arg0_3)
		arg0_1:sendNotification(GAME.BACKYARD_GET_IMG_MD5, {
			type = var1_1,
			callback = arg0_3
		})
	end

	local function var6_1(arg0_4)
		seriesAsync({
			function(arg0_5)
				var4_1(arg0_4, arg0_5)
			end,
			function(arg0_6)
				var5_1(arg0_6)
			end
		}, function()
			arg0_1:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DONE)

			if var2_1 then
				var2_1()
			end
		end)
	end

	if var1_1 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		pg.ConnectionMgr.GetInstance():Send(19105, {
			typ = var1_1
		}, 19106, function(arg0_8)
			if arg0_8.result == 0 then
				var4_1(arg0_8)
				arg0_1:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DONE)

				if var2_1 then
					var2_1()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_8.result] .. arg0_8.result)
			end
		end)
	elseif var1_1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		pg.ConnectionMgr.GetInstance():Send(19117, {
			typ = var3_1.TYPE,
			page = var3_1.PAGE,
			num = BackYardConst.THEME_TEMPLATE_SHOP_REFRSH_CNT
		}, 19118, function(arg0_9)
			if arg0_9.result == 0 then
				var6_1(arg0_9)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_9.result] .. arg0_9.result)
			end
		end)
	elseif var1_1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		pg.ConnectionMgr.GetInstance():Send(19115, {
			typ = 3
		}, 19116, function(arg0_10)
			if arg0_10.result == 0 then
				var6_1(arg0_10)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_10.result] .. arg0_10.result)
			end
		end)
	end
end

return var0_0
