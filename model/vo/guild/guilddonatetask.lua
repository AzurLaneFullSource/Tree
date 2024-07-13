local var0_0 = class("GuildDonateTask", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.guild_contribution_template
end

function var0_0.getCommitItem(arg0_3)
	return {
		arg0_3:getConfig("type"),
		arg0_3:getConfig("type_id"),
		arg0_3:getConfig("consume")
	}
end

function var0_0.getCapital(arg0_4)
	return arg0_4:getConfig("award_capital")
end

function var0_0.GetLivenessAddition(arg0_5)
	return arg0_5:getConfig("guild_active")
end

function var0_0.canCommit(arg0_6)
	local var0_6 = arg0_6:getCommitItem()

	if var0_6[1] == DROP_TYPE_RESOURCE then
		if getProxy(PlayerProxy):getData()[id2res(var0_6[2])] < var0_6[3] then
			return false
		end
	elseif var0_6[1] == DROP_TYPE_ITEM then
		if getProxy(BagProxy):getItemCountById(var0_6[2]) < var0_6[3] then
			return false
		end
	else
		assert(false)
	end

	return true
end

return var0_0
