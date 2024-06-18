local var0_0 = class("BattleSubmarineRoutineResultLayer", import(".BattleResultLayer"))

function var0_0.rankAnimaFinish(arg0_1)
	local var0_1 = arg0_1:findTF("main/conditions")

	SetActive(var0_1, true)
	SetActive(var0_1:Find("bg16/bg_extra"), true)

	local var1_1 = arg0_1.contextData.statistics.subRunResult

	arg0_1:setCondition(i18n("battle_result_base_score"), "+" .. var1_1.basePoint, COLOR_BLUE, true)
	arg0_1:setCondition(i18n("battle_result_dead_score", var1_1.deadCount), "-" .. var1_1.losePoint, COLOR_BLUE, true)
	arg0_1:setCondition(i18n("battle_result_score", var1_1.score), "+" .. var1_1.point, COLOR_BLUE, true)
	arg0_1:setCondition(i18n("battle_result_score_total"), var1_1.total, COLOR_YELLOW)

	local var2_1 = LeanTween.delayedCall(1, System.Action(function()
		arg0_1._stateFlag = var0_0.STATE_REPORTED

		SetActive(arg0_1:findTF("jieuan01/tips", arg0_1._bg), true)
	end))

	table.insert(arg0_1._delayLeanList, var2_1.id)

	arg0_1._stateFlag = var0_0.STATE_REPORT
end

function var0_0.setCondition(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = cloneTplTo(arg0_3._conditionSubTpl, arg0_3._conditionContainer)

	setActive(var0_3, false)

	local var1_3

	var0_3:Find("text"):GetComponent(typeof(Text)).text = setColorStr(arg1_3, "#FFFFFFFF")
	var0_3:Find("value"):GetComponent(typeof(Text)).text = setColorStr(arg2_3, arg3_3)

	if arg4_3 then
		local var2_3 = "resources/condition_check"

		arg0_3:setSpriteTo(var2_3, var0_3:Find("checkBox"), true)
	else
		setActive(var0_3:Find("checkBox"), false)
	end

	local var3_3 = arg0_3._conditionContainer.childCount - 1

	if var3_3 > 0 then
		local var4_3 = LeanTween.delayedCall(var0_0.CONDITIONS_FREQUENCE * var3_3, System.Action(function()
			setActive(var0_3, true)
		end))

		table.insert(arg0_3._delayLeanList, var4_3.id)
	else
		setActive(var0_3, true)
	end
end

function var0_0.displayBG(arg0_5)
	local var0_5 = rtf(arg0_5._grade)

	LeanTween.moveX(rtf(arg0_5._conditions), 1300, var0_0.DURATION_MOVE)
	LeanTween.scale(arg0_5._grade, Vector3(0.6, 0.6, 0), var0_0.DURATION_MOVE)
	LeanTween.moveLocal(go(var0_5), arg0_5._gradeUpperLeftPos, var0_0.DURATION_MOVE):setOnComplete(System.Action(function()
		arg0_5:displayShips()
		arg0_5:displayPlayerInfo()
		arg0_5:playSubExEnter()
	end))
	setActive(arg0_5:findTF("jieuan01/Bomb", arg0_5._bg), false)
end

function var0_0.showRightBottomPanel(arg0_7)
	var0_0.super.showRightBottomPanel(arg0_7)
	setText(arg0_7._playerBonusExp, "+" .. arg0_7:calcPlayerProgress())
	SetActive(arg0_7._subToggle, false)
end

return var0_0
