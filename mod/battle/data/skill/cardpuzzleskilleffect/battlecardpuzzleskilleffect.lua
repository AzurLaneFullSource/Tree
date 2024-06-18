ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleCardPuzzleSkillEffect = class("BattleCardPuzzleSkillEffect")
var0_0.Battle.BattleCardPuzzleSkillEffect.__name = "BattleCardPuzzleSkillEffect"

local var3_0 = var0_0.Battle.BattleCardPuzzleSkillEffect

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._tempData = arg1_1
	arg0_1._type = arg0_1._tempData.type
	arg0_1._targetChoise = arg0_1._tempData.target_choise
	arg0_1._delay = arg0_1._tempData.arg_list.delay or 0
	arg0_1._timerList = {}
	arg0_1._timerIndex = 0
end

function var3_0.Execute(arg0_2, arg1_2)
	arg0_2._caster = var0_0.Battle.BattleTargetChoise.TargetFleetIndex(nil, {
		fleetPos = arg0_2._tempData.caster
	})[1]

	if arg0_2._delay > 0 then
		local var0_2
		local var1_2 = arg0_2._timerIndex + 1

		arg0_2._timerIndex = var1_2

		local function var2_2()
			if arg0_2._caster and arg0_2._caster:IsAlive() then
				arg0_2:SkillEffectHandler()
			end

			pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_2)

			arg0_2._timerList[var1_2] = nil
		end

		var0_2 = pg.TimeMgr.GetInstance():AddBattleTimer("BattleSkill", -1, arg0_2._delay, var2_2, true)
		arg0_2._timerList[var1_2] = var0_2
	else
		arg0_2:SkillEffectHandler()
	end
end

function var3_0.SkillEffectHandler(arg0_4, arg1_4)
	return
end

function var3_0.AniEffect(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg2_5:GetPosition()
	local var1_5 = arg1_5:GetPosition()

	if arg0_5._casterAniEffect and arg0_5._casterAniEffect ~= "" then
		local var2_5 = arg0_5._casterAniEffect
		local var3_5

		if var2_5.posFun then
			function var3_5(arg0_6)
				return var2_5.posFun(var1_5, var0_5, arg0_6)
			end
		end

		local var4_5 = {
			effect = var2_5.effect,
			offset = var2_5.offset,
			posFun = var3_5
		}

		arg1_5:DispatchEvent(var0_0.Event.New(var2_0.ADD_EFFECT, var4_5))
	end

	if arg0_5._targetAniEffect and arg0_5._targetAniEffect ~= "" then
		local var5_5 = arg0_5._targetAniEffect
		local var6_5

		if var5_5.posFun then
			function var6_5(arg0_7)
				return var5_5.posFun(var1_5, var0_5, arg0_7)
			end
		end

		local var7_5 = {
			effect = var5_5.effect,
			offset = var5_5.offset,
			posFun = var6_5
		}

		arg2_5:DispatchEvent(var0_0.Event.New(var2_0.ADD_EFFECT, var7_5))
	end
end

function var3_0.GetTarget(arg0_8)
	if not arg0_8._targetChoise then
		return {}
	end

	local var0_8

	for iter0_8, iter1_8 in ipairs(arg0_8._targetChoise) do
		var0_8 = var0_0.Battle.BattleTargetChoise[iter1_8](arg0_8._caster, arg0_8._tempData.arg_list, var0_8)
	end

	return var0_8
end

function var3_0.GetCardPuzzleComponent(arg0_9)
	return arg0_9._card:GetClient()
end

function var3_0.GetFleetVO(arg0_10)
	return arg0_10:GetCardPuzzleComponent():GetFleetVO()
end

function var3_0.ConfigCard(arg0_11, arg1_11)
	arg0_11._card = arg1_11
end

function var3_0.SetQueue(arg0_12, arg1_12)
	arg0_12._queue = arg1_12
end

function var3_0.Finale(arg0_13)
	arg0_13._queue:EffectFinale(arg0_13)
end

function var3_0.HoldForInput(arg0_14)
	return false
end

function var3_0.MoveCardAfterCast(arg0_15)
	return var0_0.Battle.BattleFleetCardPuzzleComponent.CARD_PILE_INDEX_DISCARD
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
