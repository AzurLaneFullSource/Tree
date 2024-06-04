ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleConst.AircraftUnitType
local var4 = var0.Battle.BattleConst.CharacterUnitType

var0.Battle.BattleShrapnelBulletFactory = singletonClass("BattleShrapnelBulletFactory", var0.Battle.BattleBulletFactory)
var0.Battle.BattleShrapnelBulletFactory.__name = "BattleShrapnelBulletFactory"

local var5 = var0.Battle.BattleShrapnelBulletFactory

var5.INHERIT_NONE = 0
var5.INHERIT_ANGLE = 1
var5.INHERIT_SPEED_NORMALIZE = 2

function var5.Ctor(arg0)
	var5.super.Ctor(arg0)
end

function var5.MakeBullet(arg0)
	return var0.Battle.BattleShrapnelBullet.New()
end

function var5.CreateBullet(arg0, arg1, arg2, arg3, arg4, arg5)
	arg2:SetOutRangeCallback(arg0.OutRangeFunc)

	local var0 = arg0:MakeBullet()

	var0:SetFactory(arg0)
	var0:SetBulletData(arg2)
	arg0:MakeModel(var0, arg3, arg4, arg5)

	if arg4 and arg4 ~= "" then
		arg0:PlayFireFX(arg1, arg2, arg3, arg4, arg5, nil)
	end

	if not arg2:GetTemplate().extra_param.rangeAA then
		var5.bulletSplit(var0)
	end

	return var0
end

function var5.onBulletHitFunc(arg0, arg1, arg2)
	local var0 = var5.GetDataProxy()
	local var1 = arg0:GetBulletData()
	local var2 = var1:GetCurrentState()
	local var3 = var1:GetTemplate()
	local var4 = var3.extra_param.shrapnel

	if var3.extra_param.fragile and arg1 then
		var0.Battle.BattleCannonBulletFactory.onBulletHitFunc(arg0, arg1, arg2)

		return
	end

	if var2 == var1.STATE_SPLIT or var2 == var1.STATE_SPIN then
		-- block empty
	elseif var2 == var1.STATE_FINAL_SPLIT then
		return
	elseif var1:GetPierceCount() > 0 then
		var0.Battle.BattleCannonBulletFactory.onBulletHitFunc(arg0, arg1, arg2)

		return
	end

	if arg1 ~= nil and arg2 ~= nil then
		local var5

		if table.contains(var3, arg2) then
			var5 = var5.GetSceneMediator():GetAircraft(arg1)
		elseif table.contains(var4, arg2) then
			var5 = var5.GetSceneMediator():GetCharacter(arg1)
		end

		local var6 = var5:GetUnitData()
		local var7 = var5:AddFX(arg0:GetFXID())

		if var6:GetIFF() == var0:GetFoeCode() then
			local var8 = var7.transform
			local var9 = var8.localRotation

			var8.localRotation = Vector3(var9.x, 180, var9.z)
		end
	end

	var0.Battle.PlayBattleSFX(var1:GetHitSFX())

	if var3.extra_param.rangeAA then
		var5.areaSplit(arg0)
	else
		var5.bulletSplit(arg0, true)
	end
end

function var5.areaSplit(arg0)
	local var0 = var5.GetDataProxy()
	local var1 = arg0:GetBulletData()

	var1:GetWeapon():DoAreaSplit(var1)
	var0:RemoveBulletUnit(var1:GetUniqueID())
end

function var5.bulletSplit(arg0, arg1)
	local var0 = arg0:GetBulletData()
	local var1 = var5.GetDataProxy()
	local var2 = var0:GetTemplate()
	local var3 = var2.extra_param.shrapnel
	local var4 = var0:GetSrcHost()
	local var5 = var0:GetWeapon()

	if var2.extra_param.FXID ~= nil then
		local var6, var7 = var5.GetFXPool():GetFX(var2.extra_param.FXID)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var6, var7:Add(arg0:GetPosition()), true)
	end

	local var8
	local var9 = var0:GetSpeed().x > 0 and 0 or 180

	for iter0, iter1 in ipairs(var3) do
		if arg1 ~= iter1.initialSplit then
			local var10 = iter1.barrage_ID
			local var11 = iter1.bullet_ID
			local var12 = iter1.emitterType or var0.Battle.BattleWeaponUnit.EMITTER_SHOTGUN
			local var13 = iter1.inheritAngle
			local var14 = iter1.reaim
			local var15 = iter1.rotateOffset

			local function var16(arg0, arg1, arg2, arg3)
				local var0 = var1:CreateBulletUnit(var11, var4, var5, Vector3.zero)

				var0:OverrideCorrectedDMG(iter1.damage)
				var0:SetOffsetPriority(arg3)

				if var15 then
					local var1 = math.sqrt(arg0 * arg0 + arg1 * arg1)
					local var2 = math.atan2(arg1, arg0)
					local var3 = math.rad(var0:GetYAngle())
					local var4 = var2 + var3
					local var5 = math.abs(math.cos(var3))

					arg0 = var1 * math.cos(var4) * (0.5 + 0.5 * var5)
					arg1 = var1 * math.sin(var4) * (2 - var5)
				end

				var0:SetShiftInfo(arg0, arg1)

				local var6 = var9

				if var13 == var5.INHERIT_ANGLE then
					var6 = var0:GetYAngle()
				elseif var13 == var5.INHERIT_SPEED_NORMALIZE then
					var6 = var0:GetCurrentYAngle()
				end

				if var14 then
					local var7 = var0.Battle.BattleTargetChoise.TargetHarmNearest(var0)[1]

					if var7 == nil then
						var0:SetRotateInfo(nil, var6, arg2)
					else
						var0:SetRotateInfo(var7:GetBeenAimedPosition(), var6, arg2)
					end
				else
					var0:SetRotateInfo(nil, var6, arg2)
				end

				var5.GetFactoryList()[var0:GetTemplate().type]:CreateBullet(arg0:GetTf(), var0, arg0:GetPosition())
			end

			local var17

			local function var18()
				var17:Destroy()
				var0:SplitFinishCount()

				if var0:IsAllSplitFinish() then
					var1:RemoveBulletUnit(var0:GetUniqueID())
				end
			end

			var17 = var0.Battle[var12].New(var16, var18, var10)

			var0:CacheChildEimtter(var17)
			var17:Ready()
			var17:Fire(nil, var5:GetDirection(), var0.Battle.BattleDataFunction.GetBarrageTmpDataFromID(var10).angle)
		end
	end

	if arg1 then
		var0:ChangeShrapnelState(var0.Battle.BattleShrapnelBulletUnit.STATE_FINAL_SPLIT)
	end
end

function var5.onBulletMissFunc(arg0)
	return
end

function var5.MakeModel(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:GetBulletData()

	if not arg0:GetBulletPool():InstBullet(arg1:GetModleID(), function(arg0)
		arg1:AddModel(arg0)
	end) then
		arg1:AddTempModel(arg0:GetTempGOPool():GetObject())
	end

	arg1:SetSpawn(arg2)
	arg1:SetFXFunc(arg0.onBulletHitFunc, arg0.onBulletMissFunc)
	arg0:GetSceneMediator():AddBullet(arg1)
end

function var5.OutRangeFunc(arg0)
	if arg0:IsOutRange() then
		arg0:ChangeShrapnelState(var0.Battle.BattleShrapnelBulletUnit.STATE_SPIN)
	else
		arg0:ChangeShrapnelState(var0.Battle.BattleShrapnelBulletUnit.STATE_SPLIT)
	end
end
