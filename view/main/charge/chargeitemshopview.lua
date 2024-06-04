local var0 = class("ChargeItemShopView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ChargeItemShopUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:Show()
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in ipairs(arg0.cardList) do
		iter1:Dispose()
	end
end

function var0.initData(arg0)
	arg0.itemGoodsVOList = {}
	arg0.player = getProxy(PlayerProxy):getData()

	arg0:updateData()
end

function var0.initUI(arg0)
	arg0.contextTF = arg0:findTF("content")
	arg0.lScrollRect = GetComponent(arg0.contextTF, "LScrollRect")
	arg0.cardTable = {}
	arg0.cardList = {}

	arg0:initScrollRect()
	arg0:updateScrollRect()
end

function var0.initScrollRect(arg0)
	arg0.cardTable = {}
	arg0.cardList = {}

	local function var0(arg0)
		local var0 = ChargeGoodsCard.New(arg0)

		table.insert(arg0.cardList, var0)
		onButton(arg0, var0.tr, function()
			if var0.goodsVO:isLevelLimit(arg0.player.level) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("charge_level_limit"))

				return
			end

			local var0 = var0.goodsVO:getConfig("effect_args")
			local var1 = {}
			local var2

			if var0 == "ship_bag_size" then
				if arg0.player:getMaxShipBagExcludeGuild() >= Player.MAX_SHIP_BAG then
					pg.TipsMgr.GetInstance():ShowTips(i18n("charge_ship_bag_max"))

					return
				end

				var1 = {
					count = 1,
					type = DROP_TYPE_ITEM,
					id = Goods.SHIP_BAG_SIZE_ITEM
				}
				var2 = var1.id
			elseif var0 == "equip_bag_size" then
				if arg0.player:getMaxEquipmentBagExcludeGuild() >= Player.MAX_EQUIP_BAG then
					pg.TipsMgr.GetInstance():ShowTips(i18n("charge_equip_bag_max"))

					return
				end

				var1 = {
					count = 1,
					type = DROP_TYPE_ITEM,
					id = Goods.EQUIP_BAG_SIZE_ITEM
				}
				var2 = var1.id
			elseif var0 == "commander_bag_size" then
				if arg0.player.commanderBagMax >= Player.MAX_COMMANDER_BAG then
					pg.TipsMgr.GetInstance():ShowTips(i18n("charge_commander_bag_max"))

					return
				end

				var1 = {
					count = 1,
					type = DROP_TYPE_ITEM,
					id = Goods.COMMANDER_BAG_SIZE_ITEM
				}
				var2 = var1.id
			elseif var0 == "spweapon_bag_size" then
				if getProxy(EquipmentProxy):GetSpWeaponCapacity() >= EquipmentProxy.MAX_SPWEAPON_BAG then
					pg.TipsMgr.GetInstance():ShowTips(i18n("charge_equip_bag_max"))

					return
				end

				var1 = {
					count = 1,
					type = DROP_TYPE_ITEM,
					id = Goods.SPWEAPON_BAG_SIZE_ITEM
				}
				var2 = var1.id
			else
				var1 = {
					id = var0.goodsVO:getConfig("effect_args")[1],
					type = var0.goodsVO:getConfig("type"),
					count = var0.goodsVO:getConfig("num")
				}

				if var0.goodsVO:getConfig("type") == DROP_TYPE_RESOURCE then
					var2 = id2ItemId(var1.id)
				else
					var2 = var1.id
				end
			end

			local var3 = ChargeConst.getGroupLimit(arg0.normalGroupList, var0.goodsVO:getConfig("group"))
			local var4 = var0.goodsVO:IsGroupSale() and i18n("gem_shop_xinzhi_tip", var3) or ""

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_buy",
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = var1,
				subIntro = var4,
				onYes = function()
					if var2 then
						local var0 = var0.goodsVO:GetPrice()
						local var1 = Item.New({
							id = var2
						}):getConfig("name")

						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("charge_scene_buy_confirm", var0, var1),
							onYes = function()
								arg0:emit(ChargeMediator.BUY_ITEM, var0.goodsVO.id, 1)
							end
						})
					end
				end
			})
		end)

		arg0.cardTable[arg0] = var0
	end

	local function var1(arg0, arg1)
		local var0 = arg0.cardTable[arg1]

		if not var0 then
			var0(arg1)

			var0 = arg0.cardTable[arg1]
		end

		local var1 = arg0.itemGoodsVOList[arg0 + 1]

		var0:update(var1)
		var0:setLevelMask(arg0.player.level)

		local var2 = ChargeConst.getGroupLimit(arg0.normalGroupList, var1:getConfig("group"))

		var0:setGroupMask(var2)
	end

	arg0.lScrollRect.onInitItem = var0
	arg0.lScrollRect.onUpdateItem = var1
end

function var0.updateScrollRect(arg0)
	arg0.lScrollRect:SetTotalCount(#arg0.itemGoodsVOList, arg0.lScrollRect.value)
end

function var0.updateItemGoodsVOList(arg0)
	arg0.itemGoodsVOList = {}

	local var0 = pg.shop_template

	for iter0, iter1 in pairs(var0.all) do
		local var1 = var0[iter1]

		if var1.genre == "gem_shop" then
			local var2, var3, var4 = ChargeConst.getGoodsLimitInfo(iter1)
			local var5 = false
			local var6 = var1.effect_args

			if var6 == "ship_bag_size" and var3 and var4 then
				local var7 = arg0.player:getMaxShipBagExcludeGuild()

				if var3 <= var7 and var7 <= var4 then
					var5 = true
				end
			elseif var6 == "equip_bag_max" and var3 and var4 then
				local var8 = arg0.player:getMaxEquipmentBag()

				if var3 <= var8 and var8 <= var4 then
					var5 = true
				end
			elseif var6 == "commander_bag_size" and var3 and var4 then
				local var9 = arg0.player.commanderBagMax

				if var3 <= var9 and var9 <= var4 then
					var5 = true
				end
			else
				var5 = true
			end

			if var5 == true then
				local var10 = Goods.Create({
					count = 0,
					shop_id = iter1
				}, Goods.TYPE_MILITARY)

				table.insert(arg0.itemGoodsVOList, var10)
			end
		end
	end

	for iter2 = #arg0.itemGoodsVOList, 1, -1 do
		local var11 = arg0.itemGoodsVOList[iter2]
		local var12 = ChargeConst.getGroupLimit(arg0.normalGroupList, var11:getConfig("group"))

		if not var11:IsShowWhenGroupSale(var12) then
			table.remove(arg0.itemGoodsVOList, iter2)
		end
	end
end

function var0.sortItemGoodsVOList(arg0)
	table.sort(arg0.itemGoodsVOList, function(arg0, arg1)
		local var0 = arg0:isLevelLimit(arg0.player.level) and 1 or 0
		local var1 = arg1:isLevelLimit(arg0.player.level) and 1 or 0
		local var2 = arg0:getConfig("order")
		local var3 = arg1:getConfig("order")

		if var2 == var3 then
			if var0 == var1 then
				return arg0.id > arg1.id
			end

			return var0 < var1
		else
			return var2 < var3
		end
	end)
end

function var0.updateGoodsData(arg0)
	arg0.firstChargeIds = arg0.contextData.firstChargeIds
	arg0.chargedList = arg0.contextData.chargedList
	arg0.normalList = arg0.contextData.normalList
	arg0.normalGroupList = arg0.contextData.normalGroupList
end

function var0.setGoodData(arg0, arg1, arg2, arg3, arg4)
	arg0.firstChargeIds = arg1
	arg0.chargedList = arg2
	arg0.normalList = arg3
	arg0.normalGroupList = arg4
end

function var0.updateData(arg0)
	arg0.player = getProxy(PlayerProxy):getData()

	arg0:updateItemGoodsVOList()
	arg0:sortItemGoodsVOList()
end

function var0.reUpdateAll(arg0)
	arg0:updateData()
	arg0:updateScrollRect()
end

return var0
