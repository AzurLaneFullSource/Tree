local var0_0 = class("CommanderHome", import("...BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.level = arg1_1.level
	arg0_1.configId = arg0_1.level
	arg0_1.exp = arg1_1.exp
	arg0_1.catterys = {}
	arg0_1.unlockCatteryId = 1
	arg0_1.clean = arg1_1.clean or 0

	for iter0_1, iter1_1 in ipairs(arg1_1.slots) do
		arg0_1.catterys[iter1_1.id] = Cattery.New(arg0_1, iter1_1)

		if iter1_1.id > arg0_1.unlockCatteryId then
			arg0_1.unlockCatteryId = iter1_1.id
		end
	end

	for iter2_1 = 1, pg.gameset.commander_home_number.key_value do
		if not arg0_1.catterys[iter2_1] then
			arg0_1.catterys[iter2_1] = Cattery.New(arg0_1, {
				op_flag = 7,
				id = iter2_1
			})
		end
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.commander_home
end

function var0_0.GetLevel(arg0_3)
	return arg0_3.level
end

function var0_0.GetMaxLevel(arg0_4)
	local var0_4 = arg0_4:bindConfigTable()

	return var0_4.all[#var0_4.all]
end

function var0_0.IsMaxLevel(arg0_5)
	return arg0_5:GetMaxLevel() <= arg0_5.level
end

function var0_0.AddExp(arg0_6, arg1_6)
	arg0_6.exp = arg0_6.exp + arg1_6

	while arg0_6:CanUpgrade() do
		local var0_6 = arg0_6:GetNextLevelExp()

		arg0_6:LevelUp(arg0_6.level + 1)

		arg0_6.exp = arg0_6.exp - var0_6
	end
end

function var0_0.UpdateExpAndLevel(arg0_7, arg1_7, arg2_7)
	if arg1_7 > arg0_7.level then
		arg0_7:LevelUp(arg1_7)
	end

	arg0_7.exp = arg2_7
end

function var0_0.LevelUp(arg0_8, arg1_8)
	arg0_8.level = arg1_8
	arg0_8.configId = arg1_8
end

function var0_0.CanUpgrade(arg0_9)
	if arg0_9:GetNextLevelExp() <= arg0_9.exp and not arg0_9:IsMaxLevel() then
		return true
	end

	return false
end

function var0_0.GetNextLevelExp(arg0_10)
	return arg0_10:getConfig("home_exp")
end

function var0_0.GetPrevLevelExp(arg0_11)
	local var0_11 = arg0_11:bindConfigTable()

	return var0_11[arg0_11.level - 1] and var0_11[arg0_11.level - 1].home_exp or 0
end

function var0_0.GetCatteries(arg0_12)
	return arg0_12.catterys
end

function var0_0.GetCatteryById(arg0_13, arg1_13)
	return arg0_13.catterys[arg1_13]
end

function var0_0.GetAllLevel(arg0_14)
	return arg0_14:bindConfigTable().all
end

function var0_0.IsHeadLevel(arg0_15, arg1_15)
	return arg0_15:GetAllLevel()[1] == arg1_15
end

function var0_0.isTailLevel(arg0_16, arg1_16)
	local var0_16 = arg0_16:GetAllLevel()

	return var0_16[#var0_16] == arg1_16
end

function var0_0.GetLevelConfig(arg0_17, arg1_17)
	return arg0_17:bindConfigTable()[arg1_17]
end

function var0_0.GetTargetExpForLevel(arg0_18, arg1_18)
	local var0_18 = 0

	for iter0_18 = 1, arg1_18 - 1 do
		var0_18 = var0_18 + arg0_18:GetLevelConfig(iter0_18).home_exp
	end

	return var0_18
end

function var0_0.GetClean(arg0_19)
	return arg0_19.clean
end

function var0_0.IncCleanValue(arg0_20)
	arg0_20.clean = arg0_20.clean + arg0_20:getConfig("flower")[1]
end

function var0_0.ReduceClean(arg0_21)
	local var0_21 = false
	local var1_21 = arg0_21:getConfig("flower")[2]
	local var2_21 = arg0_21:GetCatteries()

	for iter0_21, iter1_21 in pairs(var2_21) do
		if iter1_21:IsDirty() then
			arg0_21.clean = arg0_21.clean - var1_21

			break
		end
	end
end

function var0_0.GetCleanLevel(arg0_22)
	local var0_22 = arg0_22:getConfig("flower")[3]
	local var1_22 = 0

	for iter0_22, iter1_22 in ipairs(var0_22) do
		if iter1_22 <= arg0_22.clean then
			var1_22 = iter0_22
		end
	end

	return var1_22
end

function var0_0.GetOwnStyles(arg0_23)
	return arg0_23:getConfig("nest_appearance")
end

function var0_0.GetMaxCatteryCnt(arg0_24)
	return arg0_24:getConfig("nest_number")
end

function var0_0.GetCatteriesCommanders(arg0_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in pairs(arg0_25:GetCatteries()) do
		if iter1_25:ExistCommander() then
			table.insert(var0_25, iter1_25:GetCommanderId())
		end
	end

	return var0_25
end

function var0_0.ResetCatteryOP(arg0_26)
	local var0_26 = arg0_26:GetCatteries()

	for iter0_26, iter1_26 in pairs(var0_26) do
		if iter1_26:ExistCommander() then
			iter1_26:ResetOP()
		end
	end
end

function var0_0.GetFeedCommanderExp(arg0_27)
	return arg0_27:getConfig("feed_level")[2]
end

function var0_0.AnyCatteryExistOP(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28:GetCatteries()) do
		if not iter1_28:IsLocked() and (iter1_28:ExiseFeedOP() or iter1_28:ExistPlayOP() or iter1_28:ExistCleanOP()) then
			return true
		end
	end

	return false
end

function var0_0.AnyCatteryCanUse(arg0_29)
	for iter0_29, iter1_29 in pairs(arg0_29:GetCatteries()) do
		if iter1_29:GetState() == Cattery.STATE_EMPTY then
			return true
		end
	end

	return false
end

function var0_0.GetFeedLevel(arg0_30)
	return arg0_30:getConfig("feed_level")[1]
end

function var0_0.GetPlayLevel(arg0_31)
	return arg0_31:getConfig("teast_level")[1]
end

function var0_0.GetExistCommanderCattertCnt(arg0_32)
	local var0_32 = 0
	local var1_32 = arg0_32:GetCatteries()

	for iter0_32, iter1_32 in pairs(var1_32) do
		if iter1_32:ExistCommander() then
			var0_32 = var0_32 + 1
		end
	end

	return var0_32
end

function var0_0.CommanderInHome(arg0_33, arg1_33)
	local var0_33 = arg0_33:GetCatteries()

	for iter0_33, iter1_33 in pairs(var0_33) do
		if iter1_33:GetCommanderId() == arg1_33 then
			return true
		end
	end

	return false
end

function var0_0.ShouldSettleCattery(arg0_34)
	local var0_34 = arg0_34:GetCatteries()

	for iter0_34, iter1_34 in pairs(var0_34) do
		if iter1_34:ExistCommander() and iter1_34:ExistCacheExp() then
			return true
		end
	end

	return false
end

return var0_0
