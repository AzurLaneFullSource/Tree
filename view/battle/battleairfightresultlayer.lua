local var0_0 = class("BattleAirFightResultLayer", import(".BattleResultLayer"))

function var0_0.getUIName(arg0_1)
	return "BattleAirFightResultUI"
end

function var0_0.init(arg0_2)
	arg0_2._grade = arg0_2:findTF("grade")
	arg0_2._levelText = arg0_2:findTF("chapterName/Text22", arg0_2._grade)
	arg0_2._main = arg0_2:findTF("main")
	arg0_2._blurConatiner = arg0_2:findTF("blur_container")
	arg0_2._bg = arg0_2:findTF("main/jiesuanbeijing")
	arg0_2._painting = arg0_2:findTF("painting", arg0_2._blurConatiner)
	arg0_2._chat = arg0_2:findTF("chat", arg0_2._painting)
	arg0_2._rightBottomPanel = arg0_2:findTF("rightBottomPanel", arg0_2._blurConatiner)
	arg0_2._confirmBtn = arg0_2:findTF("confirmBtn", arg0_2._rightBottomPanel)

	setText(arg0_2._confirmBtn:Find("Text"), i18n("text_confirm"))

	arg0_2._statisticsBtn = arg0_2:findTF("statisticsBtn", arg0_2._rightBottomPanel)
	arg0_2._skipBtn = arg0_2:findTF("skipLayer", arg0_2._tf)
	arg0_2._conditions = arg0_2:findTF("main/conditions")
	arg0_2._conditionContainer = arg0_2:findTF("bg16/list", arg0_2._conditions)
	arg0_2._conditionTpl = arg0_2:findTF("bg16/conditionTpl", arg0_2._conditions)
	arg0_2._conditionSubTpl = arg0_2:findTF("bg16/conditionSubTpl", arg0_2._conditions)
	arg0_2._conditionContributeTpl = arg0_2:findTF("bg16/conditionContributeTpl", arg0_2._conditions)
	arg0_2._conditionBGContribute = arg0_2:findTF("bg16/bg_contribute", arg0_2._conditions)

	arg0_2:setGradeLabel()
	SetActive(arg0_2._levelText, false)

	arg0_2._delayLeanList = {}
end

function var0_0.setPlayer(arg0_3)
	return
end

function var0_0.setGradeLabel(arg0_4)
	local var0_4 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1_4 = arg0_4:findTF("grade/Xyz/bg13")
	local var2_4 = arg0_4:findTF("grade/Xyz/bg14")
	local var3_4
	local var4_4
	local var5_4
	local var6_4 = arg0_4.contextData.score
	local var7_4 = var6_4 > ys.Battle.BattleConst.BattleScore.C

	setActive(arg0_4:findTF("jieuan01/BG/bg_victory", arg0_4._bg), var7_4)
	setActive(arg0_4:findTF("jieuan01/BG/bg_fail", arg0_4._bg), not var7_4)

	local var8_4 = var0_4[var6_4 + 1]
	local var9_4 = "battlescore/battle_score_" .. var8_4 .. "/letter_" .. var8_4
	local var10_4 = "battlescore/battle_score_" .. var8_4 .. "/label_" .. var8_4

	LoadImageSpriteAsync(var9_4, var1_4, false)
	LoadImageSpriteAsync(var10_4, var2_4, false)
end

function var0_0.didEnter(arg0_5)
	arg0_5:setStageName()

	local var0_5 = rtf(arg0_5._grade)

	arg0_5._gradeUpperLeftPos = var0_5.localPosition
	var0_5.localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)

	arg0_5._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0_5._grade, Vector3(0.88, 0.88, 1), var0_0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0_5._levelText, true)
		arg0_5:rankAnimaFinish()
	end))

	arg0_5._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)
	arg0_5._stateFlag = BattleResultLayer.STATE_RANK_ANIMA

	onButton(arg0_5, arg0_5._skipBtn, function()
		arg0_5:skip()
	end, SFX_CONFIRM)
end

function var0_0.rankAnimaFinish(arg0_8)
	local var0_8 = arg0_8:findTF("main/conditions")

	SetActive(var0_8, true)

	local var1_8 = arg0_8.contextData.statistics._airFightStatistics

	arg0_8:setCondition(i18n("fighterplane_destroy_tip") .. var1_8.kill, var1_8.score, COLOR_BLUE)
	arg0_8:setCondition(i18n("fighterplane_hit_tip") .. var1_8.hit, -var1_8.lose, COLOR_BLUE)
	arg0_8:setCondition(i18n("fighterplane_score_tip"), var1_8.total, COLOR_YELLOW)

	local var2_8 = LeanTween.delayedCall(1, System.Action(function()
		arg0_8._stateFlag = var0_0.STATE_REPORTED

		SetActive(arg0_8:findTF("jieuan01/tips", arg0_8._bg), true)
	end))

	table.insert(arg0_8._delayLeanList, var2_8.id)

	arg0_8._stateFlag = var0_0.STATE_REPORT
end

function var0_0.setCondition(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = cloneTplTo(arg0_10._conditionContributeTpl, arg0_10._conditionContainer)

	setActive(var0_10, false)

	local var1_10

	var0_10:Find("text"):GetComponent(typeof(Text)).text = setColorStr(arg1_10, "#FFFFFFFF")
	var0_10:Find("value"):GetComponent(typeof(Text)).text = setColorStr(arg2_10, arg3_10)

	local var2_10 = arg0_10._conditionContainer.childCount - 1

	if var2_10 > 0 then
		local var3_10 = LeanTween.delayedCall(var0_0.CONDITIONS_FREQUENCE * var2_10, System.Action(function()
			setActive(var0_10, true)
		end))

		table.insert(arg0_10._delayLeanList, var3_10.id)
	else
		setActive(var0_10, true)
	end
end

function var0_0.displayBG(arg0_12)
	local var0_12 = rtf(arg0_12._grade)

	LeanTween.moveX(rtf(arg0_12._conditions), 1300, var0_0.DURATION_MOVE)
	LeanTween.scale(arg0_12._grade, Vector3(0.6, 0.6, 0), var0_0.DURATION_MOVE)
	LeanTween.moveLocal(go(var0_12), arg0_12._gradeUpperLeftPos, var0_0.DURATION_MOVE):setOnComplete(System.Action(function()
		arg0_12._stateFlag = var0_0.STATE_DISPLAY

		arg0_12:showPainting()

		arg0_12._stateFlag = var0_0.STATE_DISPLAYED
	end))
	setActive(arg0_12:findTF("jieuan01/Bomb", arg0_12._bg), false)
end

function var0_0.showPainting(arg0_14)
	SetActive(arg0_14._painting, true)

	arg0_14.paintingName = "yanzhan"

	setPaintingPrefabAsync(arg0_14._painting, arg0_14.paintingName, "jiesuan", function()
		if findTF(arg0_14._painting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0_14._painting, "fitter"):GetChild(0), arg0_14.paintingName, "win_mvp")
		end
	end)

	local var0_14 = arg0_14.contextData.score > 1 and ShipWordHelper.WORD_TYPE_MVP or ShipWordHelper.WORD_TYPE_LOSE
	local var1_14, var2_14, var3_14 = ShipWordHelper.GetWordAndCV(205020, var0_14)

	setText(arg0_14._chat:Find("Text"), var3_14)

	local var4_14 = arg0_14._chat:Find("Text"):GetComponent(typeof(Text))

	if #var4_14.text > CHAT_POP_STR_LEN then
		var4_14.alignment = TextAnchor.MiddleLeft
	else
		var4_14.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0_14._chat, true)

	arg0_14._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.moveX(rtf(arg0_14._painting), 50, 0.1):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_14._chat.gameObject), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeOutBack)
	end))
end

function var0_0.skip(arg0_17)
	if arg0_17._stateFlag == BattleResultLayer.STATE_REPORTED then
		arg0_17:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end
end

function var0_0.showRightBottomPanel(arg0_18)
	SetActive(arg0_18._skipBtn, false)
	SetActive(arg0_18._rightBottomPanel, true)
	SetActive(arg0_18._subToggle, false)
	onButton(arg0_18, arg0_18._confirmBtn, function()
		arg0_18:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end, SFX_CONFIRM)

	arg0_18._stateFlag = nil
end

function var0_0.onBackPressed(arg0_20)
	triggerButton(arg0_20._skipBtn)
end

function var0_0.willExit(arg0_21)
	LeanTween.cancel(go(arg0_21._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf)
end

return var0_0
