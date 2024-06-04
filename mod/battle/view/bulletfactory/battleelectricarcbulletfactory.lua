ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConst.AircraftUnitType
local var3 = var0.Battle.BattleConst.CharacterUnitType

var0.Battle.BattleElectricArcBulletFactory = singletonClass("BattleElectricArcBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleElectricArcBulletFactory.__name = "BattleElectricArcBulletFactory"

local var4 = var0.Battle.BattleElectricArcBulletFactory

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)
end

function var4.CreateBullet(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0:PlayFireFX(arg1, arg2, arg3, arg4, arg5, nil)

	local var0 = arg2:GetDirectHitUnit()

	if var0 == nil then
		return
	end

	local var1 = var0:GetUniqueID()
	local var2 = var0:GetUnitType()
	local var3

	if table.contains(var2, var2) then
		var3 = var4.GetSceneMediator():GetAircraft(var1)
	elseif table.contains(var3, var2) then
		var3 = var4.GetSceneMediator():GetCharacter(var1)
	end

	if var3 then
		var3:AddFX(arg2:GetTemplate().hit_fx)
		arg0:GetDataProxy():HandleDamage(arg2, var0)

		local var4 = arg2:GetWeapon():GetHost()

		if var4 then
			local var5 = arg2:GetWeapon():GetTemplateData().spawn_bound
			local var6 = arg0:GetSceneMediator():GetCharacter(var4:GetUniqueID())

			arg0:GetSceneMediator():AddArcEffect(arg2:GetTemplate().modle_ID, var6, var0, var5)
		end
	end
end
