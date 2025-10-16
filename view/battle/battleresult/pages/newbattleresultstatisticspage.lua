local var0_0 = class("NewBattleResultStatisticsPage", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 0
local var4_0 = 1

function var0_0.getUIName(arg0_1)
	return "NewBattleResultStatisticsPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.mask = arg0_2._tf:Find("mask")
	arg0_2.paintingTr = arg0_2._tf:Find("painting")
	arg0_2.resultPaintingTr = arg0_2._tf:Find("result")
	arg0_2.topPanel = arg0_2._tf:Find("top")
	arg0_2.gradeIcon = arg0_2._tf:Find("top/grade/icon"):GetComponent(typeof(Image))
	arg0_2.gradeTxt = arg0_2._tf:Find("top/grade/Text"):GetComponent(typeof(Image))
	arg0_2.chapterName = arg0_2._tf:Find("top/grade/chapterName"):GetComponent(typeof(Text))
	arg0_2.opBonus = arg0_2._tf:Find("top/grade/operation_bonus")
	arg0_2.playerName = arg0_2._tf:Find("top/exp/name"):GetComponent(typeof(Text))
	arg0_2.playerLv = arg0_2._tf:Find("top/exp/lv"):GetComponent(typeof(Text))
	arg0_2.playerExp = arg0_2._tf:Find("top/exp/Text"):GetComponent(typeof(Text))
	arg0_2.playerExpLabel = arg0_2._tf:Find("top/exp/Text/exp_label"):GetComponent(typeof(Text))
	arg0_2.playerExpBar = arg0_2._tf:Find("top/exp/exp_bar/progress"):GetComponent(typeof(Image))
	arg0_2.commmanderContainer = arg0_2._tf:Find("top/exp/commanders")
	arg0_2.shipContainer = arg0_2._tf:Find("left")
	arg0_2.rawImage = arg0_2._tf:Find("bg"):GetComponent(typeof(RawImage))

	setActive(arg0_2.rawImage, false)

	arg0_2.blackBg = arg0_2._tf:Find("black")
	arg0_2.bottomPanel = arg0_2._tf:Find("bottom")
	arg0_2.confrimBtn = arg0_2._tf:Find("bottom/confirmBtn")
	arg0_2.statisticsBtn = arg0_2._tf:Find("bottom/statisticsBtn")
	arg0_2.mainFleetBtn = arg0_2._tf:Find("bottom/mainFleetBtn")
	arg0_2.subFleetBtn = arg0_2._tf:Find("bottom/subFleetBtn")
	arg0_2.chatText = arg0_2._tf:Find("chat/Text"):GetComponent(typeof(Text))

	setText(arg0_2.confrimBtn:Find("Text"), i18n("msgbox_text_confirm"))

	arg0_2.cg = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))
	arg0_2.commaderTpls = {}
	arg0_2.emptyTpls = {
		arg0_2._tf:Find("top/exp/emptycomanders/1"),
		arg0_2._tf:Find("top/exp/emptycomanders/2")
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
		if arg0_14.resultPaintingData == nil then
			arg1_14()

			return
		end

		arg0_14.animation:ZoomPainting(arg0_14.resultPaintingData, arg1_14)

		return
	end

	local var0_14 = pg.UIMgr.GetInstance().uiCamera.gameObject.transform:Find("Canvas")

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
		arg0_14.animation:Play(arg0_14.resultPaintingData, arg1_14)
	end
end

function var0_0.LoadBG(arg0_15, arg1_15)
	local var0_15 = arg0_15._parentTf:Find("Effect")

	if not IsNil(var0_15) then
		setParent(var0_15, arg0_15._tf)
		var0_15:SetSiblingIndex(2)

		arg0_15.effectTr = var0_15

		arg1_15()
	else
		local var1_15 = NewBattleResultUtil.Score2Bg(arg0_15.contextData.score)

		LoadAnyAsync("BattleResultItems/" .. var1_15, "", nil, function(arg0_16)
			if arg0_15.exited or IsNil(arg0_16) then
				if arg1_15 then
					arg1_15()
				end

				return
			end

			local var0_16 = Object.Instantiate(arg0_16, arg0_15._tf)

			var0_16.transform:SetSiblingIndex(2)

			arg0_15.effectTr = var0_16.transform

			if arg1_15 then
				arg1_15()
			end
		end)
	end
end

function var0_0.RegisterEvent(arg0_17, arg1_17)
	onButton(arg0_17, arg0_17.mainFleetBtn, function()
		arg0_17.teamType = var1_0

		arg0_17:UpdateShips(false)
		arg0_17:UpdateCommanders(function()
			return
		end)
		arg0_17:UpdateSwitchBtn()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.subFleetBtn, function()
		arg0_17.teamType = var2_0

		arg0_17:UpdateShips(false)
		arg0_17:UpdateCommanders(function()
			return
		end)
		arg0_17:UpdateSwitchBtn()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.statisticsBtn, function()
		arg0_17.displayMode = 1 - arg0_17.displayMode

		arg0_17:UpdateShipDetail()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.confrimBtn, function()
		arg1_17()
	end, SFX_PANEL)

	if arg0_17.contextData.autoSkipFlag then
		onNextTick(function()
			triggerButton(arg0_17.confrimBtn)
		end)
	end
end

local function var5_0(arg0_25, arg1_25)
	onButton(arg0_25, arg1_25, function()
		setActive(arg1_25, false)

		if arg0_25.metaExpView then
			return
		end

		arg0_25.metaExpView = BattleResultMetaExpView.New(arg0_25._tf, arg0_25.event, arg0_25.contextData)

		local var0_26 = getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList()

		arg0_25.metaExpView:setData(var0_26, function()
			if arg1_25 then
				setActive(arg1_25, true)
			end

			arg0_25.metaExpView = nil
		end)
		arg0_25.metaExpView:Reset()
		arg0_25.metaExpView:Load()
		arg0_25.metaExpView:ActionInvoke("Show")
		arg0_25.metaExpView:ActionInvoke("openPanel")
	end, SFX_PANEL)
end

function var0_0.UpdateMetaBtn(arg0_28)
	local var0_28 = getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList()

	if var0_28 and #var0_28 > 0 then
		LoadAnyAsync("BattleResultItems/MetaBtn", "", nil, function(arg0_29)
			if arg0_28.exited or IsNil(arg0_29) then
				return
			end

			local var0_29 = Object.Instantiate(arg0_29, arg0_28._tf)

			var5_0(arg0_28, var0_29.transform)
		end)
	end
end

function var0_0.StartEnterAnimation(arg0_30, arg1_30)
	LeanTween.value(arg0_30.topPanel.gameObject, 320, 0, 0.2):setOnUpdate(System.Action_float(function(arg0_31)
		setAnchoredPosition(arg0_30.topPanel, {
			y = arg0_31
		})
	end))
	LeanTween.value(arg0_30.bottomPanel.gameObject, -320, 0, 0.2):setOnUpdate(System.Action_float(function(arg0_32)
		setAnchoredPosition(arg0_30.bottomPanel, {
			y = arg0_32
		})
	end)):setOnComplete(System.Action(arg1_30))
end

function var0_0.GetShipSlotExpandPosition(arg0_33, arg1_33)
	local var0_33 = arg0_33:GetShipSlotShrinkPosition(arg1_33)

	return Vector2(1300, var0_33.y)
end

function var0_0.GetShipSlotShrinkPosition(arg0_34, arg1_34)
	return Vector2(500, 250) + (arg1_34 - 1) * Vector2(69.55, -117.7)
end

local function var6_0(arg0_35, arg1_35, arg2_35)
	local var0_35 = ""
	local var1_35 = arg0_35 and arg0_35[arg2_35]

	if arg1_35 or var1_35 then
		var0_35 = arg1_35 and arg1_35:getConfig("name") or var1_35 and i18n("Word_Ship_Exp_Buff")
	end

	return var0_35
end

function var0_0.GetAnimationFlag(arg0_36)
	if arg0_36.contextData.autoSkipFlag then
		return false
	end

	local var0_36 = arg0_36.animationFlags[arg0_36.teamType][arg0_36.displayMode]

	if var0_36 == false then
		arg0_36.animationFlags[arg0_36.teamType][arg0_36.displayMode] = true
	end

	return not var0_36
end

function var0_0.UpdateShipDetail(arg0_37)
	local var0_37 = arg0_37.teamType == var1_0
	local var1_37 = var0_37 and arg0_37.surfaceShipTpls or arg0_37.subShipTpls
	local var2_37, var3_37 = NewBattleResultUtil.SeparateSurfaceAndSubShips(arg0_37.contextData.oldMainShips)
	local var4_37 = var0_37 and var2_37 or var3_37
	local var5_37 = arg0_37.displayMode == var3_0
	local var6_37 = arg0_37.contextData.expBuff
	local var7_37 = arg0_37.contextData.buffShips
	local var8_37 = NewBattleResultUtil.GetMaxOutput(arg0_37.contextData.oldMainShips, arg0_37.contextData.statistics)

	arg0_37.numeberAnimations = {}

	local var9_37 = arg0_37:GetAnimationFlag()

	for iter0_37, iter1_37 in ipairs(var4_37) do
		local var10_37 = arg0_37.contextData.statistics[iter1_37.id] or {}
		local var11_37 = var1_37[iter0_37]
		local var12_37 = arg0_37.contextData.newMainShips[iter1_37.id]

		local function var13_37()
			setText(var11_37:Find("atk"), not var5_37 and (var10_37.output or 0) or "EXP" .. "<color=#FFDE38>+" .. NewBattleResultUtil.GetShipExpOffset(iter1_37, var12_37) .. "</color>")
			setText(var11_37:Find("killCount"), not var5_37 and (var10_37.kill_count or 0) or "Lv." .. var12_37.level)

			var11_37:Find("dmg/bar"):GetComponent(typeof(Image)).fillAmount = not var5_37 and (var10_37.output or 0) / var8_37 or var12_37:getExp() / getExpByRarityFromLv1(var12_37:getConfig("rarity"), var12_37.level)
		end

		if var9_37 then
			local var14_37 = NewBattleResultShipCardAnimation.New(var11_37, var5_37, iter1_37, var12_37, var10_37, var8_37)

			var14_37:SetUp(var13_37)
			table.insert(arg0_37.numeberAnimations, var14_37)
		else
			var13_37()
		end

		setText(var11_37:Find("kill_count_label"), not var5_37 and i18n("battle_result_kill_count") or iter1_37:getName())
		setText(var11_37:Find("dmg_count_label"), not var5_37 and i18n("battle_result_dmg") or var6_0(var7_37, var6_37, iter1_37:getGroupId()) or "")
	end
end

local function var7_0(arg0_39, arg1_39)
	local var0_39 = arg1_39:Find("MVP")

	if IsNil(var0_39) then
		LoadAnyAsync("BattleResultItems/MVP", "", nil, function(arg0_40)
			if arg0_39.exited or IsNil(arg0_40) then
				return
			end

			Object.Instantiate(arg0_40, arg1_39).name = "MVP"
		end)
	end

	local var1_39 = arg1_39:Find("MVPBG")

	if IsNil(var1_39) then
		LoadAnyAsync("BattleResultItems/MVPBG", "", nil, function(arg0_41)
			if arg0_39.exited or IsNil(arg0_41) then
				return
			end

			local var0_41 = Object.Instantiate(arg0_41, arg1_39)

			var0_41.name = "MVPBG"

			var0_41.transform:SetAsFirstSibling()
		end)
	end
end

local function var8_0(arg0_42, arg1_42)
	local var0_42 = arg1_42:Find("LevelUp")

	if IsNil(var0_42) then
		LoadAnyAsync("BattleResultItems/LevelUp", "", nil, function(arg0_43)
			if arg0_42.exited or IsNil(arg0_43) then
				return
			end

			Object.Instantiate(arg0_43, arg1_42).name = "LevelUp"
		end)
	end
end

local function var9_0(arg0_44, arg1_44)
	local var0_44 = arg1_44:Find("Intmacy")

	if IsNil(var0_44) then
		ResourceMgr.Inst:getAssetAsync("ui/zhandoujiesuan_xingxing", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_45)
			if arg0_44.exited or IsNil(arg0_45) then
				return
			end

			Object.Instantiate(arg0_45, arg1_44).name = "Intmacy"
		end), true, true)
	end
end

local function var10_0(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46, arg5_46)
	local var0_46 = arg1_46:Find("mask/icon"):GetComponent(typeof(Image))

	var0_46.sprite = LoadSprite("herohrzicon/" .. arg2_46:getPainting())
	var0_46.gameObject.transform.sizeDelta = Vector2(432, 96)

	setImageSprite(arg1_46:Find("type"), GetSpriteFromAtlas("shiptype", shipType2print(arg2_46:getShipType())), true)

	local var1_46 = arg2_46:getStar()
	local var2_46 = arg2_46:getMaxStar()
	local var3_46 = UIItemList.New(arg1_46:Find("stars"), arg1_46:Find("stars/star_tpl"))
	local var4_46 = var2_46 - var1_46

	var3_46:make(function(arg0_47, arg1_47, arg2_47)
		if arg0_47 == UIItemList.EventUpdate then
			local var0_47 = arg1_47 + 1 <= var4_46

			SetActive(arg2_47:Find("empty"), var0_47)
			SetActive(arg2_47:Find("star"), not var0_47)
		end
	end)
	var3_46:align(var2_46)

	if arg3_46 then
		var7_0(arg0_46, arg1_46)
	end

	if arg4_46 then
		var8_0(arg0_46, arg1_46)
	end

	if arg5_46 then
		onDelayTick(function()
			if arg0_46.exited then
				return
			end

			var9_0(arg0_46, arg1_46)
		end, 1)
	end
end

function var0_0.InitShips(arg0_49, arg1_49)
	arg0_49:UpdateShips(true, arg1_49)
end

function var0_0.UpdateShips(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg0_50.teamType == var1_0 and arg0_50.surfaceShipTpls or arg0_50.subShipTpls
	local var1_50 = arg0_50.teamType == var1_0 and arg0_50.subShipTpls or arg0_50.surfaceShipTpls
	local var2_50, var3_50 = NewBattleResultUtil.SeparateSurfaceAndSubShips(arg0_50.contextData.oldMainShips)
	local var4_50 = arg0_50.teamType == var1_0 and var2_50 or var3_50

	local function var5_50()
		for iter0_51, iter1_51 in ipairs(var4_50) do
			local var0_51 = var0_50[iter0_51]

			var0_51:GetComponent(typeof(CanvasGroup)).alpha = 1
			var0_51.anchoredPosition = arg0_50:GetShipSlotExpandPosition(iter0_51)

			local var1_51 = arg0_50.contextData.newMainShips[iter1_51.id]

			var10_0(arg0_50, var0_51, iter1_51, arg0_50.contextData.statistics.mvpShipID and arg0_50.contextData.statistics.mvpShipID == iter1_51.id, var1_51.level > iter1_51.level, var1_51:getIntimacy() > iter1_51:getIntimacy())
		end

		arg0_50:UpdateShipDetail()
		arg0_50:StartShipsEnterAnimation(var0_50, arg1_50 and 0.6 or 0, arg2_50)
	end

	arg0_50:LoadShipTpls(var0_50, var4_50, var5_50)

	for iter0_50, iter1_50 in ipairs(var1_50) do
		iter1_50:GetComponent(typeof(CanvasGroup)).alpha = 0
	end
end

function var0_0.LoadShipTpls(arg0_52, arg1_52, arg2_52, arg3_52)
	local var0_52 = {}

	if #arg1_52 < #arg2_52 then
		table.insert(var0_52, function(arg0_53)
			LoadAnyAsync("BattleResultItems/Ship", "", nil, function(arg0_54)
				if arg0_52.exited then
					arg0_53()

					return
				end

				arg0_53(arg0_54)
			end)
		end)
		table.insert(var0_52, function(arg0_55, arg1_55)
			if not arg1_55 then
				arg0_55()

				return
			end

			for iter0_55 = #arg1_52 + 1, #arg2_52 do
				local var0_55 = Object.Instantiate(arg1_55, arg0_52.shipContainer).transform

				var0_55:GetComponent(typeof(CanvasGroup)).alpha = 0

				table.insert(arg1_52, var0_55)
			end

			arg0_55()
		end)
	end

	seriesAsync(var0_52, arg3_52)
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

	LoadAnyAsync("BattleResultItems/FailedPainting", "", nil, function(arg0_65)
		if arg0_64.exited or IsNil(arg0_65) then
			arg1_64()

			return
		end

		Object.Instantiate(arg0_65, arg0_64.paintingTr).transform:SetAsFirstSibling()
		arg1_64()
	end)
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

	if arg1_81 > #arg0_81.commaderTpls then
		table.insert(var0_81, function(arg0_82)
			LoadAnyAsync("BattleResultItems/Commander", "", nil, function(arg0_83)
				if arg0_81.exited then
					arg0_82()

					return
				end

				arg0_82(arg0_83)
			end)
		end)
		table.insert(var0_81, function(arg0_84, arg1_84)
			if not arg1_84 then
				arg0_84()

				return
			end

			for iter0_84 = #arg0_81.commaderTpls + 1, arg1_81 do
				table.insert(arg0_81.commaderTpls, Object.Instantiate(arg1_84, arg0_81.commmanderContainer).transform)
			end

			arg0_84()
		end)
	end

	seriesAsync(var0_81, arg2_81)
end

function var0_0.onBackPressed(arg0_85)
	if arg0_85.metaExpView then
		arg0_85.metaExpView:closePanel()

		arg0_85.metaExpView = nil

		return true
	end

	return false
end

function var0_0.OnDestroy(arg0_86)
	arg0_86.exited = true

	if arg0_86.metaExpView then
		arg0_86.metaExpView:Destroy()

		arg0_86.metaExpView = nil
	end

	if arg0_86:isShowing() then
		arg0_86:Hide()
	end

	if arg0_86.animation then
		arg0_86.animation:Dispose()
	end

	arg0_86.animation = nil

	if LeanTween.isTweening(arg0_86.topPanel.gameObject) then
		LeanTween.cancel(arg0_86.topPanel.gameObject)
	end

	if LeanTween.isTweening(arg0_86.bottomPanel.gameObject) then
		LeanTween.cancel(arg0_86.bottomPanel.gameObject)
	end

	if arg0_86.surfaceShipTpls then
		for iter0_86, iter1_86 in ipairs(arg0_86.surfaceShipTpls) do
			if LeanTween.isTweening(iter1_86.gameObject) then
				LeanTween.cancel(iter1_86.gameObject)
			end
		end
	end

	if arg0_86.subShipTpls then
		for iter2_86, iter3_86 in ipairs(arg0_86.subShipTpls) do
			if LeanTween.isTweening(iter3_86.gameObject) then
				LeanTween.cancel(iter3_86.gameObject)
			end
		end
	end

	if arg0_86.numeberAnimations then
		for iter4_86, iter5_86 in ipairs(arg0_86.numeberAnimations) do
			iter5_86:Dispose()
		end
	end

	if arg0_86.playerAniamtion then
		arg0_86.playerAniamtion:Dispose()

		arg0_86.playerAniamtion = nil
	end
end

return var0_0
