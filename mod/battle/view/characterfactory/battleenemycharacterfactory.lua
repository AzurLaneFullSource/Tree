ys = ys or {}

local var0_0 = ys
local var1_0 = singletonClass("BattleEnemyCharacterFactory", var0_0.Battle.BattleCharacterFactory)

var0_0.Battle.BattleEnemyCharacterFactory = var1_0
var1_0.__name = "BattleEnemyCharacterFactory"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1.HP_BAR_NAME = var0_0.Battle.BattleHPBarManager.HP_BAR_FOE
	arg0_1.ARROW_BAR_NAME = "EnemyArrowContainer/EnemyArrow"
end

function var1_0.MakeCharacter(arg0_2)
	return var0_0.Battle.BattleEnemyCharacter.New()
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
		arg1_3:UpdateDiveInvisible(true)
		arg1_3:UpdateCharacterForceDetected()
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

function var1_0.MakeArrowBar(arg0_6, arg1_6)
	local var0_6 = arg0_6:GetArrowPool():GetArrow()

	arg1_6:AddArrowBar(var0_6)
	arg1_6:UpdateArrowBarPostition()
end

function var1_0.GetArrowPool(arg0_7)
	return var0_0.Battle.BattleArrowManager.GetInstance()
end

function var1_0.MakeBloodBar(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetHPBarPool():GetHPBar(arg0_8.HP_BAR_NAME)
	local var1_8 = arg1_8:GetUnitData():GetTemplate().icon_type
	local var2_8 = findTF(var0_8, "type")

	if var1_8 ~= 0 then
		local var3_8 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_8:GetUnitData():GetTemplate().icon_type))

		setImageSprite(var2_8, var3_8, true)

		local var4_8 = findTF(var2_8, "type")

		setImageSprite(var4_8, var3_8, true)
		SetActive(var2_8, true)
	else
		SetActive(var2_8, false)
	end

	arg1_8:AddHPBar(var0_8)
	arg1_8:UpdateHPBarPosition()
end

function var1_0.MakeAimBiasBar(arg0_9, arg1_9)
	local var0_9 = arg1_9._HPBarTf:Find("biasBar")

	arg1_9:AddAimBiasBar(var0_9)
	arg1_9:AddAimBiasFogFX()
end

function var1_0.MakeWaveFX(arg0_10, arg1_10)
	local var0_10 = arg1_10:GetUnitData():GetTemplate().wave_fx

	if var0_10 ~= "" then
		arg1_10:AddWaveFX(var0_10)
	end
end

function var1_0.RemoveCharacter(arg0_11, arg1_11)
	var0_0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[var0_0.Battle.BattleConst.ShakeType.UNIT_DIE])
	var1_0.super.RemoveCharacter(arg0_11, arg1_11)
end
