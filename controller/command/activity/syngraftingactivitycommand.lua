local var0_0 = class("SynGraftingActivityCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(ActivityProxy)
	local var2_1 = var1_1:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GRAFTING)

	if #var2_1 == 0 then
		return
	end

	local var3_1 = var1_1:getActivityById(var0_1)

	if not var3_1 or var3_1:isEnd() then
		return
	end

	local function var4_1(arg0_2, arg1_2)
		if not arg0_2 or arg0_2:isEnd() then
			return false
		end

		return arg1_2 == arg0_2:getConfig("config_id")
	end

	for iter0_1, iter1_1 in ipairs(var2_1) do
		if var4_1(iter1_1, var0_1) then
			arg0_1:HandleLinkAct(iter1_1, var3_1)
		end
	end
end

function var0_0.HandleLinkAct(arg0_3, arg1_3, arg2_3)
	if arg0_3:IsBuildShipType(arg2_3:getConfig("type")) then
		arg0_3:SynBuildShipAct(arg1_3, arg2_3)
	end
end

function var0_0.IsBuildShipType(arg0_4, arg1_4)
	return arg1_4 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or arg1_4 == ActivityConst.ACTIVITY_TYPE_BUILD or arg1_4 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
end

function var0_0.SynBuildShipAct(arg0_5, arg1_5, arg2_5)
	arg1_5.data1 = arg2_5.data1
	arg1_5.data2 = arg2_5.data2

	print("syn........", arg1_5.data1, arg1_5.data2)
	getProxy(ActivityProxy):updateActivity(arg1_5)
end

return var0_0
