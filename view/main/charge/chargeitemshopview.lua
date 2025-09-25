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
	arg0_3:unBlurView()

	for iter0_3, iter1_3 in ipairs(arg0_3.cardList) do
		iter1_3:Dispose()
	end
end

function var0_0.initData(arg0_4)
	arg0_4.itemGoodsVOList = {}
	arg0_4.player = getProxy(PlayerProxy):getData()
	arg0_4.packageSortList = {
		0
	}
	arg0_4.selectedPackageType = nil
	arg0_4.prevBtn = nil

	arg0_4:updateData()
end

function var0_0.initUI(arg0_5)
	arg0_5.contextTF = arg0_5:findTF("scroll")
	arg0_5.lScrollRect = GetComponent(arg0_5.contextTF, "LScrollRect")
	arg0_5.scrollContent = arg0_5:findTF("scroll/content")
	arg0_5.scrollRectTF = GetComponent(arg0_5.scrollContent, typeof(RectTransform))
	arg0_5.layoutGroup = GetComponent(arg0_5.scrollContent, typeof(GridLayoutGroup))

	local var0_5 = arg0_5.scrollRectTF.rect.width
	local var1_5 = arg0_5.layoutGroup.cellSize.x
	local var2_5 = math.floor(var0_5 / var1_5)
	local var3_5 = var0_5 % var1_5 / var2_5

	if var3_5 < 12 then
		local var4_5 = var2_5 - 1

		var3_5 = (var0_5 - var1_5 * var4_5) / var4_5
	end

	arg0_5.layoutGroup.spacing = Vector2(var3_5, var3_5)
	arg0_5.layoutGroup.padding.left = var3_5 / 2
	arg0_5.cardTable = {}
	arg0_5.cardList = {}

	arg0_5:initScrollRect()
	arg0_5:initToggleList()
	arg0_5:updateToggleList()
	arg0_5:updateScrollRect()
	triggerButton(arg0_5:findTF("toggleGroup"):GetChild(0))
	arg0_5:blurView()
end

function var0_0.initScrollRect(arg0_6)
	arg0_6.cardTable = {}
	arg0_6.cardList = {}

	local function var0_6(arg0_7)
		local var0_7 = ChargeGoodsCard.New(arg0_7)

		table.insert(arg0_6.cardList, var0_7)
		onButton(arg0_6, var0_7.tf, function()
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
								arg0_6:emit(NewShopMainMediator.BUY_ITEM, var0_7.goodsVO.id, 1)
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

		local var1_11 = arg0_6.filterList[arg0_11 + 1]

		var0_11:update(var1_11)
		var0_11:setLevelMask(arg0_6.player.level)

		local var2_11 = ChargeConst.getGroupLimit(arg0_6.normalGroupList, var1_11:getConfig("group"))

		var0_11:setGroupMask(var2_11)
	end

	arg0_6.lScrollRect.onInitItem = var0_6
	arg0_6.lScrollRect.onUpdateItem = var1_6
end

function var0_0.updateScrollRect(arg0_12)
	arg0_12.filterList = arg0_12:getFilterList()

	arg0_12.lScrollRect:SetTotalCount(#arg0_12.filterList, arg0_12.lScrollRect.value)
end

function var0_0.updateToggleList(arg0_13)
	arg0_13.uiToggleList:align(#arg0_13.packageSortList)
end

function var0_0.initToggleList(arg0_14)
	arg0_14.uiToggleList = UIItemList.New(arg0_14:findTF("toggleGroup"), arg0_14:findTF("toggleGroup/Toggle"))

	arg0_14.uiToggleList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventInit then
			local var0_15 = arg0_14.packageSortList[arg1_15 + 1]

			setText(arg0_14:findTF("selected/Label", arg2_15), i18n(string.format("shop_package_sort_%s", var0_15)))
			setText(arg0_14:findTF("selected/enText", arg2_15), i18n(string.format("shop_package_sort_en_%s", var0_15)))
			setText(arg0_14:findTF("unselected/Label", arg2_15), i18n(string.format("shop_package_sort_%s", var0_15)))
			setActive(arg2_15:Find("unselected"), true)
			setActive(arg2_15:Find("selected"), false)
		elseif arg0_15 == UIItemList.EventUpdate then
			onButton(arg0_14, arg2_15, function()
				local var0_16 = arg0_14.packageSortList[arg1_15 + 1]

				if arg0_14.selectedPackageType == var0_16 then
					return
				end

				setActive(arg2_15:Find("unselected"), false)
				setActive(arg2_15:Find("selected"), true)

				if arg0_14.prevBtn then
					setActive(arg0_14.prevBtn:Find("unselected"), true)
					setActive(arg0_14.prevBtn:Find("selected"), false)
				end

				arg0_14.prevBtn = arg2_15
				arg0_14.selectedPackageType = var0_16

				arg0_14:updateScrollRect()
			end, SFX_PANEL)
		end
	end)
end

function var0_0.updateItemGoodsVOList(arg0_17)
	arg0_17.itemGoodsVOList = {}
	arg0_17.packageSortList = {
		0
	}

	local var0_17 = pg.shop_template

	for iter0_17, iter1_17 in pairs(var0_17.all) do
		local var1_17 = var0_17[iter1_17]

		if var1_17.genre == "gem_shop" then
			local var2_17, var3_17, var4_17 = ChargeConst.getGoodsLimitInfo(iter1_17)
			local var5_17 = false
			local var6_17 = var1_17.effect_args

			if var6_17 == "ship_bag_size" and var3_17 and var4_17 then
				local var7_17 = arg0_17.player:getMaxShipBagExcludeGuild()

				if var3_17 <= var7_17 and var7_17 <= var4_17 then
					var5_17 = true
				end
			elseif var6_17 == "equip_bag_max" and var3_17 and var4_17 then
				local var8_17 = arg0_17.player:getMaxEquipmentBag()

				if var3_17 <= var8_17 and var8_17 <= var4_17 then
					var5_17 = true
				end
			elseif var6_17 == "commander_bag_size" and var3_17 and var4_17 then
				local var9_17 = arg0_17.player.commanderBagMax

				if var3_17 <= var9_17 and var9_17 <= var4_17 then
					var5_17 = true
				end
			else
				var5_17 = true
			end

			if var5_17 == true then
				local var10_17 = Goods.Create({
					count = 0,
					shop_id = iter1_17
				}, Goods.TYPE_MILITARY)

				table.insert(arg0_17.itemGoodsVOList, var10_17)
			end
		end
	end

	for iter2_17 = #arg0_17.itemGoodsVOList, 1, -1 do
		local var11_17 = arg0_17.itemGoodsVOList[iter2_17]
		local var12_17 = ChargeConst.getGroupLimit(arg0_17.normalGroupList, var11_17:getConfig("group"))

		if not var11_17:IsShowWhenGroupSale(var12_17) then
			table.remove(arg0_17.itemGoodsVOList, iter2_17)
		end
	end

	for iter3_17, iter4_17 in ipairs(arg0_17.itemGoodsVOList) do
		local var13_17 = var0_17[iter4_17.id].package_sort_id

		if not table.contains(arg0_17.packageSortList, var13_17) then
			table.insert(arg0_17.packageSortList, var13_17)
		end
	end

	table.sort(arg0_17.packageSortList, function(arg0_18, arg1_18)
		return arg0_18 < arg1_18
	end)
end

function var0_0.sortItemGoodsVOList(arg0_19)
	table.sort(arg0_19.itemGoodsVOList, function(arg0_20, arg1_20)
		local var0_20 = arg0_20:isLevelLimit(arg0_19.player.level) and 1 or 0
		local var1_20 = arg1_20:isLevelLimit(arg0_19.player.level) and 1 or 0
		local var2_20 = arg0_20:getConfig("order")
		local var3_20 = arg1_20:getConfig("order")

		if var2_20 == var3_20 then
			if var0_20 == var1_20 then
				return arg0_20.id > arg1_20.id
			end

			return var0_20 < var1_20
		else
			return var2_20 < var3_20
		end
	end)
end

function var0_0.getFilterList(arg0_21)
	if arg0_21.selectedPackageType == 0 then
		return arg0_21.itemGoodsVOList
	end

	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(arg0_21.itemGoodsVOList) do
		if iter1_21:getConfig("package_sort_id") == arg0_21.selectedPackageType then
			table.insert(var0_21, iter1_21)
		end
	end

	return var0_21
end

function var0_0.updateGoodsData(arg0_22)
	arg0_22.firstChargeIds = arg0_22.contextData.firstChargeIds
	arg0_22.chargedList = arg0_22.contextData.chargedList
	arg0_22.normalList = arg0_22.contextData.normalList
	arg0_22.normalGroupList = arg0_22.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	arg0_23.firstChargeIds = arg1_23
	arg0_23.chargedList = arg2_23
	arg0_23.normalList = arg3_23
	arg0_23.normalGroupList = arg4_23
end

function var0_0.updateData(arg0_24)
	arg0_24.player = getProxy(PlayerProxy):getData()

	arg0_24:updateItemGoodsVOList()
	arg0_24:sortItemGoodsVOList()
end

function var0_0.blurView(arg0_25)
	arg0_25:OverlayPanel(arg0_25._tf, {
		pbList = {
			arg0_25:findTF("bg")
		}
	})
end

function var0_0.unBlurView(arg0_26)
	arg0_26:UnOverlayPanel(arg0_26._tf, arg0_26._parentTf)
end

function var0_0.IsSupplyShop(arg0_27)
	return false
end

function var0_0.reUpdateAll(arg0_28)
	arg0_28:updateData()
	arg0_28:updateScrollRect()
end

function var0_0.ShowPanel(arg0_29, arg1_29)
	setActive(arg0_29._go, arg1_29)
end

return var0_0
