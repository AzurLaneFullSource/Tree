ys = ys or {}

local var0 = ys
local var1 = singletonClass("BattlePlayerCharacterFactory", var0.Battle.BattleCharacterFactory)

var0.Battle.BattlePlayerCharacterFactory = var1
var1.__name = "BattlePlayerCharacterFactory"

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)

	arg0.HP_BAR_NAME = var0.Battle.BattleHPBarManager.HP_BAR_FRIENDLY
	arg0.CD_BAR_NAME = "CDBarContainer/chargeWeaponCD"
	arg0.CHARGE_AREA_NAME = "ChargeAreaContainer/ChargeArea"
	arg0.ARROW_BAR_NAME = "EnemyArrowContainer/MainArrow"
	arg0.SUB_ARROW_BAR = "EnemyArrowContainer/SubArrow"
end

function var1.MakeCharacter(arg0)
	return var0.Battle.BattlePlayerCharacter.New()
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
		arg0:MakeArrowBar(arg1)
		arg0:MakeWaveFX(arg1)
		arg0:MakeSmokeFX(arg1)
		arg0:MakeSkinOrbit(arg1)

		local var1 = arg1:GetUnitData()

		if var1:GetCloak() then
			arg0:MakeCloakBar(arg1)
		end

		arg1:UpdateDiveInvisible()

		if #var1:GetTorpedoList() > 0 then
			arg0:MakeTorpedoTrack(arg1)
		end

		if var1:GetAimBias() and var1:GetAimBias():GetHost() == var1 then
			arg0:MakeAimBiasBar(arg1)
		end
	end

	arg0:GetCharacterPool():InstCharacter(arg1:GetModleID(), function(arg0)
		var0(arg0)
	end)
end

function var1.MakeBloodBar(arg0, arg1)
	local var0 = arg0:GetHPBarPool():GetHPBar(arg0.HP_BAR_NAME)
	local var1 = var0.transform

	LuaHelper.SetTFChildActive(var1, "torpedoIcons", true)
	arg1:AddHPBar(var0)
end

function var1.MakeAimBiasBar(arg0, arg1)
	local var0 = arg1._HPBarTf:Find("biasBar")

	arg1:AddAimBiasBar(var0)
end

function var1.MakeChargeArea(arg0, arg1)
	local var0 = arg0:GetSceneMediator():InstantiateCharacterComponent(arg0.CHARGE_AREA_NAME)

	var0.transform.localEulerAngles = Vector3(60, 0, 0)

	arg1:AddChargeArea(var0)
end

function var1.MakeTorpedoTrack(arg0, arg1)
	local var0 = arg0:GetFXPool():GetFX("SquareAlert", arg1:GetTf())

	arg1:AddTorpedoTrack(var0)
end

function var1.RemoveCharacter(arg0, arg1, arg2)
	local var0 = arg0:GetSceneMediator()

	if arg2 and arg2 ~= var0.Battle.BattleConst.UnitDeathReason.KILLED then
		-- block empty
	else
		var0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[var0.Battle.BattleConst.ShakeType.UNIT_DIE])
	end

	var1.super.RemoveCharacter(arg0, arg1, arg2)
end
