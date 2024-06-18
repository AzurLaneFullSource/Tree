local var0_0 = class("GuildBossMissionShip")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.super = arg1_1

	setmetatable(arg0_1, {
		__index = function(arg0_2, arg1_2)
			local var0_2 = rawget(arg0_2, "class")

			return var0_2[arg1_2] and var0_2[arg1_2] or arg1_1[arg1_2]
		end
	})
end

function var0_0.IsOwner(arg0_3)
	return tonumber(GuildAssaultFleet.GetUserId(arg0_3.id)) == getProxy(PlayerProxy):getRawData().id
end

function var0_0.GetUniqueId(arg0_4)
	return GuildAssaultFleet.GetRealId(arg0_4.id)
end

function var0_0.getProperties(arg0_5, arg1_5, arg2_5)
	local var0_5 = getProxy(GuildProxy):getRawData()
	local var1_5 = {}
	local var2_5 = arg0_5.super:getProperties(arg1_5, arg2_5)

	for iter0_5, iter1_5 in pairs(var2_5) do
		local var3_5 = var0_5:getShipAddition(iter0_5, arg0_5:getShipType())

		var1_5[iter0_5] = (var2_5[iter0_5] or 0) + var3_5
	end

	return var1_5
end

return var0_0
