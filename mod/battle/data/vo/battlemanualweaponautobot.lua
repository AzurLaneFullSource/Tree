ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattleManualWeaponAutoBot = class("BattleManualWeaponAutoBot")
var0.Battle.BattleManualWeaponAutoBot.__name = "BattleManualWeaponAutoBot"

local var3 = var0.Battle.BattleManualWeaponAutoBot

function var3.Ctor(arg0, arg1)
	var0.EventListener.AttachEventListener(arg0)

	arg0._fleetVO = arg1

	arg0:init(arg1)
end

function var3.init(arg0)
	arg0._active = false
	arg0._isPlayFocus = true
	arg0._chargeVO = arg0._fleetVO:GetChargeWeaponVO()
	arg0._torpedoVO = arg0._fleetVO:GetTorpedoWeaponVO()
	arg0._AAVO = arg0._fleetVO:GetAirAssistVO()
	arg0._totalTime = 0
	arg0._lastActiveTimeStamp = nil
end

function var3.Update(arg0)
	if arg0._active then
		if not arg0._torpedoVO:IsOverLoad() then
			arg0._fleetVO:QuickCastTorpedo()

			return
		end

		if not arg0._AAVO:IsOverLoad() then
			arg0._fleetVO:UnleashAllInStrike()

			return
		end

		if not arg0._chargeVO:IsOverLoad() then
			arg0._fleetVO:QuickTagChrageWeapon(arg0._isPlayFocus)

			return
		end
	end
end

function var3.IsActive(arg0)
	return arg0._active
end

function var3.SetActive(arg0, arg1, arg2)
	if arg0._active ~= arg1 and arg1 == true then
		arg0._lastActiveTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
	elseif arg0._active ~= arg1 and arg1 == false and arg0._lastActiveTimeStamp ~= nil then
		local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

		arg0._totalTime = arg0._totalTime + (var0 - arg0._lastActiveTimeStamp)
		arg0._lastActiveTimeStamp = nil
	end

	arg0._fleetVO:AutoBotUpdated(arg1)

	arg0._active = arg1
	arg0._isPlayFocus = arg2
end

function var3.GetTotalActiveDuration(arg0)
	if arg0._lastActiveTimeStamp then
		local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

		arg0._totalTime = arg0._totalTime + (var0 - arg0._lastActiveTimeStamp)
		arg0._lastActiveTimeStamp = nil
	end

	return arg0._totalTime
end

function var3.Dispose(arg0)
	arg0._chargeVO = nil
	arg0._torpedoVO = nil
	arg0._AAVO = nil
	arg0._dataProxy = nil
	arg0._uiMediator = nil

	var0.EventListener.DetachEventListener(arg0)
end
