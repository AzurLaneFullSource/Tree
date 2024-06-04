local var0 = class("GuildBossMissionShip")

function var0.Ctor(arg0, arg1)
	arg0.super = arg1

	setmetatable(arg0, {
		__index = function(arg0, arg1)
			local var0 = rawget(arg0, "class")

			return var0[arg1] and var0[arg1] or arg1[arg1]
		end
	})
end

function var0.IsOwner(arg0)
	return tonumber(GuildAssaultFleet.GetUserId(arg0.id)) == getProxy(PlayerProxy):getRawData().id
end

function var0.GetUniqueId(arg0)
	return GuildAssaultFleet.GetRealId(arg0.id)
end

function var0.getProperties(arg0, arg1, arg2)
	local var0 = getProxy(GuildProxy):getRawData()
	local var1 = {}
	local var2 = arg0.super:getProperties(arg1, arg2)

	for iter0, iter1 in pairs(var2) do
		local var3 = var0:getShipAddition(iter0, arg0:getShipType())

		var1[iter0] = (var2[iter0] or 0) + var3
	end

	return var1
end

return var0
