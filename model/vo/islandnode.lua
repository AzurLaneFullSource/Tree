local var0 = class("IslandNode", import(".BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.activity_map_event_list
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.eventId = arg1.event_id
	arg0.isNew = arg1.is_new == 1
end

function var0.IsUnlock(arg0)
	arg0.isUnlock = arg0.isUnlock or arg0:GetUnlock()

	return arg0.isUnlock
end

function var0.GetUnlock(arg0)
	local var0 = getProxy(IslandProxy)
	local var1 = arg0:getConfig("open_need")
	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)
	local var3 = var2 and var2:GetTotalBuildingLevel() or 0
	local var4 = {}

	for iter0, iter1 in ipairs(getProxy(ActivityTaskProxy):getFinishTasks()) do
		var4[iter1:GetConfigID()] = true
	end

	return var3 >= var1[1] and underscore.all(var1[2], function(arg0)
		return var0:GetNode(arg0):IsCompleted()
	end) and underscore.all(arg0:getConfig("open_task"), function(arg0)
		return var4[arg0]
	end)
end

function var0.IsVisual(arg0)
	return (arg0:getConfig("node_status") == 1 or not arg0:IsCompleted()) and arg0:IsUnlock() and not arg0:ChangeVisual()
end

function var0.ChangeVisual(arg0)
	local var0 = arg0:getConfig("node_change")

	return var0 ~= 0 and getProxy(IslandProxy):GetNode(var0):IsUnlock()
end

function var0.IsCompleted(arg0)
	return arg0.eventId == 0
end

function var0.IsNew(arg0)
	return not arg0:IsTreasure() and arg0.isNew
end

function var0.IsMain(arg0)
	return arg0:getConfig("type") == 1
end

function var0.IsTreasure(arg0)
	return arg0:getConfig("type") == 4
end

function var0.IsRefresh(arg0)
	return arg0:getConfig("refresh") == 1
end

function var0.IsFlowerField(arg0)
	return arg0:getConfig("type") == 5 and arg0:getConfig("params")[1] == "flowerfield"
end

function var0.GetScale(arg0)
	return 0.8
end

function var0.RedDotHint(arg0)
	return switch(arg0:getConfig("type"), {
		[4] = function()
			return false
		end,
		[5] = function()
			var0.markDic = var0.markDic or {
				minigame1 = function(...)
					local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_id")

					return getProxy(MiniGameProxy):GetHubByHubId(var0).count > 0
				end,
				minigame2 = function(...)
					return var0.markDic.minigame1(...)
				end,
				minigame3 = function(...)
					return var0.markDic.minigame1(...)
				end,
				flowerfield = function()
					local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD)

					return Activity.IsActivityReady(var0)
				end,
				hotspringtask = function()
					local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)

					return Activity.IsActivityReady(var0)
				end
			}

			return switch(arg0:getConfig("params")[1], var0.markDic, function()
				return false
			end)
		end
	}, function()
		return not arg0:IsCompleted()
	end)
end

function var0.GetEffectName(arg0)
	return switch(arg0:getConfig("type"), {
		[4] = function()
			return "haidao_baoxiang"
		end
	}, function()
		return ""
	end)
end

function var0.CanTrigger(arg0)
	if arg0:getConfig("type") == 5 then
		return true
	else
		return not arg0:IsCompleted()
	end
end

function var0.CanToggleOn(arg0)
	return switch(arg0:getConfig("type"), {
		[4] = function()
			return false
		end,
		[5] = function()
			return true
		end
	}, function()
		return not arg0:IsCompleted()
	end)
end

return var0
