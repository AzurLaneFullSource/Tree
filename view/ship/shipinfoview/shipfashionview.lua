local var0 = class("ShipFashionView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShipFashionView"
end

function var0.OnInit(arg0)
	arg0:InitFashion()
end

function var0.InitFashion(arg0)
	arg0.mainPanel = arg0._parentTf.parent
	arg0.stylePanel = arg0._tf
	arg0.styleScroll = arg0:findTF("style_scroll", arg0.stylePanel)
	arg0.styleContainer = arg0:findTF("view_port", arg0.styleScroll)
	arg0.styleCard = arg0._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0.hideObjToggleTF = findTF(arg0._tf, "btns/hideObjToggle")

	setActive(arg0.hideObjToggleTF, false)

	arg0.hideObjToggle = GetComponent(arg0.hideObjToggleTF, typeof(Toggle))

	setText(findTF(arg0.hideObjToggleTF, "Label"), i18n("paint_hide_other_obj_tip"))

	arg0.shareBtn = findTF(arg0._tf, "share_btn")

	setActive(arg0.stylePanel, true)
	setActive(arg0.styleCard, false)

	arg0.fashionSkins = {}
	arg0.fashionCellMap = {}
	arg0.fashionGroup = 0
	arg0.fashionSkinId = 0
	arg0.onSelected = false
	arg0.isShareSkinFlag = false

	arg0:RegisterShareToggle()
	arg0:bind(ShipMainMediator.ON_NEXTSHIP_PREPARE, function(arg0, arg1)
		if arg0.isShareSkinFlag and arg1 and #arg0:GetShareSkins(arg1) <= 0 then
			arg0.isShareSkinFlag = false
		end
	end)
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.GetShipVO(arg0)
	if arg0.shareData and arg0.shareData.shipVO then
		return arg0.shareData.shipVO
	end

	return nil
end

function var0.SetSkinList(arg0, arg1)
	arg0.skinList = arg1
end

function var0.UpdateUI(arg0)
	triggerToggle(arg0.shareBtn, arg0.isShareSkinFlag)

	local var0 = arg0:GetShareSkins(arg0:GetShipVO())

	setActive(arg0.shareBtn, #var0 > 0)
end

function var0.OnSelected(arg0, arg1)
	local var0 = pg.UIMgr.GetInstance()

	if arg1 then
		var0:OverlayPanelPB(arg0._parentTf, {
			pbList = {
				arg0.stylePanel:Find("style_desc"),
				arg0.stylePanel:Find("frame")
			},
			groupName = LayerWeightConst.GROUP_SHIPINFOUI,
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		var0:UnOverlayPanel(arg0._parentTf, arg0.mainPanel)
	end

	arg0.onSelected = arg1
end

function var0.GetShareSkins(arg0, arg1)
	local var0 = getProxy(ShipSkinProxy):GetShareSkinsForShip(arg1)

	return (_.map(var0, function(arg0)
		return pg.ship_skin_template[arg0.id]
	end))
end

function var0.UpdateAllFashion(arg0, arg1)
	local var0 = arg0:GetShipVO()
	local var1 = var0.groupId

	arg0.fashionSkins = arg0.isShareSkinFlag and arg0:GetShareSkins(var0) or arg0.shareData:GetGroupSkinList(var1)

	if arg0.fashionGroup ~= var1 or arg1 then
		arg0.fashionGroup = var1

		arg0:ResetFashion()

		for iter0 = arg0.styleContainer.childCount, #arg0.fashionSkins - 1 do
			cloneTplTo(arg0.styleCard, arg0.styleContainer)
		end

		for iter1 = #arg0.fashionSkins, arg0.styleContainer.childCount - 1 do
			local var2 = arg0.styleContainer:GetChild(iter1)

			if arg0.fashionCellMap[var2] then
				arg0.fashionCellMap[var2]:clear()
			end

			setActive(var2, false)
		end

		for iter2, iter3 in ipairs(arg0.fashionSkins) do
			local var3 = arg0.fashionSkins[iter2]
			local var4 = arg0.styleContainer:GetChild(iter2 - 1)
			local var5 = arg0.fashionCellMap[var4]

			if not var5 then
				var5 = ShipSkinCard.New(var4.gameObject)
				arg0.fashionCellMap[var4] = var5
			end

			local var6 = arg0:GetShipVO():getRemouldSkinId() == var3.id and arg0:GetShipVO():isRemoulded()
			local var7 = arg0:GetShipVO():proposeSkinOwned(var3) or table.contains(arg0.skinList, var3.id) or var6 or var3.skin_type == ShipSkin.SKIN_TYPE_OLD

			var5:updateData(arg0:GetShipVO(), var3, var7)
			var5:updateUsing(arg0:GetShipVO().skinId == var3.id)
			onButton(arg0, var4, function()
				if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
					return
				end

				arg0.clickCellTime = Time.realtimeSinceStartup
				arg0.fashionSkinId = var3.id

				arg0:UpdateFashionDetail(var3)
				arg0:emit(ShipViewConst.LOAD_PAINTING, var3.painting)
				arg0:emit(ShipViewConst.LOAD_PAINTING_BG, arg0:GetShipVO():rarity2bgPrintForGet(), arg0:GetShipVO():isBluePrintShip(), arg0:GetShipVO():isMetaShip())

				for iter0, iter1 in ipairs(arg0.fashionSkins) do
					local var0 = arg0.styleContainer:GetChild(iter0 - 1)
					local var1 = arg0.fashionCellMap[var0]

					var1:updateSelected(iter1.id == arg0.fashionSkinId)
					var1:updateUsing(arg0:GetShipVO().skinId == iter1.id)
				end

				local var2 = checkABExist("painting/" .. var5.paintingName .. "_n")

				setActive(arg0.hideObjToggle, var2)

				if var2 then
					arg0.hideObjToggle.isOn = PlayerPrefs.GetInt("paint_hide_other_obj_" .. var5.paintingName, 0) ~= 0

					onToggle(arg0, arg0.hideObjToggleTF, function(arg0)
						PlayerPrefs.SetInt("paint_hide_other_obj_" .. var5.paintingName, arg0 and 1 or 0)
						var5:flushSkin()
						arg0:emit(ShipViewConst.LOAD_PAINTING, var5.paintingName, true)
					end, SFX_PANEL)
				end
			end)
			setActive(var4, true)
		end
	else
		for iter4, iter5 in ipairs(arg0.fashionSkins) do
			local var8 = arg0.styleContainer:GetChild(iter4 - 1)
			local var9 = arg0.fashionCellMap[var8]
			local var10 = arg0:GetShipVO():getRemouldSkinId() == iter5.id and arg0:GetShipVO():isRemoulded()
			local var11 = arg0:GetShipVO():proposeSkinOwned(iter5) or table.contains(arg0.skinList, iter5.id) or var10 or iter5.skin_type == ShipSkin.SKIN_TYPE_OLD

			var9:updateData(arg0:GetShipVO(), iter5, var11)
		end
	end

	arg0.fashionSkinId = arg0:GetShipVO().skinId

	local var12 = arg0.styleContainer:GetChild(0)

	for iter6, iter7 in ipairs(arg0.fashionSkins) do
		if iter7.id == arg0.fashionSkinId then
			var12 = arg0.styleContainer:GetChild(iter6 - 1)

			break
		end
	end

	triggerButton(var12)
end

function var0.UpdateFashion(arg0, arg1)
	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION or not arg0.shareData:HasFashion() then
		return
	end

	arg0:UpdateAllFashion(arg1)
end

function var0.ResetFashion(arg0)
	arg0.fashionSkinId = 0
end

function var0.UpdateFashionDetail(arg0, arg1)
	local var0 = arg0.fashionDetailWrapper

	if not var0 then
		var0 = {
			name = findTF(arg0.stylePanel, "style_desc/name_bg/name"),
			descTxt = findTF(arg0.stylePanel, "style_desc/desc_frame/desc/Text"),
			character = findTF(arg0.stylePanel, "style_desc/character"),
			confirm = findTF(arg0.stylePanel, "confirm_button"),
			cancel = findTF(arg0.stylePanel, "cancel_button")
		}
		var0.diamond = findTF(var0.confirm, "diamond")
		var0.using = findTF(var0.confirm, "using")
		var0.experience = findTF(var0.confirm, "experience")
		var0.change = findTF(var0.confirm, "change")
		var0.buy = findTF(var0.confirm, "buy")
		var0.activity = findTF(var0.confirm, "activity")
		var0.cantbuy = findTF(var0.confirm, "cantbuy")
		var0.prefab = "unknown"
		arg0.fashionDetailWrapper = var0
	end

	setText(var0.name, arg1.name)
	setText(var0.descTxt, SwitchSpecialChar(arg1.desc, true))

	local var1 = var0.descTxt:GetComponent(typeof(Text))

	if #var1.text > 50 then
		var1.alignment = TextAnchor.MiddleLeft
	else
		var1.alignment = TextAnchor.MiddleCenter
	end

	if var0.prefab ~= arg1.prefab then
		local var2 = var0.character:Find(var0.prefab)

		if not IsNil(var2) then
			PoolMgr.GetInstance():ReturnSpineChar(var0.prefab, var2.gameObject)
		end

		var0.prefab = arg1.prefab

		local var3 = var0.prefab

		PoolMgr.GetInstance():GetSpineChar(var3, true, function(arg0)
			if var0.prefab ~= var3 then
				PoolMgr.GetInstance():ReturnSpineChar(var3, arg0)
			else
				arg0.name = var3
				arg0.transform.localPosition = Vector3.zero
				arg0.transform.localScale = Vector3(0.5, 0.5, 1)

				arg0.transform:SetParent(var0.character, false)
				arg0:GetComponent(typeof(SpineAnimUI)):SetAction(arg1.show_skin or "stand", 0)
			end
		end)
	end

	local var4 = arg0:GetShipVO():getRemouldSkinId() == arg1.id and arg0:GetShipVO():isRemoulded()
	local var5 = (arg0:GetShipVO():proposeSkinOwned(arg1) or table.contains(arg0.skinList, arg1.id) or var4) and 1 or 0
	local var6 = arg1.shop_id > 0 and pg.shop_template[arg1.shop_id] or nil
	local var7 = var6 and not pg.TimeMgr.GetInstance():inTime(var6.time)
	local var8 = arg1.id == arg0:GetShipVO().skinId
	local var9 = arg1.id == arg0:GetShipVO():getConfig("skin_id") or var5 >= 1 or arg1.skin_type == ShipSkin.SKIN_TYPE_OLD
	local var10 = getProxy(ShipSkinProxy):getSkinById(arg1.id)
	local var11 = getProxy(ShipSkinProxy):InForbiddenSkinListAndShow(arg1.id)
	local var12 = var8 and var10 and var10:isExpireType()

	setActive(var0.using, false)
	setActive(var0.change, false)
	setActive(var0.buy, false)
	setActive(var0.experience, false)

	if var12 then
		setGray(var0.confirm, false)
		setActive(var0.experience, true)
	elseif var8 then
		setGray(var0.confirm, false)
		setActive(var0.using, true)
	elseif var9 and ShipSkin.IsShareSkin(arg0:GetShipVO(), arg1.id) and not ShipSkin.CanUseShareSkinForShip(arg0:GetShipVO(), arg1.id) then
		setActive(var0.change, true)
		setGray(var0.confirm, true)
	elseif var9 then
		setActive(var0.change, true)
	elseif var6 then
		setActive(var0.buy, true)
		setGray(var0.confirm, var7 or var11)
	else
		setActive(var0.change, true)
		setGray(var0.confirm, true)
	end

	onButton(arg0, var0.confirm, function()
		if var8 then
			-- block empty
		elseif var9 then
			if ShipSkin.IsShareSkin(arg0:GetShipVO(), arg1.id) and not ShipSkin.CanUseShareSkinForShip(arg0:GetShipVO(), arg1.id) then
				-- block empty
			else
				arg0:emit(ShipMainMediator.CHANGE_SKIN, arg0:GetShipVO().id, arg1.id == arg0:GetShipVO():getConfig("skin_id") and 0 or arg1.id)
			end
		elseif var6 then
			if var7 or var11 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_skin_out_of_stock"))
			else
				local var0 = Goods.Create({
					shop_id = var6.id
				}, Goods.TYPE_SKIN)

				if var0:isDisCount() and var0:IsItemDiscountType() then
					arg0:emit(ShipMainMediator.BUY_ITEM_BY_ACT, var6.id, 1)
				else
					local var1 = var0:GetPrice()
					local var2 = i18n("text_buy_fashion_tip", var1, arg1.name)

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var2,
						onYes = function()
							arg0:emit(ShipMainMediator.BUY_ITEM, var6.id, 1)
						end
					})
				end
			end
		end
	end)
	onButton(arg0, var0.cancel, function()
		if arg0.clickCellTime and Time.realtimeSinceStartup - arg0.clickCellTime <= 0.35 then
			return
		end

		arg0:SilentTriggerToggleFalse()
		arg0:emit(ShipViewConst.SWITCH_TO_PAGE, ShipViewConst.PAGE.DETAIL)
	end)
end

function var0.SilentTriggerToggleFalse(arg0)
	arg0.fashionGroup = false
	arg0.isShareSkinFlag = false

	removeOnToggle(arg0.shareBtn)
	triggerToggle(arg0.shareBtn, false)
	arg0:RegisterShareToggle()
end

function var0.RegisterShareToggle(arg0)
	onToggle(arg0, arg0.shareBtn, function(arg0)
		arg0.fashionGroup = false
		arg0.isShareSkinFlag = arg0

		arg0:UpdateFashion()
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	if arg0.fashionDetailWrapper then
		local var0 = arg0.fashionDetailWrapper
		local var1 = var0.character:Find(var0.prefab)

		if not IsNil(var1) then
			PoolMgr.GetInstance():ReturnSpineChar(var0.prefab, var1.gameObject)
		end
	end

	arg0.fashionDetailWrapper = nil

	for iter0, iter1 in pairs(arg0.fashionCellMap) do
		iter1:clear()
	end

	arg0.fashionCellMap = {}
	arg0.fashionSkins = {}
	arg0.fashionGroup = 0
	arg0.fashionSkinId = 0
	arg0.shareData = nil
end

return var0
