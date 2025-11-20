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

function var0_0.getGroupName(arg0_2)
	return "BattleScene"
end

function var0_0.setRivalVO(arg0_3, arg1_3)
	arg0_3.rivalVO = arg1_3
end

function var0_0.setRank(arg0_4, arg1_4, arg2_4)
	arg0_4.player = arg1_4
	arg0_4.season = arg2_4

	setText(arg0_4._playerName, "<color=#FFFFFF>" .. arg0_4.player.name .. "</color><size=32> / C O M M A N D E R</size>")

	local var0_4 = SeasonInfo.getMilitaryRank(arg2_4.score, arg2_4.rank)
	local var1_4, var2_4 = SeasonInfo.getNextMilitaryRank(arg2_4.score, arg2_4.rank)

	setText(arg0_4._playerLv, var0_4.name)
	setText(arg0_4._playerExpLabel, i18n("word_rankScore"))

	arg0_4._playerExpProgress:GetComponent(typeof(Image)).fillAmount = arg2_4.score / var2_4

	setText(arg0_4._playerBonusExp, "+0")

	arg0_4.calcPlayerProgress = arg0_4.calcPlayerRank
end

function var0_0.setShips(arg0_5, arg1_5)
	arg0_5.shipVOs = arg1_5
end

function var0_0.setPlayer(arg0_6, arg1_6)
	arg0_6.player = arg1_6

	setText(arg0_6._playerName, "<color=#FFFFFF>" .. arg0_6.player.name .. "</color><size=32> / C O M M A N D E R</size>")
	setText(arg0_6._playerLv, "Lv." .. arg0_6.player.level)

	local var0_6 = getConfigFromLevel1(pg.user_level, arg0_6.player.level)

	arg0_6._playerExpProgress:GetComponent(typeof(Image)).fillAmount = arg0_6.player.exp / var0_6.exp_interval

	if arg0_6.player.level == pg.user_level[#pg.user_level].level then
		arg0_6._playerExpProgress:GetComponent(typeof(Image)).fillAmount = 1
	end

	setText(arg0_6._playerBonusExp, "+0")

	arg0_6.calcPlayerProgress = arg0_6.calcPlayerExp

	local var1_6 = arg0_6.contextData.extraBuffList

	for iter0_6, iter1_6 in ipairs(var1_6) do
		if pg.benefit_buff_template[iter1_6].benefit_type == Chapter.OPERATION_BUFF_TYPE_EXP then
			setActive(arg0_6._playerExpExtra, true)
		end
	end
end

function var0_0.setExpBuff(arg0_7, arg1_7, arg2_7)
	arg0_7.expBuff = arg1_7
	arg0_7.shipBuff = arg2_7
end

function var0_0.init(arg0_8)
	arg0_8._grade = arg0_8._tf:Find("grade")
	arg0_8._levelText = arg0_8._grade:Find("chapterName/Text22")
	arg0_8.clearFX = arg0_8._tf:Find("clear")
	arg0_8._main = arg0_8._tf:Find("main")
	arg0_8._blurConatiner = arg0_8._tf:Find("blur_container")
	arg0_8._bg = arg0_8._tf:Find("main/jiesuanbeijing")
	arg0_8._painting = arg0_8._blurConatiner:Find("painting")
	arg0_8._failPainting = arg0_8._painting:Find("fail")
	arg0_8._chat = arg0_8._painting:Find("chat")
	arg0_8._leftPanel = arg0_8._main:Find("leftPanel")
	arg0_8._expResult = arg0_8._leftPanel:Find("expResult")
	arg0_8._expContainer = arg0_8._expResult:Find("expContainer")
	arg0_8._extpl = arg0_8:getTpl("ShipCardTpl", arg0_8._expContainer)
	arg0_8._playerExp = arg0_8._leftPanel:Find("playerExp")
	arg0_8._playerName = arg0_8._playerExp:Find("name_text")
	arg0_8._playerLv = arg0_8._playerExp:Find("lv_text")
	arg0_8._playerExpLabel = arg0_8._playerExp:Find("exp_label")
	arg0_8._playerExpProgress = arg0_8._playerExp:Find("exp_progress")
	arg0_8._playerBonusExp = arg0_8._playerExp:Find("exp_text")
	arg0_8._playerExpExtra = arg0_8._playerExp:Find("operation_bonus")
	arg0_8._atkBG = arg0_8._blurConatiner:Find("atkPanel")
	arg0_8._atkPanel = arg0_8._atkBG:Find("atkResult")
	arg0_8._atkResult = arg0_8._atkBG:Find("atkResult/result")
	arg0_8._atkContainer = arg0_8._atkResult:Find("Grid")
	arg0_8._atkContainerNext = arg0_8._atkResult:Find("Grid_next")
	arg0_8._atkToggle = arg0_8._atkPanel:Find("switchAtk")
	arg0_8._atkTpl = arg0_8:getTpl("resulttpl", arg0_8._atkResult)
	arg0_8._mvpFX = arg0_8._atkPanel:Find("mvpFX")
	arg0_8._rightBottomPanel = arg0_8._blurConatiner:Find("rightBottomPanel")
	arg0_8._confirmBtn = arg0_8._rightBottomPanel:Find("confirmBtn")

	setText(arg0_8._confirmBtn:Find("Text"), i18n("text_confirm"))

	arg0_8._statisticsBtn = arg0_8._rightBottomPanel:Find("statisticsBtn")
	arg0_8._subExpResult = arg0_8._leftPanel:Find("subExpResult")
	arg0_8._subExpContainer = arg0_8._subExpResult:Find("expContainer")
	arg0_8._subToggle = arg0_8._leftPanel:Find("switchFleet")

	setActive(arg0_8._subToggle, false)

	arg0_8._skipBtn = arg0_8._tf:Find("skipLayer")
	arg0_8.UIMain = pg.UIMgr.GetInstance().UIMain
	arg0_8.overlay = pg.UIMgr.GetInstance().OverlayMain
	arg0_8._conditions = arg0_8._tf:Find("main/conditions")
	arg0_8._conditionContainer = arg0_8._conditions:Find("bg16/list")
	arg0_8._conditionTpl = arg0_8._conditions:Find("bg16/conditionTpl")
	arg0_8._conditionSubTpl = arg0_8._conditions:Find("bg16/conditionSubTpl")
	arg0_8._conditionContributeTpl = arg0_8._conditions:Find("bg16/conditionContributeTpl")
	arg0_8._conditionBGNormal = arg0_8._conditions:Find("bg16/bg_normal")
	arg0_8._conditionBGContribute = arg0_8._conditions:Find("bg16/bg_contribute")
	arg0_8._cmdExp = arg0_8._leftPanel:Find("commanderExp")
	arg0_8._cmdContainer = arg0_8._cmdExp:Find("commander_container")
	arg0_8._cmdTpl = arg0_8._cmdExp:Find("commander_tpl")

	arg0_8:setGradeLabel()
	SetActive(arg0_8._levelText, false)

	arg0_8._delayLeanList = {}
	arg0_8._ratioFitter = GetComponent(arg0_8._tf, typeof(AspectRatioFitter))
	arg0_8._ratioFitter.enabled = true
	arg0_8._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0_8.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_9, arg1_9)
		arg0_8._ratioFitter.aspectRatio = arg1_9
	end)
end

function var0_0.customsLang(arg0_10)
	setText(findTF(arg0_10._confirmBtn, "Text"), i18n("battle_result_confirm"))
	setText(findTF(arg0_10._bg, "jieuan01/tips/dianjijixu/bg20"), i18n("battle_result_continue"))
	setText(findTF(arg0_10._atkTpl, "result/dmg_count_label"), i18n("battle_result_dmg"))
	setText(findTF(arg0_10._atkTpl, "result/kill_count_label"), i18n("battle_result_kill_count"))
	setText(findTF(arg0_10._subToggle, "on"), i18n("battle_result_toggle_on"))
	setText(findTF(arg0_10._subToggle, "off"), i18n("battle_result_toggle_off"))
	setText(findTF(arg0_10._conditions, "bg17"), i18n("battle_result_targets"))
end

function var0_0.setGradeLabel(arg0_11)
	local var0_11 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1_11 = arg0_11._tf:Find("grade/Xyz/bg13")
	local var2_11 = arg0_11._tf:Find("grade/Xyz/bg14")
	local var3_11
	local var4_11
	local var5_11
	local var6_11 = arg0_11.contextData.score
	local var7_11
	local var8_11 = var6_11 > 0

	setActive(arg0_11._bg:Find("jieuan01/BG/bg_victory"), var8_11)
	setActive(arg0_11._bg:Find("jieuan01/BG/bg_fail"), not var8_11)

	if var8_11 then
		var5_11 = var0_11[var6_11 + 1]
		var3_11 = "battlescore/battle_score_" .. var5_11 .. "/letter_" .. var5_11
		var4_11 = "battlescore/battle_score_" .. var5_11 .. "/label_" .. var5_11
	else
		if arg0_11.contextData.statistics._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
			var5_11 = var0_11[2]
			var7_11 = "flag_destroy"
		else
			var5_11 = var0_11[1]
		end

		var3_11 = "battlescore/battle_score_" .. var5_11 .. "/letter_" .. var5_11
		var4_11 = "battlescore/battle_score_" .. var5_11 .. "/label_" .. (var7_11 or var5_11)
	end

	LoadImageSpriteAsync(var3_11, var1_11, false)
	LoadImageSpriteAsync(var4_11, var2_11, false)

	local var9_11 = arg0_11.contextData.system

	if (var9_11 == SYSTEM_SCENARIO or var9_11 == SYSTEM_ROUTINE or var9_11 == SYSTEM_SUB_ROUTINE or var9_11 == SYSTEM_DUEL) and (var5_11 == var0_11[1] or var5_11 == var0_11[2]) then
		arg0_11.failTag = true
	end
end

function var0_0.displayerCommanders(arg0_12, arg1_12)
	arg0_12.commanderExps = arg0_12.contextData.commanderExps or {}

	local var0_12 = getProxy(CommanderProxy)

	removeAllChildren(arg0_12._cmdContainer)

	local var1_12

	if arg1_12 then
		var1_12 = arg0_12.commanderExps.submarineCMD or {}
	else
		var1_12 = arg0_12.commanderExps.surfaceCMD or {}
	end

	setActive(arg0_12._cmdExp, true)

	for iter0_12, iter1_12 in ipairs(var1_12) do
		local var2_12 = var0_12:getCommanderById(iter1_12.commander_id)
		local var3_12 = cloneTplTo(arg0_12._cmdTpl, arg0_12._cmdContainer)

		GetImageSpriteFromAtlasAsync("commandericon/" .. var2_12:getPainting(), "", var3_12:Find("icon/mask/pic"))
		setText(var3_12:Find("exp/name_text"), var2_12:getName())
		setText(var3_12:Find("exp/lv_text"), "Lv." .. var2_12.level)
		setText(var3_12:Find("exp/exp_text"), "+" .. iter1_12.exp)

		local var4_12
		local var5_12 = var2_12:isMaxLevel() and 1 or iter1_12.curExp / var2_12:getNextLevelExp()

		var3_12:Find("exp/exp_progress"):GetComponent(typeof(Image)).fillAmount = var5_12
	end
end

function var0_0.didEnter(arg0_13)
	arg0_13:setStageName()
	arg0_13:customsLang()

	arg0_13._shipResultCardList, arg0_13._subShipResultCardList = {}, {}

	local var0_13 = rtf(arg0_13._grade)

	arg0_13._gradeUpperLeftPos = var0_13.localPosition
	var0_13.localPosition = Vector3(0, 25, 0)

	arg0_13:BlurPanel(arg0_13._tf, {
		staticBlur = true,
		lockGlobalBlur = true
	})

	if arg0_13.contextData.system ~= SYSTEM_BOSS_RUSH and arg0_13.contextData.system ~= SYSTEM_BOSS_RUSH_EX and arg0_13.contextData.system ~= SYSTEM_BOSS_RUSH_COLLABRATE and arg0_13.contextData.system ~= SYSTEM_ACT_BOSS and arg0_13.contextData.system ~= SYSTEM_BOSS_SINGLE and arg0_13.contextData.system ~= SYSTEM_BOSS_SINGLE_VARIABLE then
		ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCamera(false)
	end

	arg0_13._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0_13._grade, Vector3(0.88, 0.88, 1), var0_0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0_13._levelText, true)
		arg0_13:rankAnimaFinish()
	end))

	arg0_13._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)

	SetActive(arg0_13._atkBG, false)
	onToggle(arg0_13, arg0_13._subToggle, function(arg0_15)
		SetActive(arg0_13._subExpResult, not arg0_15)
		SetActive(arg0_13._expResult, arg0_15)
		setActive(arg0_13._subToggle:Find("off"), not arg0_15)
		arg0_13:displayerCommanders(not arg0_15)
	end, SFX_PANEL)

	arg0_13._stateFlag = var0_0.STATE_RANK_ANIMA

	onButton(arg0_13, arg0_13._skipBtn, function()
		arg0_13:skip()
	end, SFX_CONFIRM)
end

function var0_0.setStageName(arg0_17)
	if arg0_17.contextData.system and arg0_17.contextData.system == SYSTEM_DUEL then
		if arg0_17.rivalVO then
			setText(arg0_17._levelText, arg0_17.rivalVO.name)
		else
			setText(arg0_17._levelText, "")
		end
	else
		local var0_17 = arg0_17.contextData.stageId
		local var1_17 = pg.expedition_data_template[var0_17]

		setText(arg0_17._levelText, var1_17.name)
	end
end

function var0_0.rankAnimaFinish(arg0_18)
	local var0_18 = arg0_18._tf:Find("main/conditions")

	SetActive(var0_18, true)

	local var1_18 = arg0_18.contextData.stageId
	local var2_18 = pg.expedition_data_template[var1_18]

	local function var3_18(arg0_19)
		if type(arg0_19) == "table" then
			local var0_19 = i18n(var0_0.ObjectiveList[arg0_19[1]], arg0_19[2])

			arg0_18:setCondition(var0_19, var0_0.objectiveCheck(arg0_19[1], arg0_18.contextData))
		end
	end

	var3_18(var2_18.objective_1)
	var3_18(var2_18.objective_2)
	var3_18(var2_18.objective_3)

	local var4_18 = LeanTween.delayedCall(1, System.Action(function()
		arg0_18._stateFlag = var0_0.STATE_REPORTED

		SetActive(arg0_18._bg:Find("jieuan01/tips"), true)

		if arg0_18.skipFlag then
			arg0_18:skip()
		end
	end))

	table.insert(arg0_18._delayLeanList, var4_18.id)

	arg0_18._stateFlag = var0_0.STATE_REPORT
end

function var0_0.objectiveCheck(arg0_21, arg1_21)
	if arg0_21 == 1 or arg0_21 == 4 or arg0_21 == 8 then
		return arg1_21.score > 1
	elseif arg0_21 == 2 or arg0_21 == 3 then
		return not arg1_21.statistics._deadUnit
	elseif arg0_21 == 6 then
		return arg1_21.statistics._boss_destruct < 1
	elseif arg0_21 == 5 then
		return not arg1_21.statistics._badTime
	elseif arg0_21 == 7 then
		return true
	end
end

function var0_0.setCondition(arg0_22, arg1_22, arg2_22)
	local var0_22 = cloneTplTo(arg0_22._conditionTpl, arg0_22._conditionContainer)

	setActive(var0_22, false)

	local var1_22
	local var2_22 = var0_22:Find("text"):GetComponent(typeof(Text))

	if arg2_22 == nil then
		var1_22 = "resources/condition_check"
		var2_22.text = setColorStr(arg1_22, "#FFFFFFFF")
	elseif arg2_22 == true then
		var1_22 = "resources/condition_done"
		var2_22.text = setColorStr(arg1_22, "#FFFFFFFF")
	else
		var1_22 = "resources/condition_fail"
		var2_22.text = setColorStr(arg1_22, "#FFFFFF80")
	end

	arg0_22:setSpriteTo(var1_22, var0_22:Find("checkBox"), true)

	local var3_22 = arg0_22._conditionContainer.childCount - 1

	if var3_22 > 0 then
		local var4_22 = LeanTween.delayedCall(var0_0.CONDITIONS_FREQUENCE * var3_22, System.Action(function()
			setActive(var0_22, true)
		end))

		table.insert(arg0_22._delayLeanList, var4_22.id)
	else
		setActive(var0_22, true)
	end
end

function var0_0.showRewardInfo(arg0_24)
	arg0_24._stateFlag = var0_0.STATE_REWARD

	if arg0_24.contextData.system == SYSTEM_BOSS_RUSH or arg0_24.contextData.system == SYSTEM_BOSS_RUSH_EX or arg0_24.contextData.system == SYSTEM_BOSS_RUSH_COLLABRATE then
		arg0_24:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)

		return
	end

	SetActive(arg0_24._bg:Find("jieuan01/tips"), false)
	setParent(arg0_24._tf, arg0_24.UIMain)

	local var0_24

	local function var1_24()
		if var0_24 and coroutine.status(var0_24) == "suspended" then
			local var0_25, var1_25 = coroutine.resume(var0_24)

			assert(var0_25, var1_25)
		end
	end

	var0_24 = coroutine.create(function()
		local var0_26 = arg0_24.contextData.drops
		local var1_26 = getProxy(ActivityProxy)
		local var2_26 = var1_26:getActivityById(ActivityConst.UTAWARERU_ACTIVITY_PT_ID)

		if var2_26 and not var2_26:isEnd() then
			local var3_26 = var2_26:getConfig("config_client").pt_id
			local var4_26 = _.detect(var1_26:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function(arg0_27)
				return arg0_27:getConfig("config_id") == var3_26
			end):getData1()

			if var4_26 >= 1500 then
				local var5_26 = var4_26 - 1500
				local var6_26 = _.detect(var0_26, function(arg0_28)
					return arg0_28.type == DROP_TYPE_RESOURCE and arg0_28.id == var3_26
				end)

				var0_26 = _.filter(var0_26, function(arg0_29)
					return arg0_29.type ~= DROP_TYPE_RESOURCE or arg0_29.id ~= var3_26
				end)

				if var6_26 and var5_26 < var6_26.count then
					var6_26.count = var6_26.count - var5_26

					table.insert(var0_26, var6_26)
				end
			end
		end

		local var7_26 = {}

		for iter0_26, iter1_26 in ipairs(arg0_24.contextData.drops) do
			table.insert(var7_26, iter1_26)
		end

		for iter2_26, iter3_26 in ipairs(arg0_24.contextData.extraDrops) do
			iter3_26.riraty = true

			table.insert(var7_26, iter3_26)
		end

		local var8_26 = false
		local var9_26 = arg0_24.contextData.extraBuffList

		for iter4_26, iter5_26 in ipairs(var9_26) do
			if pg.benefit_buff_template[iter5_26].benefit_type == Chapter.OPERATION_BUFF_TYPE_REWARD then
				var8_26 = true

				break
			end
		end

		if table.getCount(var0_26) > 0 then
			local var10_26 = arg0_24.skipFlag
			local var11_26 = false

			if arg0_24.contextData.system == SYSTEM_SCENARIO then
				local var12_26 = getProxy(ChapterProxy):getActiveChapter(true)

				if var12_26 then
					if var12_26:isLoop() then
						getProxy(ChapterProxy):AddExtendChapterDataArray(var12_26.id, "TotalDrops", var7_26)

						var11_26 = getProxy(ChapterProxy):GetChapterAutoFlag(var12_26.id) == 1
					end

					var12_26:writeDrops(var7_26)
				end
			elseif arg0_24.contextData.system == SYSTEM_ACT_BOSS then
				if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
					getProxy(ChapterProxy):AddActBossRewards(var7_26)
				end
			elseif arg0_24.contextData.system == SYSTEM_BOSS_SINGLE then
				if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
					getProxy(ChapterProxy):AddBossSingleRewards(var7_26)
				end
			elseif arg0_24.contextData.system == SYSTEM_BOSS_SINGLE_VARIABLE then
				-- block empty
			end

			arg0_24:emit(BaseUI.ON_AWARD, {
				items = var7_26,
				extraBonus = var8_26,
				removeFunc = var1_24,
				closeOnCompleted = var10_26
			})
			coroutine.yield()

			local var13_26 = #_.filter(var7_26, function(arg0_30)
				return arg0_30.type == DROP_TYPE_SHIP
			end)
			local var14_26 = getProxy(BayProxy):getNewShip(true)

			for iter6_26 = math.max(1, #var14_26 - var13_26 + 1), #var14_26 do
				local var15_26 = var14_26[iter6_26]

				if PlayerPrefs.GetInt(DISPLAY_SHIP_GET_EFFECT) == 1 or var15_26.virgin or var15_26:getRarity() >= ShipRarity.Purple then
					local var16_26 = var11_26 and not var15_26.virgin and 3 or nil

					arg0_24:emit(BattleResultMediator.GET_NEW_SHIP, var15_26, var1_24, var16_26)
					coroutine.yield()
				end
			end
		end

		setParent(arg0_24._tf, arg0_24.overlay)
		arg0_24:displayBG()
	end)

	var1_24()
end

function var0_0.displayBG(arg0_31)
	local function var0_31()
		arg0_31:displayShips()
		arg0_31:displayPlayerInfo()
		arg0_31:displayerCommanders()
		arg0_31:initMetaBtn()

		arg0_31._stateFlag = var0_0.STATE_DISPLAY

		if arg0_31.skipFlag then
			arg0_31:skip()
		end
	end

	local var1_31 = rtf(arg0_31._grade)

	LeanTween.moveX(rtf(arg0_31._conditions), 1300, var0_0.DURATION_MOVE)
	LeanTween.scale(arg0_31._grade, Vector3(0.6, 0.6, 0), var0_0.DURATION_MOVE)
	LeanTween.moveLocal(go(var1_31), arg0_31._gradeUpperLeftPos, var0_0.DURATION_MOVE)
	setActive(arg0_31._bg:Find("jieuan01/Bomb"), false)
	onDelayTick(function()
		setLocalScale(arg0_31._grade, Vector3(0.6, 0.6, 0))
		setAnchoredPosition(arg0_31._grade, arg0_31._gradeUpperLeftPos)
		var0_31()
	end, var0_0.DURATION_MOVE)
end

function var0_0.displayPlayerInfo(arg0_34)
	local var0_34 = arg0_34:calcPlayerProgress()

	SetActive(arg0_34._leftPanel, true)
	SetActive(arg0_34._playerExp, true)

	arg0_34._main:GetComponent("Animator").enabled = true

	local var1_34 = LeanTween.moveX(rtf(arg0_34._leftPanel), 0, 0.5):setOnComplete(System.Action(function()
		local var0_35 = LeanTween.value(go(arg0_34._tf), 0, var0_34, 1):setOnUpdate(System.Action_float(function(arg0_36)
			setText(arg0_34._playerBonusExp, "+" .. math.floor(arg0_36))
		end))

		table.insert(arg0_34._delayLeanList, var0_35.id)
	end))

	table.insert(arg0_34._delayLeanList, var1_34.id)
end

function var0_0.calcPlayerExp(arg0_37)
	local var0_37 = arg0_37.contextData.oldPlayer
	local var1_37 = var0_37.level
	local var2_37 = arg0_37.player.level
	local var3_37 = arg0_37.player.exp - var0_37.exp

	while var1_37 < var2_37 do
		var3_37 = var3_37 + pg.user_level[var1_37].exp
		var1_37 = var1_37 + 1
	end

	if var1_37 == pg.user_level[#pg.user_level].level then
		var3_37 = 0
	end

	return var3_37
end

function var0_0.calcPlayerRank(arg0_38)
	local var0_38 = arg0_38.contextData.oldRank
	local var1_38 = var0_38.score

	return arg0_38.season.score - var0_38.score
end

function var0_0.displayShips(arg0_39)
	local var0_39 = {}
	local var1_39 = arg0_39.shipVOs

	for iter0_39, iter1_39 in ipairs(var1_39) do
		var0_39[iter1_39.id] = iter1_39
	end

	local var2_39 = arg0_39.contextData.statistics

	for iter2_39, iter3_39 in ipairs(var1_39) do
		if var2_39[iter3_39.id] then
			var2_39[iter3_39.id].vo = iter3_39
		end
	end

	local var3_39
	local var4_39

	if var2_39.mvpShipID == -1 then
		var4_39 = 0

		for iter4_39, iter5_39 in ipairs(arg0_39.contextData.oldMainShips) do
			var4_39 = math.max(var2_39[iter5_39.id].output, var4_39)
		end
	elseif var2_39.mvpShipID and var2_39.mvpShipID ~= 0 then
		var3_39 = var2_39[var2_39.mvpShipID]
		var4_39 = var3_39.output
	else
		var4_39 = 0
	end

	local var5_39 = arg0_39.contextData.oldMainShips

	arg0_39._atkFuncs = {}

	local var6_39
	local var7_39

	SetActive(arg0_39._atkToggle, #var5_39 > 6)

	if #var5_39 > 6 then
		onToggle(arg0_39, arg0_39._atkToggle, function(arg0_40)
			SetActive(arg0_39._atkContainer, arg0_40)
			SetActive(arg0_39._atkContainerNext, not arg0_40)

			if arg0_40 then
				arg0_39:skipAtkAnima(arg0_39._atkContainerNext)
			else
				arg0_39:skipAtkAnima(arg0_39._atkContainer)
			end
		end, SFX_PANEL)
	end

	local var8_39 = {}
	local var9_39 = {}

	for iter6_39, iter7_39 in ipairs(var5_39) do
		local var10_39 = var0_39[iter7_39.id]

		if var2_39[iter7_39.id] then
			local var11_39 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter7_39.configId).type
			local var12_39 = table.contains(TeamType.SubShipType, var11_39)
			local var13_39
			local var14_39
			local var15_39 = 0
			local var16_39

			if iter6_39 > 6 then
				var14_39 = arg0_39._atkContainerNext
				var16_39 = 7
			else
				var14_39 = arg0_39._atkContainer
				var16_39 = 1
			end

			local var17_39 = cloneTplTo(arg0_39._atkTpl, var14_39)
			local var18_39 = var17_39.localPosition

			var18_39.x = var18_39.x + (iter6_39 - var16_39) * 74
			var18_39.y = var18_39.y + (iter6_39 - var16_39) * -124
			var17_39.localPosition = var18_39

			local var19_39 = findTF(var17_39, "result/stars")
			local var20_39 = findTF(var17_39, "result/stars/star_tpl")
			local var21_39 = iter7_39:getStar()
			local var22_39 = iter7_39:getMaxStar()

			while var22_39 > 0 do
				local var23_39 = cloneTplTo(var20_39, var19_39)

				SetActive(var23_39:Find("empty"), var21_39 < var22_39)
				SetActive(var23_39:Find("star"), var22_39 <= var21_39)

				var22_39 = var22_39 - 1
			end

			local var24_39 = var17_39:Find("result/mask/icon")
			local var25_39 = var17_39:Find("result/type")

			var24_39:GetComponent(typeof(Image)).sprite = LoadSprite("herohrzicon/" .. iter7_39:getPainting())

			local var26_39 = var2_39[iter7_39.id].output / var4_39
			local var27_39 = GetSpriteFromAtlas("shiptype", shipType2print(iter7_39:getShipType()))

			setImageSprite(var25_39, var27_39, true)
			arg0_39:setAtkAnima(var17_39, var14_39, var26_39, var4_39, var3_39 and iter7_39.id == var3_39.id, var2_39[iter7_39.id].output, var2_39[iter7_39.id].kill_count)

			local var28_39
			local var29_39 = false

			if var3_39 and iter7_39.id == var3_39.id then
				var29_39 = true
				arg0_39.mvpShipVO = iter7_39

				local var30_39
				local var31_39
				local var32_39

				if arg0_39.contextData.score > 1 then
					local var33_39, var34_39

					var33_39, var32_39, var34_39 = ShipWordHelper.GetWordAndCV(arg0_39.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, arg0_39.mvpShipVO:getCVIntimacy())
				else
					local var35_39, var36_39

					var35_39, var32_39, var36_39 = ShipWordHelper.GetWordAndCV(arg0_39.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_LOSE)
				end

				if var32_39 then
					arg0_39:stopVoice()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var32_39, function(arg0_41)
						arg0_39._currentVoice = arg0_41
					end)
				end
			end

			if iter7_39.id == var2_39._flagShipID then
				arg0_39.flagShipVO = iter7_39
			end

			local var37_39
			local var38_39 = arg0_39.shipBuff and arg0_39.shipBuff[iter7_39:getGroupId()]

			if arg0_39.expBuff or var38_39 then
				var37_39 = arg0_39.expBuff and arg0_39.expBuff:getConfig("name") or var38_39 and i18n("Word_Ship_Exp_Buff")
			end

			local var39_39

			if not var12_39 then
				local var40_39 = cloneTplTo(arg0_39._extpl, arg0_39._expContainer)

				var39_39 = BattleResultShipCard.New(var40_39)

				table.insert(arg0_39._shipResultCardList, var39_39)

				if var7_39 then
					var7_39:ConfigCallback(function()
						var39_39:Play()
					end)
				else
					var39_39:Play()
				end

				var7_39 = var39_39
			else
				local var41_39 = cloneTplTo(arg0_39._extpl, arg0_39._subExpContainer)

				var39_39 = BattleResultShipCard.New(var41_39)

				table.insert(arg0_39._subShipResultCardList, var39_39)

				if not var6_39 then
					arg0_39._subFirstExpCard = var39_39
				else
					var6_39:ConfigCallback(function()
						var39_39:Play()
					end)
				end

				var6_39 = var39_39
			end

			var39_39:SetShipVO(iter7_39, var10_39, var29_39, var37_39)
		end
	end

	if var7_39 then
		var7_39:ConfigCallback(function()
			arg0_39._stateFlag = var0_0.STATE_DISPLAYED

			if not arg0_39._subFirstExpCard then
				arg0_39:skip()
			end
		end)
	end

	if var6_39 then
		var6_39:ConfigCallback(function()
			arg0_39._stateFlag = var0_0.STATE_SUB_DISPLAYED

			arg0_39:skip()
		end)
	end
end

function var0_0.stopVoice(arg0_46)
	if arg0_46._currentVoice then
		arg0_46._currentVoice:PlaybackStop()

		arg0_46._currentVoice = nil
	end
end

function var0_0.setAtkAnima(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47, arg5_47, arg6_47, arg7_47)
	local var0_47 = arg1_47:Find("result")
	local var1_47 = arg1_47:Find("result/atk")
	local var2_47 = arg1_47:Find("result/dmg_progress/progress_bar")
	local var3_47 = arg1_47:Find("result/killCount")
	local var4_47 = var0_47:GetComponent(typeof(DftAniEvent))

	setText(var1_47, 0)
	setText(var3_47, 0)

	var2_47:GetComponent(typeof(Image)).fillAmount = 0

	if arg5_47 then
		local var5_47 = arg1_47:Find("result/mvpBG")

		setParent(arg0_47._mvpFX, var5_47)

		arg0_47._mvpFX.localPosition = Vector3(-368.5, 0, 0)

		setActive(var5_47, true)
		setActive(arg1_47:Find("result/bg"), false)
	end

	var4_47:SetEndEvent(function(arg0_48)
		if arg5_47 then
			setActive(arg0_47._mvpFX, true)
		end

		LeanTween.value(go(var0_47), 0, arg3_47, arg3_47):setOnUpdate(System.Action_float(function(arg0_49)
			var2_47:GetComponent(typeof(Image)).fillAmount = arg0_49
		end))

		if arg4_47 ~= 0 then
			LeanTween.value(go(var0_47), 0, arg6_47, arg3_47):setOnUpdate(System.Action_float(function(arg0_50)
				setText(var1_47, math.floor(arg0_50))
			end))
			LeanTween.value(go(var0_47), 0, arg7_47, arg3_47):setOnUpdate(System.Action_float(function(arg0_51)
				setText(var3_47, math.floor(arg0_51))
			end))
		end
	end)

	if arg2_47.childCount > 1 then
		arg2_47:GetChild(arg2_47.childCount - 2):Find("result"):GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0_52)
			setActive(var0_47, true)
		end)
	else
		setActive(var0_47, true)
	end

	local function var6_47()
		var2_47:GetComponent(typeof(Image)).fillAmount = arg3_47

		setText(var1_47, arg6_47)
		setText(var3_47, arg7_47)

		var0_47.localPosition = Vector3(280, 46, 0)
		var0_47:GetComponent(typeof(Animator)).enabled = false

		setActive(var0_47, true)
		setActive(arg0_47._mvpFX, true)
	end

	if arg0_47._atkFuncs[arg2_47] == nil then
		arg0_47._atkFuncs[arg2_47] = {}
	end

	table.insert(arg0_47._atkFuncs[arg2_47], var6_47)
end

function var0_0.skipAtkAnima(arg0_54, arg1_54)
	if arg0_54._atkFuncs[arg1_54] then
		for iter0_54, iter1_54 in ipairs(arg0_54._atkFuncs[arg1_54]) do
			iter1_54()
		end

		arg0_54._atkFuncs[arg1_54] = nil
	end
end

function var0_0.showPainting(arg0_55)
	local var0_55
	local var1_55
	local var2_55

	SetActive(arg0_55._painting, true)

	if arg0_55.contextData.score > 1 then
		local var3_55 = arg0_55.mvpShipVO or arg0_55.flagShipVO

		arg0_55.paintingName = var3_55:getPainting()

		local var4_55 = var3_55:getCVIntimacy()

		setPaintingPrefabAsync(arg0_55._painting, arg0_55.paintingName, "jiesuan", function()
			if findTF(arg0_55._painting, "fitter").childCount > 0 then
				ShipExpressionHelper.SetExpression(findTF(arg0_55._painting, "fitter"):GetChild(0), arg0_55.paintingName, "win_mvp", var4_55)
			end
		end)

		local var5_55, var6_55

		var5_55, var6_55, var1_55 = ShipWordHelper.GetWordAndCV(var3_55.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, var4_55)

		SetActive(arg0_55._failPainting, false)
	else
		local var7_55 = arg0_55.contextData.oldMainShips
		local var8_55 = var7_55[math.random(#var7_55)]
		local var9_55, var10_55

		var9_55, var10_55, var1_55 = ShipWordHelper.GetWordAndCV(var8_55.skinId, ShipWordHelper.WORD_TYPE_LOSE)
	end

	setText(arg0_55._chat:Find("Text"), var1_55)

	local var11_55 = arg0_55._chat:Find("Text"):GetComponent(typeof(Text))

	if #var11_55.text > CHAT_POP_STR_LEN then
		var11_55.alignment = TextAnchor.MiddleLeft
	else
		var11_55.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0_55._chat, true)

	arg0_55._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(arg0_55._painting))
	LeanTween.moveX(rtf(arg0_55._painting), 50, 0.25):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_55._chat.gameObject), Vector3.New(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
			arg0_55._statisticsBtn:GetComponent("Button").enabled = true
			arg0_55._confirmBtn:GetComponent("Button").enabled = true
			arg0_55._atkBG:GetComponent("Button").enabled = true
		end))
	end))
end

function var0_0.hidePainting(arg0_59)
	SetActive(arg0_59._chat, false)

	arg0_59._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(arg0_59._painting))
	LeanTween.scale(rtf(arg0_59._chat.gameObject), Vector3.New(0, 0, 0), 0.1):setEase(LeanTweenType.easeOutBack)
	LeanTween.moveX(rtf(arg0_59._painting), 720, 0.2):setOnComplete(System.Action(function()
		SetActive(arg0_59._painting, false)
	end))
end

function var0_0.skip(arg0_61)
	for iter0_61, iter1_61 in ipairs(arg0_61._delayLeanList) do
		LeanTween.cancel(iter1_61)
	end

	if arg0_61._stateFlag == var0_0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0_61._stateFlag == var0_0.STATE_REPORT then
		local var0_61 = arg0_61._conditionContainer.childCount

		while var0_61 > 0 do
			SetActive(arg0_61._conditionContainer:GetChild(var0_61 - 1), true)

			var0_61 = var0_61 - 1
		end

		SetActive(arg0_61._bg:Find("jieuan01/tips"), true)

		arg0_61._stateFlag = var0_0.STATE_REPORTED

		arg0_61:skip()
	elseif arg0_61._stateFlag == var0_0.STATE_REPORTED then
		arg0_61:showRewardInfo()
	elseif arg0_61._stateFlag == var0_0.STATE_REWARD then
		-- block empty
	elseif arg0_61._stateFlag == var0_0.STATE_DISPLAY then
		for iter2_61, iter3_61 in ipairs(arg0_61._shipResultCardList) do
			iter3_61:SkipAnimation()
		end

		arg0_61._stateFlag = var0_0.STATE_DISPLAYED

		setText(arg0_61._playerBonusExp, "+" .. arg0_61:calcPlayerProgress())

		if not arg0_61._subFirstExpCard then
			arg0_61:playSubExEnter()
		elseif arg0_61.skipFlag then
			arg0_61:skip()
		end
	elseif arg0_61._stateFlag == var0_0.STATE_DISPLAYED then
		setText(arg0_61._playerBonusExp, "+" .. arg0_61:calcPlayerProgress())
		arg0_61:playSubExEnter()
	elseif arg0_61._stateFlag == var0_0.STATE_SUB_DISPLAY then
		for iter4_61, iter5_61 in ipairs(arg0_61._subShipResultCardList) do
			iter5_61:SkipAnimation()
		end

		arg0_61._stateFlag = var0_0.STATE_SUB_DISPLAYED

		if arg0_61.skipFlag then
			arg0_61:skip()
		end
	elseif arg0_61._stateFlag == var0_0.STATE_SUB_DISPLAYED then
		arg0_61:showRightBottomPanel()
	end
end

function var0_0.playSubExEnter(arg0_62)
	arg0_62._stateFlag = var0_0.STATE_SUB_DISPLAY

	if arg0_62._subFirstExpCard then
		triggerToggle(arg0_62._subToggle, false)
		arg0_62._subFirstExpCard:Play()
	else
		arg0_62:showRightBottomPanel()
	end

	if arg0_62.skipFlag then
		arg0_62:skip()
	end
end

function var0_0.showRightBottomPanel(arg0_63)
	SetActive(arg0_63._skipBtn, false)
	SetActive(arg0_63._rightBottomPanel, true)
	SetActive(arg0_63._subToggle, arg0_63._subFirstExpCard ~= nil)
	onButton(arg0_63, arg0_63._statisticsBtn, function()
		if arg0_63._atkBG.gameObject.activeSelf then
			arg0_63:closeStatistics()
		else
			arg0_63:showStatistics()
		end
	end, SFX_PANEL)
	onButton(arg0_63, arg0_63._confirmBtn, function()
		if arg0_63.failTag == true then
			arg0_63:emit(BattleResultMediator.PRE_BATTLE_FAIL_EXIT)
			arg0_63:emit(BattleResultMediator.OPEN_FAIL_TIP_LAYER)
		else
			arg0_63:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
		end
	end, SFX_CONFIRM)
	onButton(arg0_63, arg0_63._atkBG, function()
		arg0_63:closeStatistics()
	end, SFX_CANCEL)

	arg0_63._stateFlag = nil
	arg0_63._subFirstExpCard = nil

	if arg0_63.skipFlag then
		triggerButton(arg0_63._confirmBtn)
	end
end

function var0_0.showStatistics(arg0_67)
	setActive(arg0_67._leftPanel, false)
	arg0_67:enabledStatisticsGizmos(false)
	SetActive(arg0_67._atkBG, true)

	arg0_67._atkBG:GetComponent("Button").enabled = false
	arg0_67._confirmBtn:GetComponent("Button").enabled = false
	arg0_67._statisticsBtn:GetComponent("Button").enabled = false

	arg0_67:showPainting()
	LeanTween.moveX(rtf(arg0_67._atkPanel), 0, 0.25):setOnComplete(System.Action(function()
		SetActive(arg0_67._atkContainer, true)
	end))
end

function var0_0.closeStatistics(arg0_69)
	setActive(arg0_69._leftPanel, true)
	arg0_69:skipAtkAnima(arg0_69._atkContainerNext)
	arg0_69:skipAtkAnima(arg0_69._atkContainer)
	arg0_69:enabledStatisticsGizmos(true)
	arg0_69:hidePainting()

	arg0_69._atkBG:GetComponent("Button").enabled = false

	LeanTween.cancel(arg0_69._atkPanel.gameObject)
	LeanTween.moveX(rtf(arg0_69._atkPanel), -700, 0.2):setOnComplete(System.Action(function()
		SetActive(arg0_69._atkBG, false)
	end))
end

function var0_0.enabledStatisticsGizmos(arg0_71, arg1_71)
	setActive(arg0_71._main:Find("gizmos/xuxian_down"), arg1_71)
	setActive(arg0_71._main:Find("gizmos/xuxian_middle"), arg1_71)
end

function var0_0.PlayAnimation(arg0_72, arg1_72, arg2_72, arg3_72, arg4_72, arg5_72, arg6_72)
	LeanTween.value(arg1_72.gameObject, arg2_72, arg3_72, arg4_72):setDelay(arg5_72):setOnUpdate(System.Action_float(function(arg0_73)
		arg6_72(arg0_73)
	end))
end

function var0_0.SetSkipFlag(arg0_74, arg1_74)
	arg0_74.skipFlag = arg1_74
end

function var0_0.initMetaBtn(arg0_75)
	arg0_75.metaBtn = arg0_75._main:Find("MetaBtn")

	local var0_75 = getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList()

	setActive(arg0_75.metaBtn, var0_75 and #var0_75 > 0 or false)
	onButton(arg0_75, arg0_75.metaBtn, function()
		setActive(arg0_75.metaBtn, false)

		if not arg0_75.metaExpView then
			arg0_75.metaExpView = BattleResultMetaExpView.New(arg0_75._blurConatiner, arg0_75.event, arg0_75.contextData)

			arg0_75.metaExpView:setData(var0_75, function()
				if arg0_75.metaBtn then
					setActive(arg0_75.metaBtn, true)
				end

				arg0_75.metaExpView = nil
			end)
			arg0_75.metaExpView:Reset()
			arg0_75.metaExpView:Load()
			arg0_75.metaExpView:ActionInvoke("Show")
			arg0_75.metaExpView:ActionInvoke("openPanel")
		end
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_78)
	if arg0_78.metaExpView then
		arg0_78.metaExpView:closePanel()

		arg0_78.metaExpView = nil

		return
	end

	if arg0_78._stateFlag == var0_0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0_78._stateFlag == var0_0.STATE_REPORT then
		triggerButton(arg0_78._bg)
	elseif arg0_78._stateFlag == var0_0.STATE_REPORTED then
		triggerButton(arg0_78._skipBtn)
	elseif arg0_78._stateFlag == var0_0.STATE_DISPLAY then
		triggerButton(arg0_78._skipBtn)
	else
		triggerButton(arg0_78._confirmBtn)
	end
end

function var0_0.willExit(arg0_79)
	for iter0_79, iter1_79 in ipairs(arg0_79._shipResultCardList) do
		iter1_79:Dispose()
	end

	for iter2_79, iter3_79 in ipairs(arg0_79._subShipResultCardList) do
		iter3_79:Dispose()
	end

	arg0_79._atkFuncs = nil

	LeanTween.cancel(go(arg0_79._tf))

	if arg0_79.paintingName then
		retPaintingPrefab(arg0_79._painting, arg0_79.paintingName)
	end

	if arg0_79._rightTimer then
		arg0_79._rightTimer:Stop()
	end

	arg0_79:UnOverlayPanel(arg0_79._tf)
	arg0_79:stopVoice()
	getProxy(MetaCharacterProxy):clearLastMetaSkillExpInfoList()

	if arg0_79.metaExpView then
		arg0_79.metaExpView:Destroy()

		arg0_79.metaExpView = nil
	end

	pg.CameraFixMgr.GetInstance():disconnect(arg0_79.camEventId)
end

return var0_0
