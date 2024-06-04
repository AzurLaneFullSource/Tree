ys = ys or {}

local var0 = ys

var0.Battle.BattleBombBulletFactory = singletonClass("BattleBombBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleBombBulletFactory.__name = "BattleBombBulletFactory"

local var1 = var0.Battle.BattleBombBulletFactory

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.OutRangeFunc(arg0)
	local var0 = arg0:GetTemplate()
	local var1 = var0.hit_type
	local var2 = var1.GetDataProxy()
	local var3 = var0.extra_param
	local var4 = arg0:GetDiveFilter()
	local var5 = {
		_bullet = arg0,
		equipIndex = arg0:GetWeapon():GetEquipmentIndex(),
		bulletTag = arg0:GetExtraTag()
	}

	arg0:BuffTrigger(var0.Battle.BattleConst.BuffEffectType.ON_BOMB_BULLET_BANG, var5)

	if var3.directDMG then
		local var6 = var3.buff_id
		local var7 = var3.buff_level or 1
		local var8 = var3.area_FX or var0.hit_fx

		local function var9(arg0)
			if arg0:CanDealDamage() then
				for iter0, iter1 in ipairs(arg0) do
					if iter1.Active then
						local var0 = iter1.UID
						local var1 = var1.GetSceneMediator():GetCharacter(var0):GetUnitData()
						local var2 = var0.Battle.BattleBuffUnit.New(var6, var7)

						var1:AddBuff(var2)
						var2:HandleDirectDamage(var1, var3.directDMG, arg0)
					end
				end

				arg0:DealDamage()
			end
		end

		local function var10(arg0)
			if arg0.Active then
				var1:GetSceneMediator():GetCharacter(arg0.UID):GetUnitData():RemoveBuff(var6)
			end
		end

		local function var11(arg0)
			for iter0, iter1 in ipairs(arg0) do
				if iter1.Active then
					local var0 = var1:GetSceneMediator():GetCharacter(iter1.UID):GetUnitData()

					if var0:IsAlive() then
						var0:RemoveBuff(var6)
					end
				end
			end

			var2:RemoveBulletUnit(arg0:GetUniqueID())
		end

		var2:SpawnLastingColumnArea(arg0:GetEffectField(), arg0:GetIFF(), arg0:GetExplodePostion(), var1.range, var1.time, var9, var10, false, var8, var11, true):SetDiveFilter(var4)
		arg0:HideBullet()
	else
		local var12

		local function var13(arg0)
			local var0 = var1.decay

			if var0 then
				var12:UpdateDistanceInfo()
			end

			for iter0, iter1 in ipairs(arg0) do
				if iter1.Active then
					local var1 = iter1.UID
					local var2 = 0

					if var0 then
						var2 = var12:GetDistance(var1) / (var1.range * 0.5) * var0
					end

					local var3 = var1.GetSceneMediator():GetCharacter(var1):GetUnitData()

					var2:HandleDamage(arg0, var3, var2)
				end
			end
		end

		var12 = var2:SpawnColumnArea(arg0:GetEffectField(), arg0:GetIFF(), arg0:GetExplodePostion(), var1.range, var1.time, var13)

		var12:SetDiveFilter(var4)

		if var3.friendlyFire then
			var2:SpawnColumnArea(arg0:GetEffectField(), var2.GetOppoSideCode(arg0:GetIFF()), arg0:GetExplodePostion(), var1.range, var1.time, var13):SetDiveFilter(var4)
		end

		var12:SetIndiscriminate(var3.indiscriminate)
		var2:RemoveBulletUnit(arg0:GetUniqueID())
	end
end

function var1.MakeBullet(arg0)
	return var0.Battle.BattleBombBullet.New()
end

function var1.onBulletHitFunc(arg0, arg1, arg2)
	local var0 = arg0:GetBulletData()
	local var1 = var0:GetTemplate()

	var0.Battle.PlayBattleSFX(var0:GetHitSFX())

	local var2, var3 = var1.GetFXPool():GetFX(arg0:GetFXID())
	local var4 = pg.Tool.FilterY(var0:GetPosition())

	pg.EffectMgr.GetInstance():PlayBattleEffect(var2, var4:Add(var3), true)
end

function var1.onBulletMissFunc()
	return
end

function var1.MakeModel(arg0, arg1, arg2)
	local var0 = arg1:GetBulletData()
	local var1 = var0:GetExplodePostion()
	local var2, var3, var4, var5 = arg0:GetDataProxy():GetTotalBounds()

	if var1.z > var2 + 3 then
		arg0:GetDataProxy():RemoveBulletUnit(var0:GetUniqueID())

		return
	end

	local var6 = var0:GetTemplate()

	if not arg0:GetBulletPool():InstBullet(arg1:GetModleID(), function(arg0)
		arg1:AddModel(arg0)
	end) then
		arg1:AddTempModel(arg0:GetTempGOPool():GetObject())
	end

	arg1:SetSpawn(arg2)

	if var0:GetIFF() ~= arg0:GetDataProxy():GetFriendlyCode() and var0:GetExist() and var6.alert_fx ~= "" then
		var1.CreateBulletAlert(var0)
	end

	var0:SetExist(true)
	arg1:SetFXFunc(arg0.onBulletHitFunc, arg0.onBulletMissFunc)
	arg0:GetSceneMediator():AddBullet(arg1)
end

function var1.CreateBulletAlert(arg0)
	local var0 = arg0:GetTemplate().hit_type.range
	local var1 = arg0:GetTemplate().alert_fx
	local var2 = var0.Battle.BattleFXPool.GetInstance():GetFX(var1)
	local var3 = var2.transform
	local var4 = 0
	local var5 = pg.effect_offset

	if var5[var1] and var5[var1].y_scale == true then
		var4 = var0
	end

	var3.localScale = Vector3(var0, var4, var0)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var2, arg0:GetExplodePostion())
end
