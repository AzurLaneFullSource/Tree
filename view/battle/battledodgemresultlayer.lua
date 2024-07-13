local var0_0 = class("BattleDodgemResultLayer", import(".BattleResultLayer"))

function var0_0.didEnter(arg0_1)
	local var0_1 = arg0_1.contextData.stageId
	local var1_1 = pg.expedition_data_template[var0_1]

	setText(arg0_1._levelText, var1_1.name)
	setText(findTF(arg0_1._conditions, "bg17"), i18n("battle_result_targets"))

	local var2_1 = rtf(arg0_1._grade)

	arg0_1._gradeUpperLeftPos = var2_1.localPosition
	var2_1.localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(arg0_1._tf)

	arg0_1._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(arg0_1._grade, Vector3(0.88, 0.88, 1), var0_0.DURATION_WIN_SCALE):setOnComplete(System.Action(function()
		SetActive(arg0_1._levelText, true)
		arg0_1:rankAnimaFinish()
	end))

	arg0_1._tf:GetComponent(typeof(Image)).color = Color.New(0, 0, 0, 0.5)
	arg0_1._stateFlag = BattleResultLayer.STATE_RANK_ANIMA

	onButton(arg0_1, arg0_1._skipBtn, function()
		arg0_1:skip()
	end, SFX_CONFIRM)
end

function var0_0.rankAnimaFinish(arg0_4)
	local var0_4 = arg0_4:findTF("main/conditions")

	SetActive(var0_4, true)
	SetActive(arg0_4._conditionBGNormal, false)
	SetActive(arg0_4._conditionBGContribute, true)

	local var1_4 = arg0_4.contextData.statistics.dodgemResult

	arg0_4:setCondition(i18n("battle_result_total_score"), var1_4.score, COLOR_BLUE)
	arg0_4:setCondition(i18n("battle_result_max_combo"), var1_4.maxCombo, COLOR_YELLOW)

	local var2_4 = LeanTween.delayedCall(1, System.Action(function()
		arg0_4._stateFlag = var0_0.STATE_REPORTED

		SetActive(arg0_4:findTF("jieuan01/tips", arg0_4._bg), true)
	end))

	table.insert(arg0_4._delayLeanList, var2_4.id)

	arg0_4._stateFlag = var0_0.STATE_REPORT
end

function var0_0.displayBG(arg0_6)
	local var0_6 = rtf(arg0_6._grade)

	LeanTween.moveX(rtf(arg0_6._conditions), 1300, var0_0.DURATION_MOVE)
	LeanTween.scale(arg0_6._grade, Vector3(0.6, 0.6, 0), var0_0.DURATION_MOVE)
	LeanTween.moveLocal(go(var0_6), arg0_6._gradeUpperLeftPos, var0_0.DURATION_MOVE):setOnComplete(System.Action(function()
		arg0_6:showPainting()
	end))
	setActive(arg0_6:findTF("jieuan01/Bomb", arg0_6._bg), false)
end

function var0_0.setCondition(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = cloneTplTo(arg0_8._conditionContributeTpl, arg0_8._conditionContainer)

	setActive(var0_8, false)

	local var1_8

	var0_8:Find("text"):GetComponent(typeof(Text)).text = setColorStr(arg1_8, "#FFFFFFFF")
	var0_8:Find("value"):GetComponent(typeof(Text)).text = setColorStr(arg2_8, arg3_8)

	local var2_8 = arg0_8._conditionContainer.childCount - 1

	if var2_8 > 0 then
		local var3_8 = LeanTween.delayedCall(var0_0.CONDITIONS_FREQUENCE * var2_8, System.Action(function()
			setActive(var0_8, true)
		end))

		table.insert(arg0_8._delayLeanList, var3_8.id)
	else
		setActive(var0_8, true)
	end
end

function var0_0.showPainting(arg0_10)
	local var0_10
	local var1_10

	SetActive(arg0_10._painting, true)

	arg0_10.paintingName = "yanzhan"

	setPaintingPrefabAsync(arg0_10._painting, arg0_10.paintingName, "jiesuan", function()
		if findTF(arg0_10._painting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0_10._painting, "fitter"):GetChild(0), arg0_10.paintingName, "win_mvp")
		end
	end)
	SetActive(arg0_10._failPainting, false)

	if arg0_10.contextData.score > 1 then
		local var2_10

		var0_10, var2_10 = Ship.getWords(205020, "win_mvp")
	else
		local var3_10

		var0_10, var3_10 = Ship.getWords(205020, "lose")
	end

	setText(arg0_10._chat:Find("Text"), var0_10)

	local var4_10 = arg0_10._chat:Find("Text"):GetComponent(typeof(Text))

	if #var4_10.text > CHAT_POP_STR_LEN then
		var4_10.alignment = TextAnchor.MiddleLeft
	else
		var4_10.alignment = TextAnchor.MiddleCenter
	end

	SetActive(arg0_10._chat, true)

	arg0_10._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.moveX(rtf(arg0_10._painting), 50, 0.1):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_10._chat.gameObject), Vector3.New(1, 1, 1), 0.1):setEase(LeanTweenType.easeOutBack)
	end))

	arg0_10._stateFlag = BattleResultLayer.STATE_DISPLAYED
end

function var0_0.skip(arg0_13)
	if arg0_13._stateFlag == BattleResultLayer.STATE_REPORTED then
		arg0_13:displayBG()
	elseif arg0_13._stateFlag == BattleResultLayer.STATE_DISPLAYED then
		arg0_13:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end
end

function var0_0.onBackPressed(arg0_14)
	triggerButton(arg0_14._skipBtn)
end

function var0_0.willExit(arg0_15)
	LeanTween.cancel(go(arg0_15._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0_15._tf)
	pg.CameraFixMgr.GetInstance():disconnect(arg0_15.camEventId)
end

return var0_0
