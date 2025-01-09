local var0_0 = class("ShipSkill", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1.skill_id or arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.level = arg1_1.skill_lv or arg1_1.lv or arg1_1.level
	arg0_1.exp = arg1_1.skill_exp or arg1_1.exp
	arg0_1.maxLevel = arg0_1:getConfig("max_level")
	arg0_1.buff = pg.buffCfg["buff_" .. arg0_1.id]
	arg0_1.shipId = arg2_1
end

function var0_0.AddExp(arg0_2, arg1_2)
	if arg0_2:IsMaxLevel() then
		return
	end

	local var0_2 = arg0_2:GetMaxLevel()
	local var1_2 = arg1_2 + arg0_2.exp
	local var2_2 = arg0_2.level

	while var1_2 >= pg.skill_need_exp[var2_2].exp do
		var1_2 = var1_2 - pg.skill_need_exp[var2_2].exp
		var2_2 = var2_2 + 1

		if var2_2 == var0_2 then
			var1_2 = 0

			break
		end
	end

	arg0_2.level = var2_2
	arg0_2.exp = var1_2
end

function var0_0.GetExp(arg0_3)
	return arg0_3.exp
end

function var0_0.bindConfigTable(arg0_4)
	return pg.skill_data_template
end

function var0_0.GetMaxLevel(arg0_5)
	return arg0_5.maxLevel
end

function var0_0.WillReachMaxLevel(arg0_6)
	return arg0_6.level == arg0_6.maxLevel - 1
end

function var0_0.IsMaxLevel(arg0_7)
	return arg0_7.maxLevel <= arg0_7.level
end

function var0_0.GetNextLevelExp(arg0_8)
	return getConfigFromLevel1(pg.skill_need_exp, arg0_8.level).exp
end

function var0_0.StaticGetNextLevelExp(arg0_9)
	return getConfigFromLevel1(pg.skill_need_exp, arg0_9).exp
end

function var0_0.GetName(arg0_10)
	local var0_10 = arg0_10:GetDisplayId()

	return getSkillName(var0_10)
end

function var0_0.GetDesc(arg0_11)
	local var0_11 = arg0_11:GetDisplayId()

	return getSkillDesc(var0_11, arg0_11.level)
end

function var0_0.GetTacticsDesc(arg0_12)
	local var0_12 = arg0_12:GetDisplayId()

	return Student.getSkillDesc(var0_12, arg0_12.level)
end

function var0_0.GetIcon(arg0_13)
	local var0_13 = arg0_13:GetDisplayId()

	if var0_13 ~= arg0_13.id then
		return pg.buffCfg["buff_" .. var0_13].icon
	else
		return arg0_13.buff.icon
	end
end

function var0_0.GetColorType(arg0_14)
	local var0_14 = arg0_14:GetDisplayId()

	if var0_14 ~= arg0_14.id then
		return var0_0.bindConfigTable()[var0_14].type
	else
		return arg0_14:getConfig("type")
	end
end

function var0_0.GetDisplayId(arg0_15)
	local var0_15 = getProxy(BayProxy):RawGetShipById(arg0_15.shipId)

	return var0_15 and var0_15:RemapSkillId(arg0_15.id) or arg0_15.id
end

return var0_0
