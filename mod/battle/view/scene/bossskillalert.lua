ys = ys or {}

local var0 = ys

var0.Battle.BossSkillAlert = class("BossSkillAlert")
var0.Battle.BossSkillAlert.__name = "BossSkillAlert"

function var0.Battle.BossSkillAlert.Ctor(arg0, arg1)
	arg0._alertGO = arg1
	arg0._alertTF = arg1.transform
	arg0._alertTF.localPosition = Vector3.zero

	LeanTween.alpha(arg1, 0.3, 0.1):setDelay(0.1):setLoopPingPong()
end

function var0.Battle.BossSkillAlert.SetActive(arg0, arg1)
	arg0._alertGO:SetActive(arg1)
end

function var0.Battle.BossSkillAlert.GetActive(arg0)
	return arg0._alertGO.activeSelf
end

function var0.Battle.BossSkillAlert.SetScale(arg0, arg1)
	arg0._alertTF.localScale = arg1
end

function var0.Battle.BossSkillAlert.SetExistTime(arg0, arg1)
	arg0._timer = pg.TimeMgr.GetInstance():AddBattleTimer("BossSkillAlert", 0, arg1, function()
		if arg0._alertGO then
			arg0:Dispose()
		end
	end)
end

function var0.Battle.BossSkillAlert.Dispose(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._timer)
	LeanTween.cancel(arg0._alertGO)
	Object.Destroy(arg0._alertGO)

	arg0._alertGO = nil
end
