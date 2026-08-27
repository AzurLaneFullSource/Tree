local var0_0 = class("NewShipLayer", import("..base.BaseUI"))

var0_0.PAINT_DURATION = 0.35
var0_0.STAR_DURATION = 0.5
var0_0.STAR_ANIMATION_DUR1 = 0.075
var0_0.STAR_ANIMATION_DUR2 = 0.1
var0_0.STAR_ANIMATION_DUR3 = 0.4
var0_0.STAR_ANIMATION_DUR4 = 0.26

local var1_0 = 19

function var0_0.getUIName(arg0_1)
	return "NewShipUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = arg0_2.contextData.ship

	LoadSpriteAsync("newshipbg/bg_" .. var0_2:rarity2bgPrintForGet(), function(arg0_3)
		arg0_2.bgSprite = arg0_3
		arg0_2.isLoadBg = true

		arg1_2()
	end)
end

function var0_0.init(arg0_4)
	arg0_4._animator = GetComponent(arg0_4._tf, "Animator")
	arg0_4._canvasGroup = GetOrAddComponent(arg0_4._tf, typeof(CanvasGroup))
	arg0_4._shake = arg0_4._tf:Find("shake_panel")
	arg0_4._shade = arg0_4._tf:Find("shade")
	arg0_4._bg = arg0_4._shake:Find("bg")
	arg0_4._drag = arg0_4._shake:Find("drag")
	arg0_4._paintingTF = arg0_4._shake:Find("paint")
	arg0_4._paintingShadowTF = arg0_4._shake:Find("shadow")
	arg0_4._dialogue = arg0_4._shake:Find("dialogue")
	arg0_4._shipName = arg0_4._dialogue:Find("bg/name"):GetComponent(typeof(Text))
	arg0_4._shipType = arg0_4._dialogue:Find("bg/type"):GetComponent(typeof(Text))
	arg0_4._dialogueText = arg0_4._dialogue:Find("Text")
	arg0_4._left = arg0_4._shake:Find("ForNotch/left_panel")
	arg0_4._lockTF = arg0_4._left:Find("lock")
	arg0_4._lockBtn = arg0_4._left:Find("lock/lock")
	arg0_4._unlockBtn = arg0_4._left:Find("lock/unlock_btn")
	arg0_4._viewBtn = arg0_4._left:Find("view_btn")
	arg0_4._evaluationBtn = arg0_4._left:Find("evaluation_btn")
	arg0_4._shareBtn = arg0_4._left:Find("share_btn")
	arg0_4.audioBtn = arg0_4._shake:Find("property_btn")
	arg0_4.clickTF = arg0_4._shake:Find("click")
	arg0_4.npc = arg0_4._tf:Find("shake_panel/npc")

	setActive(arg0_4.npc, false)

	arg0_4.newTF = arg0_4._shake:Find("New")
	arg0_4.rarityTF = arg0_4._shake:Find("rarity")
	arg0_4.starsTF = arg0_4.rarityTF:Find("stars")
	arg0_4.starsCont = arg0_4.starsTF:Find("content")
	arg0_4._skipButton = arg0_4._shake:Find("ForNotch/skip")

	setActive(arg0_4._skipButton, arg0_4.contextData.canSkipBatch)
	setActive(arg0_4._left, true)
	setActive(arg0_4.audioBtn, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf)

	arg0_4.metaRepeatTF = arg0_4.rarityTF:Find("MetaRepeat")
	arg0_4.metaDarkTF = arg0_4._shake:Find("MetaMask")
	arg0_4.rarityEffect = {}

	if arg0_4.contextData.autoExitTime then
		arg0_4.autoExitTimer = Timer.New(function()
			arg0_4:showExitTip()
		end, arg0_4.contextData.autoExitTime)

		arg0_4.autoExitTimer:Start()

		arg0_4.contextData.autoExitTime = nil
	end

	arg0_4:PauseAnimation()
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

function var0_0.setShip(arg0_8, arg1_8)
	arg0_8:recyclePainting()

	arg0_8._shipVO = arg1_8
	arg0_8.isRemoulded = arg1_8:isRemoulded()

	local var0_8 = arg1_8:isBluePrintShip()
	local var1_8 = arg1_8:isMetaShip()

	setImageSprite(arg0_8._bg, arg0_8.bgSprite)
	setActive(arg0_8.metaDarkTF, arg1_8:isMetaShip())

	if var0_8 then
		if arg0_8.metaBg then
			setActive(arg0_8.metaBg, false)
		end

		if arg0_8.designBg and arg0_8.designName ~= "raritydesign" .. arg1_8:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0_8.designName, arg0_8.designBg)

			arg0_8.designBg = nil
		end

		if not arg0_8.designBg then
			PoolMgr.GetInstance():GetUI("raritydesign" .. arg1_8:getRarity(), true, function(arg0_9)
				arg0_8.designBg = arg0_9
				arg0_8.designName = "raritydesign" .. arg1_8:getRarity()

				arg0_9.transform:SetParent(arg0_8._shake, false)

				arg0_9.transform.localPosition = Vector3(1, 1, 1)
				arg0_9.transform.localScale = Vector3(1, 1, 1)

				arg0_9.transform:SetSiblingIndex(1)
				setActive(arg0_9, true)
			end)
		else
			setActive(arg0_8.designBg, true)
		end
	elseif var1_8 then
		if arg0_8.designBg then
			setActive(arg0_8.designBg, false)
		end

		if arg0_8.metaBg and arg0_8.metaName ~= "raritymeta" .. arg1_8:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0_8.metaName, arg0_8.metaBg)

			arg0_8.metaBg = nil
		end

		if not arg0_8.metaBg then
			PoolMgr.GetInstance():GetUI("raritymeta" .. arg1_8:getRarity(), true, function(arg0_10)
				arg0_8.metaBg = arg0_10
				arg0_8.metaName = "raritymeta" .. arg1_8:getRarity()

				arg0_10.transform:SetParent(arg0_8._shake, false)

				arg0_10.transform.localPosition = Vector3(1, 1, 1)
				arg0_10.transform.localScale = Vector3(1, 1, 1)

				arg0_10.transform:SetSiblingIndex(1)
				setActive(arg0_10, true)
			end)
		else
			setActive(arg0_8.metaBg, true)
		end
	else
		if arg0_8.designBg then
			setActive(arg0_8.designBg, false)
		end

		if arg0_8.metaBg then
			setActive(arg0_8.metaBg, false)
		end
	end

	if arg1_8.virgin and not arg0_8.isRemoulded and not arg1_8:isActivityNpc() then
		setActive(arg0_8.newTF, true)
		LoadImageSpriteAsync("clutter/new", arg0_8.newTF)

		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg0_8._shipVO.groupId, 1) then
			local var2_8 = pg.fleet_tech_ship_template[arg0_8._shipVO.groupId].pt_get
			local var3_8 = ShipType.FilterOverQuZhuType(pg.fleet_tech_ship_template[arg0_8._shipVO.groupId].add_get_shiptype)
			local var4_8 = pg.fleet_tech_ship_template[arg0_8._shipVO.groupId].add_get_attr
			local var5_8 = pg.fleet_tech_ship_template[arg0_8._shipVO.groupId].add_get_value

			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
				point = var2_8,
				typeList = var3_8,
				attr = var4_8,
				value = var5_8
			})
		end
	else
		setActive(arg0_8.newTF, false)

		local var6_8 = arg1_8:getReMetaSpecialItemVO()

		arg0_8:updateLockTF(var6_8 ~= nil)

		if var6_8 then
			local var7_8 = arg0_8.metaRepeatTF:Find("Icon")
			local var8_8 = arg0_8.metaRepeatTF:Find("Count")

			setImageSprite(var7_8, LoadSprite(var6_8:getConfig("icon")))
			GetImageSpriteFromAtlasAsync(var6_8:getConfig("icon"), "", var7_8)
			setText(var8_8, var6_8.count)

			local var9_8 = pg.ship_transform[arg0_8._shipVO.groupId].exclusive_item[1][2]
			local var10_8 = pg.ship_transform[arg0_8._shipVO.groupId].common_item[1][2]
			local var11_8 = arg0_8.metaRepeatTF:Find("Special")
			local var12_8 = arg0_8.metaRepeatTF:Find("Commom")

			setActive(var11_8, var6_8.id == var9_8)
			setActive(var12_8, var6_8.id == var10_8)
		else
			setActive(arg0_8.metaRepeatTF, false)
		end
	end

	setActive(arg0_8.audioBtn, not arg0_8.isRemoulded)
	arg0_8:UpdateLockButton(arg0_8._shipVO:GetLockState())

	local var13_8 = arg0_8._shipVO:getConfigTable()

	if arg0_8.isRemoulded then
		setPaintingPrefabAsync(arg0_8._paintingTF, arg0_8._shipVO:getRemouldPainting(), "huode")
		setPaintingPrefabAsync(arg0_8._paintingShadowTF, arg0_8._shipVO:getRemouldPainting(), "huode")
	else
		setPaintingPrefabAsync(arg0_8._paintingTF, arg0_8._shipVO:getPainting(), "huode")
		setPaintingPrefabAsync(arg0_8._paintingShadowTF, arg0_8._shipVO:getPainting(), "huode")
	end

	arg0_8._shipType.text = pg.ship_data_by_type[arg0_8._shipVO:getShipType()].type_name
	arg0_8._shipName.text = arg1_8:getName()

	local var14_8 = arg1_8:getRarity()
	local var15_8 = pg.ship_data_template[var13_8.id].star_max
	local var16_8 = arg0_8._shipVO:getStar()

	if not (var15_8 % 2 == 0) or not (var15_8 / 2) then
		local var17_8 = math.floor(var15_8 / 2) + 1
	end

	local var18_8 = 15

	for iter0_8 = 1, 6 do
		local var19_8 = arg0_8.starsTF:Find("content/star_" .. iter0_8)
		local var20_8 = var19_8:Find("star_empty")
		local var21_8 = var19_8:Find("star")

		setActive(var21_8, iter0_8 <= var16_8)
		setActive(var20_8, var16_8 < iter0_8)

		if var15_8 < iter0_8 then
			setActive(var19_8, false)
		end
	end

	local var22_8 = arg0_8._shake:Find("rarity/nation")
	local var23_8 = LoadSprite("prints/" .. nation2print(var13_8.nationality) .. "_0")

	if not var23_8 then
		warning("找不到印花, shipConfigId: " .. arg1_8.configId)
		setActive(var22_8, false)
	else
		setImageSprite(var22_8, var23_8, false)
	end

	local var24_8 = arg0_8._shake:Find("rarity/type")
	local var25_8 = arg0_8._shake:Find("rarity/type/rarLogo")

	if arg1_8:isMetaShip() then
		LoadImageSpriteAsync("shiprarity/1" .. var14_8 .. "m", var24_8, true)
		LoadImageSpriteAsync("shiprarity/1" .. var14_8 .. "s", var25_8, true)
	else
		LoadImageSpriteAsync("shiprarity/" .. (var0_8 and "0" or "") .. var14_8 .. "m", var24_8, true)
		LoadImageSpriteAsync("shiprarity/" .. (var0_8 and "0" or "") .. var14_8 .. "s", var25_8, true)
	end

	setActive(var22_8, false)
	setActive(arg0_8.rarityTF, false)
	setActive(arg0_8._shade, true)

	arg0_8.inAnimating = true

	arg0_8:AddLeanTween(function()
		return LeanTween.delayedCall(0.5, System.Action(function()
			setActive(var22_8, true)
			setActive(arg0_8.rarityTF, true)
			arg0_8:starsAnimation()
		end))
	end)

	local var26_8 = arg0_8._shake:Find("ship_type")
	local var27_8 = var26_8:Find("stars")
	local var28_8 = var26_8:Find("stars/startpl")
	local var29_8 = var26_8:Find("english_name")

	setText(var29_8, arg0_8._shipVO:getConfig("english_name"))

	local var30_8 = var27_8.childCount
	local var31_8 = arg0_8._shipVO:getStar()
	local var32_8 = arg0_8._shipVO:getMaxStar()

	for iter1_8 = var30_8, var32_8 - 1 do
		cloneTplTo(var28_8, var27_8)
	end

	local var33_8 = var27_8.childCount

	for iter2_8 = 0, var33_8 - 1 do
		local var34_8 = var27_8:GetChild(iter2_8)

		var34_8.gameObject:SetActive(iter2_8 < var32_8)
		setActive(var34_8:Find("star"), iter2_8 < var31_8)
		setActive(var34_8:Find("empty"), var31_8 <= iter2_8)
	end

	local var35_8 = arg0_8._shipVO:getConfigTable()

	findTF(var26_8, "type_bg/type"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("shiptype", tostring(arg0_8._shipVO:getShipType()))

	setScrollText(var26_8:Find("name_bg/mask/Text"), arg0_8._shipVO:getName())

	if var0_8 then
		var14_8 = var14_8 .. "_1"
	elseif arg1_8:isMetaShip() then
		var14_8 = var14_8 .. "_2"
	end

	if not arg0_8.rarityEffect[var14_8] then
		PoolMgr.GetInstance():GetUI("getrole_" .. var14_8, true, function(arg0_13)
			if IsNil(arg0_8._tf) then
				return
			end

			arg0_8.rarityEffect[var14_8] = arg0_13

			arg0_13.transform:SetParent(arg0_8._tf, false)

			arg0_13.transform.localPosition = Vector3(1, 1, 1)
			arg0_13.transform.localScale = Vector3(1, 1, 1)

			arg0_13.transform:SetSiblingIndex(1)

			if arg1_8:isMetaShip() then
				local var0_13 = tf(arg0_13):Find("fire_ruchang")

				var0_13:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_14)
					setActive(var22_8, true)
					setActive(var0_13, false)
				end)
			end

			setActive(var22_8, false)

			arg0_8.effectObj = arg0_13

			setActive(arg0_8.effectObj, arg0_8.isOpeningEnd)
		end)
	else
		arg0_8.effectObj = arg0_8.rarityEffect[var14_8]

		setActive(arg0_8.effectObj, arg0_8.isOpeningEnd)
	end

	arg0_8:playOpening(function()
		arg0_8:ResumeAnimation()
		arg0_8:DisplayWord()
	end)
end

function var0_0.PauseAnimation(arg0_16)
	arg0_16._canvasGroup.alpha = 0
	arg0_16._animator.enabled = false
end

function var0_0.ResumeAnimation(arg0_17)
	arg0_17._canvasGroup.alpha = 1
	arg0_17._animator.enabled = true
	arg0_17.isOpeningEnd = true

	if arg0_17.effectObj then
		setActive(arg0_17.effectObj, true)
	end
end

function var0_0.DisplayWord(arg0_18)
	local var0_18
	local var1_18 = ""
	local var2_18

	if arg0_18.isRemoulded then
		local var3_18 = arg0_18._shipVO:getRemouldSkinId()

		var1_18 = ShipWordHelper.RawGetWord(var3_18, ShipWordHelper.WORD_TYPE_UNLOCK)

		if var1_18 == "" then
			local var4_18

			var4_18, var2_18, var1_18 = ShipWordHelper.GetWordAndCV(var3_18, ShipWordHelper.WORD_TYPE_DROP)
		else
			local var5_18

			var5_18, var2_18, var1_18 = ShipWordHelper.GetWordAndCV(var3_18, ShipWordHelper.WORD_TYPE_UNLOCK)
		end
	else
		local var6_18

		var6_18, var2_18, var1_18 = ShipWordHelper.GetWordAndCV(arg0_18._shipVO:getSkinId(), ShipWordHelper.WORD_TYPE_UNLOCK)
	end

	setWidgetText(arg0_18._dialogue, SwitchSpecialChar(var1_18, true), "Text")

	arg0_18._dialogue.transform.localScale = Vector3(0, 1, 1)

	SetActive(arg0_18._dialogue, false)
	arg0_18:AddLeanTween(function()
		return LeanTween.delayedCall(0.5, System.Action(function()
			SetActive(arg0_18._dialogue, true)
			arg0_18:AddLeanTween(function()
				return LeanTween.scale(arg0_18._dialogue, Vector3(1, 1, 1), 0.1)
			end)
			arg0_18:voice(var2_18)
		end))
	end)
end

function var0_0.updateShip(arg0_22, arg1_22)
	arg0_22._shipVO = arg1_22
end

function var0_0.switch2Property(arg0_23)
	setActive(arg0_23.newTF, false)
	setActive(arg0_23._dialogue, false)
	setActive(arg0_23.rarityTF, false)
	setActive(arg0_23._shake:Find("rarity/nation"), false)

	local var0_23 = arg0_23._shake:Find("ship_type")

	setActive(var0_23, true)
	arg0_23:AddLeanTween(function()
		return LeanTween.move(rtf(var0_23), Vector3(0, -149.55, 0), 0.3)
	end)
	arg0_23:AddLeanTween(function()
		return LeanTween.move(rtf(arg0_23._paintingTF), Vector3(-59, 21, 0), 0.2)
	end)
	arg0_23:DisplayNewShipDocumentView()
end

function var0_0.showExitTip(arg0_26, arg1_26)
	local var0_26 = arg0_26._shipVO:GetLockState()
	local var1_26 = pg.settings_other_template[22]
	local var2_26 = getProxy(PlayerProxy):getRawData():GetCommonFlag(_G[var1_26.name])

	if var1_26.default == 1 then
		var2_26 = not var2_26
	end

	if arg0_26._shipVO.virgin and var0_26 == Ship.LOCK_STATE_UNLOCK and not var2_26 then
		if arg0_26.effectObj then
			setActive(arg0_26.effectObj, false)
		end

		if arg0_26.effectLineObj then
			setActive(arg0_26.effectLineObj, false)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			content = i18n("ship_lock_tip"),
			onYes = function()
				triggerButton(arg0_26._lockBtn)

				if arg1_26 then
					arg1_26()
				else
					arg0_26:emit(NewShipMediator.ON_EXIT)
				end
			end,
			onNo = function()
				if arg1_26 then
					arg1_26()
				else
					arg0_26:emit(NewShipMediator.ON_EXIT)
				end
			end
		})
	elseif arg1_26 then
		arg1_26()
	else
		arg0_26:emit(NewShipMediator.ON_EXIT)
	end
end

function var0_0.UpdateLockButton(arg0_29, arg1_29)
	setActive(arg0_29._lockBtn, arg1_29 ~= Ship.LOCK_STATE_LOCK)
	setActive(arg0_29._unlockBtn, arg1_29 ~= Ship.LOCK_STATE_UNLOCK)
end

function var0_0.updateLockTF(arg0_30, arg1_30)
	setActive(arg0_30._lockTF, not arg1_30)
end

function var0_0.didEnter(arg0_31)
	onButton(arg0_31, arg0_31._lockBtn, function()
		arg0_31:StopAutoExitTimer()
		arg0_31:emit(NewShipMediator.ON_LOCK, {
			arg0_31._shipVO.id
		}, Ship.LOCK_STATE_LOCK)
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31._unlockBtn, function()
		arg0_31:StopAutoExitTimer()
		arg0_31:emit(NewShipMediator.ON_LOCK, {
			arg0_31._shipVO.id
		}, Ship.LOCK_STATE_UNLOCK)
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31._viewBtn, function()
		arg0_31:StopAutoExitTimer()

		arg0_31.isInView = true

		arg0_31:paintView()
		setActive(arg0_31.clickTF, false)
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31._evaluationBtn, function()
		arg0_31:StopAutoExitTimer()
		arg0_31:emit(NewShipMediator.ON_EVALIATION, arg0_31._shipVO:getGroupId())
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31._shareBtn, function()
		arg0_31:StopAutoExitTimer()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewShip)
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31.clickTF, function()
		arg0_31:StopAutoExitTimer()

		if arg0_31.isInView or not arg0_31.isLoadBg then
			return
		end

		arg0_31:showExitTip()
	end, SFX_CANCEL)
	onButton(arg0_31, arg0_31.audioBtn, function()
		arg0_31:StopAutoExitTimer()

		if arg0_31.isInView then
			return
		end

		if not arg0_31.isOpenProperty then
			arg0_31:switch2Property()

			arg0_31.isOpenProperty = true
		end

		setActive(arg0_31.audioBtn, not arg0_31.isRemoulded and not arg0_31.isOpenProperty)
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31._skipButton, function()
		arg0_31:showExitTip(function()
			arg0_31:emit(NewShipMediator.ON_SKIP_BATCH, arg0_31.contextData.skipBatchType or NewShipMediator.SKIP_TYPE.BUILD)
		end)
	end, SFX_PANEL)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_CHARGET)
	pg.SystemGuideMgr.GetInstance():Play(arg0_31)
end

function var0_0.onBackPressed(arg0_41)
	if arg0_41.inAnimating then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_41.isInView then
		arg0_41:hidePaintView(true)

		return
	end

	arg0_41:DestroyNewShipDocumentView()
	triggerButton(arg0_41.clickTF)
end

function var0_0.paintView(arg0_42)
	local var0_42 = {}
	local var1_42 = arg0_42._shake.childCount
	local var2_42 = 0

	while var2_42 < var1_42 do
		local var3_42 = arg0_42._shake:GetChild(var2_42)

		if var3_42.gameObject.activeSelf and var3_42 ~= arg0_42._paintingTF and var3_42 ~= arg0_42._bg and var3_42 ~= arg0_42._drag then
			var0_42[#var0_42 + 1] = var3_42

			setActive(var3_42, false)
		end

		var2_42 = var2_42 + 1
	end

	setActive(arg0_42._paintingShadowTF, false)
	openPortrait()

	local var4_42 = arg0_42._paintingTF
	local var5_42 = var4_42.anchoredPosition.x
	local var6_42 = var4_42.anchoredPosition.y
	local var7_42 = var4_42.rect.width
	local var8_42 = var4_42.rect.height
	local var9_42 = arg0_42._tf.rect.width / UnityEngine.Screen.width
	local var10_42 = arg0_42._tf.rect.height / UnityEngine.Screen.height
	local var11_42 = var7_42 / 2
	local var12_42 = var8_42 / 2
	local var13_42
	local var14_42

	if not LeanTween.isTweening(go(var4_42)) then
		arg0_42:AddLeanTween(function()
			return LeanTween.moveX(rtf(var4_42), 150, 0.5):setEase(LeanTweenType.easeInOutSine)
		end)
	end

	local var15_42 = GetOrAddComponent(arg0_42._drag, "MultiTouchZoom")

	var15_42:SetZoomTarget(arg0_42._paintingTF)

	local var16_42 = GetOrAddComponent(arg0_42._drag, "EventTriggerListener")

	arg0_42.dragTrigger = var16_42

	local var17_42 = true

	var15_42.enabled = true
	var16_42.enabled = true

	local var18_42 = false

	var16_42:AddPointDownFunc(function(arg0_44)
		if Input.touchCount == 1 or IsUnityEditor then
			var18_42 = true
			var17_42 = true
		elseif Input.touchCount >= 2 then
			var17_42 = false
			var18_42 = false
		end
	end)
	var16_42:AddPointUpFunc(function(arg0_45)
		if Input.touchCount <= 2 then
			var17_42 = true
		end
	end)
	var16_42:AddBeginDragFunc(function(arg0_46, arg1_46)
		var18_42 = false
		var13_42 = arg1_46.position.x * var9_42 - var11_42 - tf(arg0_42._paintingTF).localPosition.x
		var14_42 = arg1_46.position.y * var10_42 - var12_42 - tf(arg0_42._paintingTF).localPosition.y
	end)
	var16_42:AddDragFunc(function(arg0_47, arg1_47)
		if var17_42 then
			local var0_47 = tf(arg0_42._paintingTF).localPosition

			tf(arg0_42._paintingTF).localPosition = Vector3(arg1_47.position.x * var9_42 - var11_42 - var13_42, arg1_47.position.y * var10_42 - var12_42 - var14_42, -22)
		end
	end)
	onButton(arg0_42, arg0_42._drag, function()
		arg0_42:hidePaintView()
	end, SFX_CANCEL)

	function var0_0.hidePaintView(arg0_49, arg1_49)
		if not arg1_49 and not var18_42 then
			return
		end

		var16_42.enabled = false
		var15_42.enabled = false

		for iter0_49, iter1_49 in ipairs(var0_42) do
			setActive(iter1_49, true)
		end

		setActive(arg0_49._paintingShadowTF, true)
		closePortrait()
		LeanTween.cancel(go(arg0_49._paintingTF))

		arg0_49._paintingTF.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0_49._paintingTF, {
			x = var5_42,
			y = var6_42
		})

		arg0_49.isInView = false

		setActive(arg0_49.clickTF, true)
	end
end

function var0_0.recyclePainting(arg0_50)
	if arg0_50._shipVO then
		retPaintingPrefab(arg0_50._paintingTF, arg0_50._shipVO:getPainting())
		retPaintingPrefab(arg0_50._paintingShadowTF, arg0_50._shipVO:getPainting())

		arg0_50._shipVO = nil
	end
end

function var0_0.starsAnimation(arg0_51)
	arg0_51.inAnimating = true

	if arg0_51._shipVO:getMaxStar() >= 6 and PlayerPrefs.GetInt(RARE_SHIP_VIBRATE, 1) > 0 then
		LuaHelper.Vibrate()
	end

	setActive(arg0_51.starsCont, false)

	local var0_51 = arg0_51._tf:GetComponent(typeof(DftAniEvent))

	var0_51:SetTriggerEvent(function(arg0_52)
		arg0_51:AddLeanTween(function()
			return LeanTween.scale(rtf(arg0_51.starsCont), Vector3.one, 0):setOnComplete(System.Action(function()
				setActive(arg0_51.starsCont, true)
			end))
		end)

		local var0_52 = arg0_51.STAR_ANIMATION_DUR1

		for iter0_52 = 0, arg0_51.starsCont.childCount - 1 do
			local var1_52 = arg0_51.starsCont:GetChild(iter0_52)
			local var2_52 = var1_52:Find("star_empty")
			local var3_52 = var1_52:Find("star")

			setActive(var2_52, false)
			setActive(var3_52, false)

			local var4_52 = iter0_52 * var0_52

			arg0_51:AddLeanTween(function()
				return LeanTween.scale(rtf(var2_52), Vector3(1.8, 1.8, 1.8), 0):setDelay(var4_52):setOnComplete(System.Action(function()
					setActive(var2_52, true)
					arg0_51:AddLeanTween(function()
						return LeanTween.scale(rtf(var2_52), Vector3(1, 1, 1), var0_52)
					end)
				end))
			end)
		end

		local var5_52 = arg0_51._shipVO:getStar()
		local var6_52 = arg0_51.STAR_ANIMATION_DUR2
		local var7_52 = arg0_51.STAR_ANIMATION_DUR3

		for iter1_52 = 0, var5_52 - 1 do
			local var8_52 = arg0_51.starsCont:GetChild(iter1_52)
			local var9_52 = var8_52:Find("star_empty")
			local var10_52 = var8_52:Find("star")
			local var11_52 = var0_52 * arg0_51.starsCont.childCount + iter1_52 * var6_52

			arg0_51:AddLeanTween(function()
				return LeanTween.scale(rtf(var10_52), Vector3(1.8, 1.8, 1.8), 0):setDelay(var11_52):setOnStart(System.Action(function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_STAR)
				end)):setOnComplete(System.Action(function()
					setActive(var9_52, false)
					setActive(var10_52, true)
					arg0_51:AddLeanTween(function()
						return LeanTween.scale(rtf(var10_52), Vector3(1, 1, 1), var6_52)
					end)
				end))
			end)

			local var12_52 = var8_52:Find("light")

			if var12_52 then
				arg0_51:AddLeanTween(function()
					return LeanTween.delayedCall(var11_52, System.Action(function()
						if arg0_51.exited then
							return
						end

						setActive(var12_52, true)
					end))
				end)
				arg0_51:AddLeanTween(function()
					return LeanTween.alpha(rtf(var12_52), 0, var7_52):setDelay(var11_52):setOnComplete(System.Action(function()
						SetActive(var12_52, false)
						LeanTween.alpha(rtf(var12_52), 1, 0)
					end))
				end)

				var12_52.transform.localScale = Vector3(1, 1, 1)

				arg0_51:AddLeanTween(function()
					return LeanTween.scale(rtf(var12_52), Vector3(0.5, 1, 1), arg0_51.STAR_ANIMATION_DUR4):setDelay(var11_52 + var7_52 * 1 / 3)
				end)
			end
		end
	end)
	var0_51:SetEndEvent(function(arg0_67)
		if arg0_51._shipVO:getReMetaSpecialItemVO() then
			GetComponent(arg0_51.metaRepeatTF, "CanvasGroup").alpha = 1

			arg0_51:managedTween(LeanTween.value, function()
				setAnchoredPosition(arg0_51.metaRepeatTF, {
					x = 0
				})

				arg0_51.inAnimating = false

				setActive(arg0_51.npc, arg0_51._shipVO:isActivityNpc())
				setActive(arg0_51._shade, false)
			end, go(arg0_51.metaRepeatTF), arg0_51.metaRepeatTF.rect.width, 0, 1):setOnUpdate(System.Action_float(function(arg0_69)
				setAnchoredPosition(arg0_51.metaRepeatTF, {
					x = arg0_69
				})
			end))
			setAnchoredPosition(arg0_51.metaRepeatTF, {
				x = arg0_51.metaRepeatTF.rect.width
			})
			setActive(arg0_51.metaRepeatTF, true)
		else
			arg0_51.inAnimating = false

			setActive(arg0_51.npc, arg0_51._shipVO:isActivityNpc())
			setActive(arg0_51._shade, false)
		end
	end)
end

function var0_0.playOpening(arg0_70, arg1_70)
	if arg0_70._shipVO:isMetaShip() and not getProxy(ContextProxy):getContextByMediator(BuildShipMediator) then
		if arg1_70 then
			arg1_70()
		end

		return
	end

	local var0_70

	if arg0_70._shipVO:isRemoulded() then
		var0_70 = ShipGroup.GetGroupConfig(arg0_70._shipVO:getGroupId()).trans_skin
	else
		var0_70 = ShipGroup.getDefaultSkin(arg0_70._shipVO:getGroupId()).id
	end

	local var1_70 = "star_level_unlock_anim_" .. var0_70

	if checkABExist("ui/skinunlockanim/" .. var1_70) then
		pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
			return
		end, function()
			if arg1_70 then
				arg1_70()
			end
		end, "ui/skinunlockanim", var1_70, true, false)
	elseif arg1_70 then
		arg1_70()
	end
end

function var0_0.ClearTweens(arg0_73, arg1_73)
	arg0_73:cleanManagedTween(true)
end

function var0_0.willExit(arg0_74)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0_74:StopAutoExitTimer()
	arg0_74:DestroyNewShipDocumentView()

	if arg0_74.designBg then
		PoolMgr.GetInstance():ReturnUI(arg0_74.designName, arg0_74.designBg)
	end

	if arg0_74.metaBg then
		PoolMgr.GetInstance():ReturnUI(arg0_74.metaName, arg0_74.metaBg)
	end

	for iter0_74, iter1_74 in pairs(arg0_74.rarityEffect) do
		if iter1_74 then
			PoolMgr.GetInstance():ReturnUI("getrole_" .. iter0_74, iter1_74)
		end
	end

	if arg0_74.dragTrigger then
		ClearEventTrigger(arg0_74.dragTrigger)

		arg0_74.dragTrigger = nil
	end

	if not arg0_74.isRemoulded then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newShipLayer_get", pg.ship_data_by_type[arg0_74._shipVO:getShipType()].type_name, arg0_74._shipVO:getName()), COLOR_GREEN)
	end

	arg0_74:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_74._tf)
	arg0_74:stopVoice()

	if arg0_74.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_74.loadedCVBankName)

		arg0_74.loadedCVBankName = nil
	end

	if LeanTween.isTweening(go(arg0_74.rarityTF)) then
		LeanTween.cancel(go(arg0_74.rarityTF))
	end

	cameraPaintViewAdjust(false)
end

function var0_0.DisplayNewShipDocumentView(arg0_75)
	arg0_75.newShipDocumentView = NewShipDocumentView.New(arg0_75._shake:Find("ForNotch"), arg0_75.event, arg0_75.contextData)

	arg0_75.newShipDocumentView:Load()

	local function var0_75()
		if not arg0_75.isLoadBg then
			return
		end

		arg0_75:showExitTip()
	end

	arg0_75.newShipDocumentView:ActionInvoke("SetParams", arg0_75._shipVO, var0_75)
	arg0_75.newShipDocumentView:ActionInvoke("RefreshUI")
end

function var0_0.DestroyNewShipDocumentView(arg0_77)
	if arg0_77.newShipDocumentView and arg0_77.newShipDocumentView:CheckState(BaseSubView.STATES.INITED) then
		arg0_77.newShipDocumentView:Destroy()
	end
end

function var0_0.StopAutoExitTimer(arg0_78)
	if not arg0_78.autoExitTimer then
		return
	end

	arg0_78.autoExitTimer:Stop()

	arg0_78.autoExitTimer = nil
end

return var0_0
