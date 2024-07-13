local var0_0 = class("CommanderSkill", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.exp = arg1_1.exp
end

function var0_0.getExp(arg0_2)
	return arg0_2.exp
end

function var0_0.bindConfigTable(arg0_3)
	return pg.commander_skill_template
end

function var0_0.getLevel(arg0_4)
	return arg0_4:getConfig("lv")
end

function var0_0.isMaxLevel(arg0_5)
	return arg0_5:getConfig("next_id") == 0
end

function var0_0.getNextLevelExp(arg0_6)
	return arg0_6:getConfig("exp")
end

function var0_0.addExp(arg0_7, arg1_7)
	arg0_7.exp = arg0_7.exp + arg1_7

	while arg0_7:canLevelUp() do
		arg0_7.exp = arg0_7.exp - arg0_7:getNextLevelExp()
		arg0_7.id = arg0_7:getConfig("next_id")
		arg0_7.configId = arg0_7.id
	end
end

function var0_0.canLevelUp(arg0_8)
	return arg0_8:getNextLevelExp() <= arg0_8.exp and not arg0_8:isMaxLevel()
end

function var0_0.getTacticSkill(arg0_9)
	return arg0_9:getConfig("effect_tactic")
end

function var0_0.GetTacticSkillForWorld(arg0_10)
	return arg0_10:getConfig("effect_tactic_world")
end

function var0_0.GetSkillGroup(arg0_11)
	local var0_11 = {}
	local var1_11 = arg0_11:getConfig("prev_id")

	while var1_11 and var1_11 ~= 0 do
		local var2_11 = pg.commander_skill_template[var1_11]

		table.insert(var0_11, var2_11)

		var1_11 = var2_11.prev_id
	end

	table.insert(var0_11, pg.commander_skill_template[arg0_11.configId])

	local var3_11 = arg0_11:getConfig("next_id")

	while var3_11 and var3_11 ~= 0 do
		local var4_11 = pg.commander_skill_template[var3_11]

		table.insert(var0_11, var4_11)

		var3_11 = var4_11.next_id
	end

	table.sort(var0_11, function(arg0_12, arg1_12)
		return arg0_12.lv < arg1_12.lv
	end)

	return var0_11
end

return var0_0
