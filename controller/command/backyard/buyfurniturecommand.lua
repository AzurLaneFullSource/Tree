local var0_0 = class("BuyFurnitureCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.furnitureIds
	local var2_1 = var0_1.type
	local var3_1 = getProxy(DormProxy)
	local var4_1 = getProxy(PlayerProxy)
	local var5_1 = var4_1:getData()

	if #var1_1 == 0 or not var2_1 then
		return
	end

	local var6_1 = 0

	for iter0_1, iter1_1 in ipairs(var1_1) do
		local var7_1 = Furniture.New({
			id = iter1_1
		})

		if not var7_1:inTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_furniture_overtime"))

			return
		elseif var2_1 == 4 then
			local var8_1 = var7_1:getPrice(4)

			assert(var8_1 > 0, "furniture price should more than zero>>" .. var7_1.id)

			var6_1 = var6_1 + var8_1
		elseif var2_1 == 6 then
			local var9_1 = var7_1:getPrice(6)

			assert(var9_1 > 0, "furniture price should more than zero>>" .. var7_1.id)

			var6_1 = var6_1 + var9_1
		end
	end

	if var6_1 > var5_1:getResById(var2_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	local function var10_1()
		pg.ConnectionMgr.GetInstance():Send(19006, {
			furniture_id = var1_1,
			currency = var2_1
		}, 19007, function(arg0_3)
			if arg0_3.result == 0 then
				var5_1:consume({
					[id2res(var2_1)] = var6_1
				})
				var4_1:updatePlayer(var5_1)

				local var0_3 = var1_1[1]
				local var1_3 = pg.furniture_data_template[var0_3]

				if var1_3 and var1_3.themeId > 0 then
					var3_1:ResetSystemTheme(var1_3.themeId)
				end

				var3_1:AddFurnitrues(var1_1)

				for iter0_3, iter1_3 in ipairs(var1_1) do
					-- block empty
				end

				PlayerConst.UpdateLinkActivity(underscore.map(var1_1, function(arg0_4)
					return Drop.New({
						count = 1,
						type = DROP_TYPE_FURNITURE,
						id = arg0_4
					})
				end))
				arg0_1:sendNotification(GAME.BUY_FURNITURE_DONE, var3_1:getData(), var1_1)
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_buyFurniture_error", arg0_3.result))
			end
		end)
	end

	if var2_1 == 4 then
		local var11_1 = i18n("word_furniture")

		if #var1_1 == 1 then
			var11_1 = Furniture.New({
				id = var1_1[1]
			}):getConfig("name")
		end

		if _BackyardMsgBoxMgr then
			_BackyardMsgBoxMgr:Show({
				content = i18n("charge_scene_buy_confirm_backyard", var6_1, var11_1),
				onYes = function()
					var10_1()
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("charge_scene_buy_confirm", var6_1, var11_1),
				onYes = function()
					var10_1()
				end
			})
		end
	else
		var10_1()
	end
end

return var0_0
