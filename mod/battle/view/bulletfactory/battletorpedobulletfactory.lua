ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleTorpedoBulletFactory = singletonClass("BattleTorpedoBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleTorpedoBulletFactory.__name = "BattleTorpedoBulletFactory"

local var1_0 = var0_0.Battle.BattleTorpedoBulletFactory

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.MakeBullet(arg0_2)
	return var0_0.Battle.BattleTorpedoBullet.New()
end

function var1_0.onBulletHitFunc(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:GetBulletData():GetTemplate().hit_type
	local var1_3 = var1_0.GetDataProxy()
	local var2_3 = arg0_3:GetBulletData()
	local var3_3 = var2_3:GetTemplate()

	var0_0.Battle.PlayBattleSFX(var2_3:GetHitSFX())

	local var4_3 = {
		_bullet = var2_3,
		equipIndex = var2_3:GetWeapon():GetEquipmentIndex(),
		bulletTag = var2_3:GetExtraTag()
	}

	var2_3:BuffTrigger(var0_0.Battle.BattleConst.BuffEffectType.ON_TORPEDO_BULLET_BANG, var4_3)

	local var5_3 = var2_3:GetDiveFilter()
	local var6_3

	local function var7_3(arg0_4)
		local var0_4 = var0_3.decay

		if var0_4 then
			var6_3:UpdateDistanceInfo()
		end

		for iter0_4, iter1_4 in ipairs(arg0_4) do
			if iter1_4.Active then
				local var1_4 = iter1_4.UID
				local var2_4 = 0

				if var0_4 then
					var2_4 = var6_3:GetDistance(var1_4) / (var0_3.range * 0.5) * var0_4
				end

				local var3_4 = var1_0:GetSceneMediator():GetCharacter(var1_4):GetUnitData()

				var1_3:HandleDamage(var2_3, var3_4, var2_4)
			end
		end
	end

	if var0_3.range then
		var6_3 = var1_3:SpawnColumnArea(var2_3:GetEffectField(), var2_3:GetIFF(), pg.Tool.FilterY(arg0_3:GetPosition():Clone()), var0_3.range, var0_3.time, var7_3)
	else
		var6_3 = var1_3:SpawnCubeArea(var2_3:GetEffectField(), var2_3:GetIFF(), pg.Tool.FilterY(arg0_3:GetPosition():Clone()), var0_3.width, var0_3.height, var0_3.time, var7_3)
	end

	var6_3:SetDiveFilter(var5_3)

	local var8_3, var9_3 = var1_0.GetFXPool():GetFX(arg0_3:GetFXID())
	local var10_3 = arg0_3:GetTf().localPosition

	pg.EffectMgr.GetInstance():PlayBattleEffect(var8_3, var9_3:Add(var10_3), true)

	if var2_3:GetPierceCount() <= 0 then
		var1_3:RemoveBulletUnit(var2_3:GetUniqueID())
	end
end

function var1_0.onBulletMissFunc(arg0_5)
	var1_0.onBulletHitFunc(arg0_5)
end

function var1_0.MakeModel(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetBulletData()
	local var1_6 = var0_6:GetTemplate()
	local var2_6 = arg0_6:GetDataProxy()

	if not arg0_6:GetBulletPool():InstBullet(arg1_6:GetModleID(), function(arg0_7)
		arg1_6:AddModel(arg0_7)
	end) then
		arg1_6:AddTempModel(arg0_6:GetTempGOPool():GetObject())
	end

	arg1_6:SetSpawn(arg2_6)
	arg1_6:SetFXFunc(arg0_6.onBulletHitFunc, arg0_6.onBulletMissFunc)
	arg0_6:GetSceneMediator():AddBullet(arg1_6)

	if var0_6:GetIFF() ~= var2_6:GetFriendlyCode() and var1_6.alert_fx ~= "" then
		arg1_6:MakeAlert(arg0_6:GetFXPool():GetFX(var1_6.alert_fx))
	end
end
