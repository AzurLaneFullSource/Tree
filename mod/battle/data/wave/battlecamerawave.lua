ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.BattleCameraWave = class("BattleCameraWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleCameraWave.__name = "BattleCameraWave"

local var2 = var0.Battle.BattleCameraWave

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.SetWaveData(arg0, arg1)
	var2.super.SetWaveData(arg0, arg1)

	arg0._pause = arg0._param.pause
	arg0._cameraType = arg0._param.type or 0
	arg0._modelID = arg0._param.model or 900006
	arg0._duration = arg0._param.duration or 1
	arg0._zoomSize = arg0._param.zoomSize
	arg0._zoomBounce = arg0._param.zoomBounce
end

function var2.DoWave(arg0)
	var2.super.DoWave(arg0)

	local var0 = var0.Battle.BattleCameraUtil.GetInstance()

	if arg0._cameraType == 1 then
		local var1 = var0.Battle.BattleDataProxy.GetInstance():GetUnitList()
		local var2

		for iter0, iter1 in pairs(var1) do
			if iter1:GetTemplateID() == arg0._modelID then
				var2 = iter1

				break
			end
		end

		var0:FocusCharacter(var2, arg0._duration, 0, true, not arg0._zoomBounce)

		if arg0._zoomSize then
			local var3 = arg0._duration * 0.5

			if arg0._zoomBounce then
				var0:ZoomCamara(nil, var1.CAST_CAM_OVERLOOK_SIZE, var3)
				LeanTween.delayedCall(var3, System.Action(function()
					var0:ZoomCamara(var1.CAST_CAM_OVERLOOK_SIZE, arg0._zoomSize, var3)
				end))
			else
				var0:ZoomCamara(nil, arg0._zoomSize, arg0._duration, true)
			end
		end
	elseif arg0._cameraType == 0 then
		var0:FocusCharacter(nil, arg0._duration, 0)
		var0:ZoomCamara(nil, nil, arg0._duration)
	end

	var0:BulletTime(var1.SPEED_FACTOR_FOCUS_CHARACTER, nil)
	arg0:doPass()
end
