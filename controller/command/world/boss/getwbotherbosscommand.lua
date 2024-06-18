local var0_0 = class("GetWBOtherBossCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().type
	local var1_1 = {}

	if var0_1 == WorldBoss.OTHER_BOSS_TYPE_FRIEND then
		local var2_1 = getProxy(FriendProxy):getRawData()

		for iter0_1, iter1_1 in pairs(var2_1) do
			table.insert(var1_1, iter1_1.id)
		end
	elseif var0_1 == WorldBoss.OTHER_BOSS_TYPE_GUILD then
		local var3_1 = getProxy(GuildProxy):getRawData()

		for iter2_1, iter3_1 in pairs(var3_1.member) do
			table.insert(var1_1, iter3_1.id)
		end
	end

	if #var1_1 == 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(33503, {
		user_id_list = var1_1
	}, 33504, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.boss_list) do
			local var1_2 = WorldBoss.New()

			var1_2:Setup(iter1_2)
			table.insert(var0_2, var1_2)
		end

		nowWorld():GetBossProxy():UpdateOtheroBosses(var0_2)
		arg0_1:sendNotification(GAME.WORLD_BOSS_GET_OTHER_BOSS_DONE)
	end)
end

return var0_0
