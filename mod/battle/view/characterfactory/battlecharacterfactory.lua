ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = singletonClass("BattleCharacterFactory")

var0.Battle.BattleCharacterFactory = var2
var2.__name = "BattleCharacterFactory"
var2.HP_BAR_NAME = ""
var2.POPUP_NAME = "popup"
var2.TAG_NAME = "ChargeAreaContainer/LockTag"
var2.MOVE_WAVE_FX_POS = Vector3(0, -2.3, -1.5)
var2.MOVE_WAVE_FX_NAME = "movewave"
var2.SMOKE_FX_NAME = "smoke"
var2.BOMB_FX_NAME = "Bomb"
var2.DANCHUAN_MOVE_WAVE_FX_NAME = "danchuanlanghuazhong2"

function var2.Ctor(arg0)
	return
end

function var2.CreateCharacter(arg0, arg1)
	local var0 = arg1.unit
	local var1 = arg0:MakeCharacter()

	var1:SetFactory(arg0)
	var1:SetUnitData(var0)
	arg0:MakeModel(var1)

	return var1
end

function var2.GetSceneMediator(arg0)
	return var0.Battle.BattleState.GetInstance():GetMediatorByName(var0.Battle.BattleSceneMediator.__name)
end

function var2.GetFXPool(arg0)
	return var0.Battle.BattleFXPool.GetInstance()
end

function var2.GetCharacterPool(arg0)
	return var0.Battle.BattleResourceManager.GetInstance()
end

function var2.GetHPBarPool(arg0)
	return var0.Battle.BattleHPBarManager.GetInstance()
end

function var2.GetDivingFilterColor(arg0)
	local var0 = var0.Battle.BattleDataProxy.GetInstance()._mapId
	local var1 = var0.Battle.BattleDataFunction.GetDivingFilter(var0)

	return (Color.New(var1.r, var1.g, var1.b, var1.a))
end

function var2.GetFXContainerPool(arg0)
	return var0.Battle.BattleCharacterFXContainersPool.GetInstance()
end

function var2.MakeCharacter(arg0)
	return nil
end

function var2.MakeModel(arg0, arg1)
	return nil
end

function var2.MakeBloodBar(arg0, arg1)
	return nil
end

function var2.MakeAimBiasBar(arg0)
	return nil
end

function var2.SetHPBarWidth(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetUnitData():GetTemplate().hp_bar[1]
	local var1 = arg2.transform
	local var2 = var1.rect.height

	var1.sizeDelta = Vector2(var0, var2)

	local var3 = var1:Find("blood").transform
	local var4 = var3.rect.height

	var3.sizeDelta = Vector2(var0 + arg3 or 0, var4)
end

function var2.MakeUIComponentContainer(arg0, arg1)
	arg1:AddUIComponentContainer()
end

function var2.MakeFXContainer(arg0, arg1)
	local var0 = arg1:GetTf()
	local var1 = arg0:GetFXPool():PopCharacterAttachPoint()
	local var2 = var1.transform

	SetActive(var2, true)
	var2:SetParent(var0, false)

	var2.localPosition = Vector3.zero

	local var3 = var0.localEulerAngles

	var2.localEulerAngles = Vector3(var3.x * -1, var3.y, var3.z)

	local var4 = arg1:GetUnitData():GetTemplate().fx_container
	local var5 = {}

	for iter0, iter1 in ipairs(var0.Battle.BattleConst.FXContainerIndex) do
		local var6 = var4[iter0]

		var5[iter0] = Vector3(var6[1], var6[2], var6[3])
	end

	arg1:AddFXOffsets(var1, var5)
end

function var2.MakeShadow(arg0)
	return nil
end

function var2.MakeSmokeFX(arg0, arg1)
	local var0 = arg1:GetUnitData():GetTemplate().smoke
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		local var2 = iter1[2]
		local var3 = {}

		for iter2, iter3 in ipairs(var2) do
			local var4 = {}

			var4.unInitialize = true
			var4.resID = iter3[1]
			var4.pos = Vector3(iter3[2][1], iter3[2][2], iter3[2][3])
			var3[var4] = false
		end

		var1[iter0] = {
			active = false,
			rate = iter1[1] / 100,
			smokes = var3
		}
	end

	arg1:AddSmokeFXs(var1)
end

function var2.MakeWaveFX(arg0, arg1)
	arg1:AddWaveFX(arg0.MOVE_WAVE_FX_NAME)
end

function var2.MakePopNumPool(arg0, arg1)
	arg1:AddPopNumPool(arg0:GetSceneMediator():GetPopNumPool())
end

function var2.MakeTag(arg0, arg1)
	return (var0.Battle.BattleLockTag.New(arg0:GetSceneMediator():InstantiateCharacterComponent(arg0.TAG_NAME), arg1))
end

function var2.MakePopup(arg0)
	return (arg0:GetSceneMediator():InstantiateCharacterComponent(arg0.POPUP_NAME))
end

function var2.MakeArrowBar(arg0, arg1)
	local var0 = arg0:GetSceneMediator()

	arg1:AddArrowBar(var0:InstantiateCharacterComponent(arg0.ARROW_BAR_NAME))
	arg1:UpdateArrowBarPostition()
end

function var2.MakeCastClock(arg0, arg1)
	local var0 = arg0:GetSceneMediator()

	arg1:AddCastClock(var0:InstantiateCharacterComponent("CastClockContainer/castClock"))
end

function var2.MakeBuffClock(arg0, arg1)
	local var0 = arg0:GetSceneMediator()

	arg1:AddBuffClock(var0:InstantiateCharacterComponent("CastClockContainer/buffClock"))
end

function var2.MakeBarrierClock(arg0, arg1)
	local var0 = arg0:GetSceneMediator()

	arg1:AddBarrierClock(var0:InstantiateCharacterComponent("CastClockContainer/shieldClock"))
end

function var2.MakeVigilantBar(arg0, arg1)
	local var0 = arg0:GetSceneMediator()

	arg1:AddVigilantBar(var0:InstantiateCharacterComponent("AntiSubVigilantContainer/antiSubMeter"))
	arg1:UpdateVigilantBarPosition()
end

function var2.MakeCloakBar(arg0, arg1)
	local var0 = arg0:GetSceneMediator()

	arg1:AddCloakBar(var0:InstantiateCharacterComponent("CloakContainer/cloakMeter"))
	arg1:UpdateCloakBarPosition()
end

function var2.MakeSkinOrbit(arg0, arg1)
	local var0 = arg1:GetUnitData():GetSkinAttachmentInfo()

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			local var1 = var0.Battle.BattleDataFunction.GetEquipSkinDataFromID(iter1)
			local var2 = var0.Battle.BattleResourceManager.GetInstance():InstOrbit(var1.orbit_combat)

			arg1:AddOrbit(var2, var1)
		end
	end
end

function var2.RemoveCharacter(arg0, arg1, arg2)
	local var0 = arg1:GetUnitData():GetTemplate().nationality

	if var0 and table.contains(var1.SWEET_DEATH_NATIONALITY, var0) then
		-- block empty
	elseif arg2 and arg2 ~= var0.Battle.BattleConst.UnitDeathReason.KILLED then
		-- block empty
	else
		local var1 = arg1:GetUnitData():GetDeadFX()
		local var2, var3 = arg0:GetFXPool():GetFX(var1 or arg0.BOMB_FX_NAME)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var2, var3:Add(arg1:GetPosition()), true)
	end

	arg1:Dispose()
	arg0:GetFXPool():PushCharacterAttachPoint(arg1:GetAttachPoint())
end

function var2.SwitchCharacterSpine(arg0, arg1, arg2)
	local var0

	if arg2 then
		var0 = var0.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(arg2).prefab
	else
		var0 = arg1:GetModleID()
	end

	local function var1(arg0)
		arg1:SwitchModel(arg0, arg2)
		arg1:CameraOrthogonal(var0.Battle.BattleCameraUtil.GetInstance():GetCamera())
	end

	arg0:GetCharacterPool():InstCharacter(var0, function(arg0)
		var1(arg0)
	end)
end
