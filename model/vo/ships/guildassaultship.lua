local var0 = class("GuildAssaultShip", import(".CheckCustomNameShip"))

function var0.IsOwner(arg0)
	return tonumber(GuildAssaultFleet.GetUserId(arg0.id)) == getProxy(PlayerProxy):getRawData().id
end

function var0.GetUniqueId(arg0)
	return GuildAssaultFleet.GetRealId(arg0.id)
end

function var0.ConverteFromShip(arg0)
	return setmetatable({}, {
		__index = function(arg0, arg1)
			return var0[arg1] and var0[arg1] or arg0[arg1]
		end
	})
end

return var0
