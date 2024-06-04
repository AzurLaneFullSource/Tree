ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleAttr
local var3 = var1.AntiAirConfig

var0.Battle.BattleAntiAirWeaponVO = class("BattleAntiAirWeaponVO", var0.Battle.BattlePlayerWeaponVO)
var0.Battle.BattleAntiAirWeaponVO.__name = "BattleAntiAirWeaponVO"

local var4 = var0.Battle.BattleAntiAirWeaponVO

function var4.Ctor(arg0, arg1)
	var4.super.Ctor(arg0, arg1)

	arg0._restoreDenominator = var3.const_A

	arg0:ResetCost()

	arg0._restoreInterval = var3.Restore_Interval
end

function var4.SetBattleFleetVO(arg0, arg1)
	arg0._battleFleetVO = arg1
end

function var4.AppendWeapon(arg0, arg1)
	var4.super.AppendWeapon(arg0, arg1)
	arg1:SetTotalDurabilityInfo(arg0)
end

function var4.RemoveWeapon(arg0, arg1)
	local var0 = arg0.deleteElementFromArray(arg1, arg0._weaponList)

	arg0._total = arg0._total - 1
	arg0._count = arg0._count - 1

	return var0
end

function var4.SetMax(arg0, arg1)
	if arg1 > arg0._max then
		arg0._current = arg0._current + (arg1 - arg0._max)
	end

	var4.super.SetMax(arg0, arg1)

	if arg0._current > arg0._max then
		arg0._current = arg0._max
	end
end

function var4.SetAverageReload(arg0, arg1)
	arg0._fleetReload = arg1
end

function var4.GetMaxRange(arg0)
	local var0 = arg0._battleFleetVO:GetScoutList()
	local var1 = 0
	local var2 = #var0

	if var2 > 0 then
		local var3

		for iter0 = 1, var2 do
			if #var0[iter0]:GetAntiAirWeapon() > 0 then
				var3 = var0[iter0]

				break
			end
		end

		if var3 then
			local var4 = var3:GetAntiAirWeapon()

			for iter1, iter2 in ipairs(var4) do
				var1 = math.max(var1, iter2:GetTemplateData().range)
			end
		end
	end

	return var1
end

function var4.SetActive(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._weaponList) do
		iter1:SetActive(arg1)
	end
end

function var4.Restore(arg0)
	arg0._current = arg0._current + arg0._fleetReload / arg0._restoreDenominator

	arg0:checkRestorState()
end

function var4.RestoreRate(arg0, arg1)
	arg0._current = arg0._current + arg0._max * arg1

	arg0:checkRestorState()
end

function var4.checkRestorState(arg0)
	if arg0._current >= arg0._max then
		arg0._current = arg0._max
		arg0._restoreDenominator = var3.const_A
		arg0._isOverLoad = false

		arg0:RemoveRestoreTimer()
		arg0:DispatchOverLoadChange()
	end
end

function var4.Consume(arg0)
	arg0:RemoveRestoreTimer()

	arg0._current = arg0._current - arg0._consumeNormal

	if arg0._current <= 0 then
		arg0._current = 0
		arg0._restoreDenominator = var3.const_B
		arg0._isOverLoad = true

		arg0:DispatchOverLoadChange()
	end
end

function var4.ResetCost(arg0, arg1)
	arg0._consumeNormal = arg1 or var3.const_N
end

function var4.AddRestoreTimer(arg0)
	if arg0._restoreTimer or arg0._current >= arg0._max then
		return
	end

	local function var0()
		arg0:Restore()
	end

	arg0._restoreTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AARestoreTimer", -1, arg0._restoreInterval, var0, true)
end

function var4.RemoveRestoreTimer(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._restoreTimer)

	arg0._restoreTimer = nil
end

function var4.Dispose(arg0)
	arg0._battleFleetVO = nil

	var4.super.Dispose(arg0)
end
