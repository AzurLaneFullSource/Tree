ys = ys or {}

local var0 = ys

var0.Battle.BattleTorpedoBulletFactory = singletonClass("BattleTorpedoBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleTorpedoBulletFactory.__name = "BattleTorpedoBulletFactory"

local var1 = var0.Battle.BattleTorpedoBulletFactory

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.MakeBullet(arg0)
	return var0.Battle.BattleTorpedoBullet.New()
end

function var1.onBulletHitFunc(arg0, arg1, arg2)
	local var0 = arg0:GetBulletData():GetTemplate().hit_type
	local var1 = var1.GetDataProxy()
	local var2 = arg0:GetBulletData()
	local var3 = var2:GetTemplate()

	var0.Battle.PlayBattleSFX(var2:GetHitSFX())

	local var4 = {
		_bullet = var2,
		equipIndex = var2:GetWeapon():GetEquipmentIndex(),
		bulletTag = var2:GetExtraTag()
	}

	var2:BuffTrigger(var0.Battle.BattleConst.BuffEffectType.ON_TORPEDO_BULLET_BANG, var4)

	local var5 = var2:GetDiveFilter()
	local var6

	local function var7(arg0)
		local var0 = var0.decay

		if var0 then
			var6:UpdateDistanceInfo()
		end

		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var1 = iter1.UID
				local var2 = 0

				if var0 then
					var2 = var6:GetDistance(var1) / (var0.range * 0.5) * var0
				end

				local var3 = var1:GetSceneMediator():GetCharacter(var1):GetUnitData()

				var1:HandleDamage(var2, var3, var2)
			end
		end
	end

	if var0.range then
		var6 = var1:SpawnColumnArea(var2:GetEffectField(), var2:GetIFF(), pg.Tool.FilterY(arg0:GetPosition():Clone()), var0.range, var0.time, var7)
	else
		var6 = var1:SpawnCubeArea(var2:GetEffectField(), var2:GetIFF(), pg.Tool.FilterY(arg0:GetPosition():Clone()), var0.width, var0.height, var0.time, var7)
	end

	var6:SetDiveFilter(var5)

	local var8, var9 = var1.GetFXPool():GetFX(arg0:GetFXID())
	local var10 = arg0:GetTf().localPosition

	pg.EffectMgr.GetInstance():PlayBattleEffect(var8, var9:Add(var10), true)

	if var2:GetPierceCount() <= 0 then
		var1:RemoveBulletUnit(var2:GetUniqueID())
	end
end

function var1.onBulletMissFunc(arg0)
	var1.onBulletHitFunc(arg0)
end

function var1.MakeModel(arg0, arg1, arg2)
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
