local var0 = class("BaseGuild", import("...BaseVO"))

function var0.GetTechnologys(arg0)
	assert(false)
end

function var0.getAddition(arg0, arg1)
	local var0 = 0
	local var1 = GuildConst.TYPE_TO_GROUP[arg1]

	return var0 + arg0:GetTechnologys()[var1]:getAddition()
end

function var0.getMaxOilAddition(arg0)
	return arg0:getAddition(GuildConst.TYPE_OIL_MAX)
end

function var0.getMaxGoldAddition(arg0)
	return arg0:getAddition(GuildConst.TYPE_GOLD_MAX)
end

function var0.getCatBoxGoldAddition(arg0)
	return arg0:getAddition(GuildConst.TYPE_CATBOX_GOLD_COST)
end

function var0.getEquipmentBagAddition(arg0)
	return arg0:getAddition(GuildConst.TYPE_EQUIPMENT_BAG)
end

function var0.getShipBagAddition(arg0)
	return arg0:getAddition(GuildConst.TYPE_SHIP_BAG)
end

function var0.getShipAddition(arg0, arg1, arg2)
	local var0 = 0
	local var1 = arg0:GetTechnologys()

	for iter0, iter1 in pairs(var1) do
		var0 = var0 + iter1:GetShipAttrAddition(arg1, arg2)
	end

	return var0
end

function var0.GetGuildMemberCntAddition(arg0)
	return arg0:getAddition(GuildConst.TYPE_GUILD_MEMBER_CNT)
end

return var0
