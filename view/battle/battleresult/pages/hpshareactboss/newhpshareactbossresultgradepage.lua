local var0 = class("NewHpShareActBossResultGradePage", import("..activityBoss.NewActivityBossResultGradePage"))

function var0.LoadGrade(arg0, arg1)
	local var0 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0, arg0.gradeTxt, true)

	if arg1 then
		arg1()
	end
end

function var0.GetContributionPoint(arg0)
	local var0 = arg0.contextData
	local var1 = pg.activity_template[var0.actId]
	local var2 = pg.activity_event_worldboss[var1.config_id].damage_resource
	local var3 = 0

	for iter0, iter1 in ipairs(var0.drops) do
		if iter1.configId == var2 then
			var3 = iter1.count
		end
	end

	return var3
end

function var0.GetGetObjectives(arg0)
	local var0 = arg0.contextData
	local var1 = {}
	local var2 = arg0:GetContributionPoint()
	local var3 = i18n("battle_result_total_damage")

	table.insert(var1, {
		text = setColorStr(var3, "#FFFFFFFF"),
		value = setColorStr(var0.statistics.specificDamage, COLOR_BLUE)
	})

	local var4 = i18n("battle_result_contribution")

	table.insert(var1, {
		text = setColorStr(var4, "#FFFFFFFF"),
		value = setColorStr(var2, COLOR_YELLOW)
	})

	return var1
end

return var0
