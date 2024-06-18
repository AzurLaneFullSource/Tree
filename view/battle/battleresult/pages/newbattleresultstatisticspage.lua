local var0_0 = class("NewBattleResultStatisticsPage", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 0
local var4_0 = 1

function var0_0.getUIName(arg0_1)
	return "NewBattleResultStatisticsPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.mask = arg0_2:findTF("mask")
	arg0_2.paintingTr = arg0_2:findTF("painting")
	arg0_2.resultPaintingTr = arg0_2:findTF("result")
	arg0_2.topPanel = arg0_2:findTF("top")
	arg0_2.gradeIcon = arg0_2:findTF("top/grade/icon"):GetComponent(typeof(Image))
	arg0_2.gradeTxt = arg0_2:findTF("top/grade/Text"):GetComponent(typeof(Image))
	arg0_2.chapterName = arg0_2:findTF("top/grade/chapterName"):GetComponent(typeof(Text))
	arg0_2.opBonus = arg0_2:findTF("top/grade/operation_bonus")
	arg0_2.playerName = arg0_2:findTF("top/exp/name"):GetComponent(typeof(Text))
	arg0_2.playerLv = arg0_2:findTF("top/exp/lv"):GetComponent(typeof(Text))
	arg0_2.playerExp = arg0_2:findTF("top/exp/Text"):GetComponent(typeof(Text))
	arg0_2.playerExpLabel = arg0_2:findTF("top/exp/Text/exp_label"):GetComponent(typeof(Text))
	arg0_2.playerExpBar = arg0_2:findTF("top/exp/exp_bar/progress"):GetComponent(typeof(Image))
	arg0_2.commmanderContainer = arg0_2:findTF("top/exp/commanders")
	arg0_2.shipContainer = arg0_2:findTF("left")
	arg0_2.rawImage = arg0_2._tf:Find("bg"):GetComponent(typeof(RawImage))
	arg0_2.blackBg = arg0_2._tf:Find("black")
	arg0_2.bottomPanel = arg0_2:findTF("bottom")
	arg0_2.confrimBtn = arg0_2:findTF("bottom/confirmBtn")
	arg0_2.statisticsBtn = arg0_2:findTF("bottom/statisticsBtn")
	arg0_2.mainFleetBtn = arg0_2:findTF("bottom/mainFleetBtn")
	arg0_2.subFleetBtn = arg0_2:findTF("bottom/subFleetBtn")
	arg0_2.chatText = arg0_2:findTF("chat/Text"):GetComponent(typeof(Text))

	setText(arg0_2.confrimBtn:Find("Text"), i18n("msgbox_text_confirm"))

	arg0_2.cg = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))
	arg0_2.commaderTpls = {}
	arg0_2.emptyTpls = {
		arg0_2:findTF("top/exp/emptycomanders/1"),
		arg0_2:findTF("top/exp/emptycomanders/2")
	}

	setText(arg0_2.emptyTpls[1]:Find("Text"), i18n("series_enemy_empty_commander_main"))
	setText(arg0_2.emptyTpls[2]:Find("Text"), i18n("series_enemy_empty_commander_assistant"))

	arg0_2.surfaceShipTpls = {}
	arg0_2.subShipTpls = {}
	arg0_2.animationFlags = {
		[var1_0] = {
			[var3_0] = false,
			[var4_0] = false
		},
		[var2_0] = {
			[var3_0] = false,
			[var4_0] = false
		}
	}
	arg0_2.animation = NewBattleResultAnimation.New(arg0_2._tf)
end

function var0_0.OnInit(arg0_3)
	arg0_3.teamType = var1_0
	arg0_3.displayMode = var3_0
end

function var0_0.SetUp(arg0_4, arg1_4, arg2_4)
	seriesAsync({
		function(arg0_5)
			arg0_4.cg.alpha = 0

			arg0_4:UpdatePainting(arg0_5)
			arg0_4:UpdateGrade()
			arg0_4:UpdateChapterName()
			arg0_4:UpdateSwitchBtn()
			arg0_4:UpdatePlayer()
		end,
		function(arg0_6)
			arg0_4:LoadBG(arg0_6)
		end,
		function(arg0_7)
			arg0_4.cg.alpha = 1

			arg0_4:PlayEnterAnimation(arg0_7)
		end,
		function(arg0_8)
			if arg2_4 then
				arg2_4()
			end

			arg0_4:InitMainView(arg0_8)
		end
	}, function()
		arg0_4:UpdateMetaBtn()
		arg0_4:RegisterEvent(arg1_4)
	end)
end

function var0_0.InitMainView(arg0_10, arg1_10)
	arg0_10.isEnter = true

	parallelAsync({
		function(arg0_11)
			arg0_10:UpdateCommanders(arg0_11)
		end,
		function(arg0_12)
			arg0_10:StartEnterAnimation(arg0_12)
		end,
		function(arg0_13)
			arg0_10:InitShips(arg0_13)
		end
	}, arg1_10)
end

function var0_0.PlayEnterAnimation(arg0_14, arg1_14)
	if not getProxy(SettingsProxy):IsDisplayResultPainting() then
		arg1_14()
		Object.Destroy(arg0_14.rawImage.gameObject)

		return
	end

	local var0_14 = pg.UIMgr.GetInstance().uiCamera.gameObject.transform:Find("Canvas")

	arg0_14.rawImage.texture = pg.UIMgr.GetInstance():GetStaticRtt(pg.UIMgr.CameraUI)
	rtf(arg0_14.rawImage.gameObject).sizeDelta = var0_14.sizeDelta
	arg0_14.blackBg.sizeDelta = var0_14.sizeDelta

	if arg0_14.effectTr then
		arg0_14.effectTr.anchorMax = Vector2(0.5, 0.5)
		arg0_14.effectTr.anchorMin = Vector2(0.5, 0.5)

		local var1_14 = GameObject.Find("UICamera/Canvas").transform

		arg0_14.effectTr.sizeDelta = var1_14.sizeDelta
	end

	setAnchoredPosition(arg0_14.topPanel, {
		y = 320
	})
	setAnchoredPosition(arg0_14.bottomPanel, {
		y = -320
	})

	local var2_14 = arg0_14:GetPaintingPosition()

	arg0_14.mask.localPosition = var2_14

	if arg0_14.animation then
		arg0_14.animation:Play(arg0_14.resultPaintingData, function()
			arg0_14.rawImage.texture = nil

			Object.Destroy(arg0_14.rawImage.gameObject)
			arg1_14()
		end)
	end
end

function var0_0.LoadBG(arg0_16, arg1_16)
	local var0_16 = arg0_16._parentTf:Find("Effect")

	if not IsNil(var0_16) then
		setParent(var0_16, arg0_16._tf)
		var0_16:SetSiblingIndex(2)

		arg0_16.effectTr = var0_16

		arg1_16()
	else
		local var1_16 = NewBattleResultUtil.Score2Bg(arg0_16.contextData.score)

		ResourceMgr.Inst:getAssetAsync("BattleResultItems/" .. var1_16, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_17)
			if arg0_16.exited or IsNil(arg0_17) then
				if arg1_16 then
					arg1_16()
				end

				return
			end

			local var0_17 = Object.Instantiate(arg0_17, arg0_16._tf)

			var0_17.transform:SetSiblingIndex(2)

			arg0_16.effectTr = var0_17.transform

			if arg1_16 then
				arg1_16()
			end
		end), true, true)
	end
end

function var0_0.RegisterEvent(arg0_18, arg1_18)
	onButton(arg0_18, arg0_18.mainFleetBtn, function()
		arg0_18.teamType = var1_0

		arg0_18:UpdateShips(false)
		arg0_18:UpdateCommanders(function()
			return
		end)
		arg0_18:UpdateSwitchBtn()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.subFleetBtn, function()
		arg0_18.teamType = var2_0

		arg0_18:UpdateShips(false)
		arg0_18:UpdateCommanders(function()
			return
		end)
		arg0_18:UpdateSwitchBtn()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.statisticsBtn, function()
		arg0_18.displayMode = 1 - arg0_18.displayMode

		arg0_18:UpdateShipDetail()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.confrimBtn, function()
		arg1_18()
	end, SFX_PANEL)

	if arg0_18.contextData.autoSkipFlag then
		onNextTick(function()
			triggerButton(arg0_18.confrimBtn)
		end)
	end
end

local function var5_0(arg0_26, arg1_26)
	onButton(arg0_26, arg1_26, function()
		setActive(arg1_26, false)

		if arg0_26.metaExpView then
			return
		end

		arg0_26.metaExpView = BattleResultMetaExpView.New(arg0_26._tf, arg0_26.event, arg0_26.contextData)

		arg0_26.metaExpView:Reset()
		arg0_26.metaExpView:Load()

		local var0_27 = getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList()

		arg0_26.metaExpView:setData(var0_27, function()
			if arg1_26 then
				setActive(arg1_26, true)
			end

			arg0_26.metaExpView = nil
		end)
		arg0_26.metaExpView:ActionInvoke("Show")
		arg0_26.metaExpView:ActionInvoke("openPanel")
	end, SFX_PANEL)
end

function var0_0.UpdateMetaBtn(arg0_29)
	local var0_29 = getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList()

	if var0_29 and #var0_29 > 0 then
		ResourceMgr.Inst:getAssetAsync("BattleResultItems/MetaBtn", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_30)
			if arg0_29.exited or IsNil(arg0_30) then
				return
			end

			local var0_30 = Object.Instantiate(arg0_30, arg0_29._tf)

			var5_0(arg0_29, var0_30.transform)
		end), true, true)
	end
end

function var0_0.StartEnterAnimation(arg0_31, arg1_31)
	LeanTween.value(arg0_31.topPanel.gameObject, 320, 0, 0.2):setOnUpdate(System.Action_float(function(arg0_32)
		setAnchoredPosition(arg0_31.topPanel, {
			y = arg0_32
		})
	end))
	LeanTween.value(arg0_31.bottomPanel.gameObject, -320, 0, 0.2):setOnUpdate(System.Action_float(function(arg0_33)
		setAnchoredPosition(arg0_31.bottomPanel, {
			y = arg0_33
		})
	end)):setOnComplete(System.Action(arg1_31))
end

function var0_0.GetShipSlotExpandPosition(arg0_34, arg1_34)
	local var0_34 = arg0_34:GetShipSlotShrinkPosition(arg1_34)

	return Vector2(1300, var0_34.y)
end

function var0_0.GetShipSlotShrinkPosition(arg0_35, arg1_35)
	return Vector2(500, 250) + (arg1_35 - 1) * Vector2(69.55, -117.7)
end

local function var6_0(arg0_36, arg1_36, arg2_36)
	local var0_36 = ""
	local var1_36 = arg0_36 and arg0_36[arg2_36]

	if arg1_36 or var1_36 then
		var0_36 = arg1_36 and arg1_36:getConfig("name") or var1_36 and i18n("Word_Ship_Exp_Buff")
	end

	return var0_36
end

function var0_0.GetAnimationFlag(arg0_37)
	if arg0_37.contextData.autoSkipFlag then
		return false
	end

	local var0_37 = arg0_37.animationFlags[arg0_37.teamType][arg0_37.displayMode]

	if var0_37 == false then
		arg0_37.animationFlags[arg0_37.teamType][arg0_37.displayMode] = true
	end

	return not var0_37
end

function var0_0.UpdateShipDetail(arg0_38)
	local var0_38 = arg0_38.teamType == var1_0
	local var1_38 = var0_38 and arg0_38.surfaceShipTpls or arg0_38.subShipTpls
	local var2_38, var3_38 = NewBattleResultUtil.SeparateSurfaceAndSubShips(arg0_38.contextData.oldMainShips)
	local var4_38 = var0_38 and var2_38 or var3_38
	local var5_38 = arg0_38.displayMode == var3_0
	local var6_38 = arg0_38.contextData.expBuff
	local var7_38 = arg0_38.contextData.buffShips
	local var8_38 = NewBattleResultUtil.GetMaxOutput(arg0_38.contextData.oldMainShips, arg0_38.contextData.statistics)

	arg0_38.numeberAnimations = {}

	local var9_38 = arg0_38:GetAnimationFlag()

	for iter0_38, iter1_38 in ipairs(var4_38) do
		local var10_38 = arg0_38.contextData.statistics[iter1_38.id] or {}
		local var11_38 = var1_38[iter0_38]
		local var12_38 = arg0_38.contextData.newMainShips[iter1_38.id]

		local function var13_38()
			setText(var11_38:Find("atk"), not var5_38 and (var10_38.output or 0) or "EXP" .. "<color=#FFDE38>+" .. NewBattleResultUtil.GetShipExpOffset(iter1_38, var12_38) .. "</color>")
			setText(var11_38:Find("killCount"), not var5_38 and (var10_38.kill_count or 0) or "Lv." .. var12_38.level)

			var11_38:Find("dmg/bar"):GetComponent(typeof(Image)).fillAmount = not var5_38 and (var10_38.output or 0) / var8_38 or var12_38:getExp() / getExpByRarityFromLv1(var12_38:getConfig("rarity"), var12_38.level)
		end

		if var9_38 then
			local var14_38 = NewBattleResultShipCardAnimation.New(var11_38, var5_38, iter1_38, var12_38, var10_38, var8_38)

			var14_38:SetUp(var13_38)
			table.insert(arg0_38.numeberAnimations, var14_38)
		else
			var13_38()
		end

		setText(var11_38:Find("kill_count_label"), not var5_38 and i18n("battle_result_kill_count") or iter1_38:getName())
		setText(var11_38:Find("dmg_count_label"), not var5_38 and i18n("battle_result_dmg") or var6_0(var7_38, var6_38, iter1_38:getGroupId()) or "")
	end
end

local function var7_0(arg0_40, arg1_40)
	local var0_40 = arg1_40:Find("MVP")

	if IsNil(var0_40) then
		ResourceMgr.Inst:getAssetAsync("BattleResultItems/MVP", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_41)
			if arg0_40.exited or IsNil(arg0_41) then
				return
			end

			Object.Instantiate(arg0_41, arg1_40).name = "MVP"
		end), true, true)
	end

	local var1_40 = arg1_40:Find("MVPBG")

	if IsNil(var1_40) then
		ResourceMgr.Inst:getAssetAsync("BattleResultItems/MVPBG", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_42)
			if arg0_40.exited or IsNil(arg0_42) then
				return
			end

			local var0_42 = Object.Instantiate(arg0_42, arg1_40)

			var0_42.name = "MVPBG"

			var0_42.transform:SetAsFirstSibling()
		end), true, true)
	end
end

local function var8_0(arg0_43, arg1_43)
	local var0_43 = arg1_43:Find("LevelUp")

	if IsNil(var0_43) then
		ResourceMgr.Inst:getAssetAsync("BattleResultItems/LevelUp", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_44)
			if arg0_43.exited or IsNil(arg0_44) then
				return
			end

			Object.Instantiate(arg0_44, arg1_43).name = "LevelUp"
		end), true, true)
	end
end

local function var9_0(arg0_45, arg1_45)
	local var0_45 = arg1_45:Find("Intmacy")

	if IsNil(var0_45) then
		ResourceMgr.Inst:getAssetAsync("ui/zhandoujiesuan_xingxing", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_46)
			if arg0_45.exited or IsNil(arg0_46) then
				return
			end

			Object.Instantiate(arg0_46, arg1_45).name = "Intmacy"
		end), true, true)
	end
end

local function var10_0(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47, arg5_47)
	local var0_47 = arg1_47:Find("mask/icon"):GetComponent(typeof(Image))

	var0_47.sprite = LoadSprite("herohrzicon/" .. arg2_47:getPainting())
	var0_47.gameObject.transform.sizeDelta = Vector2(432, 96)

	setImageSprite(arg1_47:Find("type"), GetSpriteFromAtlas("shiptype", shipType2print(arg2_47:getShipType())), true)

	local var1_47 = arg2_47:getStar()
	local var2_47 = arg2_47:getMaxStar()
	local var3_47 = UIItemList.New(arg1_47:Find("stars"), arg1_47:Find("stars/star_tpl"))
	local var4_47 = var2_47 - var1_47

	var3_47:make(function(arg0_48, arg1_48, arg2_48)
		if arg0_48 == UIItemList.EventUpdate then
			local var0_48 = arg1_48 + 1 <= var4_47

			SetActive(arg2_48:Find("empty"), var0_48)
			SetActive(arg2_48:Find("star"), not var0_48)
		end
	end)
	var3_47:align(var2_47)

	if arg3_47 then
		var7_0(arg0_47, arg1_47)
	end

	if arg4_47 then
		var8_0(arg0_47, arg1_47)
	end

	if arg5_47 then
		onDelayTick(function()
			if arg0_47.exited then
				return
			end

			var9_0(arg0_47, arg1_47)
		end, 1)
	end
end

function var0_0.InitShips(arg0_50, arg1_50)
	arg0_50:UpdateShips(true, arg1_50)
end

function var0_0.UpdateShips(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg0_51.teamType == var1_0 and arg0_51.surfaceShipTpls or arg0_51.subShipTpls
	local var1_51 = arg0_51.teamType == var1_0 and arg0_51.subShipTpls or arg0_51.surfaceShipTpls
	local var2_51, var3_51 = NewBattleResultUtil.SeparateSurfaceAndSubShips(arg0_51.contextData.oldMainShips)
	local var4_51 = arg0_51.teamType == var1_0 and var2_51 or var3_51

	local function var5_51()
		for iter0_52, iter1_52 in ipairs(var4_51) do
			local var0_52 = var0_51[iter0_52]

			var0_52:GetComponent(typeof(CanvasGroup)).alpha = 1
			var0_52.anchoredPosition = arg0_51:GetShipSlotExpandPosition(iter0_52)

			local var1_52 = arg0_51.contextData.newMainShips[iter1_52.id]

			var10_0(arg0_51, var0_52, iter1_52, arg0_51.contextData.statistics.mvpShipID and arg0_51.contextData.statistics.mvpShipID == iter1_52.id, var1_52.level > iter1_52.level, var1_52:getIntimacy() > iter1_52:getIntimacy())
		end

		arg0_51:UpdateShipDetail()
		arg0_51:StartShipsEnterAnimation(var0_51, arg1_51 and 0.6 or 0, arg2_51)
	end

	arg0_51:LoadShipTpls(var0_51, var4_51, var5_51)

	for iter0_51, iter1_51 in ipairs(var1_51) do
		iter1_51:GetComponent(typeof(CanvasGroup)).alpha = 0
	end
end

function var0_0.LoadShipTpls(arg0_53, arg1_53, arg2_53, arg3_53)
	local var0_53 = {}

	for iter0_53 = #arg1_53 + 1, #arg2_53 do
		table.insert(var0_53, function(arg0_54)
			local var0_54 = iter0_53 == #arg2_53

			ResourceMgr.Inst:getAssetAsync("BattleResultItems/Ship", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_55)
				if arg0_53.exited or IsNil(arg0_55) then
					arg0_54()

					return
				end

				local var0_55 = Object.Instantiate(arg0_55, arg0_53.shipContainer).transform

				var0_55:GetComponent(typeof(CanvasGroup)).alpha = 0

				table.insert(arg1_53, var0_55)
				arg0_54()
			end), var0_54, var0_54)
		end)
	end

	seriesAsync(var0_53, arg3_53)
end

function var0_0.StartShipsEnterAnimation(arg0_56, arg1_56, arg2_56, arg3_56)
	if arg2_56 <= 0 then
		for iter0_56, iter1_56 in ipairs(arg1_56) do
			iter1_56.anchoredPosition = arg0_56:GetShipSlotShrinkPosition(iter0_56)
		end

		return
	end

	local var0_56 = {}

	for iter2_56, iter3_56 in ipairs(arg1_56) do
		local var1_56 = iter3_56:GetComponent(typeof(CanvasGroup))

		var1_56.alpha = 0

		local var2_56 = arg0_56:GetShipSlotExpandPosition(iter2_56)
		local var3_56 = arg0_56:GetShipSlotShrinkPosition(iter2_56)

		table.insert(var0_56, function(arg0_57)
			if arg0_56.exited then
				return
			end

			var1_56.alpha = 1

			LeanTween.value(iter3_56.gameObject, var2_56.x, var3_56.x, arg2_56 - (iter2_56 - 1) * 0.1):setOnUpdate(System.Action_float(function(arg0_58)
				iter3_56.anchoredPosition = Vector3(arg0_58, iter3_56.anchoredPosition.y, 0)
			end))
			onDelayTick(arg0_57, 0.1)
		end)
	end

	seriesAsync(var0_56, arg3_56)
end

function var0_0.UpdateSwitchBtn(arg0_59)
	local var0_59 = NewBattleResultUtil.HasSubShip(arg0_59.contextData.oldMainShips)
	local var1_59 = NewBattleResultUtil.HasSurfaceShip(arg0_59.contextData.oldMainShips)

	setActive(arg0_59.mainFleetBtn, arg0_59.teamType == var2_0 and var1_59 and var0_59)
	setActive(arg0_59.subFleetBtn, arg0_59.teamType == var1_0 and var1_59 and var0_59)

	if not var1_59 then
		arg0_59.teamType = var2_0
	end
end

function var0_0.UpdateMvpPainting(arg0_60, arg1_60)
	local var0_60 = arg0_60.contextData.oldMainShips
	local var1_60, var2_60, var3_60, var4_60 = NewBattleResultUtil.SeparateMvpShip(var0_60, arg0_60.contextData.statistics.mvpShipID, arg0_60.contextData.statistics._flagShipID)

	var4_60 = var4_60 or var0_60[#var0_60 - 1]

	local var5_60 = arg0_60.resultPaintingTr
	local var6_60 = var4_60:getPainting()

	setPaintingPrefabAsync(var5_60, var6_60, "jiesuan", function()
		ShipExpressionHelper.SetExpression(findTF(var5_60, "fitter"):GetChild(0), var6_60, ShipWordHelper.WORD_TYPE_MVP, var4_60:getCVIntimacy())
		arg0_60:RecordPainting(arg1_60)
	end)
	arg0_60:DisplayShipDialogue(var4_60)
end

function var0_0.RecordPainting(arg0_62, arg1_62)
	onNextTick(function()
		local var0_63 = arg0_62.resultPaintingTr:Find("fitter"):GetChild(0)

		if not IsNil(var0_63) then
			arg0_62.resultPaintingData = {
				position = Vector2(var0_63.position.x, var0_63.position.y),
				pivot = rtf(var0_63).pivot,
				scale = Vector2(var0_63.localScale.x, var0_63.localScale.y)
			}

			SetParent(var0_63, arg0_62.paintingTr:Find("painting/fitter"), true)
		end

		arg1_62()
	end)
end

function var0_0.UpdateFailedPainting(arg0_64, arg1_64)
	local var0_64 = arg0_64.contextData.oldMainShips

	ResourceMgr.Inst:getAssetAsync("BattleResultItems/FailedPainting", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_65)
		if arg0_64.exited or IsNil(arg0_65) then
			arg1_64()

			return
		end

		Object.Instantiate(arg0_65, arg0_64.paintingTr).transform:SetAsFirstSibling()
		arg1_64()
	end), true, true)
	arg0_64:DisplayShipDialogue(var0_64[math.random(#var0_64)])
end

function var0_0.GetPaintingPosition(arg0_66)
	local var0_66 = arg0_66.contextData.oldMainShips

	return (NewBattleResultDisplayPaintingsPage.StaticGetFinalExpandPosition(#var0_66))
end

function var0_0.UpdatePaintingPosition(arg0_67)
	local var0_67 = arg0_67:GetPaintingPosition()

	arg0_67.paintingTr.localPosition = var0_67
end

function var0_0.UpdatePainting(arg0_68, arg1_68)
	arg0_68:UpdatePaintingPosition()

	if arg0_68.contextData.score > 1 then
		arg0_68:UpdateMvpPainting(arg1_68)
	else
		arg0_68:UpdateFailedPainting(arg1_68)
	end
end

function var0_0.DisplayShipDialogue(arg0_69, arg1_69)
	local var0_69
	local var1_69
	local var2_69

	if arg0_69.contextData.score > 1 then
		local var3_69, var4_69

		var3_69, var4_69, var1_69 = ShipWordHelper.GetWordAndCV(arg1_69.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, arg1_69:getCVIntimacy())
	else
		local var5_69, var6_69

		var5_69, var6_69, var1_69 = ShipWordHelper.GetWordAndCV(arg1_69.skinId, ShipWordHelper.WORD_TYPE_LOSE, nil, nil, arg1_69:getCVIntimacy())
	end

	arg0_69.chatText.text = var1_69
	arg0_69.chatText.alignment = #var1_69 > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter

	arg0_69:PlayMvpShipVoice()
end

function var0_0.PlayMvpShipVoice(arg0_70)
	if not arg0_70.contextData.statistics.mvpShipID or type(arg0_70.contextData.statistics.mvpShipID) == "number" and arg0_70.contextData.statistics.mvpShipID <= 0 then
		return
	end

	local var0_70 = _.detect(arg0_70.contextData.oldMainShips, function(arg0_71)
		return arg0_71.id == arg0_70.contextData.statistics.mvpShipID
	end)

	assert(var0_70)

	local var1_70
	local var2_70
	local var3_70

	if arg0_70.contextData.score > 1 then
		local var4_70, var5_70

		var4_70, var3_70, var5_70 = ShipWordHelper.GetWordAndCV(var0_70.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, var0_70:getCVIntimacy())
	else
		local var6_70, var7_70

		var6_70, var3_70, var7_70 = ShipWordHelper.GetWordAndCV(var0_70.skinId, ShipWordHelper.WORD_TYPE_LOSE)
	end

	if var3_70 then
		arg0_70:StopVoice()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_70, function(arg0_72)
			arg0_70._currentVoice = arg0_72
		end)
	end
end

function var0_0.StopVoice(arg0_73)
	if arg0_73._currentVoice then
		arg0_73._currentVoice:PlaybackStop()

		arg0_73._currentVoice = nil
	end
end

function var0_0.UpdateGrade(arg0_74)
	local var0_74, var1_74 = NewBattleResultUtil.Score2Grade(arg0_74.contextData.score, arg0_74.contextData._scoreMark)

	LoadImageSpriteAsync(var0_74, arg0_74.gradeIcon, false)
	LoadImageSpriteAsync(var1_74, arg0_74.gradeTxt, false)
end

function var0_0.UpdateChapterName(arg0_75)
	local var0_75 = NewBattleResultUtil.GetChapterName(arg0_75.contextData)

	arg0_75.chapterName.text = var0_75

	setActive(arg0_75.opBonus, NewBattleResultUtil.IsOpBonus(arg0_75.contextData.extraBuffList))
end

function var0_0.UpdatePlayer(arg0_76)
	local var0_76 = arg0_76.contextData.oldPlayer
	local var1_76 = getProxy(PlayerProxy):getRawData()

	arg0_76.playerName.text = var1_76:GetName()

	local function var2_76()
		arg0_76.playerLv.text = "Lv." .. var1_76.level

		local var0_77 = NewBattleResultUtil.GetPlayerExpOffset(var0_76, var1_76)

		arg0_76.playerExp.text = "+" .. var0_77
		arg0_76.playerExpLabel.text = "EXP"
		arg0_76.playerExpBar.fillAmount = var1_76.level == var1_76:getMaxLevel() and 1 or var1_76.exp / getConfigFromLevel1(pg.user_level, var1_76.level).exp_interval
	end

	if not arg0_76.contextData.autoSkipFlag then
		local var3_76 = NewBattleResultPlayerAniamtion.New(arg0_76.playerLv, arg0_76.playerExp, arg0_76.playerExpBar, var1_76, var0_76)

		var3_76:SetUp(var2_76)

		arg0_76.playerAniamtion = var3_76
	else
		var2_76()
	end
end

local function var11_0(arg0_78, arg1_78, arg2_78)
	GetImageSpriteFromAtlasAsync("commandericon/" .. arg2_78:getPainting(), "", arg0_78:Find("icon"))
	setText(arg0_78:Find("name_text"), arg2_78:getName())
	setText(arg0_78:Find("lv_text"), "Lv." .. arg2_78.level)
	setText(arg0_78:Find("exp"), "+" .. arg1_78.exp)

	local var0_78 = arg2_78:isMaxLevel() and 1 or arg1_78.curExp / arg2_78:getNextLevelExp()

	arg0_78:Find("exp_bar/progress"):GetComponent(typeof(Image)).fillAmount = var0_78
end

function var0_0.UpdateCommanders(arg0_79, arg1_79)
	local var0_79 = arg0_79.teamType
	local var1_79 = arg0_79.contextData.commanderExps or {}
	local var2_79 = var0_79 == var1_0 and var1_79.surfaceCMD or var1_79.submarineCMD

	var2_79 = var2_79 or {}

	local function var3_79()
		for iter0_80 = 1, #var2_79 do
			local var0_80 = getProxy(CommanderProxy):getCommanderById(var2_79[iter0_80].commander_id)

			setActive(arg0_79.commaderTpls[iter0_80], true)
			var11_0(arg0_79.commaderTpls[iter0_80], var2_79[iter0_80], var0_80)
		end

		for iter1_80 = #arg0_79.commaderTpls, #var2_79 + 1, -1 do
			setActive(arg0_79.commaderTpls[iter1_80], false)
		end
	end

	for iter0_79 = 1, #arg0_79.emptyTpls do
		setActive(arg0_79.emptyTpls[iter0_79], var2_79[iter0_79] == nil)
	end

	arg0_79:LoadCommanderTpls(#var2_79, var3_79)
	arg1_79()
end

function var0_0.LoadCommanderTpls(arg0_81, arg1_81, arg2_81)
	local var0_81 = {}

	for iter0_81 = #arg0_81.commaderTpls + 1, arg1_81 do
		table.insert(var0_81, function(arg0_82)
			local var0_82 = iter0_81 == arg1_81

			ResourceMgr.Inst:getAssetAsync("BattleResultItems/Commander", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_83)
				if arg0_81.exited or IsNil(arg0_83) then
					arg0_82()

					return
				end

				table.insert(arg0_81.commaderTpls, Object.Instantiate(arg0_83, arg0_81.commmanderContainer).transform)
				arg0_82()
			end), var0_82, var0_82)
		end)
	end

	parallelAsync(var0_81, arg2_81)
end

function var0_0.onBackPressed(arg0_84)
	if arg0_84.metaExpView then
		arg0_84.metaExpView:closePanel()

		arg0_84.metaExpView = nil

		return true
	end

	return false
end

function var0_0.OnDestroy(arg0_85)
	arg0_85.exited = true

	if arg0_85.metaExpView then
		arg0_85.metaExpView:Destroy()

		arg0_85.metaExpView = nil
	end

	if arg0_85:isShowing() then
		arg0_85:Hide()
	end

	if arg0_85.animation then
		arg0_85.animation:Dispose()
	end

	arg0_85.animation = nil

	if LeanTween.isTweening(arg0_85.topPanel.gameObject) then
		LeanTween.cancel(arg0_85.topPanel.gameObject)
	end

	if LeanTween.isTweening(arg0_85.bottomPanel.gameObject) then
		LeanTween.cancel(arg0_85.bottomPanel.gameObject)
	end

	if arg0_85.surfaceShipTpls then
		for iter0_85, iter1_85 in ipairs(arg0_85.surfaceShipTpls) do
			if LeanTween.isTweening(iter1_85.gameObject) then
				LeanTween.cancel(iter1_85.gameObject)
			end
		end
	end

	if arg0_85.subShipTpls then
		for iter2_85, iter3_85 in ipairs(arg0_85.subShipTpls) do
			if LeanTween.isTweening(iter3_85.gameObject) then
				LeanTween.cancel(iter3_85.gameObject)
			end
		end
	end

	if arg0_85.numeberAnimations then
		for iter4_85, iter5_85 in ipairs(arg0_85.numeberAnimations) do
			iter5_85:Dispose()
		end
	end

	if arg0_85.playerAniamtion then
		arg0_85.playerAniamtion:Dispose()

		arg0_85.playerAniamtion = nil
	end
end

return var0_0
