ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst

var0.Battle.BattleHammerHeadWeaponUnit = class("BattleHammerHeadWeaponUnit", var0.Battle.BattleWeaponUnit)
var0.Battle.BattleHammerHeadWeaponUnit.__name = "BattleHammerHeadWeaponUnit"

local var3 = var0.Battle.BattleHammerHeadWeaponUnit

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.DoAttack(arg0, arg1)
	if arg0._tmpData.bullet_ID[1] then
		local var0 = var1.GetBulletTmpDataFromID(arg0._tmpData.bullet_ID[1]).type

		if var0 == var2.BulletType.DIRECT or var0 == var2.BulletType.ANTI_AIR or var0 == var2.BulletType.ANTI_SEA then
			local var1 = arg0:Spawn(arg0._tmpData.bullet_ID[1], arg1)

			var1:SetDirectHitUnit(arg1)
			arg0:DispatchBulletEvent(var1)
		else
			var3.super.DoAttack(arg0, arg1)
			arg0._host:HandleDamageToDeath()

			return
		end
	end

	var0.Battle.PlayBattleSFX(arg0._tmpData.fire_sfx)
	arg0:TriggerBuffOnFire()
	arg0:CheckAndShake()
	arg0._host:HandleDamageToDeath()
end
