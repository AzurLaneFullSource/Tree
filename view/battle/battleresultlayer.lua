local var0 = class("BattleResultLayer", import("..base.BaseUI"))

var0.DURATION_MOVE = 0.35
var0.DURATION_WIN_SCALE = 0.4
var0.CONDITIONS_FREQUENCE = 0.15
var0.STATE_RANK_ANIMA = "rankAnima"
var0.STATE_REPORT = "report"
var0.STATE_REPORTED = "reported"
var0.STATE_REWARD = "reward"
var0.STATE_DISPLAY = "display"
var0.STATE_DISPLAYED = "displayed"
var0.STATE_SUB_DISPLAY = "subDisplay"
var0.STATE_SUB_DISPLAYED = "subDisplayed"
var0.ObjectiveList = {
	"battle_result_victory",
	"battle_result_undefeated",
	"battle_result_sink_limit",
	"battle_preCombatLayer_time_hold",
	"battle_result_time_limit",
	"battle_result_boss_destruct",
	"battle_preCombatLayer_damage_before_end",
	"battle_result_defeat_all_enemys"
}

function var0.getUIName(arg0)
	return "BattleResultUI"
end

function var0.setRivalVO(arg0, arg1)
	arg0.rivalVO = arg1
end

function var0.setRank(arg0, arg1, arg2)
	arg0.player = arg1
	arg0.season = arg2

	setText(arg0._playerName, "<color=#FFFFFF>" .. arg0.player.name .. "</color><size=32> / C O M M A N D E R</size>")

	local var0 = SeasonInfo.getMilitaryRank(arg2.score, arg2.rank)
	local var1, var2 = SeasonInfo.getNextMilitaryRank(arg2.score, arg2.rank)

	setText(arg0._playerLv, var0.name)
	setText(arg0._playerExpLabel, i18n("word_rankScore"))

	arg0._playerExpProgress:GetComponent(typeof(Image)).fillAmount = arg2.score / var2

	setText(arg0._playerBonusExp, "+0")

	arg0.calcPlayerProgress = arg0.calcPlayerRank
end

function var0.setShips(arg0, arg1)
	arg0.shipVOs = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1

	setText(arg0._playerName, "<color=#FFFFFF>" .. arg0.player.name .. "</color><size=32> / C O M M A N D E R</size>")
	setText(arg0._playerLv, "Lv." .. arg0.player.level)

	local var0 = getConfigFromLevel1(pg.user_level, arg0.player.level)

	arg0._playerExpProgress:GetComponent(typeof(Image)).fillAmount = arg0.player.exp / var0.exp_interval

	if arg0.player.level == pg.user_level[#pg.user_level].level then
		arg0._playerExpProgress:GetComponent(typeof(Image)).fillAmount = 1
	end

	setText(arg0._playerBonusExp, "+0")

	arg0.calcPlayerProgress = arg0.calcPlayerExp

	local var1 = arg0.contextData.extraBuffList

	for iter0, iter1 in ipairs(var1) do
		if pg.benefit_buff_template[iter1].benefit_type == Chapter.OPERATION_BUFF_TYPE_EXP then
			setActive(arg0._playerExpExtra, true)
		end
	end
end

function var0.setExpBuff(arg0, arg1, arg2)
	arg0.expBuff = arg1
	arg0.shipBuff = arg2
end

function var0.init(arg0)
	arg0._grade = arg0:findTF("grade")
	arg0._levelText = arg0:findTF("chapterName/Text22", arg0._grade)
	arg0.clearFX = arg0:findTF("clear")
	arg0._main = arg0:findTF("main")
	arg0._blurConatiner = arg0:findTF("blur_container")
	arg0._bg = arg0:findTF("main/jiesuanbeijing")
	arg0._painting = arg0:findTF("painting", arg0._blurConatiner)
	arg0._failPainting = arg0:findTF("fail", arg0._painting)
	arg0._chat = arg0:findTF("chat", arg0._painting)
	arg0._leftPanel = arg0:findTF("leftPanel", arg0._main)
	arg0._expResult = arg0:findTF("expResult", arg0._leftPanel)
	arg0._expContainer = arg0:findTF("expContainer", arg0._expResult)
	arg0._extpl = arg0:getTpl("ShipCardTpl", arg0._expContainer)
	arg0._playerExp = arg0:findTF("playerExp", arg0._leftPanel)
	arg0._playerName = arg0:findTF("name_text", arg0._playerExp)
	arg0._playerLv = arg0:findTF("lv_text", arg0._playerExp)
	arg0._playerExpLabel = arg0:findTF("exp_label", arg0._playerExp)
	arg0._playerExpProgress = arg0:findTF("exp_progress", arg0._playerExp)
	arg0._playerBonusExp = arg0:findTF("exp_text", arg0._playerExp)
	arg0._playerExpExtra = arg0:findTF("operation_bonus", arg0._playerExp)
	arg0._atkBG = arg0:findTF("atkPanel", arg0._blurConatiner)
	arg0._atkPanel = arg0:findTF("atkResult", arg0._atkBG)
	arg0._atkResult = arg0:findTF("atkResult/result", arg0._atkBG)
	arg0._atkContainer = arg0:findTF("Grid", arg0._atkResult)
	arg0._atkContainerNext = arg0:findTF("Grid_next", arg0._atkResult)
	arg0._atkToggle = arg0:findTF("switchAtk", arg0._atkPanel)
	arg0._atkTpl = arg0:getTpl("resulttpl", arg0._atkResult)
	arg0._mvpFX = arg0:findTF("mvpFX", arg0._atkPanel)
	arg0._rightBottomPanel = arg0:findTF("rightBottomPanel", arg0._blurConatiner)
	arg0._confirmBtn = arg0:findTF("confirmBtn", arg0._rightBottomPanel)

	setText(arg0._confirmBtn:Find("Text"), i18n("text_confirm"))

	arg0._statisticsBtn = arg0:findTF("statisticsBtn", arg0._rightBottomPanel)
	arg0._subExpResult = arg0:findTF("subExpResult", arg0._leftPanel)
	arg0._subExpContainer = arg0:findTF("expContainer", arg0._subExpResult)
	arg0._subToggle = arg0:findTF("switchFleet", arg0._leftPanel)

	setActive(arg0._subToggle, false)

	arg0._skipBtn = arg0:findTF("skipLayer", arg0._tf)
	arg0.UIMain = pg.UIMgr.GetInstance().UIMain
	arg0.overlay = pg.UIMgr.GetInstance().OverlayMain
	arg0._conditions = arg0:findTF("main/conditions")
	arg0._conditionContainer = arg0:findTF("bg16/list", arg0._conditions)
	arg0._conditionTpl = arg0:findTF("bg16/conditionTpl", arg0._conditions)
	arg0._conditionSubTpl = arg0:findTF("bg16/conditionSubTpl", arg0._conditions)
	arg0._conditionContributeTpl = arg0:findTF("bg16/conditionContributeTpl", arg0._conditions)
	arg0._conditionBGNormal = arg0:findTF("bg16/bg_normal", arg0._conditions)
	arg0._conditionBGContribute = arg0:findTF("bg16/bg_contribute", arg0._conditions)
	arg0._cmdExp = arg0:findTF("commanderExp", arg0._leftPanel)
	arg0._cmdContainer = arg0:findTF("commander_container", arg0._cmdExp)
	arg0._cmdTpl = arg0:findTF("commander_tpl", arg0._cmdExp)

	arg0:setGradeLabel()
	SetActive(arg0._levelText, false)

	arg0._delayLeanList = {}
	arg0._ratioFitter = GetComponent(arg0._tf, typeof(AspectRatioFitter))
	arg0._ratioFitter.enabled = true
	arg0._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0, arg1)
		arg0._ratioFitter.aspectRatio = arg1
	end)
end

function var0.customsLang(arg0)
	setText(findTF(arg0._confirmBtn, "Text"), i18n("battle_result_confirm"))
	setText(findTF(arg0._bg, "jieuan01/tips/dianjijixu/bg20"), i18n("battle_result_continue"))
	setText(findTF(arg0._atkTpl, "result/dmg_count_label"), i18n("battle_result_dmg"))
	setText(findTF(arg0._atkTpl, "result/kill_count_label"), i18n("battle_result_kill_count"))
	setText(findTF(arg0._subToggle, "on"), i18n("battle_result_toggle_on"))
	setText(findTF(arg0._subToggle, "off"), i18n("battle_result_toggle_off"))
	setText(findTF(arg0._conditions, "bg17"), i18n("battle_result_targets"))
end

function var0.setGradeLabel(arg0)
	local var0 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1 = arg0:findTF("grade/Xyz/bg13")
	local var2 = arg0:findTF("grade/Xyz/bg14")
	local var3
	local var4
	local var5
	local var6 = arg0.contextData.score
	local var7
	local var8 = var6 > 0

	setActive(arg0:findTF("jieuan01/BG/bg_victory", arg0._bg), var8)
	setActive(arg0:findTF("jieuan01/BG/bg_fail", arg0._bg), not var8)

	if var8 then
		var5 = var0[var6 + 1]
		var3 = "battlescore/battle_score_" .. var5 .. "/letter_" .. var5
		var4 = "battlescore/battle_score_" .. var5 .. "/label_" .. var5
	else
		if arg0.contextData.statistics._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
			var5 = var0[2]
			var7 = "flag_destroy"
		else
			var5 = var0[1]
		end

		var3 = "battlescore/battle_score_" .. var5 .. "/letter_" .. var5
		var4 = "battlescore/battle_score_" .. var5 .. "/label_" .. (var7 or var5)
	end

	LoadImageSpriteAsync(var3, var1, false)
	LoadImageSpriteAsync(var4, var2, false)

	local var9 = arg0.contextData.system

	if (var9 == SYSTEM_SCENARIO or var9 == SYSTEM_ROUTINE or var9 == SYSTEM_SUB_ROUTINE or var9 == SYSTEM_DUEL) and (var5 == var0[1] or var5 == var0[2]) then
		arg0.failTag = true
	end
end

function var0.displayerCommanders(arg0, arg1)
	arg0.commanderExps = arg0.contextData.commanderExps or {}

	local var0 = getProxy(CommanderProxy)

	removeAllChildren(arg0._cmdContainer)

	local var1

	if arg1 then
		var1 = arg0.commanderExps.submarineCMD or {}
	else
		var1 = arg0.commanderExps.surfaceCMD or {}
	end

	setActive(arg0._cmdExp, true)

	for iter0, iter1 in ipairs(var1) do
		local var2 = var0:getCommanderById(iter1.commander_id)
		local var3 = cloneTplTo(arg0._cmdTpl, arg0._cmdContainer)

		GetImageSpriteFromAtlasAsync("commandericon/" .. var2:getPainting(), "", var3:Find("icon/mask/pic"))
		setText(var3:Find("exp/name_text"), var2:getName())
		setText(var3:Find("exp/lv_text"), "Lv." .. var2.level)
		setText(var3:Find("exp/exp_text"), "+" .. iter1.exp)

		local var4
		local var5 = var2:isMaxLevel() and 1 or iter1.curExp / var2:getNextLevelExp()

		var3:Find("exp/exp_progress"):GetComponent(typeof(Image)).fillAmount = var5
	end
end

function var0.didEnter(arg0)
	arg0:setStageName()
	arg0:customsLang()

	arg0._shipResultCardList, arg0._subShipResultCardList = {}, {}

	local var0 = rtf(arg0._grade)

	arg0._gradeUpperLeftPos = var0.localPosition
	var0.localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, true, {
		lockGlobalBlur = true,
		groupName = LayerWeightConst.GROUP_COMBAT
	})

	if arg0.contextData.system ~= SYSTEM_BOSS_RUSH and arg0.contextData.system ~= SYSTEM_BOSS_RUSH_EX and arg0.contextData.system ~= SYSTEM_ACT_BOSS and arg0.contextData.system ~= SYSTEM_BOSS_SINGLE then
		ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCemera(false)
	end

	arg0._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0._grade, Vector3(0.88, 0.88, 1), var0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0._levelText, true)
		arg0:rankAnimaFinish()
	end))

	arg0._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)

	SetActive(arg0._atkBG, false)
	onToggle(arg0, arg0._subToggle, function(arg0)
		SetActive(arg0._subExpResult, not arg0)
		SetActive(arg0._expResult, arg0)
		setActive(arg0:findTF("off", arg0._subToggle), not arg0)
		arg0:displayerCommanders(not arg0)
	end, SFX_PANEL)

	arg0._stateFlag = var0.STATE_RANK_ANIMA

	onButton(arg0, arg0._skipBtn, function()
		arg0:skip()
	end, SFX_CONFIRM)
end

function var0.setStageName(arg0)
	if arg0.contextData.system and arg0.contextData.system == SYSTEM_DUEL then
		if arg0.rivalVO then
			setText(arg0._levelText, arg0.rivalVO.name)
		else
			setText(arg0._levelText, "")
		end
	else
		local var0 = arg0.contextData.stageId
		local var1 = pg.expedition_data_template[var0]

		setText(arg0._levelText, var1.name)
	end
end

function var0.rankAnimaFinish(arg0)
	local var0 = arg0:findTF("main/conditions")

	SetActive(var0, true)

	local var1 = arg0.contextData.stageId
	local var2 = pg.expedition_data_template[var1]

	local function var3(arg0)
		if type(arg0) == "table" then
			local var0 = i18n(var0.ObjectiveList[arg0[1]], arg0[2])

			arg0:setCondition(var0, var0.objectiveCheck(arg0[1], arg0.contextData))
		end
	end

	var3(var2.objective_1)
	var3(var2.objective_2)
	var3(var2.objective_3)

	local var4 = LeanTween.delayedCall(1, System.Action(function()
		arg0._stateFlag = var0.STATE_REPORTED

		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)

		if arg0.skipFlag then
			arg0:skip()
		end
	end))

	table.insert(arg0._delayLeanList, var4.id)

	arg0._stateFlag = var0.STATE_REPORT
end

function var0.objectiveCheck(arg0, arg1)
	if arg0 == 1 or arg0 == 4 or arg0 == 8 then
		return arg1.score > 1
	elseif arg0 == 2 or arg0 == 3 then
		return not arg1.statistics._deadUnit
	elseif arg0 == 6 then
		return arg1.statistics._boss_destruct < 1
	elseif arg0 == 5 then
		return not arg1.statistics._badTime
	elseif arg0 == 7 then
		return true
	end
end

function var0.setCondition(arg0, arg1, arg2)
	local var0 = cloneTplTo(arg0._conditionTpl, arg0._conditionContainer)

	setActive(var0, false)

	local var1
	local var2 = var0:Find("text"):GetComponent(typeof(Text))

	if arg2 == nil then
		var1 = "resources/condition_check"
		var2.text = setColorStr(arg1, "#FFFFFFFF")
	elseif arg2 == true then
		var1 = "resources/condition_done"
		var2.text = setColorStr(arg1, "#FFFFFFFF")
	else
		var1 = "resources/condition_fail"
		var2.text = setColorStr(arg1, "#FFFFFF80")
	end

	arg0:setSpriteTo(var1, var0:Find("checkBox"), true)

	local var3 = arg0._conditionContainer.childCount - 1

	if var3 > 0 then
		local var4 = LeanTween.delayedCall(var0.CONDITIONS_FREQUENCE * var3, System.Action(function()
			setActive(var0, true)
		end))

		table.insert(arg0._delayLeanList, var4.id)
	else
		setActive(var0, true)
	end
end

function var0.showRewardInfo(arg0)
	arg0._stateFlag = var0.STATE_REWARD

	if arg0.contextData.system == SYSTEM_BOSS_RUSH or arg0.contextData.system == SYSTEM_BOSS_RUSH_EX then
		arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)

		return
	end

	SetActive(arg0:findTF("jieuan01/tips", arg0._bg), false)
	setParent(arg0._tf, arg0.UIMain)

	local var0

	local function var1()
		if var0 and coroutine.status(var0) == "suspended" then
			local var0, var1 = coroutine.resume(var0)

			assert(var0, var1)
		end
	end

	var0 = coroutine.create(function()
		local var0 = arg0.contextData.drops
		local var1 = getProxy(ActivityProxy)
		local var2 = var1:getActivityById(ActivityConst.UTAWARERU_ACTIVITY_PT_ID)

		if var2 and not var2:isEnd() then
			local var3 = var2:getConfig("config_client").pt_id
			local var4 = _.detect(var1:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0)
				return arg0:getConfig("config_id") == var3
			end):getData1()

			if var4 >= 1500 then
				local var5 = var4 - 1500
				local var6 = _.detect(var0, function(arg0)
					return arg0.type == DROP_TYPE_RESOURCE and arg0.id == var3
				end)

				var0 = _.filter(var0, function(arg0)
					return arg0.type ~= DROP_TYPE_RESOURCE or arg0.id ~= var3
				end)

				if var6 and var5 < var6.count then
					var6.count = var6.count - var5

					table.insert(var0, var6)
				end
			end
		end

		local var7 = {}

		for iter0, iter1 in ipairs(arg0.contextData.drops) do
			table.insert(var7, iter1)
		end

		for iter2, iter3 in ipairs(arg0.contextData.extraDrops) do
			iter3.riraty = true

			table.insert(var7, iter3)
		end

		local var8 = false
		local var9 = arg0.contextData.extraBuffList

		for iter4, iter5 in ipairs(var9) do
			if pg.benefit_buff_template[iter5].benefit_type == Chapter.OPERATION_BUFF_TYPE_REWARD then
				var8 = true

				break
			end
		end

		local var10 = PlayerConst.BonusItemMarker(var0)

		if table.getCount(var10) > 0 then
			local var11 = arg0.skipFlag
			local var12 = false

			if arg0.contextData.system == SYSTEM_SCENARIO then
				local var13 = getProxy(ChapterProxy):getActiveChapter(true)

				if var13 then
					if var13:isLoop() then
						getProxy(ChapterProxy):AddExtendChapterDataArray(var13.id, "TotalDrops", var7)

						var12 = getProxy(ChapterProxy):GetChapterAutoFlag(var13.id) == 1
					end

					var13:writeDrops(var7)
				end
			elseif arg0.contextData.system == SYSTEM_ACT_BOSS then
				if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
					getProxy(ChapterProxy):AddActBossRewards(var7)
				end
			elseif arg0.contextData.system == SYSTEM_BOSS_SINGLE and getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
				getProxy(ChapterProxy):AddBossSingleRewards(var7)
			end

			arg0:emit(BaseUI.ON_AWARD, {
				items = var7,
				extraBonus = var8,
				removeFunc = var1,
				closeOnCompleted = var11
			})
			coroutine.yield()

			local var14 = #_.filter(var7, function(arg0)
				return arg0.type == DROP_TYPE_SHIP
			end)
			local var15 = getProxy(BayProxy):getNewShip(true)

			for iter6 = math.max(1, #var15 - var14 + 1), #var15 do
				local var16 = var15[iter6]

				if PlayerPrefs.GetInt(DISPLAY_SHIP_GET_EFFECT) == 1 or var16.virgin or var16:getRarity() >= ShipRarity.Purple then
					local var17 = var12 and not var16.virgin and 3 or nil

					arg0:emit(BattleResultMediator.GET_NEW_SHIP, var16, var1, var17)
					coroutine.yield()
				end
			end
		end

		setParent(arg0._tf, arg0.overlay)
		arg0:displayBG()
	end)

	var1()
end

function var0.displayBG(arg0)
	local var0 = function()
		arg0:displayShips()
		arg0:displayPlayerInfo()
		arg0:displayerCommanders()
		arg0:initMetaBtn()

		arg0._stateFlag = var0.STATE_DISPLAY

		if arg0.skipFlag then
			arg0:skip()
		end
	end
	local var1 = rtf(arg0._grade)

	LeanTween.moveX(rtf(arg0._conditions), 1300, var0.DURATION_MOVE)
	LeanTween.scale(arg0._grade, Vector3(0.6, 0.6, 0), var0.DURATION_MOVE)
	LeanTween.moveLocal(go(var1), arg0._gradeUpperLeftPos, var0.DURATION_MOVE)
	setActive(arg0:findTF("jieuan01/Bomb", arg0._bg), false)
	onDelayTick(function()
		setLocalScale(arg0._grade, Vector3(0.6, 0.6, 0))
		setAnchoredPosition(arg0._grade, arg0._gradeUpperLeftPos)
		var0()
	end, var0.DURATION_MOVE)
end

function var0.displayPlayerInfo(arg0)
	local var0 = arg0:calcPlayerProgress()

	SetActive(arg0._leftPanel, true)
	SetActive(arg0._playerExp, true)

	arg0._main:GetComponent("Animator").enabled = true

	local var1 = LeanTween.moveX(rtf(arg0._leftPanel), 0, 0.5):setOnComplete(System.Action(function()
		local var0 = LeanTween.value(go(arg0._tf), 0, var0, 1):setOnUpdate(System.Action_float(function(arg0)
			setText(arg0._playerBonusExp, "+" .. math.floor(arg0))
		end))

		table.insert(arg0._delayLeanList, var0.id)
	end))

	table.insert(arg0._delayLeanList, var1.id)
end

function var0.calcPlayerExp(arg0)
	local var0 = arg0.contextData.oldPlayer
	local var1 = var0.level
	local var2 = arg0.player.level
	local var3 = arg0.player.exp - var0.exp

	while var1 < var2 do
		var3 = var3 + pg.user_level[var1].exp
		var1 = var1 + 1
	end

	if var1 == pg.user_level[#pg.user_level].level then
		var3 = 0
	end

	return var3
end

function var0.calcPlayerRank(arg0)
	local var0 = arg0.contextData.oldRank
	local var1 = var0.score

	return arg0.season.score - var0.score
end

function var0.displayShips(arg0)
	local var0 = {}
	local var1 = arg0.shipVOs

	for iter0, iter1 in ipairs(var1) do
		var0[iter1.id] = iter1
	end

	local var2 = arg0.contextData.statistics

	for iter2, iter3 in ipairs(var1) do
		if var2[iter3.id] then
			var2[iter3.id].vo = iter3
		end
	end

	local var3
	local var4

	if var2.mvpShipID == -1 then
		var4 = 0

		for iter4, iter5 in ipairs(arg0.contextData.oldMainShips) do
			var4 = math.max(var2[iter5.id].output, var4)
		end
	elseif var2.mvpShipID and var2.mvpShipID ~= 0 then
		var3 = var2[var2.mvpShipID]
		var4 = var3.output
	else
		var4 = 0
	end

	local var5 = arg0.contextData.oldMainShips

	arg0._atkFuncs = {}

	local var6
	local var7

	SetActive(arg0._atkToggle, #var5 > 6)

	if #var5 > 6 then
		onToggle(arg0, arg0._atkToggle, function(arg0)
			SetActive(arg0._atkContainer, arg0)
			SetActive(arg0._atkContainerNext, not arg0)

			if arg0 then
				arg0:skipAtkAnima(arg0._atkContainerNext)
			else
				arg0:skipAtkAnima(arg0._atkContainer)
			end
		end, SFX_PANEL)
	end

	local var8 = {}
	local var9 = {}

	for iter6, iter7 in ipairs(var5) do
		local var10 = var0[iter7.id]

		if var2[iter7.id] then
			local var11 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter7.configId).type
			local var12 = table.contains(TeamType.SubShipType, var11)
			local var13
			local var14
			local var15 = 0
			local var16

			if iter6 > 6 then
				var14 = arg0._atkContainerNext
				var16 = 7
			else
				var14 = arg0._atkContainer
				var16 = 1
			end

			local var17 = cloneTplTo(arg0._atkTpl, var14)
			local var18 = var17.localPosition

			var18.x = var18.x + (iter6 - var16) * 74
			var18.y = var18.y + (iter6 - var16) * -124
			var17.localPosition = var18

			local var19 = findTF(var17, "result/stars")
			local var20 = findTF(var17, "result/stars/star_tpl")
			local var21 = iter7:getStar()
			local var22 = iter7:getMaxStar()

			while var22 > 0 do
				local var23 = cloneTplTo(var20, var19)

				SetActive(var23:Find("empty"), var21 < var22)
				SetActive(var23:Find("star"), var22 <= var21)

				var22 = var22 - 1
			end

			local var24 = arg0:findTF("result/mask/icon", var17)
			local var25 = arg0:findTF("result/type", var17)

			var24:GetComponent(typeof(Image)).sprite = LoadSprite("herohrzicon/" .. iter7:getPainting())

			local var26 = var2[iter7.id].output / var4
			local var27 = GetSpriteFromAtlas("shiptype", shipType2print(iter7:getShipType()))

			setImageSprite(var25, var27, true)
			arg0:setAtkAnima(var17, var14, var26, var4, var3 and iter7.id == var3.id, var2[iter7.id].output, var2[iter7.id].kill_count)

			local var28
			local var29 = false

			if var3 and iter7.id == var3.id then
				var29 = true
				arg0.mvpShipVO = iter7

				local var30
				local var31
				local var32

				if arg0.contextData.score > 1 then
					local var33, var34

					var33, var32, var34 = ShipWordHelper.GetWordAndCV(arg0.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, arg0.mvpShipVO:getCVIntimacy())
				else
					local var35, var36

					var35, var32, var36 = ShipWordHelper.GetWordAndCV(arg0.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_LOSE)
				end

				if var32 then
					arg0:stopVoice()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var32, function(arg0)
						arg0._currentVoice = arg0
					end)
				end
			end

			if iter7.id == var2._flagShipID then
				arg0.flagShipVO = iter7
			end

			local var37
			local var38 = arg0.shipBuff and arg0.shipBuff[iter7:getGroupId()]

			if arg0.expBuff or var38 then
				var37 = arg0.expBuff and arg0.expBuff:getConfig("name") or var38 and i18n("Word_Ship_Exp_Buff")
			end

			local var39

			if not var12 then
				local var40 = cloneTplTo(arg0._extpl, arg0._expContainer)

				var39 = BattleResultShipCard.New(var40)

				table.insert(arg0._shipResultCardList, var39)

				if var7 then
					var7:ConfigCallback(function()
						var39:Play()
					end)
				else
					var39:Play()
				end

				var7 = var39
			else
				local var41 = cloneTplTo(arg0._extpl, arg0._subExpContainer)

				var39 = BattleResultShipCard.New(var41)

				table.insert(arg0._subShipResultCardList, var39)

				if not var6 then
					arg0._subFirstExpCard = var39
				else
					var6:ConfigCallback(function()
						var39:Play()
					end)
				end

				var6 = var39
			end

			var39:SetShipVO(iter7, var10, var29, var37)
		end
	end

	if var7 then
		var7:ConfigCallback(function()
			arg0._stateFlag = var0.STATE_DISPLAYED

			if not arg0._subFirstExpCard then
				arg0:skip()
			end
		end)
	end

	if var6 then
		var6:ConfigCallback(function()
			arg0._stateFlag = var0.STATE_SUB_DISPLAYED

			arg0:skip()
		end)
	end
end

function var0.stopVoice(arg0)
	if arg0._currentVoice then
		arg0._currentVoice:PlaybackStop()

		arg0._currentVoice = nil
	end
end

function var0.setAtkAnima(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local var0 = arg0:findTF("result", arg1)
	local var1 = arg0:findTF("result/atk", arg1)
	local var2 = arg0:findTF("result/dmg_progress/progress_bar", arg1)
	local var3 = arg0:findTF("result/killCount", arg1)
	local var4 = var0:GetComponent(typeof(DftAniEvent))

	setText(var1, 0)
	setText(var3, 0)

	var2:GetComponent(typeof(Image)).fillAmount = 0

	if arg5 then
		local var5 = arg0:findTF("result/mvpBG", arg1)

		setParent(arg0._mvpFX, var5)

		arg0._mvpFX.localPosition = Vector3(-368.5, 0, 0)

		setActive(var5, true)
		setActive(arg0:findTF("result/bg", arg1), false)
	end

	var4:SetEndEvent(function(arg0)
		if arg5 then
			setActive(arg0._mvpFX, true)
		end

		LeanTween.value(go(var0), 0, arg3, arg3):setOnUpdate(System.Action_float(function(arg0)
			var2:GetComponent(typeof(Image)).fillAmount = arg0
		end))

		if arg4 ~= 0 then
			LeanTween.value(go(var0), 0, arg6, arg3):setOnUpdate(System.Action_float(function(arg0)
				setText(var1, math.floor(arg0))
			end))
			LeanTween.value(go(var0), 0, arg7, arg3):setOnUpdate(System.Action_float(function(arg0)
				setText(var3, math.floor(arg0))
			end))
		end
	end)

	if arg2.childCount > 1 then
		arg0:findTF("result", arg2:GetChild(arg2.childCount - 2)):GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0)
			setActive(var0, true)
		end)
	else
		setActive(var0, true)
	end

	local function var6()
		var2:GetComponent(typeof(Image)).fillAmount = arg3

		setText(var1, arg6)
		setText(var3, arg7)

		var0.localPosition = Vector3(280, 46, 0)
		var0:GetComponent(typeof(Animator)).enabled = false

		setActive(var0, true)
		setActive(arg0._mvpFX, true)
	end

	if arg0._atkFuncs[arg2] == nil then
		arg0._atkFuncs[arg2] = {}
	end

	table.insert(arg0._atkFuncs[arg2], var6)
end

function var0.skipAtkAnima(arg0, arg1)
	if arg0._atkFuncs[arg1] then
		for iter0, iter1 in ipairs(arg0._atkFuncs[arg1]) do
			iter1()
		end

		arg0._atkFuncs[arg1] = nil
	end
end

function var0.showPainting(arg0)
	local var0
	local var1
	local var2

	SetActive(arg0._painting, true)

	if arg0.contextData.score > 1 then
		local var3 = arg0.mvpShipVO or arg0.flagShipVO

		arg0.paintingName = var3:getPainting()

		local var4 = var3:getCVIntimacy()

		setPaintingPrefabAsync(arg0._painting, arg0.paintingName, "jiesuan", function()
			if findTF(arg0._painting, "fitter").childCount > 0 then
				ShipExpressionHelper.SetExpression(findTF(arg0._painting, "fitter"):GetChild(0), arg0.paintingName, "win_mvp", var4)
			end
		end)

		local var5, var6

		var5, var6, var1 = ShipWordHelper.GetWordAndCV(var3.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, var4)

		SetActive(arg0._failPainting, false)
	else
		local var7 = arg0.contextData.oldMainShips
		local var8 = var7[math.random(#var7)]
		local var9, var10

		var9, var10, var1 = ShipWordHelper.GetWordAndCV(var8.skinId, ShipWordHelper.WORD_TYPE_LOSE)
	end

	setText(arg0._chat:Find("Text"), var1)

	local var11 = arg0._chat:Find("Text"):GetComponent(typeof(Text))

	if #var11.text > CHAT_POP_STR_LEN then
		var11.alignment = TextAnchor.MiddleLeft
	else
		var11.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0._chat, true)

	arg0._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(arg0._painting))
	LeanTween.moveX(rtf(arg0._painting), 50, 0.25):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0._chat.gameObject), Vector3.New(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
			arg0._statisticsBtn:GetComponent("Button").enabled = true
			arg0._confirmBtn:GetComponent("Button").enabled = true
			arg0._atkBG:GetComponent("Button").enabled = true
		end))
	end))
end

function var0.hidePainting(arg0)
	SetActive(arg0._chat, false)

	arg0._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(arg0._painting))
	LeanTween.scale(rtf(arg0._chat.gameObject), Vector3.New(0, 0, 0), 0.1):setEase(LeanTweenType.easeOutBack)
	LeanTween.moveX(rtf(arg0._painting), 720, 0.2):setOnComplete(System.Action(function()
		SetActive(arg0._painting, false)
	end))
end

function var0.skip(arg0)
	for iter0, iter1 in ipairs(arg0._delayLeanList) do
		LeanTween.cancel(iter1)
	end

	if arg0._stateFlag == var0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0._stateFlag == var0.STATE_REPORT then
		local var0 = arg0._conditionContainer.childCount

		while var0 > 0 do
			SetActive(arg0._conditionContainer:GetChild(var0 - 1), true)

			var0 = var0 - 1
		end

		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)

		arg0._stateFlag = var0.STATE_REPORTED

		arg0:skip()
	elseif arg0._stateFlag == var0.STATE_REPORTED then
		arg0:showRewardInfo()
	elseif arg0._stateFlag == var0.STATE_REWARD then
		-- block empty
	elseif arg0._stateFlag == var0.STATE_DISPLAY then
		for iter2, iter3 in ipairs(arg0._shipResultCardList) do
			iter3:SkipAnimation()
		end

		arg0._stateFlag = var0.STATE_DISPLAYED

		setText(arg0._playerBonusExp, "+" .. arg0:calcPlayerProgress())

		if not arg0._subFirstExpCard then
			arg0:playSubExEnter()
		elseif arg0.skipFlag then
			arg0:skip()
		end
	elseif arg0._stateFlag == var0.STATE_DISPLAYED then
		setText(arg0._playerBonusExp, "+" .. arg0:calcPlayerProgress())
		arg0:playSubExEnter()
	elseif arg0._stateFlag == var0.STATE_SUB_DISPLAY then
		for iter4, iter5 in ipairs(arg0._subShipResultCardList) do
			iter5:SkipAnimation()
		end

		arg0._stateFlag = var0.STATE_SUB_DISPLAYED

		if arg0.skipFlag then
			arg0:skip()
		end
	elseif arg0._stateFlag == var0.STATE_SUB_DISPLAYED then
		arg0:showRightBottomPanel()
	end
end

function var0.playSubExEnter(arg0)
	arg0._stateFlag = var0.STATE_SUB_DISPLAY

	if arg0._subFirstExpCard then
		triggerToggle(arg0._subToggle, false)
		arg0._subFirstExpCard:Play()
	else
		arg0:showRightBottomPanel()
	end

	if arg0.skipFlag then
		arg0:skip()
	end
end

function var0.showRightBottomPanel(arg0)
	SetActive(arg0._skipBtn, false)
	SetActive(arg0._rightBottomPanel, true)
	SetActive(arg0._subToggle, arg0._subFirstExpCard ~= nil)
	onButton(arg0, arg0._statisticsBtn, function()
		if arg0._atkBG.gameObject.activeSelf then
			arg0:closeStatistics()
		else
			arg0:showStatistics()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0._confirmBtn, function()
		if arg0.failTag == true then
			arg0:emit(BattleResultMediator.PRE_BATTLE_FAIL_EXIT)
			arg0:emit(BattleResultMediator.OPEN_FAIL_TIP_LAYER)
		else
			arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0._atkBG, function()
		arg0:closeStatistics()
	end, SFX_CANCEL)

	arg0._stateFlag = nil
	arg0._subFirstExpCard = nil

	if arg0.skipFlag then
		triggerButton(arg0._confirmBtn)
	end
end

function var0.showStatistics(arg0)
	setActive(arg0._leftPanel, false)
	arg0:enabledStatisticsGizmos(false)
	SetActive(arg0._atkBG, true)

	arg0._atkBG:GetComponent("Button").enabled = false
	arg0._confirmBtn:GetComponent("Button").enabled = false
	arg0._statisticsBtn:GetComponent("Button").enabled = false

	arg0:showPainting()
	LeanTween.moveX(rtf(arg0._atkPanel), 0, 0.25):setOnComplete(System.Action(function()
		SetActive(arg0._atkContainer, true)
	end))
end

function var0.closeStatistics(arg0)
	setActive(arg0._leftPanel, true)
	arg0:skipAtkAnima(arg0._atkContainerNext)
	arg0:skipAtkAnima(arg0._atkContainer)
	arg0:enabledStatisticsGizmos(true)
	arg0:hidePainting()

	arg0._atkBG:GetComponent("Button").enabled = false

	LeanTween.cancel(arg0._atkPanel.gameObject)
	LeanTween.moveX(rtf(arg0._atkPanel), -700, 0.2):setOnComplete(System.Action(function()
		SetActive(arg0._atkBG, false)
	end))
end

function var0.enabledStatisticsGizmos(arg0, arg1)
	setActive(arg0:findTF("gizmos/xuxian_down", arg0._main), arg1)
	setActive(arg0:findTF("gizmos/xuxian_middle", arg0._main), arg1)
end

function var0.PlayAnimation(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	LeanTween.value(arg1.gameObject, arg2, arg3, arg4):setDelay(arg5):setOnUpdate(System.Action_float(function(arg0)
		arg6(arg0)
	end))
end

function var0.SetSkipFlag(arg0, arg1)
	arg0.skipFlag = arg1
end

function var0.initMetaBtn(arg0)
	arg0.metaBtn = arg0:findTF("MetaBtn", arg0._main)

	local var0 = getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList()

	setActive(arg0.metaBtn, var0 and #var0 > 0 or false)
	onButton(arg0, arg0.metaBtn, function()
		setActive(arg0.metaBtn, false)

		if not arg0.metaExpView then
			arg0.metaExpView = BattleResultMetaExpView.New(arg0._blurConatiner, arg0.event, arg0.contextData)

			arg0.metaExpView:Reset()
			arg0.metaExpView:Load()
			arg0.metaExpView:setData(var0, function()
				if arg0.metaBtn then
					setActive(arg0.metaBtn, true)
				end

				arg0.metaExpView = nil
			end)
			arg0.metaExpView:ActionInvoke("Show")
			arg0.metaExpView:ActionInvoke("openPanel")
		end
	end, SFX_PANEL)
end

function var0.onBackPressed(arg0)
	if arg0.metaExpView then
		arg0.metaExpView:closePanel()

		arg0.metaExpView = nil

		return
	end

	if arg0._stateFlag == var0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0._stateFlag == var0.STATE_REPORT then
		triggerButton(arg0._bg)
	elseif arg0._stateFlag == var0.STATE_REPORTED then
		triggerButton(arg0._skipBtn)
	elseif arg0._stateFlag == var0.STATE_DISPLAY then
		triggerButton(arg0._skipBtn)
	else
		triggerButton(arg0._confirmBtn)
	end
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0._shipResultCardList) do
		iter1:Dispose()
	end

	for iter2, iter3 in ipairs(arg0._subShipResultCardList) do
		iter3:Dispose()
	end

	arg0._atkFuncs = nil

	LeanTween.cancel(go(arg0._tf))

	if arg0._atkBG.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnblurPanel(arg0._blurConatiner, arg0._tf)
	end

	if arg0.paintingName then
		retPaintingPrefab(arg0._painting, arg0.paintingName)
	end

	if arg0._rightTimer then
		arg0._rightTimer:Stop()
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0:stopVoice()
	getProxy(MetaCharacterProxy):clearLastMetaSkillExpInfoList()

	if arg0.metaExpView then
		arg0.metaExpView:Destroy()

		arg0.metaExpView = nil
	end

	pg.CameraFixMgr.GetInstance():disconnect(arg0.camEventId)
end

return var0
