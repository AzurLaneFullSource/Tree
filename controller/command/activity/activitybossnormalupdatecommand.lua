local var0_0 = class("ActivityBossNormalUpdateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.stageId

	if not var1_1 then
		return
	end

	local var2_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	if not var2_1 or var2_1:isEnd() then
		return
	end

	local var3_1 = pg.activity_event_worldboss[var2_1:getConfig("config_id")]

	if not var3_1 then
		return
	end

	local var4_1 = {}

	for iter0_1, iter1_1 in pairs(var3_1.normal_expedition_drop_num or {}) do
		for iter2_1, iter3_1 in pairs(iter1_1[1]) do
			if iter3_1 == var1_1 then
				for iter4_1, iter5_1 in pairs(iter1_1[1]) do
					var4_1[iter5_1] = true
				end

				break
			end
		end

		if table.getCount(var4_1) > 0 then
			break
		end
	end

	local var5_1 = var2_1.data1KeyValueList
	local var6_1 = var0_1.num or -1

	for iter6_1, iter7_1 in pairs(var4_1) do
		if var5_1[2][iter6_1] + var6_1 >= 0 then
			var5_1[2][iter6_1] = var5_1[2][iter6_1] + var6_1
		else
			var5_1[1][iter6_1] = math.max(var5_1[1][iter6_1] + var6_1, 0)
		end
	end

	var2_1:AddStage(var1_1)
	getProxy(ActivityProxy):updateActivity(var2_1)
end

return var0_0
