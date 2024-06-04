ys = ys or {}

local var0 = ys

var0.Battle.BattleAlert = class("BattleAlert")
var0.Battle.BattleAlert.__name = "BattleAlert"

function var0.Battle.BattleAlert.Ctor(arg0, arg1)
	arg0._alertGO = arg1
	arg0._alertTf = arg1.transform
	arg0._diskTf = arg0._alertGO.transform:Find("Disk")

	arg0:UpdateRate(0)
	arg0._alertGO:SetActive(true)
end

function var0.Battle.BattleAlert.SetPosition(arg0, arg1)
	arg0._alertTf.localPosition = Vector3(arg1.x, 0, arg1.z)
end

function var0.Battle.BattleAlert.Zoom(arg0, arg1)
	arg0._alertTf.localScale = Vector3(arg1 * 2, arg1 * 2, 1)
end

function var0.Battle.BattleAlert.UpdateRate(arg0, arg1)
	arg0._diskTf.localScale = Vector3(arg1, arg1, 1)
end

function var0.Battle.BattleAlert.Dispose(arg0)
	Object.Destroy(arg0._alertGO)
end
