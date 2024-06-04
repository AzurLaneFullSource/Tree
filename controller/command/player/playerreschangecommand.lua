local var0 = class("PlayerResChangeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.oldPlayer
	local var2 = var0.newPlayer
	local var3 = false
	local var4 = pg.player_resource.all

	for iter0 = #var4, 1, -1 do
		local var5 = var4[iter0]

		if var1:getResource(var5) ~= var2:getResource(var5) then
			var3 = true

			break
		end
	end

	if var3 then
		arg0:UpdateActivies(var1, var2)
	end
end

function var0.UpdateActivies(arg0, arg1, arg2)
	arg0.activityProxy = arg0.activityProxy or getProxy(ActivityProxy)

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK)) do
		local var1 = iter1:getConfig("config_id")

		assert(var1)

		var0[var1] = var0[var1] or arg2:getResource(var1) - arg1:getResource(var1)

		var0.UpdateActivity(iter1, var0[var1])
	end

	for iter2, iter3 in ipairs(arg0.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BOSS_RANK)) do
		local var2 = iter3:getConfig("config_id")

		assert(var2)

		var0[var2] = var0[var2] or arg2:getResource(var2) - arg1:getResource(var2)

		var0.UpdateActivity(iter3, var0[var2])
	end

	for iter4, iter5 in ipairs(arg0.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)) do
		local var3 = pg.battlepass_event_pt[iter5.id].pt

		var0[var3] = var0[var3] or arg2:getResource(var3) - arg1:getResource(var3)

		var0.UpdateActivity(iter5, var0[var3])
	end

	for iter6, iter7 in ipairs(arg0.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_RETURN_AWARD)) do
		local var4 = pg.activity_template_headhunting[iter7.id]

		assert(var4)

		local var5 = var4.pt

		var0[var5] = var0[var5] or arg2:getResource(var5) - arg1:getResource(var5)

		var0.UpdateActivity(iter7, var0[var5])
	end

	for iter8, iter9 in ipairs(arg0.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PIZZA_PT)) do
		local var6 = iter9:getDataConfig("pt")

		assert(var6)

		var0[var6] = var0[var6] or arg2:getResource(var6) - arg1:getResource(var6)

		var0.UpdateActivity(iter9, var0[var6])
	end

	for iter10, iter11 in ipairs(arg0.activityProxy:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF)) do
		local var7 = iter11:getDataConfig("pt")

		if var7 > 0 then
			assert(var7)

			var0[var7] = var0[var7] or arg2:getResource(var7) - arg1:getResource(var7)

			var0.UpdateActivity(iter11, var0[var7])
		end
	end
end

function var0.UpdateActivity(arg0, arg1)
	local var0 = getProxy(ActivityProxy)
	local var1 = arg0:getConfig("type")

	arg0 = var0:getActivityById(arg0.id)

	if var1 == ActivityConst.ACTIVITY_TYPE_PT_RANK then
		if not arg0:isEnd() and arg1 > 0 then
			arg0.data1 = arg0.data1 + arg1

			var0:updateActivity(arg0)
		end
	elseif var1 == ActivityConst.ACTIVITY_TYPE_BOSS_RANK then
		if arg1 ~= 0 then
			arg0.data1 = arg0.data1 + arg1

			var0:updateActivity(arg0)
		end
	elseif var1 == ActivityConst.ACTIVITY_TYPE_PT_CRUSING then
		if not arg0:isEnd() and arg1 ~= 0 then
			arg0.data1 = arg0.data1 + math.abs(arg1)

			var0:updateActivity(arg0)
		end
	elseif var1 == ActivityConst.ACTIVITY_TYPE_RETURN_AWARD then
		local var2 = pg.activity_template_headhunting[arg0.id]

		assert(var2)

		if arg1 ~= 0 then
			arg0.data3 = arg0.data3 + arg1

			var0:updateActivity(arg0)
		end
	elseif var1 == ActivityConst.ACTIVITY_TYPE_PIZZA_PT then
		local var3 = arg0:getDataConfig("pt")

		if arg0:getDataConfig("type") == 1 then
			arg1 = math.max(arg1, 0)
		elseif arg0:getDataConfig("type") == 2 then
			arg1 = math.min(arg1, 0)
		else
			arg1 = 0
		end

		if not arg0:isEnd() and arg1 ~= 0 then
			arg0.data1 = arg0.data1 + math.abs(arg1)

			var0:updateActivity(arg0)
		end
	elseif var1 == ActivityConst.ACTIVITY_TYPE_PT_BUFF and arg0:getDataConfig("pt") > 0 then
		local var4 = arg0:getDataConfig("type") == 2

		if arg0:getDataConfig("type") == 1 then
			arg1 = math.max(arg1, 0)
		elseif var4 then
			arg1 = math.min(arg1, 0)
		else
			arg1 = 0
		end

		if not arg0:isEnd() and (arg1 > 0 or var4) then
			arg0.data1 = arg0.data1 + math.abs(arg1)

			var0:updateActivity(arg0)
		end
	end
end

return var0
