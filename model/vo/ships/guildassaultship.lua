local var0_0 = class("GuildAssaultShip", import(".CheckCustomNameShip"))

function var0_0.IsOwner(arg0_1)
	return tonumber(GuildAssaultFleet.GetUserId(arg0_1.id)) == getProxy(PlayerProxy):getRawData().id
end

function var0_0.GetUniqueId(arg0_2)
	return GuildAssaultFleet.GetRealId(arg0_2.id)
end

function var0_0.ConverteFromShip(arg0_3)
	return setmetatable({}, {
		__index = function(arg0_4, arg1_4)
			return var0_0[arg1_4] and var0_0[arg1_4] or arg0_3[arg1_4]
		end
	})
end

return var0_0
