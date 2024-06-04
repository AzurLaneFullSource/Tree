local var0 = class("BattleDodgemResultLayer", import(".BattleResultLayer"))

function var0.didEnter(arg0)
	local var0 = arg0.contextData.stageId
	local var1 = pg.expedition_data_template[var0]

	setText(arg0._levelText, var1.name)
	setText(findTF(arg0._conditions, "bg17"), i18n("battle_result_targets"))

	local var2 = rtf(arg0._grade)

	arg0._gradeUpperLeftPos = var2.localPosition
	var2.localPosition = Vector3(0, 25, 0)

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
	SetActive(arg0._conditionBGNormal, false)
	SetActive(arg0._conditionBGContribute, true)

	local var1 = arg0.contextData.statistics.dodgemResult

	arg0:setCondition(i18n("battle_result_total_score"), var1.score, COLOR_BLUE)
	arg0:setCondition(i18n("battle_result_max_combo"), var1.maxCombo, COLOR_YELLOW)

	local var2 = LeanTween.delayedCall(1, System.Action(function()
		arg0._stateFlag = var0.STATE_REPORTED

		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)
	end))

	table.insert(arg0._delayLeanList, var2.id)

	arg0._stateFlag = var0.STATE_REPORT
end

function var0.displayBG(arg0)
	local var0 = rtf(arg0._grade)

	LeanTween.moveX(rtf(arg0._conditions), 1300, var0.DURATION_MOVE)
	LeanTween.scale(arg0._grade, Vector3(0.6, 0.6, 0), var0.DURATION_MOVE)
	LeanTween.moveLocal(go(var0), arg0._gradeUpperLeftPos, var0.DURATION_MOVE):setOnComplete(System.Action(function()
		arg0:showPainting()
	end))
	setActive(arg0:findTF("jieuan01/Bomb", arg0._bg), false)
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

function var0.showPainting(arg0)
	local var0
	local var1

	SetActive(arg0._painting, true)

	arg0.paintingName = "yanzhan"

	setPaintingPrefabAsync(arg0._painting, arg0.paintingName, "jiesuan", function()
		if findTF(arg0._painting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(arg0._painting, "fitter"):GetChild(0), arg0.paintingName, "win_mvp")
		end
	end)
	SetActive(arg0._failPainting, false)

	if arg0.contextData.score > 1 then
		local var2

		var0, var2 = Ship.getWords(205020, "win_mvp")
	else
		local var3

		var0, var3 = Ship.getWords(205020, "lose")
	end

	setText(arg0._chat:Find("Text"), var0)

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

	arg0._stateFlag = BattleResultLayer.STATE_DISPLAYED
end

function var0.skip(arg0)
	if arg0._stateFlag == BattleResultLayer.STATE_REPORTED then
		arg0:displayBG()
	elseif arg0._stateFlag == BattleResultLayer.STATE_DISPLAYED then
		arg0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
	end
end

function var0.onBackPressed(arg0)
	triggerButton(arg0._skipBtn)
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0._tf))
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	pg.CameraFixMgr.GetInstance():disconnect(arg0.camEventId)
end

return var0
