ys = ys or {}

local var0 = ys

var0.Battle.BattleEffectBulletFactory = singletonClass("BattleEffectBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleEffectBulletFactory.__name = "BattleEffectBulletFactory"

local var1 = var0.Battle.BattleEffectBulletFactory

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.MakeBullet(arg0)
	return var0.Battle.BattleTorpedoBullet.New()
end

function var1.onBulletHitFunc(arg0, arg1, arg2)
	local var0 = var1.GetDataProxy()
	local var1 = arg0:GetBulletData()
	local var2 = var1:GetTemplate()

	var0.Battle.PlayBattleSFX(var1:GetHitSFX())

	if not var1:IsFlare() then
		var1:spawnArea()
	end

	local var3, var4 = var1.GetFXPool():GetFX(arg0:GetFXID())
	local var5 = arg0:GetTf().localPosition

	pg.EffectMgr.GetInstance():PlayBattleEffect(var3, var4:Add(var5), true)

	if var1:GetPierceCount() <= 0 then
		var0:RemoveBulletUnit(var1:GetUniqueID())
	end
end

function var1.onBulletMissFunc(arg0)
	var1.onBulletHitFunc(arg0)
end

function var1.MakeModel(arg0, arg1, arg2)
	local var0 = arg1:GetBulletData():GetTemplate()
	local var1 = arg0:GetDataProxy()

	if not arg0:GetBulletPool():InstBullet(arg1:GetModleID(), function(arg0)
		arg1:AddModel(arg0)
	end) then
		arg1:AddTempModel(arg0:GetTempGOPool():GetObject())
	end

	arg1:SetSpawn(arg2)
	arg1:SetFXFunc(arg0.onBulletHitFunc, arg0.onBulletMissFunc)
	arg0:GetSceneMediator():AddBullet(arg1)
end
