ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleRangeWave = class("BattleRangeWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleRangeWave.__name = "BattleRangeWave"

local var1_0 = var0_0.Battle.BattleRangeWave

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.SetWaveData(arg0_2, arg1_2)
	var1_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._pos = Vector3(arg0_2._param.rect[1], 0, arg0_2._param.rect[2])
	arg0_2._width = arg0_2._param.rect[3]
	arg0_2._height = arg0_2._param.rect[4]
	arg0_2._lifeTime = 99999
end

function var1_0.DoWave(arg0_3)
	var1_0.super.DoWave(arg0_3)
	arg0_3._spawnFunc(arg0_3._pos, arg0_3._width, arg0_3._height, arg0_3._lifeTime, function(arg0_4, arg1_4)
		for iter0_4, iter1_4 in ipairs(arg0_4) do
			if iter1_4.IFF ~= arg1_4:GetCldData().IFF then
				arg1_4:SetActiveFlag(false)
				arg0_3:doPass()

				break
			end
		end
	end)
end
