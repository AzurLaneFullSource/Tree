ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst

var0.Battle.WeaponQueue = class("WeaponQueue")
var0.Battle.WeaponQueue.__name = "WeaponQueue"

local var2 = var0.Battle.WeaponQueue

function var2.Ctor(arg0)
	arg0._totalWeapon = {}
	arg0._queueList = {}
	arg0._GCDTimerList = {}
end

function var2.ConfigParallel(arg0, arg1, arg2)
	arg0._torpedoQueue = var0.Battle.ManualWeaponQueue.New(arg2)
	arg0._chargeQueue = var0.Battle.ManualWeaponQueue.New(arg1)
end

function var2.ClearAllWeapon(arg0)
	for iter0, iter1 in ipairs(arg0._totalWeapon) do
		iter1:Clear()
	end
end

function var2.Dispose(arg0)
	arg0._torpedoQueue:Clear()
	arg0._chargeQueue:Clear()

	for iter0, iter1 in ipairs(arg0._totalWeapon) do
		iter1:Dispose()
	end

	arg0._torpedoQueue = nil
	arg0._chargeQueue = nil
end

function var2.AppendWeapon(arg0, arg1)
	local var0 = arg1:GetTemplateData().queue
	local var1 = arg0:GetQueueByIndex(var0)

	var1[#var1 + 1] = arg1
	arg0._totalWeapon[#arg0._totalWeapon + 1] = arg1
end

function var2.RemoveWeapon(arg0, arg1)
	local var0 = arg1:GetTemplateData().queue
	local var1 = arg0:GetQueueByIndex(var0)
	local var2 = 1
	local var3 = #var1

	while var2 <= var3 do
		if var1[var2] == arg1 then
			table.remove(var1, var2)

			break
		end

		var2 = var2 + 1
	end

	local var4 = 1
	local var5 = #arg0._totalWeapon

	while var4 <= var5 do
		if arg0._totalWeapon[var4] == arg1 then
			table.remove(arg0._totalWeapon, var4)

			break
		end

		var4 = var4 + 1
	end
end

function var2.AppendManualTorpedo(arg0, arg1)
	arg0:AppendWeapon(arg1)
	arg0._torpedoQueue:AppendWeapon(arg1)
end

function var2.AppendChargeWeapon(arg0, arg1)
	arg0:AppendWeapon(arg1)
	arg0._chargeQueue:AppendWeapon(arg1)
end

function var2.RemoveManualTorpedo(arg0, arg1)
	arg0:RemoveWeapon(arg1)
	arg0._torpedoQueue:RemoveWeapon(arg1)
end

function var2.RemoveManualChargeWeapon(arg0, arg1)
	arg0:RemoveWeapon(arg1)
	arg0._chargeQueue:RemoveWeapon(arg1)
end

function var2.QueueEnterGCD(arg0, arg1, arg2)
	arg0:addGCDTimer(arg2, arg1)
end

function var2.GetTotalWeaponUnit(arg0)
	return arg0._totalWeapon
end

function var2.GetQueueByIndex(arg0, arg1)
	if arg0._queueList[arg1] == nil then
		arg0._queueList[arg1] = {}
	end

	return arg0._queueList[arg1]
end

function var2.GetManualTorpedoQueue(arg0)
	return arg0._torpedoQueue
end

function var2.GetChargeWeaponQueue(arg0)
	return arg0._chargeQueue
end

function var2.Update(arg0, arg1)
	for iter0, iter1 in pairs(arg0._queueList) do
		if arg0:isNotAttacking(iter0) then
			arg0:updateWeapon(iter0, arg1)
		end
	end
end

function var2.CheckWeaponInitalCD(arg0)
	for iter0, iter1 in ipairs(arg0._totalWeapon) do
		if not arg0._torpedoQueue:Containers(iter1) and not arg0._chargeQueue:Containers(iter1) then
			iter1:InitialCD()
		end
	end

	arg0._torpedoQueue:CheckWeaponInitalCD()
	arg0._chargeQueue:CheckWeaponInitalCD()
end

function var2.FlushWeaponReloadRequire(arg0)
	for iter0, iter1 in ipairs(arg0._totalWeapon) do
		if not arg0._torpedoQueue:Containers(iter1) and not arg0._chargeQueue:Containers(iter1) then
			iter1:FlushReloadRequire()
		end
	end

	arg0._torpedoQueue:FlushWeaponReloadRequire()
	arg0._chargeQueue:FlushWeaponReloadRequire()
end

function var2.isNotAttacking(arg0, arg1)
	if arg0._GCDTimerList[arg1] ~= nil then
		return false
	end

	for iter0, iter1 in ipairs(arg0._queueList[arg1]) do
		if iter1:IsAttacking() then
			return false
		end
	end

	return true
end

function var2.updateWeapon(arg0, arg1, arg2)
	local var0 = arg0._queueList[arg1]

	for iter0, iter1 in ipairs(var0) do
		if iter1:GetType() == var1.EquipmentType.BEAM and iter1:GetCurrentState() == iter1.STATE_ATTACK then
			iter1:Update()

			return
		end
	end

	for iter2, iter3 in ipairs(var0) do
		local var1 = false
		local var2 = false
		local var3 = iter3:GetCurrentState()

		if var3 == iter3.STATE_PRECAST or var3 == iter3.STATE_READY or var3 == iter3.STATE_OVER_HEAT and iter3:CheckReloadTimeStamp() then
			var1 = true
		end

		iter3:Update(arg2)

		local var4 = iter3:GetCurrentState()

		if var4 == iter3.STATE_PRECAST or var4 == iter3.STATE_READY then
			var2 = true
		end

		if arg1 ~= var1.NON_QUEUE_WEAPON and (var1 and not var2 or iter3:IsAttacking()) then
			break
		end
	end
end

function var2.addGCDTimer(arg0, arg1, arg2)
	if arg0._GCDTimerList[arg2] ~= nil then
		return
	end

	local function var0()
		arg0:removeGCDTimer(arg2)
	end

	arg0._GCDTimerList[arg2] = pg.TimeMgr.GetInstance():AddBattleTimer("weaponGCD", -1, arg1, var0, true)
end

function var2.removeGCDTimer(arg0, arg1)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._GCDTimerList[arg1])

	arg0._GCDTimerList[arg1] = nil
end
