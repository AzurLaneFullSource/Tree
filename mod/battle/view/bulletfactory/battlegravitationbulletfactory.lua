ys = ys or {}

local var0 = ys

var0.Battle.BattleGravitationBulletFactory = singletonClass("BattleGravitationBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleGravitationBulletFactory.__name = "BattleGravitationBulletFactory"

local var1 = var0.Battle.BattleGravitationBulletFactory

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.MakeBullet(arg0)
	return var0.Battle.BattleTorpedoBullet.New()
end

function var1.onBulletHitFunc(arg0, arg1, arg2)
	local var0 = arg0:GetBulletData()

	if var0:GetPierceCount() <= 0 then
		return
	end

	local var1 = var0:GetTemplate().hit_type
	local var2 = var1.GetDataProxy()
	local var3 = arg0:GetBulletData()
	local var4 = var3:GetTemplate()

	var0.Battle.PlayBattleSFX(var3:GetHitSFX())

	local var5 = var3:GetDiveFilter()
	local var6 = var3:GetPosition():Clone()
	local var7 = var3:GetTemplate().extra_param
	local var8 = var7.buff_id
	local var9 = var7.buff_level or 1

	local function var10(arg0)
		if var3:CanDealDamage() then
			for iter0, iter1 in ipairs(arg0) do
				if iter1.Active then
					local var0 = var1:GetSceneMediator():GetCharacter(iter1.UID):GetUnitData()
					local var1 = var0.Battle.BattleBuffUnit.New(var8, var9)

					var0:AddBuff(var1)

					if not var7.noIntervalDMG then
						var2:HandleDamage(var3, var0)
					end

					local var2 = var7.force or 0.1
					local var3 = pg.Tool.FilterY(var6 - var0:GetPosition())

					if var2 > var3.magnitude then
						var0:SetUncontrollableSpeed(var3, 0.001, 1e-06)
					else
						var0:SetUncontrollableSpeed(var3, var2, 1e-07)
					end
				end
			end

			var3:DealDamage()
		end
	end

	local function var11(arg0)
		if arg0.Active then
			local var0 = var1:GetSceneMediator():GetCharacter(arg0.UID):GetUnitData()

			var0:ClearUncontrollableSpeed()
			var0:RemoveBuff(var8)
		end
	end

	local function var12(arg0)
		local var0 = var7.exploDMG
		local var1 = var7.knockBack

		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var2 = var1:GetSceneMediator():GetCharacter(iter1.UID):GetUnitData()
				local var3 = false
				local var4 = var2:GetCurrentOxyState()

				for iter2, iter3 in ipairs(var5) do
					if var4 == iter3 then
						var3 = true
					end
				end

				if not var3 then
					var2:HandleDirectDamage(var2, var0, var3)

					if var2:IsAlive() then
						local var5 = pg.Tool.FilterY(var2:GetPosition() - var6)

						if var1 ~= false then
							var2:SetUncontrollableSpeed(var5, 1, 0.2, 6)
						end

						var2:RemoveBuff(var8)
					end
				end
			end
		end

		local var6, var7 = var1.GetFXPool():GetFX(arg0:GetMissFXID())

		pg.EffectMgr.GetInstance():PlayBattleEffect(var6, var7:Add(var6), true)
		var2:RemoveBulletUnit(var3:GetUniqueID())
	end

	var2:SpawnLastingColumnArea(var3:GetEffectField(), var3:GetIFF(), pg.Tool.FilterY(var6), var1.range, var1.time, var10, var11, false, arg0:GetFXID(), var12, true):SetDiveFilter(var5)
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
