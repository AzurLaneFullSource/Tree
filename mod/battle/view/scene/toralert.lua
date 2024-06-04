ys = ys or {}

local var0 = ys

var0.Battle.TorAlert = class("TorAlert")
var0.Battle.TorAlert.__name = "TorAlert"

function var0.Battle.TorAlert.Ctor(arg0, arg1)
	arg0._alertGO = arg1
	arg0._alertTF = arg1.transform
	arg0._alertTF.localScale = Vector3(20, 5, 1)

	LeanTween.scaleY(arg1, 0, 0.5):setDelay(0.1)
end

function var0.Battle.TorAlert.SetPosition(arg0, arg1, arg2)
	pg.EffectMgr.GetInstance():PlayBattleEffect(arg0._alertGO, arg1)

	arg0._alertTF.eulerAngles = Vector3(0, 180 - arg2, 0)
end

function var0.Battle.TorAlert.Dispose(arg0)
	LeanTween.cancel(arg0._alertGO)
	var0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0._alertGO)
end
