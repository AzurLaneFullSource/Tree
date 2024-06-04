ys = ys or {}

local var0 = ys

var0.Battle.BattleAirFighterCharacterFactory = singletonClass("BattleAirFighterCharacterFactory", var0.Battle.BattleAircraftCharacterFactory)
var0.Battle.BattleAirFighterCharacterFactory.__name = "BattleAirFighterCharacterFactory"

function var0.Battle.BattleAirFighterCharacterFactory.Ctor(arg0)
	var0.Battle.BattleAirFighterCharacterFactory.super.Ctor(arg0)

	arg0.HP_BAR_NAME = var0.Battle.BattleHPBarManager.HP_BAR_FOE
end

function var0.Battle.BattleAirFighterCharacterFactory.MakeCharacter(arg0)
	return var0.Battle.BattleAirFighterCharacter.New()
end

function var0.Battle.BattleAirFighterCharacterFactory.MakeModel(arg0, arg1)
	local var0 = function(arg0)
		arg1:AddModel(arg0)
		arg1:InitWeapon()

		local var0 = arg0:GetSceneMediator()

		arg1:CameraOrthogonal(var0.Battle.BattleCameraUtil.GetInstance():GetCamera())
		var0:AddAirCraftCharacter(arg1)
		arg0:MakeUIComponentContainer(arg1)
		arg0:MakeFXContainer(arg1)
		arg0:MakePopNumPool(arg1)
		arg0:MakeBloodBar(arg1)
		arg0:MakeShadow(arg1)
	end

	arg0:GetCharacterPool():InstAirCharacter(arg1:GetModleID(), function(arg0)
		var0(arg0)
	end)
end

function var0.Battle.BattleAirFighterCharacterFactory.MakeBloodBar(arg0, arg1)
	local var0 = arg0:GetHPBarPool():GetHPBar(arg0.HP_BAR_NAME)

	arg1:AddHPBar(var0)
	var0:SetActive(false)
	arg1:UpdateHPBarPosition()
end
