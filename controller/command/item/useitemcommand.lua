local var0 = class("UseItemCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.count
	local var3 = var0.arg
	local var4 = getProxy(BagProxy)
	local var5 = var4:getItemById(var1)
	local var6 = var5:getConfig("usage")
	local var7 = var0.skip_check
	local var8 = var0.callback

	if var2 == 0 then
		return
	end

	if var2 > var5.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	if not var0.Check(var5, var2) then
		return
	end

	if var6 == ItemUsage.GUILD_DONATE or var6 == ItemUsage.GUILD_OPERATION then
		if not getProxy(GuildProxy):getRawData() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("not_exist_guild_use_item"))

			return
		end
	elseif var6 == ItemUsage.SKIN_SHOP_DISCOUNT then
		local var9, var10 = var5:GetConsumeForSkinShopDiscount(var3[1])
		local var11 = getProxy(PlayerProxy):getRawData():getResource(var10)

		if var9 > 0 and var11 < var9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(15002, {
		id = var1,
		count = var2,
		arg = var3
	}, 15003, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			var4:removeItemById(var1, var2)

			if var6 == ItemUsage.FOOD then
				arg0:sendNotification(GAME.ADD_FOOD, {
					id = var1,
					count = var2
				})
			elseif var6 == ItemUsage.DROP or var6 == ItemUsage.DROP_TEMPLATE or var6 == ItemUsage.DROP_APPOINTED or var6 == ItemUsage.INVITATION or var6 == ItemUsage.SKIN_SELECT then
				var0 = PlayerConst.addTranDrop(arg0.drop_list)
			elseif var6 == ItemUsage.SKIN_SHOP_DISCOUNT then
				var0 = PlayerConst.addTranDrop(arg0.drop_list)

				local var1, var2 = var5:GetConsumeForSkinShopDiscount(var3[1])

				if var1 > 0 then
					local var3 = getProxy(PlayerProxy):getData()

					var3:consume({
						[id2res(var2)] = var1
					})
					getProxy(PlayerProxy):updatePlayer(var3)
				end

				arg0:sendNotification(GAME.SKIN_SHOPPIGN_DONE, {
					id = var3[1]
				})
			elseif var6 == ItemUsage.DORM_LV_UP then
				arg0:sendNotification(GAME.EXTEND_BACKYARD_AREA)
			elseif var6 == ItemUsage.GUILD_DONATE then
				local var4 = getProxy(GuildProxy):getRawData()

				if var4 then
					var4:AddExtraDonateCnt(var2)
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_use_donateitem_success", var2))
				end
			elseif var6 == ItemUsage.GUILD_OPERATION then
				local var5 = getProxy(GuildProxy):getRawData()

				if var5 then
					var5:AddExtraBattleCnt(var2)
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_use_battleitem_success", var2))
				end
			elseif var6 == ItemUsage.REDUCE_COMMANDER_TIME then
				arg0:sendNotification(GAME.REFRESH_COMMANDER_BOXES)
			else
				assert(false, "未处理类型" .. var6)
			end

			local var6 = QRJ_ITEM_ID_RANGE

			if var1 >= var6[1] and var1 <= var6[2] then
				table.sort(var0, function(arg0, arg1)
					return arg0.count < arg1.count
				end)
			end

			if var8 then
				var8(var0)
			end

			arg0:sendNotification(GAME.USE_ITEM_DONE, var0)
		else
			if var8 then
				var8({})
			end

			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

function var0.Check(arg0, arg1)
	local var0 = arg0:GetOverflowCheckItems(arg1)
	local var1 = GetItemsOverflowDic(var0)
	local var2, var3 = CheckOverflow(var1)

	if not var2 then
		switch(var3, {
			gold = function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))
			end,
			oil = function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))
			end,
			equip = function()
				NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)
			end,
			ship = function()
				NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)
			end
		})

		return false
	end

	return true
end

return var0
