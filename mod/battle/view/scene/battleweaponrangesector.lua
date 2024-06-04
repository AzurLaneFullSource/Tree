ys = ys or {}

local var0 = ys

var0.Battle.BattleWeaponRangeSector = class("BattleWeaponRangeSector")
var0.Battle.BattleWeaponRangeSector.__name = "BattleWeaponRangeSector"

local var1 = var0.Battle.BattleWeaponRangeSector

function var1.Ctor(arg0, arg1)
	arg0._tf = arg1

	setActive(arg0._tf, true)
	arg0:initSector()
end

function var1.ConfigHost(arg0, arg1, arg2)
	arg0._host = arg1
	arg0._weapon = arg2

	arg0:updateSector(arg0._weapon)
end

function var1.initSector(arg0)
	arg0._minRange = arg0._tf:Find("minSector")
	arg0._minSector = arg0._minRange:Find("sector"):GetComponent(typeof(Renderer)).material
	arg0._maxRange = arg0._tf:Find("maxSector")
	arg0._maxSector = arg0._maxRange:Find("sector"):GetComponent(typeof(Renderer)).material
end

function var1.updateSector(arg0, arg1)
	local var0 = arg1:GetAttackAngle()
	local var1 = arg1._maxRangeSqr * 2
	local var2 = arg1._minRangeSqr * 2

	arg0._maxRange.localScale = Vector3(var1, 1, var1)
	arg0._minRange.localScale = Vector3(var2, 1, var2)

	arg0._maxSector:SetInt("_Angle", var0)
	arg0._minSector:SetInt("_Angle", var0)
end

function var1.Dispose(arg0)
	Destroy(arg0._tf)

	arg0._host = nil
	arg0._weapon = nil
end
