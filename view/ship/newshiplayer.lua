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

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"clutter/new",
		"shiptype"
	}
	local var1_2 = arg1_2.ship

	table.insert(var0_2, string.format(ResPathSupport.ConstPath.Ship.Rarity.NewShipBG, var1_2:rarity2bgPrintForGet()))

	if var1_2:isBluePrintShip() then
		table.insert(var0_2, string.format(ResPathSupport.ConstPath.Ship.Rarity.EffectDesign, var1_2:getRarity()))
	end

	local var2_2 = var1_2:isMetaShip()

	if var2_2 then
		table.insert(var0_2, string.format(ResPathSupport.ConstPath.Ship.Rarity.EffectMeta, var1_2:getRarity()))
	end

	if var2_2 then
		local var3_2 = MetaCharacterConst.getReMetaTransItem(var1_2)

		table.insert(var0_2, var3_2:getConfig("icon"))
	end

	local var4_2 = Ship.getPaintingName(var1_2.configId)
	local var5_2 = ResPathSupport.GetPaintingListByPaintingName(var4_2)
	local var6_2 = ResPathSupport.GetPaintingFaceListByPaintingName(var4_2)

	table.insertto(var0_2, var5_2)
	table.insertto(var0_2, var6_2)

	local var7_2 = var1_2:getNation()

	_.each(ResPathSupport.ConstPath.Ship.Nation.PrintsFixList, function(arg0_3)
		local var0_3 = string.format(ResPathSupport.ConstPath.Ship.Nation.Prints, nation2print(var7_2), arg0_3)

		table.insert(var0_2, var0_3)
	end)

	local var8_2 = var1_2:getRarity()

	_.each(ResPathSupport.ConstPath.Ship.Rarity.ShipRarityFixList1, function(arg0_4)
		_.each(ResPathSupport.ConstPath.Ship.Rarity.ShipRarityFixList2, function(arg0_5)
			local var0_5 = string.format(ResPathSupport.ConstPath.Ship.Rarity.ShipRarity, arg0_4, var8_2, arg0_5)

			table.insert(var0_2, var0_5)
		end)
	end)
	_.each(ResPathSupport.ConstPath.Ship.Rarity.GetRoleFixList, function(arg0_6)
		local var0_6 = string.format(ResPathSupport.ConstPath.Ship.Rarity.GetRole, var8_2, arg0_6)

		table.insert(var0_2, var0_6)
	end)

	local var9_2 = var1_2:getGroupId()
	local var10_2 = {
		ShipGroup.GetGroupConfig(var9_2).trans_skin,
		ShipGroup.getDefaultSkin(var9_2).id
	}

	_.each(var10_2, function(arg0_7)
		local var0_7 = "ui/skinunlockanim/star_level_unlock_anim_" .. arg0_7

		table.insert(var0_2, var0_7)
	end)

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2))
end

function var0_0.preload(arg0_8, arg1_8)
	local var0_8 = arg0_8.contextData.ship

	LoadSpriteAsync("newshipbg/bg_" .. var0_8:rarity2bgPrintForGet(), function(arg0_9)
		arg0_8.bgSprite = arg0_9
		arg0_8.isLoadBg = true

		arg1_8()
	end)
end

function var0_0.init(arg0_10)
	arg0_10._animator = GetComponent(arg0_10._tf, "Animator")
	arg0_10._canvasGroup = GetOrAddComponent(arg0_10._tf, typeof(CanvasGroup))
	arg0_10._shake = arg0_10._tf:Find("shake_panel")
	arg0_10._shade = arg0_10._tf:Find("shade")
	arg0_10._bg = arg0_10._shake:Find("bg")
	arg0_10._drag = arg0_10._shake:Find("drag")
	arg0_10._paintingTF = arg0_10._shake:Find("paint")
	arg0_10._paintingShadowTF = arg0_10._shake:Find("shadow")
	arg0_10._dialogue = arg0_10._shake:Find("dialogue")
	arg0_10._shipName = arg0_10._dialogue:Find("bg/name"):GetComponent(typeof(Text))
	arg0_10._shipType = arg0_10._dialogue:Find("bg/type"):GetComponent(typeof(Text))
	arg0_10._dialogueText = arg0_10._dialogue:Find("Text")
	arg0_10._left = arg0_10._shake:Find("ForNotch/left_panel")
	arg0_10._lockTF = arg0_10._left:Find("lock")
	arg0_10._lockBtn = arg0_10._left:Find("lock/lock")
	arg0_10._unlockBtn = arg0_10._left:Find("lock/unlock_btn")
	arg0_10._viewBtn = arg0_10._left:Find("view_btn")
	arg0_10._evaluationBtn = arg0_10._left:Find("evaluation_btn")
	arg0_10._shareBtn = arg0_10._left:Find("share_btn")
	arg0_10.audioBtn = arg0_10._shake:Find("property_btn")
	arg0_10.clickTF = arg0_10._shake:Find("click")
	arg0_10.npc = arg0_10._tf:Find("shake_panel/npc")

	setActive(arg0_10.npc, false)

	arg0_10.newTF = arg0_10._shake:Find("New")
	arg0_10.rarityTF = arg0_10._shake:Find("rarity")
	arg0_10.starsTF = arg0_10.rarityTF:Find("stars")
	arg0_10.starsCont = arg0_10.starsTF:Find("content")
	arg0_10._skipButton = arg0_10._shake:Find("ForNotch/skip")

	setActive(arg0_10._skipButton, arg0_10.contextData.canSkipBatch)
	setActive(arg0_10._left, true)
	setActive(arg0_10.audioBtn, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_10._tf)

	arg0_10.metaRepeatTF = arg0_10.rarityTF:Find("MetaRepeat")
	arg0_10.metaDarkTF = arg0_10._shake:Find("MetaMask")
	arg0_10.rarityEffect = {}

	if arg0_10.contextData.autoExitTime then
		arg0_10.autoExitTimer = Timer.New(function()
			arg0_10:showExitTip()
		end, arg0_10.contextData.autoExitTime)

		arg0_10.autoExitTimer:Start()

		arg0_10.contextData.autoExitTime = nil
	end

	arg0_10:PauseAnimation()
end

function var0_0.voice(arg0_12, arg1_12)
	if not arg1_12 then
		return
	end

	arg0_12:stopVoice()

	arg0_12._currentVoice = arg1_12

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_12)
end

function var0_0.stopVoice(arg0_13)
	if arg0_13._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_13._currentVoice)
	end

	arg0_13._currentVoice = nil
end

function var0_0.setShip(arg0_14, arg1_14)
	arg0_14:recyclePainting()

	arg0_14._shipVO = arg1_14
	arg0_14.isRemoulded = arg1_14:isRemoulded()

	local var0_14 = arg1_14:isBluePrintShip()
	local var1_14 = arg1_14:isMetaShip()

	setImageSprite(arg0_14._bg, arg0_14.bgSprite)
	setActive(arg0_14.metaDarkTF, arg1_14:isMetaShip())

	if var0_14 then
		if arg0_14.metaBg then
			setActive(arg0_14.metaBg, false)
		end

		if arg0_14.designBg and arg0_14.designName ~= "raritydesign" .. arg1_14:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0_14.designName, arg0_14.designBg)

			arg0_14.designBg = nil
		end

		if not arg0_14.designBg then
			PoolMgr.GetInstance():GetUI("raritydesign" .. arg1_14:getRarity(), true, function(arg0_15)
				arg0_14.designBg = arg0_15
				arg0_14.designName = "raritydesign" .. arg1_14:getRarity()

				arg0_15.transform:SetParent(arg0_14._shake, false)

				arg0_15.transform.localPosition = Vector3(1, 1, 1)
				arg0_15.transform.localScale = Vector3(1, 1, 1)

				arg0_15.transform:SetSiblingIndex(1)
				setActive(arg0_15, true)
			end)
		else
			setActive(arg0_14.designBg, true)
		end
	elseif var1_14 then
		if arg0_14.designBg then
			setActive(arg0_14.designBg, false)
		end

		if arg0_14.metaBg and arg0_14.metaName ~= "raritymeta" .. arg1_14:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0_14.metaName, arg0_14.metaBg)

			arg0_14.metaBg = nil
		end

		if not arg0_14.metaBg then
			PoolMgr.GetInstance():GetUI("raritymeta" .. arg1_14:getRarity(), true, function(arg0_16)
				arg0_14.metaBg = arg0_16
				arg0_14.metaName = "raritymeta" .. arg1_14:getRarity()

				arg0_16.transform:SetParent(arg0_14._shake, false)

				arg0_16.transform.localPosition = Vector3(1, 1, 1)
				arg0_16.transform.localScale = Vector3(1, 1, 1)

				arg0_16.transform:SetSiblingIndex(1)
				setActive(arg0_16, true)
			end)
		else
			setActive(arg0_14.metaBg, true)
		end
	else
		if arg0_14.designBg then
			setActive(arg0_14.designBg, false)
		end

		if arg0_14.metaBg then
			setActive(arg0_14.metaBg, false)
		end
	end

	if arg1_14.virgin and not arg0_14.isRemoulded and not arg1_14:isActivityNpc() then
		setActive(arg0_14.newTF, true)
		LoadImageSpriteAsync("clutter/new", arg0_14.newTF)

		if OPEN_TEC_TREE_SYSTEM and table.indexof(pg.fleet_tech_ship_template.all, arg0_14._shipVO.groupId, 1) then
			local var2_14 = pg.fleet_tech_ship_template[arg0_14._shipVO.groupId].pt_get
			local var3_14 = ShipType.FilterOverQuZhuType(pg.fleet_tech_ship_template[arg0_14._shipVO.groupId].add_get_shiptype)
			local var4_14 = pg.fleet_tech_ship_template[arg0_14._shipVO.groupId].add_get_attr
			local var5_14 = pg.fleet_tech_ship_template[arg0_14._shipVO.groupId].add_get_value

			pg.ToastMgr.GetInstance():ShowToast(pg.ToastMgr.TYPE_TECPOINT, {
				point = var2_14,
				typeList = var3_14,
				attr = var4_14,
				value = var5_14
			})
		end
	else
		setActive(arg0_14.newTF, false)

		local var6_14 = arg1_14:getReMetaSpecialItemVO()

		arg0_14:updateLockTF(var6_14 ~= nil)

		if var6_14 then
			local var7_14 = arg0_14.metaRepeatTF:Find("Icon")
			local var8_14 = arg0_14.metaRepeatTF:Find("Count")

			setImageSprite(var7_14, LoadSprite(var6_14:getConfig("icon")))
			GetImageSpriteFromAtlasAsync(var6_14:getConfig("icon"), "", var7_14)
			setText(var8_14, var6_14.count)

			local var9_14 = pg.ship_transform[arg0_14._shipVO.groupId].exclusive_item[1][2]
			local var10_14 = pg.ship_transform[arg0_14._shipVO.groupId].common_item[1][2]
			local var11_14 = arg0_14.metaRepeatTF:Find("Special")
			local var12_14 = arg0_14.metaRepeatTF:Find("Commom")

			setActive(var11_14, var6_14.id == var9_14)
			setActive(var12_14, var6_14.id == var10_14)
		else
			setActive(arg0_14.metaRepeatTF, false)
		end
	end

	setActive(arg0_14.audioBtn, not arg0_14.isRemoulded)
	arg0_14:UpdateLockButton(arg0_14._shipVO:GetLockState())

	local var13_14 = arg0_14._shipVO:getConfigTable()

	if arg0_14.isRemoulded then
		setPaintingPrefabAsync(arg0_14._paintingTF, arg0_14._shipVO:getRemouldPainting(), "huode")
		setPaintingPrefabAsync(arg0_14._paintingShadowTF, arg0_14._shipVO:getRemouldPainting(), "huode")
	else
		setPaintingPrefabAsync(arg0_14._paintingTF, arg0_14._shipVO:getPainting(), "huode")
		setPaintingPrefabAsync(arg0_14._paintingShadowTF, arg0_14._shipVO:getPainting(), "huode")
	end

	arg0_14._shipType.text = pg.ship_data_by_type[arg0_14._shipVO:getShipType()].type_name
	arg0_14._shipName.text = arg1_14:getName()

	local var14_14 = arg1_14:getRarity()
	local var15_14 = pg.ship_data_template[var13_14.id].star_max
	local var16_14 = arg0_14._shipVO:getStar()

	if not (var15_14 % 2 == 0) or not (var15_14 / 2) then
		local var17_14 = math.floor(var15_14 / 2) + 1
	end

	local var18_14 = 15

	for iter0_14 = 1, 6 do
		local var19_14 = arg0_14.starsTF:Find("content/star_" .. iter0_14)
		local var20_14 = var19_14:Find("star_empty")
		local var21_14 = var19_14:Find("star")

		setActive(var21_14, iter0_14 <= var16_14)
		setActive(var20_14, var16_14 < iter0_14)

		if var15_14 < iter0_14 then
			setActive(var19_14, false)
		end
	end

	local var22_14 = arg0_14._shake:Find("rarity/nation")
	local var23_14 = LoadSprite("prints/" .. nation2print(var13_14.nationality) .. "_0")

	if not var23_14 then
		warning("找不到印花, shipConfigId: " .. arg1_14.configId)
		setActive(var22_14, false)
	else
		setImageSprite(var22_14, var23_14, false)
	end

	local var24_14 = arg0_14._shake:Find("rarity/type")
	local var25_14 = arg0_14._shake:Find("rarity/type/rarLogo")

	if arg1_14:isMetaShip() then
		LoadImageSpriteAsync("shiprarity/1" .. var14_14 .. "m", var24_14, true)
		LoadImageSpriteAsync("shiprarity/1" .. var14_14 .. "s", var25_14, true)
	else
		LoadImageSpriteAsync("shiprarity/" .. (var0_14 and "0" or "") .. var14_14 .. "m", var24_14, true)
		LoadImageSpriteAsync("shiprarity/" .. (var0_14 and "0" or "") .. var14_14 .. "s", var25_14, true)
	end

	setActive(var22_14, false)
	setActive(arg0_14.rarityTF, false)
	setActive(arg0_14._shade, true)

	arg0_14.inAnimating = true

	arg0_14:AddLeanTween(function()
		return LeanTween.delayedCall(0.5, System.Action(function()
			setActive(var22_14, true)
			setActive(arg0_14.rarityTF, true)
			arg0_14:starsAnimation()
		end))
	end)

	local var26_14 = arg0_14._shake:Find("ship_type")
	local var27_14 = var26_14:Find("stars")
	local var28_14 = var26_14:Find("stars/startpl")
	local var29_14 = var26_14:Find("english_name")

	setText(var29_14, arg0_14._shipVO:getConfig("english_name"))

	local var30_14 = var27_14.childCount
	local var31_14 = arg0_14._shipVO:getStar()
	local var32_14 = arg0_14._shipVO:getMaxStar()

	for iter1_14 = var30_14, var32_14 - 1 do
		cloneTplTo(var28_14, var27_14)
	end

	local var33_14 = var27_14.childCount

	for iter2_14 = 0, var33_14 - 1 do
		local var34_14 = var27_14:GetChild(iter2_14)

		var34_14.gameObject:SetActive(iter2_14 < var32_14)
		setActive(var34_14:Find("star"), iter2_14 < var31_14)
		setActive(var34_14:Find("empty"), var31_14 <= iter2_14)
	end

	local var35_14 = arg0_14._shipVO:getConfigTable()

	findTF(var26_14, "type_bg/type"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("shiptype", tostring(arg0_14._shipVO:getShipType()))

	setScrollText(var26_14:Find("name_bg/mask/Text"), arg0_14._shipVO:getName())

	if var0_14 then
		var14_14 = var14_14 .. "_1"
	elseif arg1_14:isMetaShip() then
		var14_14 = var14_14 .. "_2"
	end

	if not arg0_14.rarityEffect[var14_14] then
		PoolMgr.GetInstance():GetUI("getrole_" .. var14_14, true, function(arg0_19)
			if IsNil(arg0_14._tf) then
				return
			end

			arg0_14.rarityEffect[var14_14] = arg0_19

			arg0_19.transform:SetParent(arg0_14._tf, false)

			arg0_19.transform.localPosition = Vector3(1, 1, 1)
			arg0_19.transform.localScale = Vector3(1, 1, 1)

			arg0_19.transform:SetSiblingIndex(1)

			if arg1_14:isMetaShip() then
				local var0_19 = tf(arg0_19):Find("fire_ruchang")

				var0_19:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_20)
					setActive(var22_14, true)
					setActive(var0_19, false)
				end)
			end

			setActive(var22_14, false)

			arg0_14.effectObj = arg0_19

			setActive(arg0_14.effectObj, arg0_14.isOpeningEnd)
		end)
	else
		arg0_14.effectObj = arg0_14.rarityEffect[var14_14]

		setActive(arg0_14.effectObj, arg0_14.isOpeningEnd)
	end

	arg0_14:playOpening(function()
		arg0_14:ResumeAnimation()
		arg0_14:DisplayWord()
	end)
end

function var0_0.PauseAnimation(arg0_22)
	arg0_22._canvasGroup.alpha = 0
	arg0_22._animator.enabled = false
end

function var0_0.ResumeAnimation(arg0_23)
	arg0_23._canvasGroup.alpha = 1
	arg0_23._animator.enabled = true
	arg0_23.isOpeningEnd = true

	if arg0_23.effectObj then
		setActive(arg0_23.effectObj, true)
	end
end

function var0_0.DisplayWord(arg0_24)
	local var0_24
	local var1_24 = ""
	local var2_24

	if arg0_24.isRemoulded then
		local var3_24 = arg0_24._shipVO:getRemouldSkinId()

		var1_24 = ShipWordHelper.RawGetWord(var3_24, ShipWordHelper.WORD_TYPE_UNLOCK)

		if var1_24 == "" then
			local var4_24

			var4_24, var2_24, var1_24 = ShipWordHelper.GetWordAndCV(var3_24, ShipWordHelper.WORD_TYPE_DROP)
		else
			local var5_24

			var5_24, var2_24, var1_24 = ShipWordHelper.GetWordAndCV(var3_24, ShipWordHelper.WORD_TYPE_UNLOCK)
		end
	else
		local var6_24

		var6_24, var2_24, var1_24 = ShipWordHelper.GetWordAndCV(arg0_24._shipVO:getSkinId(), ShipWordHelper.WORD_TYPE_UNLOCK)
	end

	setWidgetText(arg0_24._dialogue, SwitchSpecialChar(var1_24, true), "Text")

	arg0_24._dialogue.transform.localScale = Vector3(0, 1, 1)

	SetActive(arg0_24._dialogue, false)
	arg0_24:AddLeanTween(function()
		return LeanTween.delayedCall(0.5, System.Action(function()
			SetActive(arg0_24._dialogue, true)
			arg0_24:AddLeanTween(function()
				return LeanTween.scale(arg0_24._dialogue, Vector3(1, 1, 1), 0.1)
			end)
			arg0_24:voice(var2_24)
		end))
	end)
end

function var0_0.updateShip(arg0_28, arg1_28)
	arg0_28._shipVO = arg1_28
end

function var0_0.switch2Property(arg0_29)
	setActive(arg0_29.newTF, false)
	setActive(arg0_29._dialogue, false)
	setActive(arg0_29.rarityTF, false)
	setActive(arg0_29._shake:Find("rarity/nation"), false)

	local var0_29 = arg0_29._shake:Find("ship_type")

	setActive(var0_29, true)
	arg0_29:AddLeanTween(function()
		return LeanTween.move(rtf(var0_29), Vector3(0, -149.55, 0), 0.3)
	end)
	arg0_29:AddLeanTween(function()
		return LeanTween.move(rtf(arg0_29._paintingTF), Vector3(-59, 21, 0), 0.2)
	end)
	arg0_29:DisplayNewShipDocumentView()
end

function var0_0.showExitTip(arg0_32, arg1_32)
	local var0_32 = arg0_32._shipVO:GetLockState()
	local var1_32 = pg.settings_other_template[22]
	local var2_32 = getProxy(PlayerProxy):getRawData():GetCommonFlag(_G[var1_32.name])

	if var1_32.default == 1 then
		var2_32 = not var2_32
	end

	if arg0_32._shipVO.virgin and var0_32 == Ship.LOCK_STATE_UNLOCK and not var2_32 then
		if arg0_32.effectObj then
			setActive(arg0_32.effectObj, false)
		end

		if arg0_32.effectLineObj then
			setActive(arg0_32.effectLineObj, false)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			content = i18n("ship_lock_tip"),
			onYes = function()
				triggerButton(arg0_32._lockBtn)

				if arg1_32 then
					arg1_32()
				else
					arg0_32:emit(NewShipMediator.ON_EXIT)
				end
			end,
			onNo = function()
				if arg1_32 then
					arg1_32()
				else
					arg0_32:emit(NewShipMediator.ON_EXIT)
				end
			end
		})
	elseif arg1_32 then
		arg1_32()
	else
		arg0_32:emit(NewShipMediator.ON_EXIT)
	end
end

function var0_0.UpdateLockButton(arg0_35, arg1_35)
	setActive(arg0_35._lockBtn, arg1_35 ~= Ship.LOCK_STATE_LOCK)
	setActive(arg0_35._unlockBtn, arg1_35 ~= Ship.LOCK_STATE_UNLOCK)
end

function var0_0.updateLockTF(arg0_36, arg1_36)
	setActive(arg0_36._lockTF, not arg1_36)
end

function var0_0.didEnter(arg0_37)
	onButton(arg0_37, arg0_37._lockBtn, function()
		arg0_37:StopAutoExitTimer()
		arg0_37:emit(NewShipMediator.ON_LOCK, {
			arg0_37._shipVO.id
		}, Ship.LOCK_STATE_LOCK)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37._unlockBtn, function()
		arg0_37:StopAutoExitTimer()
		arg0_37:emit(NewShipMediator.ON_LOCK, {
			arg0_37._shipVO.id
		}, Ship.LOCK_STATE_UNLOCK)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37._viewBtn, function()
		arg0_37:StopAutoExitTimer()

		arg0_37.isInView = true

		arg0_37:paintView()
		setActive(arg0_37.clickTF, false)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37._evaluationBtn, function()
		arg0_37:StopAutoExitTimer()
		arg0_37:emit(NewShipMediator.ON_EVALIATION, arg0_37._shipVO:getGroupId())
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37._shareBtn, function()
		arg0_37:StopAutoExitTimer()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeNewShip)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37.clickTF, function()
		arg0_37:StopAutoExitTimer()

		if arg0_37.isInView or not arg0_37.isLoadBg then
			return
		end

		arg0_37:showExitTip()
	end, SFX_CANCEL)
	onButton(arg0_37, arg0_37.audioBtn, function()
		arg0_37:StopAutoExitTimer()

		if arg0_37.isInView then
			return
		end

		if not arg0_37.isOpenProperty then
			arg0_37:switch2Property()

			arg0_37.isOpenProperty = true
		end

		setActive(arg0_37.audioBtn, not arg0_37.isRemoulded and not arg0_37.isOpenProperty)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37._skipButton, function()
		arg0_37:showExitTip(function()
			arg0_37:emit(NewShipMediator.ON_SKIP_BATCH, arg0_37.contextData.skipBatchType or NewShipMediator.SKIP_TYPE.BUILD)
		end)
	end, SFX_PANEL)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_CHARGET)
	pg.SystemGuideMgr.GetInstance():Play(arg0_37)
end

function var0_0.onBackPressed(arg0_47)
	if arg0_47.inAnimating then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_47.isInView then
		arg0_47:hidePaintView(true)

		return
	end

	arg0_47:DestroyNewShipDocumentView()
	triggerButton(arg0_47.clickTF)
end

function var0_0.paintView(arg0_48)
	local var0_48 = {}
	local var1_48 = arg0_48._shake.childCount
	local var2_48 = 0

	while var2_48 < var1_48 do
		local var3_48 = arg0_48._shake:GetChild(var2_48)

		if var3_48.gameObject.activeSelf and var3_48 ~= arg0_48._paintingTF and var3_48 ~= arg0_48._bg and var3_48 ~= arg0_48._drag then
			var0_48[#var0_48 + 1] = var3_48

			setActive(var3_48, false)
		end

		var2_48 = var2_48 + 1
	end

	setActive(arg0_48._paintingShadowTF, false)
	openPortrait()

	local var4_48 = arg0_48._paintingTF
	local var5_48 = var4_48.anchoredPosition.x
	local var6_48 = var4_48.anchoredPosition.y
	local var7_48 = var4_48.rect.width
	local var8_48 = var4_48.rect.height
	local var9_48 = arg0_48._tf.rect.width / UnityEngine.Screen.width
	local var10_48 = arg0_48._tf.rect.height / UnityEngine.Screen.height
	local var11_48 = var7_48 / 2
	local var12_48 = var8_48 / 2
	local var13_48
	local var14_48

	if not LeanTween.isTweening(go(var4_48)) then
		arg0_48:AddLeanTween(function()
			return LeanTween.moveX(rtf(var4_48), 150, 0.5):setEase(LeanTweenType.easeInOutSine)
		end)
	end

	local var15_48 = GetOrAddComponent(arg0_48._drag, "MultiTouchZoom")

	var15_48:SetZoomTarget(arg0_48._paintingTF)

	local var16_48 = GetOrAddComponent(arg0_48._drag, "EventTriggerListener")

	arg0_48.dragTrigger = var16_48

	local var17_48 = true

	var15_48.enabled = true
	var16_48.enabled = true

	local var18_48 = false

	var16_48:AddPointDownFunc(function(arg0_50)
		if Input.touchCount == 1 or IsUnityEditor then
			var18_48 = true
			var17_48 = true
		elseif Input.touchCount >= 2 then
			var17_48 = false
			var18_48 = false
		end
	end)
	var16_48:AddPointUpFunc(function(arg0_51)
		if Input.touchCount <= 2 then
			var17_48 = true
		end
	end)
	var16_48:AddBeginDragFunc(function(arg0_52, arg1_52)
		var18_48 = false
		var13_48 = arg1_52.position.x * var9_48 - var11_48 - tf(arg0_48._paintingTF).localPosition.x
		var14_48 = arg1_52.position.y * var10_48 - var12_48 - tf(arg0_48._paintingTF).localPosition.y
	end)
	var16_48:AddDragFunc(function(arg0_53, arg1_53)
		if var17_48 then
			local var0_53 = tf(arg0_48._paintingTF).localPosition

			tf(arg0_48._paintingTF).localPosition = Vector3(arg1_53.position.x * var9_48 - var11_48 - var13_48, arg1_53.position.y * var10_48 - var12_48 - var14_48, -22)
		end
	end)
	onButton(arg0_48, arg0_48._drag, function()
		arg0_48:hidePaintView()
	end, SFX_CANCEL)

	function var0_0.hidePaintView(arg0_55, arg1_55)
		if not arg1_55 and not var18_48 then
			return
		end

		var16_48.enabled = false
		var15_48.enabled = false

		for iter0_55, iter1_55 in ipairs(var0_48) do
			setActive(iter1_55, true)
		end

		setActive(arg0_55._paintingShadowTF, true)
		closePortrait()
		LeanTween.cancel(go(arg0_55._paintingTF))

		arg0_55._paintingTF.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(arg0_55._paintingTF, {
			x = var5_48,
			y = var6_48
		})

		arg0_55.isInView = false

		setActive(arg0_55.clickTF, true)
	end
end

function var0_0.recyclePainting(arg0_56)
	if arg0_56._shipVO then
		retPaintingPrefab(arg0_56._paintingTF, arg0_56._shipVO:getPainting())
		retPaintingPrefab(arg0_56._paintingShadowTF, arg0_56._shipVO:getPainting())

		arg0_56._shipVO = nil
	end
end

function var0_0.starsAnimation(arg0_57)
	arg0_57.inAnimating = true

	if arg0_57._shipVO:getMaxStar() >= 6 and PlayerPrefs.GetInt(RARE_SHIP_VIBRATE, 1) > 0 then
		LuaHelper.Vibrate()
	end

	setActive(arg0_57.starsCont, false)

	local var0_57 = arg0_57._tf:GetComponent(typeof(DftAniEvent))

	var0_57:SetTriggerEvent(function(arg0_58)
		arg0_57:AddLeanTween(function()
			return LeanTween.scale(rtf(arg0_57.starsCont), Vector3.one, 0):setOnComplete(System.Action(function()
				setActive(arg0_57.starsCont, true)
			end))
		end)

		local var0_58 = arg0_57.STAR_ANIMATION_DUR1

		for iter0_58 = 0, arg0_57.starsCont.childCount - 1 do
			local var1_58 = arg0_57.starsCont:GetChild(iter0_58)
			local var2_58 = var1_58:Find("star_empty")
			local var3_58 = var1_58:Find("star")

			setActive(var2_58, false)
			setActive(var3_58, false)

			local var4_58 = iter0_58 * var0_58

			arg0_57:AddLeanTween(function()
				return LeanTween.scale(rtf(var2_58), Vector3(1.8, 1.8, 1.8), 0):setDelay(var4_58):setOnComplete(System.Action(function()
					setActive(var2_58, true)
					arg0_57:AddLeanTween(function()
						return LeanTween.scale(rtf(var2_58), Vector3(1, 1, 1), var0_58)
					end)
				end))
			end)
		end

		local var5_58 = arg0_57._shipVO:getStar()
		local var6_58 = arg0_57.STAR_ANIMATION_DUR2
		local var7_58 = arg0_57.STAR_ANIMATION_DUR3

		for iter1_58 = 0, var5_58 - 1 do
			local var8_58 = arg0_57.starsCont:GetChild(iter1_58)
			local var9_58 = var8_58:Find("star_empty")
			local var10_58 = var8_58:Find("star")
			local var11_58 = var0_58 * arg0_57.starsCont.childCount + iter1_58 * var6_58

			arg0_57:AddLeanTween(function()
				return LeanTween.scale(rtf(var10_58), Vector3(1.8, 1.8, 1.8), 0):setDelay(var11_58):setOnStart(System.Action(function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_STAR)
				end)):setOnComplete(System.Action(function()
					setActive(var9_58, false)
					setActive(var10_58, true)
					arg0_57:AddLeanTween(function()
						return LeanTween.scale(rtf(var10_58), Vector3(1, 1, 1), var6_58)
					end)
				end))
			end)

			local var12_58 = var8_58:Find("light")

			if var12_58 then
				arg0_57:AddLeanTween(function()
					return LeanTween.delayedCall(var11_58, System.Action(function()
						if arg0_57.exited then
							return
						end

						setActive(var12_58, true)
					end))
				end)
				arg0_57:AddLeanTween(function()
					return LeanTween.alpha(rtf(var12_58), 0, var7_58):setDelay(var11_58):setOnComplete(System.Action(function()
						SetActive(var12_58, false)
						LeanTween.alpha(rtf(var12_58), 1, 0)
					end))
				end)

				var12_58.transform.localScale = Vector3(1, 1, 1)

				arg0_57:AddLeanTween(function()
					return LeanTween.scale(rtf(var12_58), Vector3(0.5, 1, 1), arg0_57.STAR_ANIMATION_DUR4):setDelay(var11_58 + var7_58 * 1 / 3)
				end)
			end
		end
	end)
	var0_57:SetEndEvent(function(arg0_73)
		if arg0_57._shipVO:getReMetaSpecialItemVO() then
			GetComponent(arg0_57.metaRepeatTF, "CanvasGroup").alpha = 1

			arg0_57:managedTween(LeanTween.value, function()
				setAnchoredPosition(arg0_57.metaRepeatTF, {
					x = 0
				})

				arg0_57.inAnimating = false

				setActive(arg0_57.npc, arg0_57._shipVO:isActivityNpc())
				setActive(arg0_57._shade, false)
			end, go(arg0_57.metaRepeatTF), arg0_57.metaRepeatTF.rect.width, 0, 1):setOnUpdate(System.Action_float(function(arg0_75)
				setAnchoredPosition(arg0_57.metaRepeatTF, {
					x = arg0_75
				})
			end))
			setAnchoredPosition(arg0_57.metaRepeatTF, {
				x = arg0_57.metaRepeatTF.rect.width
			})
			setActive(arg0_57.metaRepeatTF, true)
		else
			arg0_57.inAnimating = false

			setActive(arg0_57.npc, arg0_57._shipVO:isActivityNpc())
			setActive(arg0_57._shade, false)
		end
	end)
end

function var0_0.playOpening(arg0_76, arg1_76)
	if arg0_76._shipVO:isMetaShip() and not getProxy(ContextProxy):getContextByMediator(BuildShipMediator) then
		if arg1_76 then
			arg1_76()
		end

		return
	end

	local var0_76

	if arg0_76._shipVO:isRemoulded() then
		var0_76 = ShipGroup.GetGroupConfig(arg0_76._shipVO:getGroupId()).trans_skin
	else
		var0_76 = ShipGroup.getDefaultSkin(arg0_76._shipVO:getGroupId()).id
	end

	local var1_76 = "star_level_unlock_anim_" .. var0_76

	if checkABExist("ui/skinunlockanim/" .. var1_76) then
		pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
			return
		end, function()
			if arg1_76 then
				arg1_76()
			end
		end, "ui/skinunlockanim", var1_76, true, false)
	elseif arg1_76 then
		arg1_76()
	end
end

function var0_0.ClearTweens(arg0_79, arg1_79)
	arg0_79:cleanManagedTween(true)
end

function var0_0.willExit(arg0_80)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()
	arg0_80:StopAutoExitTimer()
	arg0_80:DestroyNewShipDocumentView()

	if arg0_80.designBg then
		PoolMgr.GetInstance():ReturnUI(arg0_80.designName, arg0_80.designBg)
	end

	if arg0_80.metaBg then
		PoolMgr.GetInstance():ReturnUI(arg0_80.metaName, arg0_80.metaBg)
	end

	for iter0_80, iter1_80 in pairs(arg0_80.rarityEffect) do
		if iter1_80 then
			PoolMgr.GetInstance():ReturnUI("getrole_" .. iter0_80, iter1_80)
		end
	end

	if arg0_80.dragTrigger then
		ClearEventTrigger(arg0_80.dragTrigger)

		arg0_80.dragTrigger = nil
	end

	if not arg0_80.isRemoulded then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_newShipLayer_get", pg.ship_data_by_type[arg0_80._shipVO:getShipType()].type_name, arg0_80._shipVO:getName()), COLOR_GREEN)
	end

	arg0_80:recyclePainting()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_80._tf)
	arg0_80:stopVoice()

	if arg0_80.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_80.loadedCVBankName)

		arg0_80.loadedCVBankName = nil
	end

	if LeanTween.isTweening(go(arg0_80.rarityTF)) then
		LeanTween.cancel(go(arg0_80.rarityTF))
	end

	cameraPaintViewAdjust(false)
end

function var0_0.DisplayNewShipDocumentView(arg0_81)
	arg0_81.newShipDocumentView = NewShipDocumentView.New(arg0_81._shake:Find("ForNotch"), arg0_81.event, arg0_81.contextData)

	arg0_81.newShipDocumentView:Load()

	local function var0_81()
		if not arg0_81.isLoadBg then
			return
		end

		arg0_81:showExitTip()
	end

	arg0_81.newShipDocumentView:ActionInvoke("SetParams", arg0_81._shipVO, var0_81)
	arg0_81.newShipDocumentView:ActionInvoke("RefreshUI")
end

function var0_0.DestroyNewShipDocumentView(arg0_83)
	if arg0_83.newShipDocumentView and arg0_83.newShipDocumentView:CheckState(BaseSubView.STATES.INITED) then
		arg0_83.newShipDocumentView:Destroy()
	end
end

function var0_0.StopAutoExitTimer(arg0_84)
	if not arg0_84.autoExitTimer then
		return
	end

	arg0_84.autoExitTimer:Stop()

	arg0_84.autoExitTimer = nil
end

return var0_0
