local var0 = class("BuyFurnitureCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.furnitureIds
	local var2 = var0.type
	local var3 = getProxy(DormProxy)
	local var4 = getProxy(PlayerProxy)
	local var5 = var4:getData()

	if #var1 == 0 or not var2 then
		return
	end

	local var6 = 0

	for iter0, iter1 in ipairs(var1) do
		local var7 = Furniture.New({
			id = iter1
		})

		if not var7:inTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_furniture_overtime"))

			return
		elseif var2 == 4 then
			local var8 = var7:getPrice(4)

			assert(var8 > 0, "furniture price should more than zero>>" .. var7.id)

			var6 = var6 + var8
		elseif var2 == 6 then
			local var9 = var7:getPrice(6)

			assert(var9 > 0, "furniture price should more than zero>>" .. var7.id)

			var6 = var6 + var9
		end
	end

	if var6 > var5:getResById(var2) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	local function var10()
		pg.ConnectionMgr.GetInstance():Send(19006, {
			furniture_id = var1,
			currency = var2
		}, 19007, function(arg0)
			if arg0.result == 0 then
				var5:consume({
					[id2res(var2)] = var6
				})
				var4:updatePlayer(var5)

				local var0 = var1[1]
				local var1 = pg.furniture_data_template[var0]

				if var1 and var1.themeId > 0 then
					var3:ResetSystemTheme(var1.themeId)
				end

				var3:AddFurnitrues(var1)
				arg0:UpdateLinkActivity(var1)
				arg0:sendNotification(GAME.BUY_FURNITURE_DONE, var3:getData(), var1)
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_buyFurniture_error", arg0.result))
			end
		end)
	end

	if var2 == 4 then
		local var11 = i18n("word_furniture")

		if #var1 == 1 then
			var11 = Furniture.New({
				id = var1[1]
			}):getConfig("name")
		end

		if _BackyardMsgBoxMgr then
			_BackyardMsgBoxMgr:Show({
				content = i18n("charge_scene_buy_confirm_backyard", var6, var11),
				onYes = function()
					var10()
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("charge_scene_buy_confirm", var6, var11),
				onYes = function()
					var10()
				end
			})
		end
	else
		var10()
	end
end

function var0.UpdateLinkActivity(arg0, arg1)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_LINK_COLLECT)

	if var1 and not var1:isEnd() then
		local var2 = pg.activity_limit_item_guide.get_id_list_by_activity[var1.id]

		assert(var2, "activity_limit_item_guide not exist activity id: " .. var1.id)

		for iter0, iter1 in ipairs(arg1) do
			for iter2, iter3 in ipairs(var2) do
				local var3 = pg.activity_limit_item_guide[iter3]

				if var3.type == DROP_TYPE_FURNITURE and iter1 == var3.drop_id then
					local var4 = var1:getKVPList(1, var3.id) + 1

					var1:updateKVPList(1, var3.id, var4)
				end
			end
		end

		var0:updateActivity(var1)
	end
end

return var0
