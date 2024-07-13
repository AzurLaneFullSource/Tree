ys = ys or {}

local var0_0 = ys
local var1_0 = singletonClass("BattleMissileFactory", var0_0.Battle.BattleBombBulletFactory)

var1_0.__name = "BattleMissileFactory"
var0_0.Battle.BattleMissileFactory = var1_0

function var1_0.MakeModel(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1:GetBulletData()
	local var1_1 = arg0_1:GetBulletPool():InstFX(arg1_1:GetModleID())

	if var1_1 then
		arg1_1:AddModel(var1_1)
	else
		arg1_1:AddTempModel(arg0_1:GetTempGOPool():GetObject())
	end

	arg1_1:SetSpawn(arg2_1)
	arg1_1:SetFXFunc(arg0_1.onBulletHitFunc, arg0_1.onBulletHitFunc)
	arg0_1:GetSceneMediator():AddBullet(arg1_1)
end

function var1_0.CreateBulletAlert(arg0_2)
	local var0_2 = arg0_2:GetTemplate()

	if arg0_2:GetIFF() == var1_0.GetDataProxy():GetFriendlyCode() then
		return
	end

	if #var0_2.alert_fx <= 0 then
		return
	end

	local var1_2 = var0_2.hit_type.range
	local var2_2 = var0_2.alert_fx
	local var3_2 = var0_0.Battle.BattleFXPool.GetInstance():GetFX(var2_2)
	local var4_2 = var3_2.transform
	local var5_2 = 0
	local var6_2 = pg.effect_offset

	if var6_2[var2_2] and var6_2[var2_2].y_scale == true then
		var5_2 = var1_2
	end

	var4_2.localScale = Vector3(var1_2, var5_2, var1_2)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var3_2, arg0_2:GetExplodePostion())
end
