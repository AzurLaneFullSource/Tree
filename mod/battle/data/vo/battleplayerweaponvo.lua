ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattlePlayerWeaponVO = class("BattlePlayerWeaponVO")
var0_0.Battle.BattlePlayerWeaponVO.__name = "BattlePlayerWeaponVO"

local var3_0 = var0_0.Battle.BattlePlayerWeaponVO

function var3_0.Ctor(arg0_1, arg1_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._GCD = arg1_1

	arg0_1:Reset()
end

function var3_0.Reset(arg0_2)
	arg0_2._isOverLoad = false
	arg0_2._current = arg0_2._GCD
	arg0_2._max = arg0_2._GCD
	arg0_2._count = 0
	arg0_2._total = 0
	arg0_2._weaponList = {}
	arg0_2._overHeatList = {}
	arg0_2._readyList = {}
	arg0_2._chargingList = {}
end

function var3_0.Update(arg0_3, arg1_3)
	if arg0_3._current < arg0_3._max then
		local var0_3 = arg1_3 - arg0_3._reloadStartTime

		if var0_3 >= arg0_3._max then
			arg0_3._current = arg0_3._max
			arg0_3._reloadStartTime = nil

			for iter0_3, iter1_3 in ipairs(arg0_3._chargingList) do
				iter1_3:UpdateReload()
			end

			arg0_3:DispatchOverLoadChange()
		else
			arg0_3._current = var0_3
		end
	end
end

function var3_0.PlayFocus(arg0_4, arg1_4, arg2_4)
	var0_0.Battle.BattleCameraUtil.GetInstance():FocusCharacter(arg1_4, var1_0.CAST_CAM_ZOOM_IN_DURATION)
	var0_0.Battle.BattleCameraUtil.GetInstance():ZoomCamara(nil, var1_0.CAST_CAM_ZOOM_SIZE, var1_0.CAST_CAM_ZOOM_IN_DURATION, true)
	var0_0.Battle.BattleCameraUtil.GetInstance():BulletTime(var1_0.SPEED_FACTOR_FOCUS_CHARACTER, var1_0.FOCUS_MAP_RATE, arg1_4)

	arg0_4._focus = true

	if arg0_4._focusTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_4._focusTimer)
	end

	local function var0_4()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_4._focusTimer)

		arg0_4._focusTimer = nil

		arg2_4()
	end

	arg0_4._focusTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, var1_0.CAST_CAM_ZOOM_IN_DURATION, var0_4, true)
end

function var3_0.PlayCutIn(arg0_6, arg1_6, arg2_6)
	var0_0.Battle.BattleCameraUtil.GetInstance():CutInPainting(arg1_6, arg2_6)
end

function var3_0.ResetFocus(arg0_7)
	return
end

function var3_0.CancelFocus(arg0_8)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_8._focusTimer)

	arg0_8._focusTimer = nil
end

function var3_0.GetWeaponList(arg0_9)
	return arg0_9._weaponList
end

function var3_0.AppendWeapon(arg0_10, arg1_10)
	arg0_10._weaponList[#arg0_10._weaponList + 1] = arg1_10

	if arg1_10:GetCurrentState() == arg1_10.STATE_READY then
		arg0_10._count = arg0_10._count + 1
	end

	arg0_10._total = arg0_10._total + 1

	arg0_10:DispatchTotalChange()

	arg0_10._current = arg0_10._max

	arg0_10:DispatchOverLoadChange()

	arg0_10._readyList[#arg0_10._readyList + 1] = arg1_10
end

function var3_0.AppendFreezeWeapon(arg0_11, arg1_11)
	arg0_11._weaponList[#arg0_11._weaponList + 1] = arg1_11
	arg0_11._total = arg0_11._total + 1

	arg0_11:DispatchTotalChange()

	if arg1_11:GetCurrentState() == arg1_11.STATE_READY then
		arg0_11._count = arg0_11._count + 1

		table.insert(arg0_11._readyList, arg1_11)
	elseif arg1_11:GetCDStartTimeStamp() then
		table.insert(arg0_11._chargingList, arg1_11)
	else
		table.insert(arg0_11._overHeatList, arg1_11)
	end

	arg0_11:resetCurrent()
	arg0_11:refreshCD()
	arg0_11:RefreshReloadingBar()
	arg0_11:DispatchOverLoadChange()
end

function var3_0.RemoveWeapon(arg0_12, arg1_12)
	local var0_12 = arg0_12.deleteElementFromArray(arg1_12, arg0_12._weaponList)

	arg0_12._total = arg0_12._total - 1

	if arg1_12:GetCurrentState() ~= arg1_12.STATE_OVER_HEAT then
		arg0_12._count = arg0_12._count - 1

		if arg0_12._count < 0 then
			arg0_12._count = 0
		end

		local var1_12 = arg0_12.deleteElementFromArray(arg1_12, arg0_12._readyList)

		arg0_12:DispatchOverLoadChange()
		arg0_12:DispatchTotalChange(var1_12)
	else
		if arg0_12.deleteElementFromArray(arg1_12, arg0_12._chargingList) == -1 then
			arg0_12.deleteElementFromArray(arg1_12, arg0_12._overHeatList)
		end

		arg0_12:DispatchOverLoadChange()
		arg0_12:DispatchTotalChange()
	end

	arg0_12:refreshCD()

	return var0_12
end

function var3_0.refreshCD(arg0_13)
	local var0_13 = #arg0_13._readyList
	local var1_13 = #arg0_13._chargingList

	if var0_13 ~= 0 then
		arg0_13._current = 1
		arg0_13._max = 1
	elseif var0_13 + var1_13 == 0 then
		arg0_13._current = 1
		arg0_13._max = 1
	else
		local var2_13 = arg0_13:GetNextTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime()

		if arg0_13._current >= arg0_13._GCD then
			arg0_13._max = var2_13
		else
			local var3_13 = math.max(arg0_13._max, arg0_13._GCD)

			arg0_13._max = math.max(var3_13 - arg0_13._current, var2_13)
		end

		arg0_13:resetCurrent()
	end
end

function var3_0.RefreshReloadingBar(arg0_14)
	if not arg0_14._reloadStartTime or #arg0_14._readyList ~= 0 or arg0_14._max == arg0_14._GCD then
		return
	end

	local var0_14 = arg0_14:GetNextTimeStamp()
	local var1_14 = arg0_14._current / arg0_14._max

	arg0_14._max = var0_14 - arg0_14._reloadStartTime
	arg0_14._current = var1_14 * arg0_14._max
end

function var3_0.resetCurrent(arg0_15)
	arg0_15._current = 0
	arg0_15._reloadStartTime = arg0_15._jammingStarTime or pg.TimeMgr.GetInstance():GetCombatTime()
end

function var3_0.SetMax(arg0_16, arg1_16)
	arg0_16._max = arg1_16
end

function var3_0.GetMax(arg0_17)
	return arg0_17._max
end

function var3_0.GetCurrent(arg0_18)
	return arg0_18._current
end

function var3_0.IsOverLoad(arg0_19)
	return arg0_19._current < arg0_19._max or arg0_19._count < 1
end

function var3_0.SetTotal(arg0_20, arg1_20)
	arg0_20._total = arg1_20
end

function var3_0.GetTotal(arg0_21)
	return arg0_21._total
end

function var3_0.SetCount(arg0_22, arg1_22)
	arg0_22._count = arg1_22
end

function var3_0.GetCount(arg0_23)
	return arg0_23._count
end

function var3_0.GetNextTimeStamp(arg0_24)
	local var0_24

	if #arg0_24._chargingList > 0 then
		var0_24 = arg0_24._chargingList[1]
		tiemStampB = var0_24:GetReloadFinishTimeStamp()

		for iter0_24, iter1_24 in ipairs(arg0_24._chargingList) do
			local var1_24 = iter1_24:GetReloadFinishTimeStamp()

			tiemStampB = var0_24:GetReloadFinishTimeStamp()

			if var1_24 < tiemStampB then
				var0_24 = iter1_24
				tiemStampB = var1_24
			end
		end
	end

	return tiemStampB, var0_24
end

function var3_0.GetCurrentWeapon(arg0_25)
	return arg0_25._readyList[1]
end

function var3_0.GetHeadWeapon(arg0_26)
	return arg0_26:GetCurrentWeapon() or arg0_26._chargingList[1] or arg0_26._overHeatList[1]
end

function var3_0.GetCurrentWeaponIconIndex(arg0_27)
	return 0
end

function var3_0.Plus(arg0_28, arg1_28)
	local var0_28 = arg0_28._count

	arg0_28._count = arg0_28._count + 1

	arg0_28:DispatchCountChange()
	arg0_28.deleteElementFromArray(arg1_28, arg0_28._chargingList)

	arg0_28._readyList[#arg0_28._readyList + 1] = arg1_28

	local var1_28 = var0_0.Event.New(var0_0.Battle.BattleEvent.WEAPON_COUNT_PLUS)

	arg0_28:DispatchEvent(var1_28)
	arg0_28:DispatchOverLoadChange(var0_28)
end

function var3_0.Deduct(arg0_29, arg1_29)
	arg0_29:readyToOverheat(arg1_29)

	if #arg0_29._readyList ~= 0 then
		arg0_29._max = arg0_29._GCD

		arg0_29:resetCurrent()
	elseif #arg0_29._chargingList ~= 0 then
		local var0_29 = arg0_29:GetNextTimeStamp()

		arg0_29._max = math.max(arg0_29._GCD, var0_29 - pg.TimeMgr.GetInstance():GetCombatTime())

		arg0_29:resetCurrent()
	elseif arg1_29:GetType() == var0_0.Battle.BattleConst.EquipmentType.DISPOSABLE_TORPEDO then
		-- block empty
	else
		arg0_29._current = 0
	end

	arg0_29:DispatchOverLoadChange(nil, true)
end

function var3_0.InitialDeduct(arg0_30, arg1_30)
	arg0_30:readyToOverheat(arg1_30)
	arg0_30:DispatchOverLoadChange()
end

function var3_0.Charge(arg0_31, arg1_31)
	arg0_31.deleteElementFromArray(arg1_31, arg0_31._overHeatList)

	arg0_31._chargingList[#arg0_31._chargingList + 1] = arg1_31

	table.sort(arg0_31._chargingList, function(arg0_32, arg1_32)
		return arg0_32:GetReloadFinishTimeStamp() < arg1_32:GetReloadFinishTimeStamp()
	end)

	if #arg0_31._readyList == 0 then
		local var0_31 = arg0_31:GetNextTimeStamp()

		arg0_31._max = math.max(arg0_31._GCD, var0_31 - pg.TimeMgr.GetInstance():GetCombatTime())

		arg0_31:resetCurrent()
	end

	arg0_31:DispatchCountChange()
end

function var3_0.ReloadBoost(arg0_33, arg1_33, arg2_33)
	local var0_33, var1_33 = arg0_33:GetNextTimeStamp()

	arg1_33:ReloadBoost(arg2_33)

	local var2_33, var3_33 = arg0_33:GetNextTimeStamp()

	if var1_33 ~= arg1_33 and var3_33 ~= arg1_33 then
		-- block empty
	elseif var1_33 == arg1_33 and var3_33 == arg1_33 then
		arg0_33:RefreshReloadingBar()
	elseif var1_33 ~= var3_33 then
		arg0_33:RefreshReloadingBar()
	end
end

function var3_0.InstantCoolDown(arg0_34, arg1_34)
	arg0_34.deleteElementFromArray(arg1_34, arg0_34._overHeatList)

	if arg0_34._current >= arg0_34._GCD then
		arg0_34._current = arg0_34._max
		arg0_34._reloadStartTime = nil
	else
		arg0_34._max = arg0_34._GCD - arg0_34._current

		arg0_34:resetCurrent()
	end

	arg0_34:Plus(arg1_34)
end

function var3_0.DispatchBlink(arg0_35, arg1_35)
	local var0_35 = {
		value = arg1_35
	}
	local var1_35 = var0_0.Event.New(var0_0.Battle.BattleEvent.WEAPON_BUTTON_BLINK, var0_35)

	arg0_35:DispatchEvent(var1_35)
end

function var3_0.DispatchTotalChange(arg0_36, arg1_36)
	local var0_36 = var0_0.Event.New(var0_0.Battle.BattleEvent.WEAPON_TOTAL_CHANGE, {
		index = arg1_36
	})

	arg0_36:DispatchEvent(var0_36)
end

function var3_0.DispatchOverLoadChange(arg0_37, arg1_37, arg2_37)
	local var0_37 = var0_0.Event.New(var0_0.Battle.BattleEvent.OVER_LOAD_CHANGE, {
		preCast = arg1_37,
		postCast = arg2_37
	})

	arg0_37:DispatchEvent(var0_37)
end

function var3_0.DispatchCountChange(arg0_38)
	local var0_38 = var0_0.Event.New(var0_0.Battle.BattleEvent.COUNT_CHANGE)

	arg0_38:DispatchEvent(var0_38)
end

function var3_0.DispatchInitSubIcon(arg0_39)
	local var0_39 = var0_0.Event.New(var0_0.Battle.BattleEvent.INIT_SUB_ICON)

	arg0_39:DispatchEvent(var0_39)
end

function var3_0.StartJamming(arg0_40)
	arg0_40._jammingStarTime = pg.TimeMgr.GetInstance():GetCombatTime()

	for iter0_40, iter1_40 in ipairs(arg0_40._chargingList) do
		iter1_40:StartJamming()
	end
end

function var3_0.JammingEliminate(arg0_41)
	for iter0_41, iter1_41 in ipairs(arg0_41._chargingList) do
		iter1_41:JammingEliminate()
	end

	if arg0_41._reloadStartTime then
		local var0_41 = pg.TimeMgr.GetInstance():GetCombatTime()

		if #arg0_41._readyList ~= 0 then
			arg0_41._max = arg0_41._GCD
		else
			arg0_41._max = arg0_41:GetNextTimeStamp() - var0_41 + arg0_41._current
		end

		arg0_41._reloadStartTime = arg0_41._reloadStartTime + (var0_41 - arg0_41._jammingStarTime)
	end

	arg0_41._jammingStarTime = nil
end

function var3_0.Dispose(arg0_42)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_42._focusTimer)

	arg0_42._focusTimer = nil

	var0_0.EventDispatcher.DetachEventDispatcher(arg0_42)
end

function var3_0.readyToOverheat(arg0_43, arg1_43)
	arg0_43.deleteElementFromArray(arg1_43, arg0_43._readyList)

	arg0_43._overHeatList[#arg0_43._overHeatList + 1] = arg1_43
	arg0_43._count = arg0_43._count - 1

	if arg0_43._count < 0 then
		arg0_43._count = 0
	end

	arg0_43:DispatchCountChange()
end

function var3_0.deleteElementFromArray(arg0_44, arg1_44)
	local var0_44

	for iter0_44, iter1_44 in ipairs(arg1_44) do
		if arg0_44 == iter1_44 then
			var0_44 = iter0_44

			break
		end
	end

	if var0_44 == nil then
		return -1
	end

	for iter2_44 = var0_44, #arg1_44 do
		if arg1_44[iter2_44 + 1] ~= nil then
			arg1_44[iter2_44] = arg1_44[iter2_44 + 1]
		else
			arg1_44[iter2_44] = nil
		end
	end

	return var0_44
end
