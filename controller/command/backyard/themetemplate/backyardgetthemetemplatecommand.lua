local var0 = class("BackYardGetThemeTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type
	local var2 = var0.callback
	local var3 = getProxy(DormProxy)

	local function var4(arg0, arg1)
		if var1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.theme_id_list or {}) do
				local var1
				local var2 = BackYardThemeTemplate.New({
					id = iter1
				})

				var2:SetSortIndex(iter0)

				var0[var2.id] = var2
			end

			var3:SetShopThemeTemplates(var0)
		elseif var1 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			local var3 = {}

			for iter2, iter3 in ipairs(arg0.theme_list or {}) do
				local var4
				local var5 = BackYardSelfThemeTemplate.New(iter3)

				var3[var5.id] = var5
			end

			var3:SetCustomThemeTemplates(var3)
		elseif var1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
			local var6 = {}

			for iter4, iter5 in ipairs(arg0.theme_profile_list or {}) do
				local var7
				local var8 = BackYardThemeTemplate.New({
					id = iter5.id,
					upload_time = iter5.upload_time
				})

				var6[var8.id] = var8
			end

			var3:SetCollectionThemeTemplates(var6)
		end

		if arg1 then
			arg1()
		end
	end

	local function var5(arg0)
		arg0:sendNotification(GAME.BACKYARD_GET_IMG_MD5, {
			type = var1,
			callback = arg0
		})
	end

	local function var6(arg0)
		seriesAsync({
			function(arg0)
				var4(arg0, arg0)
			end,
			function(arg0)
				var5(arg0)
			end
		}, function()
			arg0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DONE)

			if var2 then
				var2()
			end
		end)
	end

	if var1 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		pg.ConnectionMgr.GetInstance():Send(19105, {
			typ = var1
		}, 19106, function(arg0)
			if arg0.result == 0 then
				var4(arg0)
				arg0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DONE)

				if var2 then
					var2()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	elseif var1 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		pg.ConnectionMgr.GetInstance():Send(19117, {
			typ = var3.TYPE,
			page = var3.PAGE,
			num = BackYardConst.THEME_TEMPLATE_SHOP_REFRSH_CNT
		}, 19118, function(arg0)
			if arg0.result == 0 then
				var6(arg0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	elseif var1 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		pg.ConnectionMgr.GetInstance():Send(19115, {
			typ = 3
		}, 19116, function(arg0)
			if arg0.result == 0 then
				var6(arg0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	end
end

return var0
