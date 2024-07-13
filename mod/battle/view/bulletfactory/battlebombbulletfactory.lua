ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBombBulletFactory = singletonClass("BattleBombBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleBombBulletFactory.__name = "BattleBombBulletFactory"

local var1_0 = var0_0.Battle.BattleBombBulletFactory

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.OutRangeFunc(arg0_2)
	local var0_2 = arg0_2:GetTemplate()
	local var1_2 = var0_2.hit_type
	local var2_2 = var1_0.GetDataProxy()
	local var3_2 = var0_2.extra_param
	local var4_2 = arg0_2:GetDiveFilter()
	local var5_2 = {
		_bullet = arg0_2,
		equipIndex = arg0_2:GetWeapon():GetEquipmentIndex(),
		bulletTag = arg0_2:GetExtraTag()
	}

	arg0_2:BuffTrigger(var0_0.Battle.BattleConst.BuffEffectType.ON_BOMB_BULLET_BANG, var5_2)

	if var3_2.directDMG then
		local var6_2 = var3_2.buff_id
		local var7_2 = var3_2.buff_level or 1
		local var8_2 = var3_2.area_FX or var0_2.hit_fx

		local function var9_2(arg0_3)
			if arg0_2:CanDealDamage() then
				for iter0_3, iter1_3 in ipairs(arg0_3) do
					if iter1_3.Active then
						local var0_3 = iter1_3.UID
						local var1_3 = var1_0.GetSceneMediator():GetCharacter(var0_3):GetUnitData()
						local var2_3 = var0_0.Battle.BattleBuffUnit.New(var6_2, var7_2)

						var1_3:AddBuff(var2_3)
						var2_2:HandleDirectDamage(var1_3, var3_2.directDMG, arg0_2)
					end
				end

				arg0_2:DealDamage()
			end
		end

		local function var10_2(arg0_4)
			if arg0_4.Active then
				var1_0:GetSceneMediator():GetCharacter(arg0_4.UID):GetUnitData():RemoveBuff(var6_2)
			end
		end

		local function var11_2(arg0_5)
			for iter0_5, iter1_5 in ipairs(arg0_5) do
				if iter1_5.Active then
					local var0_5 = var1_0:GetSceneMediator():GetCharacter(iter1_5.UID):GetUnitData()

					if var0_5:IsAlive() then
						var0_5:RemoveBuff(var6_2)
					end
				end
			end

			var2_2:RemoveBulletUnit(arg0_2:GetUniqueID())
		end

		var2_2:SpawnLastingColumnArea(arg0_2:GetEffectField(), arg0_2:GetIFF(), arg0_2:GetExplodePostion(), var1_2.range, var1_2.time, var9_2, var10_2, false, var8_2, var11_2, true):SetDiveFilter(var4_2)
		arg0_2:HideBullet()
	else
		local var12_2

		local function var13_2(arg0_6)
			local var0_6 = var1_2.decay

			if var0_6 then
				var12_2:UpdateDistanceInfo()
			end

			for iter0_6, iter1_6 in ipairs(arg0_6) do
				if iter1_6.Active then
					local var1_6 = iter1_6.UID
					local var2_6 = 0

					if var0_6 then
						var2_6 = var12_2:GetDistance(var1_6) / (var1_2.range * 0.5) * var0_6
					end

					local var3_6 = var1_0.GetSceneMediator():GetCharacter(var1_6):GetUnitData()

					var2_2:HandleDamage(arg0_2, var3_6, var2_6)
				end
			end
		end

		var12_2 = var2_2:SpawnColumnArea(arg0_2:GetEffectField(), arg0_2:GetIFF(), arg0_2:GetExplodePostion(), var1_2.range, var1_2.time, var13_2)

		var12_2:SetDiveFilter(var4_2)

		if var3_2.friendlyFire then
			var2_2:SpawnColumnArea(arg0_2:GetEffectField(), var2_2.GetOppoSideCode(arg0_2:GetIFF()), arg0_2:GetExplodePostion(), var1_2.range, var1_2.time, var13_2):SetDiveFilter(var4_2)
		end

		var12_2:SetIndiscriminate(var3_2.indiscriminate)
		var2_2:RemoveBulletUnit(arg0_2:GetUniqueID())
	end
end

function var1_0.MakeBullet(arg0_7)
	return var0_0.Battle.BattleBombBullet.New()
end

function var1_0.onBulletHitFunc(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8:GetBulletData()
	local var1_8 = var0_8:GetTemplate()

	var0_0.Battle.PlayBattleSFX(var0_8:GetHitSFX())

	local var2_8, var3_8 = var1_0.GetFXPool():GetFX(arg0_8:GetFXID())
	local var4_8 = pg.Tool.FilterY(var0_8:GetPosition())

	pg.EffectMgr.GetInstance():PlayBattleEffect(var2_8, var4_8:Add(var3_8), true)
end

function var1_0.onBulletMissFunc()
	return
end

function var1_0.MakeModel(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg1_10:GetBulletData()
	local var1_10 = var0_10:GetExplodePostion()
	local var2_10, var3_10, var4_10, var5_10 = arg0_10:GetDataProxy():GetTotalBounds()

	if var1_10.z > var2_10 + 3 then
		arg0_10:GetDataProxy():RemoveBulletUnit(var0_10:GetUniqueID())

		return
	end

	local var6_10 = var0_10:GetTemplate()

	if not arg0_10:GetBulletPool():InstBullet(arg1_10:GetModleID(), function(arg0_11)
		arg1_10:AddModel(arg0_11)
	end) then
		arg1_10:AddTempModel(arg0_10:GetTempGOPool():GetObject())
	end

	arg1_10:SetSpawn(arg2_10)

	if var0_10:GetIFF() ~= arg0_10:GetDataProxy():GetFriendlyCode() and var0_10:GetExist() and var6_10.alert_fx ~= "" then
		var1_0.CreateBulletAlert(var0_10)
	end

	var0_10:SetExist(true)
	arg1_10:SetFXFunc(arg0_10.onBulletHitFunc, arg0_10.onBulletMissFunc)
	arg0_10:GetSceneMediator():AddBullet(arg1_10)
end

function var1_0.CreateBulletAlert(arg0_12)
	local var0_12 = arg0_12:GetTemplate().hit_type.range
	local var1_12 = arg0_12:GetTemplate().alert_fx
	local var2_12 = var0_0.Battle.BattleFXPool.GetInstance():GetFX(var1_12)
	local var3_12 = var2_12.transform
	local var4_12 = 0
	local var5_12 = pg.effect_offset

	if var5_12[var1_12] and var5_12[var1_12].y_scale == true then
		var4_12 = var0_12
	end

	var3_12.localScale = Vector3(var0_12, var4_12, var0_12)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var2_12, arg0_12:GetExplodePostion())
end
