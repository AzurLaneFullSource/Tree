local var0_0 = class("NewSkinLayer", import("..base.BaseUI"))

var0_0.PAINT_DURATION = 0.35
var0_0.STAR_DURATION = 0.5

local var1_0 = 19

function var0_0.getUIName(arg0_1)
	return "NewSkinUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = arg0_2.contextData.skinId
	local var1_2 = {
		ShipSkin.GetBgPrint(var0_2)
	}

	return table.insertto(var1_2, var0_0.super.getResource(arg0_2))
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = ShipSkin.GetBgPrint(arg0_3.contextData.skinId)

	GetSpriteFromAtlasAsync(var0_3, "", arg1_3)
end

function var0_0.init(arg0_4)
	arg0_4._shake = arg0_4._tf:Find("shake_panel")
	arg0_4._shade = arg0_4._tf:Find("shade")
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

	arg0_4.changeSkinBtn = arg0_4._shake:Find("set_skin_btn")
	arg0_4.selectPanel = arg0_4._tf:Find("select_ship_panel")
	arg0_4.isTimeLimit = arg0_4.contextData.timeLimit

	setActive(arg0_4.timelimit, arg0_4.isTimeLimit)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf)

	arg0_4.isLoadBg = false
	arg0_4.selectShipPage = ChangeShipSkinPage.New(arg0_4._parentTf, arg0_4.event)
	arg0_4.selectShipPage.isNew = true

	function arg0_4.selectShipPage.hideCallback()
		arg0_4:closeView()
	end
end

function var0_0.voice(arg0_6, arg1_6)
	if not arg1_6 then
		return
	end

	arg0_6:stopVoice()

	arg0_6._currentVoice = arg1_6

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_6)
end

function var0_0.stopVoice(arg0_7)
	if arg0_7._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_7._currentVoice)
	end

	arg0_7._currentVoice = nil
end

function var0_0.setSkin(arg0_8, arg1_8)
	arg0_8.cg = GetOrAddComponent(arg0_8._tf, typeof(CanvasGroup))
	arg0_8.cg.alpha = 0

	setActive(arg0_8._shade, true)

	arg0_8._shade:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 1)

	local var0_8 = "star_level_unlock_anim_" .. arg1_8

	if checkABExist("ui/skinunlockanim/" .. var0_8) then
		arg0_8:playOpening(function()
			arg0_8:setSkinPri(arg1_8)
		end, var0_8)
	else
		arg0_8:setSkinPri(arg1_8)
	end
end

function var0_0.setSkinPri(arg0_10, arg1_10)
	local var0_10 = arg0_10:loadUISync("getrole")

	var0_10.layer = LayerMask.NameToLayer("UI")
	var0_10.transform.localPosition = Vector3(0, 0, -10)

	setParent(var0_10, arg0_10._tf, false)
	setActive(var0_10, false)
	onNextTick(function()
		setActive(var0_10, true)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_CHARGET)

	arg0_10.cg.alpha = 1
	arg0_10._shade:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0)

	arg0_10:recyclePainting()

	arg0_10._skinConfig = pg.ship_skin_template[arg1_10]

	local var1_10 = pg.ship_skin_template[arg1_10].ship_group
	local var2_10 = pg.ship_data_statistics[arg0_10._skinConfig.ship_group * 10 + 1]
	local var3_10

	if arg0_10._skinConfig.bg_sp and arg0_10._skinConfig.bg_sp ~= "" then
		var3_10 = arg0_10._skinConfig.bg_sp
	else
		var3_10 = arg0_10._skinConfig.bg and #arg0_10._skinConfig.bg > 0 and arg0_10._skinConfig.bg or arg0_10._skinConfig.rarity_bg and #arg0_10._skinConfig.rarity_bg > 0 and arg0_10._skinConfig.rarity_bg
	end

	if var3_10 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_10, var3_10, arg0_10._bg, arg0_10._staticBg, function(arg0_12)
			arg0_10.isLoadBg = true
		end, function(arg0_13)
			arg0_10.isLoadBg = true
		end)
	else
		local var4_10 = "newshipbg/bg_" .. shipRarity2bgPrint(var2_10.rarity, ShipGroup.IsBluePrintGroup(var1_10), ShipGroup.IsMetaGroup(var1_10))

		GetSpriteFromAtlasAsync(var4_10, "", function(arg0_14)
			setImageSprite(arg0_10._staticBg, arg0_14, true)

			arg0_10.isLoadBg = true
		end)
	end

	setPaintingPrefabAsync(arg0_10._paintingTF, arg0_10._skinConfig.painting, "huode")

	arg0_10._skinName.text = i18n("ship_newSkin_name", arg0_10._skinConfig.name)

	local var5_10
	local var6_10 = ""
	local var7_10
	local var8_10 = ShipWordHelper.RawGetWord(arg1_10, ShipWordHelper.WORD_TYPE_UNLOCK)

	if var8_10 == "" then
		local var9_10

		var9_10, var7_10, var8_10 = ShipWordHelper.GetWordAndCV(arg1_10, ShipWordHelper.WORD_TYPE_DROP)
	else
		local var10_10

		var10_10, var7_10, var8_10 = ShipWordHelper.GetWordAndCV(arg1_10, ShipWordHelper.WORD_TYPE_UNLOCK)
	end

	setWidgetText(arg0_10._dialogue, SwitchSpecialChar(var8_10, true), "desc/Text")

	arg0_10._dialogue.transform.localScale = Vector3(0, 1, 1)

	SetActive(arg0_10._dialogue, false)
	SetActive(arg0_10._dialogue, true)
	LeanTween.scale(arg0_10._dialogue, Vector3(1, 1, 1), 0.1):setOnComplete(System.Action(function()
		setActive(arg0_10._shade, false)
		setActive(arg0_10.clickTF, true)
		arg0_10:voice(var7_10)
	end))
end

function var0_0.showExitTip(arg0_16)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("give_up_cloth_change"),
		onYes = function()
			arg0_16:emit(var0_0.ON_CLOSE)
		end
	})
end

function var0_0.didEnter(arg0_18)
	local var0_18 = ShipWordHelper.GetDefaultSkin(arg0_18.contextData.skinId)

	arg0_18.shipName = pg.ship_skin_template[var0_18].name

	onButton(arg0_18, arg0_18._viewBtn, function()
		arg0_18.isInView = true

		arg0_18:paintView()
		setActive(arg0_18.clickTF, false)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18._shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewSkin)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.clickTF, function()
		if arg0_18.isInView or not arg0_18.isLoadBg then
			return
		end

		arg0_18:showExitTip()
	end, SFX_CANCEL)

	arg0_18.sameShipVOs = arg0_18:GetShips(arg0_18.contextData.skinId)

	arg0_18:onSwitch(arg0_18.changeSkinBtn, #arg0_18.sameShipVOs > 0)
end

function var0_0.GetShips(arg0_22, arg1_22)
	local var0_22 = getProxy(BayProxy):CanUseShareSkinPhantoms(arg1_22)

	table.sort(var0_22, CompareFuncs({
		function(arg0_23)
			return arg0_23:getSkinId() == arg1_22 and 1 or 0
		end,
		function(arg0_24)
			return -arg0_24.level
		end,
		function(arg0_25)
			return -arg0_25:getStar()
		end,
		function(arg0_26)
			return arg0_26.inFleet and 0 or 1
		end,
		function(arg0_27)
			return arg0_27.createTime
		end
	}))

	return var0_22
end

function var0_0.onBackPressed(arg0_28)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_28.isInView then
		arg0_28:hidePaintView(true)

		return
	end

	if arg0_28.selectShipPage:isShowing() then
		arg0_28.selectShipPage:Hide()

		return
	end

	if isActive(arg0_28.clickTF) then
		triggerButton(arg0_28.clickTF)
	end
end

function var0_0.onSwitch(arg0_29, arg1_29, arg2_29)
	onButton(arg0_29, arg1_29, function()
		if arg2_29 then
			arg0_29:openSelectPanel()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("err_cloth_change_noship", arg0_29.shipName))
		end
	end)
end

function var0_0.paintView(arg0_31)
	local var0_31 = {}
	local var1_31 = arg0_31._shake.childCount
	local var2_31 = 0

	while var2_31 < var1_31 do
		local var3_31 = arg0_31._shake:GetChild(var2_31)

		if var3_31.gameObject.activeSelf and var3_31 ~= arg0_31._paintingTF and var3_31 ~= arg0_31._bg then
			var0_31[#var0_31 + 1] = var3_31

			setActive(var3_31, false)
		end

		var2_31 = var2_31 + 1
	end

	openPortrait()

	local var4_31 = arg0_31._paintingTF
	local var5_31 = var4_31.anchoredPosition.x
	local var6_31 = var4_31.anchoredPosition.y
	local var7_31 = var4_31.rect.width
	local var8_31 = var4_31.rect.height
	local var9_31 = arg0_31._tf.rect.width / UnityEngine.Screen.width
	local var10_31 = arg0_31._tf.rect.height / UnityEngine.Screen.height
	local var11_31 = var7_31 / 2
	local var12_31 = var8_31 / 2
	local var13_31
	local var14_31

	if not LeanTween.isTweening(go(var4_31)) then
		LeanTween.moveX(rtf(var4_31), 150, 0.5):setEase(LeanTweenType.easeInOutSine)
	end

	local var15_31 = GetOrAddComponent(arg0_31._bg, "MultiTouchZoom")

	var15_31:SetZoomTarget(arg0_31._paintingTF)

	local var16_31 = GetOrAddComponent(arg0_31._bg, "EventTriggerListener")
	local var17_31 = true

	var15_31.enabled = true
	var16_31.enabled = true

	local var18_31 = false

	var16_31:AddPointDownFunc(function(arg0_32)
		if Input.touchCount == 1 or IsUnityEditor then
			var18_31 = true
			var17_31 = true
		elseif Input.touchCount >= 2 then
			var17_31 = false
			var18_31 = false
		end
	end)
	var16_31:AddPointUpFunc(function(arg0_33)
		if Input.touchCount <= 2 then
			var17_31 = true
		end
	end)
	var16_31:AddBeginDragFunc(function(arg0_34, arg1_34)
		var18_31 = false
		var13_31 = arg1_34.position.x * var9_31 - var11_31 - tf(arg0_31._paintingTF).localPosition.x
		var14_31 = arg1_34.position.y * var10_31 - var12_31 - tf(arg0_31._paintingTF).localPosition.y
	end)
	var16_31:AddDragFunc(function(arg0_35, arg1_35)
		if var17_31 then
			local var0_35 = tf(arg0_31._paintingTF).localPosition

			tf(arg0_31._paintingTF).localPosition = Vector3(arg1_35.position.x * var9_31 - var11_31 - var13_31, arg1_35.position.y * var10_31 - var12_31 - var14_31, -22)
		end
	end)
	onButton(arg0_31, arg0_31._bg, function()
		arg0_31:hidePaintView()
	end, SFX_CANCEL)

	function var0_0.hidePaintView(arg0_37, arg1_37)
		if not arg1_37 and not var18_31 then
			return
		end

		var16_31.enabled = false
		var15_31.enabled = false

		RemoveComponent(arg0_37._bg, "Button")

		for iter0_37, iter1_37 in ipairs(var0_31) do
			setActive(iter1_37, true)
		end

		closePortrait()
		LeanTween.cancel(go(arg0_37._paintingTF))

		arg0_37._paintingTF.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0_37._paintingTF, {
			x = var5_31,
			y = var6_31
		})

		arg0_37.isInView = false

		setActive(arg0_37.clickTF, true)
	end
end

function var0_0.recyclePainting(arg0_38)
	if arg0_38._shipVO then
		retPaintingPrefab(arg0_38._paintingTF, arg0_38._shipVO:getPainting())
	end
end

function var0_0.openSelectPanel(arg0_39)
	arg0_39.selectShipPage:ExecuteAction("Show", ShipSkin.New({
		id = arg0_39.contextData.skinId
	}))
end

function var0_0.updateShipCards(arg0_40)
	for iter0_40, iter1_40 in pairs(arg0_40.shipCards or {}) do
		local var0_40 = arg0_40.sameShipVOs[iter0_40]

		if var0_40 then
			iter1_40:update(var0_40, arg0_40.contextData.skinId)
		end
	end
end

function var0_0.playOpening(arg0_41, arg1_41, arg2_41)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		return
	end, function()
		if arg1_41 then
			arg1_41()
		end
	end, "ui/skinunlockanim", arg2_41, false, false)
end

function var0_0.willExit(arg0_44)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()

	local var0_44 = arg0_44._skinConfig.ship_group * 10 + 1
	local var1_44 = pg.ship_data_statistics[var0_44]

	pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newSkinLayer_get", var1_44.name, arg0_44._skinConfig.name), COLOR_GREEN)
	arg0_44:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_44._tf)
	arg0_44:stopVoice()

	if arg0_44.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_44.loadedCVBankName)

		arg0_44.loadedCVBankName = nil
	end

	arg0_44.selectShipPage:Destroy()
	cameraPaintViewAdjust(false)
end

return var0_0
