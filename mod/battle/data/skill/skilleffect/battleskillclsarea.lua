ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleEvent
local var4_0 = class("BattleSkillCLSArea", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillCLSArea = var4_0
var4_0.__name = "BattleSkillCLSArea"
var4_0.TYPE_BULLET = 1
var4_0.TYPE_AIRCRAFT = 2
var4_0.TYPE_MINION = 3

function var4_0.Ctor(arg0_1, arg1_1)
	var4_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._range = arg0_1._tempData.arg_list.range
	arg0_1._width = arg0_1._tempData.arg_list.width
	arg0_1._height = arg0_1._tempData.arg_list.height
	arg0_1._minRange = arg0_1._tempData.arg_list.minRange or 0
	arg0_1._angle = arg0_1._tempData.arg_list.angle
	arg0_1._lifeTime = arg0_1._tempData.arg_list.life_time
	arg0_1._fx = arg0_1._tempData.arg_list.effect
	arg0_1._moveType = arg0_1._tempData.arg_list.move_type
	arg0_1._speed = arg0_1._tempData.arg_list.speed_x
	arg0_1._finaleFX = arg0_1._tempData.arg_list.finale_effect
	arg0_1._delayCLS = arg0_1._tempData.arg_list.cld_delay
	arg0_1._bulletType = arg0_1._tempData.arg_list.bullet_type_list
	arg0_1._damageSrcUnitTag = arg0_1._tempData.arg_list.damage_tag_list
	arg0_1._damageParamA = arg0_1._tempData.arg_list.damage_param_a
	arg0_1._damageParamB = arg0_1._tempData.arg_list.damage_param_b
	arg0_1._damageSFX = arg0_1._tempData.arg_list.damage_sfx or ""
	arg0_1._damageBuffID = arg0_1._tempData.arg_list.buff_id
	arg0_1._damageBuffLV = arg0_1._tempData.arg_list.buff_lv
	arg0_1._damageDiveFilter = arg0_1._tempData.arg_list.diveFilter or {
		2
	}
	arg0_1._damageDiveDMGRate = arg0_1._tempData.arg_list.diveDamageRate or {
		1,
		1
	}
	arg0_1._delayCLSTimerList = {}
end

function var4_0.DoDataEffect(arg0_2, arg1_2)
	arg0_2:doCLS(arg1_2)
end

function var4_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:doCLS(arg1_3)
end

function var4_0.doCLS(arg0_4, arg1_4)
	if arg0_4._angle then
		arg0_4:cacheSectorData(arg1_4)
	end

	local var0_4 = var0_0.Battle.BattleDataProxy.GetInstance()

	local function var1_4(arg0_5)
		for iter0_5, iter1_5 in ipairs(arg0_5) do
			local var0_5 = iter1_5.UID
			local var1_5 = var0_4:GetBulletList()[iter1_5.UID]

			if var1_5:GetExist() and arg0_4:checkBulletType(var1_5) and not var1_5:ImmuneCLS() and not var1_5:ImmuneBombCLS() and not arg0_4:isEnterBlind(var1_5) and not arg0_4:isOutOfAngle(var1_5) then
				if arg0_4._delayCLS then
					local var2_5

					local function var3_5()
						if var1_5:GetExist() then
							var0_4:RemoveBulletUnit(var0_5)
						end

						pg.TimeMgr.GetInstance():RemoveBattleTimer(var2_5)

						arg0_4._delayCLSTimerList[var2_5] = nil
					end

					var2_5 = pg.TimeMgr.GetInstance():AddBattleTimer("clsBullet", -1, arg0_4._delayCLS, var3_5, true)
					arg0_4._delayCLSTimerList[var2_5] = true
				else
					var0_4:RemoveBulletUnit(var0_5)
				end
			end
		end
	end

	local function var2_4()
		for iter0_7, iter1_7 in pairs(arg0_4._delayCLSTimerList) do
			iter0_7.func()
			pg.TimeMgr.GetInstance():RemoveBattleTimer(iter0_7)

			arg0_4._delayCLSTimerList[iter0_7] = nil
		end

		arg0_4._delayCLSTimerList = {}

		if arg0_4._finaleFX then
			var0_4:SpawnEffect(arg0_4._finaleFX, arg0_4._cldArea:GetPosition(), 1)
		end
	end

	arg0_4._cldArea = arg0_4:generateArea(arg1_4, var1_0.AOEField.BULLET, var1_4, var2_4, arg0_4._fx)

	if arg0_4._damageSrcUnitTag then
		local var3_4 = var0_0.Battle.BattleTargetChoise.TargetAllHelp(arg1_4)
		local var4_4 = var0_0.Battle.BattleTargetChoise.TargetShipTag(arg1_4, {
			ship_tag_list = arg0_4._damageSrcUnitTag
		}, var3_4)
		local var5_4 = #var4_4

		if var5_4 <= 0 then
			return
		end

		local var6_4 = 0

		for iter0_4, iter1_4 in ipairs(var4_4) do
			var6_4 = var6_4 + iter1_4:GetAttrByName("formulaLevel")
		end

		local var7_4 = math.floor(var6_4 / var5_4)
		local var8_4 = arg0_4._damageParamA + var7_4 * arg0_4._damageParamB

		local function var9_4(arg0_8)
			for iter0_8, iter1_8 in ipairs(arg0_8) do
				if iter1_8.Active then
					local var0_8 = iter1_8.UID
					local var1_8 = var0_4:GetUnitList()[var0_8]
					local var2_8 = var1_8:GetCurrentOxyState()
					local var3_8 = math.floor(arg0_4._damageDiveDMGRate[var2_8] * var8_4)

					var0_4:HandleDirectDamage(var1_8, var8_4)
					var0_0.Battle.PlayBattleSFX(arg0_4._damageSFX)

					if arg0_4._damageBuffID and var1_8:IsAlive() then
						local var4_8 = var0_0.Battle.BattleBuffUnit.New(arg0_4._damageBuffID, nil, arg1_4)

						var4_8:SetOrb(arg1_4, arg0_4._damageBuffLV or 1)
						var1_8:AddBuff(var4_8)
					end
				end
			end
		end

		local function var10_4()
			return
		end

		local function var11_4()
			return
		end

		arg0_4:generateArea(arg1_4, var1_0.AOEField.SURFACE, var9_4, var10_4):SetDiveFilter(arg0_4._damageDiveFilter)
	end
end

function var4_0.generateArea(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11)
	local function var0_11()
		return
	end

	local var1_11 = var0_0.Battle.BattleDataProxy.GetInstance()
	local var2_11 = arg1_11:GetIFF()
	local var3_11

	if arg0_11._range then
		var3_11 = var1_11:SpawnLastingColumnArea(arg2_11, var2_11, arg1_11:GetPosition(), arg0_11._range, arg0_11._lifeTime, arg3_11, var0_11, false, arg5_11, arg4_11)
	else
		var3_11 = var1_11:SpawnLastingCubeArea(arg2_11, var2_11, arg1_11:GetPosition(), arg0_11._width, arg0_11._height, arg0_11._lifeTime, arg3_11, var0_11, false, arg5_11, arg4_11)

		if var2_11 == var2_0.FRIENDLY_CODE then
			var3_11:SetAnchorPointAlignment(var3_11.ALIGNMENT_LEFT)
		elseif var2_11 == var2_0.FOE_CODE then
			var3_11:SetAnchorPointAlignment(var3_11.ALIGNMENT_RIGHT)
		end
	end

	local var4_11 = var0_0.Battle.BattleAOEMobilizedComponent.New(var3_11)

	var4_11:SetReferenceUnit(arg1_11)

	local var5_11 = arg0_11._speed * var2_11

	var4_11:ConfigData(arg0_11._moveType, {
		speedX = var5_11
	})

	return var3_11
end

function var4_0.cacheSectorData(arg0_13, arg1_13)
	local var0_13 = arg1_13:GetIFF()
	local var1_13 = arg0_13._angle / 2

	arg0_13._upperEdge = math.deg2Rad * var1_13
	arg0_13._lowerEdge = -1 * arg0_13._upperEdge

	if var0_13 == var2_0.FRIENDLY_CODE then
		arg0_13._normalizeOffset = 0
	elseif var0_13 == var2_0.FOE_CODE then
		arg0_13._normalizeOffset = math.pi
	end

	arg0_13._wholeCircle = math.pi - arg0_13._normalizeOffset
	arg0_13._negativeCircle = -math.pi - arg0_13._normalizeOffset
	arg0_13._wholeCircleNormalizeOffset = arg0_13._normalizeOffset - math.pi * 2
	arg0_13._negativeCircleNormalizeOffset = arg0_13._normalizeOffset + math.pi * 2
end

function var4_0.isOutOfAngle(arg0_14, arg1_14)
	if not arg0_14._angle then
		return false
	end

	local var0_14 = arg1_14:GetPosition()
	local var1_14 = arg0_14._cldArea:GetPosition()
	local var2_14 = math.atan2(var0_14.z - var1_14.z, var0_14.x - var1_14.x)

	if var2_14 > arg0_14._wholeCircle then
		var2_14 = var2_14 + arg0_14._wholeCircleNormalizeOffset
	elseif var2_14 < arg0_14._negativeCircle then
		var2_14 = var2_14 + arg0_14._negativeCircleNormalizeOffset
	else
		var2_14 = var2_14 + arg0_14._normalizeOffset
	end

	if var2_14 > arg0_14._lowerEdge and var2_14 < arg0_14._upperEdge then
		return false
	else
		return true
	end
end

function var4_0.isEnterBlind(arg0_15, arg1_15)
	if arg0_15._minRange == 0 then
		return false
	end

	local var0_15 = arg1_15:GetPosition()
	local var1_15 = arg0_15._cldArea:GetPosition()

	return Vector3.BattleDistance(var1_15, var0_15) < arg0_15._minRange
end

function var4_0.checkBulletType(arg0_16, arg1_16)
	if not arg0_16._bulletType then
		return true
	else
		local var0_16 = arg1_16:GetType()

		if table.contains(arg0_16._bulletType, var0_16) then
			return true
		else
			return false
		end
	end
end
