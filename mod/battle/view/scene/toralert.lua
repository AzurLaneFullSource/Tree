ys = ys or {}

local var0_0 = ys

var0_0.Battle.TorAlert = class("TorAlert")
var0_0.Battle.TorAlert.__name = "TorAlert"

function var0_0.Battle.TorAlert.Ctor(arg0_1, arg1_1)
	arg0_1._alertGO = arg1_1
	arg0_1._alertTF = arg1_1.transform
	arg0_1._alertTF.localScale = Vector3(20, 5, 1)

	LeanTween.scaleY(arg1_1, 0, 0.5):setDelay(0.1)
end

function var0_0.Battle.TorAlert.SetPosition(arg0_2, arg1_2, arg2_2)
	pg.EffectMgr.GetInstance():PlayBattleEffect(arg0_2._alertGO, arg1_2)

	arg0_2._alertTF.eulerAngles = Vector3(0, 180 - arg2_2, 0)
end

function var0_0.Battle.TorAlert.Dispose(arg0_3)
	LeanTween.cancel(arg0_3._alertGO)
	var0_0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0_3._alertGO)
end
