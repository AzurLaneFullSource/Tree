local var0_0 = class("ShipFashionView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShipFashionView"
end

function var0_0.getFashionResList(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = arg0_2.isShareSkinFlag and arg0_2:GetShareSkins(arg1_2) or arg0_2.shareData:GetGroupSkinList(arg1_2.groupId)

	for iter0_2, iter1_2 in ipairs(var1_2) do
		table.insertto(var0_2, ResPathSupport.GetPaintingListByPaintingName(iter1_2.painting))
	end

	return var0_2
end

function var0_0.OnInit(arg0_3)
	arg0_3:InitFashion()
end

function var0_0.InitFashion(arg0_4)
	arg0_4.mainPanel = arg0_4._parentTf.parent
	arg0_4.stylePanel = arg0_4._tf
	arg0_4.styleScroll = arg0_4.stylePanel:Find("style_scroll")
	arg0_4.styleContainer = arg0_4.styleScroll:Find("view_port")
	arg0_4.styleCard = arg0_4.styleContainer:GetChild(0)
	arg0_4.hideObjToggleTF = findTF(arg0_4._tf, "btns/hideObjToggle")

	setActive(arg0_4.hideObjToggleTF, false)

	arg0_4.hideObjToggle = GetComponent(arg0_4.hideObjToggleTF, typeof(Toggle))

	setText(findTF(arg0_4.hideObjToggleTF, "Label"), i18n("paint_hide_other_obj_tip"))

	arg0_4.shareBtn = findTF(arg0_4._tf, "share_btn")
	arg0_4.phantomBtn = arg0_4._tf:Find("phantom_btn")

	onButton(arg0_4, arg0_4.phantomBtn, function()
		local var0_5 = getProxy(TechnologyProxy):getBluePrintById(arg0_4:GetShipVO().groupId)

		arg0_4:emit(ShipMainMediator.OPEN_PHANTOM_LAYER, var0_5 and var0_5:getConfig("blueprint_version") or nil)
	end, SFX_PANEL)
	setParent(arg0_4.phantomBtn, arg0_4._tf.parent)
	setActive(arg0_4.stylePanel, true)
	setActive(arg0_4.styleCard, false)

	arg0_4.fashionSkins = {}
	arg0_4.fashionCellMap = {}
	arg0_4.fashionGroup = 0
	arg0_4.fashionSkinId = 0
	arg0_4.onSelected = false
	arg0_4.isShareSkinFlag = false

	arg0_4:RegisterShareToggle()
	arg0_4:bind(ShipMainMediator.ON_NEXTSHIP_PREPARE, function(arg0_6, arg1_6)
		arg0_4._lastSelectCard = nil

		if arg0_4.isShareSkinFlag and arg1_6 and #arg0_4:GetShareSkins(arg1_6) <= 0 then
			arg0_4.isShareSkinFlag = false
		end
	end)
end

function var0_0.SetShareData(arg0_7, arg1_7)
	arg0_7.shareData = arg1_7
end

function var0_0.GetShipVO(arg0_8)
	if arg0_8.shareData and arg0_8.shareData.shipVO then
		return arg0_8.shareData.shipVO
	end

	return nil
end

function var0_0.SetSkinList(arg0_9, arg1_9)
	arg0_9.skinList = arg1_9
end

function var0_0.UpdateUI(arg0_10)
	triggerToggle(arg0_10.shareBtn, arg0_10.isShareSkinFlag)

	local var0_10 = arg0_10:GetShareSkins(arg0_10:GetShipVO())

	setActive(arg0_10.shareBtn, #var0_10 > 0)
	setActive(arg0_10.phantomBtn, arg0_10:GetShipVO():isBluePrintShip())
end

function var0_0.OnSelected(arg0_11, arg1_11)
	if arg1_11 then
		arg0_11:OverlayPanel(arg0_11._parentTf, {
			pbList = {
				arg0_11.stylePanel:Find("style_desc"),
				arg0_11.stylePanel:Find("frame")
			},
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		arg0_11:UnOverlayPanel(arg0_11._parentTf, arg0_11.mainPanel)
	end

	arg0_11.onSelected = arg1_11
end

function var0_0.GetShareSkins(arg0_12, arg1_12)
	local var0_12 = getProxy(ShipSkinProxy):GetShareSkinsForShip(arg1_12)

	return (_.map(var0_12, function(arg0_13)
		return pg.ship_skin_template[arg0_13.id]
	end))
end

function var0_0.UpdateAllFashion(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetShipVO()

	SplitPackConst.DownloadByLuaArr(arg0_14:getFashionResList(var0_14), function()
		if arg0_14.exited then
			return
		end

		arg0_14:updateAllFashion(arg1_14)
	end)
end

function var0_0.updateAllFashion(arg0_16, arg1_16)
	local var0_16 = arg0_16:GetShipVO()
	local var1_16 = var0_16.groupId

	arg0_16.fashionSkins = arg0_16.isShareSkinFlag and arg0_16:GetShareSkins(var0_16) or arg0_16.shareData:GetGroupSkinList(var1_16)

	if arg0_16.fashionGroup ~= var1_16 or arg1_16 then
		arg0_16.fashionGroup = var1_16

		arg0_16:ResetFashion()

		for iter0_16 = arg0_16.styleContainer.childCount, #arg0_16.fashionSkins - 1 do
			cloneTplTo(arg0_16.styleCard, arg0_16.styleContainer)
		end

		for iter1_16 = #arg0_16.fashionSkins, arg0_16.styleContainer.childCount - 1 do
			local var2_16 = arg0_16.styleContainer:GetChild(iter1_16)

			if arg0_16.fashionCellMap[var2_16] then
				arg0_16.fashionCellMap[var2_16]:clear()
			end

			setActive(var2_16, false)
		end

		for iter2_16, iter3_16 in ipairs(arg0_16.fashionSkins) do
			local var3_16 = iter2_16
			local var4_16 = arg0_16.fashionSkins[iter2_16]
			local var5_16 = arg0_16.styleContainer:GetChild(iter2_16 - 1)
			local var6_16 = arg0_16.fashionCellMap[var5_16]

			if not var6_16 then
				var6_16 = ShipSkinCard.New(var5_16.gameObject)
				arg0_16.fashionCellMap[var5_16] = var6_16
			end

			local var7_16 = arg0_16:GetShipVO():getRemouldSkinId() == var4_16.id and arg0_16:GetShipVO():isRemoulded()
			local var8_16 = arg0_16:GetShipVO():proposeSkinOwned(var4_16) or table.contains(arg0_16.skinList, var4_16.id) or var7_16 or var4_16.skin_type == ShipSkin.SKIN_TYPE_OLD or getProxy(ShipSkinProxy):hasSkin(var4_16.id)

			var6_16:updateData(arg0_16:GetShipVO(), var4_16, var8_16)

			local var9_16 = arg0_16:GetShipVO():useSkin(var4_16.id)

			var6_16:updateUsing(var9_16)
			onButton(arg0_16, var6_16.changeSkinTF, function(arg0_17)
				local var0_17 = ShipSkin.GetChangeSkinNextId(var4_16.id)

				if var9_16 then
					ShipSkin.SetStoreChangeSkinId(var0_17, var0_16:GetShipPhantomMark())
					pg.m02:sendNotification(GAME.CHANGE_SKIN_UPDATE, arg0_16:GetShipVO():GetShipPhantomMark())
				end
			end, SFX_PANEL)
			onButton(arg0_16, var5_16, function()
				arg0_16:clickCell(var6_16, var4_16)

				arg0_16._lastSelectCard = var3_16
			end)
			setActive(var5_16, true)
		end
	else
		for iter4_16, iter5_16 in ipairs(arg0_16.fashionSkins) do
			local var10_16 = arg0_16.styleContainer:GetChild(iter4_16 - 1)
			local var11_16 = arg0_16.fashionCellMap[var10_16]
			local var12_16 = arg0_16:GetShipVO():getRemouldSkinId() == iter5_16.id and arg0_16:GetShipVO():isRemoulded()
			local var13_16 = arg0_16:GetShipVO():proposeSkinOwned(iter5_16) or table.contains(arg0_16.skinList, iter5_16.id) or var12_16 or iter5_16.skin_type == ShipSkin.SKIN_TYPE_OLD or getProxy(ShipSkinProxy):hasSkin(iter5_16.id)

			var11_16:updateData(arg0_16:GetShipVO(), iter5_16, var13_16)
		end
	end

	arg0_16.fashionSkinId = arg0_16:GetShipVO():getSkinId()

	local var14_16 = arg0_16.styleContainer:GetChild(0)

	for iter6_16, iter7_16 in ipairs(arg0_16.fashionSkins) do
		if iter7_16.id == arg0_16.fashionSkinId then
			var14_16 = arg0_16.styleContainer:GetChild(iter6_16 - 1)

			break
		end
	end

	if arg0_16._lastSelectCard then
		var14_16 = arg0_16.styleContainer:GetChild(arg0_16._lastSelectCard - 1)
		arg0_16._lastSelectCard = nil
	end

	triggerButton(var14_16)
end

function var0_0.clickCell(arg0_19, arg1_19, arg2_19)
	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
		return
	end

	arg0_19.clickCellTime = Time.realtimeSinceStartup
	arg0_19.fashionSkinId = arg2_19.id

	arg0_19:UpdateFashionDetail(arg2_19)
	arg0_19:emit(ShipViewConst.LOAD_PAINTING, arg2_19.painting)
	arg0_19:emit(ShipViewConst.LOAD_PAINTING_BG, arg0_19:GetShipVO():rarity2bgPrintForGet(), arg0_19:GetShipVO():isBluePrintShip(), arg0_19:GetShipVO():isMetaShip())

	for iter0_19, iter1_19 in ipairs(arg0_19.fashionSkins) do
		local var0_19 = arg0_19.styleContainer:GetChild(iter0_19 - 1)
		local var1_19 = arg0_19.fashionCellMap[var0_19]

		var1_19:updateSelected(iter1_19.id == arg0_19.fashionSkinId)
		var1_19:updateUsing(arg0_19:GetShipVO():useSkin(iter1_19.id))
	end

	local var2_19 = arg2_19.painting
	local var3_19 = checkABExist("painting/" .. var2_19 .. "_n")

	setActive(arg0_19.hideObjToggle, var3_19)

	if var3_19 then
		arg0_19.hideObjToggle.isOn = PlayerPrefs.GetInt("paint_hide_other_obj_" .. var2_19, 0) ~= 0

		onToggle(arg0_19, arg0_19.hideObjToggleTF, function(arg0_20)
			PlayerPrefs.SetInt("paint_hide_other_obj_" .. var2_19, arg0_20 and 1 or 0)
			arg1_19:flushSkin()
			arg0_19:emit(ShipViewConst.LOAD_PAINTING, var2_19, true)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateFashion(arg0_21, arg1_21)
	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION or not arg0_21.shareData:HasFashion() then
		return
	end

	arg0_21:UpdateAllFashion(arg1_21)
end

function var0_0.ResetFashion(arg0_22)
	arg0_22.fashionSkinId = 0
end

function var0_0.UpdateFashionDetail(arg0_23, arg1_23)
	local var0_23 = arg0_23.fashionDetailWrapper

	if not var0_23 then
		var0_23 = {
			name = findTF(arg0_23.stylePanel, "style_desc/name_bg/name"),
			descTxt = findTF(arg0_23.stylePanel, "style_desc/desc_frame/desc/Text"),
			character = findTF(arg0_23.stylePanel, "style_desc/character"),
			confirm = findTF(arg0_23.stylePanel, "confirm_button"),
			cancel = findTF(arg0_23.stylePanel, "cancel_button")
		}
		var0_23.diamond = findTF(var0_23.confirm, "diamond")
		var0_23.using = findTF(var0_23.confirm, "using")
		var0_23.experience = findTF(var0_23.confirm, "experience")
		var0_23.change = findTF(var0_23.confirm, "change")
		var0_23.buy = findTF(var0_23.confirm, "buy")
		var0_23.activity = findTF(var0_23.confirm, "activity")
		var0_23.cantbuy = findTF(var0_23.confirm, "cantbuy")
		var0_23.prefab = "unknown"
		arg0_23.fashionDetailWrapper = var0_23
	end

	setText(var0_23.name, arg1_23.name)
	setText(var0_23.descTxt, SwitchSpecialChar(arg1_23.desc, true))

	local var1_23 = var0_23.descTxt:GetComponent(typeof(Text))

	if #var1_23.text > 50 then
		var1_23.alignment = TextAnchor.MiddleLeft
	else
		var1_23.alignment = TextAnchor.MiddleCenter
	end

	if var0_23.prefab ~= arg1_23.prefab then
		local var2_23 = var0_23.character:Find(var0_23.prefab)

		if not IsNil(var2_23) then
			PoolMgr.GetInstance():ReturnSpineChar(var0_23.prefab, var2_23.gameObject)
		end

		var0_23.prefab = arg1_23.prefab

		local var3_23 = var0_23.prefab

		arg0_23.spineChar = SpineAnimChar.New()

		arg0_23.spineChar:SetPaint(var3_23)
		arg0_23.spineChar:Load(true, function(arg0_24)
			if var0_23.prefab ~= var3_23 then
				arg0_24:Dispose()
			else
				arg0_24:SetName(var3_23)
				arg0_24:SetLocalPosition(Vector3.zero)
				arg0_24:SetLocalScale(Vector3(0.5, 0.5, 1))
				arg0_24:SetParent(var0_23.character)
				arg0_24:SetAction(arg1_23.show_skin or "stand", 0)
			end
		end)
	end

	local var4_23 = arg0_23:GetShipVO():getRemouldSkinId() == arg1_23.id and arg0_23:GetShipVO():isRemoulded()
	local var5_23 = (arg0_23:GetShipVO():proposeSkinOwned(arg1_23) or table.contains(arg0_23.skinList, arg1_23.id) or var4_23) and 1 or 0
	local var6_23 = arg1_23.shop_id > 0 and ShopConst.GetShopConfig(arg1_23.shop_id) or nil
	local var7_23 = var6_23 and not pg.TimeMgr.GetInstance():inTime(var6_23.time)
	local var8_23 = arg1_23.id == arg0_23:GetShipVO():getSkinId()
	local var9_23 = arg1_23.id == arg0_23:GetShipVO():getConfig("skin_id") or var5_23 >= 1 or arg1_23.skin_type == ShipSkin.SKIN_TYPE_OLD or getProxy(ShipSkinProxy):hasSkin(arg1_23.id)
	local var10_23 = getProxy(ShipSkinProxy):getSkinById(arg1_23.id)
	local var11_23 = getProxy(ShipSkinProxy):InForbiddenSkinListAndShow(arg1_23.id)
	local var12_23 = var8_23 and var10_23 and var10_23:isExpireType()

	setActive(var0_23.using, false)
	setActive(var0_23.change, false)
	setActive(var0_23.buy, false)
	setActive(var0_23.experience, false)

	if var12_23 then
		setGray(var0_23.confirm, false)
		setActive(var0_23.experience, true)
	elseif var8_23 then
		setGray(var0_23.confirm, false)
		setActive(var0_23.using, true)
	elseif var9_23 and ShipSkin.IsShareSkin(arg0_23:GetShipVO(), arg1_23.id) and not ShipSkin.CanUseShareSkinForShip(arg0_23:GetShipVO(), arg1_23.id) then
		setActive(var0_23.change, true)
		setGray(var0_23.confirm, true)
	elseif var9_23 then
		setActive(var0_23.change, true)
		setGray(var0_23.confirm, false)
	elseif var6_23 then
		setActive(var0_23.buy, true)
		setGray(var0_23.confirm, var7_23 or var11_23)
	else
		setActive(var0_23.change, true)
		setGray(var0_23.confirm, true)
	end

	onButton(arg0_23, var0_23.confirm, function()
		if var8_23 then
			if ShipSkin.IsChangeSkin(arg1_23.id) then
				if arg0_23.clickCellTime and Time.realtimeSinceStartup - arg0_23.clickCellTime <= 0.35 then
					return
				end

				arg0_23:SilentTriggerToggleFalse()
				arg0_23:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.DETAIL)
			end
		elseif var9_23 then
			if ShipSkin.IsShareSkin(arg0_23:GetShipVO(), arg1_23.id) and not ShipSkin.CanUseShareSkinForShip(arg0_23:GetShipVO(), arg1_23.id) then
				-- block empty
			else
				arg0_23:emit(ShipMainMediator.CHANGE_SKIN, arg0_23:GetShipVO().id, arg1_23.id == arg0_23:GetShipVO():getConfig("skin_id") and 0 or arg1_23.id)
			end
		elseif var6_23 then
			if var7_23 or var11_23 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_skin_out_of_stock"))
			else
				local var0_25 = Goods.Create({
					shop_id = var6_23.id
				}, Goods.TYPE_SKIN)

				if var0_25:isDisCount() and var0_25:IsItemDiscountType() then
					arg0_23:emit(ShipMainMediator.BUY_ITEM_BY_ACT, var6_23.id, 1)
				else
					local var1_25 = var0_25:GetPrice()
					local var2_25 = i18n("text_buy_fashion_tip", var1_25, arg1_23.name)

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var2_25,
						onYes = function()
							arg0_23:emit(ShipMainMediator.BUY_ITEM, var6_23.id, 1)
						end
					})
				end
			end
		end
	end)
	onButton(arg0_23, var0_23.cancel, function()
		if arg0_23.clickCellTime and Time.realtimeSinceStartup - arg0_23.clickCellTime <= 0.35 then
			return
		end

		arg0_23:SilentTriggerToggleFalse()
		arg0_23:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.DETAIL)
	end)
end

function var0_0.SilentTriggerToggleFalse(arg0_28)
	arg0_28.fashionGroup = false
	arg0_28.isShareSkinFlag = false

	removeOnToggle(arg0_28.shareBtn)
	triggerToggle(arg0_28.shareBtn, false)
	arg0_28:RegisterShareToggle()
end

function var0_0.RegisterShareToggle(arg0_29)
	onToggle(arg0_29, arg0_29.shareBtn, function(arg0_30)
		arg0_29.fashionGroup = false
		arg0_29.isShareSkinFlag = arg0_30

		arg0_29:UpdateFashion()
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_31)
	setParent(arg0_31.phantomBtn, arg0_31._tf)

	if arg0_31.fashionDetailWrapper then
		local var0_31 = arg0_31.fashionDetailWrapper

		if var0_31.character:Find(var0_31.prefab) and arg0_31.spineChar then
			arg0_31.spineChar:Dispose()

			arg0_31.spineChar = nil
		end
	end

	arg0_31.fashionDetailWrapper = nil

	for iter0_31, iter1_31 in pairs(arg0_31.fashionCellMap) do
		iter1_31:clear()
	end

	arg0_31.fashionCellMap = {}
	arg0_31.fashionSkins = {}
	arg0_31.fashionGroup = 0
	arg0_31.fashionSkinId = 0
	arg0_31.shareData = nil
end

return var0_0
