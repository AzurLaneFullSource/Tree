local var0_0 = class("NewSkinTBLayer", import("view.ship.NewSkinLayer"))

function var0_0.getUIName(arg0_1)
	return "NewSkinUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = arg0_2.contextData.skinId
	local var1_2 = {
		var0_2 and ShipSkin.GetBgPrint(var0_2, true) or nil
	}

	return table.insertto(var1_2, var0_0.super.getResource(arg0_2))
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = ShipSkin.GetBgPrint(arg0_3.contextData.skinId, true)

	if var0_3 then
		GetSpriteFromAtlasAsync(var0_3, "", arg1_3)
	else
		existCall(arg1_3)
	end
end

function var0_0.setSkinPri(arg0_4, arg1_4)
	local var0_4 = arg0_4:loadUISync("getrole")

	var0_4.layer = LayerMask.NameToLayer("UI")
	var0_4.transform.localPosition = Vector3(0, 0, -10)

	setParent(var0_4, arg0_4._tf, false)
	setActive(var0_4, false)
	onNextTick(function()
		setActive(var0_4, true)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_CHARGET)

	arg0_4.cg.alpha = 1
	arg0_4._shade:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0)

	arg0_4:recyclePainting()

	arg0_4._skinConfig = pg.ship_skin_template[arg1_4]

	local var1_4

	if arg0_4._skinConfig.bg_sp and arg0_4._skinConfig.bg_sp ~= "" then
		var1_4 = arg0_4._skinConfig.bg_sp
	else
		var1_4 = arg0_4._skinConfig.bg and #arg0_4._skinConfig.bg > 0 and arg0_4._skinConfig.bg or arg0_4._skinConfig.rarity_bg and #arg0_4._skinConfig.rarity_bg > 0 and arg0_4._skinConfig.rarity_bg
	end

	if var1_4 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0_4, var1_4, arg0_4._bg, arg0_4._staticBg, function(arg0_6)
			arg0_4.isLoadBg = true
		end, function(arg0_7)
			arg0_4.isLoadBg = true
		end)
	end

	setPaintingPrefabAsync(arg0_4._paintingTF, arg0_4._skinConfig.painting, "huode")

	arg0_4._skinName.text = i18n("ship_newSkin_name", arg0_4._skinConfig.name)

	local var2_4
	local var3_4 = ""
	local var4_4
	local var5_4, var6_4, var7_4 = EducateCharWordHelper.GetWordAndCV(NewEducateHelper.GetSecIdBySkinId(arg1_4), "login")

	setWidgetText(arg0_4._dialogue, SwitchSpecialChar(var7_4, true), "desc/Text")

	arg0_4._dialogue.transform.localScale = Vector3(0, 1, 1)

	SetActive(arg0_4._dialogue, false)
	SetActive(arg0_4._dialogue, true)
	LeanTween.scale(arg0_4._dialogue, Vector3(1, 1, 1), 0.1):setOnComplete(System.Action(function()
		setActive(arg0_4._shade, false)
		setActive(arg0_4.clickTF, true)
		arg0_4:voice(var6_4)
	end))
end

function var0_0.didEnter(arg0_9)
	arg0_9.shipName = NewEducateHelper.GetShipNameBySecId(arg0_9.contextData.secId)

	onButton(arg0_9, arg0_9._viewBtn, function()
		arg0_9.isInView = true

		arg0_9:paintView()
		setActive(arg0_9.clickTF, false)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewSkin)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.clickTF, function()
		if arg0_9.isInView or not arg0_9.isLoadBg then
			return
		end

		arg0_9:showExitTip()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.changeSkinBtn, function()
		if NewEducateHelper.IsUnlockDefaultShip(NewEducateHelper.GetSecIdBySkinId(arg0_9.contextData.skinId)) then
			arg0_9.hideExitTip = true

			arg0_9:emit(NewSkinTBMediator.GO_SET_TB_SKIN)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_character_buy_unlock"))
		end
	end)

	if arg0_9.contextData.isClose then
		onNextTick(function()
			arg0_9:closeView()
		end)
	end
end

function var0_0.willExit(arg0_15)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()

	if not arg0_15.hideExitTip then
		local var0_15 = pg.ship_skin_template[arg0_15.contextData.skinId].name
		local var1_15 = NewEducateHelper.GetShipNameBySecId(arg0_15.contextData.secId)

		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newSkinLayer_get", var1_15, var0_15), COLOR_GREEN)
	end

	arg0_15:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._tf)
	arg0_15:stopVoice()

	if arg0_15.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_15.loadedCVBankName)

		arg0_15.loadedCVBankName = nil
	end

	arg0_15.selectShipPage:Destroy()
	cameraPaintViewAdjust(false)
end

return var0_0
