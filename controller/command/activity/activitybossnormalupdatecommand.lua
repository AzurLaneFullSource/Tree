local var0 = class("ActivityBossNormalUpdateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.stageId

	if not var1 then
		return
	end

	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if not var2 or var2:isEnd() then
		return
	end

	local var3 = pg.activity_event_worldboss[var2:getConfig("config_id")]

	if not var3 then
		return
	end

	local var4 = {}

	for iter0, iter1 in pairs(var3.normal_expedition_drop_num or {}) do
		for iter2, iter3 in pairs(iter1[1]) do
			if iter3 == var1 then
				for iter4, iter5 in pairs(iter1[1]) do
					var4[iter5] = true
				end

				break
			end
		end

		if table.getCount(var4) > 0 then
			break
		end
	end

	local var5 = var2.data1KeyValueList
	local var6 = var0.num or -1

	for iter6, iter7 in pairs(var4) do
		if var5[2][iter6] + var6 >= 0 then
			var5[2][iter6] = var5[2][iter6] + var6
		else
			var5[1][iter6] = math.max(var5[1][iter6] + var6, 0)
		end
	end

	var2:AddStage(var1)
	getProxy(ActivityProxy):updateActivity(var2)
end

return var0
