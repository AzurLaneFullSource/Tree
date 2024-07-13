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
			local var3_12 = arg0_12.fashionSkins[iter2_12]
			local var4_12 = arg0_12.styleContainer:GetChild(iter2_12 - 1)
			local var5_12 = arg0_12.fashionCellMap[var4_12]

			if not var5_12 then
				var5_12 = ShipSkinCard.New(var4_12.gameObject)
				arg0_12.fashionCellMap[var4_12] = var5_12
			end

			local var6_12 = arg0_12:GetShipVO():getRemouldSkinId() == var3_12.id and arg0_12:GetShipVO():isRemoulded()
			local var7_12 = arg0_12:GetShipVO():proposeSkinOwned(var3_12) or table.contains(arg0_12.skinList, var3_12.id) or var6_12 or var3_12.skin_type == ShipSkin.SKIN_TYPE_OLD

			var5_12:updateData(arg0_12:GetShipVO(), var3_12, var7_12)
			var5_12:updateUsing(arg0_12:GetShipVO().skinId == var3_12.id)
			onButton(arg0_12, var4_12, function()
				if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
					return
				end

				arg0_12.clickCellTime = Time.realtimeSinceStartup
				arg0_12.fashionSkinId = var3_12.id

				arg0_12:UpdateFashionDetail(var3_12)
				arg0_12:emit(ShipViewConst.LOAD_PAINTING, var3_12.painting)
				arg0_12:emit(ShipViewConst.LOAD_PAINTING_BG, arg0_12:GetShipVO():rarity2bgPrintForGet(), arg0_12:GetShipVO():isBluePrintShip(), arg0_12:GetShipVO():isMetaShip())

				for iter0_13, iter1_13 in ipairs(arg0_12.fashionSkins) do
					local var0_13 = arg0_12.styleContainer:GetChild(iter0_13 - 1)
					local var1_13 = arg0_12.fashionCellMap[var0_13]

					var1_13:updateSelected(iter1_13.id == arg0_12.fashionSkinId)
					var1_13:updateUsing(arg0_12:GetShipVO().skinId == iter1_13.id)
				end

				local var2_13 = checkABExist("painting/" .. var5_12.paintingName .. "_n")

				setActive(arg0_12.hideObjToggle, var2_13)

				if var2_13 then
					arg0_12.hideObjToggle.isOn = PlayerPrefs.GetInt("paint_hide_other_obj_" .. var5_12.paintingName, 0) ~= 0

					onToggle(arg0_12, arg0_12.hideObjToggleTF, function(arg0_14)
						PlayerPrefs.SetInt("paint_hide_other_obj_" .. var5_12.paintingName, arg0_14 and 1 or 0)
						var5_12:flushSkin()
						arg0_12:emit(ShipViewConst.LOAD_PAINTING, var5_12.paintingName, true)
					end, SFX_PANEL)
				end
			end)
			setActive(var4_12, true)
		end
	else
		for iter4_12, iter5_12 in ipairs(arg0_12.fashionSkins) do
			local var8_12 = arg0_12.styleContainer:GetChild(iter4_12 - 1)
			local var9_12 = arg0_12.fashionCellMap[var8_12]
			local var10_12 = arg0_12:GetShipVO():getRemouldSkinId() == iter5_12.id and arg0_12:GetShipVO():isRemoulded()
			local var11_12 = arg0_12:GetShipVO():proposeSkinOwned(iter5_12) or table.contains(arg0_12.skinList, iter5_12.id) or var10_12 or iter5_12.skin_type == ShipSkin.SKIN_TYPE_OLD

			var9_12:updateData(arg0_12:GetShipVO(), iter5_12, var11_12)
		end
	end

	arg0_12.fashionSkinId = arg0_12:GetShipVO().skinId

	local var12_12 = arg0_12.styleContainer:GetChild(0)

	for iter6_12, iter7_12 in ipairs(arg0_12.fashionSkins) do
		if iter7_12.id == arg0_12.fashionSkinId then
			var12_12 = arg0_12.styleContainer:GetChild(iter6_12 - 1)

			break
		end
	end

	triggerButton(var12_12)
end

function var0_0.UpdateFashion(arg0_15, arg1_15)
	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION or not arg0_15.shareData:HasFashion() then
		return
	end

	arg0_15:UpdateAllFashion(arg1_15)
end

function var0_0.ResetFashion(arg0_16)
	arg0_16.fashionSkinId = 0
end

function var0_0.UpdateFashionDetail(arg0_17, arg1_17)
	local var0_17 = arg0_17.fashionDetailWrapper

	if not var0_17 then
		var0_17 = {
			name = findTF(arg0_17.stylePanel, "style_desc/name_bg/name"),
			descTxt = findTF(arg0_17.stylePanel, "style_desc/desc_frame/desc/Text"),
			character = findTF(arg0_17.stylePanel, "style_desc/character"),
			confirm = findTF(arg0_17.stylePanel, "confirm_button"),
			cancel = findTF(arg0_17.stylePanel, "cancel_button")
		}
		var0_17.diamond = findTF(var0_17.confirm, "diamond")
		var0_17.using = findTF(var0_17.confirm, "using")
		var0_17.experience = findTF(var0_17.confirm, "experience")
		var0_17.change = findTF(var0_17.confirm, "change")
		var0_17.buy = findTF(var0_17.confirm, "buy")
		var0_17.activity = findTF(var0_17.confirm, "activity")
		var0_17.cantbuy = findTF(var0_17.confirm, "cantbuy")
		var0_17.prefab = "unknown"
		arg0_17.fashionDetailWrapper = var0_17
	end

	setText(var0_17.name, arg1_17.name)
	setText(var0_17.descTxt, SwitchSpecialChar(arg1_17.desc, true))

	local var1_17 = var0_17.descTxt:GetComponent(typeof(Text))

	if #var1_17.text > 50 then
		var1_17.alignment = TextAnchor.MiddleLeft
	else
		var1_17.alignment = TextAnchor.MiddleCenter
	end

	if var0_17.prefab ~= arg1_17.prefab then
		local var2_17 = var0_17.character:Find(var0_17.prefab)

		if not IsNil(var2_17) then
			PoolMgr.GetInstance():ReturnSpineChar(var0_17.prefab, var2_17.gameObject)
		end

		var0_17.prefab = arg1_17.prefab

		local var3_17 = var0_17.prefab

		PoolMgr.GetInstance():GetSpineChar(var3_17, true, function(arg0_18)
			if var0_17.prefab ~= var3_17 then
				PoolMgr.GetInstance():ReturnSpineChar(var3_17, arg0_18)
			else
				arg0_18.name = var3_17
				arg0_18.transform.localPosition = Vector3.zero
				arg0_18.transform.localScale = Vector3(0.5, 0.5, 1)

				arg0_18.transform:SetParent(var0_17.character, false)
				arg0_18:GetComponent(typeof(SpineAnimUI)):SetAction(arg1_17.show_skin or "stand", 0)
			end
		end)
	end

	local var4_17 = arg0_17:GetShipVO():getRemouldSkinId() == arg1_17.id and arg0_17:GetShipVO():isRemoulded()
	local var5_17 = (arg0_17:GetShipVO():proposeSkinOwned(arg1_17) or table.contains(arg0_17.skinList, arg1_17.id) or var4_17) and 1 or 0
	local var6_17 = arg1_17.shop_id > 0 and pg.shop_template[arg1_17.shop_id] or nil
	local var7_17 = var6_17 and not pg.TimeMgr.GetInstance():inTime(var6_17.time)
	local var8_17 = arg1_17.id == arg0_17:GetShipVO().skinId
	local var9_17 = arg1_17.id == arg0_17:GetShipVO():getConfig("skin_id") or var5_17 >= 1 or arg1_17.skin_type == ShipSkin.SKIN_TYPE_OLD
	local var10_17 = getProxy(ShipSkinProxy):getSkinById(arg1_17.id)
	local var11_17 = getProxy(ShipSkinProxy):InForbiddenSkinListAndShow(arg1_17.id)
	local var12_17 = var8_17 and var10_17 and var10_17:isExpireType()

	setActive(var0_17.using, false)
	setActive(var0_17.change, false)
	setActive(var0_17.buy, false)
	setActive(var0_17.experience, false)

	if var12_17 then
		setGray(var0_17.confirm, false)
		setActive(var0_17.experience, true)
	elseif var8_17 then
		setGray(var0_17.confirm, false)
		setActive(var0_17.using, true)
	elseif var9_17 and ShipSkin.IsShareSkin(arg0_17:GetShipVO(), arg1_17.id) and not ShipSkin.CanUseShareSkinForShip(arg0_17:GetShipVO(), arg1_17.id) then
		setActive(var0_17.change, true)
		setGray(var0_17.confirm, true)
	elseif var9_17 then
		setActive(var0_17.change, true)
	elseif var6_17 then
		setActive(var0_17.buy, true)
		setGray(var0_17.confirm, var7_17 or var11_17)
	else
		setActive(var0_17.change, true)
		setGray(var0_17.confirm, true)
	end

	onButton(arg0_17, var0_17.confirm, function()
		if var8_17 then
			-- block empty
		elseif var9_17 then
			if ShipSkin.IsShareSkin(arg0_17:GetShipVO(), arg1_17.id) and not ShipSkin.CanUseShareSkinForShip(arg0_17:GetShipVO(), arg1_17.id) then
				-- block empty
			else
				arg0_17:emit(ShipMainMediator.CHANGE_SKIN, arg0_17:GetShipVO().id, arg1_17.id == arg0_17:GetShipVO():getConfig("skin_id") and 0 or arg1_17.id)
			end
		elseif var6_17 then
			if var7_17 or var11_17 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_skin_out_of_stock"))
			else
				local var0_19 = Goods.Create({
					shop_id = var6_17.id
				}, Goods.TYPE_SKIN)

				if var0_19:isDisCount() and var0_19:IsItemDiscountType() then
					arg0_17:emit(ShipMainMediator.BUY_ITEM_BY_ACT, var6_17.id, 1)
				else
					local var1_19 = var0_19:GetPrice()
					local var2_19 = i18n("text_buy_fashion_tip", var1_19, arg1_17.name)

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var2_19,
						onYes = function()
							arg0_17:emit(ShipMainMediator.BUY_ITEM, var6_17.id, 1)
						end
					})
				end
			end
		end
	end)
	onButton(arg0_17, var0_17.cancel, function()
		if arg0_17.clickCellTime and Time.realtimeSinceStartup - arg0_17.clickCellTime <= 0.35 then
			return
		end

		arg0_17:SilentTriggerToggleFalse()
		arg0_17:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.DETAIL)
	end)
end

function var0_0.SilentTriggerToggleFalse(arg0_22)
	arg0_22.fashionGroup = false
	arg0_22.isShareSkinFlag = false

	removeOnToggle(arg0_22.shareBtn)
	triggerToggle(arg0_22.shareBtn, false)
	arg0_22:RegisterShareToggle()
end

function var0_0.RegisterShareToggle(arg0_23)
	onToggle(arg0_23, arg0_23.shareBtn, function(arg0_24)
		arg0_23.fashionGroup = false
		arg0_23.isShareSkinFlag = arg0_24

		arg0_23:UpdateFashion()
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_25)
	if arg0_25.fashionDetailWrapper then
		local var0_25 = arg0_25.fashionDetailWrapper
		local var1_25 = var0_25.character:Find(var0_25.prefab)

		if not IsNil(var1_25) then
			PoolMgr.GetInstance():ReturnSpineChar(var0_25.prefab, var1_25.gameObject)
		end
	end

	arg0_25.fashionDetailWrapper = nil

	for iter0_25, iter1_25 in pairs(arg0_25.fashionCellMap) do
		iter1_25:clear()
	end

	arg0_25.fashionCellMap = {}
	arg0_25.fashionSkins = {}
	arg0_25.fashionGroup = 0
	arg0_25.fashionSkinId = 0
	arg0_25.shareData = nil
end

return var0_0
