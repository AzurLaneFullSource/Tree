ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleGravitationBulletFactory = singletonClass("BattleGravitationBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleGravitationBulletFactory.__name = "BattleGravitationBulletFactory"

local var1_0 = var0_0.Battle.BattleGravitationBulletFactory

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.MakeBullet(arg0_2)
	return var0_0.Battle.BattleTorpedoBullet.New()
end

function var1_0.onBulletHitFunc(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3:GetBulletData()

	if var0_3:GetPierceCount() <= 0 then
		return
	end

	local var1_3 = var0_3:GetTemplate().hit_type
	local var2_3 = var1_0.GetDataProxy()
	local var3_3 = arg0_3:GetBulletData()
	local var4_3 = var3_3:GetTemplate()

	var0_0.Battle.PlayBattleSFX(var3_3:GetHitSFX())

	local var5_3 = var3_3:GetDiveFilter()
	local var6_3 = var3_3:GetPosition():Clone()
	local var7_3 = var3_3:GetTemplate().extra_param
	local var8_3 = var7_3.buff_id
	local var9_3 = var7_3.buff_level or 1

	local function var10_3(arg0_4)
		if var3_3:CanDealDamage() then
			for iter0_4, iter1_4 in ipairs(arg0_4) do
				if iter1_4.Active then
					local var0_4 = var1_0:GetSceneMediator():GetCharacter(iter1_4.UID):GetUnitData()
					local var1_4 = var0_0.Battle.BattleBuffUnit.New(var8_3, var9_3)

					var0_4:AddBuff(var1_4)

					if not var7_3.noIntervalDMG then
						var2_3:HandleDamage(var3_3, var0_4)
					end

					local var2_4 = var7_3.force or 0.1
					local var3_4 = pg.Tool.FilterY(var6_3 - var0_4:GetPosition())

					if var2_4 > var3_4.magnitude then
						var0_4:SetUncontrollableSpeed(var3_4, 0.001, 1e-06)
					else
						var0_4:SetUncontrollableSpeed(var3_4, var2_4, 1e-07)
					end
				end
			end

			var3_3:DealDamage()
		end
	end

	local function var11_3(arg0_5)
		if arg0_5.Active then
			local var0_5 = var1_0:GetSceneMediator():GetCharacter(arg0_5.UID):GetUnitData()

			var0_5:ClearUncontrollableSpeed()
			var0_5:RemoveBuff(var8_3)
		end
	end

	local function var12_3(arg0_6)
		local var0_6 = var7_3.exploDMG
		local var1_6 = var7_3.knockBack

		for iter0_6, iter1_6 in ipairs(arg0_6) do
			if iter1_6.Active then
				local var2_6 = var1_0:GetSceneMediator():GetCharacter(iter1_6.UID):GetUnitData()
				local var3_6 = false
				local var4_6 = var2_6:GetCurrentOxyState()

				for iter2_6, iter3_6 in ipairs(var5_3) do
					if var4_6 == iter3_6 then
						var3_6 = true
					end
				end

				if not var3_6 then
					var2_3:HandleDirectDamage(var2_6, var0_6, var3_3)

					if var2_6:IsAlive() then
						local var5_6 = pg.Tool.FilterY(var2_6:GetPosition() - var6_3)

						if var1_6 ~= false then
							var2_6:SetUncontrollableSpeed(var5_6, 1, 0.2, 6)
						end

						var2_6:RemoveBuff(var8_3)
					end
				end
			end
		end

		local var6_6, var7_6 = var1_0.GetFXPool():GetFX(arg0_3:GetMissFXID())

		pg.EffectMgr.GetInstance():PlayBattleEffect(var6_6, var7_6:Add(var6_3), true)
		var2_3:RemoveBulletUnit(var3_3:GetUniqueID())
	end

	var2_3:SpawnLastingColumnArea(var3_3:GetEffectField(), var3_3:GetIFF(), pg.Tool.FilterY(var6_3), var1_3.range, var1_3.time, var10_3, var11_3, false, arg0_3:GetFXID(), var12_3, true):SetDiveFilter(var5_3)
end

function var1_0.onBulletMissFunc(arg0_7)
	var1_0.onBulletHitFunc(arg0_7)
end

function var1_0.MakeModel(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8:GetBulletData()
	local var1_8 = var0_8:GetTemplate()
	local var2_8 = arg0_8:GetDataProxy()

	if not arg0_8:GetBulletPool():InstBullet(arg1_8:GetModleID(), function(arg0_9)
		arg1_8:AddModel(arg0_9)
	end) then
		arg1_8:AddTempModel(arg0_8:GetTempGOPool():GetObject())
	end

	arg1_8:SetSpawn(arg2_8)
	arg1_8:SetFXFunc(arg0_8.onBulletHitFunc, arg0_8.onBulletMissFunc)
	arg0_8:GetSceneMediator():AddBullet(arg1_8)

	if var0_8:GetIFF() ~= var2_8:GetFriendlyCode() and var1_8.alert_fx ~= "" then
		arg1_8:MakeAlert(arg0_8:GetFXPool():GetFX(var1_8.alert_fx))
	end
end
