local var0 = class("BattleWorldBossResultLayer", import("..base.BaseUI"))

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
end

function var0.setExpBuff(arg0, arg1)
	arg0.expBuff = arg1
end

function var0.init(arg0)
	arg0._grade = arg0:findTF("grade")
	arg0._gradeLabel = arg0:findTF("label", arg0._grade)
	arg0._gradeLabelImg = arg0._gradeLabel:GetComponent(typeof(Image))
	arg0.title = arg0:findTF("main/title")
	arg0.subTitleTxt = arg0:findTF("main/title/Text"):GetComponent(typeof(Text))
	arg0._levelText = arg0:findTF("chapterName/Text22", arg0._grade)
	arg0.clearFX = arg0:findTF("clear")

	setParent(arg0.title, arg0._tf)

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
	arg0._skipBtn = arg0:findTF("skipLayer", arg0._tf)
	arg0.UIMain = pg.UIMgr.GetInstance().UIMain
	arg0.overlay = pg.UIMgr.GetInstance().OverlayMain
	arg0._conditions = arg0:findTF("main/conditions")
	arg0._conditionContainer = arg0:findTF("bg16/list", arg0._conditions)
	arg0._conditionTpl = arg0:findTF("bg16/conditionTpl", arg0._conditions)
	arg0._conditionSubTpl = arg0:findTF("bg16/conditionSubTpl", arg0._conditions)
	arg0._cmdExp = arg0:findTF("commanderExp", arg0._leftPanel)
	arg0._cmdContainer = arg0:findTF("commander_container", arg0._cmdExp)
	arg0._cmdTpl = arg0:findTF("commander_tpl", arg0._cmdExp)

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

		local var9 = "battlescore/battle_score_" .. var5 .. "/letter_" .. var5
		local var10 = "battlescore/battle_score_" .. var5 .. "/label_" .. var5
	else
		if arg0.contextData.statistics._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
			var5 = var0[2]
			var7 = "flag_destroy"
		else
			var5 = var0[1]
		end

		local var11 = "battlescore/battle_score_" .. var5 .. "/letter_" .. var5
		local var12 = "battlescore/battle_score_" .. var5 .. "/label_" .. (var7 or var5)
	end

	SetActive(arg0._levelText, false)
	LoadImageSpriteAsync("battlescore/grade_label_clear", arg0._gradeLabel, true)
	setActive(arg0._gradeLabel, true)
	setActive(arg0._grade:Find("Xyz"), false)
	setActive(arg0._grade:Find("chapterName"), false)

	arg0._gradeLabel.localScale = Vector3(1.2, 1.2, 1)
	arg0._delayLeanList = {}
	arg0._ratioFitter = GetComponent(arg0._tf, typeof(AspectRatioFitter))
	arg0._ratioFitter.enabled = true
	arg0._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance().targetRatio
	arg0.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0, arg1)
		arg0._ratioFitter.aspectRatio = arg1
	end)
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

	arg0._gradeUpperLeftPos = rtf(arg0._grade).localPosition
	arg0._gradeLabelImg.color = Color.New(1, 1, 1, 1)

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)

	SetActive(arg0._atkBG, false)

	arg0._stateFlag = var0.STATE_REPORTED

	setText(arg0.title, "")
	arg0:skip()
end

function var0.setTitle(arg0, arg1)
	arg0.name = arg1
end

function var0.setStageName(arg0)
	if arg0.contextData.system and arg0.contextData.system == SYSTEM_DUEL then
		setText(arg0._levelText, arg0.rivalVO.name)
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

function var0.showRewardInfo(arg0, arg1)
	arg0._stateFlag = var0.STATE_REWARD

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
		local var1 = {}

		for iter0, iter1 in ipairs(arg0.contextData.drops) do
			table.insert(var1, iter1)
		end

		for iter2, iter3 in ipairs(arg0.contextData.extraDrops) do
			iter3.riraty = true

			table.insert(var1, iter3)
		end

		local var2 = false
		local var3 = arg0.contextData.extraBuffList

		if table.getCount(var0) > 0 then
			arg0:emit(BaseUI.ON_AWARD, {
				items = var0,
				removeFunc = var1
			})
			coroutine.yield()

			local var4 = #_.filter(var1, function(arg0)
				return arg0.type == DROP_TYPE_SHIP
			end)
			local var5 = getProxy(BayProxy):getNewShip(true)

			for iter4 = math.max(1, #var5 - var4 + 1), #var5 do
				local var6 = var5[iter4]

				if PlayerPrefs.GetInt(DISPLAY_SHIP_GET_EFFECT) == 1 or var6.virgin or var6:getRarity() >= ShipRarity.Purple then
					arg0:emit(BattleResultMediator.GET_NEW_SHIP, var6, var1)
					coroutine.yield()
				end
			end
		end

		setParent(arg0._tf, arg0.overlay)
		arg1()
		setActive(arg0:findTF("main/jiesuanbeijing"), false)
		setActive(arg0._conditions, false)
	end)

	var1()
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
	setActive(arg0.title, true)

	arg0._expTFs = {}
	arg0._initExp = {}
	arg0._skipExp = {}
	arg0._subSkipExp = {}
	arg0._subCardAnimaFuncList = {}

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

	if var2.mvpShipID and var2.mvpShipID ~= 0 then
		var3 = var2[var2.mvpShipID]
		var4 = var3.output
	else
		var4 = 0
	end

	local var5 = arg0.contextData.oldMainShips

	arg0._atkFuncs = {}
	arg0._commonAtkTplList = {}
	arg0._subAtkTplList = {}

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
	local var10 = 0

	for iter4, iter5 in ipairs(var5) do
		local var11 = var0[iter5.id]

		if var2[iter5.id] then
			local var12 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(iter5.configId).type
			local var13 = table.contains(TeamType.SubShipType, var12)
			local var14
			local var15
			local var16 = 0
			local var17

			if iter4 > 6 then
				var15 = arg0._atkContainerNext
				var17 = 7
			else
				var15 = arg0._atkContainer
				var17 = 1
			end

			local var18 = cloneTplTo(arg0._atkTpl, var15)
			local var19 = var18.localPosition

			var19.x = var19.x + (iter4 - var17) * 74
			var19.y = var19.y + (iter4 - var17) * -124
			var18.localPosition = var19

			local var20 = arg0:findTF("result/mask/icon", var18)
			local var21 = arg0:findTF("result/type", var18)

			var20:GetComponent(typeof(Image)).sprite = LoadSprite("herohrzicon/" .. iter5:getPainting())

			local var22 = var2[iter5.id].output / var4
			local var23 = GetSpriteFromAtlas("shiptype", shipType2print(iter5:getShipType()))

			setImageSprite(var21, var23, true)
			arg0:setAtkAnima(var18, var15, var22, var4, var3 and iter5.id == var3.id, var2[iter5.id].output, var2[iter5.id].kill_count)

			var10 = var10 + var2[iter5.id].output

			local var24
			local var25

			if not var13 then
				var24 = cloneTplTo(arg0._extpl, arg0._expContainer)
				var25 = arg0._skipExp

				table.insert(var8, var24)
			else
				var24 = cloneTplTo(arg0._extpl, arg0._subExpContainer)
				var25 = arg0._subSkipExp

				table.insert(var9, var24)
			end

			flushShipCard(var24, iter5)

			local var26 = findTF(var24, "content")
			local var27 = findTF(var26, "exp")

			arg0._expTFs[#arg0._expTFs + 1] = var24

			local var28 = findTF(var18, "result/stars")
			local var29 = findTF(var18, "result/stars/star_tpl")
			local var30 = iter5:getStar()
			local var31 = iter5:getMaxStar()
			local var32 = var31 - var30
			local var33 = findTF(var26, "heartsfly")
			local var34 = findTF(var26, "heartsbroken")

			while var31 > 0 do
				local var35 = cloneTplTo(var29, var28)

				SetActive(var35:Find("empty"), var30 < var31)
				SetActive(var35:Find("star"), var31 <= var30)

				var31 = var31 - 1
			end

			setScrollText(findTF(var26, "info/name_mask/name"), iter5:GetColorName())

			if var3 and iter5.id == var3.id then
				arg0.mvpShipVO = iter5

				SetActive(findTF(var26, "mvp"), true)

				local var36
				local var37
				local var38
				local var39, var40, var41 = ShipWordHelper.GetWordAndCV(arg0.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP)

				if var40 then
					arg0._currentVoice = var40

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg0._currentVoice)
				end
			end

			if iter5.id == var2._flagShipID then
				arg0.flagShipVO = iter5
			end

			local var42 = iter5:getConfig("rarity")
			local var43 = findTF(var26, "dockyard/lv/Text")
			local var44 = findTF(var26, "dockyard/lv_bg/levelUpLabel")
			local var45 = findTF(var26, "dockyard/lv_bg/levelup")
			local var46 = findTF(var27, "exp_text")
			local var47 = findTF(var27, "exp_progress"):GetComponent(typeof(Image))
			local var48 = findTF(var27, "exp_buff_mask/exp_buff")

			setActive(var48, arg0.expBuff)

			if arg0.expBuff then
				setText(var48, arg0.expBuff:getConfig("name"))
			end

			local function var49()
				SetActive(var27, true)
				SetActive(var33, iter5:getIntimacy() < var11:getIntimacy())
				SetActive(var34, iter5:getIntimacy() > var11:getIntimacy())

				local var0 = getExpByRarityFromLv1(var42, iter5.level)
				local var1 = getExpByRarityFromLv1(var42, var11.level)

				var47.fillAmount = iter5:getExp() / var0

				if iter5.level < var11.level then
					local var2 = 0

					for iter0 = iter5.level, var11.level - 1 do
						var2 = var2 + getExpByRarityFromLv1(var42, iter0)
					end

					arg0:PlayAnimation(var24, 0, var2 + var11:getExp() - iter5:getExp(), 1, 0, function(arg0)
						setText(var46, "+" .. math.ceil(arg0))
					end)

					local function var3(arg0)
						SetActive(var44, true)
						SetActive(var45, true)

						local var0 = var44.localPosition

						LeanTween.moveY(rtf(var44), var0.y + 30, 0.5):setOnComplete(System.Action(function()
							SetActive(var44, false)

							var44.localPosition = var0

							pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_LEVEL_UP)
						end))

						if arg0 <= var11.level then
							setText(var43, arg0)
						end
					end

					local var4 = iter5.level

					local function var5(arg0, arg1, arg2, arg3)
						LeanTween.value(go(var24), arg0, arg1, arg2):setOnUpdate(System.Action_float(function(arg0)
							var47.fillAmount = arg0
						end)):setOnComplete(System.Action(function()
							var4 = var4 + 1

							if arg3 then
								var3(var4)
							end

							if var11.level == var4 then
								if var4 == var11:getMaxLevel() then
									var47.fillAmount = 1
								else
									var5(0, var11:getExp() / var1, 1, false)
								end
							elseif var11.level > var4 then
								var5(0, 1, 0.7, true)
							end
						end))
					end

					var5(iter5:getExp() / var0, 1, 0.7, true)
				else
					local var6 = math.ceil(var11:getExp() - iter5:getExp())

					setText(var46, "+" .. var6)

					if iter5.level == iter5:getMaxLevel() then
						var47.fillAmount = 1

						return
					end

					arg0:PlayAnimation(var24, iter5:getExp() / var0, var11:getExp() / var0, 1, 0, function(arg0)
						var47.fillAmount = arg0
					end)
				end
			end

			var24:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0)
				var49()
			end)
			setActive(var24, false)

			if var13 then
				if not var7 then
					arg0._subFirstExpTF = var24
				else
					var7:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
						setActive(var24, true)
					end)
				end

				var7 = var24
			else
				if var6 then
					var6:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
						setActive(var24, true)
					end)
				else
					setActive(var24, true)
				end

				var6 = var24
			end

			var25[#var25 + 1] = function()
				var24:GetComponent(typeof(Animator)).enabled = false

				SetActive(var24, true)
				SetActive(var26, true)
				SetActive(var27, true)

				var24:GetComponent(typeof(CanvasGroup)).alpha = 1

				LeanTween.cancel(go(var44))
				LeanTween.cancel(go(var24))
				SetActive(var33, iter5:getIntimacy() < var11:getIntimacy())
				SetActive(var34, iter5:getIntimacy() > var11:getIntimacy())

				var26.localPosition = Vector3(0, 0, 0)

				setText(var43, var11.level)

				if iter5.level == iter5:getMaxLevel() then
					setText(var46, "+" .. math.ceil(var11:getExp() - iter5:getExp()))

					var47.fillAmount = 1
				else
					if iter5.level < var11.level then
						local var0 = 0

						for iter0 = iter5.level, var11.level - 1 do
							var0 = var0 + getExpByRarityFromLv1(var42, iter0)
						end

						setText(var46, "+" .. var0 + var11:getExp() - iter5:getExp())
					else
						setText(var46, "+" .. math.ceil(var11:getExp() - iter5:getExp()))
					end

					var47.fillAmount = var11:getExp() / getExpByRarityFromLv1(var42, var11.level)
				end

				SetActive(var44, false)
			end
		end
	end

	local var50 = var8[#var8]

	if var50 then
		var50:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
			arg0._stateFlag = var0.STATE_DISPLAYED

			if not arg0._subFirstExpTF then
				arg0:skip()
			end
		end)
	end

	if #var9 > 0 then
		var9[#var9]:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
			arg0._stateFlag = var0.STATE_SUB_DISPLAYED

			arg0:skip()
		end)
	end

	arg0.subTitleTxt.text = arg0.contextData.statistics.specificDamage
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

	local var3 = arg0.mvpShipVO or arg0.flagShipVO

	arg0.paintingName = var3:getPainting()

	setPaintingPrefabAsync(arg0._painting, arg0.paintingName, "jiesuan", function()
		if findTF(arg0._painting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0._painting, "fitter"):GetChild(0), arg0.paintingName, "win_mvp")
		end
	end)

	local var4, var5, var6 = ShipWordHelper.GetWordAndCV(var3.skinId, ShipWordHelper.WORD_TYPE_MVP)

	SetActive(arg0._failPainting, false)
	setText(arg0._chat:Find("Text"), var6)

	local var7 = arg0._chat:Find("Text"):GetComponent(typeof(Text))

	if #var7.text > CHAT_POP_STR_LEN then
		var7.alignment = TextAnchor.MiddleLeft
	else
		var7.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0._chat, true)

	arg0._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(arg0._painting))
	LeanTween.moveX(rtf(arg0._painting), 50, 0):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0._chat.gameObject), Vector3.New(1, 1, 1), 0):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
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
	local var0 = {
		function(arg0)
			arg0:showRewardInfo(arg0)
		end,
		function(arg0)
			arg0:displayShips()
			arg0:showRightBottomPanel()
		end
	}

	seriesAsync(var0)
end

function var0.playSubExEnter(arg0)
	arg0._stateFlag = var0.STATE_SUB_DISPLAY

	if arg0._subFirstExpTF then
		triggerToggle(arg0._subToggle, false)
		setActive(arg0._subFirstExpTF, true)
	else
		arg0:showRightBottomPanel()
	end
end

function var0.showRightBottomPanel(arg0)
	SetActive(arg0._skipBtn, false)
	SetActive(arg0._rightBottomPanel, true)
	SetActive(arg0._subToggle, arg0._subFirstExpTF ~= nil)
	setActive(arg0._statisticsBtn, false)
	onButton(arg0, arg0._confirmBtn, function()
		arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end, SFX_CONFIRM)

	arg0._stateFlag = nil
	arg0._subFirstExpTF = nil

	arg0:showStatistics()
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

function var0.onBackPressed(arg0)
	if arg0._stateFlag == var0.STATE_RANK_ANIMA then
		-- block empty
	elseif arg0._stateFlag == var0.STATE_REPORT then
		triggerButton(arg0._bg)
	elseif arg0._stateFlag == var0.STATE_DISPLAY then
		triggerButton(arg0._skipBtn)
	else
		triggerButton(arg0._confirmBtn)
	end
end

function var0.willExit(arg0)
	setActive(arg0.title, false)

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

	if arg0._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0._currentVoice)
	end

	arg0._currentVoice = nil

	pg.CameraFixMgr.GetInstance():disconnect(arg0.camEventId)
end

return var0
