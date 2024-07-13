ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst

var0_0.Battle.BattleHammerHeadWeaponUnit = class("BattleHammerHeadWeaponUnit", var0_0.Battle.BattleWeaponUnit)
var0_0.Battle.BattleHammerHeadWeaponUnit.__name = "BattleHammerHeadWeaponUnit"

local var3_0 = var0_0.Battle.BattleHammerHeadWeaponUnit

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.DoAttack(arg0_2, arg1_2)
	if arg0_2._tmpData.bullet_ID[1] then
		local var0_2 = var1_0.GetBulletTmpDataFromID(arg0_2._tmpData.bullet_ID[1]).type

		if var0_2 == var2_0.BulletType.DIRECT or var0_2 == var2_0.BulletType.ANTI_AIR or var0_2 == var2_0.BulletType.ANTI_SEA then
			local var1_2 = arg0_2:Spawn(arg0_2._tmpData.bullet_ID[1], arg1_2)

			var1_2:SetDirectHitUnit(arg1_2)
			arg0_2:DispatchBulletEvent(var1_2)
		else
			var3_0.super.DoAttack(arg0_2, arg1_2)
			arg0_2._host:HandleDamageToDeath()

			return
		end
	end

	var0_0.Battle.PlayBattleSFX(arg0_2._tmpData.fire_sfx)
	arg0_2:TriggerBuffOnFire()
	arg0_2:CheckAndShake()
	arg0_2._host:HandleDamageToDeath()
end
