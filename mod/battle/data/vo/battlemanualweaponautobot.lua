ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleManualWeaponAutoBot = class("BattleManualWeaponAutoBot")
var0_0.Battle.BattleManualWeaponAutoBot.__name = "BattleManualWeaponAutoBot"

local var3_0 = var0_0.Battle.BattleManualWeaponAutoBot

function var3_0.Ctor(arg0_1, arg1_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1._fleetVO = arg1_1

	arg0_1:init(arg1_1)
end

function var3_0.init(arg0_2)
	arg0_2._active = false
	arg0_2._isPlayFocus = true
	arg0_2._chargeVO = arg0_2._fleetVO:GetChargeWeaponVO()
	arg0_2._torpedoVO = arg0_2._fleetVO:GetTorpedoWeaponVO()
	arg0_2._AAVO = arg0_2._fleetVO:GetAirAssistVO()
	arg0_2._totalTime = 0
	arg0_2._lastActiveTimeStamp = nil
end

function var3_0.Update(arg0_3)
	if arg0_3._active then
		if not arg0_3._torpedoVO:IsOverLoad() and arg0_3._fleetVO:QuickCastTorpedo() then
			return
		end

		if not arg0_3._AAVO:IsOverLoad() and arg0_3._fleetVO:UnleashAllInStrike() then
			return
		end

		if not arg0_3._chargeVO:IsOverLoad() and arg0_3._fleetVO:QuickTagChrageWeapon(arg0_3._isPlayFocus) then
			return
		end
	end
end

function var3_0.IsActive(arg0_4)
	return arg0_4._active
end

function var3_0.SetActive(arg0_5, arg1_5, arg2_5)
	if arg0_5._active ~= arg1_5 and arg1_5 == true then
		arg0_5._lastActiveTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
	elseif arg0_5._active ~= arg1_5 and arg1_5 == false and arg0_5._lastActiveTimeStamp ~= nil then
		local var0_5 = pg.TimeMgr.GetInstance():GetCombatTime()

		arg0_5._totalTime = arg0_5._totalTime + (var0_5 - arg0_5._lastActiveTimeStamp)
		arg0_5._lastActiveTimeStamp = nil
	end

	arg0_5._fleetVO:AutoBotUpdated(arg1_5)

	arg0_5._active = arg1_5
	arg0_5._isPlayFocus = arg2_5
end

function var3_0.GetTotalActiveDuration(arg0_6)
	if arg0_6._lastActiveTimeStamp then
		local var0_6 = pg.TimeMgr.GetInstance():GetCombatTime()

		arg0_6._totalTime = arg0_6._totalTime + (var0_6 - arg0_6._lastActiveTimeStamp)
		arg0_6._lastActiveTimeStamp = nil
	end

	return arg0_6._totalTime
end

function var3_0.Dispose(arg0_7)
	arg0_7._chargeVO = nil
	arg0_7._torpedoVO = nil
	arg0_7._AAVO = nil
	arg0_7._dataProxy = nil
	arg0_7._uiMediator = nil

	var0_0.EventListener.DetachEventListener(arg0_7)
end
