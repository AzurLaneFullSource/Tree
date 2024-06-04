ys = ys or {}

local var0 = ys

var0.Battle.BattleGuideWave = class("BattleGuideWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleGuideWave.__name = "BattleGuideWave"

local var1 = var0.Battle.BattleGuideWave

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.SetWaveData(arg0, arg1)
	var1.super.SetWaveData(arg0, arg1)

	arg0._guideType = arg0._param.type or 0
	arg0._guideStep = arg0._param.id
	arg0._event = arg0._param.event
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)

	if not pg.NewGuideMgr.ENABLE_GUIDE then
		arg0:doPass()
	elseif arg0._guideType == 1 and pg.SeriesGuideMgr.GetInstance():isEnd() then
		arg0:doFail()
	else
		pg.NewGuideMgr.GetInstance():Play(arg0._guideStep, {
			arg0._event
		}, function()
			arg0:doPass()
		end)
	end
end
