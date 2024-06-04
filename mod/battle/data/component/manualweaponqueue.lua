ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleUnitEvent

var0.Battle.ManualWeaponQueue = class("ManualWeaponQueue")
var0.Battle.ManualWeaponQueue.__name = "ManualWeaponQueue"

local var3 = var0.Battle.ManualWeaponQueue

function var3.Ctor(arg0, arg1)
	arg0:init()

	arg0._maxCount = arg1 or 1
end

function var3.init(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0._weaponList = {}
	arg0._overheatQueue = {}
	arg0._cooldownList = {}
end

function var3.AppendWeapon(arg0, arg1)
	arg0._weaponList[arg1] = true

	arg0:addWeaponEvent(arg1)

	if arg1:GetCurrentState() == arg1.STATE_OVER_HEAT then
		arg0._overheatQueue[#arg0._overheatQueue + 1] = arg1
	end
end

function var3.RemoveWeapon(arg0, arg1)
	arg0._weaponList[arg1] = nil

	arg0:removeWeaponEvent(arg1)

	for iter0, iter1 in ipairs(arg0._overheatQueue) do
		if iter1 == arg1 then
			table.remove(arg0._overheatQueue, iter0)

			break
		end
	end

	for iter2, iter3 in ipairs(arg0._cooldownList) do
		if iter3 == arg1 then
			table.remove(arg0._cooldownList, iter2)
		end
	end
end

function var3.Containers(arg0, arg1)
	return arg0._weaponList[arg1]
end

function var3.GetCoolDownList(arg0)
	return arg0._cooldownList
end

function var3.GetQueueHead(arg0)
	return arg0._overheatQueue[#arg0._overheatQueue] or arg0._cooldownList[1]
end

function var3.CheckWeaponInitalCD(arg0)
	for iter0, iter1 in pairs(arg0._weaponList) do
		if not iter0:GetModifyInitialCD() then
			arg0._overheatQueue[#arg0._overheatQueue + 1] = iter0
		end
	end

	local var0 = #arg0._cooldownList

	while var0 < arg0._maxCount and #arg0._overheatQueue > 0 do
		local var1 = table.remove(arg0._overheatQueue, 1)

		var1:InitialCD()

		arg0._cooldownList[#arg0._cooldownList + 1] = var1
		var0 = #arg0._cooldownList
	end

	for iter2, iter3 in ipairs(arg0._overheatQueue) do
		iter3:OverHeat()
	end
end

function var3.FlushWeaponReloadRequire(arg0)
	for iter0, iter1 in pairs(arg0._weaponList) do
		iter0:FlushReloadRequire()
	end
end

function var3.Clear(arg0)
	for iter0, iter1 in pairs(arg0._weaponList) do
		arg0:removeWeaponEvent(iter0)
	end

	arg0._weaponList = nil
	arg0._overheatQueue = nil

	var0.EventListener.DetachEventListener(arg0)
end

function var3.addWeaponEvent(arg0, arg1)
	arg1:RegisterEventListener(arg0, var2.MANUAL_WEAPON_FIRE, arg0.onManualWeaponFire)
	arg1:RegisterEventListener(arg0, var2.MANUAL_WEAPON_READY, arg0.onManualWeaponReady)
	arg1:RegisterEventListener(arg0, var2.MANUAL_WEAPON_INSTANT_READY, arg0.onManualInstantReady)
end

function var3.removeWeaponEvent(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var2.MANUAL_WEAPON_READY)
	arg1:UnregisterEventListener(arg0, var2.MANUAL_WEAPON_FIRE)
	arg1:UnregisterEventListener(arg0, var2.MANUAL_WEAPON_INSTANT_READY)
end

function var3.onManualWeaponFire(arg0, arg1)
	local var0 = arg1.Dispatcher

	var0:OverHeat()

	arg0._overheatQueue[#arg0._overheatQueue + 1] = var0

	arg0:fillCooldownList()
end

function var3.onManualWeaponReady(arg0, arg1)
	local var0 = arg1.Dispatcher

	arg0:removeFromCDList(var0)
	arg0:fillCooldownList()
end

function var3.onManualInstantReady(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1

	for iter0, iter1 in ipairs(arg0._overheatQueue) do
		if var0 == iter1 then
			table.remove(arg0._overheatQueue, iter0)

			var1 = true

			break
		end
	end

	if not var1 then
		arg0:removeFromCDList(var0)
	end

	arg0:fillCooldownList()
end

function var3.removeFromCDList(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._cooldownList) do
		if arg1 == iter1 then
			table.remove(arg0._cooldownList, iter0)

			break
		end
	end
end

function var3.fillCooldownList(arg0)
	local var0 = #arg0._cooldownList

	while var0 < arg0._maxCount and #arg0._overheatQueue > 0 do
		local var1 = table.remove(arg0._overheatQueue, 1)

		var1:EnterCoolDown()

		arg0._cooldownList[#arg0._cooldownList + 1] = var1
		var0 = #arg0._cooldownList
	end
end
