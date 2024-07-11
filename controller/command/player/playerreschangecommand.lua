local var0_0 = class("PlayerResChangeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.oldPlayer
	local var2_1 = var0_1.newPlayer
	local var3_1 = false
	local var4_1 = pg.player_resource.all

	for iter0_1 = #var4_1, 1, -1 do
		local var5_1 = var4_1[iter0_1]

		if var1_1:getResource(var5_1) ~= var2_1:getResource(var5_1) then
			var3_1 = true

			break
		end
	end

	if var3_1 then
		arg0_1:UpdateActivies(var1_1, var2_1)
	end
end

function var0_0.UpdateActivies(arg0_2, arg1_2, arg2_2)
	arg0_2.activityProxy = arg0_2.activityProxy or getProxy(ActivityProxy)

	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK)) do
		local var1_2 = iter1_2:getConfig("config_id")

		assert(var1_2)

		var0_2[var1_2] = var0_2[var1_2] or arg2_2:getResource(var1_2) - arg1_2:getResource(var1_2)

		var0_0.UpdateActivity(iter1_2, var0_2[var1_2])
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BOSS_RANK)) do
		local var2_2 = iter3_2:getConfig("config_id")

		assert(var2_2)

		var0_2[var2_2] = var0_2[var2_2] or arg2_2:getResource(var2_2) - arg1_2:getResource(var2_2)

		var0_0.UpdateActivity(iter3_2, var0_2[var2_2])
	end

	for iter4_2, iter5_2 in ipairs(arg0_2.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_RETURN_AWARD)) do
		local var3_2 = pg.activity_template_headhunting[iter5_2.id]

		assert(var3_2)

		local var4_2 = var3_2.pt

		var0_2[var4_2] = var0_2[var4_2] or arg2_2:getResource(var4_2) - arg1_2:getResource(var4_2)

		var0_0.UpdateActivity(iter5_2, var0_2[var4_2])
	end

	for iter6_2, iter7_2 in ipairs(arg0_2.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PIZZA_PT)) do
		local var5_2 = iter7_2:getDataConfig("pt")

		assert(var5_2)

		var0_2[var5_2] = var0_2[var5_2] or arg2_2:getResource(var5_2) - arg1_2:getResource(var5_2)

		var0_0.UpdateActivity(iter7_2, var0_2[var5_2])
	end

	for iter8_2, iter9_2 in ipairs(arg0_2.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)) do
		local var6_2 = iter9_2:getDataConfig("pt")

		if var6_2 > 0 then
			assert(var6_2)

			var0_2[var6_2] = var0_2[var6_2] or arg2_2:getResource(var6_2) - arg1_2:getResource(var6_2)

			var0_0.UpdateActivity(iter9_2, var0_2[var6_2])
		end
	end
end

function var0_0.UpdateActivity(arg0_3, arg1_3)
	local var0_3 = getProxy(ActivityProxy)
	local var1_3 = arg0_3:getConfig("type")

	arg0_3 = var0_3:getActivityById(arg0_3.id)

	if var1_3 == ActivityConst.ACTIVITY_TYPE_PT_RANK then
		if not arg0_3:isEnd() and arg1_3 > 0 then
			arg0_3.data1 = arg0_3.data1 + arg1_3

			var0_3:updateActivity(arg0_3)
		end
	elseif var1_3 == ActivityConst.ACTIVITY_TYPE_BOSS_RANK then
		if arg1_3 ~= 0 then
			arg0_3.data1 = arg0_3.data1 + arg1_3

			var0_3:updateActivity(arg0_3)
		end
	elseif var1_3 == ActivityConst.ACTIVITY_TYPE_RETURN_AWARD then
		local var2_3 = pg.activity_template_headhunting[arg0_3.id]

		assert(var2_3)

		if arg1_3 ~= 0 then
			arg0_3.data3 = arg0_3.data3 + arg1_3

			var0_3:updateActivity(arg0_3)
		end
	elseif var1_3 == ActivityConst.ACTIVITY_TYPE_PIZZA_PT then
		local var3_3 = arg0_3:getDataConfig("pt")

		if arg0_3:getDataConfig("type") == 1 then
			arg1_3 = math.max(arg1_3, 0)
		elseif arg0_3:getDataConfig("type") == 2 then
			arg1_3 = math.min(arg1_3, 0)
		else
			arg1_3 = 0
		end

		if not arg0_3:isEnd() and arg1_3 ~= 0 then
			arg0_3.data1 = arg0_3.data1 + math.abs(arg1_3)

			var0_3:updateActivity(arg0_3)
		end
	elseif var1_3 == ActivityConst.ACTIVITY_TYPE_PT_BUFF and arg0_3:getDataConfig("pt") > 0 then
		local var4_3 = arg0_3:getDataConfig("type") == 2

		if arg0_3:getDataConfig("type") == 1 then
			arg1_3 = math.max(arg1_3, 0)
		elseif var4_3 then
			arg1_3 = math.min(arg1_3, 0)
		else
			arg1_3 = 0
		end

		if not arg0_3:isEnd() and (arg1_3 > 0 or var4_3) then
			arg0_3.data1 = arg0_3.data1 + math.abs(arg1_3)

			var0_3:updateActivity(arg0_3)
		end
	end
end

return var0_0
