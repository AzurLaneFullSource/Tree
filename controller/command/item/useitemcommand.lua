local var0_0 = class("UseItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count
	local var3_1 = var0_1.arg
	local var4_1 = getProxy(BagProxy)
	local var5_1 = var4_1:getItemById(var1_1)
	local var6_1 = var5_1:getConfig("usage")
	local var7_1 = var0_1.skip_check
	local var8_1 = var0_1.callback

	if var2_1 == 0 then
		return
	end

	if var2_1 > var5_1.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	if not var0_0.Check(var5_1, var2_1) then
		return
	end

	if var6_1 == ItemUsage.GUILD_DONATE or var6_1 == ItemUsage.GUILD_OPERATION then
		if not getProxy(GuildProxy):getRawData() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("not_exist_guild_use_item"))

			return
		end
	elseif var6_1 == ItemUsage.SKIN_SHOP_DISCOUNT then
		local var9_1, var10_1 = var5_1:GetConsumeForSkinShopDiscount(var3_1[1])
		local var11_1 = getProxy(PlayerProxy):getRawData():getResource(var10_1)

		if var9_1 > 0 and var11_1 < var9_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(15002, {
		id = var1_1,
		count = var2_1,
		arg = var3_1
	}, 15003, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			var4_1:removeItemById(var1_1, var2_1)

			if var6_1 == ItemUsage.FOOD then
				arg0_1:sendNotification(GAME.ADD_FOOD, {
					id = var1_1,
					count = var2_1
				})
			elseif var6_1 == ItemUsage.DROP or var6_1 == ItemUsage.DROP_TEMPLATE or var6_1 == ItemUsage.DROP_APPOINTED or var6_1 == ItemUsage.INVITATION or var6_1 == ItemUsage.SKIN_SELECT or var6_1 == ItemUsage.RANDOM_SKIN then
				var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)
			elseif var6_1 == ItemUsage.SKIN_SHOP_DISCOUNT then
				var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

				local var1_2, var2_2 = var5_1:GetConsumeForSkinShopDiscount(var3_1[1])

				if var1_2 > 0 then
					local var3_2 = getProxy(PlayerProxy):getData()

					var3_2:consume({
						[id2res(var2_2)] = var1_2
					})
					getProxy(PlayerProxy):updatePlayer(var3_2)
				end

				arg0_1:sendNotification(GAME.SKIN_SHOPPIGN_DONE, {
					id = var3_1[1]
				})
			elseif var6_1 == ItemUsage.DORM_LV_UP then
				arg0_1:sendNotification(GAME.EXTEND_BACKYARD_AREA)
			elseif var6_1 == ItemUsage.GUILD_DONATE then
				local var4_2 = getProxy(GuildProxy):getRawData()

				if var4_2 then
					var4_2:AddExtraDonateCnt(var2_1)
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_use_donateitem_success", var2_1))
				end
			elseif var6_1 == ItemUsage.GUILD_OPERATION then
				local var5_2 = getProxy(GuildProxy):getRawData()

				if var5_2 then
					var5_2:AddExtraBattleCnt(var2_1)
					pg.TipsMgr.GetInstance():ShowTips(i18n("guild_use_battleitem_success", var2_1))
				end
			elseif var6_1 == ItemUsage.REDUCE_COMMANDER_TIME then
				arg0_1:sendNotification(GAME.REFRESH_COMMANDER_BOXES)
			else
				assert(false, "未处理类型" .. var6_1)
			end

			local var6_2 = QRJ_ITEM_ID_RANGE

			if var1_1 >= var6_2[1] and var1_1 <= var6_2[2] then
				table.sort(var0_2, function(arg0_3, arg1_3)
					return arg0_3.count < arg1_3.count
				end)
			end

			if var8_1 then
				var8_1(var0_2)
			end

			arg0_1:sendNotification(GAME.USE_ITEM_DONE, var0_2)
		else
			if var8_1 then
				var8_1({})
			end

			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

function var0_0.Check(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetOverflowCheckItems(arg1_4)
	local var1_4 = GetItemsOverflowDic(var0_4)
	local var2_4, var3_4 = CheckOverflow(var1_4)

	if not var2_4 then
		switch(var3_4, {
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

return var0_0
