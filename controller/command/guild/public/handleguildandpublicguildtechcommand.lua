local var0_0 = class("HandleGuildAndPublicGuildTechCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = getProxy(GuildProxy)
	local var1_1 = var0_1:GetPublicGuild()

	assert(var1_1)

	local var2_1 = var0_1:getData()

	if not var2_1 then
		return
	end

	local var3_1 = false
	local var4_1 = var1_1:GetTechnologyGroups()

	for iter0_1, iter1_1 in pairs(var4_1) do
		local var5_1 = var2_1:getTechnologyGroupById(iter1_1.id)

		var5_1:update({
			id = var5_1.pid,
			state = var5_1.state,
			progress = var5_1.progress,
			fake_id = iter1_1.pid
		})

		var3_1 = true
	end

	if var3_1 then
		var0_1:updateGuild(var2_1)
	end

	arg0_1:sendNotification(GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH_DONE)
end

return var0_0
