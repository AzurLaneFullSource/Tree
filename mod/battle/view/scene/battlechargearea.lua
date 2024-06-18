ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleChargeArea = class("BattleChargeArea")
var0_0.Battle.BattleChargeArea.__name = "BattleChargeArea"

function var0_0.Battle.BattleChargeArea.Ctor(arg0_1, arg1_1)
	arg1_1.gameObject:SetActive(false)

	arg0_1._areaTf = arg1_1.transform
	arg0_1._areaGO = arg1_1
end

function var0_0.Battle.BattleChargeArea.InitArea(arg0_2)
	local var0_2 = arg0_2._areaTf

	arg0_2._controller = var0_2:GetComponent("ChargeArea")

	local var1_2 = arg0_2._chargeWeapon:GetTemplateData().range
	local var2_2 = arg0_2._chargeWeapon:GetTemplateData().angle
	local var3_2 = var0_2.localScale

	var3_2.x = var1_2 / 5.5
	var3_2.y = var1_2 / 5.5
	var0_2.localScale = var3_2
	arg0_2._controller.maxAngle = var2_2
	arg0_2._controller.minAngle = arg0_2._chargeWeapon:GetMinAngle()
	var0_2:Find("UpperEdge").transform.localScale = Vector3(1, 1 / var3_2.y, 1)
	var0_2:Find("LowerEdge").transform.localScale = Vector3(1, 1 / var3_2.y, 1)
	arg0_2._controller.rate = 0.5
end

function var0_0.Battle.BattleChargeArea.Update(arg0_3, arg1_3)
	arg0_3._areaTf.position = arg1_3
end

function var0_0.Battle.BattleChargeArea.SetWeapon(arg0_4, arg1_4)
	arg0_4._chargeWeapon = arg1_4

	arg0_4:InitArea()
end

function var0_0.Battle.BattleChargeArea.SetActive(arg0_5, arg1_5)
	arg0_5._areaGO:SetActive(arg1_5)
end

function var0_0.Battle.BattleChargeArea.GetActive(arg0_6)
	return arg0_6._areaGO:GetActive()
end

function var0_0.Battle.BattleChargeArea.Reset(arg0_7)
	arg0_7._controller.rate = 1
end
