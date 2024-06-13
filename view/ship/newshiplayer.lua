local var0 = class("NewShipLayer", import("..base.BaseUI"))

var0.PAINT_DURATION = 0.35
var0.STAR_DURATION = 0.5
var0.STAR_ANIMATION_DUR1 = 0.075
var0.STAR_ANIMATION_DUR2 = 0.1
var0.STAR_ANIMATION_DUR3 = 0.4
var0.STAR_ANIMATION_DUR4 = 0.26

local var1 = 19

function var0.getUIName(arg0)
	return "NewShipUI"
end

function var0.getLayerWeight(arg0)
	return LayerWeightConst.THIRD_LAYER
end

function var0.preload(arg0, arg1)
	local var0 = arg0.contextData.ship

	LoadSpriteAsync("newshipbg/bg_" .. var0:rarity2bgPrintForGet(), function(arg0)
		arg0.bgSprite = arg0
		arg0.isLoadBg = true

		arg1()
	end)
end

function var0.init(arg0)
	arg0._animator = GetComponent(arg0._tf, "Animator")
	arg0._canvasGroup = GetOrAddComponent(arg0._tf, typeof(CanvasGroup))
	arg0._shake = arg0:findTF("shake_panel")
	arg0._shade = arg0:findTF("shade")
	arg0._bg = arg0._shake:Find("bg")
	arg0._drag = arg0._shake:Find("drag")
	arg0._paintingTF = arg0._shake:Find("paint")
	arg0._paintingShadowTF = arg0._shake:Find("shadow")
	arg0._dialogue = arg0._shake:Find("dialogue")
	arg0._shipName = arg0._dialogue:Find("bg/name"):GetComponent(typeof(Text))
	arg0._shipType = arg0._dialogue:Find("bg/type"):GetComponent(typeof(Text))
	arg0._dialogueText = arg0._dialogue:Find("Text")
	arg0._left = arg0._shake:Find("ForNotch/left_panel")
	arg0._lockTF = arg0._left:Find("lock")
	arg0._lockBtn = arg0._left:Find("lock/lock")
	arg0._unlockBtn = arg0._left:Find("lock/unlock_btn")
	arg0._viewBtn = arg0._left:Find("view_btn")
	arg0._evaluationBtn = arg0._left:Find("evaluation_btn")
	arg0._shareBtn = arg0._left:Find("share_btn")
	arg0.audioBtn = arg0._shake:Find("property_btn")
	arg0.clickTF = arg0._shake:Find("click")
	arg0.npc = arg0:findTF("shake_panel/npc")

	setActive(arg0.npc, false)

	arg0.newTF = arg0._shake:Find("New")
	arg0.rarityTF = arg0._shake:Find("rarity")
	arg0.starsTF = arg0.rarityTF:Find("stars")
	arg0.starsCont = arg0:findTF("content", arg0.starsTF)
	arg0._skipButton = arg0._shake:Find("ForNotch/skip")

	setActive(arg0._skipButton, arg0.contextData.canSkipBatch)
	setActive(arg0._left, true)
	setActive(arg0.audioBtn, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		hideLowerLayer = true,
		weight = arg0:getWeightFromData()
	})

	arg0.metaRepeatTF = arg0:findTF("MetaRepeat", arg0.rarityTF)
	arg0.metaDarkTF = arg0:findTF("MetaMask", arg0._shake)
	arg0.rarityEffect = {}

	if arg0.contextData.autoExitTime then
		arg0.autoExitTimer = Timer.New(function()
			arg0:showExitTip()
		end, arg0.contextData.autoExitTime)

		arg0.autoExitTimer:Start()

		arg0.contextData.autoExitTime = nil
	end

	arg0:PauseAnimation()
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

function var0.setShip(arg0, arg1)
	arg0:recyclePainting()

	arg0._shipVO = arg1
	arg0.isRemoulded = arg1:isRemoulded()

	local var0 = arg1:isBluePrintShip()
	local var1 = arg1:isMetaShip()

	setImageSprite(arg0._bg, arg0.bgSprite)
	setActive(arg0.metaDarkTF, arg1:isMetaShip())

	if var0 then
		if arg0.metaBg then
			setActive(arg0.metaBg, false)
		end

		if arg0.designBg and arg0.designName ~= "raritydesign" .. arg1:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0.designName, arg0.designBg)

			arg0.designBg = nil
		end

		if not arg0.designBg then
			PoolMgr.GetInstance():GetUI("raritydesign" .. arg1:getRarity(), true, function(arg0)
				arg0.designBg = arg0
				arg0.designName = "raritydesign" .. arg1:getRarity()

				arg0.transform:SetParent(arg0._shake, false)

				arg0.transform.localPosition = Vector3(1, 1, 1)
				arg0.transform.localScale = Vector3(1, 1, 1)

				arg0.transform:SetSiblingIndex(1)
				setActive(arg0, true)
			end)
		else
			setActive(arg0.designBg, true)
		end
	elseif var1 then
		if arg0.designBg then
			setActive(arg0.designBg, false)
		end

		if arg0.metaBg and arg0.metaName ~= "raritymeta" .. arg1:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0.metaName, arg0.metaBg)

			arg0.metaBg = nil
		end

		if not arg0.metaBg then
			PoolMgr.GetInstance():GetUI("raritymeta" .. arg1:getRarity(), true, function(arg0)
				arg0.metaBg = arg0
				arg0.metaName = "raritymeta" .. arg1:getRarity()

				arg0.transform:SetParent(arg0._shake, false)

				arg0.transform.localPosition = Vector3(1, 1, 1)
				arg0.transform.localScale = Vector3(1, 1, 1)

				arg0.transform:SetSiblingIndex(1)
				setActive(arg0, true)
			end)
		else
			setActive(arg0.metaBg, true)
		end
	else
		if arg0.designBg then
			setActive(arg0.designBg, false)
		end

		if arg0.metaBg then
			setActive(arg0.metaBg, false)
		end
	end

	if arg1.virgin and not arg0.isRemoulded and not arg1:isActivityNpc() then
		setActive(arg0.newTF, true)
		LoadImageSpriteAsync("clutter/new", arg0.newTF)

		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg0._shipVO.groupId, 1) then
			local var2 = pg.fleet_tech_ship_template[arg0._shipVO.groupId].pt_get
			local var3 = ShipType.FilterOverQuZhuType(pg.fleet_tech_ship_template[arg0._shipVO.groupId].add_get_shiptype)
			local var4 = pg.fleet_tech_ship_template[arg0._shipVO.groupId].add_get_attr
			local var5 = pg.fleet_tech_ship_template[arg0._shipVO.groupId].add_get_value

			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
				point = var2,
				typeList = var3,
				attr = var4,
				value = var5
			})
		end
	else
		setActive(arg0.newTF, false)

		local var6 = arg1:getReMetaSpecialItemVO()

		arg0:updateLockTF(var6 ~= nil)

		if var6 then
			local var7 = arg0:findTF("Icon", arg0.metaRepeatTF)
			local var8 = arg0:findTF("Count", arg0.metaRepeatTF)

			setImageSprite(var7, LoadSprite(var6:getConfig("icon")))
			GetImageSpriteFromAtlasAsync(var6:getConfig("icon"), "", var7)
			setText(var8, var6.count)

			local var9 = pg.ship_transform[arg0._shipVO.groupId].exclusive_item[1][2]
			local var10 = pg.ship_transform[arg0._shipVO.groupId].common_item[1][2]
			local var11 = arg0:findTF("Special", arg0.metaRepeatTF)
			local var12 = arg0:findTF("Commom", arg0.metaRepeatTF)

			setActive(var11, var6.id == var9)
			setActive(var12, var6.id == var10)
		else
			setActive(arg0.metaRepeatTF, false)
		end
	end

	setActive(arg0.audioBtn, not arg0.isRemoulded)
	arg0:UpdateLockButton(arg0._shipVO:GetLockState())

	local var13 = arg0._shipVO:getConfigTable()

	if arg0.isRemoulded then
		setPaintingPrefabAsync(arg0._paintingTF, arg0._shipVO:getRemouldPainting(), "huode")
		setPaintingPrefabAsync(arg0._paintingShadowTF, arg0._shipVO:getRemouldPainting(), "huode")
	else
		setPaintingPrefabAsync(arg0._paintingTF, arg0._shipVO:getPainting(), "huode")
		setPaintingPrefabAsync(arg0._paintingShadowTF, arg0._shipVO:getPainting(), "huode")
	end

	arg0._shipType.text = pg.ship_data_by_type[arg0._shipVO:getShipType()].type_name
	arg0._shipName.text = arg1:getName()

	local var14 = arg1:getRarity()
	local var15 = pg.ship_data_template[var13.id].star_max
	local var16 = arg0._shipVO:getStar()

	if not (var15 % 2 == 0) or not (var15 / 2) then
		local var17 = math.floor(var15 / 2) + 1
	end

	local var18 = 15

	for iter0 = 1, 6 do
		local var19 = arg0.starsTF:Find("content/star_" .. iter0)
		local var20 = var19:Find("star_empty")
		local var21 = var19:Find("star")

		setActive(var21, iter0 <= var16)
		setActive(var20, var16 < iter0)

		if var15 < iter0 then
			setActive(var19, false)
		end
	end

	local var22 = arg0._shake:Find("rarity/nation")
	local var23 = LoadSprite("prints/" .. nation2print(var13.nationality) .. "_0")

	if not var23 then
		warning("找不到印花, shipConfigId: " .. arg1.configId)
		setActive(var22, false)
	else
		setImageSprite(var22, var23, false)
	end

	local var24 = arg0._shake:Find("rarity/type")
	local var25 = arg0._shake:Find("rarity/type/rarLogo")

	if arg1:isMetaShip() then
		LoadImageSpriteAsync("shiprarity/1" .. var14 .. "m", var24, true)
		LoadImageSpriteAsync("shiprarity/1" .. var14 .. "s", var25, true)
	else
		LoadImageSpriteAsync("shiprarity/" .. (var0 and "0" or "") .. var14 .. "m", var24, true)
		LoadImageSpriteAsync("shiprarity/" .. (var0 and "0" or "") .. var14 .. "s", var25, true)
	end

	setActive(var22, false)
	setActive(arg0.rarityTF, false)
	setActive(arg0._shade, true)

	arg0.inAnimating = true

	arg0:AddLeanTween(function()
		return LeanTween.delayedCall(0.5, System.Action(function()
			setActive(var22, true)
			setActive(arg0.rarityTF, true)
			arg0:starsAnimation()
		end))
	end)

	local var26 = arg0._shake:Find("ship_type")
	local var27 = var26:Find("stars")
	local var28 = var26:Find("stars/startpl")
	local var29 = var26:Find("english_name")

	setText(var29, arg0._shipVO:getConfig("english_name"))

	local var30 = var27.childCount
	local var31 = arg0._shipVO:getStar()
	local var32 = arg0._shipVO:getMaxStar()

	for iter1 = var30, var32 - 1 do
		cloneTplTo(var28, var27)
	end

	local var33 = var27.childCount

	for iter2 = 0, var33 - 1 do
		local var34 = var27:GetChild(iter2)

		var34.gameObject:SetActive(iter2 < var32)
		setActive(var34:Find("star"), iter2 < var31)
		setActive(var34:Find("empty"), var31 <= iter2)
	end

	local var35 = arg0._shipVO:getConfigTable()

	findTF(var26, "type_bg/type"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("shiptype", tostring(arg0._shipVO:getShipType()))

	setScrollText(var26:Find("name_bg/mask/Text"), arg0._shipVO:getName())

	if var0 then
		var14 = var14 .. "_1"
	elseif arg1:isMetaShip() then
		var14 = var14 .. "_2"
	end

	if not arg0.rarityEffect[var14] then
		PoolMgr.GetInstance():GetUI("getrole_" .. var14, true, function(arg0)
			if IsNil(arg0._tf) then
				return
			end

			arg0.rarityEffect[var14] = arg0

			arg0.transform:SetParent(arg0._tf, false)

			arg0.transform.localPosition = Vector3(1, 1, 1)
			arg0.transform.localScale = Vector3(1, 1, 1)

			arg0.transform:SetSiblingIndex(1)

			if arg1:isMetaShip() then
				local var0 = arg0:findTF("fire_ruchang", tf(arg0))

				var0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
					setActive(var22, true)
					setActive(var0, false)
				end)
			end

			setActive(var22, false)

			arg0.effectObj = arg0

			setActive(arg0.effectObj, arg0.isOpeningEnd)
		end)
	else
		arg0.effectObj = arg0.rarityEffect[var14]

		setActive(arg0.effectObj, arg0.isOpeningEnd)
	end

	arg0:playOpening(function()
		arg0:ResumeAnimation()
		arg0:DisplayWord()
	end)
end

function var0.PauseAnimation(arg0)
	arg0._canvasGroup.alpha = 0
	arg0._animator.enabled = false
end

function var0.ResumeAnimation(arg0)
	arg0._canvasGroup.alpha = 1
	arg0._animator.enabled = true
	arg0.isOpeningEnd = true

	if arg0.effectObj then
		setActive(arg0.effectObj, true)
	end
end

function var0.DisplayWord(arg0)
	local var0
	local var1 = ""
	local var2

	if arg0.isRemoulded then
		local var3 = arg0._shipVO:getRemouldSkinId()

		var1 = ShipWordHelper.RawGetWord(var3, ShipWordHelper.WORD_TYPE_UNLOCK)

		if var1 == "" then
			local var4

			var4, var2, var1 = ShipWordHelper.GetWordAndCV(var3, ShipWordHelper.WORD_TYPE_DROP)
		else
			local var5

			var5, var2, var1 = ShipWordHelper.GetWordAndCV(var3, ShipWordHelper.WORD_TYPE_UNLOCK)
		end
	else
		local var6

		var6, var2, var1 = ShipWordHelper.GetWordAndCV(arg0._shipVO.skinId, ShipWordHelper.WORD_TYPE_UNLOCK)
	end

	setWidgetText(arg0._dialogue, SwitchSpecialChar(var1, true), "Text")

	arg0._dialogue.transform.localScale = Vector3(0, 1, 1)

	SetActive(arg0._dialogue, false)
	arg0:AddLeanTween(function()
		return LeanTween.delayedCall(0.5, System.Action(function()
			SetActive(arg0._dialogue, true)
			arg0:AddLeanTween(function()
				return LeanTween.scale(arg0._dialogue, Vector3(1, 1, 1), 0.1)
			end)
			arg0:voice(var2)
		end))
	end)
end

function var0.updateShip(arg0, arg1)
	arg0._shipVO = arg1
end

function var0.switch2Property(arg0)
	setActive(arg0.newTF, false)
	setActive(arg0._dialogue, false)
	setActive(arg0.rarityTF, false)
	setActive(arg0._shake:Find("rarity/nation"), false)

	local var0 = arg0._shake:Find("ship_type")

	setActive(var0, true)
	arg0:AddLeanTween(function()
		return LeanTween.move(rtf(var0), Vector3(0, -149.55, 0), 0.3)
	end)
	arg0:AddLeanTween(function()
		return LeanTween.move(rtf(arg0._paintingTF), Vector3(-59, 21, 0), 0.2)
	end)
	arg0:DisplayNewShipDocumentView()
end

function var0.showExitTip(arg0, arg1)
	local var0 = arg0._shipVO:GetLockState()
	local var1 = pg.settings_other_template[22]
	local var2 = getProxy(PlayerProxy):getRawData():GetCommonFlag(_G[var1.name])

	if var1.default == 1 then
		var2 = not var2
	end

	if arg0._shipVO.virgin and var0 == Ship.LOCK_STATE_UNLOCK and not var2 then
		if arg0.effectObj then
			setActive(arg0.effectObj, false)
		end

		if arg0.effectLineObj then
			setActive(arg0.effectLineObj, false)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			content = i18n("ship_lock_tip"),
			onYes = function()
				triggerButton(arg0._lockBtn)

				if arg1 then
					arg1()
				else
					arg0:emit(NewShipMediator.ON_EXIT)
				end
			end,
			onNo = function()
				if arg1 then
					arg1()
				else
					arg0:emit(NewShipMediator.ON_EXIT)
				end
			end,
			weight = arg0:getWeightFromData()
		})
	elseif arg1 then
		arg1()
	else
		arg0:emit(NewShipMediator.ON_EXIT)
	end
end

function var0.UpdateLockButton(arg0, arg1)
	setActive(arg0._lockBtn, arg1 ~= Ship.LOCK_STATE_LOCK)
	setActive(arg0._unlockBtn, arg1 ~= Ship.LOCK_STATE_UNLOCK)
end

function var0.updateLockTF(arg0, arg1)
	setActive(arg0._lockTF, not arg1)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._lockBtn, function()
		arg0:StopAutoExitTimer()
		arg0:emit(NewShipMediator.ON_LOCK, {
			arg0._shipVO.id
		}, Ship.LOCK_STATE_LOCK)
	end, SFX_PANEL)
	onButton(arg0, arg0._unlockBtn, function()
		arg0:StopAutoExitTimer()
		arg0:emit(NewShipMediator.ON_LOCK, {
			arg0._shipVO.id
		}, Ship.LOCK_STATE_UNLOCK)
	end, SFX_PANEL)
	onButton(arg0, arg0._viewBtn, function()
		arg0:StopAutoExitTimer()

		arg0.isInView = true

		arg0:paintView()
		setActive(arg0.clickTF, false)
	end, SFX_PANEL)
	onButton(arg0, arg0._evaluationBtn, function()
		arg0:StopAutoExitTimer()
		arg0:emit(NewShipMediator.ON_EVALIATION, arg0._shipVO:getGroupId())
	end, SFX_PANEL)
	onButton(arg0, arg0._shareBtn, function()
		arg0:StopAutoExitTimer()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewShip, nil, {
			weight = arg0:getWeightFromData()
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.clickTF, function()
		arg0:StopAutoExitTimer()

		if arg0.isInView or not arg0.isLoadBg then
			return
		end

		arg0:showExitTip()
	end, SFX_CANCEL)
	onButton(arg0, arg0.audioBtn, function()
		arg0:StopAutoExitTimer()

		if arg0.isInView then
			return
		end

		if not arg0.isOpenProperty then
			arg0:switch2Property()

			arg0.isOpenProperty = true
		end

		setActive(arg0.audioBtn, not arg0.isRemoulded and not arg0.isOpenProperty)
	end, SFX_PANEL)
	onButton(arg0, arg0._skipButton, function()
		arg0:showExitTip(function()
			arg0:emit(NewShipMediator.ON_SKIP_BATCH)
		end)
	end, SFX_PANEL)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_CHARGET)
	pg.SystemGuideMgr.GetInstance():Play(arg0)
end

function var0.onBackPressed(arg0)
	if arg0.inAnimating then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0.isInView then
		arg0:hidePaintView(true)

		return
	end

	arg0:DestroyNewShipDocumentView()
	triggerButton(arg0.clickTF)
end

function var0.paintView(arg0)
	local var0 = {}
	local var1 = arg0._shake.childCount
	local var2 = 0

	while var2 < var1 do
		local var3 = arg0._shake:GetChild(var2)

		if var3.gameObject.activeSelf and var3 ~= arg0._paintingTF and var3 ~= arg0._bg and var3 ~= arg0._drag then
			var0[#var0 + 1] = var3

			setActive(var3, false)
		end

		var2 = var2 + 1
	end

	setActive(arg0._paintingShadowTF, false)
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
		arg0:AddLeanTween(function()
			return LeanTween.moveX(rtf(var4), 150, 0.5):setEase(LeanTweenType.easeInOutSine)
		end)
	end

	local var15 = GetOrAddComponent(arg0._drag, "MultiTouchZoom")

	var15:SetZoomTarget(arg0._paintingTF)

	local var16 = GetOrAddComponent(arg0._drag, "EventTriggerListener")

	arg0.dragTrigger = var16

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
	onButton(arg0, arg0._drag, function()
		arg0:hidePaintView()
	end, SFX_CANCEL)

	function var0.hidePaintView(arg0, arg1)
		if not arg1 and not var18 then
			return
		end

		var16.enabled = false
		var15.enabled = false

		for iter0, iter1 in ipairs(var0) do
			setActive(iter1, true)
		end

		setActive(arg0._paintingShadowTF, true)
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
		retPaintingPrefab(arg0._paintingShadowTF, arg0._shipVO:getPainting())

		arg0._shipVO = nil
	end
end

function var0.starsAnimation(arg0)
	arg0.inAnimating = true

	if arg0._shipVO:getMaxStar() >= 6 and PlayerPrefs.GetInt(RARE_SHIP_VIBRATE, 1) > 0 then
		LuaHelper.Vibrate()
	end

	setActive(arg0.starsCont, false)

	local var0 = arg0._tf:GetComponent(typeof(DftAniEvent))

	var0:SetTriggerEvent(function(arg0)
		arg0:AddLeanTween(function()
			return LeanTween.scale(rtf(arg0.starsCont), Vector3.one, 0):setOnComplete(System.Action(function()
				setActive(arg0.starsCont, true)
			end))
		end)

		local var0 = arg0.STAR_ANIMATION_DUR1

		for iter0 = 0, arg0.starsCont.childCount - 1 do
			local var1 = arg0.starsCont:GetChild(iter0)
			local var2 = var1:Find("star_empty")
			local var3 = var1:Find("star")

			setActive(var2, false)
			setActive(var3, false)

			local var4 = iter0 * var0

			arg0:AddLeanTween(function()
				return LeanTween.scale(rtf(var2), Vector3(1.8, 1.8, 1.8), 0):setDelay(var4):setOnComplete(System.Action(function()
					setActive(var2, true)
					arg0:AddLeanTween(function()
						return LeanTween.scale(rtf(var2), Vector3(1, 1, 1), var0)
					end)
				end))
			end)
		end

		local var5 = arg0._shipVO:getStar()
		local var6 = arg0.STAR_ANIMATION_DUR2
		local var7 = arg0.STAR_ANIMATION_DUR3

		for iter1 = 0, var5 - 1 do
			local var8 = arg0.starsCont:GetChild(iter1)
			local var9 = var8:Find("star_empty")
			local var10 = var8:Find("star")
			local var11 = var0 * arg0.starsCont.childCount + iter1 * var6

			arg0:AddLeanTween(function()
				return LeanTween.scale(rtf(var10), Vector3(1.8, 1.8, 1.8), 0):setDelay(var11):setOnStart(System.Action(function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_STAR)
				end)):setOnComplete(System.Action(function()
					setActive(var9, false)
					setActive(var10, true)
					arg0:AddLeanTween(function()
						return LeanTween.scale(rtf(var10), Vector3(1, 1, 1), var6)
					end)
				end))
			end)

			local var12 = var8:Find("light")

			if var12 then
				arg0:AddLeanTween(function()
					return LeanTween.delayedCall(var11, System.Action(function()
						if arg0.exited then
							return
						end

						setActive(var12, true)
					end))
				end)
				arg0:AddLeanTween(function()
					return LeanTween.alpha(rtf(var12), 0, var7):setDelay(var11):setOnComplete(System.Action(function()
						SetActive(var12, false)
						LeanTween.alpha(rtf(var12), 1, 0)
					end))
				end)

				var12.transform.localScale = Vector3(1, 1, 1)

				arg0:AddLeanTween(function()
					return LeanTween.scale(rtf(var12), Vector3(0.5, 1, 1), arg0.STAR_ANIMATION_DUR4):setDelay(var11 + var7 * 1 / 3)
				end)
			end
		end
	end)
	var0:SetEndEvent(function(arg0)
		if arg0._shipVO:getReMetaSpecialItemVO() then
			GetComponent(arg0.metaRepeatTF, "CanvasGroup").alpha = 1

			arg0:managedTween(LeanTween.value, function()
				setAnchoredPosition(arg0.metaRepeatTF, {
					x = 0
				})

				arg0.inAnimating = false

				setActive(arg0.npc, arg0._shipVO:isActivityNpc())
				setActive(arg0._shade, false)
			end, go(arg0.metaRepeatTF), arg0.metaRepeatTF.rect.width, 0, 1):setOnUpdate(System.Action_float(function(arg0)
				setAnchoredPosition(arg0.metaRepeatTF, {
					x = arg0
				})
			end))
			setAnchoredPosition(arg0.metaRepeatTF, {
				x = arg0.metaRepeatTF.rect.width
			})
			setActive(arg0.metaRepeatTF, true)
		else
			arg0.inAnimating = false

			setActive(arg0.npc, arg0._shipVO:isActivityNpc())
			setActive(arg0._shade, false)
		end
	end)
end

function var0.playOpening(arg0, arg1)
	if arg0._shipVO:isMetaShip() and not getProxy(ContextProxy):getContextByMediator(BuildShipMediator) then
		if arg1 then
			arg1()
		end

		return
	end

	local var0

	if arg0._shipVO:isRemoulded() then
		var0 = ShipGroup.GetGroupConfig(arg0._shipVO:getGroupId()).trans_skin
	else
		var0 = ShipGroup.getDefaultSkin(arg0._shipVO:getGroupId()).id
	end

	local var1 = "star_level_unlock_anim_" .. var0

	if PathMgr.FileExists(PathMgr.getAssetBundle("ui/skinunlockanim/" .. var1)) then
		pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
			return
		end, function()
			if arg1 then
				arg1()
			end
		end, "ui/skinunlockanim", var1, true, false, {
			weight = arg0:getWeightFromData()
		})
	elseif arg1 then
		arg1()
	end
end

function var0.ClearTweens(arg0, arg1)
	arg0:cleanManagedTween(true)
end

function var0.willExit(arg0)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0:StopAutoExitTimer()
	arg0:DestroyNewShipDocumentView()

	if arg0.designBg then
		PoolMgr.GetInstance():ReturnUI(arg0.designName, arg0.designBg)
	end

	if arg0.metaBg then
		PoolMgr.GetInstance():ReturnUI(arg0.metaName, arg0.metaBg)
	end

	for iter0, iter1 in pairs(arg0.rarityEffect) do
		if iter1 then
			PoolMgr.GetInstance():ReturnUI("getrole_" .. iter0, iter1)
		end
	end

	if arg0.dragTrigger then
		ClearEventTrigger(arg0.dragTrigger)

		arg0.dragTrigger = nil
	end

	if not arg0.isRemoulded then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newShipLayer_get", pg.ship_data_by_type[arg0._shipVO:getShipType()].type_name, arg0._shipVO:getName()), COLOR_GREEN)
	end

	arg0:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	arg0:stopVoice()

	if arg0.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0.loadedCVBankName)

		arg0.loadedCVBankName = nil
	end

	if LeanTween.isTweening(go(arg0.rarityTF)) then
		LeanTween.cancel(go(arg0.rarityTF))
	end

	cameraPaintViewAdjust(false)
end

function var0.DisplayNewShipDocumentView(arg0)
	arg0.newShipDocumentView = NewShipDocumentView.New(arg0._shake:Find("ForNotch"), arg0.event, arg0.contextData)

	arg0.newShipDocumentView:Load()

	local function var0()
		if not arg0.isLoadBg then
			return
		end

		arg0:showExitTip()
	end

	arg0.newShipDocumentView:ActionInvoke("SetParams", arg0._shipVO, var0)
	arg0.newShipDocumentView:ActionInvoke("RefreshUI")
end

function var0.DestroyNewShipDocumentView(arg0)
	if arg0.newShipDocumentView and arg0.newShipDocumentView:CheckState(BaseSubView.STATES.INITED) then
		arg0.newShipDocumentView:Destroy()
	end
end

function var0.StopAutoExitTimer(arg0)
	if not arg0.autoExitTimer then
		return
	end

	arg0.autoExitTimer:Stop()

	arg0.autoExitTimer = nil
end

return var0
