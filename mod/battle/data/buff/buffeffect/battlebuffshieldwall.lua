ys = ys or {}

local var0 = ys
local var1 = pg.effect_offset

var0.Battle.BattleBuffShieldWall = class("BattleBuffShieldWall", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffShieldWall.__name = "BattleBuffShieldWall"

local var2 = var0.Battle.BattleBuffShieldWall

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)
end

function var2.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._buffID = arg2:GetID()
	arg0._dir = arg1:GetDirection()
	arg0._count = var0.count
	arg0._bulletType = var0.bulletType or var0.Battle.BattleConst.BulletType.CANNON
	arg0._doWhenHit = var0.do_when_hit
	arg0._unit = arg1
	arg0._dataProxy = var0.Battle.BattleDataProxy.GetInstance()
	arg0._centerPos = arg1:GetPosition()
	arg0._startTime = pg.TimeMgr.GetInstance():GetCombatTime()

	local function var1(arg0)
		return arg0:onWallCld(arg0)
	end

	local var2 = arg1:GetTemplate().scale / 50
	local var3 = var0.cld_list[1]
	local var4 = var3.box
	local var5 = Clone(var3.offset)

	if arg1:GetDirection() == var0.Battle.BattleConst.UnitDir.LEFT then
		var5[1] = -var5[1] * var2
	else
		var5[1] = var5[1] * var2
	end

	arg0._wall = arg0._dataProxy:SpawnWall(arg0, var1, var4, var5)

	local var6
	local var7 = var1[var0.effect]

	if var7 then
		local var8 = var7.container_index
		local var9 = Vector3(var7.offset[1], var7.offset[2], var7.offset[3])
		local var10 = arg1:GetTemplate().fx_container[var8]
		local var11 = Vector3(var10[1], var10[2], var10[3])

		var11:Add(var9)

		var6 = var11
	end

	if var6 then
		function arg0._centerPosFun(arg0)
			local var0
			local var1 = var0.centerPosFun(arg0):Add(var6)

			var1.x = var1.x * arg0._dir

			return var1
		end
	else
		arg0._centerPosFun = var0.centerPosFun
	end

	arg0._currentTimeCount = 0

	if var0.effect then
		arg0._effectIndex = "BattleBuffShieldWall" .. arg0._buffID .. arg0._tempData.id

		local var12

		if var6 then
			function var12(arg0)
				local var0

				return (var0.centerPosFun(arg0):Add(var6))
			end
		else
			var12 = var0.centerPosFun
		end

		arg0._unit = arg1
		arg0._evtData = {
			effect = var0.effect,
			posFun = var12,
			index = arg0._effectIndex,
			rotationFun = var0.rotationFun
		}

		arg1:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.ADD_EFFECT, arg0._evtData))
	end
end

function var2.onStack(arg0, arg1, arg2)
	arg0._count = arg0._tempData.arg_list.count

	arg0._unit:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.ADD_EFFECT, arg0._evtData))
end

function var2.onUpdate(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetPosition()
	local var1 = arg1:GetTemplate().scale * 0.02
	local var2 = arg3.timeStamp

	if arg0._centerPosFun then
		arg0._currentTimeCount = var2 - arg0._startTime
		var0 = arg0._centerPosFun(arg0._currentTimeCount):Mul(var1):Add(var0)
	end

	arg0._centerPos = var0
end

function var2.onWallCld(arg0, arg1)
	if not arg1:GetIgnoreShield() and arg1:GetType() == arg0._bulletType and arg0._count > 0 then
		if arg0._doWhenHit == "intercept" then
			arg1:Intercepted()
			arg0._dataProxy:RemoveBulletUnit(arg1:GetUniqueID())

			arg0._count = arg0._count - 1
		elseif arg0._doWhenHit == "reflect" and arg0:GetIFF() ~= arg1:GetIFF() then
			arg1:Reflected()

			arg0._count = arg0._count - 1
		end

		if arg0._count <= 0 then
			arg0:Deactive()
		end
	end

	return arg0._count > 0
end

function var2.GetIFF(arg0)
	return arg0._unit:GetIFF()
end

function var2.GetPosition(arg0)
	return arg0._centerPos
end

function var2.IsWallActive(arg0)
	return arg0._count > 0
end

function var2.Deactive(arg0)
	if arg0._effectIndex then
		local var0 = {
			index = arg0._effectIndex
		}

		arg0._unit:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.DEACTIVE_EFFECT, var0))
	end

	arg0._unit:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_SHIELD_BROKEN, {
		shieldBuffID = arg0._buffID
	})
end

function var2.Clear(arg0)
	if arg0._effectIndex then
		local var0 = {
			index = arg0._effectIndex
		}

		arg0._unit:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.CANCEL_EFFECT, var0))
	end

	arg0._dataProxy:RemoveWall(arg0._wall:GetUniqueID())
end
