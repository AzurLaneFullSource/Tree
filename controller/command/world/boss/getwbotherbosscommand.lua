local var0 = class("GetWBOtherBossCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().type
	local var1 = {}

	if var0 == WorldBoss.OTHER_BOSS_TYPE_FRIEND then
		local var2 = getProxy(FriendProxy):getRawData()

		for iter0, iter1 in pairs(var2) do
			table.insert(var1, iter1.id)
		end
	elseif var0 == WorldBoss.OTHER_BOSS_TYPE_GUILD then
		local var3 = getProxy(GuildProxy):getRawData()

		for iter2, iter3 in pairs(var3.member) do
			table.insert(var1, iter3.id)
		end
	end

	if #var1 == 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(33503, {
		user_id_list = var1
	}, 33504, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.boss_list) do
			local var1 = WorldBoss.New()

			var1:Setup(iter1)
			table.insert(var0, var1)
		end

		nowWorld():GetBossProxy():UpdateOtheroBosses(var0)
		arg0:sendNotification(GAME.WORLD_BOSS_GET_OTHER_BOSS_DONE)
	end)
end

return var0
