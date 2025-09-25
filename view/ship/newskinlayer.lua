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

function var0_0.init(arg0_3)
	arg0_3._shake = arg0_3:findTF("shake_panel")
	arg0_3._shade = arg0_3:findTF("shade")
	arg0_3._bg = arg0_3._shake:Find("bg")
	arg0_3._staticBg = arg0_3._bg:Find("static_bg")
	arg0_3._paintingTF = arg0_3._shake:Find("paint")
	arg0_3._dialogue = arg0_3._shake:Find("dialogue")
	arg0_3._skinName = arg0_3._dialogue:Find("name"):GetComponent(typeof(Text))
	arg0_3._left = arg0_3._shake:Find("left_panel")
	arg0_3._viewBtn = arg0_3._left:Find("view_btn")
	arg0_3._shareBtn = arg0_3._left:Find("share_btn")
	arg0_3.clickTF = arg0_3._shake:Find("click")
	arg0_3.newTF = arg0_3._shake:Find("New")
	arg0_3.timelimit = arg0_3._shake:Find("timelimit")

	setActive(arg0_3.newTF, false)

	arg0_3.changeSkinBtn = arg0_3:findTF("set_skin_btn", arg0_3._shake)
	arg0_3.selectPanel = arg0_3:findTF("select_ship_panel")
	arg0_3.isTimeLimit = arg0_3.contextData.timeLimit

	setActive(arg0_3.timelimit, arg0_3.isTimeLimit)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf)

	arg0_3.isLoadBg = false
	arg0_3.selectShipPage = ChangeShipSkinPage.New(arg0_3._parentTf, arg0_3.event)
	arg0_3.selectShipPage.isNew = true

	function arg0_3.selectShipPage.hideCallback()
		arg0_3:closeView()
	end
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
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewSkin)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.clickTF, function()
		if arg0_17.isInView or not arg0_17.isLoadBg then
			return
		end

		arg0_17:showExitTip()
	end, SFX_CANCEL)

	arg0_17.sameShipVOs = arg0_17:GetShips(arg0_17.contextData.skinId)

	arg0_17:onSwitch(arg0_17.changeSkinBtn, #arg0_17.sameShipVOs > 0)
end

function var0_0.GetShips(arg0_21, arg1_21)
	local var0_21 = getProxy(BayProxy):CanUseShareSkinPhantoms(arg1_21)

	table.sort(var0_21, CompareFuncs({
		function(arg0_22)
			return arg0_22:getSkinId() == arg1_21 and 1 or 0
		end,
		function(arg0_23)
			return -arg0_23.level
		end,
		function(arg0_24)
			return -arg0_24:getStar()
		end,
		function(arg0_25)
			return arg0_25.inFleet and 0 or 1
		end,
		function(arg0_26)
			return arg0_26.createTime
		end
	}))

	return var0_21
end

function var0_0.onBackPressed(arg0_27)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_27.isInView then
		arg0_27:hidePaintView(true)

		return
	end

	if arg0_27.selectShipPage:isShowing() then
		arg0_27.selectShipPage:Hide()

		return
	end

	if isActive(arg0_27.clickTF) then
		triggerButton(arg0_27.clickTF)
	end
end

function var0_0.onSwitch(arg0_28, arg1_28, arg2_28)
	onButton(arg0_28, arg1_28, function()
		if arg2_28 then
			arg0_28:openSelectPanel()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("err_cloth_change_noship", arg0_28.shipName))
		end
	end)
end

function var0_0.paintView(arg0_30)
	local var0_30 = {}
	local var1_30 = arg0_30._shake.childCount
	local var2_30 = 0

	while var2_30 < var1_30 do
		local var3_30 = arg0_30._shake:GetChild(var2_30)

		if var3_30.gameObject.activeSelf and var3_30 ~= arg0_30._paintingTF and var3_30 ~= arg0_30._bg then
			var0_30[#var0_30 + 1] = var3_30

			setActive(var3_30, false)
		end

		var2_30 = var2_30 + 1
	end

	openPortrait()

	local var4_30 = arg0_30._paintingTF
	local var5_30 = var4_30.anchoredPosition.x
	local var6_30 = var4_30.anchoredPosition.y
	local var7_30 = var4_30.rect.width
	local var8_30 = var4_30.rect.height
	local var9_30 = arg0_30._tf.rect.width / UnityEngine.Screen.width
	local var10_30 = arg0_30._tf.rect.height / UnityEngine.Screen.height
	local var11_30 = var7_30 / 2
	local var12_30 = var8_30 / 2
	local var13_30
	local var14_30

	if not LeanTween.isTweening(go(var4_30)) then
		LeanTween.moveX(rtf(var4_30), 150, 0.5):setEase(LeanTweenType.easeInOutSine)
	end

	local var15_30 = GetOrAddComponent(arg0_30._bg, "MultiTouchZoom")

	var15_30:SetZoomTarget(arg0_30._paintingTF)

	local var16_30 = GetOrAddComponent(arg0_30._bg, "EventTriggerListener")
	local var17_30 = true

	var15_30.enabled = true
	var16_30.enabled = true

	local var18_30 = false

	var16_30:AddPointDownFunc(function(arg0_31)
		if Input.touchCount == 1 or IsUnityEditor then
			var18_30 = true
			var17_30 = true
		elseif Input.touchCount >= 2 then
			var17_30 = false
			var18_30 = false
		end
	end)
	var16_30:AddPointUpFunc(function(arg0_32)
		if Input.touchCount <= 2 then
			var17_30 = true
		end
	end)
	var16_30:AddBeginDragFunc(function(arg0_33, arg1_33)
		var18_30 = false
		var13_30 = arg1_33.position.x * var9_30 - var11_30 - tf(arg0_30._paintingTF).localPosition.x
		var14_30 = arg1_33.position.y * var10_30 - var12_30 - tf(arg0_30._paintingTF).localPosition.y
	end)
	var16_30:AddDragFunc(function(arg0_34, arg1_34)
		if var17_30 then
			local var0_34 = tf(arg0_30._paintingTF).localPosition

			tf(arg0_30._paintingTF).localPosition = Vector3(arg1_34.position.x * var9_30 - var11_30 - var13_30, arg1_34.position.y * var10_30 - var12_30 - var14_30, -22)
		end
	end)
	onButton(arg0_30, arg0_30._bg, function()
		arg0_30:hidePaintView()
	end, SFX_CANCEL)

	function var0_0.hidePaintView(arg0_36, arg1_36)
		if not arg1_36 and not var18_30 then
			return
		end

		var16_30.enabled = false
		var15_30.enabled = false

		RemoveComponent(arg0_36._bg, "Button")

		for iter0_36, iter1_36 in ipairs(var0_30) do
			setActive(iter1_36, true)
		end

		closePortrait()
		LeanTween.cancel(go(arg0_36._paintingTF))

		arg0_36._paintingTF.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0_36._paintingTF, {
			x = var5_30,
			y = var6_30
		})

		arg0_36.isInView = false

		setActive(arg0_36.clickTF, true)
	end
end

function var0_0.recyclePainting(arg0_37)
	if arg0_37._shipVO then
		retPaintingPrefab(arg0_37._paintingTF, arg0_37._shipVO:getPainting())
	end
end

function var0_0.openSelectPanel(arg0_38)
	arg0_38.selectShipPage:ExecuteAction("Show", ShipSkin.New({
		id = arg0_38.contextData.skinId
	}))
end

function var0_0.updateShipCards(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.shipCards or {}) do
		local var0_39 = arg0_39.sameShipVOs[iter0_39]

		if var0_39 then
			iter1_39:update(var0_39, arg0_39.contextData.skinId)
		end
	end
end

function var0_0.playOpening(arg0_40, arg1_40, arg2_40)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		return
	end, function()
		if arg1_40 then
			arg1_40()
		end
	end, "ui/skinunlockanim", arg2_40, false, false)
end

function var0_0.willExit(arg0_43)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()

	local var0_43 = arg0_43._skinConfig.ship_group * 10 + 1
	local var1_43 = pg.ship_data_statistics[var0_43]

	pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newSkinLayer_get", var1_43.name, arg0_43._skinConfig.name), COLOR_GREEN)
	arg0_43:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_43._tf)
	arg0_43:stopVoice()

	if arg0_43.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_43.loadedCVBankName)

		arg0_43.loadedCVBankName = nil
	end

	arg0_43.selectShipPage:Destroy()
	cameraPaintViewAdjust(false)
end

return var0_0
