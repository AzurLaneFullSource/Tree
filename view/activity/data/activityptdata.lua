local var0_0 = class("ActivityPtData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.dropList = arg1_1:getDataConfig("drop_client")
	arg0_1.targets = arg1_1:getDataConfig("target")
	arg0_1.resId = arg1_1:getDataConfig("pt")
	arg0_1.bindActId = arg1_1:getDataConfig("id_2")
	arg0_1.unlockDay = arg1_1:getDataConfig("day_unlock")
	arg0_1.type = arg1_1:getDataConfig("type")

	arg0_1:Update(arg1_1)
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.activity = arg1_2
	arg0_2.count = arg1_2.data1
	arg0_2.level = 0

	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.data1_list) do
		table.insert(var0_2, iter1_2)
	end

	table.sort(var0_2)

	for iter2_2, iter3_2 in ipairs(var0_2) do
		if iter3_2 == arg0_2.targets[iter2_2] then
			arg0_2.level = iter2_2
		else
			break
		end
	end

	arg0_2.startTime = arg1_2.data2
	arg0_2.value2 = arg1_2.data3
	arg0_2.isDayUnlock = arg0_2:CheckDayUnlock() and 1 or 0
	arg0_2.curHasBuffs = arg1_2.data2_list
	arg0_2.curBuffs = arg1_2.data3_list
end

function var0_0.CheckDayUnlock(arg0_3)
	local var0_3 = math.min(arg0_3.level + 1, #arg0_3.targets)
	local var1_3 = pg.TimeMgr.GetInstance()

	return var1_3:DiffDay(arg0_3.startTime, var1_3:GetServerTime()) + 1 >= (arg0_3.unlockDay[var0_3] or 0)
end

function var0_0.GetDayUnlockStamps(arg0_4)
	local var0_4 = pg.TimeMgr.GetInstance()
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.unlockDay) do
		local var2_4 = arg0_4.startTime + (iter1_4 - 1) * 86400

		table.insert(var1_4, var2_4)
	end

	return var1_4
end

function var0_0.GetLevelProgress(arg0_5)
	local var0_5 = arg0_5:getTargetLevel()

	return var0_5, #arg0_5.targets, var0_5 / #arg0_5.targets
end

function var0_0.GetResProgress(arg0_6)
	local var0_6 = arg0_6:getTargetLevel()

	return arg0_6.count, arg0_6.targets[var0_6], arg0_6.count / arg0_6.targets[var0_6]
end

function var0_0.GetUnlockedMaxResRequire(arg0_7)
	local var0_7 = pg.TimeMgr.GetInstance()
	local var1_7 = var0_7:DiffDay(arg0_7.startTime, var0_7:GetServerTime()) + 1

	for iter0_7 = #arg0_7.targets, 1, -1 do
		if var1_7 >= arg0_7.unlockDay[iter0_7] then
			return arg0_7.targets[iter0_7]
		end
	end

	return 1
end

function var0_0.GetTotalResRequire(arg0_8)
	return arg0_8.targets[#arg0_8.targets]
end

function var0_0.GetId(arg0_9)
	return arg0_9.activity.id
end

function var0_0.GetRes(arg0_10)
	return {
		type = 1,
		id = arg0_10.resId
	}
end

function var0_0.GetAward(arg0_11)
	local var0_11 = arg0_11.dropList[arg0_11:getTargetLevel()]

	return Drop.New({
		type = var0_11[1],
		id = var0_11[2],
		count = var0_11[3]
	})
end

function var0_0.GetResItemId(arg0_12)
	return arg0_12:GetAward().id
end

function var0_0.GetValue2(arg0_13)
	return arg0_13.value2
end

function var0_0.getTargetLevel(arg0_14)
	return math.min(arg0_14.level + arg0_14.isDayUnlock, #arg0_14.targets)
end

function var0_0.GetLevel(arg0_15)
	return arg0_15.level
end

function var0_0.CanGetAward(arg0_16)
	local function var0_16()
		local var0_17, var1_17, var2_17 = arg0_16:GetResProgress()

		return var2_17 >= 1
	end

	return arg0_16:CanGetNextAward() and var0_16()
end

function var0_0.CanGetNextAward(arg0_18)
	return arg0_18.isDayUnlock > 0 and arg0_18.level < #arg0_18.targets
end

function var0_0.CanGetMorePt(arg0_19)
	local var0_19 = getProxy(ActivityProxy):getActivityById(arg0_19.bindActId)

	return var0_19 and not var0_19:isEnd()
end

function var0_0.CanTrain(arg0_20)
	if not arg0_20:isInBuffTime() then
		return false
	end

	local function var0_20(arg0_21)
		for iter0_21, iter1_21 in ipairs(arg0_20.curHasBuffs) do
			if arg0_21 == iter1_21 then
				return false
			end
		end

		return true
	end

	for iter0_20, iter1_20 in ipairs(arg0_20.activity:getDataConfig("target_buff")) do
		if var0_20(iter1_20) and iter1_20 <= arg0_20.level + 1 then
			return iter1_20
		end
	end

	return false
end

function var0_0.GetCurBuffInfos(arg0_22)
	local var0_22 = {}
	local var1_22 = #arg0_22.activity:getDataConfig("buff_group")

	for iter0_22, iter1_22 in ipairs(arg0_22.curBuffs) do
		for iter2_22, iter3_22 in ipairs(arg0_22.activity:getDataConfig("buff_group")) do
			for iter4_22, iter5_22 in ipairs(iter3_22) do
				if iter1_22 == iter5_22 then
					local var2_22 = {
						id = iter5_22,
						lv = iter4_22,
						group = iter2_22,
						next = iter3_22[iter4_22 + 1],
						award = arg0_22:GetBuffAwardInfo(iter3_22[#iter3_22])
					}

					table.insert(var0_22, var2_22)
				end
			end
		end
	end

	return var0_22
end

function var0_0.GetBuffAwardInfo(arg0_23, arg1_23)
	local var0_23 = arg0_23.activity:getDataConfig("drop_display")

	if var0_23 == "" then
		return nil
	end

	for iter0_23, iter1_23 in ipairs(var0_23) do
		if arg1_23 == iter1_23[1] then
			local var1_23 = iter1_23[2]

			return {
				type = var1_23[1],
				id = var1_23[2],
				count = var1_23[3]
			}
		end
	end

	return nil
end

function var0_0.GetBuffLevelProgress(arg0_24)
	local var0_24 = false
	local var1_24, var2_24 = (function()
		for iter0_25, iter1_25 in ipairs(arg0_24.activity:getDataConfig("target_buff")) do
			if iter1_25 > arg0_24.level then
				return iter0_25, iter1_25
			end
		end

		var0_24 = true

		return #arg0_24.activity:getDataConfig("target_buff") + 1, 1
	end)()
	local var3_24 = (var1_24 == 1 and true or false) and 0 or arg0_24.activity:getDataConfig("target_buff")[var1_24 - 1]

	return var1_24, var0_24 and 1 or (arg0_24.level - var3_24) / (var2_24 - var3_24)
end

function var0_0.isInBuffTime(arg0_26)
	local var0_26 = arg0_26.activity:getDataConfig("buff_time")

	if type(var0_26) == "table" then
		local var1_26 = pg.TimeMgr.GetInstance():GetServerTime()
		local var2_26 = {
			year = var0_26[1][1],
			month = var0_26[1][2],
			day = var0_26[1][3],
			hour = var0_26[2][1],
			min = var0_26[2][2],
			sec = var0_26[2][3]
		}

		return var1_26 < pg.TimeMgr.GetInstance():Table2ServerTime(var2_26) and true or false
	elseif var0_26 == "always" then
		return true
	elseif var0_26 == "stop" then
		return false
	end

	return false
end

function var0_0.GetDrop(arg0_27, arg1_27)
	local var0_27 = arg0_27.dropList[arg1_27]

	return {
		type = var0_27[1],
		id = var0_27[2],
		count = var0_27[3]
	}
end

function var0_0.GetPtTarget(arg0_28, arg1_28)
	if arg1_28 <= 0 then
		return 0
	elseif arg1_28 > #arg0_28.targets then
		return arg0_28.targets[#arg0_28.targets]
	else
		return arg0_28.targets[arg1_28]
	end
end

function var0_0.GetCurrLevel(arg0_29)
	for iter0_29, iter1_29 in ipairs(arg0_29.targets) do
		if iter1_29 > arg0_29.count then
			return iter0_29 - 1
		end
	end

	return #arg0_29.targets
end

function var0_0.IsMaxLevel(arg0_30)
	return arg0_30:GetCurrLevel() == #arg0_30.targets
end

function var0_0.GetNextLevel(arg0_31)
	for iter0_31, iter1_31 in ipairs(arg0_31.targets) do
		if iter1_31 > arg0_31.count then
			return iter0_31
		end
	end

	return #arg0_31.targets
end

function var0_0.GetCurrTarget(arg0_32)
	local var0_32 = arg0_32:GetCurrLevel()

	return arg0_32:GetPtTarget(var0_32)
end

function var0_0.GetNextLevelTarget(arg0_33)
	local var0_33 = arg0_33:GetNextLevel()

	return arg0_33:GetPtTarget(var0_33)
end

function var0_0.IsGotLevelAward(arg0_34, arg1_34)
	local var0_34 = arg0_34:GetPtTarget(arg1_34)

	for iter0_34, iter1_34 in ipairs(arg0_34.activity.data1_list) do
		if iter1_34 == var0_34 then
			return true
		end
	end

	return false
end

function var0_0.GetLastAward(arg0_35)
	local var0_35 = arg0_35.dropList[#arg0_35.targets]

	return {
		type = var0_35[1],
		id = var0_35[2],
		count = var0_35[3]
	}
end

var0_0.STATE_LOCK = 1
var0_0.STATE_CAN_GET = 2
var0_0.STATE_GOT = 3

function var0_0.GetDroptItemState(arg0_36, arg1_36)
	if arg1_36 > arg0_36:GetCurrLevel() then
		return var0_0.STATE_LOCK
	elseif arg0_36:IsGotLevelAward(arg1_36) then
		return var0_0.STATE_GOT
	else
		return var0_0.STATE_CAN_GET
	end
end

function var0_0.AnyAwardCanGet(arg0_37)
	for iter0_37, iter1_37 in ipairs(arg0_37.targets) do
		if arg0_37:GetDroptItemState(iter0_37) == var0_0.STATE_CAN_GET then
			return true
		end
	end

	return false
end

return var0_0
