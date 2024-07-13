ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleEffectBulletFactory = singletonClass("BattleEffectBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleEffectBulletFactory.__name = "BattleEffectBulletFactory"

local var1_0 = var0_0.Battle.BattleEffectBulletFactory

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.MakeBullet(arg0_2)
	return var0_0.Battle.BattleTorpedoBullet.New()
end

function var1_0.onBulletHitFunc(arg0_3, arg1_3, arg2_3)
	local var0_3 = var1_0.GetDataProxy()
	local var1_3 = arg0_3:GetBulletData()
	local var2_3 = var1_3:GetTemplate()

	var0_0.Battle.PlayBattleSFX(var1_3:GetHitSFX())

	if not var1_3:IsFlare() then
		var1_3:spawnArea()
	end

	local var3_3, var4_3 = var1_0.GetFXPool():GetFX(arg0_3:GetFXID())
	local var5_3 = arg0_3:GetTf().localPosition

	pg.EffectMgr.GetInstance():PlayBattleEffect(var3_3, var4_3:Add(var5_3), true)

	if var1_3:GetPierceCount() <= 0 then
		var0_3:RemoveBulletUnit(var1_3:GetUniqueID())
	end
end

function var1_0.onBulletMissFunc(arg0_4)
	var1_0.onBulletHitFunc(arg0_4)
end

function var1_0.MakeModel(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:GetBulletData():GetTemplate()
	local var1_5 = arg0_5:GetDataProxy()

	if not arg0_5:GetBulletPool():InstBullet(arg1_5:GetModleID(), function(arg0_6)
		arg1_5:AddModel(arg0_6)
	end) then
		arg1_5:AddTempModel(arg0_5:GetTempGOPool():GetObject())
	end

	arg1_5:SetSpawn(arg2_5)
	arg1_5:SetFXFunc(arg0_5.onBulletHitFunc, arg0_5.onBulletMissFunc)
	arg0_5:GetSceneMediator():AddBullet(arg1_5)
end
