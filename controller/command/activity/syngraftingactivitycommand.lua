local var0 = class("SynGraftingActivityCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(ActivityProxy)
	local var2 = var1:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GRAFTING)

	if #var2 == 0 then
		return
	end

	local var3 = var1:getActivityById(var0)

	if not var3 or var3:isEnd() then
		return
	end

	local function var4(arg0, arg1)
		if not arg0 or arg0:isEnd() then
			return false
		end

		return arg1 == arg0:getConfig("config_id")
	end

	for iter0, iter1 in ipairs(var2) do
		if var4(iter1, var0) then
			arg0:HandleLinkAct(iter1, var3)
		end
	end
end

function var0.HandleLinkAct(arg0, arg1, arg2)
	if arg0:IsBuildShipType(arg2:getConfig("type")) then
		arg0:SynBuildShipAct(arg1, arg2)
	end
end

function var0.IsBuildShipType(arg0, arg1)
	return arg1 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or arg1 == ActivityConst.ACTIVITY_TYPE_BUILD or arg1 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
end

function var0.SynBuildShipAct(arg0, arg1, arg2)
	arg1.data1 = arg2.data1
	arg1.data2 = arg2.data2

	print("syn........", arg1.data1, arg1.data2)
	getProxy(ActivityProxy):updateActivity(arg1)
end

return var0
