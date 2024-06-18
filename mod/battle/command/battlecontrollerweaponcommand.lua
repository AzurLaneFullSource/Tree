ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent

var0_0.Battle.BattleControllerWeaponCommand = class("BattleControllerWeaponCommand", var0_0.MVC.Command)
var0_0.Battle.BattleControllerWeaponCommand.__name = "BattleControllerWeaponCommand"

local var2_0 = var0_0.Battle.BattleControllerWeaponCommand

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.Initialize(arg0_2)
	var2_0.super.Initialize(arg0_2)

	arg0_2._dataProxy = arg0_2._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)

	arg0_2:InitBattleEvent()

	arg0_2._focusBlockCast = false
end

function var2_0.ActiveBot(arg0_3, arg1_3, arg2_3)
	arg0_3._manualWeaponAutoBot:SetActive(arg1_3, arg2_3)
	arg0_3._joyStickAutoBot:SetActive(arg1_3)
end

function var2_0.TryAutoSub(arg0_4)
	local var0_4 = arg0_4:GetState():GetBattleType()

	if var0_0.Battle.BattleState.IsAutoSubActive(var0_4) then
		local var1_4 = arg0_4._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)._submarineVO

		if var1_4:GetUseable() and var1_4:GetCount() > 0 then
			arg0_4._dataProxy:SubmarineStrike(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
			var1_4:Cast()
		end
	end
end

function var2_0.GetWeaponBot(arg0_5)
	return arg0_5._manualWeaponAutoBot
end

function var2_0.GetBotActiveDuration(arg0_6)
	return arg0_6._manualWeaponAutoBot:GetTotalActiveDuration()
end

function var2_0.GetStickBot(arg0_7)
	return arg0_7._joyStickAutoBot
end

function var2_0.InitBattleEvent(arg0_8)
	arg0_8._dataProxy:RegisterEventListener(arg0_8, var1_0.COMMON_DATA_INIT_FINISH, arg0_8.onUnitInitFinish)
	arg0_8._dataProxy:RegisterEventListener(arg0_8, var1_0.JAMMING, arg0_8.onJamming)
end

function var2_0.Update(arg0_9, arg1_9)
	if arg0_9._jammingFlag then
		return
	end

	if not arg0_9._focusBlockCast then
		arg0_9._manualWeaponAutoBot:Update()
	end

	for iter0_9, iter1_9 in pairs(arg0_9._fleetList) do
		iter1_9:UpdateManualWeaponVO(arg1_9)
	end
end

function var2_0.onJamming(arg0_10, arg1_10)
	arg0_10._jammingFlag = arg1_10.Data.jammingFlag
end

function var2_0.onUnitInitFinish(arg0_11, arg1_11)
	arg0_11._fleetList = arg0_11._dataProxy:GetFleetList()

	local var0_11 = arg0_11._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)

	var0_11:RegisterEventListener(arg0_11, var1_0.REFRESH_FLEET_FORMATION, arg0_11.onFleetFormationUpdate)
	var0_11:RegisterEventListener(arg0_11, var1_0.OVERRIDE_AUTO_BOT, arg0_11.onOverrideAutoBot)

	arg0_11._manualWeaponAutoBot = var0_0.Battle.BattleManualWeaponAutoBot.New(var0_11)
	arg0_11._joyStickAutoBot = var0_0.Battle.BattleJoyStickAutoBot.New(arg0_11._dataProxy, var0_11)

	var0_0.Battle.BattleCameraUtil.GetInstance():RegisterEventListener(arg0_11, var1_0.CAMERA_FOCUS, arg0_11.onCameraFocus)
end

function var2_0.onFleetFormationUpdate(arg0_12, arg1_12)
	arg0_12._joyStickAutoBot:FleetFormationUpdate()
end

function var2_0.onOverrideAutoBot(arg0_13, arg1_13)
	arg0_13._joyStickAutoBot:SwitchStrategy(var0_0.Battle.BattleJoyStickAutoBot.AUTO_PILOT)
end

function var2_0.onCameraFocus(arg0_14, arg1_14)
	local var0_14 = arg1_14.Data

	if var0_14.unit ~= nil then
		arg0_14._focusBlockCast = true
	else
		local var1_14 = var0_14.duration + var0_14.extraBulletTime

		LeanTween.delayedCall(var1_14, System.Action(function()
			arg0_14._focusBlockCast = false
		end))
	end
end

function var2_0.Dispose(arg0_16)
	local var0_16 = arg0_16._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)

	var0_16:UnregisterEventListener(arg0_16, var1_0.REFRESH_FLEET_FORMATION)
	var0_16:UnregisterEventListener(arg0_16, var1_0.OVERRIDE_AUTO_BOT)
	arg0_16._dataProxy:UnregisterEventListener(arg0_16, var1_0.COMMON_DATA_INIT_FINISH)
	var0_0.Battle.BattleCameraUtil.GetInstance():UnregisterEventListener(arg0_16, var1_0.CAMERA_FOCUS)
	arg0_16._joyStickAutoBot:Dispose()

	arg0_16._joyStickAutoBot = nil

	arg0_16._manualWeaponAutoBot:Dispose()

	arg0_16._manualWeaponAutoBot = nil

	var2_0.super.Dispose(arg0_16)
end
