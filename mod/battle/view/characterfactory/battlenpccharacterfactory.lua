ys = ys or {}

local var0 = ys
local var1 = singletonClass("BattleNPCCharacterFactory", var0.Battle.BattleEnemyCharacterFactory)

var0.Battle.BattleNPCCharacterFactory = var1
var1.__name = "BattleNPCCharacterFactory"

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)

	arg0.HP_BAR_NAME = var0.Battle.BattleHPBarManager.HP_BAR_FOE
end

function var1.CreateCharacter(arg0, arg1)
	local var0 = arg1.extraInfo
	local var1 = arg1.unit
	local var2 = arg0:MakeCharacter()

	var2:SetFactory(arg0)
	var2:SetUnitData(var1)

	if var0.modleID then
		var2:SetModleID(var0.modleID)
	end

	if var0.HPColor then
		var2:SetHPColor(var0.HPColor)
	end

	if var0.isUnvisible then
		var2:SetUnvisible()
	end

	arg0:MakeModel(var2)

	return var2
end

function var1.MakeModel(arg0, arg1)
	local var0 = arg1:GetUnitData()

	local function var1(arg0)
		arg1:AddModel(arg0)

		local var0 = arg0:GetSceneMediator()

		arg1:CameraOrthogonal(var0.Battle.BattleCameraUtil.GetInstance():GetCamera())
		var0:AddEnemyCharacter(arg1)
		arg0:MakeUIComponentContainer(arg1)
		arg0:MakeFXContainer(arg1)
		arg0:MakePopNumPool(arg1)
		arg0:MakeBloodBar(arg1)
		arg0:MakeWaveFX(arg1)
		arg0:MakeSmokeFX(arg1)
		arg0:MakeArrowBar(arg1)

		local var1 = var0:GetTemplate().appear_fx

		for iter0, iter1 in ipairs(var1) do
			arg1:AddFX(iter1)
		end

		arg1:MakeVisible()
	end

	arg0:GetCharacterPool():InstCharacter(arg1:GetModleID(), function(arg0)
		var1(arg0)
	end)
end

function var1.MakeCharacter(arg0)
	return var0.Battle.BattleNPCCharacter.New()
end

function var1.MakeBloodBar(arg0, arg1)
	local var0 = arg0:GetHPBarPool():GetHPBar(arg0.HP_BAR_NAME)
	local var1 = var0.transform
	local var2 = arg1:GetHPColor()

	if var2 then
		var1:Find("blood"):GetComponent(typeof(Image)).color = var2
	end

	arg1:AddHPBar(var0)
	arg1:UpdateHPBarPosition()
end
