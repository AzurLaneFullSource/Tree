local var0_0 = class("BattleResultLayer", import("..base.BaseUI"))

var0_0.DURATION_MOVE = 0.35
var0_0.DURATION_WIN_SCALE = 0.4
var0_0.CONDITIONS_FREQUENCE = 0.15
var0_0.STATE_RANK_ANIMA = "rankAnima"
var0_0.STATE_REPORT = "report"
var0_0.STATE_REPORTED = "reported"
var0_0.STATE_REWARD = "reward"
var0_0.STATE_DISPLAY = "display"
var0_0.STATE_DISPLAYED = "displayed"
var0_0.STATE_SUB_DISPLAY = "subDisplay"
var0_0.STATE_SUB_DISPLAYED = "subDisplayed"
var0_0.ObjectiveList = {
	"battle_result_victory",
	"battle_result_undefeated",
	"battle_result_sink_limit",
	"battle_preCombatLayer_time_hold",
	"battle_result_time_limit",
	"battle_result_boss_destruct",
	"battle_preCombatLayer_damage_before_end",
	"battle_result_defeat_all_enemys"
}

function var0_0.getUIName(arg0_1)
	return "BattleResultUI"
end

function var0_0.setRivalVO(arg0_2, arg1_2)
	arg0_2.rivalVO = arg1_2
end

function var0_0.setRank(arg0_3, arg1_3, arg2_3)
	arg0_3.player = arg1_3
	arg0_3.season = arg2_3

	setText(arg0_3._playerName, "<color=#FFFFFF>" .. arg0_3.player.name .. "</color><size=32> / C O M M A N D E R</size>")

	local var0_3 = SeasonInfo.getMilitaryRank(arg2_3.score, arg2_3.rank)
	local var1_3, var2_3 = SeasonInfo.getNextMilitaryRank(arg2_3.score, arg2_3.rank)

	setText(arg0_3._playerLv, var0_3.name)
	setText(arg0_3._playerExpLabel, i18n("word_rankScore"))

	arg0_3._playerExpProgress:GetComponent(typeof(Image)).fillAmount = arg2_3.score / var2_3

	setText(arg0_3._playerBonusExp, "+0")

	arg0_3.calcPlayerProgress = arg0_3.calcPlayerRank
end

function var0_0.setShips(arg0_4, arg1_4)
	arg0_4.shipVOs = arg1_4
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.player = arg1_5

	setText(arg0_5._playerName, "<color=#FFFFFF>" .. arg0_5.player.name .. "</color><size=32> / C O M M A N D E R</size>")
	setText(arg0_5._playerLv, "Lv." .. arg0_5.player.level)

	local var0_5 = getConfigFromLevel1(pg.user_level, arg0_5.player.level)

	arg0_5._playerExpProgress:GetComponent(typeof(Image)).fillAmount = arg0_5.player.exp / var0_5.exp_interval

	if arg0_5.player.level == pg.user_level[#pg.user_level].level then
		arg0_5._playerExpProgress:GetComponent(typeof(Image)).fillAmount = 1
	end

	setText(arg0_5._playerBonusExp, "+0")

	arg0_5.calcPlayerProgress = arg0_5.calcPlayerExp

	local var1_5 = arg0_5.contextData.extraBuffList

	for iter0_5, iter1_5 in ipairs(var1_5) do
		if pg.benefit_buff_template[iter1_5].benefit_type == Chapter.OPERATION_BUFF_TYPE_EXP then
			setActive(arg0_5._playerExpExtra, true)
		end
	end
end

function var0_0.setExpBuff(arg0_6, arg1_6, arg2_6)
	arg0_6.expBuff = arg1_6
	arg0_6.shipBuff = arg2_6
end

function var0_0.init(arg0_7)
	arg0_7._grade = arg0_7:findTF("grade")
	arg0_7._levelText = arg0_7:findTF("chapterName/Text22", arg0_7._grade)
	arg0_7.clearFX = arg0_7:findTF("clear")
	arg0_7._main = arg0_7:findTF("main")
	arg0_7._blurConatiner = arg0_7:findTF("blur_container")
	arg0_7._bg = arg0_7:findTF("main/jiesuanbeijing")
	arg0_7._painting = arg0_7:findTF("painting", arg0_7._blurConatiner)
	arg0_7._failPainting = arg0_7:findTF("fail", arg0_7._painting)
	arg0_7._chat = arg0_7:findTF("chat", arg0_7._painting)
	arg0_7._leftPanel = arg0_7:findTF("leftPanel", arg0_7._main)
	arg0_7._expResult = arg0_7:findTF("expResult", arg0_7._leftPanel)
	arg0_7._expContainer = arg0_7:findTF("expContainer", arg0_7._expResult)
	arg0_7._extpl = arg0_7:getTpl("ShipCardTpl", arg0_7._expContainer)
	arg0_7._playerExp = arg0_7:findTF("playerExp", arg0_7._leftPanel)
	arg0_7._playerName = arg0_7:findTF("name_text", arg0_7._playerExp)
	arg0_7._playerLv = arg0_7:findTF("lv_text", arg0_7._playerExp)
	arg0_7._playerExpLabel = arg0_7:findTF("exp_label", arg0_7._playerExp)
	arg0_7._playerExpProgress = arg0_7:findTF("exp_progress", arg0_7._playerExp)
	arg0_7._playerBonusExp = arg0_7:findTF("exp_text", arg0_7._playerExp)
	arg0_7._playerExpExtra = arg0_7:findTF("operation_bonus", arg0_7._playerExp)
	arg0_7._atkBG = arg0_7:findTF("atkPanel", arg0_7._blurConatiner)
	arg0_7._atkPanel = arg0_7:findTF("atkResult", arg0_7._atkBG)
	arg0_7._atkResult = arg0_7:findTF("atkResult/result", arg0_7._atkBG)
	arg0_7._atkContainer = arg0_7:findTF("Grid", arg0_7._atkResult)
	arg0_7._atkContainerNext = arg0_7:findTF("Grid_next", arg0_7._atkResult)
	arg0_7._atkToggle = arg0_7:findTF("switchAtk", arg0_7._atkPanel)
	arg0_7._atkTpl = arg0_7:getTpl("resulttpl", arg0_7._atkResult)
	arg0_7._mvpFX = arg0_7:findTF("mvpFX", arg0_7._atkPanel)
	arg0_7._rightBottomPanel = arg0_7:findTF("rightBottomPanel", arg0_7._blurConatiner)
	arg0_7._confirmBtn = arg0_7:findTF("confirmBtn", arg0_7._rightBottomPanel)

	setText(arg0_7._confirmBtn:Find("Text"), i18n("text_confirm"))

	arg0_7._statisticsBtn = arg0_7:findTF("statisticsBtn", arg0_7._rightBottomPanel)
	arg0_7._subExpResult = arg0_7:findTF("subExpResult", arg0_7._leftPanel)
	arg0_7._subExpContainer = arg0_7:findTF("expContainer", arg0_7._subExpResult)
	arg0_7._subToggle = arg0_7:findTF("switchFleet", arg0_7._leftPanel)

	setActive(arg0_7._subToggle, false)

	arg0_7._skipBtn = arg0_7:findTF("skipLayer", arg0_7._tf)
	arg0_7.UIMain = pg.UIMgr.GetInstance().UIMain
	arg0_7.overlay = pg.UIMgr.GetInstance().OverlayMain
	arg0_7._conditions = arg0_7:findTF("main/conditions")
	arg0_7._conditionContainer = arg0_7:findTF("bg16/list", arg0_7._conditions)
	arg0_7._conditionTpl = arg0_7:findTF("bg16/conditionTpl", arg0_7._conditions)
	arg0_7._conditionSubTpl = arg0_7:findTF("bg16/conditionSubTpl", arg0_7._conditions)
	arg0_7._conditionContributeTpl = arg0_7:findTF("bg16/conditionContributeTpl", arg0_7._conditions)
	arg0_7._conditionBGNormal = arg0_7:findTF("bg16/bg_normal", arg0_7._conditions)
	arg0_7._conditionBGContribute = arg0_7:findTF("bg16/bg_contribute", arg0_7._conditions)
	arg0_7._cmdExp = arg0_7:findTF("commanderExp", arg0_7._leftPanel)
	arg0_7._cmdContainer = arg0_7:findTF("commander_container", arg0_7._cmdExp)
	arg0_7._cmdTpl = arg0_7:findTF("commander_tpl", arg0_7._cmdExp)

	arg0_7:setGradeLabel()
	SetActive(arg0_7._levelText, false)

	arg0_7._delayLeanList = {}
	arg0_7._ratioFitter = GetComponent(arg0_7._tf, typeof(AspectRatioFitter))
	arg0_7._ratioFitter.enabled = true
	arg0_7._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0_7.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_8, arg1_8)
		arg0_7._ratioFitter.aspectRatio = arg1_8
	end)
end

function var0_0.customsLang(arg0_9)
	setText(findTF(arg0_9._confirmBtn, "Text"), i18n("battle_result_confirm"))
	setText(findTF(arg0_9._bg, "jieuan01/tips/dianjijixu/bg20"), i18n("battle_result_continue"))
	setText(findTF(arg0_9._atkTpl, "result/dmg_count_label"), i18n("battle_result_dmg"))
	setText(findTF(arg0_9._atkTpl, "result/kill_count_label"), i18n("battle_result_kill_count"))
	setText(findTF(arg0_9._subToggle, "on"), i18n("battle_result_toggle_on"))
	setText(findTF(arg0_9._subToggle, "off"), i18n("battle_result_toggle_off"))
	setText(findTF(arg0_9._conditions, "bg17"), i18n("battle_result_targets"))
end

function var0_0.setGradeLabel(arg0_10)
	local var0_10 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1_10 = arg0_10:findTF("grade/Xyz/bg13")
	local var2_10 = arg0_10:findTF("grade/Xyz/bg14")
	local var3_10
	local var4_10
	local var5_10
	local var6_10 = arg0_10.contextData.score
	local var7_10
	local var8_10 = var6_10 > 0

	setActive(arg0_10:findTF("jieuan01/BG/bg_victory", arg0_10._bg), var8_10)
	setActive(arg0_10:findTF("jieuan01/BG/bg_fail", arg0_10._bg), not var8_10)

	if var8_10 then
		var5_10 = var0_10[var6_10 + 1]
		var3_10 = "battlescore/battle_score_" .. var5_10 .. "/letter_" .. var5_10
		var4_10 = "battlescore/battle_score_" .. var5_10 .. "/label_" .. var5_10
	else
		if arg0_10.contextData.statistics._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
			var5_10 = var0_10[2]
			var7_10 = "flag_destroy"
		else
			var5_10 = var0_10[1]
		end

		var3_10 = "battlescore/battle_score_" .. var5_10 .. "/letter_" .. var5_10
		var4_10 = "battlescore/battle_score_" .. var5_10 .. "/label_" .. (var7_10 or var5_10)
	end

	LoadImageSpriteAsync(var3_10, var1_10, false)
	LoadImageSpriteAsync(var4_10, var2_10, false)

	local var9_10 = arg0_10.contextData.system

	if (var9_10 == SYSTEM_SCENARIO or var9_10 == SYSTEM_ROUTINE or var9_10 == SYSTEM_SUB_ROUTINE or var9_10 == SYSTEM_DUEL) and (var5_10 == var0_10[1] or var5_10 == var0_10[2]) then
		arg0_10.failTag = true
	end
end

function var0_0.displayerCommanders(arg0_11, arg1_11)
	arg0_11.commanderExps = arg0_11.contextData.commanderExps or {}

	local var0_11 = getProxy(CommanderProxy)

	removeAllChildren(arg0_11._cmdContainer)

	local var1_11

	if arg1_11 then
		var1_11 = arg0_11.commanderExps.submarineCMD or {}
	else
		var1_11 = arg0_11.commanderExps.surfaceCMD or {}
	end

	setActive(arg0_11._cmdExp, true)

	for iter0_11, iter1_11 in ipairs(var1_11) do
		local var2_11 = var0_11:getCommanderById(iter1_11.commander_id)
		local var3_11 = cloneTplTo(arg0_11._cmdTpl, arg0_11._cmdContainer)

		GetImageSpriteFromAtlasAsync("commandericon/" .. var2_11:getPainting(), "", var3_11:Find("icon/mask/pic"))
		setText(var3_11:Find("exp/name_text"), var2_11:getName())
		setText(var3_11:Find("exp/lv_text"), "Lv." .. var2_11.level)
		setText(var3_11:Find("exp/exp_text"), "+" .. iter1_11.exp)

		local var4_11
		local var5_11 = var2_11:isMaxLevel() and 1 or iter1_11.curExp / var2_11:getNextLevelExp()

		var3_11:Find("exp/exp_progress"):GetComponent(typeof(Image)).fillAmount = var5_11
	end
end

function var0_0.didEnter(arg0_12)
	arg0_12:setStageName()
	arg0_12:customsLang()

	arg0_12._shipResultCardList, arg0_12._subShipResultCardList = {}, {}

	local var0_12 = rtf(arg0_12._grade)

	arg0_12._gradeUpperLeftPos = var0_12.localPosition
	var0_12.localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf, true, {
		lockGlobalBlur = true,
		groupName = LayerWeightConst.GROUP_COMBAT
	})

	if arg0_12.contextData.system ~= SYSTEM_BOSS_RUSH and arg0_12.contextData.system ~= SYSTEM_BOSS_RUSH_EX and arg0_12.contextData.system ~= SYSTEM_ACT_BOSS and arg0_12.contextData.system ~= SYSTEM_BOSS_SINGLE then
		ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCemera(false)
	end

	arg0_12._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0_12._grade, Vector3(0.88, 0.88, 1), var0_0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0_12._levelText, true)
		arg0_12:rankAnimaFinish()
	end))

	arg0_12._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)

	SetActive(arg0_12._atkBG, false)
	onToggle(arg0_12, arg0_12._subToggle, function(arg0_14)
		SetActive(arg0_12._subExpResult, not arg0_14)
		SetActive(arg0_12._expResult, arg0_14)
		setActive(arg0_12:findTF("off", arg0_12._subToggle), not arg0_14)
		arg0_12:displayerCommanders(not arg0_14)
	end, SFX_PANEL)

	arg0_12._stateFlag = var0_0.STATE_RANK_ANIMA

	onButton(arg0_12, arg0_12._skipBtn, function()
		arg0_12:skip()
	end, SFX_CONFIRM)
end

function var0_0.setStageName(arg0_16)
	if arg0_16.contextData.system and arg0_16.contextData.system == SYSTEM_DUEL then
		if arg0_16.rivalVO then
			setText(arg0_16._levelText, arg0_16.rivalVO.name)
		else
			setText(arg0_16._levelText, "")
		end
	else
		local var0_16 = arg0_16.contextData.stageId
		local var1_16 = pg.expedition_data_template[var0_16]

		setText(arg0_16._levelText, var1_16.name)
	end
end

function var0_0.rankAnimaFinish(arg0_17)
	local var0_17 = arg0_17:findTF("main/conditions")

	SetActive(var0_17, true)

	local var1_17 = arg0_17.contextData.stageId
	local var2_17 = pg.expedition_data_template[var1_17]

	local function var3_17(arg0_18)
		if type(arg0_18) == "table" then
			local var0_18 = i18n(var0_0.ObjectiveList[arg0_18[1]], arg0_18[2])

			arg0_17:setCondition(var0_18, var0_0.objectiveCheck(arg0_18[1], arg0_17.contextData))
		end
	end

	var3_17(var2_17.objective_1)
	var3_17(var2_17.objective_2)
	var3_17(var2_17.objective_3)

	local var4_17 = LeanTween.delayedCall(1, System.Action(function()
		arg0_17._stateFlag = var0_0.STATE_REPORTED

		SetActive(arg0_17:findTF("jieuan01/tips", arg0_17._bg), true)

		if arg0_17.skipFlag then
			arg0_17:skip()
		end
	end))

	table.insert(arg0_17._delayLeanList, var4_17.id)

	arg0_17._stateFlag = var0_0.STATE_REPORT
end

function var0_0.objectiveCheck(arg0_20, arg1_20)
	if arg0_20 == 1 or arg0_20 == 4 or arg0_20 == 8 then
		return arg1_20.score > 1
	elseif arg0_20 == 2 or arg0_20 == 3 then
		return not arg1_20.statistics._deadUnit
	elseif arg0_20 == 6 then
		return arg1_20.statistics._boss_destruct < 1
	elseif arg0_20 == 5 then
		return not arg1_20.statistics._badTime
	elseif arg0_20 == 7 then
		return true
	end
end

function var0_0.setCondition(arg0_21, arg1_21, arg2_21)
	local var0_21 = cloneTplTo(arg0_21._conditionTpl, arg0_21._conditionContainer)

	setActive(var0_21, false)

	local var1_21
	local var2_21 = var0_21:Find("text"):GetComponent(typeof(Text))

	if arg2_21 == nil then
		var1_21 = "resources/condition_check"
		var2_21.text = setColorStr(arg1_21, "#FFFFFFFF")
	elseif arg2_21 == true then
		var1_21 = "resources/condition_done"
		var2_21.text = setColorStr(arg1_21, "#FFFFFFFF")
	else
		var1_21 = "resources/condition_fail"
		var2_21.text = setColorStr(arg1_21, "#FFFFFF80")
	end

	arg0_21:setSpriteTo(var1_21, var0_21:Find("checkBox"), true)

	local var3_21 = arg0_21._conditionContainer.childCount - 1

	if var3_21 > 0 then
		local var4_21 = LeanTween.delayedCall(var0_0.CONDITIONS_FREQUENCE * var3_21, System.Action(function()
			setActive(var0_21, true)
		end))

		table.insert(arg0_21._delayLeanList, var4_21.id)
	else
		setActive(var0_21, true)
	end
end

function var0_0.showRewardInfo(arg0_23)
	arg0_23._stateFlag = var0_0.STATE_REWARD

	if arg0_23.contextData.system == SYSTEM_BOSS_RUSH or arg0_23.contextData.system == SYSTEM_BOSS_RUSH_EX then
		arg0_23:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)

		return
	end

	SetActive(arg0_23:findTF("jieuan01/tips", arg0_23._bg), false)
	setParent(arg0_23._tf, arg0_23.UIMain)

	local var0_23

	local function var1_23()
		if var0_23 and coroutine.status(var0_23) == "suspended" then
			local var0_24, var1_24 = coroutine.resume(var0_23)

			assert(var0_24, var1_24)
		end
	end

	var0_23 = coroutine.create(function()
		local var0_25 = arg0_23.contextData.drops
		local var1_25 = getProxy(ActivityProxy)
		local var2_25 = var1_25:getActivityById(ActivityConst.UTAWARERU_ACTIVITY_PT_ID)

		if var2_25 and not var2_25:isEnd() then
			local var3_25 = var2_25:getConfig("config_client").pt_id
			local var4_25 = _.detect(var1_25:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_26)
				return arg0_26:getConfig("config_id") == var3_25
			end):getData1()

			if var4_25 >= 1500 then
				local var5_25 = var4_25 - 1500
				local var6_25 = _.detect(var0_25, function(arg0_27)
					return arg0_27.type == DROP_TYPE_RESOURCE and arg0_27.id == var3_25
				end)

				var0_25 = _.filter(var0_25, function(arg0_28)
					return arg0_28.type ~= DROP_TYPE_RESOURCE or arg0_28.id ~= var3_25
				end)

				if var6_25 and var5_25 < var6_25.count then
					var6_25.count = var6_25.count - var5_25

					table.insert(var0_25, var6_25)
				end
			end
		end

		local var7_25 = {}

		for iter0_25, iter1_25 in ipairs(arg0_23.contextData.drops) do
			table.insert(var7_25, iter1_25)
		end

		for iter2_25, iter3_25 in ipairs(arg0_23.contextData.extraDrops) do
			iter3_25.riraty = true

			table.insert(var7_25, iter3_25)
		end

		local var8_25 = false
		local var9_25 = arg0_23.contextData.extraBuffList

		for iter4_25, iter5_25 in ipairs(var9_25) do
			if pg.benefit_buff_template[iter5_25].benefit_type == Chapter.OPERATION_BUFF_TYPE_REWARD then
				var8_25 = true

				break
			end
		end

		local var10_25 = PlayerConst.BonusItemMarker(var0_25)

		if table.getCount(var10_25) > 0 then
			local var11_25 = arg0_23.skipFlag
			local var12_25 = false

			if arg0_23.contextData.system == SYSTEM_SCENARIO then
				local var13_25 = getProxy(ChapterProxy):getActiveChapter(true)

				if var13_25 then
					if var13_25:isLoop() then
						getProxy(ChapterProxy):AddExtendChapterDataArray(var13_25.id, "TotalDrops", var7_25)

						var12_25 = getProxy(ChapterProxy):GetChapterAutoFlag(var13_25.id) == 1
					end

					var13_25:writeDrops(var7_25)
				end
			elseif arg0_23.contextData.system == SYSTEM_ACT_BOSS then
				if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
					getProxy(ChapterProxy):AddActBossRewards(var7_25)
				end
			elseif arg0_23.contextData.system == SYSTEM_BOSS_SINGLE and getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
				getProxy(ChapterProxy):AddBossSingleRewards(var7_25)
			end

			arg0_23:emit(BaseUI.ON_AWARD, {
				items = var7_25,
				extraBonus = var8_25,
				removeFunc = var1_23,
				closeOnCompleted = var11_25
			})
			coroutine.yield()

			local var14_25 = #_.filter(var7_25, function(arg0_29)
				return arg0_29.type == DROP_TYPE_SHIP
			end)
			local var15_25 = getProxy(BayProxy):getNewShip(true)

			for iter6_25 = math.max(1, #var15_25 - var14_25 + 1), #var15_25 do
				local var16_25 = var15_25[iter6_25]

				if PlayerPrefs.GetInt(DISPLAY_SHIP_GET_EFFECT) == 1 or var16_25.virgin or var16_25:getRarity() >= ShipRarity.Purple then
					local var17_25 = var12_25 and not var16_25.virgin and 3 or nil

					arg0_23:emit(BattleResultMediator.GET_NEW_SHIP, var16_25, var1_23, var17_25)
					coroutine.yield()
				end
			end
		end

		setParent(arg0_23._tf, arg0_23.overlay)
		arg0_23:displayBG()
	end)

	var1_23()
end

function var0_0.displayBG(arg0_30)
	local function var0_30()
		arg0_30:displayShips()
		arg0_30:displayPlayerInfo()
		arg0_30:displayerCommanders()
		arg0_30:initMetaBtn()

		arg0_30._stateFlag = var0_0.STATE_DISPLAY

		if arg0_30.skipFlag then
			arg0_30:skip()
		end
	end

	local var1_30 = rtf(arg0_30._grade)

	LeanTween.moveX(rtf(arg0_30._conditions), 1300, var0_0.DURATION_MOVE)
	LeanTween.scale(arg0_30._grade, Vector3(0.6, 0.6, 0), var0_0.DURATION_MOVE)
	LeanTween.moveLocal(go(var1_30), arg0_30._gradeUpperLeftPos, var0_0.DURATION_MOVE)
	setActive(arg0_30:findTF("jieuan01/Bomb", arg0_30._bg), false)
	onDelayTick(function()
		setLocalScale(arg0_30._grade, Vector3(0.6, 0.6, 0))
		setAnchoredPosition(arg0_30._grade, arg0_30._gradeUpperLeftPos)
		var0_30()
	end, var0_0.DURATION_MOVE)
end

function var0_0.displayPlayerInfo(arg0_33)
	local var0_33 = arg0_33:calcPlayerProgress()

	SetActive(arg0_33._leftPanel, true)
	SetActive(arg0_33._playerExp, true)

	arg0_33._main:GetComponent("Animator").enabled = true

	local var1_33 = LeanTween.moveX(rtf(arg0_33._leftPanel), 0, 0.5):setOnComplete(System.Action(function()
		local var0_34 = LeanTween.value(go(arg0_33._tf), 0, var0_33, 1):setOnUpdate(System.Action_float(function(arg0_35)
			setText(arg0_33._playerBonusExp, "+" .. math.floor(arg0_35))
		end))

		table.insert(arg0_33._delayLeanList, var0_34.id)
	end))

	table.insert(arg0_33._delayLeanList, var1_33.id)
end

function var0_0.calcPlayerExp(arg0_36)
	local var0_36 = arg0_36.contextData.oldPlayer
	local var1_36 = var0_36.level
	local var2_36 = arg0_36.player.level
	local var3_36 = arg0_36.player.exp - var0_36.exp

	while var1_36 < var2_36 do
		var3_36 = var3_36 + pg.user_level[var1_36].exp
		var1_36 = var1_36 + 1
	end

	if var1_36 == pg.user_level[#pg.user_level].level then
		var3_36 = 0
	end

	return var3_36
end

function var0_0.calcPlayerRank(arg0_37)
	local var0_37 = arg0_37.contextData.oldRank
	local var1_37 = var0_37.score

	return arg0_37.season.score - var0_37.score
end

function var0_0.displayShips(arg0_38)
	local var0_38 = {}
	local var1_38 = arg0_38.shipVOs

	for iter0_38, iter1_38 in ipairs(var1_38) do
		var0_38[iter1_38.id] = iter1_38
	end

	local var2_38 = arg0_38.contextData.statistics

	for iter2_38, iter3_38 in ipairs(var1_38) do
		if var2_38[iter3_38.id] then
			var2_38[iter3_38.id].vo = iter3_38
		end
	end

	local var3_38
	local var4_38

	if var2_38.mvpShipID == -1 then
		var4_38 = 0

		for iter4_38, iter5_38 in ipairs(arg0_38.contextData.oldMainShips) do
			var4_38 = math.max(var2_38[iter5_38.id].output, var4_38)
		end
	elseif var2_38.mvpShipID and var2_38.mvpShipID ~= 0 then
		var3_38 = var2_38[var2_38.mvpShipID]
		var4_38 = var3_38.output
	else
		var4_38 = 0
	end

	local var5_38 = arg0_38.contextData.oldMainShips

	arg0_38._atkFuncs = {}

	local var6_38
	local var7_38

	SetActive(arg0_38._atkToggle, #var5_38 > 6)

	if #var5_38 > 6 then
		onToggle(arg0_38, arg0_38._atkToggle, function(arg0_39)
			SetActive(arg0_38._atkContainer, arg0_39)
			SetActive(arg0_38._atkContainerNext, not arg0_39)

			if arg0_39 then
				arg0_38:skipAtkAnima(arg0_38._atkContainerNext)
			else
				arg0_38:skipAtkAnima(arg0_38._atkContainer)
			end
		end, SFX_PANEL)
	end

	local var8_38 = {}
	local var9_38 = {}

	for iter6_38, iter7_38 in ipairs(var5_38) do
		local var10_38 = var0_38[iter7_38.id]

		if var2_38[iter7_38.id] then
			local var11_38 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter7_38.configId).type
			local var12_38 = table.contains(TeamType.SubShipType, var11_38)
			local var13_38
			local var14_38
			local var15_38 = 0
			local var16_38

			if iter6_38 > 6 then
				var14_38 = arg0_38._atkContainerNext
				var16_38 = 7
			else
				var14_38 = arg0_38._atkContainer
				var16_38 = 1
			end

			local var17_38 = cloneTplTo(arg0_38._atkTpl, var14_38)
			local var18_38 = var17_38.localPosition

			var18_38.x = var18_38.x + (iter6_38 - var16_38) * 74
			var18_38.y = var18_38.y + (iter6_38 - var16_38) * -124
			var17_38.localPosition = var18_38

			local var19_38 = findTF(var17_38, "result/stars")
			local var20_38 = findTF(var17_38, "result/stars/star_tpl")
			local var21_38 = iter7_38:getStar()
			local var22_38 = iter7_38:getMaxStar()

			while var22_38 > 0 do
				local var23_38 = cloneTplTo(var20_38, var19_38)

				SetActive(var23_38:Find("empty"), var21_38 < var22_38)
				SetActive(var23_38:Find("star"), var22_38 <= var21_38)

				var22_38 = var22_38 - 1
			end

			local var24_38 = arg0_38:findTF("result/mask/icon", var17_38)
			local var25_38 = arg0_38:findTF("result/type", var17_38)

			var24_38:GetComponent(typeof(Image)).sprite = LoadSprite("herohrzicon/" .. iter7_38:getPainting())

			local var26_38 = var2_38[iter7_38.id].output / var4_38
			local var27_38 = GetSpriteFromAtlas("shiptype", shipType2print(iter7_38:getShipType()))

			setImageSprite(var25_38, var27_38, true)
			arg0_38:setAtkAnima(var17_38, var14_38, var26_38, var4_38, var3_38 and iter7_38.id == var3_38.id, var2_38[iter7_38.id].output, var2_38[iter7_38.id].kill_count)

			local var28_38
			local var29_38 = false

			if var3_38 and iter7_38.id == var3_38.id then
				var29_38 = true
				arg0_38.mvpShipVO = iter7_38

				local var30_38
				local var31_38
				local var32_38

				if arg0_38.contextData.score > 1 then
					local var33_38, var34_38

					var33_38, var32_38, var34_38 = ShipWordHelper.GetWordAndCV(arg0_38.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, arg0_38.mvpShipVO:getCVIntimacy())
				else
					local var35_38, var36_38

					var35_38, var32_38, var36_38 = ShipWordHelper.GetWordAndCV(arg0_38.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_LOSE)
				end

				if var32_38 then
					arg0_38:stopVoice()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var32_38, function(arg0_40)
						arg0_38._currentVoice = arg0_40
					end)
				end
			end

			if iter7_38.id == var2_38._flagShipID then
				arg0_38.flagShipVO = iter7_38
			end

			local var37_38
			local var38_38 = arg0_38.shipBuff and arg0_38.shipBuff[iter7_38:getGroupId()]

			if arg0_38.expBuff or var38_38 then
				var37_38 = arg0_38.expBuff and arg0_38.expBuff:getConfig("name") or var38_38 and i18n("Word_Ship_Exp_Buff")
			end

			local var39_38

			if not var12_38 then
				local var40_38 = cloneTplTo(arg0_38._extpl, arg0_38._expContainer)

				var39_38 = BattleResultShipCard.New(var40_38)

				table.insert(arg0_38._shipResultCardList, var39_38)

				if var7_38 then
					var7_38:ConfigCallback(function()
						var39_38:Play()
					end)
				else
					var39_38:Play()
				end

				var7_38 = var39_38
			else
				local var41_38 = cloneTplTo(arg0_38._extpl, arg0_38._subExpContainer)

				var39_38 = BattleResultShipCard.New(var41_38)

				table.insert(arg0_38._subShipResultCardList, var39_38)

				if not var6_38 then
					arg0_38._subFirstExpCard = var39_38
				else
					var6_38:ConfigCallback(function()
						var39_38:Play()
					end)
				end

				var6_38 = var39_38
			end

			var39_38:SetShipVO(iter7_38, var10_38, var29_38, var37_38)
		end
	end

	if var7_38 then
		var7_38:ConfigCallback(function()
			arg0_38._stateFlag = var0_0.STATE_DISPLAYED

			if not arg0_38._subFirstExpCard then
				arg0_38:skip()
			end
		end)
	end

	if var6_38 then
		var6_38:ConfigCallback(function()
			arg0_38._stateFlag = var0_0.STATE_SUB_DISPLAYED

			arg0_38:skip()
		end)
	end
end

function var0_0.stopVoice(arg0_45)
	if arg0_45._currentVoice then
		arg0_45._currentVoice:PlaybackStop()

		arg0_45._currentVoice = nil
	end
end

function var0_0.setAtkAnima(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46, arg5_46, arg6_46, arg7_46)
	local var0_46 = arg0_46:findTF("result", arg1_46)
	local var1_46 = arg0_46:findTF("result/atk", arg1_46)
	local var2_46 = arg0_46:findTF("result/dmg_progress/progress_bar", arg1_46)
	local var3_46 = arg0_46:findTF("result/killCount", arg1_46)
	local var4_46 = var0_46:GetComponent(typeof(DftAniEvent))

	setText(var1_46, 0)
	setText(var3_46, 0)

	var2_46:GetComponent(typeof(Image)).fillAmount = 0

	if arg5_46 then
		local var5_46 = arg0_46:findTF("result/mvpBG", arg1_46)

		setParent(arg0_46._mvpFX, var5_46)

		arg0_46._mvpFX.localPosition = Vector3(-368.5, 0, 0)

		setActive(var5_46, true)
		setActive(arg0_46:findTF("result/bg", arg1_46), false)
	end

	var4_46:SetEndEvent(function(arg0_47)
		if arg5_46 then
			setActive(arg0_46._mvpFX, true)
		end

		LeanTween.value(go(var0_46), 0, arg3_46, arg3_46):setOnUpdate(System.Action_float(function(arg0_48)
			var2_46:GetComponent(typeof(Image)).fillAmount = arg0_48
		end))

		if arg4_46 ~= 0 then
			LeanTween.value(go(var0_46), 0, arg6_46, arg3_46):setOnUpdate(System.Action_float(function(arg0_49)
				setText(var1_46, math.floor(arg0_49))
			end))
			LeanTween.value(go(var0_46), 0, arg7_46, arg3_46):setOnUpdate(System.Action_float(function(arg0_50)
				setText(var3_46, math.floor(arg0_50))
			end))
		end
	end)

	if arg2_46.childCount > 1 then
		arg0_46:findTF("result", arg2_46:GetChild(arg2_46.childCount - 2)):GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0_51)
			setActive(var0_46, true)
		end)
	else
		setActive(var0_46, true)
	end

	local function var6_46()
		var2_46:GetComponent(typeof(Image)).fillAmount = arg3_46

		setText(var1_46, arg6_46)
		setText(var3_46, arg7_46)

		var0_46.localPosition = Vector3(280, 46, 0)
		var0_46:GetComponent(typeof(Animator)).enabled = false

		setActive(var0_46, true)
		setActive(arg0_46._mvpFX, true)
	end

	if arg0_46._atkFuncs[arg2_46] == nil then
		arg0_46._atkFuncs[arg2_46] = {}
	end

	table.insert(arg0_46._atkFuncs[arg2_46], var6_46)
end

function var0_0.skipAtkAnima(arg0_53, arg1_53)
	if arg0_53._atkFuncs[arg1_53] then
		for iter0_53, iter1_53 in ipairs(arg0_53._atkFuncs[arg1_53]) do
			iter1_53()
		end

		arg0_53._atkFuncs[arg1_53] = nil
	end
end

function var0_0.showPainting(arg0_54)
	local var0_54
	local var1_54
	local var2_54

	SetActive(arg0_54._painting, true)

	if arg0_54.contextData.score > 1 then
		local var3_54 = arg0_54.mvpShipVO or arg0_54.flagShipVO

		arg0_54.paintingName = var3_54:getPainting()

		local var4_54 = var3_54:getCVIntimacy()

		setPaintingPrefabAsync(arg0_54._painting, arg0_54.paintingName, "jiesuan", function()
			if findTF(arg0_54._painting, "fitter").childCount > 0 then
				ShipExpressionHelper.SetExpression(findTF(arg0_54._painting, "fitter"):GetChild(0), arg0_54.paintingName, "win_mvp", var4_54)
			end
		end)

		local var5_54, var6_54

		var5_54, var6_54, var1_54 = ShipWordHelper.GetWordAndCV(var3_54.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, var4_54)

		SetActive(arg0_54._failPainting, false)
	else
		local var7_54 = arg0_54.contextData.oldMainShips
		local var8_54 = var7_54[math.random(#var7_54)]
		local var9_54, var10_54

		var9_54, var10_54, var1_54 = ShipWordHelper.GetWordAndCV(var8_54.skinId, ShipWordHelper.WORD_TYPE_LOSE)
	end

	setText(arg0_54._chat:Find("Text"), var1_54)

	local var11_54 = arg0_54._chat:Find("Text"):GetComponent(typeof(Text))

	if #var11_54.text > CHAT_POP_STR_LEN then
		var11_54.alignment = TextAnchor.MiddleLeft
	else
		var11_54.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0_54._chat, true)

	arg0_54._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(arg0_54._painting))
	LeanTween.moveX(rtf(arg0_54._painting), 50, 0.25):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_54._chat.gameObject), Vector3.New(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
			arg0_54._statisticsBtn:GetComponent("Button").enabled = true
			arg0_54._confirmBtn:GetComponent("Button").enabled = true
			arg0_54._atkBG:GetComponent("Button").enabled = true
		end))
	end))
end

function var0_0.hidePainting(arg0_58)
	SetActive(arg0_58._chat, false)

	arg0_58._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(arg0_58._painting))
	LeanTween.scale(rtf(arg0_58._chat.gameObject), Vector3.New(0, 0, 0), 0.1):setEase(LeanTweenType.easeOutBack)
	LeanTween.moveX(rtf(arg0_58._painting), 720, 0.2):setOnComplete(System.Action(function()
		SetActive(arg0_58._painting, false)
	end))
end

function var0_0.skip(arg0_60)
	for iter0_60, iter1_60 in ipairs(arg0_60._delayLeanList) do
		LeanTween.cancel(iter1_60)
	end

	if arg0_60._stateFlag == var0_0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0_60._stateFlag == var0_0.STATE_REPORT then
		local var0_60 = arg0_60._conditionContainer.childCount

		while var0_60 > 0 do
			SetActive(arg0_60._conditionContainer:GetChild(var0_60 - 1), true)

			var0_60 = var0_60 - 1
		end

		SetActive(arg0_60:findTF("jieuan01/tips", arg0_60._bg), true)

		arg0_60._stateFlag = var0_0.STATE_REPORTED

		arg0_60:skip()
	elseif arg0_60._stateFlag == var0_0.STATE_REPORTED then
		arg0_60:showRewardInfo()
	elseif arg0_60._stateFlag == var0_0.STATE_REWARD then
		-- block empty
	elseif arg0_60._stateFlag == var0_0.STATE_DISPLAY then
		for iter2_60, iter3_60 in ipairs(arg0_60._shipResultCardList) do
			iter3_60:SkipAnimation()
		end

		arg0_60._stateFlag = var0_0.STATE_DISPLAYED

		setText(arg0_60._playerBonusExp, "+" .. arg0_60:calcPlayerProgress())

		if not arg0_60._subFirstExpCard then
			arg0_60:playSubExEnter()
		elseif arg0_60.skipFlag then
			arg0_60:skip()
		end
	elseif arg0_60._stateFlag == var0_0.STATE_DISPLAYED then
		setText(arg0_60._playerBonusExp, "+" .. arg0_60:calcPlayerProgress())
		arg0_60:playSubExEnter()
	elseif arg0_60._stateFlag == var0_0.STATE_SUB_DISPLAY then
		for iter4_60, iter5_60 in ipairs(arg0_60._subShipResultCardList) do
			iter5_60:SkipAnimation()
		end

		arg0_60._stateFlag = var0_0.STATE_SUB_DISPLAYED

		if arg0_60.skipFlag then
			arg0_60:skip()
		end
	elseif arg0_60._stateFlag == var0_0.STATE_SUB_DISPLAYED then
		arg0_60:showRightBottomPanel()
	end
end

function var0_0.playSubExEnter(arg0_61)
	arg0_61._stateFlag = var0_0.STATE_SUB_DISPLAY

	if arg0_61._subFirstExpCard then
		triggerToggle(arg0_61._subToggle, false)
		arg0_61._subFirstExpCard:Play()
	else
		arg0_61:showRightBottomPanel()
	end

	if arg0_61.skipFlag then
		arg0_61:skip()
	end
end

function var0_0.showRightBottomPanel(arg0_62)
	SetActive(arg0_62._skipBtn, false)
	SetActive(arg0_62._rightBottomPanel, true)
	SetActive(arg0_62._subToggle, arg0_62._subFirstExpCard ~= nil)
	onButton(arg0_62, arg0_62._statisticsBtn, function()
		if arg0_62._atkBG.gameObject.activeSelf then
			arg0_62:closeStatistics()
		else
			arg0_62:showStatistics()
		end
	end, SFX_PANEL)
	onButton(arg0_62, arg0_62._confirmBtn, function()
		if arg0_62.failTag == true then
			arg0_62:emit(BattleResultMediator.PRE_BATTLE_FAIL_EXIT)
			arg0_62:emit(BattleResultMediator.OPEN_FAIL_TIP_LAYER)
		else
			arg0_62:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
		end
	end, SFX_CONFIRM)
	onButton(arg0_62, arg0_62._atkBG, function()
		arg0_62:closeStatistics()
	end, SFX_CANCEL)

	arg0_62._stateFlag = nil
	arg0_62._subFirstExpCard = nil

	if arg0_62.skipFlag then
		triggerButton(arg0_62._confirmBtn)
	end
end

function var0_0.showStatistics(arg0_66)
	setActive(arg0_66._leftPanel, false)
	arg0_66:enabledStatisticsGizmos(false)
	SetActive(arg0_66._atkBG, true)

	arg0_66._atkBG:GetComponent("Button").enabled = false
	arg0_66._confirmBtn:GetComponent("Button").enabled = false
	arg0_66._statisticsBtn:GetComponent("Button").enabled = false

	arg0_66:showPainting()
	LeanTween.moveX(rtf(arg0_66._atkPanel), 0, 0.25):setOnComplete(System.Action(function()
		SetActive(arg0_66._atkContainer, true)
	end))
end

function var0_0.closeStatistics(arg0_68)
	setActive(arg0_68._leftPanel, true)
	arg0_68:skipAtkAnima(arg0_68._atkContainerNext)
	arg0_68:skipAtkAnima(arg0_68._atkContainer)
	arg0_68:enabledStatisticsGizmos(true)
	arg0_68:hidePainting()

	arg0_68._atkBG:GetComponent("Button").enabled = false

	LeanTween.cancel(arg0_68._atkPanel.gameObject)
	LeanTween.moveX(rtf(arg0_68._atkPanel), -700, 0.2):setOnComplete(System.Action(function()
		SetActive(arg0_68._atkBG, false)
	end))
end

function var0_0.enabledStatisticsGizmos(arg0_70, arg1_70)
	setActive(arg0_70:findTF("gizmos/xuxian_down", arg0_70._main), arg1_70)
	setActive(arg0_70:findTF("gizmos/xuxian_middle", arg0_70._main), arg1_70)
end

function var0_0.PlayAnimation(arg0_71, arg1_71, arg2_71, arg3_71, arg4_71, arg5_71, arg6_71)
	LeanTween.value(arg1_71.gameObject, arg2_71, arg3_71, arg4_71):setDelay(arg5_71):setOnUpdate(System.Action_float(function(arg0_72)
		arg6_71(arg0_72)
	end))
end

function var0_0.SetSkipFlag(arg0_73, arg1_73)
	arg0_73.skipFlag = arg1_73
end

function var0_0.initMetaBtn(arg0_74)
	arg0_74.metaBtn = arg0_74:findTF("MetaBtn", arg0_74._main)

	local var0_74 = getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList()

	setActive(arg0_74.metaBtn, var0_74 and #var0_74 > 0 or false)
	onButton(arg0_74, arg0_74.metaBtn, function()
		setActive(arg0_74.metaBtn, false)

		if not arg0_74.metaExpView then
			arg0_74.metaExpView = BattleResultMetaExpView.New(arg0_74._blurConatiner, arg0_74.event, arg0_74.contextData)

			arg0_74.metaExpView:Reset()
			arg0_74.metaExpView:Load()
			arg0_74.metaExpView:setData(var0_74, function()
				if arg0_74.metaBtn then
					setActive(arg0_74.metaBtn, true)
				end

				arg0_74.metaExpView = nil
			end)
			arg0_74.metaExpView:ActionInvoke("Show")
			arg0_74.metaExpView:ActionInvoke("openPanel")
		end
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_77)
	if arg0_77.metaExpView then
		arg0_77.metaExpView:closePanel()

		arg0_77.metaExpView = nil

		return
	end

	if arg0_77._stateFlag == var0_0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0_77._stateFlag == var0_0.STATE_REPORT then
		triggerButton(arg0_77._bg)
	elseif arg0_77._stateFlag == var0_0.STATE_REPORTED then
		triggerButton(arg0_77._skipBtn)
	elseif arg0_77._stateFlag == var0_0.STATE_DISPLAY then
		triggerButton(arg0_77._skipBtn)
	else
		triggerButton(arg0_77._confirmBtn)
	end
end

function var0_0.willExit(arg0_78)
	for iter0_78, iter1_78 in ipairs(arg0_78._shipResultCardList) do
		iter1_78:Dispose()
	end

	for iter2_78, iter3_78 in ipairs(arg0_78._subShipResultCardList) do
		iter3_78:Dispose()
	end

	arg0_78._atkFuncs = nil

	LeanTween.cancel(go(arg0_78._tf))

	if arg0_78._atkBG.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_78._blurConatiner, arg0_78._tf)
	end

	if arg0_78.paintingName then
		retPaintingPrefab(arg0_78._painting, arg0_78.paintingName)
	end

	if arg0_78._rightTimer then
		arg0_78._rightTimer:Stop()
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_78._tf)
	arg0_78:stopVoice()
	getProxy(MetaCharacterProxy):clearLastMetaSkillExpInfoList()

	if arg0_78.metaExpView then
		arg0_78.metaExpView:Destroy()

		arg0_78.metaExpView = nil
	end

	pg.CameraFixMgr.GetInstance():disconnect(arg0_78.camEventId)
end

return var0_0
