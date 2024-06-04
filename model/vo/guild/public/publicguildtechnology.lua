local var0 = class("PublicGuildTechnology", import("..GuildTechnology"))

function var0.GetConsume(arg0)
	local var0 = arg0:getConfig("contribution_consume")
	local var1 = arg0:getConfig("gold_consume")
	local var2 = arg0:getConfig("contribution_multiple")

	return var0 * var2, var1 * var2
end

return var0
