ys = ys or {}

local var0_0 = ys
local var1_0 = singletonClass("BattleNPCCharacterFactory", var0_0.Battle.BattleEnemyCharacterFactory)

var0_0.Battle.BattleNPCCharacterFactory = var1_0
var1_0.__name = "BattleNPCCharacterFactory"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1.HP_BAR_NAME = var0_0.Battle.BattleHPBarManager.HP_BAR_FOE
end

function var1_0.CreateCharacter(arg0_2, arg1_2)
	local var0_2 = arg1_2.extraInfo
	local var1_2 = arg1_2.unit
	local var2_2 = arg0_2:MakeCharacter()

	var2_2:SetFactory(arg0_2)
	var2_2:SetUnitData(var1_2)

	if var0_2.modleID then
		var2_2:SetModleID(var0_2.modleID)
	end

	if var0_2.HPColor then
		var2_2:SetHPColor(var0_2.HPColor)
	end

	if var0_2.isUnvisible then
		var2_2:SetUnvisible()
	end

	arg0_2:MakeModel(var2_2)

	return var2_2
end

function var1_0.MakeModel(arg0_3, arg1_3)
	local var0_3 = arg1_3:GetUnitData()

	local function var1_3(arg0_4)
		arg1_3:AddModel(arg0_4)

		local var0_4 = arg0_3:GetSceneMediator()

		arg1_3:CameraOrthogonal(var0_0.Battle.BattleCameraUtil.GetInstance():GetCamera())
		var0_4:AddEnemyCharacter(arg1_3)
		arg0_3:MakeUIComponentContainer(arg1_3)
		arg0_3:MakeFXContainer(arg1_3)
		arg0_3:MakePopNumPool(arg1_3)
		arg0_3:MakeBloodBar(arg1_3)
		arg0_3:MakeWaveFX(arg1_3)
		arg0_3:MakeSmokeFX(arg1_3)
		arg0_3:MakeArrowBar(arg1_3)

		local var1_4 = var0_3:GetTemplate().appear_fx

		for iter0_4, iter1_4 in ipairs(var1_4) do
			arg1_3:AddFX(iter1_4)
		end

		arg1_3:MakeVisible()
	end

	arg0_3:GetCharacterPool():InstCharacter(arg1_3:GetModleID(), function(arg0_5)
		var1_3(arg0_5)
	end)
end

function var1_0.MakeCharacter(arg0_6)
	return var0_0.Battle.BattleNPCCharacter.New()
end

function var1_0.MakeBloodBar(arg0_7, arg1_7)
	local var0_7 = arg0_7:GetHPBarPool():GetHPBar(arg0_7.HP_BAR_NAME)
	local var1_7 = var0_7.transform
	local var2_7 = arg1_7:GetHPColor()

	if var2_7 then
		var1_7:Find("blood"):GetComponent(typeof(Image)).color = var2_7
	end

	arg1_7:AddHPBar(var0_7)
	arg1_7:UpdateHPBarPosition()
end
