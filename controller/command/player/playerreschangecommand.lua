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

local function var1_0(arg0_2, arg1_2, arg2_2)
	if arg2_2 == PlayerConst.ResDiamond then
		return arg1_2:getChargeGem() - arg0_2:getChargeGem()
	elseif arg2_2 == PlayerConst.ResFreeDiamond then
		return arg1_2:getFreeGem() - arg0_2:getFreeGem()
	end

	return arg1_2:getResource(arg2_2) - arg0_2:getResource(arg2_2)
end

function var0_0.UpdateActivies(arg0_3, arg1_3, arg2_3)
	arg0_3.activityProxy = arg0_3.activityProxy or getProxy(ActivityProxy)

	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK)) do
		local var1_3 = iter1_3:getConfig("config_id")

		assert(var1_3)

		var0_3[var1_3] = var0_3[var1_3] or arg2_3:getResource(var1_3) - arg1_3:getResource(var1_3)

		var0_0.UpdateActivity(iter1_3, var0_3[var1_3])
	end

	for iter2_3, iter3_3 in ipairs(arg0_3.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BOSS_RANK)) do
		local var2_3 = iter3_3:getConfig("config_id")

		assert(var2_3)

		var0_3[var2_3] = var0_3[var2_3] or arg2_3:getResource(var2_3) - arg1_3:getResource(var2_3)

		var0_0.UpdateActivity(iter3_3, var0_3[var2_3])
	end

	for iter4_3, iter5_3 in ipairs(arg0_3.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_RETURN_AWARD)) do
		local var3_3 = pg.activity_template_headhunting[iter5_3.id]

		assert(var3_3)

		local var4_3 = var3_3.pt

		var0_3[var4_3] = var0_3[var4_3] or arg2_3:getResource(var4_3) - arg1_3:getResource(var4_3)

		var0_0.UpdateActivity(iter5_3, var0_3[var4_3])
	end

	for iter6_3, iter7_3 in ipairs(arg0_3.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PIZZA_PT)) do
		local var5_3 = iter7_3:getDataConfig("pt")

		assert(var5_3)

		var0_3[var5_3] = var0_3[var5_3] or arg2_3:getResource(var5_3) - arg1_3:getResource(var5_3)

		var0_0.UpdateActivity(iter7_3, var0_3[var5_3])
	end

	for iter8_3, iter9_3 in ipairs(arg0_3.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)) do
		local var6_3 = iter9_3:getDataConfig("pt")

		if var6_3 > 0 then
			assert(var6_3)

			local var7_3 = var6_3 == PlayerConst.ResDiamond and {
				PlayerConst.ResFreeDiamond,
				PlayerConst.ResDiamond
			} or {
				var6_3
			}
			local var8_3 = 0

			for iter10_3, iter11_3 in ipairs(var7_3) do
				var0_3[iter11_3] = var0_3[iter11_3] or var1_0(arg1_3, arg2_3, iter11_3)
				var8_3 = var8_3 + var0_3[iter11_3]
			end

			var0_0.UpdateActivity(iter9_3, var8_3)
		end
	end
end

function var0_0.UpdateActivity(arg0_4, arg1_4)
	local var0_4 = getProxy(ActivityProxy)
	local var1_4 = arg0_4:getConfig("type")

	arg0_4 = var0_4:getActivityById(arg0_4.id)

	if var1_4 == ActivityConst.ACTIVITY_TYPE_PT_RANK then
		if not arg0_4:isEnd() and arg1_4 > 0 then
			arg0_4.data1 = arg0_4.data1 + arg1_4

			var0_4:updateActivity(arg0_4)
		end
	elseif var1_4 == ActivityConst.ACTIVITY_TYPE_BOSS_RANK then
		if arg1_4 ~= 0 then
			arg0_4.data1 = arg0_4.data1 + arg1_4

			var0_4:updateActivity(arg0_4)
		end
	elseif var1_4 == ActivityConst.ACTIVITY_TYPE_RETURN_AWARD then
		local var2_4 = pg.activity_template_headhunting[arg0_4.id]

		assert(var2_4)

		if arg1_4 ~= 0 then
			arg0_4.data3 = arg0_4.data3 + arg1_4

			var0_4:updateActivity(arg0_4)
		end
	elseif var1_4 == ActivityConst.ACTIVITY_TYPE_PIZZA_PT then
		local var3_4 = arg0_4:getDataConfig("pt")

		if arg0_4:getDataConfig("type") == 1 then
			arg1_4 = math.max(arg1_4, 0)
		elseif arg0_4:getDataConfig("type") == 2 then
			arg1_4 = math.min(arg1_4, 0)
		else
			arg1_4 = 0
		end

		if not arg0_4:isEnd() and arg1_4 ~= 0 then
			arg0_4.data1 = arg0_4.data1 + math.abs(arg1_4)

			var0_4:updateActivity(arg0_4)
		end
	elseif var1_4 == ActivityConst.ACTIVITY_TYPE_PT_BUFF and arg0_4:getDataConfig("pt") > 0 then
		local var4_4 = arg0_4:getDataConfig("type") == 2

		if arg0_4:getDataConfig("type") == 1 then
			arg1_4 = math.max(arg1_4, 0)
		elseif var4_4 then
			arg1_4 = math.min(arg1_4, 0)
		else
			arg1_4 = 0
		end

		if not arg0_4:isEnd() and (arg1_4 > 0 or var4_4) then
			arg0_4.data1 = arg0_4.data1 + math.abs(arg1_4)

			var0_4:updateActivity(arg0_4)
		end
	end
end

return var0_0
