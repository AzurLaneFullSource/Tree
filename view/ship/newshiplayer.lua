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

function var0_0.getLayerWeight(arg0_2)
	return LayerWeightConst.THIRD_LAYER
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = arg0_3.contextData.ship

	LoadSpriteAsync("newshipbg/bg_" .. var0_3:rarity2bgPrintForGet(), function(arg0_4)
		arg0_3.bgSprite = arg0_4
		arg0_3.isLoadBg = true

		arg1_3()
	end)
end

function var0_0.init(arg0_5)
	arg0_5._animator = GetComponent(arg0_5._tf, "Animator")
	arg0_5._canvasGroup = GetOrAddComponent(arg0_5._tf, typeof(CanvasGroup))
	arg0_5._shake = arg0_5:findTF("shake_panel")
	arg0_5._shade = arg0_5:findTF("shade")
	arg0_5._bg = arg0_5._shake:Find("bg")
	arg0_5._drag = arg0_5._shake:Find("drag")
	arg0_5._paintingTF = arg0_5._shake:Find("paint")
	arg0_5._paintingShadowTF = arg0_5._shake:Find("shadow")
	arg0_5._dialogue = arg0_5._shake:Find("dialogue")
	arg0_5._shipName = arg0_5._dialogue:Find("bg/name"):GetComponent(typeof(Text))
	arg0_5._shipType = arg0_5._dialogue:Find("bg/type"):GetComponent(typeof(Text))
	arg0_5._dialogueText = arg0_5._dialogue:Find("Text")
	arg0_5._left = arg0_5._shake:Find("ForNotch/left_panel")
	arg0_5._lockTF = arg0_5._left:Find("lock")
	arg0_5._lockBtn = arg0_5._left:Find("lock/lock")
	arg0_5._unlockBtn = arg0_5._left:Find("lock/unlock_btn")
	arg0_5._viewBtn = arg0_5._left:Find("view_btn")
	arg0_5._evaluationBtn = arg0_5._left:Find("evaluation_btn")
	arg0_5._shareBtn = arg0_5._left:Find("share_btn")
	arg0_5.audioBtn = arg0_5._shake:Find("property_btn")
	arg0_5.clickTF = arg0_5._shake:Find("click")
	arg0_5.npc = arg0_5:findTF("shake_panel/npc")

	setActive(arg0_5.npc, false)

	arg0_5.newTF = arg0_5._shake:Find("New")
	arg0_5.rarityTF = arg0_5._shake:Find("rarity")
	arg0_5.starsTF = arg0_5.rarityTF:Find("stars")
	arg0_5.starsCont = arg0_5:findTF("content", arg0_5.starsTF)
	arg0_5._skipButton = arg0_5._shake:Find("ForNotch/skip")

	setActive(arg0_5._skipButton, arg0_5.contextData.canSkipBatch)
	setActive(arg0_5._left, true)
	setActive(arg0_5.audioBtn, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf, {
		hideLowerLayer = true,
		weight = arg0_5:getWeightFromData()
	})

	arg0_5.metaRepeatTF = arg0_5:findTF("MetaRepeat", arg0_5.rarityTF)
	arg0_5.metaDarkTF = arg0_5:findTF("MetaMask", arg0_5._shake)
	arg0_5.rarityEffect = {}

	if arg0_5.contextData.autoExitTime then
		arg0_5.autoExitTimer = Timer.New(function()
			arg0_5:showExitTip()
		end, arg0_5.contextData.autoExitTime)

		arg0_5.autoExitTimer:Start()

		arg0_5.contextData.autoExitTime = nil
	end

	arg0_5:PauseAnimation()
end

function var0_0.voice(arg0_7, arg1_7)
	if not arg1_7 then
		return
	end

	arg0_7:stopVoice()

	arg0_7._currentVoice = arg1_7

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_7)
end

function var0_0.stopVoice(arg0_8)
	if arg0_8._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_8._currentVoice)
	end

	arg0_8._currentVoice = nil
end

function var0_0.setShip(arg0_9, arg1_9)
	arg0_9:recyclePainting()

	arg0_9._shipVO = arg1_9
	arg0_9.isRemoulded = arg1_9:isRemoulded()

	local var0_9 = arg1_9:isBluePrintShip()
	local var1_9 = arg1_9:isMetaShip()

	setImageSprite(arg0_9._bg, arg0_9.bgSprite)
	setActive(arg0_9.metaDarkTF, arg1_9:isMetaShip())

	if var0_9 then
		if arg0_9.metaBg then
			setActive(arg0_9.metaBg, false)
		end

		if arg0_9.designBg and arg0_9.designName ~= "raritydesign" .. arg1_9:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0_9.designName, arg0_9.designBg)

			arg0_9.designBg = nil
		end

		if not arg0_9.designBg then
			PoolMgr.GetInstance():GetUI("raritydesign" .. arg1_9:getRarity(), true, function(arg0_10)
				arg0_9.designBg = arg0_10
				arg0_9.designName = "raritydesign" .. arg1_9:getRarity()

				arg0_10.transform:SetParent(arg0_9._shake, false)

				arg0_10.transform.localPosition = Vector3(1, 1, 1)
				arg0_10.transform.localScale = Vector3(1, 1, 1)

				arg0_10.transform:SetSiblingIndex(1)
				setActive(arg0_10, true)
			end)
		else
			setActive(arg0_9.designBg, true)
		end
	elseif var1_9 then
		if arg0_9.designBg then
			setActive(arg0_9.designBg, false)
		end

		if arg0_9.metaBg and arg0_9.metaName ~= "raritymeta" .. arg1_9:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0_9.metaName, arg0_9.metaBg)

			arg0_9.metaBg = nil
		end

		if not arg0_9.metaBg then
			PoolMgr.GetInstance():GetUI("raritymeta" .. arg1_9:getRarity(), true, function(arg0_11)
				arg0_9.metaBg = arg0_11
				arg0_9.metaName = "raritymeta" .. arg1_9:getRarity()

				arg0_11.transform:SetParent(arg0_9._shake, false)

				arg0_11.transform.localPosition = Vector3(1, 1, 1)
				arg0_11.transform.localScale = Vector3(1, 1, 1)

				arg0_11.transform:SetSiblingIndex(1)
				setActive(arg0_11, true)
			end)
		else
			setActive(arg0_9.metaBg, true)
		end
	else
		if arg0_9.designBg then
			setActive(arg0_9.designBg, false)
		end

		if arg0_9.metaBg then
			setActive(arg0_9.metaBg, false)
		end
	end

	if arg1_9.virgin and not arg0_9.isRemoulded and not arg1_9:isActivityNpc() then
		setActive(arg0_9.newTF, true)
		LoadImageSpriteAsync("clutter/new", arg0_9.newTF)

		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg0_9._shipVO.groupId, 1) then
			local var2_9 = pg.fleet_tech_ship_template[arg0_9._shipVO.groupId].pt_get
			local var3_9 = ShipType.FilterOverQuZhuType(pg.fleet_tech_ship_template[arg0_9._shipVO.groupId].add_get_shiptype)
			local var4_9 = pg.fleet_tech_ship_template[arg0_9._shipVO.groupId].add_get_attr
			local var5_9 = pg.fleet_tech_ship_template[arg0_9._shipVO.groupId].add_get_value

			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
				point = var2_9,
				typeList = var3_9,
				attr = var4_9,
				value = var5_9
			})
		end
	else
		setActive(arg0_9.newTF, false)

		local var6_9 = arg1_9:getReMetaSpecialItemVO()

		arg0_9:updateLockTF(var6_9 ~= nil)

		if var6_9 then
			local var7_9 = arg0_9:findTF("Icon", arg0_9.metaRepeatTF)
			local var8_9 = arg0_9:findTF("Count", arg0_9.metaRepeatTF)

			setImageSprite(var7_9, LoadSprite(var6_9:getConfig("icon")))
			GetImageSpriteFromAtlasAsync(var6_9:getConfig("icon"), "", var7_9)
			setText(var8_9, var6_9.count)

			local var9_9 = pg.ship_transform[arg0_9._shipVO.groupId].exclusive_item[1][2]
			local var10_9 = pg.ship_transform[arg0_9._shipVO.groupId].common_item[1][2]
			local var11_9 = arg0_9:findTF("Special", arg0_9.metaRepeatTF)
			local var12_9 = arg0_9:findTF("Commom", arg0_9.metaRepeatTF)

			setActive(var11_9, var6_9.id == var9_9)
			setActive(var12_9, var6_9.id == var10_9)
		else
			setActive(arg0_9.metaRepeatTF, false)
		end
	end

	setActive(arg0_9.audioBtn, not arg0_9.isRemoulded)
	arg0_9:UpdateLockButton(arg0_9._shipVO:GetLockState())

	local var13_9 = arg0_9._shipVO:getConfigTable()

	if arg0_9.isRemoulded then
		setPaintingPrefabAsync(arg0_9._paintingTF, arg0_9._shipVO:getRemouldPainting(), "huode")
		setPaintingPrefabAsync(arg0_9._paintingShadowTF, arg0_9._shipVO:getRemouldPainting(), "huode")
	else
		setPaintingPrefabAsync(arg0_9._paintingTF, arg0_9._shipVO:getPainting(), "huode")
		setPaintingPrefabAsync(arg0_9._paintingShadowTF, arg0_9._shipVO:getPainting(), "huode")
	end

	arg0_9._shipType.text = pg.ship_data_by_type[arg0_9._shipVO:getShipType()].type_name
	arg0_9._shipName.text = arg1_9:getName()

	local var14_9 = arg1_9:getRarity()
	local var15_9 = pg.ship_data_template[var13_9.id].star_max
	local var16_9 = arg0_9._shipVO:getStar()

	if not (var15_9 % 2 == 0) or not (var15_9 / 2) then
		local var17_9 = math.floor(var15_9 / 2) + 1
	end

	local var18_9 = 15

	for iter0_9 = 1, 6 do
		local var19_9 = arg0_9.starsTF:Find("content/star_" .. iter0_9)
		local var20_9 = var19_9:Find("star_empty")
		local var21_9 = var19_9:Find("star")

		setActive(var21_9, iter0_9 <= var16_9)
		setActive(var20_9, var16_9 < iter0_9)

		if var15_9 < iter0_9 then
			setActive(var19_9, false)
		end
	end

	local var22_9 = arg0_9._shake:Find("rarity/nation")
	local var23_9 = LoadSprite("prints/" .. nation2print(var13_9.nationality) .. "_0")

	if not var23_9 then
		warning("找不到印花, shipConfigId: " .. arg1_9.configId)
		setActive(var22_9, false)
	else
		setImageSprite(var22_9, var23_9, false)
	end

	local var24_9 = arg0_9._shake:Find("rarity/type")
	local var25_9 = arg0_9._shake:Find("rarity/type/rarLogo")

	if arg1_9:isMetaShip() then
		LoadImageSpriteAsync("shiprarity/1" .. var14_9 .. "m", var24_9, true)
		LoadImageSpriteAsync("shiprarity/1" .. var14_9 .. "s", var25_9, true)
	else
		LoadImageSpriteAsync("shiprarity/" .. (var0_9 and "0" or "") .. var14_9 .. "m", var24_9, true)
		LoadImageSpriteAsync("shiprarity/" .. (var0_9 and "0" or "") .. var14_9 .. "s", var25_9, true)
	end

	setActive(var22_9, false)
	setActive(arg0_9.rarityTF, false)
	setActive(arg0_9._shade, true)

	arg0_9.inAnimating = true

	arg0_9:AddLeanTween(function()
		return LeanTween.delayedCall(0.5, System.Action(function()
			setActive(var22_9, true)
			setActive(arg0_9.rarityTF, true)
			arg0_9:starsAnimation()
		end))
	end)

	local var26_9 = arg0_9._shake:Find("ship_type")
	local var27_9 = var26_9:Find("stars")
	local var28_9 = var26_9:Find("stars/startpl")
	local var29_9 = var26_9:Find("english_name")

	setText(var29_9, arg0_9._shipVO:getConfig("english_name"))

	local var30_9 = var27_9.childCount
	local var31_9 = arg0_9._shipVO:getStar()
	local var32_9 = arg0_9._shipVO:getMaxStar()

	for iter1_9 = var30_9, var32_9 - 1 do
		cloneTplTo(var28_9, var27_9)
	end

	local var33_9 = var27_9.childCount

	for iter2_9 = 0, var33_9 - 1 do
		local var34_9 = var27_9:GetChild(iter2_9)

		var34_9.gameObject:SetActive(iter2_9 < var32_9)
		setActive(var34_9:Find("star"), iter2_9 < var31_9)
		setActive(var34_9:Find("empty"), var31_9 <= iter2_9)
	end

	local var35_9 = arg0_9._shipVO:getConfigTable()

	findTF(var26_9, "type_bg/type"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("shiptype", tostring(arg0_9._shipVO:getShipType()))

	setScrollText(var26_9:Find("name_bg/mask/Text"), arg0_9._shipVO:getName())

	if var0_9 then
		var14_9 = var14_9 .. "_1"
	elseif arg1_9:isMetaShip() then
		var14_9 = var14_9 .. "_2"
	end

	if not arg0_9.rarityEffect[var14_9] then
		PoolMgr.GetInstance():GetUI("getrole_" .. var14_9, true, function(arg0_14)
			if IsNil(arg0_9._tf) then
				return
			end

			arg0_9.rarityEffect[var14_9] = arg0_14

			arg0_14.transform:SetParent(arg0_9._tf, false)

			arg0_14.transform.localPosition = Vector3(1, 1, 1)
			arg0_14.transform.localScale = Vector3(1, 1, 1)

			arg0_14.transform:SetSiblingIndex(1)

			if arg1_9:isMetaShip() then
				local var0_14 = arg0_9:findTF("fire_ruchang", tf(arg0_14))

				var0_14:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_15)
					setActive(var22_9, true)
					setActive(var0_14, false)
				end)
			end

			setActive(var22_9, false)

			arg0_9.effectObj = arg0_14

			setActive(arg0_9.effectObj, arg0_9.isOpeningEnd)
		end)
	else
		arg0_9.effectObj = arg0_9.rarityEffect[var14_9]

		setActive(arg0_9.effectObj, arg0_9.isOpeningEnd)
	end

	arg0_9:playOpening(function()
		arg0_9:ResumeAnimation()
		arg0_9:DisplayWord()
	end)
end

function var0_0.PauseAnimation(arg0_17)
	arg0_17._canvasGroup.alpha = 0
	arg0_17._animator.enabled = false
end

function var0_0.ResumeAnimation(arg0_18)
	arg0_18._canvasGroup.alpha = 1
	arg0_18._animator.enabled = true
	arg0_18.isOpeningEnd = true

	if arg0_18.effectObj then
		setActive(arg0_18.effectObj, true)
	end
end

function var0_0.DisplayWord(arg0_19)
	local var0_19
	local var1_19 = ""
	local var2_19

	if arg0_19.isRemoulded then
		local var3_19 = arg0_19._shipVO:getRemouldSkinId()

		var1_19 = ShipWordHelper.RawGetWord(var3_19, ShipWordHelper.WORD_TYPE_UNLOCK)

		if var1_19 == "" then
			local var4_19

			var4_19, var2_19, var1_19 = ShipWordHelper.GetWordAndCV(var3_19, ShipWordHelper.WORD_TYPE_DROP)
		else
			local var5_19

			var5_19, var2_19, var1_19 = ShipWordHelper.GetWordAndCV(var3_19, ShipWordHelper.WORD_TYPE_UNLOCK)
		end
	else
		local var6_19

		var6_19, var2_19, var1_19 = ShipWordHelper.GetWordAndCV(arg0_19._shipVO.skinId, ShipWordHelper.WORD_TYPE_UNLOCK)
	end

	setWidgetText(arg0_19._dialogue, SwitchSpecialChar(var1_19, true), "Text")

	arg0_19._dialogue.transform.localScale = Vector3(0, 1, 1)

	SetActive(arg0_19._dialogue, false)
	arg0_19:AddLeanTween(function()
		return LeanTween.delayedCall(0.5, System.Action(function()
			SetActive(arg0_19._dialogue, true)
			arg0_19:AddLeanTween(function()
				return LeanTween.scale(arg0_19._dialogue, Vector3(1, 1, 1), 0.1)
			end)
			arg0_19:voice(var2_19)
		end))
	end)
end

function var0_0.updateShip(arg0_23, arg1_23)
	arg0_23._shipVO = arg1_23
end

function var0_0.switch2Property(arg0_24)
	setActive(arg0_24.newTF, false)
	setActive(arg0_24._dialogue, false)
	setActive(arg0_24.rarityTF, false)
	setActive(arg0_24._shake:Find("rarity/nation"), false)

	local var0_24 = arg0_24._shake:Find("ship_type")

	setActive(var0_24, true)
	arg0_24:AddLeanTween(function()
		return LeanTween.move(rtf(var0_24), Vector3(0, -149.55, 0), 0.3)
	end)
	arg0_24:AddLeanTween(function()
		return LeanTween.move(rtf(arg0_24._paintingTF), Vector3(-59, 21, 0), 0.2)
	end)
	arg0_24:DisplayNewShipDocumentView()
end

function var0_0.showExitTip(arg0_27, arg1_27)
	local var0_27 = arg0_27._shipVO:GetLockState()
	local var1_27 = pg.settings_other_template[22]
	local var2_27 = getProxy(PlayerProxy):getRawData():GetCommonFlag(_G[var1_27.name])

	if var1_27.default == 1 then
		var2_27 = not var2_27
	end

	if arg0_27._shipVO.virgin and var0_27 == Ship.LOCK_STATE_UNLOCK and not var2_27 then
		if arg0_27.effectObj then
			setActive(arg0_27.effectObj, false)
		end

		if arg0_27.effectLineObj then
			setActive(arg0_27.effectLineObj, false)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			content = i18n("ship_lock_tip"),
			onYes = function()
				triggerButton(arg0_27._lockBtn)

				if arg1_27 then
					arg1_27()
				else
					arg0_27:emit(NewShipMediator.ON_EXIT)
				end
			end,
			onNo = function()
				if arg1_27 then
					arg1_27()
				else
					arg0_27:emit(NewShipMediator.ON_EXIT)
				end
			end,
			weight = arg0_27:getWeightFromData()
		})
	elseif arg1_27 then
		arg1_27()
	else
		arg0_27:emit(NewShipMediator.ON_EXIT)
	end
end

function var0_0.UpdateLockButton(arg0_30, arg1_30)
	setActive(arg0_30._lockBtn, arg1_30 ~= Ship.LOCK_STATE_LOCK)
	setActive(arg0_30._unlockBtn, arg1_30 ~= Ship.LOCK_STATE_UNLOCK)
end

function var0_0.updateLockTF(arg0_31, arg1_31)
	setActive(arg0_31._lockTF, not arg1_31)
end

function var0_0.didEnter(arg0_32)
	onButton(arg0_32, arg0_32._lockBtn, function()
		arg0_32:StopAutoExitTimer()
		arg0_32:emit(NewShipMediator.ON_LOCK, {
			arg0_32._shipVO.id
		}, Ship.LOCK_STATE_LOCK)
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32._unlockBtn, function()
		arg0_32:StopAutoExitTimer()
		arg0_32:emit(NewShipMediator.ON_LOCK, {
			arg0_32._shipVO.id
		}, Ship.LOCK_STATE_UNLOCK)
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32._viewBtn, function()
		arg0_32:StopAutoExitTimer()

		arg0_32.isInView = true

		arg0_32:paintView()
		setActive(arg0_32.clickTF, false)
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32._evaluationBtn, function()
		arg0_32:StopAutoExitTimer()
		arg0_32:emit(NewShipMediator.ON_EVALIATION, arg0_32._shipVO:getGroupId())
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32._shareBtn, function()
		arg0_32:StopAutoExitTimer()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewShip, nil, {
			weight = arg0_32:getWeightFromData()
		})
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32.clickTF, function()
		arg0_32:StopAutoExitTimer()

		if arg0_32.isInView or not arg0_32.isLoadBg then
			return
		end

		arg0_32:showExitTip()
	end, SFX_CANCEL)
	onButton(arg0_32, arg0_32.audioBtn, function()
		arg0_32:StopAutoExitTimer()

		if arg0_32.isInView then
			return
		end

		if not arg0_32.isOpenProperty then
			arg0_32:switch2Property()

			arg0_32.isOpenProperty = true
		end

		setActive(arg0_32.audioBtn, not arg0_32.isRemoulded and not arg0_32.isOpenProperty)
	end, SFX_PANEL)
	onButton(arg0_32, arg0_32._skipButton, function()
		arg0_32:showExitTip(function()
			arg0_32:emit(NewShipMediator.ON_SKIP_BATCH)
		end)
	end, SFX_PANEL)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_CHARGET)
	pg.SystemGuideMgr.GetInstance():Play(arg0_32)
end

function var0_0.onBackPressed(arg0_42)
	if arg0_42.inAnimating then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_42.isInView then
		arg0_42:hidePaintView(true)

		return
	end

	arg0_42:DestroyNewShipDocumentView()
	triggerButton(arg0_42.clickTF)
end

function var0_0.paintView(arg0_43)
	local var0_43 = {}
	local var1_43 = arg0_43._shake.childCount
	local var2_43 = 0

	while var2_43 < var1_43 do
		local var3_43 = arg0_43._shake:GetChild(var2_43)

		if var3_43.gameObject.activeSelf and var3_43 ~= arg0_43._paintingTF and var3_43 ~= arg0_43._bg and var3_43 ~= arg0_43._drag then
			var0_43[#var0_43 + 1] = var3_43

			setActive(var3_43, false)
		end

		var2_43 = var2_43 + 1
	end

	setActive(arg0_43._paintingShadowTF, false)
	openPortrait()

	local var4_43 = arg0_43._paintingTF
	local var5_43 = var4_43.anchoredPosition.x
	local var6_43 = var4_43.anchoredPosition.y
	local var7_43 = var4_43.rect.width
	local var8_43 = var4_43.rect.height
	local var9_43 = arg0_43._tf.rect.width / UnityEngine.Screen.width
	local var10_43 = arg0_43._tf.rect.height / UnityEngine.Screen.height
	local var11_43 = var7_43 / 2
	local var12_43 = var8_43 / 2
	local var13_43
	local var14_43

	if not LeanTween.isTweening(go(var4_43)) then
		arg0_43:AddLeanTween(function()
			return LeanTween.moveX(rtf(var4_43), 150, 0.5):setEase(LeanTweenType.easeInOutSine)
		end)
	end

	local var15_43 = GetOrAddComponent(arg0_43._drag, "MultiTouchZoom")

	var15_43:SetZoomTarget(arg0_43._paintingTF)

	local var16_43 = GetOrAddComponent(arg0_43._drag, "EventTriggerListener")

	arg0_43.dragTrigger = var16_43

	local var17_43 = true

	var15_43.enabled = true
	var16_43.enabled = true

	local var18_43 = false

	var16_43:AddPointDownFunc(function(arg0_45)
		if Input.touchCount == 1 or IsUnityEditor then
			var18_43 = true
			var17_43 = true
		elseif Input.touchCount >= 2 then
			var17_43 = false
			var18_43 = false
		end
	end)
	var16_43:AddPointUpFunc(function(arg0_46)
		if Input.touchCount <= 2 then
			var17_43 = true
		end
	end)
	var16_43:AddBeginDragFunc(function(arg0_47, arg1_47)
		var18_43 = false
		var13_43 = arg1_47.position.x * var9_43 - var11_43 - tf(arg0_43._paintingTF).localPosition.x
		var14_43 = arg1_47.position.y * var10_43 - var12_43 - tf(arg0_43._paintingTF).localPosition.y
	end)
	var16_43:AddDragFunc(function(arg0_48, arg1_48)
		if var17_43 then
			local var0_48 = tf(arg0_43._paintingTF).localPosition

			tf(arg0_43._paintingTF).localPosition = Vector3(arg1_48.position.x * var9_43 - var11_43 - var13_43, arg1_48.position.y * var10_43 - var12_43 - var14_43, -22)
		end
	end)
	onButton(arg0_43, arg0_43._drag, function()
		arg0_43:hidePaintView()
	end, SFX_CANCEL)

	function var0_0.hidePaintView(arg0_50, arg1_50)
		if not arg1_50 and not var18_43 then
			return
		end

		var16_43.enabled = false
		var15_43.enabled = false

		for iter0_50, iter1_50 in ipairs(var0_43) do
			setActive(iter1_50, true)
		end

		setActive(arg0_50._paintingShadowTF, true)
		closePortrait()
		LeanTween.cancel(go(arg0_50._paintingTF))

		arg0_50._paintingTF.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0_50._paintingTF, {
			x = var5_43,
			y = var6_43
		})

		arg0_50.isInView = false

		setActive(arg0_50.clickTF, true)
	end
end

function var0_0.recyclePainting(arg0_51)
	if arg0_51._shipVO then
		retPaintingPrefab(arg0_51._paintingTF, arg0_51._shipVO:getPainting())
		retPaintingPrefab(arg0_51._paintingShadowTF, arg0_51._shipVO:getPainting())

		arg0_51._shipVO = nil
	end
end

function var0_0.starsAnimation(arg0_52)
	arg0_52.inAnimating = true

	if arg0_52._shipVO:getMaxStar() >= 6 and PlayerPrefs.GetInt(RARE_SHIP_VIBRATE, 1) > 0 then
		LuaHelper.Vibrate()
	end

	setActive(arg0_52.starsCont, false)

	local var0_52 = arg0_52._tf:GetComponent(typeof(DftAniEvent))

	var0_52:SetTriggerEvent(function(arg0_53)
		arg0_52:AddLeanTween(function()
			return LeanTween.scale(rtf(arg0_52.starsCont), Vector3.one, 0):setOnComplete(System.Action(function()
				setActive(arg0_52.starsCont, true)
			end))
		end)

		local var0_53 = arg0_52.STAR_ANIMATION_DUR1

		for iter0_53 = 0, arg0_52.starsCont.childCount - 1 do
			local var1_53 = arg0_52.starsCont:GetChild(iter0_53)
			local var2_53 = var1_53:Find("star_empty")
			local var3_53 = var1_53:Find("star")

			setActive(var2_53, false)
			setActive(var3_53, false)

			local var4_53 = iter0_53 * var0_53

			arg0_52:AddLeanTween(function()
				return LeanTween.scale(rtf(var2_53), Vector3(1.8, 1.8, 1.8), 0):setDelay(var4_53):setOnComplete(System.Action(function()
					setActive(var2_53, true)
					arg0_52:AddLeanTween(function()
						return LeanTween.scale(rtf(var2_53), Vector3(1, 1, 1), var0_53)
					end)
				end))
			end)
		end

		local var5_53 = arg0_52._shipVO:getStar()
		local var6_53 = arg0_52.STAR_ANIMATION_DUR2
		local var7_53 = arg0_52.STAR_ANIMATION_DUR3

		for iter1_53 = 0, var5_53 - 1 do
			local var8_53 = arg0_52.starsCont:GetChild(iter1_53)
			local var9_53 = var8_53:Find("star_empty")
			local var10_53 = var8_53:Find("star")
			local var11_53 = var0_53 * arg0_52.starsCont.childCount + iter1_53 * var6_53

			arg0_52:AddLeanTween(function()
				return LeanTween.scale(rtf(var10_53), Vector3(1.8, 1.8, 1.8), 0):setDelay(var11_53):setOnStart(System.Action(function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_STAR)
				end)):setOnComplete(System.Action(function()
					setActive(var9_53, false)
					setActive(var10_53, true)
					arg0_52:AddLeanTween(function()
						return LeanTween.scale(rtf(var10_53), Vector3(1, 1, 1), var6_53)
					end)
				end))
			end)

			local var12_53 = var8_53:Find("light")

			if var12_53 then
				arg0_52:AddLeanTween(function()
					return LeanTween.delayedCall(var11_53, System.Action(function()
						if arg0_52.exited then
							return
						end

						setActive(var12_53, true)
					end))
				end)
				arg0_52:AddLeanTween(function()
					return LeanTween.alpha(rtf(var12_53), 0, var7_53):setDelay(var11_53):setOnComplete(System.Action(function()
						SetActive(var12_53, false)
						LeanTween.alpha(rtf(var12_53), 1, 0)
					end))
				end)

				var12_53.transform.localScale = Vector3(1, 1, 1)

				arg0_52:AddLeanTween(function()
					return LeanTween.scale(rtf(var12_53), Vector3(0.5, 1, 1), arg0_52.STAR_ANIMATION_DUR4):setDelay(var11_53 + var7_53 * 1 / 3)
				end)
			end
		end
	end)
	var0_52:SetEndEvent(function(arg0_68)
		if arg0_52._shipVO:getReMetaSpecialItemVO() then
			GetComponent(arg0_52.metaRepeatTF, "CanvasGroup").alpha = 1

			arg0_52:managedTween(LeanTween.value, function()
				setAnchoredPosition(arg0_52.metaRepeatTF, {
					x = 0
				})

				arg0_52.inAnimating = false

				setActive(arg0_52.npc, arg0_52._shipVO:isActivityNpc())
				setActive(arg0_52._shade, false)
			end, go(arg0_52.metaRepeatTF), arg0_52.metaRepeatTF.rect.width, 0, 1):setOnUpdate(System.Action_float(function(arg0_70)
				setAnchoredPosition(arg0_52.metaRepeatTF, {
					x = arg0_70
				})
			end))
			setAnchoredPosition(arg0_52.metaRepeatTF, {
				x = arg0_52.metaRepeatTF.rect.width
			})
			setActive(arg0_52.metaRepeatTF, true)
		else
			arg0_52.inAnimating = false

			setActive(arg0_52.npc, arg0_52._shipVO:isActivityNpc())
			setActive(arg0_52._shade, false)
		end
	end)
end

function var0_0.playOpening(arg0_71, arg1_71)
	if arg0_71._shipVO:isMetaShip() and not getProxy(ContextProxy):getContextByMediator(BuildShipMediator) then
		if arg1_71 then
			arg1_71()
		end

		return
	end

	local var0_71

	if arg0_71._shipVO:isRemoulded() then
		var0_71 = ShipGroup.GetGroupConfig(arg0_71._shipVO:getGroupId()).trans_skin
	else
		var0_71 = ShipGroup.getDefaultSkin(arg0_71._shipVO:getGroupId()).id
	end

	local var1_71 = "star_level_unlock_anim_" .. var0_71

	if PathMgr.FileExists(PathMgr.getAssetBundle("ui/skinunlockanim/" .. var1_71)) then
		pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
			return
		end, function()
			if arg1_71 then
				arg1_71()
			end
		end, "ui/skinunlockanim", var1_71, true, false, {
			weight = arg0_71:getWeightFromData()
		})
	elseif arg1_71 then
		arg1_71()
	end
end

function var0_0.ClearTweens(arg0_74, arg1_74)
	arg0_74:cleanManagedTween(true)
end

function var0_0.willExit(arg0_75)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0_75:StopAutoExitTimer()
	arg0_75:DestroyNewShipDocumentView()

	if arg0_75.designBg then
		PoolMgr.GetInstance():ReturnUI(arg0_75.designName, arg0_75.designBg)
	end

	if arg0_75.metaBg then
		PoolMgr.GetInstance():ReturnUI(arg0_75.metaName, arg0_75.metaBg)
	end

	for iter0_75, iter1_75 in pairs(arg0_75.rarityEffect) do
		if iter1_75 then
			PoolMgr.GetInstance():ReturnUI("getrole_" .. iter0_75, iter1_75)
		end
	end

	if arg0_75.dragTrigger then
		ClearEventTrigger(arg0_75.dragTrigger)

		arg0_75.dragTrigger = nil
	end

	if not arg0_75.isRemoulded then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newShipLayer_get", pg.ship_data_by_type[arg0_75._shipVO:getShipType()].type_name, arg0_75._shipVO:getName()), COLOR_GREEN)
	end

	arg0_75:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_75._tf)
	arg0_75:stopVoice()

	if arg0_75.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_75.loadedCVBankName)

		arg0_75.loadedCVBankName = nil
	end

	if LeanTween.isTweening(go(arg0_75.rarityTF)) then
		LeanTween.cancel(go(arg0_75.rarityTF))
	end

	cameraPaintViewAdjust(false)
end

function var0_0.DisplayNewShipDocumentView(arg0_76)
	arg0_76.newShipDocumentView = NewShipDocumentView.New(arg0_76._shake:Find("ForNotch"), arg0_76.event, arg0_76.contextData)

	arg0_76.newShipDocumentView:Load()

	local function var0_76()
		if not arg0_76.isLoadBg then
			return
		end

		arg0_76:showExitTip()
	end

	arg0_76.newShipDocumentView:ActionInvoke("SetParams", arg0_76._shipVO, var0_76)
	arg0_76.newShipDocumentView:ActionInvoke("RefreshUI")
end

function var0_0.DestroyNewShipDocumentView(arg0_78)
	if arg0_78.newShipDocumentView and arg0_78.newShipDocumentView:CheckState(BaseSubView.STATES.INITED) then
		arg0_78.newShipDocumentView:Destroy()
	end
end

function var0_0.StopAutoExitTimer(arg0_79)
	if not arg0_79.autoExitTimer then
		return
	end

	arg0_79.autoExitTimer:Stop()

	arg0_79.autoExitTimer = nil
end

return var0_0
