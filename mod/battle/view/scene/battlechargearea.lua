ys = ys or {}

local var0 = ys

var0.Battle.BattleChargeArea = class("BattleChargeArea")
var0.Battle.BattleChargeArea.__name = "BattleChargeArea"

function var0.Battle.BattleChargeArea.Ctor(arg0, arg1)
	arg1.gameObject:SetActive(false)

	arg0._areaTf = arg1.transform
	arg0._areaGO = arg1
end

function var0.Battle.BattleChargeArea.InitArea(arg0)
	local var0 = arg0._areaTf

	arg0._controller = var0:GetComponent("ChargeArea")

	local var1 = arg0._chargeWeapon:GetTemplateData().range
	local var2 = arg0._chargeWeapon:GetTemplateData().angle
	local var3 = var0.localScale

	var3.x = var1 / 5.5
	var3.y = var1 / 5.5
	var0.localScale = var3
	arg0._controller.maxAngle = var2
	arg0._controller.minAngle = arg0._chargeWeapon:GetMinAngle()
	var0:Find("UpperEdge").transform.localScale = Vector3(1, 1 / var3.y, 1)
	var0:Find("LowerEdge").transform.localScale = Vector3(1, 1 / var3.y, 1)
	arg0._controller.rate = 0.5
end

function var0.Battle.BattleChargeArea.Update(arg0, arg1)
	arg0._areaTf.position = arg1
end

function var0.Battle.BattleChargeArea.SetWeapon(arg0, arg1)
	arg0._chargeWeapon = arg1

	arg0:InitArea()
end

function var0.Battle.BattleChargeArea.SetActive(arg0, arg1)
	arg0._areaGO:SetActive(arg1)
end

function var0.Battle.BattleChargeArea.GetActive(arg0)
	return arg0._areaGO:GetActive()
end

function var0.Battle.BattleChargeArea.Reset(arg0)
	arg0._controller.rate = 1
end
