ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleMainFleetCharacterFactory = singletonClass("BattleMainFleetCharacterFactory", var0_0.Battle.BattlePlayerCharacterFactory)
var0_0.Battle.BattleMainFleetCharacterFactory.__name = "BattleMainFleetCharacterFactory"

local var1_0 = var0_0.Battle.BattleMainFleetCharacterFactory

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1.ARROW_BAR_NAME = "EnemyArrowContainer/MainArrow"
end

function var1_0.MakeCharacter(arg0_2)
	return var0_0.Battle.BattleMainFleetCharacter.New()
end

function var1_0.MakeModel(arg0_3, arg1_3, arg2_3)
	local function var0_3(arg0_4)
		arg1_3:AddModel(arg0_4)

		local var0_4 = arg0_3:GetSceneMediator()

		arg1_3:CameraOrthogonal(var0_0.Battle.BattleCameraUtil.GetInstance():GetCamera())
		var0_4:AddPlayerCharacter(arg1_3)
		arg0_3:MakeUIComponentContainer(arg1_3)
		arg0_3:MakeFXContainer(arg1_3)
		arg0_3:MakePopNumPool(arg1_3)
		arg0_3:MakeBloodBar(arg1_3)
		arg0_3:MakeWaveFX(arg1_3)
		arg0_3:MakeSmokeFX(arg1_3)
		arg0_3:MakeArrowBar(arg1_3)
	end

	arg0_3:GetCharacterPool():InstCharacter(arg1_3:GetModleID(), function(arg0_5)
		var0_3(arg0_5)
	end)
end
