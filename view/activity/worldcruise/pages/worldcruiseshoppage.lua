local var0_0 = class("WorldCruiseShopPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldCruiseShopPage"
end

function var0_0.UpdateShop(arg0_2, arg1_2)
	arg0_2.shop = arg1_2 or getProxy(ShopsProxy):GetCruiseShop()
end

function var0_0.OnLoaded(arg0_3)
	arg0_3:UpdateShop()

	local var0_3 = arg0_3._tf:Find("frame")

	arg0_3.lockTF = var0_3:Find("views/lock")
	arg0_3.remainTF = var0_3:Find("views/remain")
	arg0_3.togglesTF = var0_3:Find("toggles")

	eachChild(arg0_3.togglesTF, function(arg0_4)
		setText(arg0_4:Find("unselected/Text"), i18n("cruise_shop_title_" .. arg0_4.name))
		setText(arg0_4:Find("selected/Text"), i18n("cruise_shop_title_" .. arg0_4.name))
		onToggle(arg0_3, arg0_4, function(arg0_5)
			if arg0_5 then
				setActive(arg0_3.remainTF, arg0_4.name == "equip_skin")
			end

			arg0_3:Flush()
		end, SFX_PANEL)
	end)

	local var1_3 = var0_3:Find("views")
	local var2_3 = string.format("-%s-", i18n("word_sell_out"))

	arg0_3.skinView = var1_3:Find("skin")

	setText(arg0_3.skinView:Find("tpl_skin/mask/sell_out/Text"), var2_3)

	arg0_3.skinScrollCom = GetComponent(arg0_3.skinView:Find("content"), "LScrollRect")

	function arg0_3.skinScrollCom.onUpdateItem(arg0_6, arg1_6)
		arg0_3:UpdateSkinItem(arg0_6, tf(arg1_6))
	end

	arg0_3.equipSkinView = var1_3:Find("equip_skin")

	setText(arg0_3.equipSkinView:Find("tpl_equip_skin/mask/sell_out/Text"), var2_3)

	arg0_3.equipSkinScrollCom = GetComponent(arg0_3.equipSkinView:Find("content"), "LScrollRect")

	function arg0_3.equipSkinScrollCom.onUpdateItem(arg0_7, arg1_7)
		arg0_3:UpdateEquipSkinItem(arg0_7, tf(arg1_7))
	end
end

function var0_0.OnInit(arg0_8)
	arg0_8.unlockPhase = pg.gameset.battlepass_level.key_value
	arg0_8.paintingList = {}
	arg0_8.idx2Painting = {}
end

function var0_0.Flush(arg0_9, arg1_9)
	arg0_9:Show()

	if arg1_9 then
		arg0_9:UpdateShop(arg1_9)
	end

	arg0_9.isLock = arg0_9.contextData.phase < arg0_9.unlockPhase
	arg0_9.remainCnt = arg0_9.shop:GetRemainEquipSkinCnt()

	setText(arg0_9.lockTF:Find("Image/Text"), i18n("cruise_shop_lock_tip", arg0_9.contextData.phase, arg0_9.unlockPhase))
	setActive(arg0_9.lockTF, arg0_9.isLock)
	setText(arg0_9.remainTF, i18n("cruise_shop_limit_tip") .. arg0_9.remainCnt)

	arg0_9.skinGoods = arg0_9.shop:getSortGoodsByType(CruiseShop.TYPE_SKIN)

	if isActive(arg0_9.skinView) then
		arg0_9.skinScrollCom:SetTotalCount(#arg0_9.skinGoods)
	end

	arg0_9.equipSkinGoods = arg0_9.shop:getSortGoodsByType(CruiseShop.TYPE_EQUIP_SKIN)

	if isActive(arg0_9.equipSkinView) then
		arg0_9.equipSkinScrollCom:SetTotalCount(#arg0_9.equipSkinGoods)
	end
end

function var0_0.UpdateSkinItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.skinGoods[arg1_10 + 1]
	local var1_10 = var0_10:getDropInfo()

	setText(arg2_10:Find("skin_name"), var0_10:GetName())

	local var2_10 = var1_10:getConfig("ship_group")
	local var3_10 = tonumber(var2_10 .. "1")

	setText(arg2_10:Find("name"), pg.ship_data_statistics[var3_10].name)
	setText(arg2_10:Find("buy/Text"), var0_10:GetPrice())

	local var4_10 = arg2_10:Find("icon_mask/painting")
	local var5_10 = var1_10:getConfig("painting")

	if arg0_10.idx2Painting[arg1_10] ~= var5_10 then
		retPaintingPrefab(var4_10, var5_10, "pifu")
		setPaintingPrefabAsync(var4_10, var5_10, "pifu", function()
			setLocalPosition(var4_10, {
				x = 0,
				y = 40
			})

			arg0_10.paintingList[var5_10] = var4_10
			arg0_10.idx2Painting[arg1_10] = var5_10
		end)
	end

	local var6_10 = var0_10:canPurchase()

	setActive(arg2_10:Find("mask"), not var6_10)
	onButton(arg0_10, arg2_10, function()
		if not var6_10 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("charge_scene_buy_confirm", var0_10:GetPrice(), var0_10:GetName()),
			onYes = function()
				if getProxy(PlayerProxy):getData():getTotalGem() < var0_10:GetPrice() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

					return
				end

				arg0_10:emit(WorldCruiseMediator.ON_CRUISE_SHOPPING, var0_10.id, 1)
			end
		})
	end, SFX_CONFIRM)
end

function var0_0.UpdateEquipSkinItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.equipSkinGoods[arg1_14 + 1]
	local var1_14 = var0_14:getDropInfo()

	updateDrop(arg2_14:Find("IconTpl"), var1_14)
	setText(arg2_14:Find("name"), var0_14:GetName())
	setText(arg2_14:Find("buy/Text"), var0_14:GetPrice())
	setText(arg2_14:Find("Text"), i18n("common_already owned") .. string.format("%s/%s", var0_14:GetOwnedCnt(), var0_14:getLimitCount()))

	local var2_14 = var0_14:canPurchase()

	setActive(arg2_14:Find("mask"), not var2_14)
	onButton(arg0_14, arg2_14, function()
		if not var2_14 then
			return
		end

		arg0_14.contextData.windowForESkin:ExecuteAction("Open", var0_14, function(arg0_16, arg1_16, arg2_16)
			if arg0_14.remainCnt <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("cruise_limit_count"))

				return
			end

			if not var2_14 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

				return
			end

			if getProxy(PlayerProxy):getData():getTotalGem() < arg0_16:GetPrice() * arg1_16 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end

			arg0_14:emit(WorldCruiseMediator.ON_CRUISE_SHOPPING, arg0_16.id, arg1_16)
		end)
	end, SFX_CONFIRM)
end

function var0_0.OnDestroy(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.paintingList) do
		setLocalPosition(iter1_17, {
			x = 0,
			y = 0
		})
		retPaintingPrefab(iter1_17, iter0_17)
	end
end

return var0_0
