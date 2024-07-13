ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleAirFighterCharacterFactory = singletonClass("BattleAirFighterCharacterFactory", var0_0.Battle.BattleAircraftCharacterFactory)
var0_0.Battle.BattleAirFighterCharacterFactory.__name = "BattleAirFighterCharacterFactory"

function var0_0.Battle.BattleAirFighterCharacterFactory.Ctor(arg0_1)
	var0_0.Battle.BattleAirFighterCharacterFactory.super.Ctor(arg0_1)

	arg0_1.HP_BAR_NAME = var0_0.Battle.BattleHPBarManager.HP_BAR_FOE
end

function var0_0.Battle.BattleAirFighterCharacterFactory.MakeCharacter(arg0_2)
	return var0_0.Battle.BattleAirFighterCharacter.New()
end

function var0_0.Battle.BattleAirFighterCharacterFactory.MakeModel(arg0_3, arg1_3)
	local function var0_3(arg0_4)
		arg1_3:AddModel(arg0_4)
		arg1_3:InitWeapon()

		local var0_4 = arg0_3:GetSceneMediator()

		arg1_3:CameraOrthogonal(var0_0.Battle.BattleCameraUtil.GetInstance():GetCamera())
		var0_4:AddAirCraftCharacter(arg1_3)
		arg0_3:MakeUIComponentContainer(arg1_3)
		arg0_3:MakeFXContainer(arg1_3)
		arg0_3:MakePopNumPool(arg1_3)
		arg0_3:MakeBloodBar(arg1_3)
		arg0_3:MakeShadow(arg1_3)
	end

	arg0_3:GetCharacterPool():InstAirCharacter(arg1_3:GetModleID(), function(arg0_5)
		var0_3(arg0_5)
	end)
end

function var0_0.Battle.BattleAirFighterCharacterFactory.MakeBloodBar(arg0_6, arg1_6)
	local var0_6 = arg0_6:GetHPBarPool():GetHPBar(arg0_6.HP_BAR_NAME)

	arg1_6:AddHPBar(var0_6)
	var0_6:SetActive(false)
	arg1_6:UpdateHPBarPosition()
end
