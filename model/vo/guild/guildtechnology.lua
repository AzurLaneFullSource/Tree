local var0 = class("GuildTechnology", import("..BaseVO"))

var0.UPGRADE_TYPE_SELF = 1
var0.UPGRADE_TYPE_PUBLIC = 2

function var0.Ctor(arg0, arg1)
	local var0 = arg0:bindConfigTable().get_id_list_by_group[arg1.id][1]

	arg0:Update(var0, arg1)
end

function var0.Update(arg0, arg1, arg2)
	arg0.group = arg2

	if arg0.group:GuildMemberCntType() then
		arg0.id = arg0.group.pid
	else
		arg0.id = arg1
	end

	arg0.configId = arg0.id
	arg0.level = arg0:getConfig("level")
end

function var0.GetShipAttrAddition(arg0, arg1, arg2)
	local var0 = arg0:getConfig("effect_args")
	local var1 = var0[1]
	local var2 = var0[2]

	if var1 == arg1 and table.contains(var2, arg2) then
		return arg0:getConfig("num")
	else
		return 0
	end
end

function var0.GetTargetLivness(arg0)
	local var0 = arg0:GetNextLevelId()

	if var0 == 0 then
		return 0
	else
		return pg.guild_technology_template[var0].need_guild_active
	end
end

function var0.ReachTargetLiveness(arg0, arg1)
	return arg1:GetLiveness() >= arg0:GetTargetLivness()
end

function var0._ReachTargetLiveness_(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = getProxy(GuildProxy):getRawData():getMemberById(var0)

	return arg0:ReachTargetLiveness(var1)
end

function var0.levelUp(arg0)
	local var0 = arg0:GetNextLevelId()

	if var0 ~= 0 then
		arg0:Update(var0, arg0.group)
	end
end

function var0.GetNextLevelId(arg0)
	return arg0:getConfig("next_tech")
end

function var0.GetLevel(arg0)
	return arg0.level
end

function var0.isMaxLevel(arg0)
	return arg0:GetLevel() >= arg0:GetMaxLevel()
end

function var0.CanUpgradeBySelf(arg0)
	local var0 = arg0:_ReachTargetLiveness_()
	local var1 = arg0:GetLevel() < arg0:GetMaxLevel()

	return var0 and var1, var0, var1
end

function var0.GetLivenessOffset(arg0)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = getProxy(GuildProxy):getRawData():getMemberById(var0)

	return arg0:GetTargetLivness() - var1:GetLiveness()
end

function var0.GetUpgradeType(arg0)
	if arg0:CanUpgradeBySelf() then
		return var0.UPGRADE_TYPE_SELF
	else
		local var0 = arg0.group:GetFakeLevel()
		local var1 = arg0:GetMaxLevel()

		if var0 > arg0:GetLevel() then
			return var0.UPGRADE_TYPE_PUBLIC
		end
	end

	return false
end

function var0.CanUpgrade(arg0)
	return arg0:GetUpgradeType() ~= false
end

function var0.GetMaxLevel(arg0)
	return arg0.group:GetLevel()
end

function var0.bindConfigTable(arg0)
	return pg.guild_technology_template
end

function var0.GetDesc(arg0)
	local var0 = arg0:getConfig("effect_args")
	local var1 = arg0:getConfig("num")

	return GuildConst.GET_TECHNOLOGY_DESC(var0, var1)
end

function var0.getAddition(arg0)
	if arg0:GetLevel() > 0 then
		return arg0:getConfig("num")
	else
		return 0
	end
end

function var0.GetConsume(arg0)
	local var0 = arg0:getConfig("contribution_consume")
	local var1 = arg0:getConfig("gold_consume")

	if arg0:IsRiseInPrice() then
		local var2 = arg0:getConfig("contribution_multiple")

		return var0 * var2, var1 * var2
	else
		return var0, var1
	end
end

function var0.IsRiseInPrice(arg0)
	return arg0:GetUpgradeType() == var0.UPGRADE_TYPE_PUBLIC
end

function var0.IsGuildMember(arg0)
	return arg0:getConfig("group") == 1
end

return var0
