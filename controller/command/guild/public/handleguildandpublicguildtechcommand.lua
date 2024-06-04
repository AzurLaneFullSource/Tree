local var0 = class("HandleGuildAndPublicGuildTechCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = getProxy(GuildProxy)
	local var1 = var0:GetPublicGuild()

	assert(var1)

	local var2 = var0:getData()

	if not var2 then
		return
	end

	local var3 = false
	local var4 = var1:GetTechnologyGroups()

	for iter0, iter1 in pairs(var4) do
		local var5 = var2:getTechnologyGroupById(iter1.id)

		var5:update({
			id = var5.pid,
			state = var5.state,
			progress = var5.progress,
			fake_id = iter1.pid
		})

		var3 = true
	end

	if var3 then
		var0:updateGuild(var2)
	end

	arg0:sendNotification(GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH_DONE)
end

return var0
