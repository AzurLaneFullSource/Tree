ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.AircraftUnitType
local var2_0 = var0_0.Battle.BattleConst.CharacterUnitType

var0_0.Battle.BattleDirectBulletFactory = singletonClass("BattleDirectBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleDirectBulletFactory.__name = "BattleDirectBulletFactory"

local var3_0 = var0_0.Battle.BattleDirectBulletFactory

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.CreateBullet(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2)
	arg0_2:PlayFireFX(arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, nil)

	local var0_2 = arg2_2:GetDirectHitUnit()

	if var0_2 == nil then
		return
	end

	local var1_2 = var0_2:GetUniqueID()
	local var2_2 = var0_2:GetUnitType()
	local var3_2

	if table.contains(var1_0, var2_2) then
		var3_2 = var3_0.GetSceneMediator():GetAircraft(var1_2)
	elseif table.contains(var2_0, var2_2) then
		var3_2 = var3_0.GetSceneMediator():GetCharacter(var1_2)
	end

	if var3_2 then
		var3_2:AddFX(arg2_2:GetTemplate().hit_fx)
		arg0_2:GetDataProxy():HandleDamage(arg2_2, var0_2)
	end
end
