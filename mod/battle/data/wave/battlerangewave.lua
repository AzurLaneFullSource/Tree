ys = ys or {}

local var0 = ys

var0.Battle.BattleRangeWave = class("BattleRangeWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleRangeWave.__name = "BattleRangeWave"

local var1 = var0.Battle.BattleRangeWave

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.SetWaveData(arg0, arg1)
	var1.super.SetWaveData(arg0, arg1)

	arg0._pos = Vector3(arg0._param.rect[1], 0, arg0._param.rect[2])
	arg0._width = arg0._param.rect[3]
	arg0._height = arg0._param.rect[4]
	arg0._lifeTime = 99999
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)
	arg0._spawnFunc(arg0._pos, arg0._width, arg0._height, arg0._lifeTime, function(arg0, arg1)
		for iter0, iter1 in ipairs(arg0) do
			if iter1.IFF ~= arg1:GetCldData().IFF then
				arg1:SetActiveFlag(false)
				arg0:doPass()

				break
			end
		end
	end)
end
