ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.UnitType
local var2_0 = var0_0.Battle.BattleConst.AircraftUnitType
local var3_0 = var0_0.Battle.BattleConst.CharacterUnitType

var0_0.Battle.BattleAAMissileFactory = singletonClass("BattleAAMissileFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleAAMissileFactory.__name = "BattleAAMissileFactory"

local var4_0 = var0_0.Battle.BattleAAMissileFactory

function var4_0.MakeBullet(arg0_1)
	return var0_0.Battle.BattleTorpedoBullet.New()
end

function var4_0.onBulletHitFunc(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:GetBulletData()
	local var1_2 = var0_2:getTrackingTarget()

	if var1_2 == -1 then
		var0_0.Battle.BattleCannonBulletFactory.onBulletHitFunc(arg0_2, arg1_2, arg2_2)

		return
	end

	local var2_2 = var0_2:GetTemplate()
	local var3_2 = var4_0.GetDataProxy()
	local var4_2

	if table.contains(var2_0, arg2_2) then
		var4_2 = var4_0.GetSceneMediator():GetAircraft(arg1_2):GetUnitData()
	elseif table.contains(var3_0, arg2_2) then
		var4_2 = var4_0.GetSceneMediator():GetCharacter(arg1_2):GetUnitData()
	end

	if not var4_2 or not var1_2 or var4_2:GetUniqueID() ~= var1_2:GetUniqueID() then
		return
	end

	var0_0.Battle.PlayBattleSFX(var0_2:GetHitSFX())

	local var5_2, var6_2 = var4_0.GetFXPool():GetFX(arg0_2:GetFXID())
	local var7_2 = arg0_2:GetTf().localPosition

	pg.EffectMgr.GetInstance():PlayBattleEffect(var5_2, var6_2:Add(var7_2), true)

	local var8_2, var9_2 = var3_2:HandleDamage(var0_2, var4_2)

	if var0_2:GetPierceCount() <= 0 then
		var0_2:CleanAimMark()
		var3_2:RemoveBulletUnit(var0_2:GetUniqueID())
	end
end

function var4_0.onBulletMissFunc(arg0_3)
	var4_0.onBulletHitFunc(arg0_3)
end

function var4_0.MakeModel(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:GetBulletData()
	local var1_4 = var0_4:GetTemplate()
	local var2_4 = arg0_4:GetDataProxy()

	if not arg0_4:GetBulletPool():InstBullet(arg1_4:GetModleID(), function(arg0_5)
		arg1_4:AddModel(arg0_5)
	end) then
		arg1_4:AddTempModel(arg0_4:GetTempGOPool():GetObject())
	end

	arg1_4:SetSpawn(arg2_4)
	arg1_4:SetFXFunc(arg0_4.onBulletHitFunc, arg0_4.onBulletMissFunc)
	arg0_4:GetSceneMediator():AddBullet(arg1_4)

	if var0_4:GetIFF() ~= var2_4:GetFriendlyCode() and var1_4.alert_fx ~= "" then
		arg1_4:MakeAlert(arg0_4:GetFXPool():GetFX(var1_4.alert_fx))
	end
end
