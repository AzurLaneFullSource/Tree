ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleSkillEffect = class("BattleSkillEffect")
var0_0.Battle.BattleSkillEffect.__name = "BattleSkillEffect"

local var3_0 = var0_0.Battle.BattleSkillEffect

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tempData = arg1_1
	arg0_1._type = arg0_1._tempData.type
	arg0_1._targetChoise = arg0_1._tempData.target_choise or "TargetNull"
	arg0_1._casterAniEffect = arg0_1._tempData.casterAniEffect
	arg0_1._targetAniEffect = arg0_1._tempData.targetAniEffect
	arg0_1._delay = arg0_1._tempData.arg_list.delay or 0
	arg0_1._lastEffectTarget = {}
	arg0_1._timerList = {}
	arg0_1._timerIndex = 0
	arg0_1._level = arg2_1
end

function var3_0.SetCommander(arg0_2, arg1_2)
	arg0_2._commander = arg1_2
end

function var3_0.Effect(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg2_3 and #arg2_3 > 0 then
		for iter0_3, iter1_3 in ipairs(arg2_3) do
			arg0_3:AniEffect(arg1_3, iter1_3)
			arg0_3:DataEffect(arg1_3, iter1_3, arg3_3)
		end
	else
		arg0_3:DataEffectWithoutTarget(arg1_3, arg3_3)
	end
end

function var3_0.IsFinaleEffect(arg0_4)
	return false
end

function var3_0.SetFinaleCallback(arg0_5, arg1_5)
	arg0_5._finaleCallback = arg1_5
end

function var3_0.AniEffect(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg2_6:GetPosition()
	local var1_6 = arg1_6:GetPosition()

	if arg0_6._casterAniEffect and arg0_6._casterAniEffect ~= "" then
		local var2_6 = arg0_6._casterAniEffect
		local var3_6

		if var2_6.posFun then
			function var3_6(arg0_7)
				return var2_6.posFun(var1_6, var0_6, arg0_7)
			end
		end

		local var4_6 = {
			effect = var2_6.effect,
			offset = var2_6.offset,
			posFun = var3_6
		}

		arg1_6:DispatchEvent(var0_0.Event.New(var2_0.ADD_EFFECT, var4_6))
	end

	if arg0_6._targetAniEffect and arg0_6._targetAniEffect ~= "" then
		local var5_6 = arg0_6._targetAniEffect
		local var6_6

		if var5_6.posFun then
			function var6_6(arg0_8)
				return var5_6.posFun(var1_6, var0_6, arg0_8)
			end
		end

		local var7_6 = {
			effect = var5_6.effect,
			offset = var5_6.offset,
			posFun = var6_6
		}

		arg2_6:DispatchEvent(var0_0.Event.New(var2_0.ADD_EFFECT, var7_6))
	end
end

function var3_0.DataEffect(arg0_9, arg1_9, arg2_9, arg3_9)
	if arg0_9._delay > 0 then
		local var0_9
		local var1_9 = arg0_9._timerIndex + 1

		arg0_9._timerIndex = var1_9

		local function var2_9()
			if arg1_9 and arg1_9:IsAlive() then
				arg0_9:DoDataEffect(arg1_9, arg2_9, arg3_9)
			end

			pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_9)

			arg0_9._timerList[var1_9] = nil
		end

		var0_9 = pg.TimeMgr.GetInstance():AddBattleTimer("BattleSkill", -1, arg0_9._delay, var2_9, true)
		arg0_9._timerList[var1_9] = var0_9
	else
		arg0_9:DoDataEffect(arg1_9, arg2_9, arg3_9)
	end
end

function var3_0.DoDataEffect(arg0_11, arg1_11, arg2_11, arg3_11)
	return
end

function var3_0.DataEffectWithoutTarget(arg0_12, arg1_12, arg2_12)
	if arg0_12._delay > 0 then
		local var0_12
		local var1_12 = arg0_12._timerIndex + 1

		arg0_12._timerIndex = var1_12

		local function var2_12()
			if arg1_12 and arg1_12:IsAlive() then
				arg0_12:DoDataEffectWithoutTarget(arg1_12, arg2_12)
			end

			pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_12)

			arg0_12._timerList[var1_12] = nil
		end

		var0_12 = pg.TimeMgr.GetInstance():AddBattleTimer("BattleSkill", -1, arg0_12._delay, var2_12, true)
		arg0_12._timerList[var1_12] = var0_12
	else
		arg0_12:DoDataEffectWithoutTarget(arg1_12, arg2_12)
	end
end

function var3_0.DoDataEffectWithoutTarget(arg0_14, arg1_14, arg2_14)
	return
end

function var3_0.GetTarget(arg0_15, arg1_15, arg2_15)
	if type(arg0_15._targetChoise) == "string" then
		if arg0_15._targetChoise == "TargetSameToLastEffect" then
			return arg2_15._lastEffectTarget
		else
			return var0_0.Battle.BattleTargetChoise[arg0_15._targetChoise](arg1_15, arg0_15._tempData.arg_list)
		end
	elseif type(arg0_15._targetChoise) == "table" then
		local var0_15

		for iter0_15, iter1_15 in ipairs(arg0_15._targetChoise) do
			var0_15 = var0_0.Battle.BattleTargetChoise[iter1_15](arg1_15, arg0_15._tempData.arg_list, var0_15)
		end

		return var0_15
	end
end

function var3_0.Interrupt(arg0_16)
	return
end

function var3_0.Clear(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17._timerList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter1_17)

		arg0_17._timerList[iter0_17] = nil
	end

	arg0_17._commander = nil
end

function var3_0.calcCorrdinate(arg0_18, arg1_18, arg2_18)
	local var0_18

	if arg0_18.absoulteCorrdinate then
		var0_18 = Vector3(arg0_18.absoulteCorrdinate.x, 0, arg0_18.absoulteCorrdinate.z)
	elseif arg0_18.absoulteRandom then
		var0_18 = var1_0.RandomPos(arg0_18.absoulteRandom)
	elseif arg0_18.casterRelativeCorrdinate then
		local var1_18 = arg1_18:GetIFF()
		local var2_18 = arg1_18:GetPosition()
		local var3_18 = var1_18 * arg0_18.casterRelativeCorrdinate.hrz + var2_18.x
		local var4_18 = var1_18 * arg0_18.casterRelativeCorrdinate.vrt + var2_18.z

		var0_18 = Vector3(var3_18, 0, var4_18)
	elseif arg0_18.casterRelativeRandom then
		local var5_18 = arg1_18:GetIFF()
		local var6_18 = arg1_18:GetPosition()
		local var7_18 = {
			X1 = var5_18 * arg0_18.casterRelativeRandom.front + var6_18.x,
			X2 = var5_18 * arg0_18.casterRelativeRandom.rear + var6_18.x,
			Z1 = arg0_18.casterRelativeRandom.upper + var6_18.z,
			Z2 = arg0_18.casterRelativeRandom.lower + var6_18.z
		}

		var0_18 = var1_0.RandomPos(var7_18)
	elseif arg0_18.targetRelativeCorrdinate then
		if arg2_18 then
			local var8_18 = arg2_18:GetIFF()
			local var9_18 = arg2_18:GetPosition()
			local var10_18 = var8_18 * arg0_18.targetRelativeCorrdinate.hrz + var9_18.x
			local var11_18 = var8_18 * arg0_18.targetRelativeCorrdinate.vrt + var9_18.z

			var0_18 = Vector3(var10_18, 0, var11_18)
		end
	elseif arg0_18.targetRelativeRandom and arg2_18 then
		local var12_18 = arg2_18:GetIFF()
		local var13_18 = arg2_18:GetPosition()
		local var14_18 = {
			X1 = var12_18 * arg0_18.targetRelativeRandom.front + var13_18.x,
			X2 = var12_18 * arg0_18.targetRelativeRandom.rear + var13_18.x,
			Z1 = arg0_18.targetRelativeRandom.upper + var13_18.z,
			Z2 = arg0_18.targetRelativeRandom.lower + var13_18.z
		}

		var0_18 = var1_0.RandomPos(var14_18)
	end

	return var0_18
end

function var3_0.GetDamageSum(arg0_19)
	return 0
end
