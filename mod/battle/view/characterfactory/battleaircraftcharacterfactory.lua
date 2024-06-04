ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = singletonClass("BattleAircraftCharacterFactory", var0.Battle.BattleCharacterFactory)

var0.Battle.BattleAircraftCharacterFactory = var2
var2.__name = "BattleAircraftCharacterFactory"
var2.BOMB_FX_NAME = "feijibaozha"

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.MakeCharacter(arg0)
	return var0.Battle.BattleAircraftCharacter.New()
end

function var2.MakeModel(arg0, arg1)
	local var0 = function(arg0)
		arg1:AddModel(arg0)
		arg1:InitWeapon()

		local var0 = arg0:GetSceneMediator()

		arg1:CameraOrthogonal(var0.Battle.BattleCameraUtil.GetInstance():GetCamera())
		var0:AddAirCraftCharacter(arg1)
		arg0:MakeUIComponentContainer(arg1)
		arg0:MakeFXContainer(arg1)
		arg0:MakeShadow(arg1)

		if arg1:GetUnitData():GetIFF() == var1.FOE_CODE then
			arg0:MakePopNumPool(arg1)
			arg0:MakeBloodBar(arg1)
		end
	end

	arg0:GetCharacterPool():InstAirCharacter(arg1:GetModleID(), function(arg0)
		var0(arg0)
	end)
end

function var2.MakeBloodBar(arg0, arg1)
	local var0

	if arg1:GetUnitData():IsPlayerAircraft() then
		var0 = arg0:GetHPBarPool():GetHPBar(var0.Battle.BattleHPBarManager.HP_BAR_FRIENDLY)
	else
		var0 = arg0:GetHPBarPool():GetHPBar(var0.Battle.BattleHPBarManager.HP_BAR_FOE)
	end

	arg1:AddHPBar(var0)
	arg1:UpdateHPBarPosition()
end

function var2.SetHPBarWidth(arg0, arg1, arg2)
	local var0 = 40
	local var1 = arg1.transform
	local var2 = var1.rect.height

	var1.sizeDelta = Vector2(var0, var2)

	local var3 = var1:Find("blood").transform
	local var4 = var3.rect.height

	var3.sizeDelta = Vector2(var0 - arg2 or 0, var4)
end

function var2.MakeShadow(arg0, arg1)
	arg1:AddShadow()
	arg1:UpdateShadow()
end
