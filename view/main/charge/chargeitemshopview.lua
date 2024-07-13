local var0_0 = class("ChargeItemShopView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ChargeItemShopUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:Show()
end

function var0_0.OnDestroy(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.cardList) do
		iter1_3:Dispose()
	end
end

function var0_0.initData(arg0_4)
	arg0_4.itemGoodsVOList = {}
	arg0_4.player = getProxy(PlayerProxy):getData()

	arg0_4:updateData()
end

function var0_0.initUI(arg0_5)
	arg0_5.contextTF = arg0_5:findTF("content")
	arg0_5.lScrollRect = GetComponent(arg0_5.contextTF, "LScrollRect")
	arg0_5.cardTable = {}
	arg0_5.cardList = {}

	arg0_5:initScrollRect()
	arg0_5:updateScrollRect()
end

function var0_0.initScrollRect(arg0_6)
	arg0_6.cardTable = {}
	arg0_6.cardList = {}

	local function var0_6(arg0_7)
		local var0_7 = ChargeGoodsCard.New(arg0_7)

		table.insert(arg0_6.cardList, var0_7)
		onButton(arg0_6, var0_7.tr, function()
			if var0_7.goodsVO:isLevelLimit(arg0_6.player.level) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("charge_level_limit"))

				return
			end

			local var0_8 = var0_7.goodsVO:getConfig("effect_args")
			local var1_8 = {}
			local var2_8

			if var0_8 == "ship_bag_size" then
				if arg0_6.player:getMaxShipBagExcludeGuild() >= Player.MAX_SHIP_BAG then
					pg.TipsMgr.GetInstance():ShowTips(i18n("charge_ship_bag_max"))

					return
				end

				var1_8 = {
					count = 1,
					type = DROP_TYPE_ITEM,
					id = Goods.SHIP_BAG_SIZE_ITEM
				}
				var2_8 = var1_8.id
			elseif var0_8 == "equip_bag_size" then
				if arg0_6.player:getMaxEquipmentBagExcludeGuild() >= Player.MAX_EQUIP_BAG then
					pg.TipsMgr.GetInstance():ShowTips(i18n("charge_equip_bag_max"))

					return
				end

				var1_8 = {
					count = 1,
					type = DROP_TYPE_ITEM,
					id = Goods.EQUIP_BAG_SIZE_ITEM
				}
				var2_8 = var1_8.id
			elseif var0_8 == "commander_bag_size" then
				if arg0_6.player.commanderBagMax >= Player.MAX_COMMANDER_BAG then
					pg.TipsMgr.GetInstance():ShowTips(i18n("charge_commander_bag_max"))

					return
				end

				var1_8 = {
					count = 1,
					type = DROP_TYPE_ITEM,
					id = Goods.COMMANDER_BAG_SIZE_ITEM
				}
				var2_8 = var1_8.id
			elseif var0_8 == "spweapon_bag_size" then
				if getProxy(EquipmentProxy):GetSpWeaponCapacity() >= EquipmentProxy.MAX_SPWEAPON_BAG then
					pg.TipsMgr.GetInstance():ShowTips(i18n("charge_equip_bag_max"))

					return
				end

				var1_8 = {
					count = 1,
					type = DROP_TYPE_ITEM,
					id = Goods.SPWEAPON_BAG_SIZE_ITEM
				}
				var2_8 = var1_8.id
			else
				var1_8 = {
					id = var0_7.goodsVO:getConfig("effect_args")[1],
					type = var0_7.goodsVO:getConfig("type"),
					count = var0_7.goodsVO:getConfig("num")
				}

				if var0_7.goodsVO:getConfig("type") == DROP_TYPE_RESOURCE then
					var2_8 = id2ItemId(var1_8.id)
				else
					var2_8 = var1_8.id
				end
			end

			local var3_8 = ChargeConst.getGroupLimit(arg0_6.normalGroupList, var0_7.goodsVO:getConfig("group"))
			local var4_8 = var0_7.goodsVO:IsGroupSale() and i18n("gem_shop_xinzhi_tip", var3_8) or ""

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_buy",
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = var1_8,
				subIntro = var4_8,
				onYes = function()
					if var2_8 then
						local var0_9 = var0_7.goodsVO:GetPrice()
						local var1_9 = Item.New({
							id = var2_8
						}):getConfig("name")

						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("charge_scene_buy_confirm", var0_9, var1_9),
							onYes = function()
								arg0_6:emit(ChargeMediator.BUY_ITEM, var0_7.goodsVO.id, 1)
							end
						})
					end
				end
			})
		end)

		arg0_6.cardTable[arg0_7] = var0_7
	end

	local function var1_6(arg0_11, arg1_11)
		local var0_11 = arg0_6.cardTable[arg1_11]

		if not var0_11 then
			var0_6(arg1_11)

			var0_11 = arg0_6.cardTable[arg1_11]
		end

		local var1_11 = arg0_6.itemGoodsVOList[arg0_11 + 1]

		var0_11:update(var1_11)
		var0_11:setLevelMask(arg0_6.player.level)

		local var2_11 = ChargeConst.getGroupLimit(arg0_6.normalGroupList, var1_11:getConfig("group"))

		var0_11:setGroupMask(var2_11)
	end

	arg0_6.lScrollRect.onInitItem = var0_6
	arg0_6.lScrollRect.onUpdateItem = var1_6
end

function var0_0.updateScrollRect(arg0_12)
	arg0_12.lScrollRect:SetTotalCount(#arg0_12.itemGoodsVOList, arg0_12.lScrollRect.value)
end

function var0_0.updateItemGoodsVOList(arg0_13)
	arg0_13.itemGoodsVOList = {}

	local var0_13 = pg.shop_template

	for iter0_13, iter1_13 in pairs(var0_13.all) do
		local var1_13 = var0_13[iter1_13]

		if var1_13.genre == "gem_shop" then
			local var2_13, var3_13, var4_13 = ChargeConst.getGoodsLimitInfo(iter1_13)
			local var5_13 = false
			local var6_13 = var1_13.effect_args

			if var6_13 == "ship_bag_size" and var3_13 and var4_13 then
				local var7_13 = arg0_13.player:getMaxShipBagExcludeGuild()

				if var3_13 <= var7_13 and var7_13 <= var4_13 then
					var5_13 = true
				end
			elseif var6_13 == "equip_bag_max" and var3_13 and var4_13 then
				local var8_13 = arg0_13.player:getMaxEquipmentBag()

				if var3_13 <= var8_13 and var8_13 <= var4_13 then
					var5_13 = true
				end
			elseif var6_13 == "commander_bag_size" and var3_13 and var4_13 then
				local var9_13 = arg0_13.player.commanderBagMax

				if var3_13 <= var9_13 and var9_13 <= var4_13 then
					var5_13 = true
				end
			else
				var5_13 = true
			end

			if var5_13 == true then
				local var10_13 = Goods.Create({
					count = 0,
					shop_id = iter1_13
				}, Goods.TYPE_MILITARY)

				table.insert(arg0_13.itemGoodsVOList, var10_13)
			end
		end
	end

	for iter2_13 = #arg0_13.itemGoodsVOList, 1, -1 do
		local var11_13 = arg0_13.itemGoodsVOList[iter2_13]
		local var12_13 = ChargeConst.getGroupLimit(arg0_13.normalGroupList, var11_13:getConfig("group"))

		if not var11_13:IsShowWhenGroupSale(var12_13) then
			table.remove(arg0_13.itemGoodsVOList, iter2_13)
		end
	end
end

function var0_0.sortItemGoodsVOList(arg0_14)
	table.sort(arg0_14.itemGoodsVOList, function(arg0_15, arg1_15)
		local var0_15 = arg0_15:isLevelLimit(arg0_14.player.level) and 1 or 0
		local var1_15 = arg1_15:isLevelLimit(arg0_14.player.level) and 1 or 0
		local var2_15 = arg0_15:getConfig("order")
		local var3_15 = arg1_15:getConfig("order")

		if var2_15 == var3_15 then
			if var0_15 == var1_15 then
				return arg0_15.id > arg1_15.id
			end

			return var0_15 < var1_15
		else
			return var2_15 < var3_15
		end
	end)
end

function var0_0.updateGoodsData(arg0_16)
	arg0_16.firstChargeIds = arg0_16.contextData.firstChargeIds
	arg0_16.chargedList = arg0_16.contextData.chargedList
	arg0_16.normalList = arg0_16.contextData.normalList
	arg0_16.normalGroupList = arg0_16.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	arg0_17.firstChargeIds = arg1_17
	arg0_17.chargedList = arg2_17
	arg0_17.normalList = arg3_17
	arg0_17.normalGroupList = arg4_17
end

function var0_0.updateData(arg0_18)
	arg0_18.player = getProxy(PlayerProxy):getData()

	arg0_18:updateItemGoodsVOList()
	arg0_18:sortItemGoodsVOList()
end

function var0_0.reUpdateAll(arg0_19)
	arg0_19:updateData()
	arg0_19:updateScrollRect()
end

return var0_0
