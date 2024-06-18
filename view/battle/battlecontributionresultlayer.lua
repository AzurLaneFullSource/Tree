local var0_0 = class("BattleContributionResultLayer", import(".BattleActivityBossResultLayer"))

function var0_0.setActId(arg0_1, arg1_1)
	arg0_1._actID = arg1_1

	local var0_1 = pg.activity_template[arg1_1]

	arg0_1._resourceID = pg.activity_event_worldboss[var0_1.config_id].damage_resource
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)
	arg0_2:setPoint()
end

function var0_0.setPoint(arg0_3)
	arg0_3._contributionPoint = 0

	for iter0_3, iter1_3 in ipairs(arg0_3.contextData.drops) do
		if iter1_3.configId == arg0_3._resourceID then
			arg0_3._contributionPoint = iter1_3.count
		end
	end
end

function var0_0.setGradeLabel(arg0_4)
	local var0_4 = arg0_4:findTF("grade/Xyz/bg13")
	local var1_4 = arg0_4:findTF("grade/Xyz/bg14")

	setActive(var0_4, false)

	local var2_4 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var2_4, var1_4, false)
end

function var0_0.rankAnimaFinish(arg0_5)
	setActive(arg0_5._conditionBGNormal, false)
	setActive(arg0_5._conditionBGContribute, true)
	arg0_5:setCondition(i18n("battle_result_total_damage"), arg0_5.contextData.statistics.specificDamage, COLOR_BLUE)
	arg0_5:setCondition(i18n("battle_result_contribution"), arg0_5._contributionPoint, COLOR_YELLOW)

	local var0_5 = LeanTween.delayedCall(1, System.Action(function()
		arg0_5._stateFlag = var0_0.STATE_REPORTED

		SetActive(arg0_5:findTF("jieuan01/tips", arg0_5._bg), true)
	end))

	table.insert(arg0_5._delayLeanList, var0_5.id)

	arg0_5._stateFlag = var0_0.STATE_REPORT
end

function var0_0.setCondition(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = cloneTplTo(arg0_7._conditionContributeTpl, arg0_7._conditionContainer)

	setActive(var0_7, false)

	local var1_7

	var0_7:Find("text"):GetComponent(typeof(Text)).text = setColorStr(arg1_7, "#FFFFFFFF")
	var0_7:Find("value"):GetComponent(typeof(Text)).text = setColorStr(arg2_7, arg3_7)

	local var2_7 = arg0_7._conditionContainer.childCount - 1

	if var2_7 > 0 then
		local var3_7 = LeanTween.delayedCall(var0_0.CONDITIONS_FREQUENCE * var2_7, System.Action(function()
			setActive(var0_7, true)
		end))

		table.insert(arg0_7._delayLeanList, var3_7.id)
	else
		setActive(var0_7, true)
	end
end

return var0_0
