ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.UnitType
local var2 = var0.Battle.BattleConst.AircraftUnitType
local var3 = var0.Battle.BattleConst.CharacterUnitType

var0.Battle.BattleAAMissileFactory = singletonClass("BattleAAMissileFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleAAMissileFactory.__name = "BattleAAMissileFactory"

local var4 = var0.Battle.BattleAAMissileFactory

function var4.MakeBullet(arg0)
	return var0.Battle.BattleTorpedoBullet.New()
end

function var4.onBulletHitFunc(arg0, arg1, arg2)
	local var0 = arg0:GetBulletData()
	local var1 = var0:getTrackingTarget()

	if var1 == -1 then
		var0.Battle.BattleCannonBulletFactory.onBulletHitFunc(arg0, arg1, arg2)

		return
	end

	local var2 = var0:GetTemplate()
	local var3 = var4.GetDataProxy()
	local var4

	if table.contains(var2, arg2) then
		var4 = var4.GetSceneMediator():GetAircraft(arg1):GetUnitData()
	elseif table.contains(var3, arg2) then
		var4 = var4.GetSceneMediator():GetCharacter(arg1):GetUnitData()
	end

	if not var4 or not var1 or var4:GetUniqueID() ~= var1:GetUniqueID() then
		return
	end

	var0.Battle.PlayBattleSFX(var0:GetHitSFX())

	local var5, var6 = var4.GetFXPool():GetFX(arg0:GetFXID())
	local var7 = arg0:GetTf().localPosition

	pg.EffectMgr.GetInstance():PlayBattleEffect(var5, var6:Add(var7), true)

	local var8, var9 = var3:HandleDamage(var0, var4)

	if var0:GetPierceCount() <= 0 then
		var0:CleanAimMark()
		var3:RemoveBulletUnit(var0:GetUniqueID())
	end
end

function var4.onBulletMissFunc(arg0)
	var4.onBulletHitFunc(arg0)
end

function var4.MakeModel(arg0, arg1, arg2)
	local var0 = arg1:GetBulletData()
	local var1 = var0:GetTemplate()
	local var2 = arg0:GetDataProxy()

	if not arg0:GetBulletPool():InstBullet(arg1:GetModleID(), function(arg0)
		arg1:AddModel(arg0)
	end) then
		arg1:AddTempModel(arg0:GetTempGOPool():GetObject())
	end

	arg1:SetSpawn(arg2)
	arg1:SetFXFunc(arg0.onBulletHitFunc, arg0.onBulletMissFunc)
	arg0:GetSceneMediator():AddBullet(arg1)

	if var0:GetIFF() ~= var2:GetFriendlyCode() and var1.alert_fx ~= "" then
		arg1:MakeAlert(arg0:GetFXPool():GetFX(var1.alert_fx))
	end
end
