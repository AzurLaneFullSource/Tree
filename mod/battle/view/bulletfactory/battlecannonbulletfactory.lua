ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.UnitType
local var2 = var0.Battle.BattleConst.AircraftUnitType
local var3 = var0.Battle.BattleConst.CharacterUnitType

var0.Battle.BattleCannonBulletFactory = singletonClass("BattleCannonBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleCannonBulletFactory.__name = "BattleCannonBulletFactory"

local var4 = var0.Battle.BattleCannonBulletFactory

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)
end

function var4.MakeBullet(arg0)
	return var0.Battle.BattleCannonBullet.New()
end

local var5 = Quaternion.Euler(-90, 0, 0)

function var4.onBulletHitFunc(arg0, arg1, arg2)
	local var0 = var4.GetDataProxy()
	local var1 = arg0:GetBulletData()
	local var2 = var1:GetTemplate()
	local var3

	if table.contains(var2, arg2) then
		var3 = var4.GetSceneMediator():GetAircraft(arg1)
	elseif table.contains(var3, arg2) then
		var3 = var4.GetSceneMediator():GetCharacter(arg1)
	end

	if not var3 then
		return
	end

	local var4 = var3:GetUnitData()
	local var5, var6 = var0:HandleDamage(var1, var4)
	local var7

	if var3:GetGO() then
		if var5 then
			local var8, var9 = var4.GetFXPool():GetFX(arg0:GetMissFXID())
			local var10 = var3:GetUnitData():GetBoxSize()
			local var11 = math.random(0, 1)

			if var11 == 0 then
				var11 = -1
			end

			local var12 = (math.random() - 0.5) * var10.x
			local var13 = Vector3(var12, 0, var10.z * var11):Add(var3:GetPosition())

			pg.EffectMgr.GetInstance():PlayBattleEffect(var8, var13:Add(var9), true)
			var0.Battle.PlayBattleSFX(var1:GetMissSFX())
		else
			var7 = var3:AddFX(arg0:GetFXID())

			var0.Battle.PlayBattleSFX(var1:GetHitSFX())

			local var14 = var4:GetDirection()
			local var15 = arg0:GetPosition() - var3:GetPosition()

			var15.x = var15.x * var14

			local var16 = var7.transform.localPosition
			local var17 = (var5 * var3:GetTf().localRotation).eulerAngles.x

			var15.y = math.cos(math.deg2Rad * var17) * var15.z
			var15.z = 0

			local var18 = var15 / var3:GetInitScale()

			var16:Add(var18)

			var7.transform.localPosition = var16
		end
	end

	if var7 and var4:GetIFF() == var0:GetFoeCode() then
		local var19 = var7.transform
		local var20 = var19.localRotation

		var19.localRotation = Vector3(var20.x, 180, var20.z)
	end

	if var1:GetPierceCount() <= 0 then
		var0:RemoveBulletUnit(var1:GetUniqueID())
	end
end

function var4.onBulletMissFunc(arg0)
	local var0 = arg0:GetBulletData()
	local var1 = var0:GetTemplate()
	local var2, var3 = var4.GetFXPool():GetFX(arg0:GetMissFXID())

	pg.EffectMgr.GetInstance():PlayBattleEffect(var2, var3:Add(arg0:GetPosition()), true)
	var0.Battle.PlayBattleSFX(var0:GetMissSFX())
end

function var4.MakeModel(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:GetDataProxy()
	local var1 = arg1:GetBulletData()

	if not arg0:GetBulletPool():InstBullet(arg1:GetModleID(), function(arg0)
		arg1:AddModel(arg0)
	end) then
		arg1:AddTempModel(arg0:GetTempGOPool():GetObject())
	end

	arg1:SetSpawn(arg2)
	arg1:SetFXFunc(arg0.onBulletHitFunc, arg0.onBulletMissFunc)
	arg0:GetSceneMediator():AddBullet(arg1)
end
