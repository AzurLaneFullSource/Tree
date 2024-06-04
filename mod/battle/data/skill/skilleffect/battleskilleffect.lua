ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = var0.Battle.BattleUnitEvent

var0.Battle.BattleSkillEffect = class("BattleSkillEffect")
var0.Battle.BattleSkillEffect.__name = "BattleSkillEffect"

local var3 = var0.Battle.BattleSkillEffect

function var3.Ctor(arg0, arg1, arg2)
	arg0._tempData = arg1
	arg0._type = arg0._tempData.type
	arg0._targetChoise = arg0._tempData.target_choise or "TargetNull"
	arg0._casterAniEffect = arg0._tempData.casterAniEffect
	arg0._targetAniEffect = arg0._tempData.targetAniEffect
	arg0._delay = arg0._tempData.arg_list.delay or 0
	arg0._lastEffectTarget = {}
	arg0._timerList = {}
	arg0._timerIndex = 0
	arg0._level = arg2
end

function var3.SetCommander(arg0, arg1)
	arg0._commander = arg1
end

function var3.Effect(arg0, arg1, arg2, arg3)
	if arg2 and #arg2 > 0 then
		for iter0, iter1 in ipairs(arg2) do
			arg0:AniEffect(arg1, iter1)
			arg0:DataEffect(arg1, iter1, arg3)
		end
	else
		arg0:DataEffectWithoutTarget(arg1, arg3)
	end
end

function var3.IsFinaleEffect(arg0)
	return false
end

function var3.SetFinaleCallback(arg0, arg1)
	arg0._finaleCallback = arg1
end

function var3.AniEffect(arg0, arg1, arg2)
	local var0 = arg2:GetPosition()
	local var1 = arg1:GetPosition()

	if arg0._casterAniEffect and arg0._casterAniEffect ~= "" then
		local var2 = arg0._casterAniEffect
		local var3

		if var2.posFun then
			function var3(arg0)
				return var2.posFun(var1, var0, arg0)
			end
		end

		local var4 = {
			effect = var2.effect,
			offset = var2.offset,
			posFun = var3
		}

		arg1:DispatchEvent(var0.Event.New(var2.ADD_EFFECT, var4))
	end

	if arg0._targetAniEffect and arg0._targetAniEffect ~= "" then
		local var5 = arg0._targetAniEffect
		local var6

		if var5.posFun then
			function var6(arg0)
				return var5.posFun(var1, var0, arg0)
			end
		end

		local var7 = {
			effect = var5.effect,
			offset = var5.offset,
			posFun = var6
		}

		arg2:DispatchEvent(var0.Event.New(var2.ADD_EFFECT, var7))
	end
end

function var3.DataEffect(arg0, arg1, arg2, arg3)
	if arg0._delay > 0 then
		local var0
		local var1 = arg0._timerIndex + 1

		arg0._timerIndex = var1

		local function var2()
			if arg1 and arg1:IsAlive() then
				arg0:DoDataEffect(arg1, arg2, arg3)
			end

			pg.TimeMgr.GetInstance():RemoveBattleTimer(var0)

			arg0._timerList[var1] = nil
		end

		var0 = pg.TimeMgr.GetInstance():AddBattleTimer("BattleSkill", -1, arg0._delay, var2, true)
		arg0._timerList[var1] = var0
	else
		arg0:DoDataEffect(arg1, arg2, arg3)
	end
end

function var3.DoDataEffect(arg0, arg1, arg2, arg3)
	return
end

function var3.DataEffectWithoutTarget(arg0, arg1, arg2)
	if arg0._delay > 0 then
		local var0
		local var1 = arg0._timerIndex + 1

		arg0._timerIndex = var1

		local function var2()
			if arg1 and arg1:IsAlive() then
				arg0:DoDataEffectWithoutTarget(arg1, arg2)
			end

			pg.TimeMgr.GetInstance():RemoveBattleTimer(var0)

			arg0._timerList[var1] = nil
		end

		var0 = pg.TimeMgr.GetInstance():AddBattleTimer("BattleSkill", -1, arg0._delay, var2, true)
		arg0._timerList[var1] = var0
	else
		arg0:DoDataEffectWithoutTarget(arg1, arg2)
	end
end

function var3.DoDataEffectWithoutTarget(arg0, arg1, arg2)
	return
end

function var3.GetTarget(arg0, arg1, arg2)
	if type(arg0._targetChoise) == "string" then
		if arg0._targetChoise == "TargetSameToLastEffect" then
			return arg2._lastEffectTarget
		else
			return var0.Battle.BattleTargetChoise[arg0._targetChoise](arg1, arg0._tempData.arg_list)
		end
	elseif type(arg0._targetChoise) == "table" then
		local var0

		for iter0, iter1 in ipairs(arg0._targetChoise) do
			var0 = var0.Battle.BattleTargetChoise[iter1](arg1, arg0._tempData.arg_list, var0)
		end

		return var0
	end
end

function var3.Interrupt(arg0)
	return
end

function var3.Clear(arg0)
	for iter0, iter1 in pairs(arg0._timerList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter1)

		arg0._timerList[iter0] = nil
	end

	arg0._commander = nil
end

function var3.calcCorrdinate(arg0, arg1, arg2)
	local var0

	if arg0.absoulteCorrdinate then
		var0 = Vector3(arg0.absoulteCorrdinate.x, 0, arg0.absoulteCorrdinate.z)
	elseif arg0.absoulteRandom then
		var0 = var1.RandomPos(arg0.absoulteRandom)
	elseif arg0.casterRelativeCorrdinate then
		local var1 = arg1:GetIFF()
		local var2 = arg1:GetPosition()
		local var3 = var1 * arg0.casterRelativeCorrdinate.hrz + var2.x
		local var4 = var1 * arg0.casterRelativeCorrdinate.vrt + var2.z

		var0 = Vector3(var3, 0, var4)
	elseif arg0.casterRelativeRandom then
		local var5 = arg1:GetIFF()
		local var6 = arg1:GetPosition()
		local var7 = {
			X1 = var5 * arg0.casterRelativeRandom.front + var6.x,
			X2 = var5 * arg0.casterRelativeRandom.rear + var6.x,
			Z1 = arg0.casterRelativeRandom.upper + var6.z,
			Z2 = arg0.casterRelativeRandom.lower + var6.z
		}

		var0 = var1.RandomPos(var7)
	elseif arg0.targetRelativeCorrdinate then
		if arg2 then
			local var8 = arg2:GetIFF()
			local var9 = arg2:GetPosition()
			local var10 = var8 * arg0.targetRelativeCorrdinate.hrz + var9.x
			local var11 = var8 * arg0.targetRelativeCorrdinate.vrt + var9.z

			var0 = Vector3(var10, 0, var11)
		end
	elseif arg0.targetRelativeRandom and arg2 then
		local var12 = arg2:GetIFF()
		local var13 = arg2:GetPosition()
		local var14 = {
			X1 = var12 * arg0.targetRelativeRandom.front + var13.x,
			X2 = var12 * arg0.targetRelativeRandom.rear + var13.x,
			Z1 = arg0.targetRelativeRandom.upper + var13.z,
			Z2 = arg0.targetRelativeRandom.lower + var13.z
		}

		var0 = var1.RandomPos(var14)
	end

	return var0
end

function var3.GetDamageSum(arg0)
	return 0
end
