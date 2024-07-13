local var0_0 = class("PublicGuildTechnology", import("..GuildTechnology"))

function var0_0.GetConsume(arg0_1)
	local var0_1 = arg0_1:getConfig("contribution_consume")
	local var1_1 = arg0_1:getConfig("gold_consume")
	local var2_1 = arg0_1:getConfig("contribution_multiple")

	return var0_1 * var2_1, var1_1 * var2_1
end

return var0_0
