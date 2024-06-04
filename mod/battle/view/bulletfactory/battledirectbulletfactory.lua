ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.AircraftUnitType
local var2 = var0.Battle.BattleConst.CharacterUnitType

var0.Battle.BattleDirectBulletFactory = singletonClass("BattleDirectBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleDirectBulletFactory.__name = "BattleDirectBulletFactory"

local var3 = var0.Battle.BattleDirectBulletFactory

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.CreateBullet(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0:PlayFireFX(arg1, arg2, arg3, arg4, arg5, nil)

	local var0 = arg2:GetDirectHitUnit()

	if var0 == nil then
		return
	end

	local var1 = var0:GetUniqueID()
	local var2 = var0:GetUnitType()
	local var3

	if table.contains(var1, var2) then
		var3 = var3.GetSceneMediator():GetAircraft(var1)
	elseif table.contains(var2, var2) then
		var3 = var3.GetSceneMediator():GetCharacter(var1)
	end

	if var3 then
		var3:AddFX(arg2:GetTemplate().hit_fx)
		arg0:GetDataProxy():HandleDamage(arg2, var0)
	end
end
