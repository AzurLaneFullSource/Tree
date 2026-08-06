local var0_0 = class("ShipFashionView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShipFashionView"
end

function var0_0.OnInit(arg0_2)
	arg0_2:InitFashion()
end

function var0_0.InitFashion(arg0_3)
	arg0_3.mainPanel = arg0_3._parentTf.parent
	arg0_3.stylePanel = arg0_3._tf
	arg0_3.styleScroll = arg0_3.stylePanel:Find("style_scroll")
	arg0_3.styleContainer = arg0_3.styleScroll:Find("view_port")
	arg0_3.styleCard = arg0_3.styleContainer:GetChild(0)
	arg0_3.hideObjToggleTF = findTF(arg0_3._tf, "btns/hideObjToggle")

	setActive(arg0_3.hideObjToggleTF, false)

	arg0_3.hideObjToggle = GetComponent(arg0_3.hideObjToggleTF, typeof(Toggle))

	setText(findTF(arg0_3.hideObjToggleTF, "Label"), i18n("paint_hide_other_obj_tip"))

	arg0_3.shareBtn = findTF(arg0_3._tf, "share_btn")
	arg0_3.phantomBtn = arg0_3._tf:Find("phantom_btn")

	onButton(arg0_3, arg0_3.phantomBtn, function()
		local var0_4 = getProxy(TechnologyProxy):getBluePrintById(arg0_3:GetShipVO().groupId)

		arg0_3:emit(ShipMainMediator.OPEN_PHANTOM_LAYER, var0_4 and var0_4:getConfig("blueprint_version") or nil)
	end, SFX_PANEL)
	setParent(arg0_3.phantomBtn, arg0_3._tf.parent)
	setActive(arg0_3.stylePanel, true)
	setActive(arg0_3.styleCard, false)

	arg0_3.fashionSkins = {}
	arg0_3.fashionCellMap = {}
	arg0_3.fashionGroup = 0
	arg0_3.fashionSkinId = 0
	arg0_3.onSelected = false
	arg0_3.isShareSkinFlag = false

	arg0_3:RegisterShareToggle()
	arg0_3:bind(ShipMainMediator.ON_NEXTSHIP_PREPARE, function(arg0_5, arg1_5)
		arg0_3._lastSelectCard = nil

		if arg0_3.isShareSkinFlag and arg1_5 and #arg0_3:GetShareSkins(arg1_5) <= 0 then
			arg0_3.isShareSkinFlag = false
		end
	end)
end

function var0_0.SetShareData(arg0_6, arg1_6)
	arg0_6.shareData = arg1_6
end

function var0_0.GetShipVO(arg0_7)
	if arg0_7.shareData and arg0_7.shareData.shipVO then
		return arg0_7.shareData.shipVO
	end

	return nil
end

function var0_0.SetSkinList(arg0_8, arg1_8)
	arg0_8.skinList = arg1_8
end

function var0_0.UpdateUI(arg0_9)
	triggerToggle(arg0_9.shareBtn, arg0_9.isShareSkinFlag)

	local var0_9 = arg0_9:GetShareSkins(arg0_9:GetShipVO())

	setActive(arg0_9.shareBtn, #var0_9 > 0)
	setActive(arg0_9.phantomBtn, arg0_9:GetShipVO():isBluePrintShip())
end

function var0_0.OnSelected(arg0_10, arg1_10)
	if arg1_10 then
		arg0_10:OverlayPanel(arg0_10._parentTf, {
			pbList = {
				arg0_10.stylePanel:Find("style_desc"),
				arg0_10.stylePanel:Find("frame")
			},
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		arg0_10:UnOverlayPanel(arg0_10._parentTf, arg0_10.mainPanel)
	end

	arg0_10.onSelected = arg1_10
end

function var0_0.GetShareSkins(arg0_11, arg1_11)
	local var0_11 = getProxy(ShipSkinProxy):GetShareSkinsForShip(arg1_11)

	return (_.map(var0_11, function(arg0_12)
		return pg.ship_skin_template[arg0_12.id]
	end))
end

function var0_0.UpdateAllFashion(arg0_13, arg1_13)
	local var0_13 = arg0_13:GetShipVO()
	local var1_13 = var0_13.groupId

	arg0_13.fashionSkins = arg0_13.isShareSkinFlag and arg0_13:GetShareSkins(var0_13) or arg0_13.shareData:GetGroupSkinList(var1_13)

	if arg0_13.fashionGroup ~= var1_13 or arg1_13 then
		arg0_13.fashionGroup = var1_13

		arg0_13:ResetFashion()

		for iter0_13 = arg0_13.styleContainer.childCount, #arg0_13.fashionSkins - 1 do
			cloneTplTo(arg0_13.styleCard, arg0_13.styleContainer)
		end

		for iter1_13 = #arg0_13.fashionSkins, arg0_13.styleContainer.childCount - 1 do
			local var2_13 = arg0_13.styleContainer:GetChild(iter1_13)

			if arg0_13.fashionCellMap[var2_13] then
				arg0_13.fashionCellMap[var2_13]:clear()
			end

			setActive(var2_13, false)
		end

		for iter2_13, iter3_13 in ipairs(arg0_13.fashionSkins) do
			local var3_13 = iter2_13
			local var4_13 = arg0_13.fashionSkins[iter2_13]
			local var5_13 = arg0_13.styleContainer:GetChild(iter2_13 - 1)
			local var6_13 = arg0_13.fashionCellMap[var5_13]

			if not var6_13 then
				var6_13 = ShipSkinCard.New(var5_13.gameObject)
				arg0_13.fashionCellMap[var5_13] = var6_13
			end

			local var7_13 = arg0_13:GetShipVO():getRemouldSkinId() == var4_13.id and arg0_13:GetShipVO():isRemoulded()
			local var8_13 = arg0_13:GetShipVO():proposeSkinOwned(var4_13) or table.contains(arg0_13.skinList, var4_13.id) or var7_13 or var4_13.skin_type == ShipSkin.SKIN_TYPE_OLD or getProxy(ShipSkinProxy):hasSkin(var4_13.id)

			var6_13:updateData(arg0_13:GetShipVO(), var4_13, var8_13)

			local var9_13 = arg0_13:GetShipVO():useSkin(var4_13.id)

			var6_13:updateUsing(var9_13)
			onButton(arg0_13, var6_13.changeSkinTF, function(arg0_14)
				local var0_14 = ShipSkin.GetChangeSkinNextId(var4_13.id)

				if var9_13 then
					ShipSkin.SetStoreChangeSkinId(var0_14, var0_13:GetShipPhantomMark())
					pg.m02:sendNotification(GAME.CHANGE_SKIN_UPDATE, arg0_13:GetShipVO():GetShipPhantomMark())
				end
			end, SFX_PANEL)
			onButton(arg0_13, var5_13, function()
				arg0_13:clickCell(var6_13, var4_13)

				arg0_13._lastSelectCard = var3_13
			end)
			setActive(var5_13, true)
		end
	else
		for iter4_13, iter5_13 in ipairs(arg0_13.fashionSkins) do
			local var10_13 = arg0_13.styleContainer:GetChild(iter4_13 - 1)
			local var11_13 = arg0_13.fashionCellMap[var10_13]
			local var12_13 = arg0_13:GetShipVO():getRemouldSkinId() == iter5_13.id and arg0_13:GetShipVO():isRemoulded()
			local var13_13 = arg0_13:GetShipVO():proposeSkinOwned(iter5_13) or table.contains(arg0_13.skinList, iter5_13.id) or var12_13 or iter5_13.skin_type == ShipSkin.SKIN_TYPE_OLD or getProxy(ShipSkinProxy):hasSkin(iter5_13.id)

			var11_13:updateData(arg0_13:GetShipVO(), iter5_13, var13_13)
		end
	end

	arg0_13.fashionSkinId = arg0_13:GetShipVO():getSkinId()

	local var14_13 = arg0_13.styleContainer:GetChild(0)

	for iter6_13, iter7_13 in ipairs(arg0_13.fashionSkins) do
		if iter7_13.id == arg0_13.fashionSkinId then
			var14_13 = arg0_13.styleContainer:GetChild(iter6_13 - 1)

			break
		end
	end

	if arg0_13._lastSelectCard then
		var14_13 = arg0_13.styleContainer:GetChild(arg0_13._lastSelectCard - 1)
		arg0_13._lastSelectCard = nil
	end

	triggerButton(var14_13)
end

function var0_0.clickCell(arg0_16, arg1_16, arg2_16)
	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
		return
	end

	arg0_16.clickCellTime = Time.realtimeSinceStartup
	arg0_16.fashionSkinId = arg2_16.id

	arg0_16:UpdateFashionDetail(arg2_16)
	arg0_16:emit(ShipViewConst.LOAD_PAINTING, arg2_16.painting)
	arg0_16:emit(ShipViewConst.LOAD_PAINTING_BG, arg0_16:GetShipVO():rarity2bgPrintForGet(), arg0_16:GetShipVO():isBluePrintShip(), arg0_16:GetShipVO():isMetaShip())

	for iter0_16, iter1_16 in ipairs(arg0_16.fashionSkins) do
		local var0_16 = arg0_16.styleContainer:GetChild(iter0_16 - 1)
		local var1_16 = arg0_16.fashionCellMap[var0_16]

		var1_16:updateSelected(iter1_16.id == arg0_16.fashionSkinId)
		var1_16:updateUsing(arg0_16:GetShipVO():useSkin(iter1_16.id))
	end

	local var2_16 = arg2_16.painting
	local var3_16 = checkABExist("painting/" .. var2_16 .. "_n")

	setActive(arg0_16.hideObjToggle, var3_16)

	if var3_16 then
		arg0_16.hideObjToggle.isOn = PlayerPrefs.GetInt("paint_hide_other_obj_" .. var2_16, 0) ~= 0

		onToggle(arg0_16, arg0_16.hideObjToggleTF, function(arg0_17)
			PlayerPrefs.SetInt("paint_hide_other_obj_" .. var2_16, arg0_17 and 1 or 0)
			arg1_16:flushSkin()
			arg0_16:emit(ShipViewConst.LOAD_PAINTING, var2_16, true)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateFashion(arg0_18, arg1_18)
	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION or not arg0_18.shareData:HasFashion() then
		return
	end

	arg0_18:UpdateAllFashion(arg1_18)
end

function var0_0.ResetFashion(arg0_19)
	arg0_19.fashionSkinId = 0
end

function var0_0.UpdateFashionDetail(arg0_20, arg1_20)
	local var0_20 = arg0_20.fashionDetailWrapper

	if not var0_20 then
		var0_20 = {
			name = findTF(arg0_20.stylePanel, "style_desc/name_bg/name"),
			descTxt = findTF(arg0_20.stylePanel, "style_desc/desc_frame/desc/Text"),
			character = findTF(arg0_20.stylePanel, "style_desc/character"),
			confirm = findTF(arg0_20.stylePanel, "confirm_button"),
			cancel = findTF(arg0_20.stylePanel, "cancel_button")
		}
		var0_20.diamond = findTF(var0_20.confirm, "diamond")
		var0_20.using = findTF(var0_20.confirm, "using")
		var0_20.experience = findTF(var0_20.confirm, "experience")
		var0_20.change = findTF(var0_20.confirm, "change")
		var0_20.buy = findTF(var0_20.confirm, "buy")
		var0_20.activity = findTF(var0_20.confirm, "activity")
		var0_20.cantbuy = findTF(var0_20.confirm, "cantbuy")
		var0_20.prefab = "unknown"
		arg0_20.fashionDetailWrapper = var0_20
	end

	setText(var0_20.name, arg1_20.name)
	setText(var0_20.descTxt, SwitchSpecialChar(arg1_20.desc, true))

	local var1_20 = var0_20.descTxt:GetComponent(typeof(Text))

	if #var1_20.text > 50 then
		var1_20.alignment = TextAnchor.MiddleLeft
	else
		var1_20.alignment = TextAnchor.MiddleCenter
	end

	if var0_20.prefab ~= arg1_20.prefab then
		local var2_20 = var0_20.character:Find(var0_20.prefab)

		if not IsNil(var2_20) then
			PoolMgr.GetInstance():ReturnSpineChar(var0_20.prefab, var2_20.gameObject)
		end

		var0_20.prefab = arg1_20.prefab

		local var3_20 = var0_20.prefab

		arg0_20.spineChar = SpineAnimChar.New()

		arg0_20.spineChar:SetPaint(var3_20)
		arg0_20.spineChar:Load(true, function(arg0_21)
			if var0_20.prefab ~= var3_20 then
				arg0_21:Dispose()
			else
				arg0_21:SetName(var3_20)
				arg0_21:SetLocalPosition(Vector3.zero)
				arg0_21:SetLocalScale(Vector3(0.5, 0.5, 1))
				arg0_21:SetParent(var0_20.character)
				arg0_21:SetAction(arg1_20.show_skin or "stand", 0)
			end
		end)
	end

	local var4_20 = arg0_20:GetShipVO():getRemouldSkinId() == arg1_20.id and arg0_20:GetShipVO():isRemoulded()
	local var5_20 = (arg0_20:GetShipVO():proposeSkinOwned(arg1_20) or table.contains(arg0_20.skinList, arg1_20.id) or var4_20) and 1 or 0
	local var6_20 = arg1_20.shop_id > 0 and pg.shop_template[arg1_20.shop_id] or nil
	local var7_20 = var6_20 and not pg.TimeMgr.GetInstance():inTime(var6_20.time)
	local var8_20 = arg1_20.id == arg0_20:GetShipVO():getSkinId()
	local var9_20 = arg1_20.id == arg0_20:GetShipVO():getConfig("skin_id") or var5_20 >= 1 or arg1_20.skin_type == ShipSkin.SKIN_TYPE_OLD or getProxy(ShipSkinProxy):hasSkin(arg1_20.id)
	local var10_20 = getProxy(ShipSkinProxy):getSkinById(arg1_20.id)
	local var11_20 = getProxy(ShipSkinProxy):InForbiddenSkinListAndShow(arg1_20.id)
	local var12_20 = var8_20 and var10_20 and var10_20:isExpireType()

	setActive(var0_20.using, false)
	setActive(var0_20.change, false)
	setActive(var0_20.buy, false)
	setActive(var0_20.experience, false)

	if var12_20 then
		setGray(var0_20.confirm, false)
		setActive(var0_20.experience, true)
	elseif var8_20 then
		setGray(var0_20.confirm, false)
		setActive(var0_20.using, true)
	elseif var9_20 and ShipSkin.IsShareSkin(arg0_20:GetShipVO(), arg1_20.id) and not ShipSkin.CanUseShareSkinForShip(arg0_20:GetShipVO(), arg1_20.id) then
		setActive(var0_20.change, true)
		setGray(var0_20.confirm, true)
	elseif var9_20 then
		setActive(var0_20.change, true)
		setGray(var0_20.confirm, false)
	elseif var6_20 then
		setActive(var0_20.buy, true)
		setGray(var0_20.confirm, var7_20 or var11_20)
	else
		setActive(var0_20.change, true)
		setGray(var0_20.confirm, true)
	end

	onButton(arg0_20, var0_20.confirm, function()
		if var8_20 then
			if ShipSkin.IsChangeSkin(arg1_20.id) then
				if arg0_20.clickCellTime and Time.realtimeSinceStartup - arg0_20.clickCellTime <= 0.35 then
					return
				end

				arg0_20:SilentTriggerToggleFalse()
				arg0_20:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.DETAIL)
			end
		elseif var9_20 then
			if ShipSkin.IsShareSkin(arg0_20:GetShipVO(), arg1_20.id) and not ShipSkin.CanUseShareSkinForShip(arg0_20:GetShipVO(), arg1_20.id) then
				-- block empty
			else
				arg0_20:emit(ShipMainMediator.CHANGE_SKIN, arg0_20:GetShipVO().id, arg1_20.id == arg0_20:GetShipVO():getConfig("skin_id") and 0 or arg1_20.id)
			end
		elseif var6_20 then
			if var7_20 or var11_20 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_skin_out_of_stock"))
			else
				local var0_22 = Goods.Create({
					shop_id = var6_20.id
				}, Goods.TYPE_SKIN)

				if var0_22:isDisCount() and var0_22:IsItemDiscountType() then
					arg0_20:emit(ShipMainMediator.BUY_ITEM_BY_ACT, var6_20.id, 1)
				else
					local var1_22 = var0_22:GetPrice()
					local var2_22 = i18n("text_buy_fashion_tip", var1_22, arg1_20.name)

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var2_22,
						onYes = function()
							arg0_20:emit(ShipMainMediator.BUY_ITEM, var6_20.id, 1)
						end
					})
				end
			end
		end
	end)
	onButton(arg0_20, var0_20.cancel, function()
		if arg0_20.clickCellTime and Time.realtimeSinceStartup - arg0_20.clickCellTime <= 0.35 then
			return
		end

		arg0_20:SilentTriggerToggleFalse()
		arg0_20:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.DETAIL)
	end)
end

function var0_0.SilentTriggerToggleFalse(arg0_25)
	arg0_25.fashionGroup = false
	arg0_25.isShareSkinFlag = false

	removeOnToggle(arg0_25.shareBtn)
	triggerToggle(arg0_25.shareBtn, false)
	arg0_25:RegisterShareToggle()
end

function var0_0.RegisterShareToggle(arg0_26)
	onToggle(arg0_26, arg0_26.shareBtn, function(arg0_27)
		arg0_26.fashionGroup = false
		arg0_26.isShareSkinFlag = arg0_27

		arg0_26:UpdateFashion()
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_28)
	setParent(arg0_28.phantomBtn, arg0_28._tf)

	if arg0_28.fashionDetailWrapper then
		local var0_28 = arg0_28.fashionDetailWrapper

		if var0_28.character:Find(var0_28.prefab) and arg0_28.spineChar then
			arg0_28.spineChar:Dispose()

			arg0_28.spineChar = nil
		end
	end

	arg0_28.fashionDetailWrapper = nil

	for iter0_28, iter1_28 in pairs(arg0_28.fashionCellMap) do
		iter1_28:clear()
	end

	arg0_28.fashionCellMap = {}
	arg0_28.fashionSkins = {}
	arg0_28.fashionGroup = 0
	arg0_28.fashionSkinId = 0
	arg0_28.shareData = nil
end

return var0_0
