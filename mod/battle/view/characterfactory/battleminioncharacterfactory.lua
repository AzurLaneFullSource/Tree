ys = ys or {}

local var0_0 = ys
local var1_0 = singletonClass("BattleMinionCharacterFactory", var0_0.Battle.BattleCharacterFactory)

var0_0.Battle.BattleMinionCharacterFactory = var1_0
var1_0.__name = "BattleMinionCharacterFactory"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.MakeCharacter(arg0_2)
	return var0_0.Battle.BattleMinionCharacter.New()
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
		arg1_3:UpdateDiveInvisible(true)
		arg1_3:UpdateBlindInvisible()

		local var1_4 = var0_3:GetTemplate().appear_fx

		for iter0_4, iter1_4 in ipairs(var1_4) do
			arg1_3:AddFX(iter1_4)
		end

		if arg1_3:GetUnitData():GetAimBias() then
			arg0_3:MakeAimBiasBar(arg1_3)
		end
	end

	arg0_3:GetCharacterPool():InstCharacter(arg1_3:GetModleID(), function(arg0_5)
		var1_3(arg0_5)
	end)
end

function var1_0.MakeBloodBar(arg0_6, arg1_6)
	local var0_6 = arg1_6:GetUnitData()
	local var1_6

	if var0_6:GetIFF() == var0_0.Battle.BattleConfig.FRIENDLY_CODE then
		var1_6 = var0_0.Battle.BattleHPBarManager.HP_BAR_FRIENDLY
	else
		var1_6 = var0_0.Battle.BattleHPBarManager.HP_BAR_FOE
	end

	local var2_6 = arg0_6:GetHPBarPool():GetHPBar(var1_6)
	local var3_6 = var0_6:GetTemplate().icon_type
	local var4_6 = findTF(var2_6, "type")

	if var4_6 then
		SetActive(var4_6, false)
	end

	arg1_6:AddHPBar(var2_6)
	arg1_6:UpdateHPBarPosition()
end

function var1_0.MakeAimBiasBar(arg0_7, arg1_7)
	local var0_7 = arg1_7._HPBarTf:Find("biasBar")

	arg1_7:AddAimBiasBar(var0_7)
	arg1_7:AddAimBiasFogFX()
end

function var1_0.MakeWaveFX(arg0_8, arg1_8)
	local var0_8 = arg1_8:GetUnitData():GetTemplate().wave_fx

	if var0_8 ~= "" then
		arg1_8:AddWaveFX(var0_8)
	end
end

function var1_0.RemoveCharacter(arg0_9, arg1_9)
	var0_0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[var0_0.Battle.BattleConst.ShakeType.UNIT_DIE])
	var1_0.super.RemoveCharacter(arg0_9, arg1_9)
end
