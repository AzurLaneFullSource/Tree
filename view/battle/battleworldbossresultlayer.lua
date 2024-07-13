local var0_0 = class("BattleWorldBossResultLayer", import("..base.BaseUI"))

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
end

function var0_0.setExpBuff(arg0_6, arg1_6)
	arg0_6.expBuff = arg1_6
end

function var0_0.init(arg0_7)
	arg0_7._grade = arg0_7:findTF("grade")
	arg0_7._gradeLabel = arg0_7:findTF("label", arg0_7._grade)
	arg0_7._gradeLabelImg = arg0_7._gradeLabel:GetComponent(typeof(Image))
	arg0_7.title = arg0_7:findTF("main/title")
	arg0_7.subTitleTxt = arg0_7:findTF("main/title/Text"):GetComponent(typeof(Text))
	arg0_7._levelText = arg0_7:findTF("chapterName/Text22", arg0_7._grade)
	arg0_7.clearFX = arg0_7:findTF("clear")

	setParent(arg0_7.title, arg0_7._tf)

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
	arg0_7._skipBtn = arg0_7:findTF("skipLayer", arg0_7._tf)
	arg0_7.UIMain = pg.UIMgr.GetInstance().UIMain
	arg0_7.overlay = pg.UIMgr.GetInstance().OverlayMain
	arg0_7._conditions = arg0_7:findTF("main/conditions")
	arg0_7._conditionContainer = arg0_7:findTF("bg16/list", arg0_7._conditions)
	arg0_7._conditionTpl = arg0_7:findTF("bg16/conditionTpl", arg0_7._conditions)
	arg0_7._conditionSubTpl = arg0_7:findTF("bg16/conditionSubTpl", arg0_7._conditions)
	arg0_7._cmdExp = arg0_7:findTF("commanderExp", arg0_7._leftPanel)
	arg0_7._cmdContainer = arg0_7:findTF("commander_container", arg0_7._cmdExp)
	arg0_7._cmdTpl = arg0_7:findTF("commander_tpl", arg0_7._cmdExp)

	local var0_7 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1_7 = arg0_7:findTF("grade/Xyz/bg13")
	local var2_7 = arg0_7:findTF("grade/Xyz/bg14")
	local var3_7
	local var4_7
	local var5_7
	local var6_7 = arg0_7.contextData.score
	local var7_7
	local var8_7 = var6_7 > 0

	setActive(arg0_7:findTF("jieuan01/BG/bg_victory", arg0_7._bg), var8_7)
	setActive(arg0_7:findTF("jieuan01/BG/bg_fail", arg0_7._bg), not var8_7)

	if var8_7 then
		var5_7 = var0_7[var6_7 + 1]

		local var9_7 = "battlescore/battle_score_" .. var5_7 .. "/letter_" .. var5_7
		local var10_7 = "battlescore/battle_score_" .. var5_7 .. "/label_" .. var5_7
	else
		if arg0_7.contextData.statistics._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
			var5_7 = var0_7[2]
			var7_7 = "flag_destroy"
		else
			var5_7 = var0_7[1]
		end

		local var11_7 = "battlescore/battle_score_" .. var5_7 .. "/letter_" .. var5_7
		local var12_7 = "battlescore/battle_score_" .. var5_7 .. "/label_" .. (var7_7 or var5_7)
	end

	SetActive(arg0_7._levelText, false)
	LoadImageSpriteAsync("battlescore/grade_label_clear", arg0_7._gradeLabel, true)
	setActive(arg0_7._gradeLabel, true)
	setActive(arg0_7._grade:Find("Xyz"), false)
	setActive(arg0_7._grade:Find("chapterName"), false)

	arg0_7._gradeLabel.localScale = Vector3(1.2, 1.2, 1)
	arg0_7._delayLeanList = {}
	arg0_7._ratioFitter = GetComponent(arg0_7._tf, typeof(AspectRatioFitter))
	arg0_7._ratioFitter.enabled = true
	arg0_7._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0_7.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_8, arg1_8)
		arg0_7._ratioFitter.aspectRatio = arg1_8
	end)
end

function var0_0.displayerCommanders(arg0_9, arg1_9)
	arg0_9.commanderExps = arg0_9.contextData.commanderExps or {}

	local var0_9 = getProxy(CommanderProxy)

	removeAllChildren(arg0_9._cmdContainer)

	local var1_9

	if arg1_9 then
		var1_9 = arg0_9.commanderExps.submarineCMD or {}
	else
		var1_9 = arg0_9.commanderExps.surfaceCMD or {}
	end

	setActive(arg0_9._cmdExp, true)

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var2_9 = var0_9:getCommanderById(iter1_9.commander_id)
		local var3_9 = cloneTplTo(arg0_9._cmdTpl, arg0_9._cmdContainer)

		GetImageSpriteFromAtlasAsync("commandericon/" .. var2_9:getPainting(), "", var3_9:Find("icon/mask/pic"))
		setText(var3_9:Find("exp/name_text"), var2_9:getName())
		setText(var3_9:Find("exp/lv_text"), "Lv." .. var2_9.level)
		setText(var3_9:Find("exp/exp_text"), "+" .. iter1_9.exp)

		local var4_9
		local var5_9 = var2_9:isMaxLevel() and 1 or iter1_9.curExp / var2_9:getNextLevelExp()

		var3_9:Find("exp/exp_progress"):GetComponent(typeof(Image)).fillAmount = var5_9
	end
end

function var0_0.didEnter(arg0_10)
	arg0_10:setStageName()

	arg0_10._gradeUpperLeftPos = rtf(arg0_10._grade).localPosition
	arg0_10._gradeLabelImg.color = Color.New(1, 1, 1, 1)

	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)

	arg0_10._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)

	SetActive(arg0_10._atkBG, false)

	arg0_10._stateFlag = var0_0.STATE_REPORTED

	setText(arg0_10.title, "")
	arg0_10:skip()
end

function var0_0.setTitle(arg0_11, arg1_11)
	arg0_11.name = arg1_11
end

function var0_0.setStageName(arg0_12)
	if arg0_12.contextData.system and arg0_12.contextData.system == SYSTEM_DUEL then
		setText(arg0_12._levelText, arg0_12.rivalVO.name)
	else
		local var0_12 = arg0_12.contextData.stageId
		local var1_12 = pg.expedition_data_template[var0_12]

		setText(arg0_12._levelText, var1_12.name)
	end
end

function var0_0.rankAnimaFinish(arg0_13)
	local var0_13 = arg0_13:findTF("main/conditions")

	SetActive(var0_13, true)

	local var1_13 = arg0_13.contextData.stageId
	local var2_13 = pg.expedition_data_template[var1_13]

	local function var3_13(arg0_14)
		if type(arg0_14) == "table" then
			local var0_14 = i18n(var0_0.ObjectiveList[arg0_14[1]], arg0_14[2])

			arg0_13:setCondition(var0_14, var0_0.objectiveCheck(arg0_14[1], arg0_13.contextData))
		end
	end

	var3_13(var2_13.objective_1)
	var3_13(var2_13.objective_2)
	var3_13(var2_13.objective_3)

	local var4_13 = LeanTween.delayedCall(1, System.Action(function()
		arg0_13._stateFlag = var0_0.STATE_REPORTED

		SetActive(arg0_13:findTF("jieuan01/tips", arg0_13._bg), true)
	end))

	table.insert(arg0_13._delayLeanList, var4_13.id)

	arg0_13._stateFlag = var0_0.STATE_REPORT
end

function var0_0.objectiveCheck(arg0_16, arg1_16)
	if arg0_16 == 1 or arg0_16 == 4 or arg0_16 == 8 then
		return arg1_16.score > 1
	elseif arg0_16 == 2 or arg0_16 == 3 then
		return not arg1_16.statistics._deadUnit
	elseif arg0_16 == 6 then
		return arg1_16.statistics._boss_destruct < 1
	elseif arg0_16 == 5 then
		return not arg1_16.statistics._badTime
	elseif arg0_16 == 7 then
		return true
	end
end

function var0_0.setCondition(arg0_17, arg1_17, arg2_17)
	local var0_17 = cloneTplTo(arg0_17._conditionTpl, arg0_17._conditionContainer)

	setActive(var0_17, false)

	local var1_17
	local var2_17 = var0_17:Find("text"):GetComponent(typeof(Text))

	if arg2_17 == nil then
		var1_17 = "resources/condition_check"
		var2_17.text = setColorStr(arg1_17, "#FFFFFFFF")
	elseif arg2_17 == true then
		var1_17 = "resources/condition_done"
		var2_17.text = setColorStr(arg1_17, "#FFFFFFFF")
	else
		var1_17 = "resources/condition_fail"
		var2_17.text = setColorStr(arg1_17, "#FFFFFF80")
	end

	arg0_17:setSpriteTo(var1_17, var0_17:Find("checkBox"), true)

	local var3_17 = arg0_17._conditionContainer.childCount - 1

	if var3_17 > 0 then
		local var4_17 = LeanTween.delayedCall(var0_0.CONDITIONS_FREQUENCE * var3_17, System.Action(function()
			setActive(var0_17, true)
		end))

		table.insert(arg0_17._delayLeanList, var4_17.id)
	else
		setActive(var0_17, true)
	end
end

function var0_0.showRewardInfo(arg0_19, arg1_19)
	arg0_19._stateFlag = var0_0.STATE_REWARD

	SetActive(arg0_19:findTF("jieuan01/tips", arg0_19._bg), false)
	setParent(arg0_19._tf, arg0_19.UIMain)

	local var0_19

	local function var1_19()
		if var0_19 and coroutine.status(var0_19) == "suspended" then
			local var0_20, var1_20 = coroutine.resume(var0_19)

			assert(var0_20, var1_20)
		end
	end

	var0_19 = coroutine.create(function()
		local var0_21 = arg0_19.contextData.drops
		local var1_21 = {}

		for iter0_21, iter1_21 in ipairs(arg0_19.contextData.drops) do
			table.insert(var1_21, iter1_21)
		end

		for iter2_21, iter3_21 in ipairs(arg0_19.contextData.extraDrops) do
			iter3_21.riraty = true

			table.insert(var1_21, iter3_21)
		end

		local var2_21 = false
		local var3_21 = arg0_19.contextData.extraBuffList

		if table.getCount(var0_21) > 0 then
			arg0_19:emit(BaseUI.ON_AWARD, {
				items = var0_21,
				removeFunc = var1_19
			})
			coroutine.yield()

			local var4_21 = #_.filter(var1_21, function(arg0_22)
				return arg0_22.type == DROP_TYPE_SHIP
			end)
			local var5_21 = getProxy(BayProxy):getNewShip(true)

			for iter4_21 = math.max(1, #var5_21 - var4_21 + 1), #var5_21 do
				local var6_21 = var5_21[iter4_21]

				if PlayerPrefs.GetInt(DISPLAY_SHIP_GET_EFFECT) == 1 or var6_21.virgin or var6_21:getRarity() >= ShipRarity.Purple then
					arg0_19:emit(BattleResultMediator.GET_NEW_SHIP, var6_21, var1_19)
					coroutine.yield()
				end
			end
		end

		setParent(arg0_19._tf, arg0_19.overlay)
		arg1_19()
		setActive(arg0_19:findTF("main/jiesuanbeijing"), false)
		setActive(arg0_19._conditions, false)
	end)

	var1_19()
end

function var0_0.displayPlayerInfo(arg0_23)
	local var0_23 = arg0_23:calcPlayerProgress()

	SetActive(arg0_23._leftPanel, true)
	SetActive(arg0_23._playerExp, true)

	arg0_23._main:GetComponent("Animator").enabled = true

	local var1_23 = LeanTween.moveX(rtf(arg0_23._leftPanel), 0, 0.5):setOnComplete(System.Action(function()
		local var0_24 = LeanTween.value(go(arg0_23._tf), 0, var0_23, 1):setOnUpdate(System.Action_float(function(arg0_25)
			setText(arg0_23._playerBonusExp, "+" .. math.floor(arg0_25))
		end))

		table.insert(arg0_23._delayLeanList, var0_24.id)
	end))

	table.insert(arg0_23._delayLeanList, var1_23.id)
end

function var0_0.calcPlayerExp(arg0_26)
	local var0_26 = arg0_26.contextData.oldPlayer
	local var1_26 = var0_26.level
	local var2_26 = arg0_26.player.level
	local var3_26 = arg0_26.player.exp - var0_26.exp

	while var1_26 < var2_26 do
		var3_26 = var3_26 + pg.user_level[var1_26].exp
		var1_26 = var1_26 + 1
	end

	if var1_26 == pg.user_level[#pg.user_level].level then
		var3_26 = 0
	end

	return var3_26
end

function var0_0.calcPlayerRank(arg0_27)
	local var0_27 = arg0_27.contextData.oldRank
	local var1_27 = var0_27.score

	return arg0_27.season.score - var0_27.score
end

function var0_0.displayShips(arg0_28)
	setActive(arg0_28.title, true)

	arg0_28._expTFs = {}
	arg0_28._initExp = {}
	arg0_28._skipExp = {}
	arg0_28._subSkipExp = {}
	arg0_28._subCardAnimaFuncList = {}

	local var0_28 = {}
	local var1_28 = arg0_28.shipVOs

	for iter0_28, iter1_28 in ipairs(var1_28) do
		var0_28[iter1_28.id] = iter1_28
	end

	local var2_28 = arg0_28.contextData.statistics

	for iter2_28, iter3_28 in ipairs(var1_28) do
		if var2_28[iter3_28.id] then
			var2_28[iter3_28.id].vo = iter3_28
		end
	end

	local var3_28
	local var4_28

	if var2_28.mvpShipID and var2_28.mvpShipID ~= 0 then
		var3_28 = var2_28[var2_28.mvpShipID]
		var4_28 = var3_28.output
	else
		var4_28 = 0
	end

	local var5_28 = arg0_28.contextData.oldMainShips

	arg0_28._atkFuncs = {}
	arg0_28._commonAtkTplList = {}
	arg0_28._subAtkTplList = {}

	local var6_28
	local var7_28

	SetActive(arg0_28._atkToggle, #var5_28 > 6)

	if #var5_28 > 6 then
		onToggle(arg0_28, arg0_28._atkToggle, function(arg0_29)
			SetActive(arg0_28._atkContainer, arg0_29)
			SetActive(arg0_28._atkContainerNext, not arg0_29)

			if arg0_29 then
				arg0_28:skipAtkAnima(arg0_28._atkContainerNext)
			else
				arg0_28:skipAtkAnima(arg0_28._atkContainer)
			end
		end, SFX_PANEL)
	end

	local var8_28 = {}
	local var9_28 = {}
	local var10_28 = 0

	for iter4_28, iter5_28 in ipairs(var5_28) do
		local var11_28 = var0_28[iter5_28.id]

		if var2_28[iter5_28.id] then
			local var12_28 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter5_28.configId).type
			local var13_28 = table.contains(TeamType.SubShipType, var12_28)
			local var14_28
			local var15_28
			local var16_28 = 0
			local var17_28

			if iter4_28 > 6 then
				var15_28 = arg0_28._atkContainerNext
				var17_28 = 7
			else
				var15_28 = arg0_28._atkContainer
				var17_28 = 1
			end

			local var18_28 = cloneTplTo(arg0_28._atkTpl, var15_28)
			local var19_28 = var18_28.localPosition

			var19_28.x = var19_28.x + (iter4_28 - var17_28) * 74
			var19_28.y = var19_28.y + (iter4_28 - var17_28) * -124
			var18_28.localPosition = var19_28

			local var20_28 = arg0_28:findTF("result/mask/icon", var18_28)
			local var21_28 = arg0_28:findTF("result/type", var18_28)

			var20_28:GetComponent(typeof(Image)).sprite = LoadSprite("herohrzicon/" .. iter5_28:getPainting())

			local var22_28 = var2_28[iter5_28.id].output / var4_28
			local var23_28 = GetSpriteFromAtlas("shiptype", shipType2print(iter5_28:getShipType()))

			setImageSprite(var21_28, var23_28, true)
			arg0_28:setAtkAnima(var18_28, var15_28, var22_28, var4_28, var3_28 and iter5_28.id == var3_28.id, var2_28[iter5_28.id].output, var2_28[iter5_28.id].kill_count)

			var10_28 = var10_28 + var2_28[iter5_28.id].output

			local var24_28
			local var25_28

			if not var13_28 then
				var24_28 = cloneTplTo(arg0_28._extpl, arg0_28._expContainer)
				var25_28 = arg0_28._skipExp

				table.insert(var8_28, var24_28)
			else
				var24_28 = cloneTplTo(arg0_28._extpl, arg0_28._subExpContainer)
				var25_28 = arg0_28._subSkipExp

				table.insert(var9_28, var24_28)
			end

			flushShipCard(var24_28, iter5_28)

			local var26_28 = findTF(var24_28, "content")
			local var27_28 = findTF(var26_28, "exp")

			arg0_28._expTFs[#arg0_28._expTFs + 1] = var24_28

			local var28_28 = findTF(var18_28, "result/stars")
			local var29_28 = findTF(var18_28, "result/stars/star_tpl")
			local var30_28 = iter5_28:getStar()
			local var31_28 = iter5_28:getMaxStar()
			local var32_28 = var31_28 - var30_28
			local var33_28 = findTF(var26_28, "heartsfly")
			local var34_28 = findTF(var26_28, "heartsbroken")

			while var31_28 > 0 do
				local var35_28 = cloneTplTo(var29_28, var28_28)

				SetActive(var35_28:Find("empty"), var30_28 < var31_28)
				SetActive(var35_28:Find("star"), var31_28 <= var30_28)

				var31_28 = var31_28 - 1
			end

			setScrollText(findTF(var26_28, "info/name_mask/name"), iter5_28:GetColorName())

			if var3_28 and iter5_28.id == var3_28.id then
				arg0_28.mvpShipVO = iter5_28

				SetActive(findTF(var26_28, "mvp"), true)

				local var36_28
				local var37_28
				local var38_28
				local var39_28, var40_28, var41_28 = ShipWordHelper.GetWordAndCV(arg0_28.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP)

				if var40_28 then
					arg0_28._currentVoice = var40_28

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg0_28._currentVoice)
				end
			end

			if iter5_28.id == var2_28._flagShipID then
				arg0_28.flagShipVO = iter5_28
			end

			local var42_28 = iter5_28:getConfig("rarity")
			local var43_28 = findTF(var26_28, "dockyard/lv/Text")
			local var44_28 = findTF(var26_28, "dockyard/lv_bg/levelUpLabel")
			local var45_28 = findTF(var26_28, "dockyard/lv_bg/levelup")
			local var46_28 = findTF(var27_28, "exp_text")
			local var47_28 = findTF(var27_28, "exp_progress"):GetComponent(typeof(Image))
			local var48_28 = findTF(var27_28, "exp_buff_mask/exp_buff")

			setActive(var48_28, arg0_28.expBuff)

			if arg0_28.expBuff then
				setText(var48_28, arg0_28.expBuff:getConfig("name"))
			end

			local function var49_28()
				SetActive(var27_28, true)
				SetActive(var33_28, iter5_28:getIntimacy() < var11_28:getIntimacy())
				SetActive(var34_28, iter5_28:getIntimacy() > var11_28:getIntimacy())

				local var0_30 = getExpByRarityFromLv1(var42_28, iter5_28.level)
				local var1_30 = getExpByRarityFromLv1(var42_28, var11_28.level)

				var47_28.fillAmount = iter5_28:getExp() / var0_30

				if iter5_28.level < var11_28.level then
					local var2_30 = 0

					for iter0_30 = iter5_28.level, var11_28.level - 1 do
						var2_30 = var2_30 + getExpByRarityFromLv1(var42_28, iter0_30)
					end

					arg0_28:PlayAnimation(var24_28, 0, var2_30 + var11_28:getExp() - iter5_28:getExp(), 1, 0, function(arg0_31)
						setText(var46_28, "+" .. math.ceil(arg0_31))
					end)

					local function var3_30(arg0_32)
						SetActive(var44_28, true)
						SetActive(var45_28, true)

						local var0_32 = var44_28.localPosition

						LeanTween.moveY(rtf(var44_28), var0_32.y + 30, 0.5):setOnComplete(System.Action(function()
							SetActive(var44_28, false)

							var44_28.localPosition = var0_32

							pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_LEVEL_UP)
						end))

						if arg0_32 <= var11_28.level then
							setText(var43_28, arg0_32)
						end
					end

					local var4_30 = iter5_28.level

					local function var5_30(arg0_34, arg1_34, arg2_34, arg3_34)
						LeanTween.value(go(var24_28), arg0_34, arg1_34, arg2_34):setOnUpdate(System.Action_float(function(arg0_35)
							var47_28.fillAmount = arg0_35
						end)):setOnComplete(System.Action(function()
							var4_30 = var4_30 + 1

							if arg3_34 then
								var3_30(var4_30)
							end

							if var11_28.level == var4_30 then
								if var4_30 == var11_28:getMaxLevel() then
									var47_28.fillAmount = 1
								else
									var5_30(0, var11_28:getExp() / var1_30, 1, false)
								end
							elseif var11_28.level > var4_30 then
								var5_30(0, 1, 0.7, true)
							end
						end))
					end

					var5_30(iter5_28:getExp() / var0_30, 1, 0.7, true)
				else
					local var6_30 = math.ceil(var11_28:getExp() - iter5_28:getExp())

					setText(var46_28, "+" .. var6_30)

					if iter5_28.level == iter5_28:getMaxLevel() then
						var47_28.fillAmount = 1

						return
					end

					arg0_28:PlayAnimation(var24_28, iter5_28:getExp() / var0_30, var11_28:getExp() / var0_30, 1, 0, function(arg0_37)
						var47_28.fillAmount = arg0_37
					end)
				end
			end

			var24_28:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0_38)
				var49_28()
			end)
			setActive(var24_28, false)

			if var13_28 then
				if not var7_28 then
					arg0_28._subFirstExpTF = var24_28
				else
					var7_28:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_39)
						setActive(var24_28, true)
					end)
				end

				var7_28 = var24_28
			else
				if var6_28 then
					var6_28:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_40)
						setActive(var24_28, true)
					end)
				else
					setActive(var24_28, true)
				end

				var6_28 = var24_28
			end

			var25_28[#var25_28 + 1] = function()
				var24_28:GetComponent(typeof(Animator)).enabled = false

				SetActive(var24_28, true)
				SetActive(var26_28, true)
				SetActive(var27_28, true)

				var24_28:GetComponent(typeof(CanvasGroup)).alpha = 1

				LeanTween.cancel(go(var44_28))
				LeanTween.cancel(go(var24_28))
				SetActive(var33_28, iter5_28:getIntimacy() < var11_28:getIntimacy())
				SetActive(var34_28, iter5_28:getIntimacy() > var11_28:getIntimacy())

				var26_28.localPosition = Vector3(0, 0, 0)

				setText(var43_28, var11_28.level)

				if iter5_28.level == iter5_28:getMaxLevel() then
					setText(var46_28, "+" .. math.ceil(var11_28:getExp() - iter5_28:getExp()))

					var47_28.fillAmount = 1
				else
					if iter5_28.level < var11_28.level then
						local var0_41 = 0

						for iter0_41 = iter5_28.level, var11_28.level - 1 do
							var0_41 = var0_41 + getExpByRarityFromLv1(var42_28, iter0_41)
						end

						setText(var46_28, "+" .. var0_41 + var11_28:getExp() - iter5_28:getExp())
					else
						setText(var46_28, "+" .. math.ceil(var11_28:getExp() - iter5_28:getExp()))
					end

					var47_28.fillAmount = var11_28:getExp() / getExpByRarityFromLv1(var42_28, var11_28.level)
				end

				SetActive(var44_28, false)
			end
		end
	end

	local var50_28 = var8_28[#var8_28]

	if var50_28 then
		var50_28:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_42)
			arg0_28._stateFlag = var0_0.STATE_DISPLAYED

			if not arg0_28._subFirstExpTF then
				arg0_28:skip()
			end
		end)
	end

	if #var9_28 > 0 then
		var9_28[#var9_28]:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_43)
			arg0_28._stateFlag = var0_0.STATE_SUB_DISPLAYED

			arg0_28:skip()
		end)
	end

	arg0_28.subTitleTxt.text = arg0_28.contextData.statistics.specificDamage
end

function var0_0.setAtkAnima(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44, arg5_44, arg6_44, arg7_44)
	local var0_44 = arg0_44:findTF("result", arg1_44)
	local var1_44 = arg0_44:findTF("result/atk", arg1_44)
	local var2_44 = arg0_44:findTF("result/dmg_progress/progress_bar", arg1_44)
	local var3_44 = arg0_44:findTF("result/killCount", arg1_44)
	local var4_44 = var0_44:GetComponent(typeof(DftAniEvent))

	setText(var1_44, 0)
	setText(var3_44, 0)

	var2_44:GetComponent(typeof(Image)).fillAmount = 0

	if arg5_44 then
		local var5_44 = arg0_44:findTF("result/mvpBG", arg1_44)

		setParent(arg0_44._mvpFX, var5_44)

		arg0_44._mvpFX.localPosition = Vector3(-368.5, 0, 0)

		setActive(var5_44, true)
		setActive(arg0_44:findTF("result/bg", arg1_44), false)
	end

	var4_44:SetEndEvent(function(arg0_45)
		if arg5_44 then
			setActive(arg0_44._mvpFX, true)
		end

		LeanTween.value(go(var0_44), 0, arg3_44, arg3_44):setOnUpdate(System.Action_float(function(arg0_46)
			var2_44:GetComponent(typeof(Image)).fillAmount = arg0_46
		end))

		if arg4_44 ~= 0 then
			LeanTween.value(go(var0_44), 0, arg6_44, arg3_44):setOnUpdate(System.Action_float(function(arg0_47)
				setText(var1_44, math.floor(arg0_47))
			end))
			LeanTween.value(go(var0_44), 0, arg7_44, arg3_44):setOnUpdate(System.Action_float(function(arg0_48)
				setText(var3_44, math.floor(arg0_48))
			end))
		end
	end)

	if arg2_44.childCount > 1 then
		arg0_44:findTF("result", arg2_44:GetChild(arg2_44.childCount - 2)):GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0_49)
			setActive(var0_44, true)
		end)
	else
		setActive(var0_44, true)
	end

	local function var6_44()
		var2_44:GetComponent(typeof(Image)).fillAmount = arg3_44

		setText(var1_44, arg6_44)
		setText(var3_44, arg7_44)

		var0_44.localPosition = Vector3(280, 46, 0)
		var0_44:GetComponent(typeof(Animator)).enabled = false

		setActive(var0_44, true)
		setActive(arg0_44._mvpFX, true)
	end

	if arg0_44._atkFuncs[arg2_44] == nil then
		arg0_44._atkFuncs[arg2_44] = {}
	end

	table.insert(arg0_44._atkFuncs[arg2_44], var6_44)
end

function var0_0.skipAtkAnima(arg0_51, arg1_51)
	if arg0_51._atkFuncs[arg1_51] then
		for iter0_51, iter1_51 in ipairs(arg0_51._atkFuncs[arg1_51]) do
			iter1_51()
		end

		arg0_51._atkFuncs[arg1_51] = nil
	end
end

function var0_0.showPainting(arg0_52)
	local var0_52
	local var1_52
	local var2_52

	SetActive(arg0_52._painting, true)

	local var3_52 = arg0_52.mvpShipVO or arg0_52.flagShipVO

	arg0_52.paintingName = var3_52:getPainting()

	setPaintingPrefabAsync(arg0_52._painting, arg0_52.paintingName, "jiesuan", function()
		if findTF(arg0_52._painting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0_52._painting, "fitter"):GetChild(0), arg0_52.paintingName, "win_mvp")
		end
	end)

	local var4_52, var5_52, var6_52 = ShipWordHelper.GetWordAndCV(var3_52.skinId, ShipWordHelper.WORD_TYPE_MVP)

	SetActive(arg0_52._failPainting, false)
	setText(arg0_52._chat:Find("Text"), var6_52)

	local var7_52 = arg0_52._chat:Find("Text"):GetComponent(typeof(Text))

	if #var7_52.text > CHAT_POP_STR_LEN then
		var7_52.alignment = TextAnchor.MiddleLeft
	else
		var7_52.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0_52._chat, true)

	arg0_52._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(arg0_52._painting))
	LeanTween.moveX(rtf(arg0_52._painting), 50, 0):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_52._chat.gameObject), Vector3.New(1, 1, 1), 0):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
			arg0_52._statisticsBtn:GetComponent("Button").enabled = true
			arg0_52._confirmBtn:GetComponent("Button").enabled = true
			arg0_52._atkBG:GetComponent("Button").enabled = true
		end))
	end))
end

function var0_0.hidePainting(arg0_56)
	SetActive(arg0_56._chat, false)

	arg0_56._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(arg0_56._painting))
	LeanTween.scale(rtf(arg0_56._chat.gameObject), Vector3.New(0, 0, 0), 0.1):setEase(LeanTweenType.easeOutBack)
	LeanTween.moveX(rtf(arg0_56._painting), 720, 0.2):setOnComplete(System.Action(function()
		SetActive(arg0_56._painting, false)
	end))
end

function var0_0.skip(arg0_58)
	local var0_58 = {
		function(arg0_59)
			arg0_58:showRewardInfo(arg0_59)
		end,
		function(arg0_60)
			arg0_58:displayShips()
			arg0_58:showRightBottomPanel()
		end
	}

	seriesAsync(var0_58)
end

function var0_0.playSubExEnter(arg0_61)
	arg0_61._stateFlag = var0_0.STATE_SUB_DISPLAY

	if arg0_61._subFirstExpTF then
		triggerToggle(arg0_61._subToggle, false)
		setActive(arg0_61._subFirstExpTF, true)
	else
		arg0_61:showRightBottomPanel()
	end
end

function var0_0.showRightBottomPanel(arg0_62)
	SetActive(arg0_62._skipBtn, false)
	SetActive(arg0_62._rightBottomPanel, true)
	SetActive(arg0_62._subToggle, arg0_62._subFirstExpTF ~= nil)
	setActive(arg0_62._statisticsBtn, false)
	onButton(arg0_62, arg0_62._confirmBtn, function()
		arg0_62:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end, SFX_CONFIRM)

	arg0_62._stateFlag = nil
	arg0_62._subFirstExpTF = nil

	arg0_62:showStatistics()
end

function var0_0.showStatistics(arg0_64)
	setActive(arg0_64._leftPanel, false)
	arg0_64:enabledStatisticsGizmos(false)
	SetActive(arg0_64._atkBG, true)

	arg0_64._atkBG:GetComponent("Button").enabled = false
	arg0_64._confirmBtn:GetComponent("Button").enabled = false
	arg0_64._statisticsBtn:GetComponent("Button").enabled = false

	arg0_64:showPainting()
	LeanTween.moveX(rtf(arg0_64._atkPanel), 0, 0.25):setOnComplete(System.Action(function()
		SetActive(arg0_64._atkContainer, true)
	end))
end

function var0_0.closeStatistics(arg0_66)
	setActive(arg0_66._leftPanel, true)
	arg0_66:skipAtkAnima(arg0_66._atkContainerNext)
	arg0_66:skipAtkAnima(arg0_66._atkContainer)
	arg0_66:enabledStatisticsGizmos(true)
	arg0_66:hidePainting()

	arg0_66._atkBG:GetComponent("Button").enabled = false

	LeanTween.cancel(arg0_66._atkPanel.gameObject)
	LeanTween.moveX(rtf(arg0_66._atkPanel), -700, 0.2):setOnComplete(System.Action(function()
		SetActive(arg0_66._atkBG, false)
	end))
end

function var0_0.enabledStatisticsGizmos(arg0_68, arg1_68)
	setActive(arg0_68:findTF("gizmos/xuxian_down", arg0_68._main), arg1_68)
	setActive(arg0_68:findTF("gizmos/xuxian_middle", arg0_68._main), arg1_68)
end

function var0_0.PlayAnimation(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69, arg5_69, arg6_69)
	LeanTween.value(arg1_69.gameObject, arg2_69, arg3_69, arg4_69):setDelay(arg5_69):setOnUpdate(System.Action_float(function(arg0_70)
		arg6_69(arg0_70)
	end))
end

function var0_0.onBackPressed(arg0_71)
	if arg0_71._stateFlag == var0_0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0_71._stateFlag == var0_0.STATE_REPORT then
		triggerButton(arg0_71._bg)
	elseif arg0_71._stateFlag == var0_0.STATE_DISPLAY then
		triggerButton(arg0_71._skipBtn)
	else
		triggerButton(arg0_71._confirmBtn)
	end
end

function var0_0.willExit(arg0_72)
	setActive(arg0_72.title, false)

	arg0_72._atkFuncs = nil

	LeanTween.cancel(go(arg0_72._tf))

	if arg0_72._atkBG.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_72._blurConatiner, arg0_72._tf)
	end

	if arg0_72.paintingName then
		retPaintingPrefab(arg0_72._painting, arg0_72.paintingName)
	end

	if arg0_72._rightTimer then
		arg0_72._rightTimer:Stop()
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_72._tf)

	if arg0_72._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_72._currentVoice)
	end

	arg0_72._currentVoice = nil

	pg.CameraFixMgr.GetInstance():disconnect(arg0_72.camEventId)
end

return var0_0
