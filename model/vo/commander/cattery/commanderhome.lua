local var0 = class("CommanderHome", import("...BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.level = arg1.level
	arg0.configId = arg0.level
	arg0.exp = arg1.exp
	arg0.catterys = {}
	arg0.unlockCatteryId = 1
	arg0.clean = arg1.clean or 0

	for iter0, iter1 in ipairs(arg1.slots) do
		arg0.catterys[iter1.id] = Cattery.New(arg0, iter1)

		if iter1.id > arg0.unlockCatteryId then
			arg0.unlockCatteryId = iter1.id
		end
	end

	for iter2 = 1, pg.gameset.commander_home_number.key_value do
		if not arg0.catterys[iter2] then
			arg0.catterys[iter2] = Cattery.New(arg0, {
				op_flag = 7,
				id = iter2
			})
		end
	end
end

function var0.bindConfigTable(arg0)
	return pg.commander_home
end

function var0.GetLevel(arg0)
	return arg0.level
end

function var0.GetMaxLevel(arg0)
	local var0 = arg0:bindConfigTable()

	return var0.all[#var0.all]
end

function var0.IsMaxLevel(arg0)
	return arg0:GetMaxLevel() <= arg0.level
end

function var0.AddExp(arg0, arg1)
	arg0.exp = arg0.exp + arg1

	while arg0:CanUpgrade() do
		local var0 = arg0:GetNextLevelExp()

		arg0:LevelUp(arg0.level + 1)

		arg0.exp = arg0.exp - var0
	end
end

function var0.UpdateExpAndLevel(arg0, arg1, arg2)
	if arg1 > arg0.level then
		arg0:LevelUp(arg1)
	end

	arg0.exp = arg2
end

function var0.LevelUp(arg0, arg1)
	arg0.level = arg1
	arg0.configId = arg1
end

function var0.CanUpgrade(arg0)
	if arg0:GetNextLevelExp() <= arg0.exp and not arg0:IsMaxLevel() then
		return true
	end

	return false
end

function var0.GetNextLevelExp(arg0)
	return arg0:getConfig("home_exp")
end

function var0.GetPrevLevelExp(arg0)
	local var0 = arg0:bindConfigTable()

	return var0[arg0.level - 1] and var0[arg0.level - 1].home_exp or 0
end

function var0.GetCatteries(arg0)
	return arg0.catterys
end

function var0.GetCatteryById(arg0, arg1)
	return arg0.catterys[arg1]
end

function var0.GetAllLevel(arg0)
	return arg0:bindConfigTable().all
end

function var0.IsHeadLevel(arg0, arg1)
	return arg0:GetAllLevel()[1] == arg1
end

function var0.isTailLevel(arg0, arg1)
	local var0 = arg0:GetAllLevel()

	return var0[#var0] == arg1
end

function var0.GetLevelConfig(arg0, arg1)
	return arg0:bindConfigTable()[arg1]
end

function var0.GetTargetExpForLevel(arg0, arg1)
	local var0 = 0

	for iter0 = 1, arg1 - 1 do
		var0 = var0 + arg0:GetLevelConfig(iter0).home_exp
	end

	return var0
end

function var0.GetClean(arg0)
	return arg0.clean
end

function var0.IncCleanValue(arg0)
	arg0.clean = arg0.clean + arg0:getConfig("flower")[1]
end

function var0.ReduceClean(arg0)
	local var0 = false
	local var1 = arg0:getConfig("flower")[2]
	local var2 = arg0:GetCatteries()

	for iter0, iter1 in pairs(var2) do
		if iter1:IsDirty() then
			arg0.clean = arg0.clean - var1

			break
		end
	end
end

function var0.GetCleanLevel(arg0)
	local var0 = arg0:getConfig("flower")[3]
	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		if iter1 <= arg0.clean then
			var1 = iter0
		end
	end

	return var1
end

function var0.GetOwnStyles(arg0)
	return arg0:getConfig("nest_appearance")
end

function var0.GetMaxCatteryCnt(arg0)
	return arg0:getConfig("nest_number")
end

function var0.GetCatteriesCommanders(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0:GetCatteries()) do
		if iter1:ExistCommander() then
			table.insert(var0, iter1:GetCommanderId())
		end
	end

	return var0
end

function var0.ResetCatteryOP(arg0)
	local var0 = arg0:GetCatteries()

	for iter0, iter1 in pairs(var0) do
		if iter1:ExistCommander() then
			iter1:ResetOP()
		end
	end
end

function var0.GetFeedCommanderExp(arg0)
	return arg0:getConfig("feed_level")[2]
end

function var0.AnyCatteryExistOP(arg0)
	for iter0, iter1 in pairs(arg0:GetCatteries()) do
		if not iter1:IsLocked() and (iter1:ExiseFeedOP() or iter1:ExistPlayOP() or iter1:ExistCleanOP()) then
			return true
		end
	end

	return false
end

function var0.AnyCatteryCanUse(arg0)
	for iter0, iter1 in pairs(arg0:GetCatteries()) do
		if iter1:GetState() == Cattery.STATE_EMPTY then
			return true
		end
	end

	return false
end

function var0.GetFeedLevel(arg0)
	return arg0:getConfig("feed_level")[1]
end

function var0.GetPlayLevel(arg0)
	return arg0:getConfig("teast_level")[1]
end

function var0.GetExistCommanderCattertCnt(arg0)
	local var0 = 0
	local var1 = arg0:GetCatteries()

	for iter0, iter1 in pairs(var1) do
		if iter1:ExistCommander() then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.CommanderInHome(arg0, arg1)
	local var0 = arg0:GetCatteries()

	for iter0, iter1 in pairs(var0) do
		if iter1:GetCommanderId() == arg1 then
			return true
		end
	end

	return false
end

function var0.ShouldSettleCattery(arg0)
	local var0 = arg0:GetCatteries()

	for iter0, iter1 in pairs(var0) do
		if iter1:ExistCommander() and iter1:ExistCacheExp() then
			return true
		end
	end

	return false
end

return var0
