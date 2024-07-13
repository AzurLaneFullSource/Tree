local var0_0 = class("BackYardRefreshShopTemplateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.page
	local var3_1 = var0_1.force
	local var4_1 = var0_1.timeType
	local var5_1 = getProxy(DormProxy)
	local var6_1 = false

	if var2_1 == var5_1.MAX_PAGE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shop_reach_last_page"))

		return
	end

	if var2_1 > var5_1.lastPages[var1_1] then
		arg0_1:sendNotification(GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_ERRO)

		return
	end

	local function var7_1(arg0_2, arg1_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.theme_id_list or {}) do
			local var1_2 = var5_1:GetShopThemeTemplateById(iter1_2)

			if not var1_2 then
				var6_1 = true

				local var2_2 = BackYardThemeTemplate.New({
					id = iter1_2
				})

				var2_2:SetSortIndex(iter0_2)

				var0_2[var2_2.id] = var2_2
			else
				var1_2:SetSortIndex(iter0_2)

				var0_2[var1_2.id] = var1_2
			end
		end

		if table.getCount(var0_2) > 0 then
			var5_1:SetShopThemeTemplates(var0_2)

			var5_1.TYPE = var1_1
			var5_1.PAGE = var2_1
		end

		if table.getCount(var0_2) < BackYardConst.THEME_TEMPLATE_SHOP_REFRSH_CNT then
			var5_1.lastPages[var1_1] = var2_1

			if not var3_1 then
				-- block empty
			end
		end

		if arg1_2 then
			arg1_2()
		end
	end

	local function var8_1(arg0_3)
		arg0_1:sendNotification(GAME.BACKYARD_GET_IMG_MD5, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_SHOP,
			callback = arg0_3
		})
	end

	local function var9_1(arg0_4)
		seriesAsync({
			function(arg0_5)
				var7_1(arg0_4, arg0_5)
			end,
			function(arg0_6)
				var8_1(arg0_6)
			end
		}, function()
			arg0_1:sendNotification(GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_DONE, {
				existNew = var6_1
			})
		end)
	end

	pg.ConnectionMgr.GetInstance():Send(19117, {
		typ = var1_1,
		page = var2_1,
		num = BackYardConst.THEME_TEMPLATE_SHOP_REFRSH_CNT
	}, 19118, function(arg0_8)
		if arg0_8.result == 0 then
			var9_1(arg0_8)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_8.result] .. arg0_8.result)
		end
	end)
end

return var0_0
