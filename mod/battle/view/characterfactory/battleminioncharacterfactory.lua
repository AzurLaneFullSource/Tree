ys = ys or {}

local var0 = ys
local var1 = singletonClass("BattleMinionCharacterFactory", var0.Battle.BattleCharacterFactory)

var0.Battle.BattleMinionCharacterFactory = var1
var1.__name = "BattleMinionCharacterFactory"

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.MakeCharacter(arg0)
	return var0.Battle.BattleMinionCharacter.New()
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
		arg1:UpdateDiveInvisible(true)
		arg1:UpdateBlindInvisible()

		local var1 = var0:GetTemplate().appear_fx

		for iter0, iter1 in ipairs(var1) do
			arg1:AddFX(iter1)
		end

		if arg1:GetUnitData():GetAimBias() then
			arg0:MakeAimBiasBar(arg1)
		end
	end

	arg0:GetCharacterPool():InstCharacter(arg1:GetModleID(), function(arg0)
		var1(arg0)
	end)
end

function var1.MakeBloodBar(arg0, arg1)
	local var0 = arg1:GetUnitData()
	local var1

	if var0:GetIFF() == var0.Battle.BattleConfig.FRIENDLY_CODE then
		var1 = var0.Battle.BattleHPBarManager.HP_BAR_FRIENDLY
	else
		var1 = var0.Battle.BattleHPBarManager.HP_BAR_FOE
	end

	local var2 = arg0:GetHPBarPool():GetHPBar(var1)
	local var3 = var0:GetTemplate().icon_type
	local var4 = findTF(var2, "type")

	if var4 then
		SetActive(var4, false)
	end

	arg1:AddHPBar(var2)
	arg1:UpdateHPBarPosition()
end

function var1.MakeAimBiasBar(arg0, arg1)
	local var0 = arg1._HPBarTf:Find("biasBar")

	arg1:AddAimBiasBar(var0)
	arg1:AddAimBiasFogFX()
end

function var1.MakeWaveFX(arg0, arg1)
	local var0 = arg1:GetUnitData():GetTemplate().wave_fx

	if var0 ~= "" then
		arg1:AddWaveFX(var0)
	end
end

function var1.RemoveCharacter(arg0, arg1)
	var0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[var0.Battle.BattleConst.ShakeType.UNIT_DIE])
	var1.super.RemoveCharacter(arg0, arg1)
end
