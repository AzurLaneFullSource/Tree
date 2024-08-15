ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleConst.AircraftUnitType
local var4_0 = var0_0.Battle.BattleConst.CharacterUnitType

var0_0.Battle.BattleShrapnelBulletFactory = singletonClass("BattleShrapnelBulletFactory", var0_0.Battle.BattleBulletFactory)
var0_0.Battle.BattleShrapnelBulletFactory.__name = "BattleShrapnelBulletFactory"

local var5_0 = var0_0.Battle.BattleShrapnelBulletFactory

var5_0.INHERIT_NONE = 0
var5_0.INHERIT_ANGLE = 1
var5_0.INHERIT_SPEED_NORMALIZE = 2
var5_0.FRAGILE_DAMAGE_NOT_SPLIT = 1
var5_0.FRAGILE_NOT_DAMAGE_NOT_SPLIT = 2

function var5_0.Ctor(arg0_1)
	var5_0.super.Ctor(arg0_1)
end

function var5_0.MakeBullet(arg0_2)
	return var0_0.Battle.BattleShrapnelBullet.New()
end

function var5_0.CreateBullet(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	arg2_3:SetOutRangeCallback(arg0_3.OutRangeFunc)

	local var0_3 = arg0_3:MakeBullet()

	var0_3:SetFactory(arg0_3)
	var0_3:SetBulletData(arg2_3)
	arg0_3:MakeModel(var0_3, arg3_3, arg4_3, arg5_3)

	if arg4_3 and arg4_3 ~= "" then
		arg0_3:PlayFireFX(arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, nil)
	end

	if not arg2_3:GetTemplate().extra_param.rangeAA then
		var5_0.bulletSplit(var0_3)
	end

	return var0_3
end

function var5_0.onBulletHitFunc(arg0_4, arg1_4, arg2_4)
	local var0_4 = var5_0.GetDataProxy()
	local var1_4 = arg0_4:GetBulletData()
	local var2_4 = var1_4:GetCurrentState()
	local var3_4 = var1_4:GetTemplate()
	local var4_4 = var3_4.extra_param.shrapnel
	local var5_4 = var3_4.extra_param.fragile
	local var6_4 = var3_4.extra_param.hitSplitOnly

	if not arg1_4 and var6_4 then
		var0_4:RemoveBulletUnit(var1_4:GetUniqueID())

		return
	end

	if var5_4 and arg1_4 then
		if var5_4 == var5_0.FRAGILE_DAMAGE_NOT_SPLIT then
			var0_0.Battle.BattleCannonBulletFactory.onBulletHitFunc(arg0_4, arg1_4, arg2_4)
		elseif var5_4 == var5_0.FRAGILE_NOT_DAMAGE_NOT_SPLIT then
			var0_4:RemoveBulletUnit(var1_4:GetUniqueID())
		end

		return
	end

	if var2_4 == var1_4.STATE_SPLIT or var2_4 == var1_4.STATE_SPIN then
		-- block empty
	elseif var2_4 == var1_4.STATE_FINAL_SPLIT then
		return
	elseif var1_4:GetPierceCount() > 0 then
		var0_0.Battle.BattleCannonBulletFactory.onBulletHitFunc(arg0_4, arg1_4, arg2_4)

		return
	end

	if arg1_4 ~= nil and arg2_4 ~= nil then
		local var7_4

		if table.contains(var3_0, arg2_4) then
			var7_4 = var5_0.GetSceneMediator():GetAircraft(arg1_4)
		elseif table.contains(var4_0, arg2_4) then
			var7_4 = var5_0.GetSceneMediator():GetCharacter(arg1_4)
		end

		local var8_4 = var7_4:GetUnitData()
		local var9_4 = var7_4:AddFX(arg0_4:GetFXID())

		if var8_4:GetIFF() == var0_4:GetFoeCode() then
			local var10_4 = var9_4.transform
			local var11_4 = var10_4.localRotation

			var10_4.localRotation = Vector3(var11_4.x, 180, var11_4.z)
		end
	end

	var0_0.Battle.PlayBattleSFX(var1_4:GetHitSFX())

	if var3_4.extra_param.rangeAA then
		var5_0.areaSplit(arg0_4)
	else
		var5_0.bulletSplit(arg0_4, true)
	end
end

function var5_0.areaSplit(arg0_5)
	local var0_5 = var5_0.GetDataProxy()
	local var1_5 = arg0_5:GetBulletData()

	var1_5:GetWeapon():DoAreaSplit(var1_5)
	var0_5:RemoveBulletUnit(var1_5:GetUniqueID())
end

function var5_0.bulletSplit(arg0_6, arg1_6)
	local var0_6 = arg0_6:GetBulletData()
	local var1_6 = var5_0.GetDataProxy()
	local var2_6 = var0_6:GetTemplate()
	local var3_6 = var2_6.extra_param.shrapnel
	local var4_6 = var0_6:GetSrcHost()
	local var5_6 = var0_6:GetWeapon()

	if var2_6.extra_param.FXID ~= nil then
		local var6_6, var7_6 = var5_0.GetFXPool():GetFX(var2_6.extra_param.FXID)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var6_6, var7_6:Add(arg0_6:GetPosition()), true)
	end

	local var8_6
	local var9_6 = var0_6:GetSpeed().x > 0 and 0 or 180

	for iter0_6, iter1_6 in ipairs(var3_6) do
		if arg1_6 ~= iter1_6.initialSplit then
			local var10_6 = iter1_6.barrage_ID
			local var11_6 = iter1_6.bullet_ID
			local var12_6 = iter1_6.emitterType or var0_0.Battle.BattleWeaponUnit.EMITTER_SHOTGUN
			local var13_6 = iter1_6.inheritAngle
			local var14_6 = iter1_6.reaim
			local var15_6 = iter1_6.rotateOffset

			local function var16_6(arg0_7, arg1_7, arg2_7, arg3_7)
				local var0_7 = var1_6:CreateBulletUnit(var11_6, var4_6, var5_6, Vector3.zero)

				var0_7:OverrideCorrectedDMG(iter1_6.damage)
				var0_7:SetOffsetPriority(arg3_7)

				if var15_6 then
					local var1_7 = math.sqrt(arg0_7 * arg0_7 + arg1_7 * arg1_7)
					local var2_7 = math.atan2(arg1_7, arg0_7)
					local var3_7 = math.rad(var0_6:GetYAngle())
					local var4_7 = var2_7 + var3_7
					local var5_7 = math.abs(math.cos(var3_7))

					arg0_7 = var1_7 * math.cos(var4_7) * (0.5 + 0.5 * var5_7)
					arg1_7 = var1_7 * math.sin(var4_7) * (2 - var5_7)
				end

				var0_7:SetShiftInfo(arg0_7, arg1_7)

				local var6_7 = var9_6

				if var13_6 == var5_0.INHERIT_ANGLE then
					var6_7 = var0_6:GetYAngle()
				elseif var13_6 == var5_0.INHERIT_SPEED_NORMALIZE then
					var6_7 = var0_6:GetCurrentYAngle()
				end

				if var14_6 then
					local var7_7
					local var8_7 = var0_6:GetWeapon():GetHost()

					if type(var14_6) == "table" and var8_7 then
						local var9_7 = iter1_6.reaimParam
						local var10_7

						for iter0_7, iter1_7 in ipairs(var14_6) do
							var10_7 = var0_0.Battle.BattleTargetChoise[iter1_7](var8_7, var9_7, var10_7)
						end

						var7_7 = var10_7[1]
					else
						var7_7 = var0_0.Battle.BattleTargetChoise.TargetHarmNearest(var0_6)[1]
					end

					if var7_7 == nil then
						var0_7:SetRotateInfo(nil, var6_7, arg2_7)
					else
						var0_7:SetRotateInfo(var7_7:GetBeenAimedPosition(), var6_7, arg2_7)
					end
				else
					var0_7:SetRotateInfo(nil, var6_7, arg2_7)
				end

				var5_0.GetFactoryList()[var0_7:GetTemplate().type]:CreateBullet(arg0_6:GetTf(), var0_7, arg0_6:GetPosition())
			end

			local var17_6

			local function var18_6()
				var17_6:Destroy()
				var0_6:SplitFinishCount()

				if var0_6:IsAllSplitFinish() then
					var1_6:RemoveBulletUnit(var0_6:GetUniqueID())
				end
			end

			var17_6 = var0_0.Battle[var12_6].New(var16_6, var18_6, var10_6)

			var0_6:CacheChildEimtter(var17_6)
			var17_6:Ready()
			var17_6:Fire(nil, var5_6:GetDirection(), var0_0.Battle.BattleDataFunction.GetBarrageTmpDataFromID(var10_6).angle)
		end
	end

	if arg1_6 then
		var0_6:ChangeShrapnelState(var0_0.Battle.BattleShrapnelBulletUnit.STATE_FINAL_SPLIT)
	end
end

function var5_0.onBulletMissFunc(arg0_9)
	return
end

function var5_0.MakeModel(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	local var0_10 = arg1_10:GetBulletData()

	if not arg0_10:GetBulletPool():InstBullet(arg1_10:GetModleID(), function(arg0_11)
		arg1_10:AddModel(arg0_11)
	end) then
		arg1_10:AddTempModel(arg0_10:GetTempGOPool():GetObject())
	end

	arg1_10:SetSpawn(arg2_10)
	arg1_10:SetFXFunc(arg0_10.onBulletHitFunc, arg0_10.onBulletMissFunc)
	arg0_10:GetSceneMediator():AddBullet(arg1_10)
end

function var5_0.OutRangeFunc(arg0_12)
	if arg0_12:IsOutRange() then
		arg0_12:ChangeShrapnelState(var0_0.Battle.BattleShrapnelBulletUnit.STATE_SPIN)
	else
		arg0_12:ChangeShrapnelState(var0_0.Battle.BattleShrapnelBulletUnit.STATE_SPLIT)
	end
end
