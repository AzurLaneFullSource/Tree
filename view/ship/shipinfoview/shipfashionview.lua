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
	arg0_3.styleScroll = arg0_3:findTF("style_scroll", arg0_3.stylePanel)
	arg0_3.styleContainer = arg0_3:findTF("view_port", arg0_3.styleScroll)
	arg0_3.styleCard = arg0_3._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0_3.hideObjToggleTF = findTF(arg0_3._tf, "btns/hideObjToggle")

	setActive(arg0_3.hideObjToggleTF, false)

	arg0_3.hideObjToggle = GetComponent(arg0_3.hideObjToggleTF, typeof(Toggle))

	setText(findTF(arg0_3.hideObjToggleTF, "Label"), i18n("paint_hide_other_obj_tip"))

	arg0_3.shareBtn = findTF(arg0_3._tf, "share_btn")

	setActive(arg0_3.stylePanel, true)
	setActive(arg0_3.styleCard, false)

	arg0_3.fashionSkins = {}
	arg0_3.fashionCellMap = {}
	arg0_3.fashionGroup = 0
	arg0_3.fashionSkinId = 0
	arg0_3.onSelected = false
	arg0_3.isShareSkinFlag = false

	arg0_3:RegisterShareToggle()
	arg0_3:bind(ShipMainMediator.ON_NEXTSHIP_PREPARE, function(arg0_4, arg1_4)
		arg0_3._lastSelectCard = nil

		if arg0_3.isShareSkinFlag and arg1_4 and #arg0_3:GetShareSkins(arg1_4) <= 0 then
			arg0_3.isShareSkinFlag = false
		end
	end)
end

function var0_0.SetShareData(arg0_5, arg1_5)
	arg0_5.shareData = arg1_5
end

function var0_0.GetShipVO(arg0_6)
	if arg0_6.shareData and arg0_6.shareData.shipVO then
		return arg0_6.shareData.shipVO
	end

	return nil
end

function var0_0.SetSkinList(arg0_7, arg1_7)
	arg0_7.skinList = arg1_7
end

function var0_0.UpdateUI(arg0_8)
	triggerToggle(arg0_8.shareBtn, arg0_8.isShareSkinFlag)

	local var0_8 = arg0_8:GetShareSkins(arg0_8:GetShipVO())

	setActive(arg0_8.shareBtn, #var0_8 > 0)
end

function var0_0.OnSelected(arg0_9, arg1_9)
	local var0_9 = pg.UIMgr.GetInstance()

	if arg1_9 then
		var0_9:OverlayPanelPB(arg0_9._parentTf, {
			pbList = {
				arg0_9.stylePanel:Find("style_desc"),
				arg0_9.stylePanel:Find("frame")
			},
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		var0_9:UnOverlayPanel(arg0_9._parentTf, arg0_9.mainPanel)
	end

	arg0_9.onSelected = arg1_9
end

function var0_0.GetShareSkins(arg0_10, arg1_10)
	local var0_10 = getProxy(ShipSkinProxy):GetShareSkinsForShip(arg1_10)

	return (_.map(var0_10, function(arg0_11)
		return pg.ship_skin_template[arg0_11.id]
	end))
end

function var0_0.UpdateAllFashion(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetShipVO()
	local var1_12 = var0_12.groupId

	arg0_12.fashionSkins = arg0_12.isShareSkinFlag and arg0_12:GetShareSkins(var0_12) or arg0_12.shareData:GetGroupSkinList(var1_12)

	if arg0_12.fashionGroup ~= var1_12 or arg1_12 then
		arg0_12.fashionGroup = var1_12

		arg0_12:ResetFashion()

		for iter0_12 = arg0_12.styleContainer.childCount, #arg0_12.fashionSkins - 1 do
			cloneTplTo(arg0_12.styleCard, arg0_12.styleContainer)
		end

		for iter1_12 = #arg0_12.fashionSkins, arg0_12.styleContainer.childCount - 1 do
			local var2_12 = arg0_12.styleContainer:GetChild(iter1_12)

			if arg0_12.fashionCellMap[var2_12] then
				arg0_12.fashionCellMap[var2_12]:clear()
			end

			setActive(var2_12, false)
		end

		for iter2_12, iter3_12 in ipairs(arg0_12.fashionSkins) do
			local var3_12 = iter2_12
			local var4_12 = arg0_12.fashionSkins[iter2_12]
			local var5_12 = arg0_12.styleContainer:GetChild(iter2_12 - 1)
			local var6_12 = arg0_12.fashionCellMap[var5_12]

			if not var6_12 then
				var6_12 = ShipSkinCard.New(var5_12.gameObject)
				arg0_12.fashionCellMap[var5_12] = var6_12
			end

			local var7_12 = arg0_12:GetShipVO():getRemouldSkinId() == var4_12.id and arg0_12:GetShipVO():isRemoulded()
			local var8_12 = arg0_12:GetShipVO():proposeSkinOwned(var4_12) or table.contains(arg0_12.skinList, var4_12.id) or var7_12 or var4_12.skin_type == ShipSkin.SKIN_TYPE_OLD or getProxy(ShipSkinProxy):hasSkin(var4_12.id)

			var6_12:updateData(arg0_12:GetShipVO(), var4_12, var8_12)

			local var9_12 = arg0_12:GetShipVO():useSkin(var4_12.id)

			var6_12:updateUsing(var9_12)
			onButton(arg0_12, var6_12.changeSkinTF, function(arg0_13)
				local var0_13 = ShipGroup.GetChangeSkinNextId(var4_12.id)
				local var1_13 = ShipGroup.GetChangeSkinGroupId(var4_12.id)
				local var2_13 = arg0_12:GetShipVO().id

				if var9_12 then
					ShipGroup.SetShipChangeSkin(var2_13, var1_13, var0_13, true)
				else
					ShipGroup.SetShipChangeSkin(var2_13, var1_13, var0_13, false)
				end
			end, SFX_PANEL)
			onButton(arg0_12, var5_12, function()
				arg0_12:clickCell(var6_12, var4_12)

				arg0_12._lastSelectCard = var3_12
			end)
			setActive(var5_12, true)
		end
	else
		for iter4_12, iter5_12 in ipairs(arg0_12.fashionSkins) do
			local var10_12 = arg0_12.styleContainer:GetChild(iter4_12 - 1)
			local var11_12 = arg0_12.fashionCellMap[var10_12]
			local var12_12 = arg0_12:GetShipVO():getRemouldSkinId() == iter5_12.id and arg0_12:GetShipVO():isRemoulded()
			local var13_12 = arg0_12:GetShipVO():proposeSkinOwned(iter5_12) or table.contains(arg0_12.skinList, iter5_12.id) or var12_12 or iter5_12.skin_type == ShipSkin.SKIN_TYPE_OLD

			var11_12:updateData(arg0_12:GetShipVO(), iter5_12, var13_12)
		end
	end

	arg0_12.fashionSkinId = arg0_12:GetShipVO().skinId

	local var14_12 = arg0_12.styleContainer:GetChild(0)

	for iter6_12, iter7_12 in ipairs(arg0_12.fashionSkins) do
		if iter7_12.id == arg0_12.fashionSkinId then
			var14_12 = arg0_12.styleContainer:GetChild(iter6_12 - 1)

			break
		end
	end

	if arg0_12._lastSelectCard then
		var14_12 = arg0_12.styleContainer:GetChild(arg0_12._lastSelectCard - 1)
		arg0_12._lastSelectCard = nil
	end

	triggerButton(var14_12)
end

function var0_0.clickCell(arg0_15, arg1_15, arg2_15)
	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
		return
	end

	arg0_15.clickCellTime = Time.realtimeSinceStartup
	arg0_15.fashionSkinId = arg2_15.id

	arg0_15:UpdateFashionDetail(arg2_15)
	arg0_15:emit(ShipViewConst.LOAD_PAINTING, arg2_15.painting)
	arg0_15:emit(ShipViewConst.LOAD_PAINTING_BG, arg0_15:GetShipVO():rarity2bgPrintForGet(), arg0_15:GetShipVO():isBluePrintShip(), arg0_15:GetShipVO():isMetaShip())

	for iter0_15, iter1_15 in ipairs(arg0_15.fashionSkins) do
		local var0_15 = arg0_15.styleContainer:GetChild(iter0_15 - 1)
		local var1_15 = arg0_15.fashionCellMap[var0_15]

		var1_15:updateSelected(iter1_15.id == arg0_15.fashionSkinId)
		var1_15:updateUsing(arg0_15:GetShipVO().skinId == iter1_15.id)
	end

	local var2_15 = arg2_15.painting
	local var3_15 = checkABExist("painting/" .. var2_15 .. "_n")

	setActive(arg0_15.hideObjToggle, var3_15)

	if var3_15 then
		arg0_15.hideObjToggle.isOn = PlayerPrefs.GetInt("paint_hide_other_obj_" .. var2_15, 0) ~= 0

		onToggle(arg0_15, arg0_15.hideObjToggleTF, function(arg0_16)
			PlayerPrefs.SetInt("paint_hide_other_obj_" .. var2_15, arg0_16 and 1 or 0)
			arg1_15:flushSkin()
			arg0_15:emit(ShipViewConst.LOAD_PAINTING, var2_15, true)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateFashion(arg0_17, arg1_17)
	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION or not arg0_17.shareData:HasFashion() then
		return
	end

	arg0_17:UpdateAllFashion(arg1_17)
end

function var0_0.ResetFashion(arg0_18)
	arg0_18.fashionSkinId = 0
end

function var0_0.UpdateFashionDetail(arg0_19, arg1_19)
	local var0_19 = arg0_19.fashionDetailWrapper

	if not var0_19 then
		var0_19 = {
			name = findTF(arg0_19.stylePanel, "style_desc/name_bg/name"),
			descTxt = findTF(arg0_19.stylePanel, "style_desc/desc_frame/desc/Text"),
			character = findTF(arg0_19.stylePanel, "style_desc/character"),
			confirm = findTF(arg0_19.stylePanel, "confirm_button"),
			cancel = findTF(arg0_19.stylePanel, "cancel_button")
		}
		var0_19.diamond = findTF(var0_19.confirm, "diamond")
		var0_19.using = findTF(var0_19.confirm, "using")
		var0_19.experience = findTF(var0_19.confirm, "experience")
		var0_19.change = findTF(var0_19.confirm, "change")
		var0_19.buy = findTF(var0_19.confirm, "buy")
		var0_19.activity = findTF(var0_19.confirm, "activity")
		var0_19.cantbuy = findTF(var0_19.confirm, "cantbuy")
		var0_19.prefab = "unknown"
		arg0_19.fashionDetailWrapper = var0_19
	end

	setText(var0_19.name, arg1_19.name)
	setText(var0_19.descTxt, SwitchSpecialChar(arg1_19.desc, true))

	local var1_19 = var0_19.descTxt:GetComponent(typeof(Text))

	if #var1_19.text > 50 then
		var1_19.alignment = TextAnchor.MiddleLeft
	else
		var1_19.alignment = TextAnchor.MiddleCenter
	end

	if var0_19.prefab ~= arg1_19.prefab then
		local var2_19 = var0_19.character:Find(var0_19.prefab)

		if not IsNil(var2_19) then
			PoolMgr.GetInstance():ReturnSpineChar(var0_19.prefab, var2_19.gameObject)
		end

		var0_19.prefab = arg1_19.prefab

		local var3_19 = var0_19.prefab

		PoolMgr.GetInstance():GetSpineChar(var3_19, true, function(arg0_20)
			if var0_19.prefab ~= var3_19 then
				PoolMgr.GetInstance():ReturnSpineChar(var3_19, arg0_20)
			else
				arg0_20.name = var3_19
				arg0_20.transform.localPosition = Vector3.zero
				arg0_20.transform.localScale = Vector3(0.5, 0.5, 1)

				arg0_20.transform:SetParent(var0_19.character, false)
				arg0_20:GetComponent(typeof(SpineAnimUI)):SetAction(arg1_19.show_skin or "stand", 0)
			end
		end)
	end

	local var4_19 = arg0_19:GetShipVO():getRemouldSkinId() == arg1_19.id and arg0_19:GetShipVO():isRemoulded()
	local var5_19 = (arg0_19:GetShipVO():proposeSkinOwned(arg1_19) or table.contains(arg0_19.skinList, arg1_19.id) or var4_19) and 1 or 0
	local var6_19 = arg1_19.shop_id > 0 and pg.shop_template[arg1_19.shop_id] or nil
	local var7_19 = var6_19 and not pg.TimeMgr.GetInstance():inTime(var6_19.time)
	local var8_19 = arg1_19.id == arg0_19:GetShipVO().skinId
	local var9_19 = arg1_19.id == arg0_19:GetShipVO():getConfig("skin_id") or var5_19 >= 1 or arg1_19.skin_type == ShipSkin.SKIN_TYPE_OLD or getProxy(ShipSkinProxy):hasSkin(arg1_19.id)
	local var10_19 = getProxy(ShipSkinProxy):getSkinById(arg1_19.id)
	local var11_19 = getProxy(ShipSkinProxy):InForbiddenSkinListAndShow(arg1_19.id)
	local var12_19 = var8_19 and var10_19 and var10_19:isExpireType()

	setActive(var0_19.using, false)
	setActive(var0_19.change, false)
	setActive(var0_19.buy, false)
	setActive(var0_19.experience, false)

	if var12_19 then
		setGray(var0_19.confirm, false)
		setActive(var0_19.experience, true)
	elseif var8_19 then
		setGray(var0_19.confirm, false)
		setActive(var0_19.using, true)
	elseif var9_19 and ShipSkin.IsShareSkin(arg0_19:GetShipVO(), arg1_19.id) and not ShipSkin.CanUseShareSkinForShip(arg0_19:GetShipVO(), arg1_19.id) then
		setActive(var0_19.change, true)
		setGray(var0_19.confirm, true)
	elseif var9_19 then
		setActive(var0_19.change, true)
		setGray(var0_19.confirm, false)
	elseif var6_19 then
		setActive(var0_19.buy, true)
		setGray(var0_19.confirm, var7_19 or var11_19)
	else
		setActive(var0_19.change, true)
		setGray(var0_19.confirm, true)
	end

	onButton(arg0_19, var0_19.confirm, function()
		if var8_19 then
			if ShipGroup.IsChangeSkin(arg1_19.id) then
				if arg0_19.clickCellTime and Time.realtimeSinceStartup - arg0_19.clickCellTime <= 0.35 then
					return
				end

				arg0_19:SilentTriggerToggleFalse()
				arg0_19:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.DETAIL)
			end
		elseif var9_19 then
			if ShipSkin.IsShareSkin(arg0_19:GetShipVO(), arg1_19.id) and not ShipSkin.CanUseShareSkinForShip(arg0_19:GetShipVO(), arg1_19.id) then
				-- block empty
			else
				arg0_19:emit(ShipMainMediator.CHANGE_SKIN, arg0_19:GetShipVO().id, arg1_19.id == arg0_19:GetShipVO():getConfig("skin_id") and 0 or arg1_19.id)
			end
		elseif var6_19 then
			if var7_19 or var11_19 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_skin_out_of_stock"))
			else
				local var0_21 = Goods.Create({
					shop_id = var6_19.id
				}, Goods.TYPE_SKIN)

				if var0_21:isDisCount() and var0_21:IsItemDiscountType() then
					arg0_19:emit(ShipMainMediator.BUY_ITEM_BY_ACT, var6_19.id, 1)
				else
					local var1_21 = var0_21:GetPrice()
					local var2_21 = i18n("text_buy_fashion_tip", var1_21, arg1_19.name)

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var2_21,
						onYes = function()
							arg0_19:emit(ShipMainMediator.BUY_ITEM, var6_19.id, 1)
						end
					})
				end
			end
		end
	end)
	onButton(arg0_19, var0_19.cancel, function()
		if arg0_19.clickCellTime and Time.realtimeSinceStartup - arg0_19.clickCellTime <= 0.35 then
			return
		end

		arg0_19:SilentTriggerToggleFalse()
		arg0_19:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.DETAIL)
	end)
end

function var0_0.SilentTriggerToggleFalse(arg0_24)
	arg0_24.fashionGroup = false
	arg0_24.isShareSkinFlag = false

	removeOnToggle(arg0_24.shareBtn)
	triggerToggle(arg0_24.shareBtn, false)
	arg0_24:RegisterShareToggle()
end

function var0_0.RegisterShareToggle(arg0_25)
	onToggle(arg0_25, arg0_25.shareBtn, function(arg0_26)
		arg0_25.fashionGroup = false
		arg0_25.isShareSkinFlag = arg0_26

		arg0_25:UpdateFashion()
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_27)
	if arg0_27.fashionDetailWrapper then
		local var0_27 = arg0_27.fashionDetailWrapper
		local var1_27 = var0_27.character:Find(var0_27.prefab)

		if not IsNil(var1_27) then
			PoolMgr.GetInstance():ReturnSpineChar(var0_27.prefab, var1_27.gameObject)
		end
	end

	arg0_27.fashionDetailWrapper = nil

	for iter0_27, iter1_27 in pairs(arg0_27.fashionCellMap) do
		iter1_27:clear()
	end

	arg0_27.fashionCellMap = {}
	arg0_27.fashionSkins = {}
	arg0_27.fashionGroup = 0
	arg0_27.fashionSkinId = 0
	arg0_27.shareData = nil
end

return var0_0
