ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConst.AircraftUnitType
local var3_0 = var0_0.Battle.BattleConst.CharacterUnitType

var0_0.Battle.BattleElectricArcBulletFactory = singletonClass("BattleElectricArcBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleElectricArcBulletFactory.__name = "BattleElectricArcBulletFactory"

local var4_0 = var0_0.Battle.BattleElectricArcBulletFactory

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)
end

function var4_0.CreateBullet(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2)
	arg0_2:PlayFireFX(arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, nil)

	local var0_2 = arg2_2:GetDirectHitUnit()

	if var0_2 == nil then
		return
	end

	local var1_2 = var0_2:GetUniqueID()
	local var2_2 = var0_2:GetUnitType()
	local var3_2

	if table.contains(var2_0, var2_2) then
		var3_2 = var4_0.GetSceneMediator():GetAircraft(var1_2)
	elseif table.contains(var3_0, var2_2) then
		var3_2 = var4_0.GetSceneMediator():GetCharacter(var1_2)
	end

	if var3_2 then
		var3_2:AddFX(arg2_2:GetTemplate().hit_fx)
		arg0_2:GetDataProxy():HandleDamage(arg2_2, var0_2)

		local var4_2 = arg2_2:GetWeapon():GetHost()

		if var4_2 then
			local var5_2 = arg2_2:GetWeapon():GetTemplateData().spawn_bound
			local var6_2 = arg0_2:GetSceneMediator():GetCharacter(var4_2:GetUniqueID())

			arg0_2:GetSceneMediator():AddArcEffect(arg2_2:GetTemplate().modle_ID, var6_2, var0_2, var5_2)
		end
	end
end
