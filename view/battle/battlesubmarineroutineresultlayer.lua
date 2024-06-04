local var0 = class("BattleSubmarineRoutineResultLayer", import(".BattleResultLayer"))

function var0.rankAnimaFinish(arg0)
	local var0 = arg0:findTF("main/conditions")

	SetActive(var0, true)
	SetActive(var0:Find("bg16/bg_extra"), true)

	local var1 = arg0.contextData.statistics.subRunResult

	arg0:setCondition(i18n("battle_result_base_score"), "+" .. var1.basePoint, COLOR_BLUE, true)
	arg0:setCondition(i18n("battle_result_dead_score", var1.deadCount), "-" .. var1.losePoint, COLOR_BLUE, true)
	arg0:setCondition(i18n("battle_result_score", var1.score), "+" .. var1.point, COLOR_BLUE, true)
	arg0:setCondition(i18n("battle_result_score_total"), var1.total, COLOR_YELLOW)

	local var2 = LeanTween.delayedCall(1, System.Action(function()
		arg0._stateFlag = var0.STATE_REPORTED

		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)
	end))

	table.insert(arg0._delayLeanList, var2.id)

	arg0._stateFlag = var0.STATE_REPORT
end

function var0.setCondition(arg0, arg1, arg2, arg3, arg4)
	local var0 = cloneTplTo(arg0._conditionSubTpl, arg0._conditionContainer)

	setActive(var0, false)

	local var1

	var0:Find("text"):GetComponent(typeof(Text)).text = setColorStr(arg1, "#FFFFFFFF")
	var0:Find("value"):GetComponent(typeof(Text)).text = setColorStr(arg2, arg3)

	if arg4 then
		local var2 = "resources/condition_check"

		arg0:setSpriteTo(var2, var0:Find("checkBox"), true)
	else
		setActive(var0:Find("checkBox"), false)
	end

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

function var0.displayBG(arg0)
	local var0 = rtf(arg0._grade)

	LeanTween.moveX(rtf(arg0._conditions), 1300, var0.DURATION_MOVE)
	LeanTween.scale(arg0._grade, Vector3(0.6, 0.6, 0), var0.DURATION_MOVE)
	LeanTween.moveLocal(go(var0), arg0._gradeUpperLeftPos, var0.DURATION_MOVE):setOnComplete(System.Action(function()
		arg0:displayShips()
		arg0:displayPlayerInfo()
		arg0:playSubExEnter()
	end))
	setActive(arg0:findTF("jieuan01/Bomb", arg0._bg), false)
end

function var0.showRightBottomPanel(arg0)
	var0.super.showRightBottomPanel(arg0)
	setText(arg0._playerBonusExp, "+" .. arg0:calcPlayerProgress())
	SetActive(arg0._subToggle, false)
end

return var0
