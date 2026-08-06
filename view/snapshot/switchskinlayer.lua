local var0_0 = class("SwitchSkinLayer", import("..base.BaseUI"))

function var0_0.setShip(arg0_1, arg1_1)
	arg0_1.shipVO = arg1_1
end

function var0_0.GetShareSkins(arg0_2)
	local var0_2 = getProxy(ShipSkinProxy):GetShareSkinsForShip(arg0_2.shipVO)

	return (_.map(var0_2, function(arg0_3)
		return pg.ship_skin_template[arg0_3.id]
	end))
end

function var0_0.setSkinList(arg0_4, arg1_4)
	arg0_4.skinList = arg1_4
	arg0_4.skins = arg0_4:getGroupSkinList(arg0_4.shipVO.groupId)
	arg0_4.shareSkins = arg0_4:GetShareSkins()
end

function var0_0.getUIName(arg0_5)
	return "SwitchSkinLayer"
end

function var0_0.back(arg0_6)
	arg0_6:emit(var0_0.ON_CLOSE)
end

function var0_0.init(arg0_7)
	arg0_7.shareBtn = arg0_7._tf:Find("select_skin/share_btn")

	arg0_7:BlurPanel(arg0_7._tf)
end

function var0_0.didEnter(arg0_8)
	arg0_8:initSelectSkinPanel()
	triggerToggle(arg0_8.shareBtn, false)
	setActive(arg0_8.shareBtn, #arg0_8.shareSkins > 0)
	setText(findTF(arg0_8._tf, "select_skin/title/Text"), i18n("dorm3d_clothing_choose"))
end

function var0_0.initSelectSkinPanel(arg0_9)
	arg0_9.skinPanel = arg0_9._tf

	local var0_9 = arg0_9.skinPanel:Find("select_skin/btnBack")
	local var1_9 = arg0_9.skinPanel:Find("print")

	onButton(arg0_9, var0_9, function()
		arg0_9:back()
	end)
	onButton(arg0_9, var1_9, function()
		arg0_9:back()
	end)
	onToggle(arg0_9, arg0_9.shareBtn, function(arg0_12)
		if arg0_12 then
			arg0_9:Flush(arg0_9.shareSkins)
		else
			arg0_9:Flush(arg0_9.skins)
		end

		arg0_9.shareOn = arg0_12
	end, SFX_PANEL)

	arg0_9.skinScroll = arg0_9.skinPanel:Find("select_skin/style_scroll")
	arg0_9.skinContainer = arg0_9.skinScroll:Find("view_port")
	arg0_9.skinCard = arg0_9.skinContainer:GetChild(0)

	setActive(arg0_9.skinCard, false)

	arg0_9.skinCardMap = {}
end

function var0_0.openSelectSkinPanel(arg0_13)
	if arg0_13.shareOn then
		arg0_13:Flush(arg0_13.shareSkins)
	else
		arg0_13:Flush(arg0_13.skins)
	end
end

function var0_0.Flush(arg0_14, arg1_14)
	for iter0_14 = arg0_14.skinContainer.childCount, #arg1_14 - 1 do
		cloneTplTo(arg0_14.skinCard, arg0_14.skinContainer)
	end

	for iter1_14 = #arg1_14, arg0_14.skinContainer.childCount - 1 do
		setActive(arg0_14.skinContainer:GetChild(iter1_14), false)
	end

	local var0_14 = getProxy(ShipSkinProxy)
	local var1_14 = arg0_14.skinContainer.childCount

	for iter2_14, iter3_14 in ipairs(arg1_14) do
		local var2_14 = arg0_14.skinContainer:GetChild(iter2_14 - 1)
		local var3_14 = arg0_14.skinCardMap[var2_14]

		if not var3_14 then
			var3_14 = ShipSkinCard.New(var2_14.gameObject)
			arg0_14.skinCardMap[var2_14] = var3_14
		end

		local var4_14 = arg0_14.shipVO:getRemouldSkinId() == iter3_14.id and arg0_14.shipVO:isRemoulded()
		local var5_14 = arg0_14.shipVO:proposeSkinOwned(iter3_14) or table.contains(arg0_14.skinList, iter3_14.id) or var4_14 or iter3_14.skin_type == ShipSkin.SKIN_TYPE_OLD or var0_14:hasSkin(iter3_14.id)

		var3_14:updateData(arg0_14.shipVO, iter3_14, var5_14)

		local var6_14 = arg0_14.shipVO:useSkin(iter3_14.id)

		var3_14:updateUsing(var6_14)
		removeOnButton(var2_14)

		local var7_14 = arg0_14.shipVO:getRemouldSkinId() == iter3_14.id and arg0_14.shipVO:isRemoulded()
		local var8_14 = (arg0_14.shipVO:proposeSkinOwned(iter3_14) or table.contains(arg0_14.skinList, iter3_14.id) or var7_14) and 1 or 0
		local var9_14 = iter3_14.shop_id > 0 and pg.shop_template[iter3_14.shop_id] or nil
		local var10_14 = var9_14 and not pg.TimeMgr.GetInstance():inTime(var9_14.time)
		local var11_14 = iter3_14.id == arg0_14.shipVO:getSkinId()
		local var12_14 = iter3_14.id == arg0_14.shipVO:getConfig("skin_id") or var8_14 >= 1 or iter3_14.skin_type == ShipSkin.SKIN_TYPE_OLD or var0_14:hasSkin(iter3_14.id)
		local var13_14 = getProxy(ShipSkinProxy):InForbiddenSkinListAndShow(iter3_14.id)

		onToggle(arg0_14, var3_14.hideObjToggleTF, function(arg0_15)
			PlayerPrefs.SetInt("paint_hide_other_obj_" .. var3_14.paintingName, arg0_15 and 1 or 0)
			var3_14:flushSkin()
			arg0_14:emit(SwitchSkinMediator.UPDATE_SKINCONFIG, arg0_14.shipVO:getSkinId())
		end, SFX_PANEL)
		onButton(arg0_14, var3_14.changeSkinTF, function(arg0_16)
			local var0_16 = ShipSkin.GetChangeSkinNextId(iter3_14.id)

			ShipSkin.SetStoreChangeSkinId(var0_16, arg0_14.shipVO:GetShipPhantomMark())

			if var6_14 then
				arg0_14:emit(SwitchSkinMediator.CHANGE_SKIN, arg0_14.shipVO:GetShipPhantomMark(), var0_16)
				pg.m02:sendNotification(GAME.CHANGE_SKIN_UPDATE, arg0_14.shipVO:GetShipPhantomMark())
			end
		end, SFX_PANEL)
		onButton(arg0_14, var2_14, function()
			if var11_14 then
				arg0_14:back()
			elseif ShipSkin.IsShareSkin(arg0_14.shipVO, iter3_14.id) and not ShipSkin.CanUseShareSkinForShip(arg0_14.shipVO, iter3_14.id) then
				-- block empty
			elseif var12_14 then
				arg0_14:emit(SwitchSkinMediator.CHANGE_SKIN, arg0_14.shipVO:GetShipPhantomMark(), iter3_14.id == arg0_14.shipVO:getConfig("skin_id") and 0 or iter3_14.id)
				arg0_14:back()
			elseif var9_14 then
				if var10_14 or var13_14 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_skin_out_of_stock"))
				else
					local var0_17 = Goods.Create({
						shop_id = var9_14.id
					}, Goods.TYPE_SKIN)

					if var0_17:isDisCount() and var0_17:IsItemDiscountType() then
						arg0_14:emit(SwitchSkinMediator.BUY_ITEM_BY_ACT, var9_14.id, 1)
					else
						local var1_17 = var0_17:GetPrice()
						local var2_17 = i18n("text_buy_fashion_tip", var1_17, iter3_14.name)

						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = var2_17,
							onYes = function()
								arg0_14:emit(SwitchSkinMediator.BUY_ITEM, var9_14.id, 1)
							end
						})
					end
				end
			end
		end)
		setActive(var2_14, true)
	end
end

function var0_0.getGroupSkinList(arg0_19, arg1_19)
	return getProxy(ShipSkinProxy):GetAllSkinForShip(arg0_19.shipVO)
end

function var0_0.willExit(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.skinCardMap) do
		iter1_20:clear()
	end

	arg0_20:UnOverlayPanel(arg0_20._tf)
end

return var0_0
