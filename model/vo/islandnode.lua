local var0_0 = class("IslandNode", import(".BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_map_event_list
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg1_2.id
	arg0_2.eventId = arg1_2.event_id
	arg0_2.isNew = arg1_2.is_new == 1
end

function var0_0.IsUnlock(arg0_3)
	arg0_3.isUnlock = arg0_3.isUnlock or arg0_3:GetUnlock()

	return arg0_3.isUnlock
end

function var0_0.GetUnlock(arg0_4)
	local var0_4 = getProxy(IslandProxy)
	local var1_4 = arg0_4:getConfig("open_need")
	local var2_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2)
	local var3_4 = var2_4 and var2_4:GetTotalBuildingLevel() or 0
	local var4_4 = {}

	for iter0_4, iter1_4 in ipairs(getProxy(ActivityTaskProxy):getFinishTasks()) do
		var4_4[iter1_4:GetConfigID()] = true
	end

	return var3_4 >= var1_4[1] and underscore.all(var1_4[2], function(arg0_5)
		return var0_4:GetNode(arg0_5):IsCompleted()
	end) and underscore.all(arg0_4:getConfig("open_task"), function(arg0_6)
		return var4_4[arg0_6]
	end)
end

function var0_0.IsVisual(arg0_7)
	return (arg0_7:getConfig("node_status") == 1 or not arg0_7:IsCompleted()) and arg0_7:IsUnlock() and not arg0_7:ChangeVisual()
end

function var0_0.ChangeVisual(arg0_8)
	local var0_8 = arg0_8:getConfig("node_change")

	return var0_8 ~= 0 and getProxy(IslandProxy):GetNode(var0_8):IsUnlock()
end

function var0_0.IsCompleted(arg0_9)
	return arg0_9.eventId == 0
end

function var0_0.IsNew(arg0_10)
	return not arg0_10:IsTreasure() and arg0_10.isNew
end

function var0_0.IsMain(arg0_11)
	return arg0_11:getConfig("type") == 1
end

function var0_0.IsTreasure(arg0_12)
	return arg0_12:getConfig("type") == 4
end

function var0_0.IsRefresh(arg0_13)
	return arg0_13:getConfig("refresh") == 1
end

function var0_0.IsFlowerField(arg0_14)
	return arg0_14:getConfig("type") == 5 and arg0_14:getConfig("params")[1] == "flowerfield"
end

function var0_0.GetScale(arg0_15)
	return 0.8
end

function var0_0.RedDotHint(arg0_16)
	return switch(arg0_16:getConfig("type"), {
		[4] = function()
			return false
		end,
		[5] = function()
			var0_0.markDic = var0_0.markDic or {
				minigame1 = function(...)
					local var0_19 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_id")

					return getProxy(MiniGameProxy):GetHubByHubId(var0_19).count > 0
				end,
				minigame2 = function(...)
					return var0_0.markDic.minigame1(...)
				end,
				minigame3 = function(...)
					return var0_0.markDic.minigame1(...)
				end,
				flowerfield = function()
					local var0_22 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FLOWER_FIELD)

					return Activity.IsActivityReady(var0_22)
				end,
				hotspringtask = function()
					local var0_23 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)

					return Activity.IsActivityReady(var0_23)
				end
			}

			return switch(arg0_16:getConfig("params")[1], var0_0.markDic, function()
				return false
			end)
		end
	}, function()
		return not arg0_16:IsCompleted()
	end)
end

function var0_0.GetEffectName(arg0_26)
	return switch(arg0_26:getConfig("type"), {
		[4] = function()
			return "haidao_baoxiang"
		end
	}, function()
		return ""
	end)
end

function var0_0.CanTrigger(arg0_29)
	if arg0_29:getConfig("type") == 5 then
		return true
	else
		return not arg0_29:IsCompleted()
	end
end

function var0_0.CanToggleOn(arg0_30)
	return switch(arg0_30:getConfig("type"), {
		[4] = function()
			return false
		end,
		[5] = function()
			return true
		end
	}, function()
		return not arg0_30:IsCompleted()
	end)
end

return var0_0
