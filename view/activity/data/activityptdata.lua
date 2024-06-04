local var0 = class("ActivityPtData")

function var0.Ctor(arg0, arg1)
	arg0.dropList = arg1:getDataConfig("drop_client")
	arg0.targets = arg1:getDataConfig("target")
	arg0.resId = arg1:getDataConfig("pt")
	arg0.bindActId = arg1:getDataConfig("id_2")
	arg0.unlockDay = arg1:getDataConfig("day_unlock")
	arg0.type = arg1:getDataConfig("type")

	arg0:Update(arg1)
end

function var0.Update(arg0, arg1)
	arg0.activity = arg1
	arg0.count = arg1.data1
	arg0.level = 0

	local var0 = {}

	for iter0, iter1 in ipairs(arg1.data1_list) do
		table.insert(var0, iter1)
	end

	table.sort(var0)

	for iter2, iter3 in ipairs(var0) do
		if iter3 == arg0.targets[iter2] then
			arg0.level = iter2
		else
			break
		end
	end

	arg0.startTime = arg1.data2
	arg0.value2 = arg1.data3
	arg0.isDayUnlock = arg0:CheckDayUnlock() and 1 or 0
	arg0.curHasBuffs = arg1.data2_list
	arg0.curBuffs = arg1.data3_list
end

function var0.CheckDayUnlock(arg0)
	local var0 = math.min(arg0.level + 1, #arg0.targets)
	local var1 = pg.TimeMgr.GetInstance()

	return var1:DiffDay(arg0.startTime, var1:GetServerTime()) + 1 >= (arg0.unlockDay[var0] or 0)
end

function var0.GetDayUnlockStamps(arg0)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.unlockDay) do
		local var2 = arg0.startTime + (iter1 - 1) * 86400

		table.insert(var1, var2)
	end

	return var1
end

function var0.GetLevelProgress(arg0)
	local var0 = arg0:getTargetLevel()

	return var0, #arg0.targets, var0 / #arg0.targets
end

function var0.GetResProgress(arg0)
	local var0 = arg0:getTargetLevel()

	return arg0.count, arg0.targets[var0], arg0.count / arg0.targets[var0]
end

function var0.GetUnlockedMaxResRequire(arg0)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = var0:DiffDay(arg0.startTime, var0:GetServerTime()) + 1

	for iter0 = #arg0.targets, 1, -1 do
		if var1 >= arg0.unlockDay[iter0] then
			return arg0.targets[iter0]
		end
	end

	return 1
end

function var0.GetTotalResRequire(arg0)
	return arg0.targets[#arg0.targets]
end

function var0.GetId(arg0)
	return arg0.activity.id
end

function var0.GetRes(arg0)
	return {
		type = 1,
		id = arg0.resId
	}
end

function var0.GetAward(arg0)
	local var0 = arg0.dropList[arg0:getTargetLevel()]

	return Drop.New({
		type = var0[1],
		id = var0[2],
		count = var0[3]
	})
end

function var0.GetResItemId(arg0)
	return arg0:GetAward().id
end

function var0.GetValue2(arg0)
	return arg0.value2
end

function var0.getTargetLevel(arg0)
	return math.min(arg0.level + arg0.isDayUnlock, #arg0.targets)
end

function var0.GetLevel(arg0)
	return arg0.level
end

function var0.CanGetAward(arg0)
	local function var0()
		local var0, var1, var2 = arg0:GetResProgress()

		return var2 >= 1
	end

	return arg0:CanGetNextAward() and var0()
end

function var0.CanGetNextAward(arg0)
	return arg0.isDayUnlock > 0 and arg0.level < #arg0.targets
end

function var0.CanGetMorePt(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.bindActId)

	return var0 and not var0:isEnd()
end

function var0.CanTrain(arg0)
	if not arg0:isInBuffTime() then
		return false
	end

	local function var0(arg0)
		for iter0, iter1 in ipairs(arg0.curHasBuffs) do
			if arg0 == iter1 then
				return false
			end
		end

		return true
	end

	for iter0, iter1 in ipairs(arg0.activity:getDataConfig("target_buff")) do
		if var0(iter1) and iter1 <= arg0.level + 1 then
			return iter1
		end
	end

	return false
end

function var0.GetCurBuffInfos(arg0)
	local var0 = {}
	local var1 = #arg0.activity:getDataConfig("buff_group")

	for iter0, iter1 in ipairs(arg0.curBuffs) do
		for iter2, iter3 in ipairs(arg0.activity:getDataConfig("buff_group")) do
			for iter4, iter5 in ipairs(iter3) do
				if iter1 == iter5 then
					local var2 = {
						id = iter5,
						lv = iter4,
						group = iter2,
						next = iter3[iter4 + 1],
						award = arg0:GetBuffAwardInfo(iter3[#iter3])
					}

					table.insert(var0, var2)
				end
			end
		end
	end

	return var0
end

function var0.GetBuffAwardInfo(arg0, arg1)
	local var0 = arg0.activity:getDataConfig("drop_display")

	if var0 == "" then
		return nil
	end

	for iter0, iter1 in ipairs(var0) do
		if arg1 == iter1[1] then
			local var1 = iter1[2]

			return {
				type = var1[1],
				id = var1[2],
				count = var1[3]
			}
		end
	end

	return nil
end

function var0.GetBuffLevelProgress(arg0)
	local var0 = false
	local var1, var2 = (function()
		for iter0, iter1 in ipairs(arg0.activity:getDataConfig("target_buff")) do
			if iter1 > arg0.level then
				return iter0, iter1
			end
		end

		var0 = true

		return #arg0.activity:getDataConfig("target_buff") + 1, 1
	end)()
	local var3 = (var1 == 1 and true or false) and 0 or arg0.activity:getDataConfig("target_buff")[var1 - 1]

	return var1, var0 and 1 or (arg0.level - var3) / (var2 - var3)
end

function var0.isInBuffTime(arg0)
	local var0 = arg0.activity:getDataConfig("buff_time")

	if type(var0) == "table" then
		local var1 = pg.TimeMgr.GetInstance():GetServerTime()
		local var2 = {
			year = var0[1][1],
			month = var0[1][2],
			day = var0[1][3],
			hour = var0[2][1],
			min = var0[2][2],
			sec = var0[2][3]
		}

		return var1 < pg.TimeMgr.GetInstance():Table2ServerTime(var2) and true or false
	elseif var0 == "always" then
		return true
	elseif var0 == "stop" then
		return false
	end

	return false
end

function var0.GetDrop(arg0, arg1)
	local var0 = arg0.dropList[arg1]

	return {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}
end

function var0.GetPtTarget(arg0, arg1)
	if arg1 <= 0 then
		return 0
	elseif arg1 > #arg0.targets then
		return arg0.targets[#arg0.targets]
	else
		return arg0.targets[arg1]
	end
end

function var0.GetCurrLevel(arg0)
	for iter0, iter1 in ipairs(arg0.targets) do
		if iter1 > arg0.count then
			return iter0 - 1
		end
	end

	return #arg0.targets
end

function var0.IsMaxLevel(arg0)
	return arg0:GetCurrLevel() == #arg0.targets
end

function var0.GetNextLevel(arg0)
	for iter0, iter1 in ipairs(arg0.targets) do
		if iter1 > arg0.count then
			return iter0
		end
	end

	return #arg0.targets
end

function var0.GetCurrTarget(arg0)
	local var0 = arg0:GetCurrLevel()

	return arg0:GetPtTarget(var0)
end

function var0.GetNextLevelTarget(arg0)
	local var0 = arg0:GetNextLevel()

	return arg0:GetPtTarget(var0)
end

function var0.IsGotLevelAward(arg0, arg1)
	local var0 = arg0:GetPtTarget(arg1)

	for iter0, iter1 in ipairs(arg0.activity.data1_list) do
		if iter1 == var0 then
			return true
		end
	end

	return false
end

function var0.GetLastAward(arg0)
	local var0 = arg0.dropList[#arg0.targets]

	return {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}
end

var0.STATE_LOCK = 1
var0.STATE_CAN_GET = 2
var0.STATE_GOT = 3

function var0.GetDroptItemState(arg0, arg1)
	if arg1 > arg0:GetCurrLevel() then
		return var0.STATE_LOCK
	elseif arg0:IsGotLevelAward(arg1) then
		return var0.STATE_GOT
	else
		return var0.STATE_CAN_GET
	end
end

function var0.AnyAwardCanGet(arg0)
	for iter0, iter1 in ipairs(arg0.targets) do
		if arg0:GetDroptItemState(iter0) == var0.STATE_CAN_GET then
			return true
		end
	end

	return false
end

return var0
