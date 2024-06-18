ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleGuideWave = class("BattleGuideWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleGuideWave.__name = "BattleGuideWave"

local var1_0 = var0_0.Battle.BattleGuideWave

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.SetWaveData(arg0_2, arg1_2)
	var1_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._guideType = arg0_2._param.type or 0
	arg0_2._guideStep = arg0_2._param.id
	arg0_2._event = arg0_2._param.event
end

function var1_0.DoWave(arg0_3)
	var1_0.super.DoWave(arg0_3)

	if not pg.NewGuideMgr.ENABLE_GUIDE then
		arg0_3:doPass()
	elseif arg0_3._guideType == 1 and pg.SeriesGuideMgr.GetInstance():isEnd() then
		arg0_3:doFail()
	else
		pg.NewGuideMgr.GetInstance():Play(arg0_3._guideStep, {
			arg0_3._event
		}, function()
			arg0_3:doPass()
		end)
	end
end
