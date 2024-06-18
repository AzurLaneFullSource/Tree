ys = ys or {}

local var0_0 = ys
local var1_0 = pg.effect_offset

var0_0.Battle.BattleBuffShieldWall = class("BattleBuffShieldWall", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffShieldWall.__name = "BattleBuffShieldWall"

local var2_0 = var0_0.Battle.BattleBuffShieldWall

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)
end

function var2_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._buffID = arg2_2:GetID()
	arg0_2._dir = arg1_2:GetDirection()
	arg0_2._count = var0_2.count
	arg0_2._bulletType = var0_2.bulletType or var0_0.Battle.BattleConst.BulletType.CANNON
	arg0_2._doWhenHit = var0_2.do_when_hit
	arg0_2._unit = arg1_2
	arg0_2._dataProxy = var0_0.Battle.BattleDataProxy.GetInstance()
	arg0_2._centerPos = arg1_2:GetPosition()
	arg0_2._startTime = pg.TimeMgr.GetInstance():GetCombatTime()

	local function var1_2(arg0_3)
		return arg0_2:onWallCld(arg0_3)
	end

	local var2_2 = arg1_2:GetTemplate().scale / 50
	local var3_2 = var0_2.cld_list[1]
	local var4_2 = var3_2.box
	local var5_2 = Clone(var3_2.offset)

	if arg1_2:GetDirection() == var0_0.Battle.BattleConst.UnitDir.LEFT then
		var5_2[1] = -var5_2[1] * var2_2
	else
		var5_2[1] = var5_2[1] * var2_2
	end

	arg0_2._wall = arg0_2._dataProxy:SpawnWall(arg0_2, var1_2, var4_2, var5_2)

	local var6_2
	local var7_2 = var1_0[var0_2.effect]

	if var7_2 then
		local var8_2 = var7_2.container_index
		local var9_2 = Vector3(var7_2.offset[1], var7_2.offset[2], var7_2.offset[3])
		local var10_2 = arg1_2:GetTemplate().fx_container[var8_2]
		local var11_2 = Vector3(var10_2[1], var10_2[2], var10_2[3])

		var11_2:Add(var9_2)

		var6_2 = var11_2
	end

	if var6_2 then
		function arg0_2._centerPosFun(arg0_4)
			local var0_4
			local var1_4 = var0_2.centerPosFun(arg0_4):Add(var6_2)

			var1_4.x = var1_4.x * arg0_2._dir

			return var1_4
		end
	else
		arg0_2._centerPosFun = var0_2.centerPosFun
	end

	arg0_2._currentTimeCount = 0

	if var0_2.effect then
		arg0_2._effectIndex = "BattleBuffShieldWall" .. arg0_2._buffID .. arg0_2._tempData.id

		local var12_2

		if var6_2 then
			function var12_2(arg0_5)
				local var0_5

				return (var0_2.centerPosFun(arg0_5):Add(var6_2))
			end
		else
			var12_2 = var0_2.centerPosFun
		end

		arg0_2._unit = arg1_2
		arg0_2._evtData = {
			effect = var0_2.effect,
			posFun = var12_2,
			index = arg0_2._effectIndex,
			rotationFun = var0_2.rotationFun
		}

		arg1_2:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ADD_EFFECT, arg0_2._evtData))
	end
end

function var2_0.onStack(arg0_6, arg1_6, arg2_6)
	arg0_6._count = arg0_6._tempData.arg_list.count

	arg0_6._unit:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ADD_EFFECT, arg0_6._evtData))
end

function var2_0.onUpdate(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg1_7:GetPosition()
	local var1_7 = arg1_7:GetTemplate().scale * 0.02
	local var2_7 = arg3_7.timeStamp

	if arg0_7._centerPosFun then
		arg0_7._currentTimeCount = var2_7 - arg0_7._startTime
		var0_7 = arg0_7._centerPosFun(arg0_7._currentTimeCount):Mul(var1_7):Add(var0_7)
	end

	arg0_7._centerPos = var0_7
end

function var2_0.onWallCld(arg0_8, arg1_8)
	if not arg1_8:GetIgnoreShield() and arg1_8:GetType() == arg0_8._bulletType and arg0_8._count > 0 then
		if arg0_8._doWhenHit == "intercept" then
			arg1_8:Intercepted()
			arg0_8._dataProxy:RemoveBulletUnit(arg1_8:GetUniqueID())

			arg0_8._count = arg0_8._count - 1
		elseif arg0_8._doWhenHit == "reflect" and arg0_8:GetIFF() ~= arg1_8:GetIFF() then
			arg1_8:Reflected()

			arg0_8._count = arg0_8._count - 1
		end

		if arg0_8._count <= 0 then
			arg0_8:Deactive()
		end
	end

	return arg0_8._count > 0
end

function var2_0.GetIFF(arg0_9)
	return arg0_9._unit:GetIFF()
end

function var2_0.GetPosition(arg0_10)
	return arg0_10._centerPos
end

function var2_0.IsWallActive(arg0_11)
	return arg0_11._count > 0
end

function var2_0.Deactive(arg0_12)
	if arg0_12._effectIndex then
		local var0_12 = {
			index = arg0_12._effectIndex
		}

		arg0_12._unit:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.DEACTIVE_EFFECT, var0_12))
	end

	arg0_12._unit:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_SHIELD_BROKEN, {
		shieldBuffID = arg0_12._buffID
	})
end

function var2_0.Clear(arg0_13)
	if arg0_13._effectIndex then
		local var0_13 = {
			index = arg0_13._effectIndex
		}

		arg0_13._unit:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CANCEL_EFFECT, var0_13))
	end

	arg0_13._dataProxy:RemoveWall(arg0_13._wall:GetUniqueID())
end
