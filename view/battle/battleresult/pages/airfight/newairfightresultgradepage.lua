local var0_0 = class("NewAirFightResultGradePage", import("..NewBattleResultGradePage"))

function var0_0.LoadGrade(arg0_1, arg1_1)
	local var0_1 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1_1 = arg0_1.contextData.score
	local var2_1

	var2_1 = var1_1 > ys.Battle.BattleConst.BattleScore.C

	local var3_1
	local var4_1
	local var5_1
	local var6_1 = var0_1[var1_1 + 1]
	local var7_1 = "battlescore/battle_score_" .. var6_1 .. "/letter_" .. var6_1
	local var8_1 = "battlescore/battle_score_" .. var6_1 .. "/label_" .. var6_1

	LoadImageSpriteAsync(var7_1, arg0_1.gradeIcon, true)
	LoadImageSpriteAsync(var8_1, arg0_1.gradeTxt, true)

	if arg1_1 then
		arg1_1()
	end
end

function var0_0.GetGetObjectives(arg0_2)
	local var0_2 = {}
	local var1_2 = arg0_2.contextData.statistics._airFightStatistics
	local var2_2 = i18n("fighterplane_destroy_tip") .. var1_2.kill

	table.insert(var0_2, {
		text = setColorStr(var2_2, "#FFFFFFFF"),
		value = setColorStr(var1_2.score, COLOR_BLUE)
	})

	local var3_2 = i18n("fighterplane_hit_tip") .. var1_2.hit

	table.insert(var0_2, {
		text = setColorStr(var3_2, "#FFFFFFFF"),
		value = setColorStr(-var1_2.lose, COLOR_BLUE)
	})

	local var4_2 = i18n("fighterplane_destroy_tip")

	table.insert(var0_2, {
		text = setColorStr(var4_2, "#FFFFFFFF"),
		value = setColorStr(var1_2.total, COLOR_YELLOW)
	})

	return var0_2
end

return var0_0
