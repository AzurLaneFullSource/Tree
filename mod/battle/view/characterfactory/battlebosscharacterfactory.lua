ys = ys or {}

local var0_0 = ys
local var1_0 = singletonClass("BattleBossCharacterFactory", var0_0.Battle.BattleEnemyCharacterFactory)

var0_0.Battle.BattleBossCharacterFactory = var1_0
var1_0.__name = "BattleBossCharacterFactory"
var1_0.BOMB_FX_NAME = "Bossbomb"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1.HP_BAR_NAME = "BossBarContainer/heroBlood"
	arg0_1.DUAL_BAR_NAME = {
		"BossBarContainer/heroBlood_ivory",
		"BossBarContainer/heroBlood_ebony"
	}
end

function var1_0.CreateCharacter(arg0_2, arg1_2)
	local var0_2 = arg1_2.unit
	local var1_2 = arg0_2:MakeCharacter()

	var1_2:SetFactory(arg0_2)
	var1_2:SetUnitData(var0_2)
	var1_2:SetBossData(arg1_2.bossData)
	arg0_2:MakeModel(var1_2)
	arg0_2:MakeCastClock(var1_2)
	arg0_2:MakeBarrierClock(var1_2)

	return var1_2
end

function var1_0.MakeCharacter(arg0_3)
	return var0_0.Battle.BattleBossCharacter:New()
end

function var1_0.MakeBloodBar(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetSceneMediator()
	local var1_4 = arg1_4:GetBossIndex()

	if var1_4 then
		arg1_4:AddHPBar(var0_4:InstantiateCharacterComponent(arg0_4.DUAL_BAR_NAME[var1_4]))
	else
		arg1_4:AddHPBar(var0_4:InstantiateCharacterComponent(arg0_4.HP_BAR_NAME), true)
	end
end

function var1_0.MakeAimBiasBar(arg0_5, arg1_5)
	local var0_5 = arg0_5:GetHPBarPool():GetHPBar(var0_0.Battle.BattleHPBarManager.HP_BAR_FOE).transform

	setActive(var0_5:Find("bg"), false)
	setActive(var0_5:Find("blood"), false)
	arg1_5:AddAimBiasBar(var0_5)
	arg1_5:AddAimBiasFogFX()
end

function var1_0.RemoveCharacter(arg0_6, arg1_6)
	var1_0.super.RemoveCharacter(arg0_6, arg1_6)
end
