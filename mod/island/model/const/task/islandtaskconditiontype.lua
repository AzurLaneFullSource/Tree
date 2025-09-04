local var0_0 = class("IslandTaskConditionType")

var0_0.GOT_ACHIEVEMENT = 1
var0_0.FINISH_TASK = 2
var0_0.EXIST_ABILITY = 3
var0_0.MUTEX_TASK = 4
var0_0.IN_TIME = 5
var0_0.EXIST_ANY_ITEM = 6
var0_0.EXIST_ALL_ITEM = 7
var0_0.EXIST_ANY_COMMANDER_DRESS = 8
var0_0.EXIST_ALL_COMMANDER_DRESS = 9

function var0_0.IsMatch(arg0_1)
	local var0_1 = arg0_1[1]
	local var1_1 = arg0_1[2]
	local var2_1 = getProxy(IslandProxy):GetIsland()

	return switch(var0_1, {
		[var0_0.GOT_ACHIEVEMENT] = function()
			return var2_1:GetAchievementAgency():IsGot(var1_1)
		end,
		[var0_0.FINISH_TASK] = function()
			return var2_1:GetTaskAgency():IsFinishTask(var1_1)
		end,
		[var0_0.EXIST_ABILITY] = function()
			return var2_1:GetAblityAgency():HasAbility(var1_1)
		end,
		[var0_0.MUTEX_TASK] = function()
			return not var2_1:GetTaskAgency():IsPassId(var1_1)
		end,
		[var0_0.IN_TIME] = function()
			return pg.TimeMgr.GetInstance():inTime(var1_1)
		end,
		[var0_0.EXIST_ANY_ITEM] = function()
			local var0_7 = var2_1:GetInventoryAgency()

			return underscore.any(var1_1, function(arg0_8)
				return var0_7:OwnItem(arg0_8)
			end)
		end,
		[var0_0.EXIST_ALL_ITEM] = function()
			local var0_9 = var2_1:GetInventoryAgency()

			return underscore.all(var1_1, function(arg0_10)
				return var0_9:OwnItem(arg0_10)
			end)
		end,
		[var0_0.EXIST_ANY_COMMANDER_DRESS] = function()
			local var0_11 = var2_1:GetDressUpAgency()

			return underscore.any(var1_1, function(arg0_12)
				return var0_11:CheckOwnDress(arg0_12)
			end)
		end,
		[var0_0.EXIST_ALL_COMMANDER_DRESS] = function()
			local var0_13 = var2_1:GetDressUpAgency()

			return underscore.all(var1_1, function(arg0_14)
				return var0_13:CheckOwnDress(arg0_14)
			end)
		end
	}, function()
		return false
	end)
end

return var0_0
