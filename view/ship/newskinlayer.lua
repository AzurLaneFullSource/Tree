local var0_0 = class("NewSkinLayer", import("..base.BaseUI"))

var0_0.PAINT_DURATION = 0.35
var0_0.STAR_DURATION = 0.5

local var1_0 = 19

function var0_0.getUIName(arg0_1)
	return "NewSkinUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = arg0_2.contextData.skinId
	local var1_2 = pg.ship_skin_template[var0_2]
	local var2_2 = var1_2.ship_group
	local var3_2 = var2_2 * 10 + 1
	local var4_2 = pg.ship_data_statistics[var3_2]
	local var5_2

	if var1_2.bg_sp and var1_2.bg_sp ~= "" then
		var5_2 = var1_2.bg_sp
	else
		var5_2 = var1_2.bg and #var1_2.bg > 0 and var1_2.bg or var1_2.rarity_bg and #var1_2.rarity_bg > 0 and var1_2.rarity_bg
	end

	local var6_2

	var6_2 = var5_2 and "bg/star_level_bg_" .. var5_2 or "newshipbg/bg_" .. shipRarity2bgPrint(var4_2.rarity, ShipGroup.IsBluePrintGroup(var2_2), ShipGroup.IsMetaGroup(var2_2))

	GetSpriteFromAtlasAsync(var6_2, "", arg1_2)
end

function var0_0.setShipVOs(arg0_3, arg1_3)
	arg0_3.shipVOs = arg1_3
	arg0_3.sameShipVOs = arg0_3:getSameGroupShips()
end

function var0_0.init(arg0_4)
	arg0_4._shake = arg0_4:findTF("shake_panel")
	arg0_4._shade = arg0_4:findTF("shade")
	arg0_4._bg = arg0_4._shake:Find("bg")
	arg0_4._staticBg = arg0_4._bg:Find("static_bg")
	arg0_4._paintingTF = arg0_4._shake:Find("paint")
	arg0_4._dialogue = arg0_4._shake:Find("dialogue")
	arg0_4._skinName = arg0_4._dialogue:Find("name"):GetComponent(typeof(Text))
	arg0_4._left = arg0_4._shake:Find("left_panel")
	arg0_4._viewBtn = arg0_4._left:Find("view_btn")
	arg0_4._shareBtn = arg0_4._left:Find("share_btn")
	arg0_4.clickTF = arg0_4._shake:Find("click")
	arg0_4.newTF = arg0_4._shake:Find("New")
	arg0_4.timelimit = arg0_4._shake:Find("timelimit")

	setActive(arg0_4.newTF, false)

	arg0_4.changeSkinBtn = arg0_4:findTF("set_skin_btn", arg0_4._shake)
	arg0_4.selectPanel = arg0_4:findTF("select_ship_panel")
	arg0_4.selectPanelCloseBtn = arg0_4:findTF("window/top/btnBack", arg0_4.selectPanel)
	arg0_4.shipContent = arg0_4:findTF("window/sliders/scroll_rect/content", arg0_4.selectPanel)
	arg0_4.shipCardTpl = arg0_4._tf:GetComponent("ItemList").prefabItem[0]
	arg0_4.confirmChangeBtn = arg0_4:findTF("window/exchange_btn", arg0_4.selectPanel)
	arg0_4.flagShipToggle = arg0_4:findTF("window/flag_ship", arg0_4.selectPanel)

	setActive(arg0_4.selectPanel, false)

	arg0_4.isTimeLimit = arg0_4.contextData.timeLimit

	setActive(arg0_4.timelimit, arg0_4.isTimeLimit)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0_4.isLoadBg = false
end

function var0_0.voice(arg0_5, arg1_5)
	if not arg1_5 then
		return
	end

	arg0_5:stopVoice()

	arg0_5._currentVoice = arg1_5

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_5)
end

function var0_0.stopVoice(arg0_6)
	if arg0_6._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_6._currentVoice)
	end

	arg0_6._currentVoice = nil
end

function var0_0.setSkin(arg0_7, arg1_7)
	arg0_7.cg = GetOrAddComponent(arg0_7._tf, typeof(CanvasGroup))
	arg0_7.cg.alpha = 0

	setActive(arg0_7._shade, true)

	arg0_7._shade:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 1)

	local var0_7 = "star_level_unlock_anim_" .. arg1_7

	if checkABExist("ui/skinunlockanim/" .. var0_7) then
		arg0_7:playOpening(function()
			arg0_7:setSkinPri(arg1_7)
		end, var0_7)
	else
		arg0_7:setSkinPri(arg1_7)
	end
end

function var0_0.setSkinPri(arg0_9, arg1_9)
	local var0_9 = arg0_9:loadUISync("getrole")

	var0_9.layer = LayerMask.NameToLayer("UI")
	var0_9.transform.localPosition = Vector3(0, 0, -10)

	setParent(var0_9, arg0_9._tf, false)
	setActive(var0_9, false)
	onNextTick(function()
		setActive(var0_9, true)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_CHARGET)

	arg0_9.cg.alpha = 1
	arg0_9._shade:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0)

	arg0_9:recyclePainting()

	arg0_9._skinConfig = pg.ship_skin_template[arg1_9]

	local var1_9 = pg.ship_skin_template[arg1_9].ship_group
	local var2_9 = pg.ship_data_statistics[arg0_9._skinConfig.ship_group * 10 + 1]
	local var3_9

	if arg0_9._skinConfig.bg_sp and arg0_9._skinConfig.bg_sp ~= "" then
		var3_9 = arg0_9._skinConfig.bg_sp
	else
		var3_9 = arg0_9._skinConfig.bg and #arg0_9._skinConfig.bg > 0 and arg0_9._skinConfig.bg or arg0_9._skinConfig.rarity_bg and #arg0_9._skinConfig.rarity_bg > 0 and arg0_9._skinConfig.rarity_bg
	end

	if var3_9 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_9, var3_9, arg0_9._bg, arg0_9._staticBg, function(arg0_11)
			arg0_9.isLoadBg = true
		end, function(arg0_12)
			arg0_9.isLoadBg = true
		end)
	else
		local var4_9 = "newshipbg/bg_" .. shipRarity2bgPrint(var2_9.rarity, ShipGroup.IsBluePrintGroup(var1_9), ShipGroup.IsMetaGroup(var1_9))

		GetSpriteFromAtlasAsync(var4_9, "", function(arg0_13)
			setImageSprite(arg0_9._staticBg, arg0_13, true)

			arg0_9.isLoadBg = true
		end)
	end

	setPaintingPrefabAsync(arg0_9._paintingTF, arg0_9._skinConfig.painting, "huode")

	arg0_9._skinName.text = i18n("ship_newSkin_name", arg0_9._skinConfig.name)

	local var5_9
	local var6_9 = ""
	local var7_9
	local var8_9 = ShipWordHelper.RawGetWord(arg1_9, ShipWordHelper.WORD_TYPE_UNLOCK)

	if var8_9 == "" then
		local var9_9

		var9_9, var7_9, var8_9 = ShipWordHelper.GetWordAndCV(arg1_9, ShipWordHelper.WORD_TYPE_DROP)
	else
		local var10_9

		var10_9, var7_9, var8_9 = ShipWordHelper.GetWordAndCV(arg1_9, ShipWordHelper.WORD_TYPE_UNLOCK)
	end

	setWidgetText(arg0_9._dialogue, SwitchSpecialChar(var8_9, true), "desc/Text")

	arg0_9._dialogue.transform.localScale = Vector3(0, 1, 1)

	SetActive(arg0_9._dialogue, false)
	SetActive(arg0_9._dialogue, true)
	LeanTween.scale(arg0_9._dialogue, Vector3(1, 1, 1), 0.1):setOnComplete(System.Action(function()
		setActive(arg0_9._shade, false)
		setActive(arg0_9.clickTF, true)
		arg0_9:voice(var7_9)
	end))
end

function var0_0.showExitTip(arg0_15)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("give_up_cloth_change"),
		onYes = function()
			arg0_15:emit(var0_0.ON_CLOSE)
		end
	})
end

function var0_0.didEnter(arg0_17)
	local var0_17 = ShipWordHelper.GetDefaultSkin(arg0_17.contextData.skinId)

	arg0_17.shipName = pg.ship_skin_template[var0_17].name

	onButton(arg0_17, arg0_17._viewBtn, function()
		arg0_17.isInView = true

		arg0_17:paintView()
		setActive(arg0_17.clickTF, false)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17._shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewSkin, nil, {
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.clickTF, function()
		if arg0_17.isInView or not arg0_17.isLoadBg then
			return
		end

		arg0_17:showExitTip()
	end, SFX_CANCEL)
	onButton(arg0_17, arg0_17.selectPanel, function()
		arg0_17:closeSelectPanel()
	end, SFX_PANEL)

	local var1_17 = getProxy(SettingsProxy):GetSetFlagShip()

	onToggle(arg0_17, arg0_17.flagShipToggle, function(arg0_22)
		arg0_17.flagShipMark = arg0_22
	end, SFX_PANEL)
	triggerToggle(arg0_17.flagShipToggle, var1_17)
	arg0_17:onSwitch(arg0_17.changeSkinBtn, table.getCount(arg0_17.sameShipVOs) > 0)
end

function var0_0.onBackPressed(arg0_23)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_23.isInView then
		arg0_23:hidePaintView(true)

		return
	end

	if isActive(arg0_23.selectPanel) then
		arg0_23:closeSelectPanel()

		return
	end

	if isActive(arg0_23.clickTF) then
		triggerButton(arg0_23.clickTF)
	end
end

function var0_0.onSwitch(arg0_24, arg1_24, arg2_24)
	onButton(arg0_24, arg1_24, function()
		if arg2_24 then
			arg0_24:openSelectPanel()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("err_cloth_change_noship", arg0_24.shipName))
		end
	end)
end

function var0_0.getSameGroupShips(arg0_26)
	local var0_26 = {}
	local var1_26 = arg0_26.contextData.skinId
	local var2_26 = pg.ship_skin_template[var1_26].ship_group

	for iter0_26, iter1_26 in pairs(arg0_26.shipVOs) do
		if iter1_26.groupId == var2_26 then
			var0_26[iter1_26.id] = iter1_26
		end
	end

	local var3_26 = getProxy(BayProxy):CanUseShareSkinShips(var1_26)

	for iter2_26, iter3_26 in ipairs(var3_26) do
		var0_26[iter3_26.id] = iter3_26
	end

	return var0_26
end

function var0_0.paintView(arg0_27)
	local var0_27 = {}
	local var1_27 = arg0_27._shake.childCount
	local var2_27 = 0

	while var2_27 < var1_27 do
		local var3_27 = arg0_27._shake:GetChild(var2_27)

		if var3_27.gameObject.activeSelf and var3_27 ~= arg0_27._paintingTF and var3_27 ~= arg0_27._bg then
			var0_27[#var0_27 + 1] = var3_27

			setActive(var3_27, false)
		end

		var2_27 = var2_27 + 1
	end

	openPortrait()

	local var4_27 = arg0_27._paintingTF
	local var5_27 = var4_27.anchoredPosition.x
	local var6_27 = var4_27.anchoredPosition.y
	local var7_27 = var4_27.rect.width
	local var8_27 = var4_27.rect.height
	local var9_27 = arg0_27._tf.rect.width / UnityEngine.Screen.width
	local var10_27 = arg0_27._tf.rect.height / UnityEngine.Screen.height
	local var11_27 = var7_27 / 2
	local var12_27 = var8_27 / 2
	local var13_27
	local var14_27

	if not LeanTween.isTweening(go(var4_27)) then
		LeanTween.moveX(rtf(var4_27), 150, 0.5):setEase(LeanTweenType.easeInOutSine)
	end

	local var15_27 = GetOrAddComponent(arg0_27._bg, "MultiTouchZoom")

	var15_27:SetZoomTarget(arg0_27._paintingTF)

	local var16_27 = GetOrAddComponent(arg0_27._bg, "EventTriggerListener")
	local var17_27 = true

	var15_27.enabled = true
	var16_27.enabled = true

	local var18_27 = false

	var16_27:AddPointDownFunc(function(arg0_28)
		if Input.touchCount == 1 or IsUnityEditor then
			var18_27 = true
			var17_27 = true
		elseif Input.touchCount >= 2 then
			var17_27 = false
			var18_27 = false
		end
	end)
	var16_27:AddPointUpFunc(function(arg0_29)
		if Input.touchCount <= 2 then
			var17_27 = true
		end
	end)
	var16_27:AddBeginDragFunc(function(arg0_30, arg1_30)
		var18_27 = false
		var13_27 = arg1_30.position.x * var9_27 - var11_27 - tf(arg0_27._paintingTF).localPosition.x
		var14_27 = arg1_30.position.y * var10_27 - var12_27 - tf(arg0_27._paintingTF).localPosition.y
	end)
	var16_27:AddDragFunc(function(arg0_31, arg1_31)
		if var17_27 then
			local var0_31 = tf(arg0_27._paintingTF).localPosition

			tf(arg0_27._paintingTF).localPosition = Vector3(arg1_31.position.x * var9_27 - var11_27 - var13_27, arg1_31.position.y * var10_27 - var12_27 - var14_27, -22)
		end
	end)
	onButton(arg0_27, arg0_27._bg, function()
		arg0_27:hidePaintView()
	end, SFX_CANCEL)

	function var0_0.hidePaintView(arg0_33, arg1_33)
		if not arg1_33 and not var18_27 then
			return
		end

		var16_27.enabled = false
		var15_27.enabled = false

		RemoveComponent(arg0_33._bg, "Button")

		for iter0_33, iter1_33 in ipairs(var0_27) do
			setActive(iter1_33, true)
		end

		closePortrait()
		LeanTween.cancel(go(arg0_33._paintingTF))

		arg0_33._paintingTF.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0_33._paintingTF, {
			x = var5_27,
			y = var6_27
		})

		arg0_33.isInView = false

		setActive(arg0_33.clickTF, true)
	end
end

function var0_0.recyclePainting(arg0_34)
	if arg0_34._shipVO then
		retPaintingPrefab(arg0_34._paintingTF, arg0_34._shipVO:getPainting())
	end
end

function var0_0.openSelectPanel(arg0_35)
	removeAllChildren(arg0_35.shipContent)

	arg0_35.isOpenSelPanel = true
	arg0_35.selectIds = {}

	setActive(arg0_35.selectPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_35.selectPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0_35.shipCards = {}

	local var0_35 = {}

	for iter0_35, iter1_35 in pairs(arg0_35.sameShipVOs) do
		table.insert(var0_35, iter1_35)
	end

	table.sort(var0_35, function(arg0_36, arg1_36)
		if arg0_36.level == arg1_36.level then
			local var0_36 = arg0_36:getStar()
			local var1_36 = arg1_36:getStar()

			if var0_36 == var1_36 then
				local var2_36 = arg0_36.inFleet and 1 or 0
				local var3_36 = arg1_36.inFleet and 1 or 0

				if var2_36 == var3_36 then
					return arg0_36.createTime < arg1_36.createTime
				else
					return var3_36 < var2_36
				end
			else
				return var1_36 < var0_36
			end
		else
			return arg0_36.level > arg1_36.level
		end
	end)

	for iter2_35, iter3_35 in ipairs(var0_35) do
		local var1_35 = cloneTplTo(arg0_35.shipCardTpl, arg0_35.shipContent)
		local var2_35 = ShipDetailCard.New(var1_35.gameObject)

		var2_35:update(iter3_35, arg0_35.contextData.skinId)

		arg0_35.shipCards[iter3_35.id] = var2_35

		onToggle(arg0_35, var2_35.tr, function(arg0_37)
			var2_35:updateSelected(arg0_37)

			if arg0_37 then
				table.insert(arg0_35.selectIds, var2_35.shipVO.id)
			else
				for iter0_37, iter1_37 in pairs(arg0_35.selectIds) do
					if iter1_37 == var2_35.shipVO.id then
						table.remove(arg0_35.selectIds, iter0_37)

						break
					end
				end
			end
		end)
	end

	onButton(arg0_35, arg0_35.confirmChangeBtn, function()
		if not arg0_35.selectIds or #arg0_35.selectIds <= 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("new_skin_no_choose"),
				weight = LayerWeightConst.TOP_LAYER + 1,
				onYes = function()
					arg0_35:emit(var0_0.ON_CLOSE)
				end
			})

			return
		end

		arg0_35:emit(NewSkinMediator.SET_SKIN, arg0_35.selectIds, arg0_35.flagShipMark)
	end)
	onButton(arg0_35, arg0_35.selectPanelCloseBtn, function()
		arg0_35:closeSelectPanel()
	end)
end

function var0_0.updateShipCards(arg0_41)
	for iter0_41, iter1_41 in pairs(arg0_41.shipCards or {}) do
		local var0_41 = arg0_41.sameShipVOs[iter0_41]

		if var0_41 then
			iter1_41:update(var0_41, arg0_41.contextData.skinId)
		end
	end
end

function var0_0.closeSelectPanel(arg0_42)
	if arg0_42.isOpenSelPanel then
		arg0_42.isOpenSelPanel = nil

		setActive(arg0_42.selectPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_42.selectPanel, arg0_42._tf)
	end
end

function var0_0.playOpening(arg0_43, arg1_43, arg2_43)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		return
	end, function()
		if arg1_43 then
			arg1_43()
		end
	end, "ui/skinunlockanim", arg2_43, false, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.willExit(arg0_46)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()

	local var0_46 = arg0_46._skinConfig.ship_group * 10 + 1
	local var1_46 = pg.ship_data_statistics[var0_46]

	pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newSkinLayer_get", var1_46.name, arg0_46._skinConfig.name), COLOR_GREEN)
	arg0_46:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_46._tf)
	arg0_46:stopVoice()

	if arg0_46.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_46.loadedCVBankName)

		arg0_46.loadedCVBankName = nil
	end

	arg0_46:closeSelectPanel()
	cameraPaintViewAdjust(false)
end

return var0_0
