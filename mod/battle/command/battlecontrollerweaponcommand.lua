ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent

var0.Battle.BattleControllerWeaponCommand = class("BattleControllerWeaponCommand", var0.MVC.Command)
var0.Battle.BattleControllerWeaponCommand.__name = "BattleControllerWeaponCommand"

local var2 = var0.Battle.BattleControllerWeaponCommand

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.Initialize(arg0)
	var2.super.Initialize(arg0)

	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)

	arg0:InitBattleEvent()

	arg0._focusBlockCast = false
end

function var2.ActiveBot(arg0, arg1, arg2)
	arg0._manualWeaponAutoBot:SetActive(arg1, arg2)
	arg0._joyStickAutoBot:SetActive(arg1)
end

function var2.TryAutoSub(arg0)
	local var0 = arg0:GetState():GetBattleType()

	if var0.Battle.BattleState.IsAutoSubActive(var0) then
		local var1 = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)._submarineVO

		if var1:GetUseable() and var1:GetCount() > 0 then
			arg0._dataProxy:SubmarineStrike(var0.Battle.BattleConfig.FRIENDLY_CODE)
			var1:Cast()
		end
	end
end

function var2.GetWeaponBot(arg0)
	return arg0._manualWeaponAutoBot
end

function var2.GetBotActiveDuration(arg0)
	return arg0._manualWeaponAutoBot:GetTotalActiveDuration()
end

function var2.GetStickBot(arg0)
	return arg0._joyStickAutoBot
end

function var2.InitBattleEvent(arg0)
	arg0._dataProxy:RegisterEventListener(arg0, var1.COMMON_DATA_INIT_FINISH, arg0.onUnitInitFinish)
	arg0._dataProxy:RegisterEventListener(arg0, var1.JAMMING, arg0.onJamming)
end

function var2.Update(arg0, arg1)
	if arg0._jammingFlag then
		return
	end

	if not arg0._focusBlockCast then
		arg0._manualWeaponAutoBot:Update()
	end

	for iter0, iter1 in pairs(arg0._fleetList) do
		iter1:UpdateManualWeaponVO(arg1)
	end
end

function var2.onJamming(arg0, arg1)
	arg0._jammingFlag = arg1.Data.jammingFlag
end

function var2.onUnitInitFinish(arg0, arg1)
	arg0._fleetList = arg0._dataProxy:GetFleetList()

	local var0 = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)

	var0:RegisterEventListener(arg0, var1.REFRESH_FLEET_FORMATION, arg0.onFleetFormationUpdate)
	var0:RegisterEventListener(arg0, var1.OVERRIDE_AUTO_BOT, arg0.onOverrideAutoBot)

	arg0._manualWeaponAutoBot = var0.Battle.BattleManualWeaponAutoBot.New(var0)
	arg0._joyStickAutoBot = var0.Battle.BattleJoyStickAutoBot.New(arg0._dataProxy, var0)

	var0.Battle.BattleCameraUtil.GetInstance():RegisterEventListener(arg0, var1.CAMERA_FOCUS, arg0.onCameraFocus)
end

function var2.onFleetFormationUpdate(arg0, arg1)
	arg0._joyStickAutoBot:FleetFormationUpdate()
end

function var2.onOverrideAutoBot(arg0, arg1)
	arg0._joyStickAutoBot:SwitchStrategy(var0.Battle.BattleJoyStickAutoBot.AUTO_PILOT)
end

function var2.onCameraFocus(arg0, arg1)
	local var0 = arg1.Data

	if var0.unit ~= nil then
		arg0._focusBlockCast = true
	else
		local var1 = var0.duration + var0.extraBulletTime

		LeanTween.delayedCall(var1, System.Action(function()
			arg0._focusBlockCast = false
		end))
	end
end

function var2.Dispose(arg0)
	local var0 = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)

	var0:UnregisterEventListener(arg0, var1.REFRESH_FLEET_FORMATION)
	var0:UnregisterEventListener(arg0, var1.OVERRIDE_AUTO_BOT)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.COMMON_DATA_INIT_FINISH)
	var0.Battle.BattleCameraUtil.GetInstance():UnregisterEventListener(arg0, var1.CAMERA_FOCUS)
	arg0._joyStickAutoBot:Dispose()

	arg0._joyStickAutoBot = nil

	arg0._manualWeaponAutoBot:Dispose()

	arg0._manualWeaponAutoBot = nil

	var2.super.Dispose(arg0)
end
