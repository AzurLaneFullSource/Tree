ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleWeaponRangeSector = class("BattleWeaponRangeSector")
var0_0.Battle.BattleWeaponRangeSector.__name = "BattleWeaponRangeSector"

local var1_0 = var0_0.Battle.BattleWeaponRangeSector

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1

	setActive(arg0_1._tf, true)
	arg0_1:initSector()
end

function var1_0.ConfigHost(arg0_2, arg1_2, arg2_2)
	arg0_2._host = arg1_2
	arg0_2._weapon = arg2_2

	arg0_2:updateSector(arg0_2._weapon)
end

function var1_0.initSector(arg0_3)
	arg0_3._minRange = arg0_3._tf:Find("minSector")
	arg0_3._minSector = arg0_3._minRange:Find("sector"):GetComponent(typeof(Renderer)).material
	arg0_3._maxRange = arg0_3._tf:Find("maxSector")
	arg0_3._maxSector = arg0_3._maxRange:Find("sector"):GetComponent(typeof(Renderer)).material
end

function var1_0.updateSector(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetAttackAngle()
	local var1_4 = arg1_4._maxRangeSqr * 2
	local var2_4 = arg1_4._minRangeSqr * 2

	arg0_4._maxRange.localScale = Vector3(var1_4, 1, var1_4)
	arg0_4._minRange.localScale = Vector3(var2_4, 1, var2_4)

	arg0_4._maxSector:SetInt("_Angle", var0_4)
	arg0_4._minSector:SetInt("_Angle", var0_4)
end

function var1_0.Dispose(arg0_5)
	Destroy(arg0_5._tf)

	arg0_5._host = nil
	arg0_5._weapon = nil
end
