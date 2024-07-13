local var0_0 = class("GuildTechnology", import("..BaseVO"))

var0_0.UPGRADE_TYPE_SELF = 1
var0_0.UPGRADE_TYPE_PUBLIC = 2

function var0_0.Ctor(arg0_1, arg1_1)
	local var0_1 = arg0_1:bindConfigTable().get_id_list_by_group[arg1_1.id][1]

	arg0_1:Update(var0_1, arg1_1)
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.group = arg2_2

	if arg0_2.group:GuildMemberCntType() then
		arg0_2.id = arg0_2.group.pid
	else
		arg0_2.id = arg1_2
	end

	arg0_2.configId = arg0_2.id
	arg0_2.level = arg0_2:getConfig("level")
end

function var0_0.GetShipAttrAddition(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:getConfig("effect_args")
	local var1_3 = var0_3[1]
	local var2_3 = var0_3[2]

	if var1_3 == arg1_3 and table.contains(var2_3, arg2_3) then
		return arg0_3:getConfig("num")
	else
		return 0
	end
end

function var0_0.GetTargetLivness(arg0_4)
	local var0_4 = arg0_4:GetNextLevelId()

	if var0_4 == 0 then
		return 0
	else
		return pg.guild_technology_template[var0_4].need_guild_active
	end
end

function var0_0.ReachTargetLiveness(arg0_5, arg1_5)
	return arg1_5:GetLiveness() >= arg0_5:GetTargetLivness()
end

function var0_0._ReachTargetLiveness_(arg0_6)
	local var0_6 = getProxy(PlayerProxy):getRawData().id
	local var1_6 = getProxy(GuildProxy):getRawData():getMemberById(var0_6)

	return arg0_6:ReachTargetLiveness(var1_6)
end

function var0_0.levelUp(arg0_7)
	local var0_7 = arg0_7:GetNextLevelId()

	if var0_7 ~= 0 then
		arg0_7:Update(var0_7, arg0_7.group)
	end
end

function var0_0.GetNextLevelId(arg0_8)
	return arg0_8:getConfig("next_tech")
end

function var0_0.GetLevel(arg0_9)
	return arg0_9.level
end

function var0_0.isMaxLevel(arg0_10)
	return arg0_10:GetLevel() >= arg0_10:GetMaxLevel()
end

function var0_0.CanUpgradeBySelf(arg0_11)
	local var0_11 = arg0_11:_ReachTargetLiveness_()
	local var1_11 = arg0_11:GetLevel() < arg0_11:GetMaxLevel()

	return var0_11 and var1_11, var0_11, var1_11
end

function var0_0.GetLivenessOffset(arg0_12)
	local var0_12 = getProxy(PlayerProxy):getRawData().id
	local var1_12 = getProxy(GuildProxy):getRawData():getMemberById(var0_12)

	return arg0_12:GetTargetLivness() - var1_12:GetLiveness()
end

function var0_0.GetUpgradeType(arg0_13)
	if arg0_13:CanUpgradeBySelf() then
		return var0_0.UPGRADE_TYPE_SELF
	else
		local var0_13 = arg0_13.group:GetFakeLevel()
		local var1_13 = arg0_13:GetMaxLevel()

		if var0_13 > arg0_13:GetLevel() then
			return var0_0.UPGRADE_TYPE_PUBLIC
		end
	end

	return false
end

function var0_0.CanUpgrade(arg0_14)
	return arg0_14:GetUpgradeType() ~= false
end

function var0_0.GetMaxLevel(arg0_15)
	return arg0_15.group:GetLevel()
end

function var0_0.bindConfigTable(arg0_16)
	return pg.guild_technology_template
end

function var0_0.GetDesc(arg0_17)
	local var0_17 = arg0_17:getConfig("effect_args")
	local var1_17 = arg0_17:getConfig("num")

	return GuildConst.GET_TECHNOLOGY_DESC(var0_17, var1_17)
end

function var0_0.getAddition(arg0_18)
	if arg0_18:GetLevel() > 0 then
		return arg0_18:getConfig("num")
	else
		return 0
	end
end

function var0_0.GetConsume(arg0_19)
	local var0_19 = arg0_19:getConfig("contribution_consume")
	local var1_19 = arg0_19:getConfig("gold_consume")

	if arg0_19:IsRiseInPrice() then
		local var2_19 = arg0_19:getConfig("contribution_multiple")

		return var0_19 * var2_19, var1_19 * var2_19
	else
		return var0_19, var1_19
	end
end

function var0_0.IsRiseInPrice(arg0_20)
	return arg0_20:GetUpgradeType() == var0_0.UPGRADE_TYPE_PUBLIC
end

function var0_0.IsGuildMember(arg0_21)
	return arg0_21:getConfig("group") == 1
end

return var0_0
