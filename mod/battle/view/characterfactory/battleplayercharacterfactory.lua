ys = ys or {}

local var0_0 = ys
local var1_0 = singletonClass("BattlePlayerCharacterFactory", var0_0.Battle.BattleCharacterFactory)

var0_0.Battle.BattlePlayerCharacterFactory = var1_0
var1_0.__name = "BattlePlayerCharacterFactory"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1.HP_BAR_NAME = var0_0.Battle.BattleHPBarManager.HP_BAR_FRIENDLY
	arg0_1.CD_BAR_NAME = "CDBarContainer/chargeWeaponCD"
	arg0_1.CHARGE_AREA_NAME = "ChargeAreaContainer/ChargeArea"
	arg0_1.ARROW_BAR_NAME = "EnemyArrowContainer/MainArrow"
	arg0_1.SUB_ARROW_BAR = "EnemyArrowContainer/SubArrow"
end

function var1_0.MakeCharacter(arg0_2)
	return var0_0.Battle.BattlePlayerCharacter.New()
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
		arg0_3:MakeArrowBar(arg1_3)
		arg0_3:MakeWaveFX(arg1_3)
		arg0_3:MakeSmokeFX(arg1_3)
		arg0_3:MakeSkinOrbit(arg1_3)

		local var1_4 = arg1_3:GetUnitData()

		if var1_4:GetCloak() then
			arg0_3:MakeCloakBar(arg1_3)
		end

		arg1_3:UpdateDiveInvisible()

		if #var1_4:GetTorpedoList() > 0 then
			arg0_3:MakeTorpedoTrack(arg1_3)
		end

		if var1_4:GetAimBias() and var1_4:GetAimBias():GetHost() == var1_4 then
			arg0_3:MakeAimBiasBar(arg1_3)
		end
	end

	arg0_3:GetCharacterPool():InstCharacter(arg1_3:GetModleID(), function(arg0_5)
		var0_3(arg0_5)
	end)
end

function var1_0.MakeBloodBar(arg0_6, arg1_6)
	local var0_6 = arg0_6:GetHPBarPool():GetHPBar(arg0_6.HP_BAR_NAME)
	local var1_6 = var0_6.transform

	LuaHelper.SetTFChildActive(var1_6, "torpedoIcons", true)
	arg1_6:AddHPBar(var0_6)
end

function var1_0.MakeAimBiasBar(arg0_7, arg1_7)
	local var0_7 = arg1_7._HPBarTf:Find("biasBar")

	arg1_7:AddAimBiasBar(var0_7)
end

function var1_0.MakeChargeArea(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetSceneMediator():InstantiateCharacterComponent(arg0_8.CHARGE_AREA_NAME)

	var0_8.transform.localEulerAngles = Vector3(60, 0, 0)

	arg1_8:AddChargeArea(var0_8)
end

function var1_0.MakeTorpedoTrack(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetFXPool():GetFX("SquareAlert", arg1_9:GetTf())

	arg1_9:AddTorpedoTrack(var0_9)
end

function var1_0.RemoveCharacter(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10:GetSceneMediator()

	if arg2_10 and arg2_10 ~= var0_0.Battle.BattleConst.UnitDeathReason.KILLED then
		-- block empty
	else
		var0_0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[var0_0.Battle.BattleConst.ShakeType.UNIT_DIE])
	end

	var1_0.super.RemoveCharacter(arg0_10, arg1_10, arg2_10)
end
