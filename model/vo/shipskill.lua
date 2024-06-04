local var0 = class("ShipSkill", import(".BaseVO"))

function var0.Ctor(arg0, arg1, arg2)
	arg0.id = arg1.skill_id or arg1.id
	arg0.configId = arg0.id
	arg0.level = arg1.skill_lv or arg1.lv or arg1.level
	arg0.exp = arg1.skill_exp or arg1.exp
	arg0.maxLevel = arg0:getConfig("max_level")
	arg0.buff = require("GameCfg.buff.buff_" .. arg0.id)
	arg0.shipId = arg2
end

function var0.AddExp(arg0, arg1)
	if arg0:IsMaxLevel() then
		return
	end

	local var0 = arg0:GetMaxLevel()
	local var1 = arg1 + arg0.exp
	local var2 = arg0.level

	while var1 >= pg.skill_need_exp[var2].exp do
		var1 = var1 - pg.skill_need_exp[var2].exp
		var2 = var2 + 1

		if var2 == var0 then
			var1 = 0

			break
		end
	end

	arg0.level = var2
	arg0.exp = var1
end

function var0.GetExp(arg0)
	return arg0.exp
end

function var0.bindConfigTable(arg0)
	return pg.skill_data_template
end

function var0.GetMaxLevel(arg0)
	return arg0.maxLevel
end

function var0.WillReachMaxLevel(arg0)
	return arg0.level == arg0.maxLevel - 1
end

function var0.IsMaxLevel(arg0)
	return arg0.maxLevel <= arg0.level
end

function var0.GetNextLevelExp(arg0)
	return getConfigFromLevel1(pg.skill_need_exp, arg0.level).exp
end

function var0.StaticGetNextLevelExp(arg0)
	return getConfigFromLevel1(pg.skill_need_exp, arg0).exp
end

function var0.GetName(arg0)
	local var0 = arg0:GetDisplayId()

	return getSkillName(var0)
end

function var0.GetDesc(arg0)
	local var0 = arg0:GetDisplayId()

	return getSkillDesc(var0, arg0.level)
end

function var0.GetTacticsDesc(arg0)
	local var0 = arg0:GetDisplayId()

	return Student.getSkillDesc(var0, arg0.level)
end

function var0.GetIcon(arg0)
	local var0 = arg0:GetDisplayId()

	if var0 ~= arg0.id then
		return require("GameCfg.buff.buff_" .. var0).icon
	else
		return arg0.buff.icon
	end
end

function var0.GetColorType(arg0)
	local var0 = arg0:GetDisplayId()

	if var0 ~= arg0.id then
		return var0.bindConfigTable()[var0].type
	else
		return arg0:getConfig("type")
	end
end

function var0.GetDisplayId(arg0)
	local var0 = getProxy(BayProxy):RawGetShipById(arg0.shipId)

	return var0 and var0:RemapSkillId(arg0.id) or arg0.id
end

return var0
