local var0_0 = class("GetWBDamageRankCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.bossId
	local var2_1 = var0_1.callback

	if not var1_1 or var1_1 == 0 then
		if var2_1 then
			var2_1()
		end

		return
	end

	local var3_1 = getProxy(PlayerProxy):getRawData().id

	pg.ConnectionMgr.GetInstance():Send(34505, {
		boss_id = var1_1
	}, 34506, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.rank_list) do
			table.insert(var0_2, {
				id = iter1_2.id,
				name = iter1_2.name,
				damage = iter1_2.damage,
				isSelf = var3_1 == iter1_2.id
			})
		end

		table.sort(var0_2, function(arg0_3, arg1_3)
			return arg0_3.damage > arg1_3.damage
		end)
		nowWorld():GetBossProxy():SetRank(var1_1, var0_2)

		if var2_1 then
			var2_1(#var0_2)
		end

		arg0_1:sendNotification(GAME.WORLD_GET_BOSS_RANK_DONE, {
			bossId = var1_1
		})
	end)
end

return var0_0
