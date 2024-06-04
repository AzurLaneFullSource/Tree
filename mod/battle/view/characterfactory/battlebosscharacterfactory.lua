ys = ys or {}

local var0 = ys
local var1 = singletonClass("BattleBossCharacterFactory", var0.Battle.BattleEnemyCharacterFactory)

var0.Battle.BattleBossCharacterFactory = var1
var1.__name = "BattleBossCharacterFactory"
var1.BOMB_FX_NAME = "Bossbomb"

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)

	arg0.HP_BAR_NAME = "BossBarContainer/heroBlood"
	arg0.DUAL_BAR_NAME = {
		"BossBarContainer/heroBlood_ivory",
		"BossBarContainer/heroBlood_ebony"
	}
end

function var1.CreateCharacter(arg0, arg1)
	local var0 = arg1.unit
	local var1 = arg0:MakeCharacter()

	var1:SetFactory(arg0)
	var1:SetUnitData(var0)
	var1:SetBossData(arg1.bossData)
	arg0:MakeModel(var1)
	arg0:MakeCastClock(var1)
	arg0:MakeBarrierClock(var1)

	return var1
end

function var1.MakeCharacter(arg0)
	return var0.Battle.BattleBossCharacter:New()
end

function var1.MakeBloodBar(arg0, arg1)
	local var0 = arg0:GetSceneMediator()
	local var1 = arg1:GetBossIndex()

	if var1 then
		arg1:AddHPBar(var0:InstantiateCharacterComponent(arg0.DUAL_BAR_NAME[var1]))
	else
		arg1:AddHPBar(var0:InstantiateCharacterComponent(arg0.HP_BAR_NAME), true)
	end
end

function var1.MakeAimBiasBar(arg0, arg1)
	local var0 = arg0:GetHPBarPool():GetHPBar(var0.Battle.BattleHPBarManager.HP_BAR_FOE).transform

	setActive(var0:Find("bg"), false)
	setActive(var0:Find("blood"), false)
	arg1:AddAimBiasBar(var0)
	arg1:AddAimBiasFogFX()
end

function var1.RemoveCharacter(arg0, arg1)
	var1.super.RemoveCharacter(arg0, arg1)
end
