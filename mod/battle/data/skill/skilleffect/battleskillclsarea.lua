ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleEvent
local var4 = class("BattleSkillCLSArea", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillCLSArea = var4
var4.__name = "BattleSkillCLSArea"
var4.TYPE_BULLET = 1
var4.TYPE_AIRCRAFT = 2
var4.TYPE_MINION = 3

function var4.Ctor(arg0, arg1)
	var4.super.Ctor(arg0, arg1, lv)

	arg0._range = arg0._tempData.arg_list.range
	arg0._width = arg0._tempData.arg_list.width
	arg0._height = arg0._tempData.arg_list.height
	arg0._minRange = arg0._tempData.arg_list.minRange or 0
	arg0._angle = arg0._tempData.arg_list.angle
	arg0._lifeTime = arg0._tempData.arg_list.life_time
	arg0._fx = arg0._tempData.arg_list.effect
	arg0._moveType = arg0._tempData.arg_list.move_type
	arg0._speed = arg0._tempData.arg_list.speed_x
	arg0._finaleFX = arg0._tempData.arg_list.finale_effect
	arg0._delayCLS = arg0._tempData.arg_list.cld_delay
	arg0._bulletType = arg0._tempData.arg_list.bullet_type_list
	arg0._damageSrcUnitTag = arg0._tempData.arg_list.damage_tag_list
	arg0._damageParamA = arg0._tempData.arg_list.damage_param_a
	arg0._damageParamB = arg0._tempData.arg_list.damage_param_b
	arg0._damageSFX = arg0._tempData.arg_list.damage_sfx or ""
	arg0._damageBuffID = arg0._tempData.arg_list.buff_id
	arg0._damageBuffLV = arg0._tempData.arg_list.buff_lv
	arg0._damageDiveFilter = arg0._tempData.arg_list.diveFilter or {
		2
	}
	arg0._damageDiveDMGRate = arg0._tempData.arg_list.diveDamageRate or {
		1,
		1
	}
	arg0._delayCLSTimerList = {}
end

function var4.DoDataEffect(arg0, arg1)
	arg0:doCLS(arg1)
end

function var4.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:doCLS(arg1)
end

function var4.doCLS(arg0, arg1)
	if arg0._angle then
		arg0:cacheSectorData(arg1)
	end

	local var0 = var0.Battle.BattleDataProxy.GetInstance()

	local function var1(arg0)
		for iter0, iter1 in ipairs(arg0) do
			local var0 = iter1.UID
			local var1 = var0:GetBulletList()[iter1.UID]

			if var1:GetExist() and arg0:checkBulletType(var1) and not var1:ImmuneCLS() and not var1:ImmuneBombCLS() and not arg0:isEnterBlind(var1) and not arg0:isOutOfAngle(var1) then
				if arg0._delayCLS then
					local var2

					local function var3()
						if var1:GetExist() then
							var0:RemoveBulletUnit(var0)
						end

						pg.TimeMgr.GetInstance():RemoveBattleTimer(var2)

						arg0._delayCLSTimerList[var2] = nil
					end

					var2 = pg.TimeMgr.GetInstance():AddBattleTimer("clsBullet", -1, arg0._delayCLS, var3, true)
					arg0._delayCLSTimerList[var2] = true
				else
					var0:RemoveBulletUnit(var0)
				end
			end
		end
	end

	local function var2()
		for iter0, iter1 in pairs(arg0._delayCLSTimerList) do
			iter0.func()
			pg.TimeMgr.GetInstance():RemoveBattleTimer(iter0)

			arg0._delayCLSTimerList[iter0] = nil
		end

		arg0._delayCLSTimerList = {}

		if arg0._finaleFX then
			var0:SpawnEffect(arg0._finaleFX, arg0._cldArea:GetPosition(), 1)
		end
	end

	arg0._cldArea = arg0:generateArea(arg1, var1.AOEField.BULLET, var1, var2, arg0._fx)

	if arg0._damageSrcUnitTag then
		local var3 = var0.Battle.BattleTargetChoise.TargetAllHelp(arg1)
		local var4 = var0.Battle.BattleTargetChoise.TargetShipTag(arg1, {
			ship_tag_list = arg0._damageSrcUnitTag
		}, var3)
		local var5 = #var4

		if var5 <= 0 then
			return
		end

		local var6 = 0

		for iter0, iter1 in ipairs(var4) do
			var6 = var6 + iter1:GetAttrByName("formulaLevel")
		end

		local var7 = math.floor(var6 / var5)
		local var8 = arg0._damageParamA + var7 * arg0._damageParamB

		local function var9(arg0)
			for iter0, iter1 in ipairs(arg0) do
				if iter1.Active then
					local var0 = iter1.UID
					local var1 = var0:GetUnitList()[var0]
					local var2 = var1:GetCurrentOxyState()
					local var3 = math.floor(arg0._damageDiveDMGRate[var2] * var8)

					var0:HandleDirectDamage(var1, var8)
					var0.Battle.PlayBattleSFX(arg0._damageSFX)

					if arg0._damageBuffID and var1:IsAlive() then
						local var4 = var0.Battle.BattleBuffUnit.New(arg0._damageBuffID, nil, arg1)

						var4:SetOrb(arg1, arg0._damageBuffLV or 1)
						var1:AddBuff(var4)
					end
				end
			end
		end

		local function var10()
			return
		end

		local function var11()
			return
		end

		arg0:generateArea(arg1, var1.AOEField.SURFACE, var9, var10):SetDiveFilter(arg0._damageDiveFilter)
	end
end

function var4.generateArea(arg0, arg1, arg2, arg3, arg4, arg5)
	local function var0()
		return
	end

	local var1 = var0.Battle.BattleDataProxy.GetInstance()
	local var2 = arg1:GetIFF()
	local var3

	if arg0._range then
		var3 = var1:SpawnLastingColumnArea(arg2, var2, arg1:GetPosition(), arg0._range, arg0._lifeTime, arg3, var0, false, arg5, arg4)
	else
		var3 = var1:SpawnLastingCubeArea(arg2, var2, arg1:GetPosition(), arg0._width, arg0._height, arg0._lifeTime, arg3, var0, false, arg5, arg4)

		if var2 == var2.FRIENDLY_CODE then
			var3:SetAnchorPointAlignment(var3.ALIGNMENT_LEFT)
		elseif var2 == var2.FOE_CODE then
			var3:SetAnchorPointAlignment(var3.ALIGNMENT_RIGHT)
		end
	end

	local var4 = var0.Battle.BattleAOEMobilizedComponent.New(var3)

	var4:SetReferenceUnit(arg1)

	local var5 = arg0._speed * var2

	var4:ConfigData(arg0._moveType, {
		speedX = var5
	})

	return var3
end

function var4.cacheSectorData(arg0, arg1)
	local var0 = arg1:GetIFF()
	local var1 = arg0._angle / 2

	arg0._upperEdge = math.deg2Rad * var1
	arg0._lowerEdge = -1 * arg0._upperEdge

	if var0 == var2.FRIENDLY_CODE then
		arg0._normalizeOffset = 0
	elseif var0 == var2.FOE_CODE then
		arg0._normalizeOffset = math.pi
	end

	arg0._wholeCircle = math.pi - arg0._normalizeOffset
	arg0._negativeCircle = -math.pi - arg0._normalizeOffset
	arg0._wholeCircleNormalizeOffset = arg0._normalizeOffset - math.pi * 2
	arg0._negativeCircleNormalizeOffset = arg0._normalizeOffset + math.pi * 2
end

function var4.isOutOfAngle(arg0, arg1)
	if not arg0._angle then
		return false
	end

	local var0 = arg1:GetPosition()
	local var1 = arg0._cldArea:GetPosition()
	local var2 = math.atan2(var0.z - var1.z, var0.x - var1.x)

	if var2 > arg0._wholeCircle then
		var2 = var2 + arg0._wholeCircleNormalizeOffset
	elseif var2 < arg0._negativeCircle then
		var2 = var2 + arg0._negativeCircleNormalizeOffset
	else
		var2 = var2 + arg0._normalizeOffset
	end

	if var2 > arg0._lowerEdge and var2 < arg0._upperEdge then
		return false
	else
		return true
	end
end

function var4.isEnterBlind(arg0, arg1)
	if arg0._minRange == 0 then
		return false
	end

	local var0 = arg1:GetPosition()
	local var1 = arg0._cldArea:GetPosition()

	return Vector3.BattleDistance(var1, var0) < arg0._minRange
end

function var4.checkBulletType(arg0, arg1)
	if not arg0._bulletType then
		return true
	else
		local var0 = arg1:GetType()

		if table.contains(arg0._bulletType, var0) then
			return true
		else
			return false
		end
	end
end
