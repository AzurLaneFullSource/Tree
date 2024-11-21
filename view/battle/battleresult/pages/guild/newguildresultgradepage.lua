local var0_0 = class("NewGuildResultGradePage", import("..NewBattleResultGradePage"))

function var0_0.LoadBG(arg0_1, arg1_1)
	local var0_1 = "Victory"

	LoadAnyAsync("BattleResultItems/" .. var0_1, "", nil, function(arg0_2)
		if arg0_1.exited or IsNil(arg0_2) then
			if arg1_1 then
				arg1_1()
			end

			return
		end

		Object.Instantiate(arg0_2, arg0_1.bgTr).transform:SetAsFirstSibling()

		if arg1_1 then
			arg1_1()
		end
	end)
end

function var0_0.LoadGrade(arg0_3, arg1_3)
	local var0_3 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0_3, arg0_3.gradeTxt, true)

	if arg1_3 then
		arg1_3()
	end
end

function var0_0.GetContributionPoint(arg0_4)
	local var0_4 = 0
	local var1_4 = pg.guildset.guild_damage_resource.key_value

	for iter0_4, iter1_4 in ipairs(arg0_4.contextData.drops) do
		if iter1_4.configId == var1_4 then
			var0_4 = iter1_4.count
		end
	end

	return var0_4
end

function var0_0.GetGetObjectives(arg0_5)
	local var0_5 = {}
	local var1_5 = i18n("battle_result_total_damage")

	table.insert(var0_5, {
		text = setColorStr(var1_5, "#FFFFFFFF"),
		value = setColorStr(arg0_5.contextData.statistics.specificDamage, COLOR_BLUE)
	})

	local var2_5 = i18n("battle_result_contribution")

	table.insert(var0_5, {
		text = setColorStr(var2_5, "#FFFFFFFF"),
		value = setColorStr(arg0_5:GetContributionPoint(), COLOR_YELLOW)
	})

	return var0_5
end

return var0_0
