ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleCameraWave = class("BattleCameraWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleCameraWave.__name = "BattleCameraWave"

local var2_0 = var0_0.Battle.BattleCameraWave

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.SetWaveData(arg0_2, arg1_2)
	var2_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._pause = arg0_2._param.pause
	arg0_2._cameraType = arg0_2._param.type or 0
	arg0_2._modelID = arg0_2._param.model or 900006
	arg0_2._duration = arg0_2._param.duration or 1
	arg0_2._zoomSize = arg0_2._param.zoomSize
	arg0_2._zoomBounce = arg0_2._param.zoomBounce
end

function var2_0.DoWave(arg0_3)
	var2_0.super.DoWave(arg0_3)

	local var0_3 = var0_0.Battle.BattleCameraUtil.GetInstance()

	if arg0_3._cameraType == 1 then
		local var1_3 = var0_0.Battle.BattleDataProxy.GetInstance():GetUnitList()
		local var2_3

		for iter0_3, iter1_3 in pairs(var1_3) do
			if iter1_3:GetTemplateID() == arg0_3._modelID then
				var2_3 = iter1_3

				break
			end
		end

		var0_3:FocusCharacter(var2_3, arg0_3._duration, 0, true, not arg0_3._zoomBounce)

		if arg0_3._zoomSize then
			local var3_3 = arg0_3._duration * 0.5

			if arg0_3._zoomBounce then
				var0_3:ZoomCamara(nil, var1_0.CAST_CAM_OVERLOOK_SIZE, var3_3)
				LeanTween.delayedCall(var3_3, System.Action(function()
					var0_3:ZoomCamara(var1_0.CAST_CAM_OVERLOOK_SIZE, arg0_3._zoomSize, var3_3)
				end))
			else
				var0_3:ZoomCamara(nil, arg0_3._zoomSize, arg0_3._duration, true)
			end
		end
	elseif arg0_3._cameraType == 0 then
		var0_3:FocusCharacter(nil, arg0_3._duration, 0)
		var0_3:ZoomCamara(nil, nil, arg0_3._duration)
	end

	var0_3:BulletTime(var1_0.SPEED_FACTOR_FOCUS_CHARACTER, nil)
	arg0_3:doPass()
end
