ys = ys or {}

local var0 = ys

var0.Battle.BattleMainFleetCharacterFactory = singletonClass("BattleMainFleetCharacterFactory", var0.Battle.BattlePlayerCharacterFactory)
var0.Battle.BattleMainFleetCharacterFactory.__name = "BattleMainFleetCharacterFactory"

local var1 = var0.Battle.BattleMainFleetCharacterFactory

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)

	arg0.ARROW_BAR_NAME = "EnemyArrowContainer/MainArrow"
end

function var1.MakeCharacter(arg0)
	return var0.Battle.BattleMainFleetCharacter.New()
end

function var1.MakeModel(arg0, arg1, arg2)
	local var0 = function(arg0)
		arg1:AddModel(arg0)

		local var0 = arg0:GetSceneMediator()

		arg1:CameraOrthogonal(var0.Battle.BattleCameraUtil.GetInstance():GetCamera())
		var0:AddPlayerCharacter(arg1)
		arg0:MakeUIComponentContainer(arg1)
		arg0:MakeFXContainer(arg1)
		arg0:MakePopNumPool(arg1)
		arg0:MakeBloodBar(arg1)
		arg0:MakeWaveFX(arg1)
		arg0:MakeSmokeFX(arg1)
		arg0:MakeArrowBar(arg1)
	end

	arg0:GetCharacterPool():InstCharacter(arg1:GetModleID(), function(arg0)
		var0(arg0)
	end)
end
