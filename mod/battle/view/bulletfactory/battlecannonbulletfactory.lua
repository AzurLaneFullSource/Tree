ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.UnitType
local var2_0 = var0_0.Battle.BattleConst.AircraftUnitType
local var3_0 = var0_0.Battle.BattleConst.CharacterUnitType

var0_0.Battle.BattleCannonBulletFactory = singletonClass("BattleCannonBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleCannonBulletFactory.__name = "BattleCannonBulletFactory"

local var4_0 = var0_0.Battle.BattleCannonBulletFactory

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)
end

function var4_0.MakeBullet(arg0_2)
	return var0_0.Battle.BattleCannonBullet.New()
end

local var5_0 = Quaternion.Euler(-90, 0, 0)

function var4_0.onBulletHitFunc(arg0_3, arg1_3, arg2_3)
	local var0_3 = var4_0.GetDataProxy()
	local var1_3 = arg0_3:GetBulletData()
	local var2_3 = var1_3:GetTemplate()
	local var3_3

	if table.contains(var2_0, arg2_3) then
		var3_3 = var4_0.GetSceneMediator():GetAircraft(arg1_3)
	elseif table.contains(var3_0, arg2_3) then
		var3_3 = var4_0.GetSceneMediator():GetCharacter(arg1_3)
	end

	if not var3_3 then
		return
	end

	local var4_3 = var3_3:GetUnitData()
	local var5_3, var6_3 = var0_3:HandleDamage(var1_3, var4_3)
	local var7_3

	if var3_3:GetGO() then
		if var5_3 then
			local var8_3, var9_3 = var4_0.GetFXPool():GetFX(arg0_3:GetMissFXID())
			local var10_3 = var3_3:GetUnitData():GetBoxSize()
			local var11_3 = math.random(0, 1)

			if var11_3 == 0 then
				var11_3 = -1
			end

			local var12_3 = (math.random() - 0.5) * var10_3.x
			local var13_3 = Vector3(var12_3, 0, var10_3.z * var11_3):Add(var3_3:GetPosition())

			pg.EffectMgr.GetInstance():PlayBattleEffect(var8_3, var13_3:Add(var9_3), true)
			var0_0.Battle.PlayBattleSFX(var1_3:GetMissSFX())
		else
			var7_3 = var3_3:AddFX(arg0_3:GetFXID())

			var0_0.Battle.PlayBattleSFX(var1_3:GetHitSFX())

			local var14_3 = var4_3:GetDirection()
			local var15_3 = arg0_3:GetPosition() - var3_3:GetPosition()

			var15_3.x = var15_3.x * var14_3

			local var16_3 = var7_3.transform.localPosition
			local var17_3 = (var5_0 * var3_3:GetTf().localRotation).eulerAngles.x

			var15_3.y = math.cos(math.deg2Rad * var17_3) * var15_3.z
			var15_3.z = 0

			local var18_3 = var15_3 / var3_3:GetInitScale()

			var16_3:Add(var18_3)

			var7_3.transform.localPosition = var16_3
		end
	end

	if var7_3 and var4_3:GetIFF() == var0_3:GetFoeCode() then
		local var19_3 = var7_3.transform
		local var20_3 = var19_3.localRotation

		var19_3.localRotation = Vector3(var20_3.x, 180, var20_3.z)
	end

	if var1_3:GetPierceCount() <= 0 then
		var0_3:RemoveBulletUnit(var1_3:GetUniqueID())
	end
end

function var4_0.onBulletMissFunc(arg0_4)
	local var0_4 = arg0_4:GetBulletData()
	local var1_4 = var0_4:GetTemplate()
	local var2_4, var3_4 = var4_0.GetFXPool():GetFX(arg0_4:GetMissFXID())

	pg.EffectMgr.GetInstance():PlayBattleEffect(var2_4, var3_4:Add(arg0_4:GetPosition()), true)
	var0_0.Battle.PlayBattleSFX(var0_4:GetMissSFX())
end

function var4_0.MakeModel(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5 = arg0_5:GetDataProxy()
	local var1_5 = arg1_5:GetBulletData()

	if not arg0_5:GetBulletPool():InstBullet(arg1_5:GetModleID(), function(arg0_6)
		arg1_5:AddModel(arg0_6)
	end) then
		arg1_5:AddTempModel(arg0_5:GetTempGOPool():GetObject())
	end

	arg1_5:SetSpawn(arg2_5)
	arg1_5:SetFXFunc(arg0_5.onBulletHitFunc, arg0_5.onBulletMissFunc)
	arg0_5:GetSceneMediator():AddBullet(arg1_5)
end
