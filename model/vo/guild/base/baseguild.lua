local var0_0 = class("BaseGuild", import("...BaseVO"))

function var0_0.GetTechnologys(arg0_1)
	assert(false)
end

function var0_0.getAddition(arg0_2, arg1_2)
	local var0_2 = 0
	local var1_2 = GuildConst.TYPE_TO_GROUP[arg1_2]

	return var0_2 + arg0_2:GetTechnologys()[var1_2]:getAddition()
end

function var0_0.getMaxOilAddition(arg0_3)
	return arg0_3:getAddition(GuildConst.TYPE_OIL_MAX)
end

function var0_0.getMaxGoldAddition(arg0_4)
	return arg0_4:getAddition(GuildConst.TYPE_GOLD_MAX)
end

function var0_0.getCatBoxGoldAddition(arg0_5)
	return arg0_5:getAddition(GuildConst.TYPE_CATBOX_GOLD_COST)
end

function var0_0.getEquipmentBagAddition(arg0_6)
	return arg0_6:getAddition(GuildConst.TYPE_EQUIPMENT_BAG)
end

function var0_0.getShipBagAddition(arg0_7)
	return arg0_7:getAddition(GuildConst.TYPE_SHIP_BAG)
end

function var0_0.getShipAddition(arg0_8, arg1_8, arg2_8)
	local var0_8 = 0
	local var1_8 = arg0_8:GetTechnologys()

	for iter0_8, iter1_8 in pairs(var1_8) do
		var0_8 = var0_8 + iter1_8:GetShipAttrAddition(arg1_8, arg2_8)
	end

	return var0_8
end

function var0_0.GetGuildMemberCntAddition(arg0_9)
	return arg0_9:getAddition(GuildConst.TYPE_GUILD_MEMBER_CNT)
end

return var0_0
