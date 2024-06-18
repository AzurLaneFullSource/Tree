local var0_0 = class("SwichSkinLayer", import("..base.BaseUI"))

function var0_0.setShip(arg0_1, arg1_1)
	arg0_1.shipVO = arg1_1
end

function var0_0.setShipSkin(arg0_2, arg1_2)
	arg0_2.shipVO.skinId = arg1_2
end

function var0_0.GetShareSkins(arg0_3)
	local var0_3 = getProxy(ShipSkinProxy):GetShareSkinsForShip(arg0_3.shipVO)

	return (_.map(var0_3, function(arg0_4)
		return pg.ship_skin_template[arg0_4.id]
	end))
end

function var0_0.setSkinList(arg0_5, arg1_5)
	arg0_5.skinList = arg1_5
	arg0_5.skins = arg0_5:getGroupSkinList(arg0_5.shipVO.groupId)
	arg0_5.shareSkins = arg0_5:GetShareSkins()
end

function var0_0.getUIName(arg0_6)
	return "SwichSkinLayer"
end

function var0_0.back(arg0_7)
	arg0_7:emit(var0_0.ON_CLOSE)
end

function var0_0.init(arg0_8)
	arg0_8.shareBtn = arg0_8:findTF("select_skin/share_btn")
end

function var0_0.didEnter(arg0_9)
	arg0_9:initSelectSkinPanel()
	triggerToggle(arg0_9.shareBtn, false)
	setActive(arg0_9.shareBtn, #arg0_9.shareSkins > 0)
end

function var0_0.initSelectSkinPanel(arg0_10)
	arg0_10.skinPanel = arg0_10._tf

	local var0_10 = arg0_10:findTF("select_skin/btnBack", arg0_10.skinPanel)
	local var1_10 = arg0_10:findTF("print", arg0_10.skinPanel)

	onButton(arg0_10, var0_10, function()
		arg0_10:back()
	end)
	onButton(arg0_10, var1_10, function()
		arg0_10:back()
	end)
	onToggle(arg0_10, arg0_10.shareBtn, function(arg0_13)
		if arg0_13 then
			arg0_10:Flush(arg0_10.shareSkins)
		else
			arg0_10:Flush(arg0_10.skins)
		end
	end, SFX_PANEL)

	arg0_10.skinScroll = arg0_10:findTF("select_skin/style_scroll", arg0_10.skinPanel)
	arg0_10.skinContainer = arg0_10:findTF("view_port", arg0_10.skinScroll)
	arg0_10.skinCard = arg0_10._go:GetComponent(typeof(ItemList)).prefabItem[0]

	setActive(arg0_10.skinCard, false)

	arg0_10.skinCardMap = {}
end

function var0_0.openSelectSkinPanel(arg0_14)
	arg0_14:Flush(arg0_14.skins)
end

function var0_0.Flush(arg0_15, arg1_15)
	for iter0_15 = arg0_15.skinContainer.childCount, #arg1_15 - 1 do
		cloneTplTo(arg0_15.skinCard, arg0_15.skinContainer)
	end

	for iter1_15 = #arg1_15, arg0_15.skinContainer.childCount - 1 do
		setActive(arg0_15.skinContainer:GetChild(iter1_15), false)
	end

	local var0_15 = arg0_15.skinContainer.childCount

	for iter2_15, iter3_15 in ipairs(arg1_15) do
		local var1_15 = arg0_15.skinContainer:GetChild(iter2_15 - 1)
		local var2_15 = arg0_15.skinCardMap[var1_15]

		if not var2_15 then
			var2_15 = ShipSkinCard.New(var1_15.gameObject)
			arg0_15.skinCardMap[var1_15] = var2_15
		end

		local var3_15 = arg0_15.shipVO:getRemouldSkinId() == iter3_15.id and arg0_15.shipVO:isRemoulded()
		local var4_15 = arg0_15.shipVO:proposeSkinOwned(iter3_15) or table.contains(arg0_15.skinList, iter3_15.id) or var3_15 or iter3_15.skin_type == ShipSkin.SKIN_TYPE_OLD

		var2_15:updateData(arg0_15.shipVO, iter3_15, var4_15)
		var2_15:updateUsing(arg0_15.shipVO.skinId == iter3_15.id)
		removeOnButton(var1_15)

		local var5_15 = arg0_15.shipVO:getRemouldSkinId() == iter3_15.id and arg0_15.shipVO:isRemoulded()
		local var6_15 = (arg0_15.shipVO:proposeSkinOwned(iter3_15) or table.contains(arg0_15.skinList, iter3_15.id) or var5_15) and 1 or 0
		local var7_15 = iter3_15.shop_id > 0 and pg.shop_template[iter3_15.shop_id] or nil
		local var8_15 = var7_15 and not pg.TimeMgr.GetInstance():inTime(var7_15.time)
		local var9_15 = iter3_15.id == arg0_15.shipVO.skinId
		local var10_15 = iter3_15.id == arg0_15.shipVO:getConfig("skin_id") or var6_15 >= 1 or iter3_15.skin_type == ShipSkin.SKIN_TYPE_OLD
		local var11_15 = getProxy(ShipSkinProxy):InForbiddenSkinListAndShow(iter3_15.id)

		onToggle(arg0_15, var2_15.hideObjToggleTF, function(arg0_16)
			PlayerPrefs.SetInt("paint_hide_other_obj_" .. var2_15.paintingName, arg0_16 and 1 or 0)
			var2_15:flushSkin()
			arg0_15:emit(SwichSkinMediator.UPDATE_SKINCONFIG, arg0_15.shipVO.skinId)
		end, SFX_PANEL)
		onButton(arg0_15, var1_15, function()
			if var9_15 then
				arg0_15:back()
			elseif ShipSkin.IsShareSkin(arg0_15.shipVO, iter3_15.id) and not ShipSkin.CanUseShareSkinForShip(arg0_15.shipVO, iter3_15.id) then
				-- block empty
			elseif var10_15 then
				arg0_15:emit(SwichSkinMediator.CHANGE_SKIN, arg0_15.shipVO.id, iter3_15.id == arg0_15.shipVO:getConfig("skin_id") and 0 or iter3_15.id)
				arg0_15:back()
			elseif var7_15 then
				if var8_15 or var11_15 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_skin_out_of_stock"))
				else
					local var0_17 = Goods.Create({
						shop_id = var7_15.id
					}, Goods.TYPE_SKIN)

					if var0_17:isDisCount() and var0_17:IsItemDiscountType() then
						arg0_15:emit(SwichSkinMediator.BUY_ITEM_BY_ACT, var7_15.id, 1)
					else
						local var1_17 = var0_17:GetPrice()
						local var2_17 = i18n("text_buy_fashion_tip", var1_17, iter3_15.name)

						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = var2_17,
							onYes = function()
								arg0_15:emit(SwichSkinMediator.BUY_ITEM, var7_15.id, 1)
							end
						})
					end
				end
			end
		end)
		setActive(var1_15, true)
	end
end

function var0_0.getGroupSkinList(arg0_19, arg1_19)
	return getProxy(ShipSkinProxy):GetAllSkinForShip(arg0_19.shipVO)
end

function var0_0.willExit(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.skinCardMap) do
		iter1_20:clear()
	end
end

return var0_0
