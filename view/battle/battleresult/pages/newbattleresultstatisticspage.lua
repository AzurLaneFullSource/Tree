local var0 = class("NewBattleResultStatisticsPage", import("view.base.BaseSubView"))
local var1 = 1
local var2 = 2
local var3 = 0
local var4 = 1

function var0.getUIName(arg0)
	return "NewBattleResultStatisticsPage"
end

function var0.OnLoaded(arg0)
	arg0.mask = arg0:findTF("mask")
	arg0.paintingTr = arg0:findTF("painting")
	arg0.resultPaintingTr = arg0:findTF("result")
	arg0.topPanel = arg0:findTF("top")
	arg0.gradeIcon = arg0:findTF("top/grade/icon"):GetComponent(typeof(Image))
	arg0.gradeTxt = arg0:findTF("top/grade/Text"):GetComponent(typeof(Image))
	arg0.chapterName = arg0:findTF("top/grade/chapterName"):GetComponent(typeof(Text))
	arg0.opBonus = arg0:findTF("top/grade/operation_bonus")
	arg0.playerName = arg0:findTF("top/exp/name"):GetComponent(typeof(Text))
	arg0.playerLv = arg0:findTF("top/exp/lv"):GetComponent(typeof(Text))
	arg0.playerExp = arg0:findTF("top/exp/Text"):GetComponent(typeof(Text))
	arg0.playerExpLabel = arg0:findTF("top/exp/Text/exp_label"):GetComponent(typeof(Text))
	arg0.playerExpBar = arg0:findTF("top/exp/exp_bar/progress"):GetComponent(typeof(Image))
	arg0.commmanderContainer = arg0:findTF("top/exp/commanders")
	arg0.shipContainer = arg0:findTF("left")
	arg0.rawImage = arg0._tf:Find("bg"):GetComponent(typeof(RawImage))
	arg0.blackBg = arg0._tf:Find("black")
	arg0.bottomPanel = arg0:findTF("bottom")
	arg0.confrimBtn = arg0:findTF("bottom/confirmBtn")
	arg0.statisticsBtn = arg0:findTF("bottom/statisticsBtn")
	arg0.mainFleetBtn = arg0:findTF("bottom/mainFleetBtn")
	arg0.subFleetBtn = arg0:findTF("bottom/subFleetBtn")
	arg0.chatText = arg0:findTF("chat/Text"):GetComponent(typeof(Text))

	setText(arg0.confrimBtn:Find("Text"), i18n("msgbox_text_confirm"))

	arg0.cg = GetOrAddComponent(arg0._tf, typeof(CanvasGroup))
	arg0.commaderTpls = {}
	arg0.emptyTpls = {
		arg0:findTF("top/exp/emptycomanders/1"),
		arg0:findTF("top/exp/emptycomanders/2")
	}

	setText(arg0.emptyTpls[1]:Find("Text"), i18n("series_enemy_empty_commander_main"))
	setText(arg0.emptyTpls[2]:Find("Text"), i18n("series_enemy_empty_commander_assistant"))

	arg0.surfaceShipTpls = {}
	arg0.subShipTpls = {}
	arg0.animationFlags = {
		[var1] = {
			[var3] = false,
			[var4] = false
		},
		[var2] = {
			[var3] = false,
			[var4] = false
		}
	}
	arg0.animation = NewBattleResultAnimation.New(arg0._tf)
end

function var0.OnInit(arg0)
	arg0.teamType = var1
	arg0.displayMode = var3
end

function var0.SetUp(arg0, arg1, arg2)
	seriesAsync({
		function(arg0)
			arg0.cg.alpha = 0

			arg0:UpdatePainting(arg0)
			arg0:UpdateGrade()
			arg0:UpdateChapterName()
			arg0:UpdateSwitchBtn()
			arg0:UpdatePlayer()
		end,
		function(arg0)
			arg0:LoadBG(arg0)
		end,
		function(arg0)
			arg0.cg.alpha = 1

			arg0:PlayEnterAnimation(arg0)
		end,
		function(arg0)
			if arg2 then
				arg2()
			end

			arg0:InitMainView(arg0)
		end
	}, function()
		arg0:UpdateMetaBtn()
		arg0:RegisterEvent(arg1)
	end)
end

function var0.InitMainView(arg0, arg1)
	arg0.isEnter = true

	parallelAsync({
		function(arg0)
			arg0:UpdateCommanders(arg0)
		end,
		function(arg0)
			arg0:StartEnterAnimation(arg0)
		end,
		function(arg0)
			arg0:InitShips(arg0)
		end
	}, arg1)
end

function var0.PlayEnterAnimation(arg0, arg1)
	if not getProxy(SettingsProxy):IsDisplayResultPainting() then
		arg1()
		Object.Destroy(arg0.rawImage.gameObject)

		return
	end

	local var0 = pg.UIMgr.GetInstance().uiCamera.gameObject.transform:Find("Canvas")

	arg0.rawImage.texture = pg.UIMgr.GetInstance():GetStaticRtt(pg.UIMgr.CameraUI)
	rtf(arg0.rawImage.gameObject).sizeDelta = var0.sizeDelta
	arg0.blackBg.sizeDelta = var0.sizeDelta

	if arg0.effectTr then
		arg0.effectTr.anchorMax = Vector2(0.5, 0.5)
		arg0.effectTr.anchorMin = Vector2(0.5, 0.5)

		local var1 = GameObject.Find("UICamera/Canvas").transform

		arg0.effectTr.sizeDelta = var1.sizeDelta
	end

	setAnchoredPosition(arg0.topPanel, {
		y = 320
	})
	setAnchoredPosition(arg0.bottomPanel, {
		y = -320
	})

	local var2 = arg0:GetPaintingPosition()

	arg0.mask.localPosition = var2

	if arg0.animation then
		arg0.animation:Play(arg0.resultPaintingData, function()
			arg0.rawImage.texture = nil

			Object.Destroy(arg0.rawImage.gameObject)
			arg1()
		end)
	end
end

function var0.LoadBG(arg0, arg1)
	local var0 = arg0._parentTf:Find("Effect")

	if not IsNil(var0) then
		setParent(var0, arg0._tf)
		var0:SetSiblingIndex(2)

		arg0.effectTr = var0

		arg1()
	else
		local var1 = NewBattleResultUtil.Score2Bg(arg0.contextData.score)

		ResourceMgr.Inst:getAssetAsync("BattleResultItems/" .. var1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.exited or IsNil(arg0) then
				if arg1 then
					arg1()
				end

				return
			end

			local var0 = Object.Instantiate(arg0, arg0._tf)

			var0.transform:SetSiblingIndex(2)

			arg0.effectTr = var0.transform

			if arg1 then
				arg1()
			end
		end), true, true)
	end
end

function var0.RegisterEvent(arg0, arg1)
	onButton(arg0, arg0.mainFleetBtn, function()
		arg0.teamType = var1

		arg0:UpdateShips(false)
		arg0:UpdateCommanders(function()
			return
		end)
		arg0:UpdateSwitchBtn()
	end, SFX_PANEL)
	onButton(arg0, arg0.subFleetBtn, function()
		arg0.teamType = var2

		arg0:UpdateShips(false)
		arg0:UpdateCommanders(function()
			return
		end)
		arg0:UpdateSwitchBtn()
	end, SFX_PANEL)
	onButton(arg0, arg0.statisticsBtn, function()
		arg0.displayMode = 1 - arg0.displayMode

		arg0:UpdateShipDetail()
	end, SFX_PANEL)
	onButton(arg0, arg0.confrimBtn, function()
		arg1()
	end, SFX_PANEL)

	if arg0.contextData.autoSkipFlag then
		onNextTick(function()
			triggerButton(arg0.confrimBtn)
		end)
	end
end

local function var5(arg0, arg1)
	onButton(arg0, arg1, function()
		setActive(arg1, false)

		if arg0.metaExpView then
			return
		end

		arg0.metaExpView = BattleResultMetaExpView.New(arg0._tf, arg0.event, arg0.contextData)

		arg0.metaExpView:Reset()
		arg0.metaExpView:Load()

		local var0 = getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList()

		arg0.metaExpView:setData(var0, function()
			if arg1 then
				setActive(arg1, true)
			end

			arg0.metaExpView = nil
		end)
		arg0.metaExpView:ActionInvoke("Show")
		arg0.metaExpView:ActionInvoke("openPanel")
	end, SFX_PANEL)
end

function var0.UpdateMetaBtn(arg0)
	local var0 = getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList()

	if var0 and #var0 > 0 then
		ResourceMgr.Inst:getAssetAsync("BattleResultItems/MetaBtn", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.exited or IsNil(arg0) then
				return
			end

			local var0 = Object.Instantiate(arg0, arg0._tf)

			var5(arg0, var0.transform)
		end), true, true)
	end
end

function var0.StartEnterAnimation(arg0, arg1)
	LeanTween.value(arg0.topPanel.gameObject, 320, 0, 0.2):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.topPanel, {
			y = arg0
		})
	end))
	LeanTween.value(arg0.bottomPanel.gameObject, -320, 0, 0.2):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.bottomPanel, {
			y = arg0
		})
	end)):setOnComplete(System.Action(arg1))
end

function var0.GetShipSlotExpandPosition(arg0, arg1)
	local var0 = arg0:GetShipSlotShrinkPosition(arg1)

	return Vector2(1300, var0.y)
end

function var0.GetShipSlotShrinkPosition(arg0, arg1)
	return Vector2(500, 250) + (arg1 - 1) * Vector2(69.55, -117.7)
end

local function var6(arg0, arg1, arg2)
	local var0 = ""
	local var1 = arg0 and arg0[arg2]

	if arg1 or var1 then
		var0 = arg1 and arg1:getConfig("name") or var1 and i18n("Word_Ship_Exp_Buff")
	end

	return var0
end

function var0.GetAnimationFlag(arg0)
	if arg0.contextData.autoSkipFlag then
		return false
	end

	local var0 = arg0.animationFlags[arg0.teamType][arg0.displayMode]

	if var0 == false then
		arg0.animationFlags[arg0.teamType][arg0.displayMode] = true
	end

	return not var0
end

function var0.UpdateShipDetail(arg0)
	local var0 = arg0.teamType == var1
	local var1 = var0 and arg0.surfaceShipTpls or arg0.subShipTpls
	local var2, var3 = NewBattleResultUtil.SeparateSurfaceAndSubShips(arg0.contextData.oldMainShips)
	local var4 = var0 and var2 or var3
	local var5 = arg0.displayMode == var3
	local var6 = arg0.contextData.expBuff
	local var7 = arg0.contextData.buffShips
	local var8 = NewBattleResultUtil.GetMaxOutput(arg0.contextData.oldMainShips, arg0.contextData.statistics)

	arg0.numeberAnimations = {}

	local var9 = arg0:GetAnimationFlag()

	for iter0, iter1 in ipairs(var4) do
		local var10 = arg0.contextData.statistics[iter1.id] or {}
		local var11 = var1[iter0]
		local var12 = arg0.contextData.newMainShips[iter1.id]

		local function var13()
			setText(var11:Find("atk"), not var5 and (var10.output or 0) or "EXP" .. "<color=#FFDE38>+" .. NewBattleResultUtil.GetShipExpOffset(iter1, var12) .. "</color>")
			setText(var11:Find("killCount"), not var5 and (var10.kill_count or 0) or "Lv." .. var12.level)

			var11:Find("dmg/bar"):GetComponent(typeof(Image)).fillAmount = not var5 and (var10.output or 0) / var8 or var12:getExp() / getExpByRarityFromLv1(var12:getConfig("rarity"), var12.level)
		end

		if var9 then
			local var14 = NewBattleResultShipCardAnimation.New(var11, var5, iter1, var12, var10, var8)

			var14:SetUp(var13)
			table.insert(arg0.numeberAnimations, var14)
		else
			var13()
		end

		setText(var11:Find("kill_count_label"), not var5 and i18n("battle_result_kill_count") or iter1:getName())
		setText(var11:Find("dmg_count_label"), not var5 and i18n("battle_result_dmg") or var6(var7, var6, iter1:getGroupId()) or "")
	end
end

local function var7(arg0, arg1)
	local var0 = arg1:Find("MVP")

	if IsNil(var0) then
		ResourceMgr.Inst:getAssetAsync("BattleResultItems/MVP", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.exited or IsNil(arg0) then
				return
			end

			Object.Instantiate(arg0, arg1).name = "MVP"
		end), true, true)
	end

	local var1 = arg1:Find("MVPBG")

	if IsNil(var1) then
		ResourceMgr.Inst:getAssetAsync("BattleResultItems/MVPBG", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.exited or IsNil(arg0) then
				return
			end

			local var0 = Object.Instantiate(arg0, arg1)

			var0.name = "MVPBG"

			var0.transform:SetAsFirstSibling()
		end), true, true)
	end
end

local function var8(arg0, arg1)
	local var0 = arg1:Find("LevelUp")

	if IsNil(var0) then
		ResourceMgr.Inst:getAssetAsync("BattleResultItems/LevelUp", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.exited or IsNil(arg0) then
				return
			end

			Object.Instantiate(arg0, arg1).name = "LevelUp"
		end), true, true)
	end
end

local function var9(arg0, arg1)
	local var0 = arg1:Find("Intmacy")

	if IsNil(var0) then
		ResourceMgr.Inst:getAssetAsync("ui/zhandoujiesuan_xingxing", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.exited or IsNil(arg0) then
				return
			end

			Object.Instantiate(arg0, arg1).name = "Intmacy"
		end), true, true)
	end
end

local function var10(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg1:Find("mask/icon"):GetComponent(typeof(Image))

	var0.sprite = LoadSprite("herohrzicon/" .. arg2:getPainting())
	var0.gameObject.transform.sizeDelta = Vector2(432, 96)

	setImageSprite(arg1:Find("type"), GetSpriteFromAtlas("shiptype", shipType2print(arg2:getShipType())), true)

	local var1 = arg2:getStar()
	local var2 = arg2:getMaxStar()
	local var3 = UIItemList.New(arg1:Find("stars"), arg1:Find("stars/star_tpl"))
	local var4 = var2 - var1

	var3:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1 <= var4

			SetActive(arg2:Find("empty"), var0)
			SetActive(arg2:Find("star"), not var0)
		end
	end)
	var3:align(var2)

	if arg3 then
		var7(arg0, arg1)
	end

	if arg4 then
		var8(arg0, arg1)
	end

	if arg5 then
		onDelayTick(function()
			if arg0.exited then
				return
			end

			var9(arg0, arg1)
		end, 1)
	end
end

function var0.InitShips(arg0, arg1)
	arg0:UpdateShips(true, arg1)
end

function var0.UpdateShips(arg0, arg1, arg2)
	local var0 = arg0.teamType == var1 and arg0.surfaceShipTpls or arg0.subShipTpls
	local var1 = arg0.teamType == var1 and arg0.subShipTpls or arg0.surfaceShipTpls
	local var2, var3 = NewBattleResultUtil.SeparateSurfaceAndSubShips(arg0.contextData.oldMainShips)
	local var4 = arg0.teamType == var1 and var2 or var3

	local function var5()
		for iter0, iter1 in ipairs(var4) do
			local var0 = var0[iter0]

			var0:GetComponent(typeof(CanvasGroup)).alpha = 1
			var0.anchoredPosition = arg0:GetShipSlotExpandPosition(iter0)

			local var1 = arg0.contextData.newMainShips[iter1.id]

			var10(arg0, var0, iter1, arg0.contextData.statistics.mvpShipID and arg0.contextData.statistics.mvpShipID == iter1.id, var1.level > iter1.level, var1:getIntimacy() > iter1:getIntimacy())
		end

		arg0:UpdateShipDetail()
		arg0:StartShipsEnterAnimation(var0, arg1 and 0.6 or 0, arg2)
	end

	arg0:LoadShipTpls(var0, var4, var5)

	for iter0, iter1 in ipairs(var1) do
		iter1:GetComponent(typeof(CanvasGroup)).alpha = 0
	end
end

function var0.LoadShipTpls(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0 = #arg1 + 1, #arg2 do
		table.insert(var0, function(arg0)
			local var0 = iter0 == #arg2

			ResourceMgr.Inst:getAssetAsync("BattleResultItems/Ship", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0.exited or IsNil(arg0) then
					arg0()

					return
				end

				local var0 = Object.Instantiate(arg0, arg0.shipContainer).transform

				var0:GetComponent(typeof(CanvasGroup)).alpha = 0

				table.insert(arg1, var0)
				arg0()
			end), var0, var0)
		end)
	end

	seriesAsync(var0, arg3)
end

function var0.StartShipsEnterAnimation(arg0, arg1, arg2, arg3)
	if arg2 <= 0 then
		for iter0, iter1 in ipairs(arg1) do
			iter1.anchoredPosition = arg0:GetShipSlotShrinkPosition(iter0)
		end

		return
	end

	local var0 = {}

	for iter2, iter3 in ipairs(arg1) do
		local var1 = iter3:GetComponent(typeof(CanvasGroup))

		var1.alpha = 0

		local var2 = arg0:GetShipSlotExpandPosition(iter2)
		local var3 = arg0:GetShipSlotShrinkPosition(iter2)

		table.insert(var0, function(arg0)
			if arg0.exited then
				return
			end

			var1.alpha = 1

			LeanTween.value(iter3.gameObject, var2.x, var3.x, arg2 - (iter2 - 1) * 0.1):setOnUpdate(System.Action_float(function(arg0)
				iter3.anchoredPosition = Vector3(arg0, iter3.anchoredPosition.y, 0)
			end))
			onDelayTick(arg0, 0.1)
		end)
	end

	seriesAsync(var0, arg3)
end

function var0.UpdateSwitchBtn(arg0)
	local var0 = NewBattleResultUtil.HasSubShip(arg0.contextData.oldMainShips)
	local var1 = NewBattleResultUtil.HasSurfaceShip(arg0.contextData.oldMainShips)

	setActive(arg0.mainFleetBtn, arg0.teamType == var2 and var1 and var0)
	setActive(arg0.subFleetBtn, arg0.teamType == var1 and var1 and var0)

	if not var1 then
		arg0.teamType = var2
	end
end

function var0.UpdateMvpPainting(arg0, arg1)
	local var0 = arg0.contextData.oldMainShips
	local var1, var2, var3, var4 = NewBattleResultUtil.SeparateMvpShip(var0, arg0.contextData.statistics.mvpShipID, arg0.contextData.statistics._flagShipID)

	var4 = var4 or var0[#var0 - 1]

	local var5 = arg0.resultPaintingTr
	local var6 = var4:getPainting()

	setPaintingPrefabAsync(var5, var6, "jiesuan", function()
		ShipExpressionHelper.SetExpression(findTF(var5, "fitter"):GetChild(0), var6, ShipWordHelper.WORD_TYPE_MVP, var4:getCVIntimacy())
		arg0:RecordPainting(arg1)
	end)
	arg0:DisplayShipDialogue(var4)
end

function var0.RecordPainting(arg0, arg1)
	onNextTick(function()
		local var0 = arg0.resultPaintingTr:Find("fitter"):GetChild(0)

		if not IsNil(var0) then
			arg0.resultPaintingData = {
				position = Vector2(var0.position.x, var0.position.y),
				pivot = rtf(var0).pivot,
				scale = Vector2(var0.localScale.x, var0.localScale.y)
			}

			SetParent(var0, arg0.paintingTr:Find("painting/fitter"), true)
		end

		arg1()
	end)
end

function var0.UpdateFailedPainting(arg0, arg1)
	local var0 = arg0.contextData.oldMainShips

	ResourceMgr.Inst:getAssetAsync("BattleResultItems/FailedPainting", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited or IsNil(arg0) then
			arg1()

			return
		end

		Object.Instantiate(arg0, arg0.paintingTr).transform:SetAsFirstSibling()
		arg1()
	end), true, true)
	arg0:DisplayShipDialogue(var0[math.random(#var0)])
end

function var0.GetPaintingPosition(arg0)
	local var0 = arg0.contextData.oldMainShips

	return (NewBattleResultDisplayPaintingsPage.StaticGetFinalExpandPosition(#var0))
end

function var0.UpdatePaintingPosition(arg0)
	local var0 = arg0:GetPaintingPosition()

	arg0.paintingTr.localPosition = var0
end

function var0.UpdatePainting(arg0, arg1)
	arg0:UpdatePaintingPosition()

	if arg0.contextData.score > 1 then
		arg0:UpdateMvpPainting(arg1)
	else
		arg0:UpdateFailedPainting(arg1)
	end
end

function var0.DisplayShipDialogue(arg0, arg1)
	local var0
	local var1
	local var2

	if arg0.contextData.score > 1 then
		local var3, var4

		var3, var4, var1 = ShipWordHelper.GetWordAndCV(arg1.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, arg1:getCVIntimacy())
	else
		local var5, var6

		var5, var6, var1 = ShipWordHelper.GetWordAndCV(arg1.skinId, ShipWordHelper.WORD_TYPE_LOSE, nil, nil, arg1:getCVIntimacy())
	end

	arg0.chatText.text = var1
	arg0.chatText.alignment = #var1 > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter

	arg0:PlayMvpShipVoice()
end

function var0.PlayMvpShipVoice(arg0)
	if not arg0.contextData.statistics.mvpShipID or type(arg0.contextData.statistics.mvpShipID) == "number" and arg0.contextData.statistics.mvpShipID <= 0 then
		return
	end

	local var0 = _.detect(arg0.contextData.oldMainShips, function(arg0)
		return arg0.id == arg0.contextData.statistics.mvpShipID
	end)

	assert(var0)

	local var1
	local var2
	local var3

	if arg0.contextData.score > 1 then
		local var4, var5

		var4, var3, var5 = ShipWordHelper.GetWordAndCV(var0.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, var0:getCVIntimacy())
	else
		local var6, var7

		var6, var3, var7 = ShipWordHelper.GetWordAndCV(var0.skinId, ShipWordHelper.WORD_TYPE_LOSE)
	end

	if var3 then
		arg0:StopVoice()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3, function(arg0)
			arg0._currentVoice = arg0
		end)
	end
end

function var0.StopVoice(arg0)
	if arg0._currentVoice then
		arg0._currentVoice:PlaybackStop()

		arg0._currentVoice = nil
	end
end

function var0.UpdateGrade(arg0)
	local var0, var1 = NewBattleResultUtil.Score2Grade(arg0.contextData.score, arg0.contextData._scoreMark)

	LoadImageSpriteAsync(var0, arg0.gradeIcon, false)
	LoadImageSpriteAsync(var1, arg0.gradeTxt, false)
end

function var0.UpdateChapterName(arg0)
	local var0 = NewBattleResultUtil.GetChapterName(arg0.contextData)

	arg0.chapterName.text = var0

	setActive(arg0.opBonus, NewBattleResultUtil.IsOpBonus(arg0.contextData.extraBuffList))
end

function var0.UpdatePlayer(arg0)
	local var0 = arg0.contextData.oldPlayer
	local var1 = getProxy(PlayerProxy):getRawData()

	arg0.playerName.text = var1:GetName()

	local function var2()
		arg0.playerLv.text = "Lv." .. var1.level

		local var0 = NewBattleResultUtil.GetPlayerExpOffset(var0, var1)

		arg0.playerExp.text = "+" .. var0
		arg0.playerExpLabel.text = "EXP"
		arg0.playerExpBar.fillAmount = var1.level == var1:getMaxLevel() and 1 or var1.exp / getConfigFromLevel1(pg.user_level, var1.level).exp_interval
	end

	if not arg0.contextData.autoSkipFlag then
		local var3 = NewBattleResultPlayerAniamtion.New(arg0.playerLv, arg0.playerExp, arg0.playerExpBar, var1, var0)

		var3:SetUp(var2)

		arg0.playerAniamtion = var3
	else
		var2()
	end
end

local function var11(arg0, arg1, arg2)
	GetImageSpriteFromAtlasAsync("commandericon/" .. arg2:getPainting(), "", arg0:Find("icon"))
	setText(arg0:Find("name_text"), arg2:getName())
	setText(arg0:Find("lv_text"), "Lv." .. arg2.level)
	setText(arg0:Find("exp"), "+" .. arg1.exp)

	local var0 = arg2:isMaxLevel() and 1 or arg1.curExp / arg2:getNextLevelExp()

	arg0:Find("exp_bar/progress"):GetComponent(typeof(Image)).fillAmount = var0
end

function var0.UpdateCommanders(arg0, arg1)
	local var0 = arg0.teamType
	local var1 = arg0.contextData.commanderExps or {}
	local var2 = var0 == var1 and var1.surfaceCMD or var1.submarineCMD

	var2 = var2 or {}

	local function var3()
		for iter0 = 1, #var2 do
			local var0 = getProxy(CommanderProxy):getCommanderById(var2[iter0].commander_id)

			setActive(arg0.commaderTpls[iter0], true)
			var11(arg0.commaderTpls[iter0], var2[iter0], var0)
		end

		for iter1 = #arg0.commaderTpls, #var2 + 1, -1 do
			setActive(arg0.commaderTpls[iter1], false)
		end
	end

	for iter0 = 1, #arg0.emptyTpls do
		setActive(arg0.emptyTpls[iter0], var2[iter0] == nil)
	end

	arg0:LoadCommanderTpls(#var2, var3)
	arg1()
end

function var0.LoadCommanderTpls(arg0, arg1, arg2)
	local var0 = {}

	for iter0 = #arg0.commaderTpls + 1, arg1 do
		table.insert(var0, function(arg0)
			local var0 = iter0 == arg1

			ResourceMgr.Inst:getAssetAsync("BattleResultItems/Commander", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				if arg0.exited or IsNil(arg0) then
					arg0()

					return
				end

				table.insert(arg0.commaderTpls, Object.Instantiate(arg0, arg0.commmanderContainer).transform)
				arg0()
			end), var0, var0)
		end)
	end

	parallelAsync(var0, arg2)
end

function var0.onBackPressed(arg0)
	if arg0.metaExpView then
		arg0.metaExpView:closePanel()

		arg0.metaExpView = nil

		return true
	end

	return false
end

function var0.OnDestroy(arg0)
	arg0.exited = true

	if arg0.metaExpView then
		arg0.metaExpView:Destroy()

		arg0.metaExpView = nil
	end

	if arg0:isShowing() then
		arg0:Hide()
	end

	if arg0.animation then
		arg0.animation:Dispose()
	end

	arg0.animation = nil

	if LeanTween.isTweening(arg0.topPanel.gameObject) then
		LeanTween.cancel(arg0.topPanel.gameObject)
	end

	if LeanTween.isTweening(arg0.bottomPanel.gameObject) then
		LeanTween.cancel(arg0.bottomPanel.gameObject)
	end

	if arg0.surfaceShipTpls then
		for iter0, iter1 in ipairs(arg0.surfaceShipTpls) do
			if LeanTween.isTweening(iter1.gameObject) then
				LeanTween.cancel(iter1.gameObject)
			end
		end
	end

	if arg0.subShipTpls then
		for iter2, iter3 in ipairs(arg0.subShipTpls) do
			if LeanTween.isTweening(iter3.gameObject) then
				LeanTween.cancel(iter3.gameObject)
			end
		end
	end

	if arg0.numeberAnimations then
		for iter4, iter5 in ipairs(arg0.numeberAnimations) do
			iter5:Dispose()
		end
	end

	if arg0.playerAniamtion then
		arg0.playerAniamtion:Dispose()

		arg0.playerAniamtion = nil
	end
end

return var0
