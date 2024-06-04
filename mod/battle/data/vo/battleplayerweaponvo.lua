ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattlePlayerWeaponVO = class("BattlePlayerWeaponVO")
var0.Battle.BattlePlayerWeaponVO.__name = "BattlePlayerWeaponVO"

local var3 = var0.Battle.BattlePlayerWeaponVO

function var3.Ctor(arg0, arg1)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._GCD = arg1

	arg0:Reset()
end

function var3.Reset(arg0)
	arg0._isOverLoad = false
	arg0._current = arg0._GCD
	arg0._max = arg0._GCD
	arg0._count = 0
	arg0._total = 0
	arg0._weaponList = {}
	arg0._overHeatList = {}
	arg0._readyList = {}
	arg0._chargingList = {}
end

function var3.Update(arg0, arg1)
	if arg0._current < arg0._max then
		local var0 = arg1 - arg0._reloadStartTime

		if var0 >= arg0._max then
			arg0._current = arg0._max
			arg0._reloadStartTime = nil

			for iter0, iter1 in ipairs(arg0._chargingList) do
				iter1:UpdateReload()
			end

			arg0:DispatchOverLoadChange()
		else
			arg0._current = var0
		end
	end
end

function var3.PlayFocus(arg0, arg1, arg2)
	var0.Battle.BattleCameraUtil.GetInstance():FocusCharacter(arg1, var1.CAST_CAM_ZOOM_IN_DURATION)
	var0.Battle.BattleCameraUtil.GetInstance():ZoomCamara(nil, var1.CAST_CAM_ZOOM_SIZE, var1.CAST_CAM_ZOOM_IN_DURATION, true)
	var0.Battle.BattleCameraUtil.GetInstance():BulletTime(var1.SPEED_FACTOR_FOCUS_CHARACTER, var1.FOCUS_MAP_RATE, arg1)

	arg0._focus = true

	if arg0._focusTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._focusTimer)
	end

	local function var0()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._focusTimer)

		arg0._focusTimer = nil

		arg2()
	end

	arg0._focusTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, var1.CAST_CAM_ZOOM_IN_DURATION, var0, true)
end

function var3.PlayCutIn(arg0, arg1, arg2)
	var0.Battle.BattleCameraUtil.GetInstance():CutInPainting(arg1, arg2)
end

function var3.ResetFocus(arg0)
	return
end

function var3.CancelFocus(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._focusTimer)

	arg0._focusTimer = nil
end

function var3.GetWeaponList(arg0)
	return arg0._weaponList
end

function var3.AppendWeapon(arg0, arg1)
	arg0._weaponList[#arg0._weaponList + 1] = arg1

	if arg1:GetCurrentState() == arg1.STATE_READY then
		arg0._count = arg0._count + 1
	end

	arg0._total = arg0._total + 1

	arg0:DispatchTotalChange()

	arg0._current = arg0._max

	arg0:DispatchOverLoadChange()

	arg0._readyList[#arg0._readyList + 1] = arg1
end

function var3.AppendFreezeWeapon(arg0, arg1)
	arg0._weaponList[#arg0._weaponList + 1] = arg1
	arg0._total = arg0._total + 1

	arg0:DispatchTotalChange()

	if arg1:GetCurrentState() == arg1.STATE_READY then
		arg0._count = arg0._count + 1

		table.insert(arg0._readyList, arg1)
	elseif arg1:GetCDStartTimeStamp() then
		table.insert(arg0._chargingList, arg1)
	else
		table.insert(arg0._overHeatList, arg1)
	end

	arg0:resetCurrent()
	arg0:refreshCD()
	arg0:RefreshReloadingBar()
	arg0:DispatchOverLoadChange()
end

function var3.RemoveWeapon(arg0, arg1)
	local var0 = arg0.deleteElementFromArray(arg1, arg0._weaponList)

	arg0._total = arg0._total - 1

	if arg1:GetCurrentState() ~= arg1.STATE_OVER_HEAT then
		arg0._count = arg0._count - 1

		if arg0._count < 0 then
			arg0._count = 0
		end

		local var1 = arg0.deleteElementFromArray(arg1, arg0._readyList)

		arg0:DispatchOverLoadChange()
		arg0:DispatchTotalChange(var1)
	else
		if arg0.deleteElementFromArray(arg1, arg0._chargingList) == -1 then
			arg0.deleteElementFromArray(arg1, arg0._overHeatList)
		end

		arg0:DispatchOverLoadChange()
		arg0:DispatchTotalChange()
	end

	arg0:refreshCD()

	return var0
end

function var3.refreshCD(arg0)
	local var0 = #arg0._readyList
	local var1 = #arg0._chargingList

	if var0 ~= 0 then
		arg0._current = 1
		arg0._max = 1
	elseif var0 + var1 == 0 then
		arg0._current = 1
		arg0._max = 1
	else
		local var2 = arg0:GetNextTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime()

		if arg0._current >= arg0._GCD then
			arg0._max = var2
		else
			local var3 = math.max(arg0._max, arg0._GCD)

			arg0._max = math.max(var3 - arg0._current, var2)
		end

		arg0:resetCurrent()
	end
end

function var3.RefreshReloadingBar(arg0)
	if not arg0._reloadStartTime or #arg0._readyList ~= 0 or arg0._max == arg0._GCD then
		return
	end

	local var0 = arg0:GetNextTimeStamp()
	local var1 = arg0._current / arg0._max

	arg0._max = var0 - arg0._reloadStartTime
	arg0._current = var1 * arg0._max
end

function var3.resetCurrent(arg0)
	arg0._current = 0
	arg0._reloadStartTime = arg0._jammingStarTime or pg.TimeMgr.GetInstance():GetCombatTime()
end

function var3.SetMax(arg0, arg1)
	arg0._max = arg1
end

function var3.GetMax(arg0)
	return arg0._max
end

function var3.GetCurrent(arg0)
	return arg0._current
end

function var3.IsOverLoad(arg0)
	return arg0._current < arg0._max or arg0._count < 1
end

function var3.SetTotal(arg0, arg1)
	arg0._total = arg1
end

function var3.GetTotal(arg0)
	return arg0._total
end

function var3.SetCount(arg0, arg1)
	arg0._count = arg1
end

function var3.GetCount(arg0)
	return arg0._count
end

function var3.GetNextTimeStamp(arg0)
	local var0

	if #arg0._chargingList > 0 then
		var0 = arg0._chargingList[1]
		tiemStampB = var0:GetReloadFinishTimeStamp()

		for iter0, iter1 in ipairs(arg0._chargingList) do
			local var1 = iter1:GetReloadFinishTimeStamp()

			tiemStampB = var0:GetReloadFinishTimeStamp()

			if var1 < tiemStampB then
				var0 = iter1
				tiemStampB = var1
			end
		end
	end

	return tiemStampB, var0
end

function var3.GetCurrentWeapon(arg0)
	return arg0._readyList[1]
end

function var3.GetHeadWeapon(arg0)
	return arg0:GetCurrentWeapon() or arg0._chargingList[1] or arg0._overHeatList[1]
end

function var3.GetCurrentWeaponIconIndex(arg0)
	return 0
end

function var3.Plus(arg0, arg1)
	arg0._count = arg0._count + 1

	arg0:DispatchCountChange()
	arg0.deleteElementFromArray(arg1, arg0._chargingList)

	arg0._readyList[#arg0._readyList + 1] = arg1

	local var0 = var0.Event.New(var0.Battle.BattleEvent.WEAPON_COUNT_PLUS)

	arg0:DispatchEvent(var0)
	arg0:DispatchOverLoadChange()
end

function var3.Deduct(arg0, arg1)
	arg0:readyToOverheat(arg1)

	if #arg0._readyList ~= 0 then
		arg0._max = arg0._GCD

		arg0:resetCurrent()
	elseif #arg0._chargingList ~= 0 then
		local var0 = arg0:GetNextTimeStamp()

		arg0._max = math.max(arg0._GCD, var0 - pg.TimeMgr.GetInstance():GetCombatTime())

		arg0:resetCurrent()
	elseif arg1:GetType() == var0.Battle.BattleConst.EquipmentType.DISPOSABLE_TORPEDO then
		-- block empty
	else
		arg0._current = 0
	end

	arg0:DispatchOverLoadChange()
end

function var3.InitialDeduct(arg0, arg1)
	arg0:readyToOverheat(arg1)
	arg0:DispatchOverLoadChange()
end

function var3.Charge(arg0, arg1)
	arg0.deleteElementFromArray(arg1, arg0._overHeatList)

	arg0._chargingList[#arg0._chargingList + 1] = arg1

	if #arg0._readyList == 0 then
		local var0 = arg0:GetNextTimeStamp()

		arg0._max = math.max(arg0._GCD, var0 - pg.TimeMgr.GetInstance():GetCombatTime())

		arg0:resetCurrent()
	end
end

function var3.ReloadBoost(arg0, arg1, arg2)
	local var0, var1 = arg0:GetNextTimeStamp()

	arg1:ReloadBoost(arg2)

	local var2, var3 = arg0:GetNextTimeStamp()

	if var1 ~= arg1 and var3 ~= arg1 then
		-- block empty
	elseif var1 == arg1 and var3 == arg1 then
		arg0:RefreshReloadingBar()
	elseif var1 ~= var3 then
		arg0:RefreshReloadingBar()
	end
end

function var3.InstantCoolDown(arg0, arg1)
	arg0.deleteElementFromArray(arg1, arg0._overHeatList)

	if arg0._current >= arg0._GCD then
		arg0._current = arg0._max
		arg0._reloadStartTime = nil
	else
		arg0._max = arg0._GCD - arg0._current

		arg0:resetCurrent()
	end

	arg0:Plus(arg1)
end

function var3.DispatchBlink(arg0, arg1)
	local var0 = {
		value = arg1
	}
	local var1 = var0.Event.New(var0.Battle.BattleEvent.WEAPON_BUTTON_BLINK, var0)

	arg0:DispatchEvent(var1)
end

function var3.DispatchTotalChange(arg0, arg1)
	local var0 = var0.Event.New(var0.Battle.BattleEvent.WEAPON_TOTAL_CHANGE, {
		index = arg1
	})

	arg0:DispatchEvent(var0)
end

function var3.DispatchOverLoadChange(arg0)
	local var0 = var0.Event.New(var0.Battle.BattleEvent.OVER_LOAD_CHANGE)

	arg0:DispatchEvent(var0)
end

function var3.DispatchCountChange(arg0)
	local var0 = var0.Event.New(var0.Battle.BattleEvent.COUNT_CHANGE)

	arg0:DispatchEvent(var0)
end

function var3.DispatchInitSubIcon(arg0)
	local var0 = var0.Event.New(var0.Battle.BattleEvent.INIT_SUB_ICON)

	arg0:DispatchEvent(var0)
end

function var3.StartJamming(arg0)
	arg0._jammingStarTime = pg.TimeMgr.GetInstance():GetCombatTime()

	for iter0, iter1 in ipairs(arg0._chargingList) do
		iter1:StartJamming()
	end
end

function var3.JammingEliminate(arg0)
	for iter0, iter1 in ipairs(arg0._chargingList) do
		iter1:JammingEliminate()
	end

	if arg0._reloadStartTime then
		local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

		if #arg0._readyList ~= 0 then
			arg0._max = arg0._GCD
		else
			arg0._max = arg0:GetNextTimeStamp() - var0 + arg0._current
		end

		arg0._reloadStartTime = arg0._reloadStartTime + (var0 - arg0._jammingStarTime)
	end

	arg0._jammingStarTime = nil
end

function var3.Dispose(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._focusTimer)

	arg0._focusTimer = nil

	var0.EventDispatcher.DetachEventDispatcher(arg0)
end

function var3.readyToOverheat(arg0, arg1)
	arg0.deleteElementFromArray(arg1, arg0._readyList)

	arg0._overHeatList[#arg0._overHeatList + 1] = arg1
	arg0._count = arg0._count - 1

	if arg0._count < 0 then
		arg0._count = 0
	end

	arg0:DispatchCountChange()
end

function var3.deleteElementFromArray(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg1) do
		if arg0 == iter1 then
			var0 = iter0

			break
		end
	end

	if var0 == nil then
		return -1
	end

	for iter2 = var0, #arg1 do
		if arg1[iter2 + 1] ~= nil then
			arg1[iter2] = arg1[iter2 + 1]
		else
			arg1[iter2] = nil
		end
	end

	return var0
end
