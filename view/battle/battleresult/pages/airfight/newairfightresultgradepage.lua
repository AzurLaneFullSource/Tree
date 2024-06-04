local var0 = class("NewAirFightResultGradePage", import("..NewBattleResultGradePage"))

function var0.LoadGrade(arg0, arg1)
	local var0 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var1 = arg0.contextData.score
	local var2

	var2 = var1 > ys.Battle.BattleConst.BattleScore.C

	local var3
	local var4
	local var5
	local var6 = var0[var1 + 1]
	local var7 = "battlescore/battle_score_" .. var6 .. "/letter_" .. var6
	local var8 = "battlescore/battle_score_" .. var6 .. "/label_" .. var6

	LoadImageSpriteAsync(var7, arg0.gradeIcon, true)
	LoadImageSpriteAsync(var8, arg0.gradeTxt, true)

	if arg1 then
		arg1()
	end
end

function var0.GetGetObjectives(arg0)
	local var0 = {}
	local var1 = arg0.contextData.statistics._airFightStatistics
	local var2 = i18n("fighterplane_destroy_tip") .. var1.kill

	table.insert(var0, {
		text = setColorStr(var2, "#FFFFFFFF"),
		value = setColorStr(var1.score, COLOR_BLUE)
	})

	local var3 = i18n("fighterplane_hit_tip") .. var1.hit

	table.insert(var0, {
		text = setColorStr(var3, "#FFFFFFFF"),
		value = setColorStr(-var1.lose, COLOR_BLUE)
	})

	local var4 = i18n("fighterplane_destroy_tip")

	table.insert(var0, {
		text = setColorStr(var4, "#FFFFFFFF"),
		value = setColorStr(var1.total, COLOR_YELLOW)
	})

	return var0
end

return var0
