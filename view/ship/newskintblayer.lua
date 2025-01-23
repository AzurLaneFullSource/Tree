local var0_0 = class("NewSkinTBLayer", import("view.ship.NewSkinLayer"))

function var0_0.getUIName(arg0_1)
	return "NewSkinUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = arg0_2.contextData.skinId
	local var1_2 = pg.ship_skin_template[var0_2]
	local var2_2

	if var1_2.bg_sp and var1_2.bg_sp ~= "" then
		var2_2 = var1_2.bg_sp
	else
		var2_2 = var1_2.bg and #var1_2.bg > 0 and var1_2.bg or var1_2.rarity_bg and #var1_2.rarity_bg > 0 and var1_2.rarity_bg
	end

	local var3_2

	var3_2 = var2_2 and "bg/star_level_bg_" .. var2_2 or nil

	if var3_2 then
		GetSpriteFromAtlasAsync(var3_2, "", arg1_2)
	else
		existCall(arg1_2)
	end
end

function var0_0.setSkinPri(arg0_3, arg1_3)
	local var0_3 = arg0_3:loadUISync("getrole")

	var0_3.layer = LayerMask.NameToLayer("UI")
	var0_3.transform.localPosition = Vector3(0, 0, -10)

	setParent(var0_3, arg0_3._tf, false)
	setActive(var0_3, false)
	onNextTick(function()
		setActive(var0_3, true)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_CHARGET)

	arg0_3.cg.alpha = 1
	arg0_3._shade:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0)

	arg0_3:recyclePainting()

	arg0_3._skinConfig = pg.ship_skin_template[arg1_3]

	local var1_3

	if arg0_3._skinConfig.bg_sp and arg0_3._skinConfig.bg_sp ~= "" then
		var1_3 = arg0_3._skinConfig.bg_sp
	else
		var1_3 = arg0_3._skinConfig.bg and #arg0_3._skinConfig.bg > 0 and arg0_3._skinConfig.bg or arg0_3._skinConfig.rarity_bg and #arg0_3._skinConfig.rarity_bg > 0 and arg0_3._skinConfig.rarity_bg
	end

	if var1_3 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_3, var1_3, arg0_3._bg, arg0_3._staticBg, function(arg0_5)
			arg0_3.isLoadBg = true
		end, function(arg0_6)
			arg0_3.isLoadBg = true
		end)
	end

	setPaintingPrefabAsync(arg0_3._paintingTF, arg0_3._skinConfig.painting, "huode")

	arg0_3._skinName.text = i18n("ship_newSkin_name", arg0_3._skinConfig.name)

	local var2_3
	local var3_3 = ""
	local var4_3
	local var5_3, var6_3, var7_3 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg1_3), "login")

	setWidgetText(arg0_3._dialogue, SwitchSpecialChar(var7_3, true), "desc/Text")

	arg0_3._dialogue.transform.localScale = Vector3(0, 1, 1)

	SetActive(arg0_3._dialogue, false)
	SetActive(arg0_3._dialogue, true)
	LeanTween.scale(arg0_3._dialogue, Vector3(1, 1, 1), 0.1):setOnComplete(System.Action(function()
		setActive(arg0_3._shade, false)
		setActive(arg0_3.clickTF, true)
		arg0_3:voice(var6_3)
	end))
end

function var0_0.didEnter(arg0_8)
	arg0_8.shipName = NewEducateHelper.GetShipNameBySecId(arg0_8.contextData.secId)

	onButton(arg0_8, arg0_8._viewBtn, function()
		arg0_8.isInView = true

		arg0_8:paintView()
		setActive(arg0_8.clickTF, false)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewSkin, nil, {
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.clickTF, function()
		if arg0_8.isInView or not arg0_8.isLoadBg then
			return
		end

		arg0_8:showExitTip()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.selectPanel, function()
		arg0_8:closeSelectPanel()
	end, SFX_PANEL)

	local var0_8 = getProxy(SettingsProxy):GetSetFlagShip()

	onToggle(arg0_8, arg0_8.flagShipToggle, function(arg0_13)
		arg0_8.flagShipMark = arg0_13
	end, SFX_PANEL)
	triggerToggle(arg0_8.flagShipToggle, var0_8)
	onButton(arg0_8, arg0_8.changeSkinBtn, function()
		if NewEducateHelper.IsUnlockDefaultShip(NewEducateHelper.GetSecIdBySkinId(arg0_8.contextData.skinId)) then
			arg0_8.hideExitTip = true

			arg0_8:emit(NewSkinTBMediator.GO_SET_TB_SKIN)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_character_buy_unlock"))
		end
	end)

	if arg0_8.contextData.isClose then
		onNextTick(function()
			arg0_8:closeView()
		end)
	end
end

function var0_0.willExit(arg0_16)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()

	if not arg0_16.hideExitTip then
		local var0_16 = pg.ship_skin_template[arg0_16.contextData.skinId].name
		local var1_16 = NewEducateHelper.GetShipNameBySecId(arg0_16.contextData.secId)

		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newSkinLayer_get", var1_16, var0_16), COLOR_GREEN)
	end

	arg0_16:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_16._tf)
	arg0_16:stopVoice()

	if arg0_16.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_16.loadedCVBankName)

		arg0_16.loadedCVBankName = nil
	end

	arg0_16:closeSelectPanel()
	cameraPaintViewAdjust(false)
end

return var0_0
