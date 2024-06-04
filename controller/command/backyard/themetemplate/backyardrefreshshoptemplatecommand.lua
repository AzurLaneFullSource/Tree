local var0 = class("BackYardRefreshShopTemplateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type
	local var2 = var0.page
	local var3 = var0.force
	local var4 = var0.timeType
	local var5 = getProxy(DormProxy)
	local var6 = false

	if var2 == var5.MAX_PAGE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shop_reach_last_page"))

		return
	end

	if var2 > var5.lastPages[var1] then
		arg0:sendNotification(GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_ERRO)

		return
	end

	local function var7(arg0, arg1)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.theme_id_list or {}) do
			local var1 = var5:GetShopThemeTemplateById(iter1)

			if not var1 then
				var6 = true

				local var2 = BackYardThemeTemplate.New({
					id = iter1
				})

				var2:SetSortIndex(iter0)

				var0[var2.id] = var2
			else
				var1:SetSortIndex(iter0)

				var0[var1.id] = var1
			end
		end

		if table.getCount(var0) > 0 then
			var5:SetShopThemeTemplates(var0)

			var5.TYPE = var1
			var5.PAGE = var2
		end

		if table.getCount(var0) < BackYardConst.THEME_TEMPLATE_SHOP_REFRSH_CNT then
			var5.lastPages[var1] = var2

			if not var3 then
				-- block empty
			end
		end

		if arg1 then
			arg1()
		end
	end

	local function var8(arg0)
		arg0:sendNotification(GAME.BACKYARD_GET_IMG_MD5, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_SHOP,
			callback = arg0
		})
	end

	local function var9(arg0)
		seriesAsync({
			function(arg0)
				var7(arg0, arg0)
			end,
			function(arg0)
				var8(arg0)
			end
		}, function()
			arg0:sendNotification(GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_DONE, {
				existNew = var6
			})
		end)
	end

	pg.ConnectionMgr.GetInstance():Send(19117, {
		typ = var1,
		page = var2,
		num = BackYardConst.THEME_TEMPLATE_SHOP_REFRSH_CNT
	}, 19118, function(arg0)
		if arg0.result == 0 then
			var9(arg0)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
