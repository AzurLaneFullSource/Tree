ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = var0.Battle.BattleUnitEvent

var0.Battle.BattleCardPuzzleSkillEffect = class("BattleCardPuzzleSkillEffect")
var0.Battle.BattleCardPuzzleSkillEffect.__name = "BattleCardPuzzleSkillEffect"

local var3 = var0.Battle.BattleCardPuzzleSkillEffect

function var3.Ctor(arg0, arg1)
	arg0._tempData = arg1
	arg0._type = arg0._tempData.type
	arg0._targetChoise = arg0._tempData.target_choise
	arg0._delay = arg0._tempData.arg_list.delay or 0
	arg0._timerList = {}
	arg0._timerIndex = 0
end

function var3.Execute(arg0, arg1)
	arg0._caster = var0.Battle.BattleTargetChoise.TargetFleetIndex(nil, {
		fleetPos = arg0._tempData.caster
	})[1]

	if arg0._delay > 0 then
		local var0
		local var1 = arg0._timerIndex + 1

		arg0._timerIndex = var1

		local function var2()
			if arg0._caster and arg0._caster:IsAlive() then
				arg0:SkillEffectHandler()
			end

			pg.TimeMgr.GetInstance():RemoveBattleTimer(var0)

			arg0._timerList[var1] = nil
		end

		var0 = pg.TimeMgr.GetInstance():AddBattleTimer("BattleSkill", -1, arg0._delay, var2, true)
		arg0._timerList[var1] = var0
	else
		arg0:SkillEffectHandler()
	end
end

function var3.SkillEffectHandler(arg0, arg1)
	return
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

function var3.GetTarget(arg0)
	if not arg0._targetChoise then
		return {}
	end

	local var0

	for iter0, iter1 in ipairs(arg0._targetChoise) do
		var0 = var0.Battle.BattleTargetChoise[iter1](arg0._caster, arg0._tempData.arg_list, var0)
	end

	return var0
end

function var3.GetCardPuzzleComponent(arg0)
	return arg0._card:GetClient()
end

function var3.GetFleetVO(arg0)
	return arg0:GetCardPuzzleComponent():GetFleetVO()
end

function var3.ConfigCard(arg0, arg1)
	arg0._card = arg1
end

function var3.SetQueue(arg0, arg1)
	arg0._queue = arg1
end

function var3.Finale(arg0)
	arg0._queue:EffectFinale(arg0)
end

function var3.HoldForInput(arg0)
	return false
end

function var3.MoveCardAfterCast(arg0)
	return var0.Battle.BattleFleetCardPuzzleComponent.CARD_PILE_INDEX_DISCARD
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
