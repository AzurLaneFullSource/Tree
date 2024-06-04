local var0 = class("BattleAirFightResultLayer", import(".BattleResultLayer"))

function var0.getUIName(arg0)
	return "BattleAirFightResultUI"
end

function var0.init(arg0)
	arg0._grade = arg0:findTF("grade")
	arg0._levelText = arg0:findTF("chapterName/Text22", arg0._grade)
	arg0._main = arg0:findTF("main")
	arg0._blurConatiner = arg0:findTF("blur_container")
	arg0._bg = arg0:findTF("main/jiesuanbeijing")
	arg0._painting = arg0:findTF("painting", arg0._blurConatiner)
	arg0._chat = arg0:findTF("chat", arg0._painting)
	arg0._rightBottomPanel = arg0:findTF("rightBottomPanel", arg0._blurConatiner)
	arg0._confirmBtn = arg0:findTF("confirmBtn", arg0._rightBottomPanel)

	setText(arg0._confirmBtn:Find("Text"), i18n("text_confirm"))

	arg0._statisticsBtn = arg0:findTF("statisticsBtn", arg0._rightBottomPanel)
	arg0._skipBtn = arg0:findTF("skipLayer", arg0._tf)
	arg0._conditions = arg0:findTF("main/conditions")
	arg0._conditionContainer = arg0:findTF("bg16/list", arg0._conditions)
	arg0._conditionTpl = arg0:findTF("bg16/conditionTpl", arg0._conditions)
	arg0._conditionSubTpl = arg0:findTF("bg16/conditionSubTpl", arg0._conditions)
	arg0._conditionContributeTpl = arg0:findTF("bg16/conditionContributeTpl", arg0._conditions)
	arg0._conditionBGContribute = arg0:findTF("bg16/bg_contribute", arg0._conditions)

	arg0:setGradeLabel()
	SetActive(arg0._levelText, false)

	arg0._delayLeanList = {}
end

function var0.setPlayer(arg0)
	return
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
	local var7 = var6 > ys.Battle.BattleConst.BattleScore.C

	setActive(arg0:findTF("jieuan01/BG/bg_victory", arg0._bg), var7)
	setActive(arg0:findTF("jieuan01/BG/bg_fail", arg0._bg), not var7)

	local var8 = var0[var6 + 1]
	local var9 = "battlescore/battle_score_" .. var8 .. "/letter_" .. var8
	local var10 = "battlescore/battle_score_" .. var8 .. "/label_" .. var8

	LoadImageSpriteAsync(var9, var1, false)
	LoadImageSpriteAsync(var10, var2, false)
end

function var0.didEnter(arg0)
	arg0:setStageName()

	local var0 = rtf(arg0._grade)

	arg0._gradeUpperLeftPos = var0.localPosition
	var0.localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0._grade, Vector3(0.88, 0.88, 1), var0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0._levelText, true)
		arg0:rankAnimaFinish()
	end))

	arg0._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)
	arg0._stateFlag = BattleResultLayer.STATE_RANK_ANIMA

	onButton(arg0, arg0._skipBtn, function()
		arg0:skip()
	end, SFX_CONFIRM)
end

function var0.rankAnimaFinish(arg0)
	local var0 = arg0:findTF("main/conditions")

	SetActive(var0, true)

	local var1 = arg0.contextData.statistics._airFightStatistics

	arg0:setCondition(i18n("fighterplane_destroy_tip") .. var1.kill, var1.score, COLOR_BLUE)
	arg0:setCondition(i18n("fighterplane_hit_tip") .. var1.hit, -var1.lose, COLOR_BLUE)
	arg0:setCondition(i18n("fighterplane_score_tip"), var1.total, COLOR_YELLOW)

	local var2 = LeanTween.delayedCall(1, System.Action(function()
		arg0._stateFlag = var0.STATE_REPORTED

		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)
	end))

	table.insert(arg0._delayLeanList, var2.id)

	arg0._stateFlag = var0.STATE_REPORT
end

function var0.setCondition(arg0, arg1, arg2, arg3)
	local var0 = cloneTplTo(arg0._conditionContributeTpl, arg0._conditionContainer)

	setActive(var0, false)

	local var1

	var0:Find("text"):GetComponent(typeof(Text)).text = setColorStr(arg1, "#FFFFFFFF")
	var0:Find("value"):GetComponent(typeof(Text)).text = setColorStr(arg2, arg3)

	local var2 = arg0._conditionContainer.childCount - 1

	if var2 > 0 then
		local var3 = LeanTween.delayedCall(var0.CONDITIONS_FREQUENCE * var2, System.Action(function()
			setActive(var0, true)
		end))

		table.insert(arg0._delayLeanList, var3.id)
	else
		setActive(var0, true)
	end
end

function var0.displayBG(arg0)
	local var0 = rtf(arg0._grade)

	LeanTween.moveX(rtf(arg0._conditions), 1300, var0.DURATION_MOVE)
	LeanTween.scale(arg0._grade, Vector3(0.6, 0.6, 0), var0.DURATION_MOVE)
	LeanTween.moveLocal(go(var0), arg0._gradeUpperLeftPos, var0.DURATION_MOVE):setOnComplete(System.Action(function()
		arg0._stateFlag = var0.STATE_DISPLAY

		arg0:showPainting()

		arg0._stateFlag = var0.STATE_DISPLAYED
	end))
	setActive(arg0:findTF("jieuan01/Bomb", arg0._bg), false)
end

function var0.showPainting(arg0)
	SetActive(arg0._painting, true)

	arg0.paintingName = "yanzhan"

	setPaintingPrefabAsync(arg0._painting, arg0.paintingName, "jiesuan", function()
		if findTF(arg0._painting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0._painting, "fitter"):GetChild(0), arg0.paintingName, "win_mvp")
		end
	end)

	local var0 = arg0.contextData.score > 1 and ShipWordHelper.WORD_TYPE_MVP or ShipWordHelper.WORD_TYPE_LOSE
	local var1, var2, var3 = ShipWordHelper.GetWordAndCV(205020, var0)

	setText(arg0._chat:Find("Text"), var3)

	local var4 = arg0._chat:Find("Text"):GetComponent(typeof(Text))

	if #var4.text > CHAT_POP_STR_LEN then
		var4.alignment = TextAnchor.MiddleLeft
	else
		var4.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0._chat, true)

	arg0._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.moveX(rtf(arg0._painting), 50, 0.1):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0._chat.gameObject), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeOutBack)
	end))
end

function var0.skip(arg0)
	if arg0._stateFlag == BattleResultLayer.STATE_REPORTED then
		arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end
end

function var0.showRightBottomPanel(arg0)
	SetActive(arg0._skipBtn, false)
	SetActive(arg0._rightBottomPanel, true)
	SetActive(arg0._subToggle, false)
	onButton(arg0, arg0._confirmBtn, function()
		arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end, SFX_CONFIRM)

	arg0._stateFlag = nil
end

function var0.onBackPressed(arg0)
	triggerButton(arg0._skipBtn)
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
