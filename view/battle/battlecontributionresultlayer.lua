local var0 = class("BattleContributionResultLayer", import(".BattleActivityBossResultLayer"))

function var0.setActId(arg0, arg1)
	arg0._actID = arg1

	local var0 = pg.activity_template[arg1]

	arg0._resourceID = pg.activity_event_worldboss[var0.config_id].damage_resource
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	arg0:setPoint()
end

function var0.setPoint(arg0)
	arg0._contributionPoint = 0

	for iter0, iter1 in ipairs(arg0.contextData.drops) do
		if iter1.configId == arg0._resourceID then
			arg0._contributionPoint = iter1.count
		end
	end
end

function var0.setGradeLabel(arg0)
	local var0 = arg0:findTF("grade/Xyz/bg13")
	local var1 = arg0:findTF("grade/Xyz/bg14")

	setActive(var0, false)

	local var2 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var2, var1, false)
end

function var0.rankAnimaFinish(arg0)
	setActive(arg0._conditionBGNormal, false)
	setActive(arg0._conditionBGContribute, true)
	arg0:setCondition(i18n("battle_result_total_damage"), arg0.contextData.statistics.specificDamage, COLOR_BLUE)
	arg0:setCondition(i18n("battle_result_contribution"), arg0._contributionPoint, COLOR_YELLOW)

	local var0 = LeanTween.delayedCall(1, System.Action(function()
		arg0._stateFlag = var0.STATE_REPORTED

		SetActive(arg0:findTF("jieuan01/tips", arg0._bg), true)
	end))

	table.insert(arg0._delayLeanList, var0.id)

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

return var0
