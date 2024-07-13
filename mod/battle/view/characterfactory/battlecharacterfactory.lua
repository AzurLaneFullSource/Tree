ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = singletonClass("BattleCharacterFactory")

var0_0.Battle.BattleCharacterFactory = var2_0
var2_0.__name = "BattleCharacterFactory"
var2_0.HP_BAR_NAME = ""
var2_0.POPUP_NAME = "popup"
var2_0.TAG_NAME = "ChargeAreaContainer/LockTag"
var2_0.MOVE_WAVE_FX_POS = Vector3(0, -2.3, -1.5)
var2_0.MOVE_WAVE_FX_NAME = "movewave"
var2_0.SMOKE_FX_NAME = "smoke"
var2_0.BOMB_FX_NAME = "Bomb"
var2_0.DANCHUAN_MOVE_WAVE_FX_NAME = "danchuanlanghuazhong2"

function var2_0.Ctor(arg0_1)
	return
end

function var2_0.CreateCharacter(arg0_2, arg1_2)
	local var0_2 = arg1_2.unit
	local var1_2 = arg0_2:MakeCharacter()

	var1_2:SetFactory(arg0_2)
	var1_2:SetUnitData(var0_2)
	arg0_2:MakeModel(var1_2)

	return var1_2
end

function var2_0.GetSceneMediator(arg0_3)
	return var0_0.Battle.BattleState.GetInstance():GetMediatorByName(var0_0.Battle.BattleSceneMediator.__name)
end

function var2_0.GetFXPool(arg0_4)
	return var0_0.Battle.BattleFXPool.GetInstance()
end

function var2_0.GetCharacterPool(arg0_5)
	return var0_0.Battle.BattleResourceManager.GetInstance()
end

function var2_0.GetHPBarPool(arg0_6)
	return var0_0.Battle.BattleHPBarManager.GetInstance()
end

function var2_0.GetDivingFilterColor(arg0_7)
	local var0_7 = var0_0.Battle.BattleDataProxy.GetInstance()._mapId
	local var1_7 = var0_0.Battle.BattleDataFunction.GetDivingFilter(var0_7)

	return (Color.New(var1_7.r, var1_7.g, var1_7.b, var1_7.a))
end

function var2_0.GetFXContainerPool(arg0_8)
	return var0_0.Battle.BattleCharacterFXContainersPool.GetInstance()
end

function var2_0.MakeCharacter(arg0_9)
	return nil
end

function var2_0.MakeModel(arg0_10, arg1_10)
	return nil
end

function var2_0.MakeBloodBar(arg0_11, arg1_11)
	return nil
end

function var2_0.MakeAimBiasBar(arg0_12)
	return nil
end

function var2_0.SetHPBarWidth(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg1_13:GetUnitData():GetTemplate().hp_bar[1]
	local var1_13 = arg2_13.transform
	local var2_13 = var1_13.rect.height

	var1_13.sizeDelta = Vector2(var0_13, var2_13)

	local var3_13 = var1_13:Find("blood").transform
	local var4_13 = var3_13.rect.height

	var3_13.sizeDelta = Vector2(var0_13 + arg3_13 or 0, var4_13)
end

function var2_0.MakeUIComponentContainer(arg0_14, arg1_14)
	arg1_14:AddUIComponentContainer()
end

function var2_0.MakeFXContainer(arg0_15, arg1_15)
	local var0_15 = arg1_15:GetTf()
	local var1_15 = arg0_15:GetFXPool():PopCharacterAttachPoint()
	local var2_15 = var1_15.transform

	SetActive(var2_15, true)
	var2_15:SetParent(var0_15, false)

	var2_15.localPosition = Vector3.zero

	local var3_15 = var0_15.localEulerAngles

	var2_15.localEulerAngles = Vector3(var3_15.x * -1, var3_15.y, var3_15.z)

	local var4_15 = arg1_15:GetUnitData():GetTemplate().fx_container
	local var5_15 = {}

	for iter0_15, iter1_15 in ipairs(var0_0.Battle.BattleConst.FXContainerIndex) do
		local var6_15 = var4_15[iter0_15]

		var5_15[iter0_15] = Vector3(var6_15[1], var6_15[2], var6_15[3])
	end

	arg1_15:AddFXOffsets(var1_15, var5_15)
end

function var2_0.MakeShadow(arg0_16)
	return nil
end

function var2_0.MakeSmokeFX(arg0_17, arg1_17)
	local var0_17 = arg1_17:GetUnitData():GetTemplate().smoke
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		local var2_17 = iter1_17[2]
		local var3_17 = {}

		for iter2_17, iter3_17 in ipairs(var2_17) do
			local var4_17 = {}

			var4_17.unInitialize = true
			var4_17.resID = iter3_17[1]
			var4_17.pos = Vector3(iter3_17[2][1], iter3_17[2][2], iter3_17[2][3])
			var3_17[var4_17] = false
		end

		var1_17[iter0_17] = {
			active = false,
			rate = iter1_17[1] / 100,
			smokes = var3_17
		}
	end

	arg1_17:AddSmokeFXs(var1_17)
end

function var2_0.MakeWaveFX(arg0_18, arg1_18)
	arg1_18:AddWaveFX(arg0_18.MOVE_WAVE_FX_NAME)
end

function var2_0.MakePopNumPool(arg0_19, arg1_19)
	arg1_19:AddPopNumPool(arg0_19:GetSceneMediator():GetPopNumPool())
end

function var2_0.MakeTag(arg0_20, arg1_20)
	return (var0_0.Battle.BattleLockTag.New(arg0_20:GetSceneMediator():InstantiateCharacterComponent(arg0_20.TAG_NAME), arg1_20))
end

function var2_0.MakePopup(arg0_21)
	return (arg0_21:GetSceneMediator():InstantiateCharacterComponent(arg0_21.POPUP_NAME))
end

function var2_0.MakeArrowBar(arg0_22, arg1_22)
	local var0_22 = arg0_22:GetSceneMediator()

	arg1_22:AddArrowBar(var0_22:InstantiateCharacterComponent(arg0_22.ARROW_BAR_NAME))
	arg1_22:UpdateArrowBarPostition()
end

function var2_0.MakeCastClock(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetSceneMediator()

	arg1_23:AddCastClock(var0_23:InstantiateCharacterComponent("CastClockContainer/castClock"))
end

function var2_0.MakeBuffClock(arg0_24, arg1_24)
	local var0_24 = arg0_24:GetSceneMediator()

	arg1_24:AddBuffClock(var0_24:InstantiateCharacterComponent("CastClockContainer/buffClock"))
end

function var2_0.MakeBarrierClock(arg0_25, arg1_25)
	local var0_25 = arg0_25:GetSceneMediator()

	arg1_25:AddBarrierClock(var0_25:InstantiateCharacterComponent("CastClockContainer/shieldClock"))
end

function var2_0.MakeVigilantBar(arg0_26, arg1_26)
	local var0_26 = arg0_26:GetSceneMediator()

	arg1_26:AddVigilantBar(var0_26:InstantiateCharacterComponent("AntiSubVigilantContainer/antiSubMeter"))
	arg1_26:UpdateVigilantBarPosition()
end

function var2_0.MakeCloakBar(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetSceneMediator()

	arg1_27:AddCloakBar(var0_27:InstantiateCharacterComponent("CloakContainer/cloakMeter"))
	arg1_27:UpdateCloakBarPosition()
end

function var2_0.MakeSkinOrbit(arg0_28, arg1_28)
	local var0_28 = arg1_28:GetUnitData():GetSkinAttachmentInfo()

	if var0_28 then
		for iter0_28, iter1_28 in ipairs(var0_28) do
			local var1_28 = var0_0.Battle.BattleDataFunction.GetEquipSkinDataFromID(iter1_28)
			local var2_28 = var0_0.Battle.BattleResourceManager.GetInstance():InstOrbit(var1_28.orbit_combat)

			arg1_28:AddOrbit(var2_28, var1_28)
		end
	end
end

function var2_0.RemoveCharacter(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg1_29:GetUnitData():GetTemplate().nationality

	if var0_29 and table.contains(var1_0.SWEET_DEATH_NATIONALITY, var0_29) then
		-- block empty
	elseif arg2_29 and arg2_29 ~= var0_0.Battle.BattleConst.UnitDeathReason.KILLED then
		-- block empty
	else
		local var1_29 = arg1_29:GetUnitData():GetDeadFX()
		local var2_29, var3_29 = arg0_29:GetFXPool():GetFX(var1_29 or arg0_29.BOMB_FX_NAME)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var2_29, var3_29:Add(arg1_29:GetPosition()), true)
	end

	arg1_29:Dispose()
	arg0_29:GetFXPool():PushCharacterAttachPoint(arg1_29:GetAttachPoint())
end

function var2_0.SwitchCharacterSpine(arg0_30, arg1_30, arg2_30)
	local var0_30

	if arg2_30 then
		var0_30 = var0_0.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(arg2_30).prefab
	else
		var0_30 = arg1_30:GetModleID()
	end

	local function var1_30(arg0_31)
		arg1_30:SwitchModel(arg0_31, arg2_30)
		arg1_30:CameraOrthogonal(var0_0.Battle.BattleCameraUtil.GetInstance():GetCamera())
	end

	arg0_30:GetCharacterPool():InstCharacter(var0_30, function(arg0_32)
		var1_30(arg0_32)
	end)
end
