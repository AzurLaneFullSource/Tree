ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = singletonClass("BattleAircraftCharacterFactory", var0_0.Battle.BattleCharacterFactory)

var0_0.Battle.BattleAircraftCharacterFactory = var2_0
var2_0.__name = "BattleAircraftCharacterFactory"
var2_0.BOMB_FX_NAME = "feijibaozha"

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.MakeCharacter(arg0_2)
	return var0_0.Battle.BattleAircraftCharacter.New()
end

function var2_0.MakeModel(arg0_3, arg1_3)
	local function var0_3(arg0_4)
		arg1_3:AddModel(arg0_4)
		arg1_3:InitWeapon()

		local var0_4 = arg0_3:GetSceneMediator()

		arg1_3:CameraOrthogonal(var0_0.Battle.BattleCameraUtil.GetInstance():GetCamera())
		var0_4:AddAirCraftCharacter(arg1_3)
		arg0_3:MakeUIComponentContainer(arg1_3)
		arg0_3:MakeFXContainer(arg1_3)
		arg0_3:MakeShadow(arg1_3)

		if arg1_3:GetUnitData():GetIFF() == var1_0.FOE_CODE then
			arg0_3:MakePopNumPool(arg1_3)
			arg0_3:MakeBloodBar(arg1_3)
		end
	end

	arg0_3:GetCharacterPool():InstAirCharacter(arg1_3:GetModleID(), function(arg0_5)
		var0_3(arg0_5)
	end)
end

function var2_0.MakeBloodBar(arg0_6, arg1_6)
	local var0_6

	if arg1_6:GetUnitData():IsPlayerAircraft() then
		var0_6 = arg0_6:GetHPBarPool():GetHPBar(var0_0.Battle.BattleHPBarManager.HP_BAR_FRIENDLY)
	else
		var0_6 = arg0_6:GetHPBarPool():GetHPBar(var0_0.Battle.BattleHPBarManager.HP_BAR_FOE)
	end

	arg1_6:AddHPBar(var0_6)
	arg1_6:UpdateHPBarPosition()
end

function var2_0.SetHPBarWidth(arg0_7, arg1_7, arg2_7)
	local var0_7 = 40
	local var1_7 = arg1_7.transform
	local var2_7 = var1_7.rect.height

	var1_7.sizeDelta = Vector2(var0_7, var2_7)

	local var3_7 = var1_7:Find("blood").transform
	local var4_7 = var3_7.rect.height

	var3_7.sizeDelta = Vector2(var0_7 - arg2_7 or 0, var4_7)
end

function var2_0.MakeShadow(arg0_8, arg1_8)
	arg1_8:AddShadow()
	arg1_8:UpdateShadow()
end
