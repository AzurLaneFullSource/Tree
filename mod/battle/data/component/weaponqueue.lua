ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst

var0_0.Battle.WeaponQueue = class("WeaponQueue")
var0_0.Battle.WeaponQueue.__name = "WeaponQueue"

local var2_0 = var0_0.Battle.WeaponQueue

function var2_0.Ctor(arg0_1)
	arg0_1._totalWeapon = {}
	arg0_1._queueList = {}
	arg0_1._GCDTimerList = {}
end

function var2_0.ConfigParallel(arg0_2, arg1_2, arg2_2)
	arg0_2._torpedoQueue = var0_0.Battle.ManualWeaponQueue.New(arg2_2)
	arg0_2._chargeQueue = var0_0.Battle.ManualWeaponQueue.New(arg1_2)
end

function var2_0.ClearAllWeapon(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3._totalWeapon) do
		iter1_3:Clear()
	end
end

function var2_0.Dispose(arg0_4)
	arg0_4._torpedoQueue:Clear()
	arg0_4._chargeQueue:Clear()

	for iter0_4, iter1_4 in ipairs(arg0_4._totalWeapon) do
		iter1_4:Dispose()
	end

	arg0_4._torpedoQueue = nil
	arg0_4._chargeQueue = nil
end

function var2_0.AppendWeapon(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetTemplateData().queue
	local var1_5 = arg0_5:GetQueueByIndex(var0_5)

	var1_5[#var1_5 + 1] = arg1_5
	arg0_5._totalWeapon[#arg0_5._totalWeapon + 1] = arg1_5
end

function var2_0.RemoveWeapon(arg0_6, arg1_6)
	local var0_6 = arg1_6:GetTemplateData().queue
	local var1_6 = arg0_6:GetQueueByIndex(var0_6)
	local var2_6 = 1
	local var3_6 = #var1_6

	while var2_6 <= var3_6 do
		if var1_6[var2_6] == arg1_6 then
			table.remove(var1_6, var2_6)

			break
		end

		var2_6 = var2_6 + 1
	end

	local var4_6 = 1
	local var5_6 = #arg0_6._totalWeapon

	while var4_6 <= var5_6 do
		if arg0_6._totalWeapon[var4_6] == arg1_6 then
			table.remove(arg0_6._totalWeapon, var4_6)

			break
		end

		var4_6 = var4_6 + 1
	end
end

function var2_0.AppendManualTorpedo(arg0_7, arg1_7)
	arg0_7:AppendWeapon(arg1_7)
	arg0_7._torpedoQueue:AppendWeapon(arg1_7)
end

function var2_0.AppendChargeWeapon(arg0_8, arg1_8)
	arg0_8:AppendWeapon(arg1_8)
	arg0_8._chargeQueue:AppendWeapon(arg1_8)
end

function var2_0.RemoveManualTorpedo(arg0_9, arg1_9)
	arg0_9:RemoveWeapon(arg1_9)
	arg0_9._torpedoQueue:RemoveWeapon(arg1_9)
end

function var2_0.RemoveManualChargeWeapon(arg0_10, arg1_10)
	arg0_10:RemoveWeapon(arg1_10)
	arg0_10._chargeQueue:RemoveWeapon(arg1_10)
end

function var2_0.QueueEnterGCD(arg0_11, arg1_11, arg2_11)
	arg0_11:addGCDTimer(arg2_11, arg1_11)
end

function var2_0.GetTotalWeaponUnit(arg0_12)
	return arg0_12._totalWeapon
end

function var2_0.GetQueueByIndex(arg0_13, arg1_13)
	if arg0_13._queueList[arg1_13] == nil then
		arg0_13._queueList[arg1_13] = {}
	end

	return arg0_13._queueList[arg1_13]
end

function var2_0.GetManualTorpedoQueue(arg0_14)
	return arg0_14._torpedoQueue
end

function var2_0.GetChargeWeaponQueue(arg0_15)
	return arg0_15._chargeQueue
end

function var2_0.Update(arg0_16, arg1_16)
	for iter0_16, iter1_16 in pairs(arg0_16._queueList) do
		if arg0_16:isNotAttacking(iter0_16) then
			arg0_16:updateWeapon(iter0_16, arg1_16)
		end
	end
end

function var2_0.CheckWeaponInitalCD(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17._totalWeapon) do
		if not arg0_17._torpedoQueue:Containers(iter1_17) and not arg0_17._chargeQueue:Containers(iter1_17) then
			iter1_17:InitialCD()
		end
	end

	arg0_17._torpedoQueue:CheckWeaponInitalCD()
	arg0_17._chargeQueue:CheckWeaponInitalCD()
end

function var2_0.FlushWeaponReloadRequire(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18._totalWeapon) do
		if not arg0_18._torpedoQueue:Containers(iter1_18) and not arg0_18._chargeQueue:Containers(iter1_18) then
			iter1_18:FlushReloadRequire()
		end
	end

	arg0_18._torpedoQueue:FlushWeaponReloadRequire()
	arg0_18._chargeQueue:FlushWeaponReloadRequire()
end

function var2_0.isNotAttacking(arg0_19, arg1_19)
	if arg0_19._GCDTimerList[arg1_19] ~= nil then
		return false
	end

	for iter0_19, iter1_19 in ipairs(arg0_19._queueList[arg1_19]) do
		if iter1_19:IsAttacking() then
			return false
		end
	end

	return true
end

function var2_0.updateWeapon(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20._queueList[arg1_20]

	for iter0_20, iter1_20 in ipairs(var0_20) do
		if iter1_20:GetType() == var1_0.EquipmentType.BEAM and iter1_20:GetCurrentState() == iter1_20.STATE_ATTACK then
			iter1_20:Update()

			return
		end
	end

	for iter2_20, iter3_20 in ipairs(var0_20) do
		local var1_20 = false
		local var2_20 = false
		local var3_20 = iter3_20:GetCurrentState()

		if var3_20 == iter3_20.STATE_PRECAST or var3_20 == iter3_20.STATE_READY or var3_20 == iter3_20.STATE_OVER_HEAT and iter3_20:CheckReloadTimeStamp() then
			var1_20 = true
		end

		iter3_20:Update(arg2_20)

		local var4_20 = iter3_20:GetCurrentState()

		if var4_20 == iter3_20.STATE_PRECAST or var4_20 == iter3_20.STATE_READY then
			var2_20 = true
		end

		if arg1_20 ~= var1_0.NON_QUEUE_WEAPON and (var1_20 and not var2_20 or iter3_20:IsAttacking()) then
			break
		end
	end
end

function var2_0.addGCDTimer(arg0_21, arg1_21, arg2_21)
	if arg0_21._GCDTimerList[arg2_21] ~= nil then
		return
	end

	local function var0_21()
		arg0_21:removeGCDTimer(arg2_21)
	end

	arg0_21._GCDTimerList[arg2_21] = pg.TimeMgr.GetInstance():AddBattleTimer("weaponGCD", -1, arg1_21, var0_21, true)
end

function var2_0.removeGCDTimer(arg0_23, arg1_23)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_23._GCDTimerList[arg1_23])

	arg0_23._GCDTimerList[arg1_23] = nil
end
