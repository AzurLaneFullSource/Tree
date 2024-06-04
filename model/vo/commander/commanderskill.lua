local var0 = class("CommanderSkill", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.exp = arg1.exp
end

function var0.getExp(arg0)
	return arg0.exp
end

function var0.bindConfigTable(arg0)
	return pg.commander_skill_template
end

function var0.getLevel(arg0)
	return arg0:getConfig("lv")
end

function var0.isMaxLevel(arg0)
	return arg0:getConfig("next_id") == 0
end

function var0.getNextLevelExp(arg0)
	return arg0:getConfig("exp")
end

function var0.addExp(arg0, arg1)
	arg0.exp = arg0.exp + arg1

	while arg0:canLevelUp() do
		arg0.exp = arg0.exp - arg0:getNextLevelExp()
		arg0.id = arg0:getConfig("next_id")
		arg0.configId = arg0.id
	end
end

function var0.canLevelUp(arg0)
	return arg0:getNextLevelExp() <= arg0.exp and not arg0:isMaxLevel()
end

function var0.getTacticSkill(arg0)
	return arg0:getConfig("effect_tactic")
end

function var0.GetTacticSkillForWorld(arg0)
	return arg0:getConfig("effect_tactic_world")
end

function var0.GetSkillGroup(arg0)
	local var0 = {}
	local var1 = arg0:getConfig("prev_id")

	while var1 and var1 ~= 0 do
		local var2 = pg.commander_skill_template[var1]

		table.insert(var0, var2)

		var1 = var2.prev_id
	end

	table.insert(var0, pg.commander_skill_template[arg0.configId])

	local var3 = arg0:getConfig("next_id")

	while var3 and var3 ~= 0 do
		local var4 = pg.commander_skill_template[var3]

		table.insert(var0, var4)

		var3 = var4.next_id
	end

	table.sort(var0, function(arg0, arg1)
		return arg0.lv < arg1.lv
	end)

	return var0
end

return var0
