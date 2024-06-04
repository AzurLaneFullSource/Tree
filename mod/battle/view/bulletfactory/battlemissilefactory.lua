ys = ys or {}

local var0 = ys
local var1 = singletonClass("BattleMissileFactory", var0.Battle.BattleBombBulletFactory)

var1.__name = "BattleMissileFactory"
var0.Battle.BattleMissileFactory = var1

function var1.MakeModel(arg0, arg1, arg2)
	local var0 = arg1:GetBulletData()
	local var1 = arg0:GetBulletPool():InstFX(arg1:GetModleID())

	if var1 then
		arg1:AddModel(var1)
	else
		arg1:AddTempModel(arg0:GetTempGOPool():GetObject())
	end

	arg1:SetSpawn(arg2)
	arg1:SetFXFunc(arg0.onBulletHitFunc, arg0.onBulletHitFunc)
	arg0:GetSceneMediator():AddBullet(arg1)
end

function var1.CreateBulletAlert(arg0)
	local var0 = arg0:GetTemplate()

	if arg0:GetIFF() == var1.GetDataProxy():GetFriendlyCode() then
		return
	end

	if #var0.alert_fx <= 0 then
		return
	end

	local var1 = var0.hit_type.range
	local var2 = var0.alert_fx
	local var3 = var0.Battle.BattleFXPool.GetInstance():GetFX(var2)
	local var4 = var3.transform
	local var5 = 0
	local var6 = pg.effect_offset

	if var6[var2] and var6[var2].y_scale == true then
		var5 = var1
	end

	var4.localScale = Vector3(var1, var5, var1)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var3, arg0:GetExplodePostion())
end
