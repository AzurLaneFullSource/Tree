ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleAttr
local var3_0 = var1_0.AntiAirConfig

var0_0.Battle.BattleAntiAirWeaponVO = class("BattleAntiAirWeaponVO", var0_0.Battle.BattlePlayerWeaponVO)
var0_0.Battle.BattleAntiAirWeaponVO.__name = "BattleAntiAirWeaponVO"

local var4_0 = var0_0.Battle.BattleAntiAirWeaponVO

function var4_0.Ctor(arg0_1, arg1_1)
	var4_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._restoreDenominator = var3_0.const_A

	arg0_1:ResetCost()

	arg0_1._restoreInterval = var3_0.Restore_Interval
end

function var4_0.SetBattleFleetVO(arg0_2, arg1_2)
	arg0_2._battleFleetVO = arg1_2
end

function var4_0.AppendWeapon(arg0_3, arg1_3)
	var4_0.super.AppendWeapon(arg0_3, arg1_3)
	arg1_3:SetTotalDurabilityInfo(arg0_3)
end

function var4_0.RemoveWeapon(arg0_4, arg1_4)
	local var0_4 = arg0_4.deleteElementFromArray(arg1_4, arg0_4._weaponList)

	arg0_4._total = arg0_4._total - 1
	arg0_4._count = arg0_4._count - 1

	return var0_4
end

function var4_0.SetMax(arg0_5, arg1_5)
	if arg1_5 > arg0_5._max then
		arg0_5._current = arg0_5._current + (arg1_5 - arg0_5._max)
	end

	var4_0.super.SetMax(arg0_5, arg1_5)

	if arg0_5._current > arg0_5._max then
		arg0_5._current = arg0_5._max
	end
end

function var4_0.SetAverageReload(arg0_6, arg1_6)
	arg0_6._fleetReload = arg1_6
end

function var4_0.GetMaxRange(arg0_7)
	local var0_7 = arg0_7._battleFleetVO:GetScoutList()
	local var1_7 = 0
	local var2_7 = #var0_7

	if var2_7 > 0 then
		local var3_7

		for iter0_7 = 1, var2_7 do
			if #var0_7[iter0_7]:GetAntiAirWeapon() > 0 then
				var3_7 = var0_7[iter0_7]

				break
			end
		end

		if var3_7 then
			local var4_7 = var3_7:GetAntiAirWeapon()

			for iter1_7, iter2_7 in ipairs(var4_7) do
				var1_7 = math.max(var1_7, iter2_7:GetTemplateData().range)
			end
		end
	end

	return var1_7
end

function var4_0.SetActive(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg0_8._weaponList) do
		iter1_8:SetActive(arg1_8)
	end
end

function var4_0.Restore(arg0_9)
	arg0_9._current = arg0_9._current + arg0_9._fleetReload / arg0_9._restoreDenominator

	arg0_9:checkRestorState()
end

function var4_0.RestoreRate(arg0_10, arg1_10)
	arg0_10._current = arg0_10._current + arg0_10._max * arg1_10

	arg0_10:checkRestorState()
end

function var4_0.checkRestorState(arg0_11)
	if arg0_11._current >= arg0_11._max then
		arg0_11._current = arg0_11._max
		arg0_11._restoreDenominator = var3_0.const_A
		arg0_11._isOverLoad = false

		arg0_11:RemoveRestoreTimer()
		arg0_11:DispatchOverLoadChange()
	end
end

function var4_0.Consume(arg0_12)
	arg0_12:RemoveRestoreTimer()

	arg0_12._current = arg0_12._current - arg0_12._consumeNormal

	if arg0_12._current <= 0 then
		arg0_12._current = 0
		arg0_12._restoreDenominator = var3_0.const_B
		arg0_12._isOverLoad = true

		arg0_12:DispatchOverLoadChange()
	end
end

function var4_0.ResetCost(arg0_13, arg1_13)
	arg0_13._consumeNormal = arg1_13 or var3_0.const_N
end

function var4_0.AddRestoreTimer(arg0_14)
	if arg0_14._restoreTimer or arg0_14._current >= arg0_14._max then
		return
	end

	local function var0_14()
		arg0_14:Restore()
	end

	arg0_14._restoreTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AARestoreTimer", -1, arg0_14._restoreInterval, var0_14, true)
end

function var4_0.RemoveRestoreTimer(arg0_16)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_16._restoreTimer)

	arg0_16._restoreTimer = nil
end

function var4_0.Dispose(arg0_17)
	arg0_17._battleFleetVO = nil

	var4_0.super.Dispose(arg0_17)
end
