local var0 = class("GetWBDamageRankCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.bossId
	local var2 = var0.callback

	if not var1 or var1 == 0 then
		if var2 then
			var2()
		end

		return
	end

	local var3 = getProxy(PlayerProxy):getRawData().id

	pg.ConnectionMgr.GetInstance():Send(34505, {
		boss_id = var1
	}, 34506, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.rank_list) do
			table.insert(var0, {
				id = iter1.id,
				name = iter1.name,
				damage = iter1.damage,
				isSelf = var3 == iter1.id
			})
		end

		table.sort(var0, function(arg0, arg1)
			return arg0.damage > arg1.damage
		end)
		nowWorld():GetBossProxy():SetRank(var1, var0)

		if var2 then
			var2(#var0)
		end

		arg0:sendNotification(GAME.WORLD_GET_BOSS_RANK_DONE, {
			bossId = var1
		})
	end)
end

return var0
