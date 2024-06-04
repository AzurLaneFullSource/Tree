local var0 = class("NewSkinLayer", import("..base.BaseUI"))

var0.PAINT_DURATION = 0.35
var0.STAR_DURATION = 0.5

local var1 = 19

function var0.getUIName(arg0)
	return "NewSkinUI"
end

function var0.preload(arg0, arg1)
	local var0 = arg0.contextData.skinId
	local var1 = pg.ship_skin_template[var0]
	local var2 = var1.ship_group
	local var3 = var2 * 10 + 1
	local var4 = pg.ship_data_statistics[var3]
	local var5

	if var1.bg_sp and var1.bg_sp ~= "" then
		var5 = var1.bg_sp
	else
		var5 = var1.bg and #var1.bg > 0 and var1.bg or var1.rarity_bg and #var1.rarity_bg > 0 and var1.rarity_bg
	end

	local var6

	var6 = var5 and "bg/star_level_bg_" .. var5 or "newshipbg/bg_" .. shipRarity2bgPrint(var4.rarity, ShipGroup.IsBluePrintGroup(var2), ShipGroup.IsMetaGroup(var2))

	GetSpriteFromAtlasAsync(var6, "", arg1)
end

function var0.setShipVOs(arg0, arg1)
	arg0.shipVOs = arg1
	arg0.sameShipVOs = arg0:getSameGroupShips()
end

function var0.init(arg0)
	arg0._shake = arg0:findTF("shake_panel")
	arg0._shade = arg0:findTF("shade")
	arg0._bg = arg0._shake:Find("bg")
	arg0._staticBg = arg0._bg:Find("static_bg")
	arg0._paintingTF = arg0._shake:Find("paint")
	arg0._dialogue = arg0._shake:Find("dialogue")
	arg0._skinName = arg0._dialogue:Find("name"):GetComponent(typeof(Text))
	arg0._left = arg0._shake:Find("left_panel")
	arg0._viewBtn = arg0._left:Find("view_btn")
	arg0._shareBtn = arg0._left:Find("share_btn")
	arg0.clickTF = arg0._shake:Find("click")
	arg0.newTF = arg0._shake:Find("New")
	arg0.timelimit = arg0._shake:Find("timelimit")

	setActive(arg0.newTF, false)

	arg0.changeSkinBtn = arg0:findTF("set_skin_btn", arg0._shake)
	arg0.selectPanel = arg0:findTF("select_ship_panel")
	arg0.selectPanelCloseBtn = arg0:findTF("window/top/btnBack", arg0.selectPanel)
	arg0.shipContent = arg0:findTF("window/sliders/scroll_rect/content", arg0.selectPanel)
	arg0.shipCardTpl = arg0._tf:GetComponent("ItemList").prefabItem[0]
	arg0.confirmChangeBtn = arg0:findTF("window/exchange_btn", arg0.selectPanel)
	arg0.flagShipToggle = arg0:findTF("window/flag_ship", arg0.selectPanel)

	setActive(arg0.selectPanel, false)

	arg0.isTimeLimit = arg0.contextData.timeLimit

	setActive(arg0.timelimit, arg0.isTimeLimit)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	arg0.isLoadBg = false
end

function var0.voice(arg0, arg1)
	if not arg1 then
		return
	end

	arg0:stopVoice()

	arg0._currentVoice = arg1

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1)
end

function var0.stopVoice(arg0)
	if arg0._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0._currentVoice)
	end

	arg0._currentVoice = nil
end

function var0.setSkin(arg0, arg1)
	arg0.cg = GetOrAddComponent(arg0._tf, typeof(CanvasGroup))
	arg0.cg.alpha = 0

	setActive(arg0._shade, true)

	arg0._shade:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 1)

	local var0 = "star_level_unlock_anim_" .. arg1

	if checkABExist("ui/skinunlockanim/" .. var0) then
		arg0:playOpening(function()
			arg0:setSkinPri(arg1)
		end, var0)
	else
		arg0:setSkinPri(arg1)
	end
end

function var0.setSkinPri(arg0, arg1)
	local var0 = arg0:loadUISync("getrole")

	var0.layer = LayerMask.NameToLayer("UI")
	var0.transform.localPosition = Vector3(0, 0, -10)

	setParent(var0, arg0._tf, false)
	setActive(var0, false)
	onNextTick(function()
		setActive(var0, true)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_CHARGET)

	arg0.cg.alpha = 1
	arg0._shade:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0)

	arg0:recyclePainting()

	arg0._skinConfig = pg.ship_skin_template[arg1]

	local var1 = pg.ship_skin_template[arg1].ship_group
	local var2 = pg.ship_data_statistics[arg0._skinConfig.ship_group * 10 + 1]
	local var3

	if arg0._skinConfig.bg_sp and arg0._skinConfig.bg_sp ~= "" then
		var3 = arg0._skinConfig.bg_sp
	else
		var3 = arg0._skinConfig.bg and #arg0._skinConfig.bg > 0 and arg0._skinConfig.bg or arg0._skinConfig.rarity_bg and #arg0._skinConfig.rarity_bg > 0 and arg0._skinConfig.rarity_bg
	end

	if var3 then
		pg.DynamicBgMgr.GetInstance():LoadBg(arg0, var3, arg0._bg, arg0._staticBg, function(arg0)
			arg0.isLoadBg = true
		end, function(arg0)
			arg0.isLoadBg = true
		end)
	else
		local var4 = "newshipbg/bg_" .. shipRarity2bgPrint(var2.rarity, ShipGroup.IsBluePrintGroup(var1), ShipGroup.IsMetaGroup(var1))

		GetSpriteFromAtlasAsync(var4, "", function(arg0)
			setImageSprite(arg0._staticBg, arg0, true)

			arg0.isLoadBg = true
		end)
	end

	setPaintingPrefabAsync(arg0._paintingTF, arg0._skinConfig.painting, "huode")

	arg0._skinName.text = i18n("ship_newSkin_name", arg0._skinConfig.name)

	local var5
	local var6 = ""
	local var7
	local var8 = ShipWordHelper.RawGetWord(arg1, ShipWordHelper.WORD_TYPE_UNLOCK)

	if var8 == "" then
		local var9

		var9, var7, var8 = ShipWordHelper.GetWordAndCV(arg1, ShipWordHelper.WORD_TYPE_DROP)
	else
		local var10

		var10, var7, var8 = ShipWordHelper.GetWordAndCV(arg1, ShipWordHelper.WORD_TYPE_UNLOCK)
	end

	setWidgetText(arg0._dialogue, SwitchSpecialChar(var8, true), "desc/Text")

	arg0._dialogue.transform.localScale = Vector3(0, 1, 1)

	SetActive(arg0._dialogue, false)
	SetActive(arg0._dialogue, true)
	LeanTween.scale(arg0._dialogue, Vector3(1, 1, 1), 0.1):setOnComplete(System.Action(function()
		setActive(arg0._shade, false)
		setActive(arg0.clickTF, true)
		arg0:voice(var7)
	end))
end

function var0.showExitTip(arg0)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("give_up_cloth_change"),
		onYes = function()
			arg0:emit(var0.ON_CLOSE)
		end
	})
end

function var0.didEnter(arg0)
	local var0 = ShipWordHelper.GetDefaultSkin(arg0.contextData.skinId)

	arg0.shipName = pg.ship_skin_template[var0].name

	onButton(arg0, arg0._viewBtn, function()
		arg0.isInView = true

		arg0:paintView()
		setActive(arg0.clickTF, false)
	end, SFX_PANEL)
	onButton(arg0, arg0._shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewSkin, nil, {
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.clickTF, function()
		if arg0.isInView or not arg0.isLoadBg then
			return
		end

		arg0:showExitTip()
	end, SFX_CANCEL)
	onButton(arg0, arg0.selectPanel, function()
		arg0:closeSelectPanel()
	end, SFX_PANEL)

	local var1 = getProxy(SettingsProxy):GetSetFlagShip()

	onToggle(arg0, arg0.flagShipToggle, function(arg0)
		arg0.flagShipMark = arg0
	end, SFX_PANEL)
	triggerToggle(arg0.flagShipToggle, var1)
	arg0:onSwitch(arg0.changeSkinBtn, table.getCount(arg0.sameShipVOs) > 0)
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0.isInView then
		arg0:hidePaintView(true)

		return
	end

	if isActive(arg0.selectPanel) then
		arg0:closeSelectPanel()

		return
	end

	if isActive(arg0.clickTF) then
		triggerButton(arg0.clickTF)
	end
end

function var0.onSwitch(arg0, arg1, arg2)
	onButton(arg0, arg1, function()
		if arg2 then
			arg0:openSelectPanel()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("err_cloth_change_noship", arg0.shipName))
		end
	end)
end

function var0.getSameGroupShips(arg0)
	local var0 = {}
	local var1 = arg0.contextData.skinId
	local var2 = pg.ship_skin_template[var1].ship_group

	for iter0, iter1 in pairs(arg0.shipVOs) do
		if iter1.groupId == var2 then
			var0[iter1.id] = iter1
		end
	end

	local var3 = getProxy(BayProxy):CanUseShareSkinShips(var1)

	for iter2, iter3 in ipairs(var3) do
		var0[iter3.id] = iter3
	end

	return var0
end

function var0.paintView(arg0)
	local var0 = {}
	local var1 = arg0._shake.childCount
	local var2 = 0

	while var2 < var1 do
		local var3 = arg0._shake:GetChild(var2)

		if var3.gameObject.activeSelf and var3 ~= arg0._paintingTF and var3 ~= arg0._bg then
			var0[#var0 + 1] = var3

			setActive(var3, false)
		end

		var2 = var2 + 1
	end

	openPortrait()

	local var4 = arg0._paintingTF
	local var5 = var4.anchoredPosition.x
	local var6 = var4.anchoredPosition.y
	local var7 = var4.rect.width
	local var8 = var4.rect.height
	local var9 = arg0._tf.rect.width / UnityEngine.Screen.width
	local var10 = arg0._tf.rect.height / UnityEngine.Screen.height
	local var11 = var7 / 2
	local var12 = var8 / 2
	local var13
	local var14

	if not LeanTween.isTweening(go(var4)) then
		LeanTween.moveX(rtf(var4), 150, 0.5):setEase(LeanTweenType.easeInOutSine)
	end

	local var15 = GetOrAddComponent(arg0._bg, "MultiTouchZoom")

	var15:SetZoomTarget(arg0._paintingTF)

	local var16 = GetOrAddComponent(arg0._bg, "EventTriggerListener")
	local var17 = true

	var15.enabled = true
	var16.enabled = true

	local var18 = false

	var16:AddPointDownFunc(function(arg0)
		if Input.touchCount == 1 or IsUnityEditor then
			var18 = true
			var17 = true
		elseif Input.touchCount >= 2 then
			var17 = false
			var18 = false
		end
	end)
	var16:AddPointUpFunc(function(arg0)
		if Input.touchCount <= 2 then
			var17 = true
		end
	end)
	var16:AddBeginDragFunc(function(arg0, arg1)
		var18 = false
		var13 = arg1.position.x * var9 - var11 - tf(arg0._paintingTF).localPosition.x
		var14 = arg1.position.y * var10 - var12 - tf(arg0._paintingTF).localPosition.y
	end)
	var16:AddDragFunc(function(arg0, arg1)
		if var17 then
			local var0 = tf(arg0._paintingTF).localPosition

			tf(arg0._paintingTF).localPosition = Vector3(arg1.position.x * var9 - var11 - var13, arg1.position.y * var10 - var12 - var14, -22)
		end
	end)
	onButton(arg0, arg0._bg, function()
		arg0:hidePaintView()
	end, SFX_CANCEL)

	function var0.hidePaintView(arg0, arg1)
		if not arg1 and not var18 then
			return
		end

		var16.enabled = false
		var15.enabled = false

		RemoveComponent(arg0._bg, "Button")

		for iter0, iter1 in ipairs(var0) do
			setActive(iter1, true)
		end

		closePortrait()
		LeanTween.cancel(go(arg0._paintingTF))

		arg0._paintingTF.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0._paintingTF, {
			x = var5,
			y = var6
		})

		arg0.isInView = false

		setActive(arg0.clickTF, true)
	end
end

function var0.recyclePainting(arg0)
	if arg0._shipVO then
		retPaintingPrefab(arg0._paintingTF, arg0._shipVO:getPainting())
	end
end

function var0.openSelectPanel(arg0)
	removeAllChildren(arg0.shipContent)

	arg0.isOpenSelPanel = true
	arg0.selectIds = {}

	setActive(arg0.selectPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.selectPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0.shipCards = {}

	local var0 = {}

	for iter0, iter1 in pairs(arg0.sameShipVOs) do
		table.insert(var0, iter1)
	end

	table.sort(var0, function(arg0, arg1)
		if arg0.level == arg1.level then
			local var0 = arg0:getStar()
			local var1 = arg1:getStar()

			if var0 == var1 then
				local var2 = arg0.inFleet and 1 or 0
				local var3 = arg1.inFleet and 1 or 0

				if var2 == var3 then
					return arg0.createTime < arg1.createTime
				else
					return var3 < var2
				end
			else
				return var1 < var0
			end
		else
			return arg0.level > arg1.level
		end
	end)

	for iter2, iter3 in ipairs(var0) do
		local var1 = cloneTplTo(arg0.shipCardTpl, arg0.shipContent)
		local var2 = ShipDetailCard.New(var1.gameObject)

		var2:update(iter3, arg0.contextData.skinId)

		arg0.shipCards[iter3.id] = var2

		onToggle(arg0, var2.tr, function(arg0)
			var2:updateSelected(arg0)

			if arg0 then
				table.insert(arg0.selectIds, var2.shipVO.id)
			else
				for iter0, iter1 in pairs(arg0.selectIds) do
					if iter1 == var2.shipVO.id then
						table.remove(arg0.selectIds, iter0)

						break
					end
				end
			end
		end)
	end

	onButton(arg0, arg0.confirmChangeBtn, function()
		if not arg0.selectIds or #arg0.selectIds <= 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("new_skin_no_choose"),
				weight = LayerWeightConst.TOP_LAYER + 1,
				onYes = function()
					arg0:emit(var0.ON_CLOSE)
				end
			})

			return
		end

		arg0:emit(NewSkinMediator.SET_SKIN, arg0.selectIds, arg0.flagShipMark)
	end)
	onButton(arg0, arg0.selectPanelCloseBtn, function()
		arg0:closeSelectPanel()
	end)
end

function var0.updateShipCards(arg0)
	for iter0, iter1 in pairs(arg0.shipCards or {}) do
		local var0 = arg0.sameShipVOs[iter0]

		if var0 then
			iter1:update(var0, arg0.contextData.skinId)
		end
	end
end

function var0.closeSelectPanel(arg0)
	if arg0.isOpenSelPanel then
		arg0.isOpenSelPanel = nil

		setActive(arg0.selectPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.selectPanel, arg0._tf)
	end
end

function var0.playOpening(arg0, arg1, arg2)
	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		return
	end, function()
		if arg1 then
			arg1()
		end
	end, "ui/skinunlockanim", arg2, false, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0.willExit(arg0)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()

	local var0 = arg0._skinConfig.ship_group * 10 + 1
	local var1 = pg.ship_data_statistics[var0]

	pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newSkinLayer_get", var1.name, arg0._skinConfig.name), COLOR_GREEN)
	arg0:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	arg0:stopVoice()

	if arg0.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0.loadedCVBankName)

		arg0.loadedCVBankName = nil
	end

	arg0:closeSelectPanel()
	cameraPaintViewAdjust(false)
end

return var0
