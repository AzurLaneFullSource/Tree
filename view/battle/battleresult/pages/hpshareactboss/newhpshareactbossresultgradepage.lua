local var0_0 = class("NewHpShareActBossResultGradePage", import("..activityBoss.NewActivityBossResultGradePage"))

function var0_0.LoadGrade(arg0_1, arg1_1)
	local var0_1 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0_1, arg0_1.gradeTxt, true)

	if arg1_1 then
		arg1_1()
	end
end

function var0_0.GetContributionPoint(arg0_2)
	local var0_2 = arg0_2.contextData
	local var1_2 = pg.activity_template[var0_2.actId]
	local var2_2 = pg.activity_event_worldboss[var1_2.config_id].damage_resource
	local var3_2 = 0

	for iter0_2, iter1_2 in ipairs(var0_2.drops) do
		if iter1_2.configId == var2_2 then
			var3_2 = iter1_2.count
		end
	end

	return var3_2
end

function var0_0.GetGetObjectives(arg0_3)
	local var0_3 = arg0_3.contextData
	local var1_3 = {}
	local var2_3 = arg0_3:GetContributionPoint()
	local var3_3 = i18n("battle_result_total_damage")

	table.insert(var1_3, {
		text = setColorStr(var3_3, "#FFFFFFFF"),
		value = setColorStr(var0_3.statistics.specificDamage, COLOR_BLUE)
	})

	local var4_3 = i18n("battle_result_contribution")

	table.insert(var1_3, {
		text = setColorStr(var4_3, "#FFFFFFFF"),
		value = setColorStr(var2_3, COLOR_YELLOW)
	})

	return var1_3
end

return var0_0
