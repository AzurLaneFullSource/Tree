local var0 = class("GuildDonateTask", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
end

function var0.bindConfigTable(arg0)
	return pg.guild_contribution_template
end

function var0.getCommitItem(arg0)
	return {
		arg0:getConfig("type"),
		arg0:getConfig("type_id"),
		arg0:getConfig("consume")
	}
end

function var0.getCapital(arg0)
	return arg0:getConfig("award_capital")
end

function var0.GetLivenessAddition(arg0)
	return arg0:getConfig("guild_active")
end

function var0.canCommit(arg0)
	local var0 = arg0:getCommitItem()

	if var0[1] == DROP_TYPE_RESOURCE then
		if getProxy(PlayerProxy):getData()[id2res(var0[2])] < var0[3] then
			return false
		end
	elseif var0[1] == DROP_TYPE_ITEM then
		if getProxy(BagProxy):getItemCountById(var0[2]) < var0[3] then
			return false
		end
	else
		assert(false)
	end

	return true
end

return var0
