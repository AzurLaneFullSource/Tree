ys = ys or {}

local var0_0 = ys

var0_0.Battle.BossSkillAlert = class("BossSkillAlert")
var0_0.Battle.BossSkillAlert.__name = "BossSkillAlert"

function var0_0.Battle.BossSkillAlert.Ctor(arg0_1, arg1_1)
	arg0_1._alertGO = arg1_1
	arg0_1._alertTF = arg1_1.transform
	arg0_1._alertTF.localPosition = Vector3.zero

	LeanTween.alpha(arg1_1, 0.3, 0.1):setDelay(0.1):setLoopPingPong()
end

function var0_0.Battle.BossSkillAlert.SetActive(arg0_2, arg1_2)
	arg0_2._alertGO:SetActive(arg1_2)
end

function var0_0.Battle.BossSkillAlert.GetActive(arg0_3)
	return arg0_3._alertGO.activeSelf
end

function var0_0.Battle.BossSkillAlert.SetScale(arg0_4, arg1_4)
	arg0_4._alertTF.localScale = arg1_4
end

function var0_0.Battle.BossSkillAlert.SetExistTime(arg0_5, arg1_5)
	arg0_5._timer = pg.TimeMgr.GetInstance():AddBattleTimer("BossSkillAlert", 0, arg1_5, function()
		if arg0_5._alertGO then
			arg0_5:Dispose()
		end
	end)
end

function var0_0.Battle.BossSkillAlert.Dispose(arg0_7)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_7._timer)
	LeanTween.cancel(arg0_7._alertGO)
	Object.Destroy(arg0_7._alertGO)

	arg0_7._alertGO = nil
end
