local var0 = class("SwichSkinLayer", import("..base.BaseUI"))

function var0.setShip(arg0, arg1)
	arg0.shipVO = arg1
end

function var0.setShipSkin(arg0, arg1)
	arg0.shipVO.skinId = arg1
end

function var0.GetShareSkins(arg0)
	local var0 = getProxy(ShipSkinProxy):GetShareSkinsForShip(arg0.shipVO)

	return (_.map(var0, function(arg0)
		return pg.ship_skin_template[arg0.id]
	end))
end

function var0.setSkinList(arg0, arg1)
	arg0.skinList = arg1
	arg0.skins = arg0:getGroupSkinList(arg0.shipVO.groupId)
	arg0.shareSkins = arg0:GetShareSkins()
end

function var0.getUIName(arg0)
	return "SwichSkinLayer"
end

function var0.back(arg0)
	arg0:emit(var0.ON_CLOSE)
end

function var0.init(arg0)
	arg0.shareBtn = arg0:findTF("select_skin/share_btn")
end

function var0.didEnter(arg0)
	arg0:initSelectSkinPanel()
	triggerToggle(arg0.shareBtn, false)
	setActive(arg0.shareBtn, #arg0.shareSkins > 0)
end

function var0.initSelectSkinPanel(arg0)
	arg0.skinPanel = arg0._tf

	local var0 = arg0:findTF("select_skin/btnBack", arg0.skinPanel)
	local var1 = arg0:findTF("print", arg0.skinPanel)

	onButton(arg0, var0, function()
		arg0:back()
	end)
	onButton(arg0, var1, function()
		arg0:back()
	end)
	onToggle(arg0, arg0.shareBtn, function(arg0)
		if arg0 then
			arg0:Flush(arg0.shareSkins)
		else
			arg0:Flush(arg0.skins)
		end
	end, SFX_PANEL)

	arg0.skinScroll = arg0:findTF("select_skin/style_scroll", arg0.skinPanel)
	arg0.skinContainer = arg0:findTF("view_port", arg0.skinScroll)
	arg0.skinCard = arg0._go:GetComponent(typeof(ItemList)).prefabItem[0]

	setActive(arg0.skinCard, false)

	arg0.skinCardMap = {}
end

function var0.openSelectSkinPanel(arg0)
	arg0:Flush(arg0.skins)
end

function var0.Flush(arg0, arg1)
	for iter0 = arg0.skinContainer.childCount, #arg1 - 1 do
		cloneTplTo(arg0.skinCard, arg0.skinContainer)
	end

	for iter1 = #arg1, arg0.skinContainer.childCount - 1 do
		setActive(arg0.skinContainer:GetChild(iter1), false)
	end

	local var0 = arg0.skinContainer.childCount

	for iter2, iter3 in ipairs(arg1) do
		local var1 = arg0.skinContainer:GetChild(iter2 - 1)
		local var2 = arg0.skinCardMap[var1]

		if not var2 then
			var2 = ShipSkinCard.New(var1.gameObject)
			arg0.skinCardMap[var1] = var2
		end

		local var3 = arg0.shipVO:getRemouldSkinId() == iter3.id and arg0.shipVO:isRemoulded()
		local var4 = arg0.shipVO:proposeSkinOwned(iter3) or table.contains(arg0.skinList, iter3.id) or var3 or iter3.skin_type == ShipSkin.SKIN_TYPE_OLD

		var2:updateData(arg0.shipVO, iter3, var4)
		var2:updateUsing(arg0.shipVO.skinId == iter3.id)
		removeOnButton(var1)

		local var5 = arg0.shipVO:getRemouldSkinId() == iter3.id and arg0.shipVO:isRemoulded()
		local var6 = (arg0.shipVO:proposeSkinOwned(iter3) or table.contains(arg0.skinList, iter3.id) or var5) and 1 or 0
		local var7 = iter3.shop_id > 0 and pg.shop_template[iter3.shop_id] or nil
		local var8 = var7 and not pg.TimeMgr.GetInstance():inTime(var7.time)
		local var9 = iter3.id == arg0.shipVO.skinId
		local var10 = iter3.id == arg0.shipVO:getConfig("skin_id") or var6 >= 1 or iter3.skin_type == ShipSkin.SKIN_TYPE_OLD
		local var11 = getProxy(ShipSkinProxy):InForbiddenSkinListAndShow(iter3.id)

		onToggle(arg0, var2.hideObjToggleTF, function(arg0)
			PlayerPrefs.SetInt("paint_hide_other_obj_" .. var2.paintingName, arg0 and 1 or 0)
			var2:flushSkin()
			arg0:emit(SwichSkinMediator.UPDATE_SKINCONFIG, arg0.shipVO.skinId)
		end, SFX_PANEL)
		onButton(arg0, var1, function()
			if var9 then
				arg0:back()
			elseif ShipSkin.IsShareSkin(arg0.shipVO, iter3.id) and not ShipSkin.CanUseShareSkinForShip(arg0.shipVO, iter3.id) then
				-- block empty
			elseif var10 then
				arg0:emit(SwichSkinMediator.CHANGE_SKIN, arg0.shipVO.id, iter3.id == arg0.shipVO:getConfig("skin_id") and 0 or iter3.id)
				arg0:back()
			elseif var7 then
				if var8 or var11 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_skin_out_of_stock"))
				else
					local var0 = Goods.Create({
						shop_id = var7.id
					}, Goods.TYPE_SKIN)

					if var0:isDisCount() and var0:IsItemDiscountType() then
						arg0:emit(SwichSkinMediator.BUY_ITEM_BY_ACT, var7.id, 1)
					else
						local var1 = var0:GetPrice()
						local var2 = i18n("text_buy_fashion_tip", var1, iter3.name)

						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = var2,
							onYes = function()
								arg0:emit(SwichSkinMediator.BUY_ITEM, var7.id, 1)
							end
						})
					end
				end
			end
		end)
		setActive(var1, true)
	end
end

function var0.getGroupSkinList(arg0, arg1)
	return getProxy(ShipSkinProxy):GetAllSkinForShip(arg0.shipVO)
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.skinCardMap) do
		iter1:clear()
	end
end

return var0
