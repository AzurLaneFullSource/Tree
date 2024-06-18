ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleAlert = class("BattleAlert")
var0_0.Battle.BattleAlert.__name = "BattleAlert"

function var0_0.Battle.BattleAlert.Ctor(arg0_1, arg1_1)
	arg0_1._alertGO = arg1_1
	arg0_1._alertTf = arg1_1.transform
	arg0_1._diskTf = arg0_1._alertGO.transform:Find("Disk")

	arg0_1:UpdateRate(0)
	arg0_1._alertGO:SetActive(true)
end

function var0_0.Battle.BattleAlert.SetPosition(arg0_2, arg1_2)
	arg0_2._alertTf.localPosition = Vector3(arg1_2.x, 0, arg1_2.z)
end

function var0_0.Battle.BattleAlert.Zoom(arg0_3, arg1_3)
	arg0_3._alertTf.localScale = Vector3(arg1_3 * 2, arg1_3 * 2, 1)
end

function var0_0.Battle.BattleAlert.UpdateRate(arg0_4, arg1_4)
	arg0_4._diskTf.localScale = Vector3(arg1_4, arg1_4, 1)
end

function var0_0.Battle.BattleAlert.Dispose(arg0_5)
	Object.Destroy(arg0_5._alertGO)
end
