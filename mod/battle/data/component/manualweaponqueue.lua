ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.ManualWeaponQueue = class("ManualWeaponQueue")
var0_0.Battle.ManualWeaponQueue.__name = "ManualWeaponQueue"

local var3_0 = var0_0.Battle.ManualWeaponQueue

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1:init()

	arg0_1._maxCount = arg1_1 or 1
end

function var3_0.init(arg0_2)
	var0_0.EventListener.AttachEventListener(arg0_2)

	arg0_2._weaponList = {}
	arg0_2._overheatQueue = {}
	arg0_2._cooldownList = {}
end

function var3_0.AppendWeapon(arg0_3, arg1_3)
	arg0_3._weaponList[arg1_3] = true

	arg0_3:addWeaponEvent(arg1_3)

	if arg1_3:GetCurrentState() == arg1_3.STATE_OVER_HEAT then
		arg0_3._overheatQueue[#arg0_3._overheatQueue + 1] = arg1_3
	end
end

function var3_0.RemoveWeapon(arg0_4, arg1_4)
	arg0_4._weaponList[arg1_4] = nil

	arg0_4:removeWeaponEvent(arg1_4)

	for iter0_4, iter1_4 in ipairs(arg0_4._overheatQueue) do
		if iter1_4 == arg1_4 then
			table.remove(arg0_4._overheatQueue, iter0_4)

			break
		end
	end

	for iter2_4, iter3_4 in ipairs(arg0_4._cooldownList) do
		if iter3_4 == arg1_4 then
			table.remove(arg0_4._cooldownList, iter2_4)
		end
	end
end

function var3_0.Containers(arg0_5, arg1_5)
	return arg0_5._weaponList[arg1_5]
end

function var3_0.GetCoolDownList(arg0_6)
	return arg0_6._cooldownList
end

function var3_0.GetQueueHead(arg0_7)
	return arg0_7._overheatQueue[#arg0_7._overheatQueue] or arg0_7._cooldownList[1]
end

function var3_0.CheckWeaponInitalCD(arg0_8)
	for iter0_8, iter1_8 in pairs(arg0_8._weaponList) do
		if not iter0_8:GetModifyInitialCD() then
			arg0_8._overheatQueue[#arg0_8._overheatQueue + 1] = iter0_8
		end
	end

	local var0_8 = #arg0_8._cooldownList

	while var0_8 < arg0_8._maxCount and #arg0_8._overheatQueue > 0 do
		local var1_8 = table.remove(arg0_8._overheatQueue, 1)

		var1_8:InitialCD()

		arg0_8._cooldownList[#arg0_8._cooldownList + 1] = var1_8
		var0_8 = #arg0_8._cooldownList
	end

	for iter2_8, iter3_8 in ipairs(arg0_8._overheatQueue) do
		iter3_8:OverHeat()
	end
end

function var3_0.FlushWeaponReloadRequire(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9._weaponList) do
		iter0_9:FlushReloadRequire()
	end
end

function var3_0.Clear(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10._weaponList) do
		arg0_10:removeWeaponEvent(iter0_10)
	end

	arg0_10._weaponList = nil
	arg0_10._overheatQueue = nil

	var0_0.EventListener.DetachEventListener(arg0_10)
end

function var3_0.addWeaponEvent(arg0_11, arg1_11)
	arg1_11:RegisterEventListener(arg0_11, var2_0.MANUAL_WEAPON_FIRE, arg0_11.onManualWeaponFire)
	arg1_11:RegisterEventListener(arg0_11, var2_0.MANUAL_WEAPON_READY, arg0_11.onManualWeaponReady)
	arg1_11:RegisterEventListener(arg0_11, var2_0.MANUAL_WEAPON_INSTANT_READY, arg0_11.onManualInstantReady)
end

function var3_0.removeWeaponEvent(arg0_12, arg1_12)
	arg1_12:UnregisterEventListener(arg0_12, var2_0.MANUAL_WEAPON_READY)
	arg1_12:UnregisterEventListener(arg0_12, var2_0.MANUAL_WEAPON_FIRE)
	arg1_12:UnregisterEventListener(arg0_12, var2_0.MANUAL_WEAPON_INSTANT_READY)
end

function var3_0.onManualWeaponFire(arg0_13, arg1_13)
	local var0_13 = arg1_13.Dispatcher

	var0_13:OverHeat()

	arg0_13._overheatQueue[#arg0_13._overheatQueue + 1] = var0_13

	arg0_13:fillCooldownList()
end

function var3_0.onManualWeaponReady(arg0_14, arg1_14)
	local var0_14 = arg1_14.Dispatcher

	arg0_14:removeFromCDList(var0_14)
	arg0_14:fillCooldownList()
end

function var3_0.onManualInstantReady(arg0_15, arg1_15)
	local var0_15 = arg1_15.Dispatcher
	local var1_15

	for iter0_15, iter1_15 in ipairs(arg0_15._overheatQueue) do
		if var0_15 == iter1_15 then
			table.remove(arg0_15._overheatQueue, iter0_15)

			var1_15 = true

			break
		end
	end

	if not var1_15 then
		arg0_15:removeFromCDList(var0_15)
	end

	arg0_15:fillCooldownList()
end

function var3_0.removeFromCDList(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg0_16._cooldownList) do
		if arg1_16 == iter1_16 then
			table.remove(arg0_16._cooldownList, iter0_16)

			break
		end
	end
end

function var3_0.fillCooldownList(arg0_17)
	local var0_17 = #arg0_17._cooldownList

	while var0_17 < arg0_17._maxCount and #arg0_17._overheatQueue > 0 do
		local var1_17 = table.remove(arg0_17._overheatQueue, 1)

		var1_17:EnterCoolDown()

		arg0_17._cooldownList[#arg0_17._cooldownList + 1] = var1_17
		var0_17 = #arg0_17._cooldownList
	end
end
