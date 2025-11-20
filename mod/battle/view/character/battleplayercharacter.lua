ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleCardPuzzleEvent
local var5_0 = class("BattlePlayerCharacter", var0_0.Battle.BattleCharacter)

var0_0.Battle.BattlePlayerCharacter = var5_0
var5_0.__name = "BattlePlayerCharacter"

function var5_0.Ctor(arg0_1)
	var5_0.super.Ctor(arg0_1)
end

function var5_0.SetUnitData(arg0_2, arg1_2)
	var5_0.super.SetUnitData(arg0_2, arg1_2)

	arg0_2._chargeWeaponList = {}

	for iter0_2, iter1_2 in ipairs(arg1_2:GetChargeList()) do
		arg0_2:InitChargeWeapon(iter1_2)
	end

	arg0_2._torpedoWeaponList = {}

	for iter2_2, iter3_2 in ipairs(arg1_2:GetTorpedoList()) do
		arg0_2:InitTorpedoWeapon(iter3_2)
	end

	arg0_2._airAssistList = {}

	local var0_2 = arg1_2:GetAirAssistList()

	if var0_2 ~= nil then
		for iter4_2, iter5_2 in ipairs(var0_2) do
			arg0_2:InitAirAssit(iter5_2)
		end
	end

	arg0_2._weaponSectorList = {}
end

function var5_0.AddUnitEvent(arg0_3)
	var5_0.super.AddUnitEvent(arg0_3)
	arg0_3._unitData:RegisterEventListener(arg0_3, var1_0.WILL_DIE, arg0_3.onWillDie)
	arg0_3._unitData:RegisterEventListener(arg0_3, var1_0.INIT_COOL_DOWN, arg0_3.onInitWeaponCD)
	arg0_3._unitData:RegisterEventListener(arg0_3, var1_0.WEAPON_SECTOR, arg0_3.onActiveWeaponSector)
	arg0_3._unitData:RegisterEventListener(arg0_3, var1_0.CREATE_POINT_AIR_STRIKE, arg0_3.onCreatePointAirStrike)

	if arg0_3._unitData:GetFleetRangeAAWeapon() then
		arg0_3:RegisterWeaponListener(arg0_3._unitData:GetFleetRangeAAWeapon())
	end
end

function var5_0.RemoveUnitEvent(arg0_4)
	if arg0_4._unitData:GetFleetRangeAAWeapon() then
		arg0_4:UnregisterWeaponListener(arg0_4._unitData:GetFleetRangeAAWeapon())
	end

	for iter0_4, iter1_4 in ipairs(arg0_4._chargeWeaponList) do
		iter1_4:UnregisterEventListener(arg0_4, var1_0.CHARGE_WEAPON_FINISH)
		arg0_4:UnregisterWeaponListener(iter1_4)
	end

	for iter2_4, iter3_4 in ipairs(arg0_4._torpedoWeaponList) do
		iter3_4:UnregisterEventListener(arg0_4, var1_0.TORPEDO_WEAPON_FIRE)
		iter3_4:UnregisterEventListener(arg0_4, var1_0.TORPEDO_WEAPON_PREPAR)
		iter3_4:UnregisterEventListener(arg0_4, var1_0.TORPEDO_WEAPON_CANCEL)
		iter3_4:UnregisterEventListener(arg0_4, var1_0.TORPEDO_WEAPON_READY)
		arg0_4:UnregisterWeaponListener(iter3_4)
	end

	for iter4_4, iter5_4 in ipairs(arg0_4._airAssistList) do
		iter5_4:UnregisterEventListener(arg0_4, var1_0.CHARGE_WEAPON_FINISH)
		iter5_4:UnregisterEventListener(arg0_4, var1_0.FIRE)
	end

	arg0_4._unitData:UnregisterEventListener(arg0_4, var1_0.WILL_DIE)
	arg0_4._unitData:UnregisterEventListener(arg0_4, var1_0.INIT_COOL_DOWN)
	arg0_4._unitData:UnregisterEventListener(arg0_4, var1_0.CREATE_POINT_AIR_STRIKE)
	var5_0.super.RemoveUnitEvent(arg0_4)
end

function var5_0.Update(arg0_5)
	var5_0.super.Update(arg0_5)
	arg0_5:UpdatePosition()
	arg0_5:UpdateMatrix()

	if not arg0_5._inViewArea or not arg0_5._alwaysHideArrow then
		arg0_5:UpdateArrowBarPosition()
	end

	if arg0_5._unitData:GetOxyState() then
		arg0_5:UpdateOxygenBar()
	end

	if arg0_5._cloakBar then
		arg0_5._cloakBar:UpdateCloakProgress()
		arg0_5._hpCloakBar:UpdateCloakProgress()

		if not arg0_5._inViewArea or not arg0_5._alwaysHideArrow then
			arg0_5:UpdateCloakBarPosition()
		end
	end
end

function var5_0.UpdateArrowBarPosition(arg0_6)
	var5_0.super.UpdateArrowBarPosition(arg0_6)

	local var0_6 = arg0_6._unitData:GetFleetVO():GetLeftBoundDistance()

	if arg0_6._arrowCG and var0_6 then
		if var0_6 < 6 then
			arg0_6._arrowCG.alpha = 0.1
		else
			arg0_6._arrowCG.alpha = 1
		end
	end

	if arg0_6._unitData:GetGroupID() and table.contains(var2_0.MIRROR_QICON_SHIP_GROUP, arg0_6._unitData:GetGroupID()) then
		local var1_6

		if arg0_6._arrowVector.x > 0 then
			var1_6 = arg0_6._unitData:GetTemplate().painting .. var2_0.MIRROR_QICON_KEY
		else
			var1_6 = arg0_6._unitData:GetTemplate().painting
		end

		local var2_6 = var0_0.Battle.BattleResourceManager.GetInstance():GetCharacterQIcon(var1_6)

		setImageSprite(findTF(arg0_6._arrowBar, "icon"), var2_6)
	end
end

function var5_0.UpdateHpBar(arg0_7)
	var5_0.super.UpdateHpBar(arg0_7)

	if arg0_7._unitData.__name == var0_0.Battle.BattleCardPuzzlePlayerUnit.__name then
		arg0_7:UpdateVectorBar()
	end
end

function var5_0.UpdateOxygenBar(arg0_8)
	arg0_8._oxygenSlider.value = arg0_8._unitData:GetOxygenProgress()
end

function var5_0.UpdateVectorBar(arg0_9)
	local var0_9 = arg0_9._unitData:GetHPRate()

	arg0_9._vectorProgress.fillAmount = var0_9
end

function var5_0.UpdateUIComponentPosition(arg0_10)
	var5_0.super.UpdateUIComponentPosition(arg0_10)

	local var0_10 = arg0_10._unitData:GetBornPosition()

	if var0_10 then
		if not arg0_10._referenceVectorBorn then
			arg0_10._referenceVectorBorn = Vector3.New(var0_10.x, var0_10.y, var0_10.z)
		else
			arg0_10._referenceVectorBorn:Set(var0_10.x, var0_10.y, var0_10.z)
		end

		var0_0.Battle.BattleVariable.CameraPosToUICameraByRef(arg0_10._referenceVectorBorn)
	end
end

function var5_0.AddArrowBar(arg0_11, arg1_11)
	var5_0.super.AddArrowBar(arg0_11, arg1_11)

	arg0_11._arrowCG = GetOrAddComponent(arg0_11._arrowBarTf, typeof(CanvasGroup))
	arg0_11._vectorProgress = arg0_11._arrowBarTf:Find("HPBar/HPProgress"):GetComponent(typeof(Image))

	local var0_11 = var0_0.Battle.BattleResourceManager.GetInstance():GetCharacterQIcon(arg0_11._unitData:GetTemplate().painting)

	setImageSprite(findTF(arg0_11._arrowBar, "icon"), var0_11)

	if arg0_11._unitData:IsMainFleetUnit() and arg0_11._unitData:GetFleetVO():GetMainList()[3] == arg0_11._unitData then
		arg1_11.transform:SetSiblingIndex(arg1_11.transform.parent.childCount - 3)
	end

	arg0_11:UpdateVectorBar()
end

function var5_0.GetReferenceVector(arg0_12, arg1_12)
	if arg0_12._inViewArea then
		return var5_0.super.GetReferenceVector(arg0_12, arg1_12)
	else
		return arg0_12._arrowVector
	end
end

function var5_0.DisableWeaponTrack(arg0_13)
	if arg0_13._torpedoTrack then
		arg0_13._torpedoTrack:SetActive(false)
	end
end

function var5_0.SonarAcitve(arg0_14, arg1_14)
	if var0_0.Battle.BattleAttr.HasSonar(arg0_14._unitData) then
		arg0_14._sonar:GetComponent(typeof(Animator)).enabled = arg1_14
	end
end

function var5_0.UpdateDiveInvisible(arg0_15)
	var5_0.super.UpdateDiveInvisible(arg0_15)

	local var0_15 = arg0_15._unitData:GetDiveInvisible()

	SetActive(arg0_15._diveMark, var0_15)

	local var1_15 = arg0_15._unitData:GetOxygenVisible()

	SetActive(arg0_15._oxygenBar, var1_15)
end

function var5_0.Dispose(arg0_16)
	arg0_16._torpedoIcons = nil
	arg0_16._renderer = nil
	arg0_16._sonar = nil
	arg0_16._diveMark = nil
	arg0_16._oxygenBar = nil
	arg0_16._oxygenSlider = nil

	Object.Destroy(arg0_16._arrowBar)

	for iter0_16, iter1_16 in ipairs(arg0_16._weaponSectorList) do
		iter1_16:Dispose()
	end

	arg0_16._weaponSectorList = nil

	var5_0.super.Dispose(arg0_16)
end

function var5_0.GetModleID(arg0_17)
	return arg0_17._unitData:GetTemplate().prefab
end

function var5_0.OnUpdateHP(arg0_18, arg1_18)
	var5_0.super.OnUpdateHP(arg0_18, arg1_18)
	arg0_18:UpdateVectorBar()
end

function var5_0.onInitWeaponCD(arg0_19, arg1_19)
	arg0_19:onTorepedoReady()
end

function var5_0.onCastBlink(arg0_20, arg1_20)
	local var0_20 = arg1_20.Data.callbackFunc
	local var1_20 = arg1_20.Data.timeScale

	arg0_20:AddFX("jineng", false, var1_20, var0_20)
end

function var5_0.onTorpedoWeaponFire(arg0_21, arg1_21)
	arg0_21._torpedoTrack:SetActive(false)
	arg0_21:onTorepedoReady()
end

function var5_0.onTorpedoPrepar(arg0_22, arg1_22)
	arg0_22._torpedoTrack:SetActive(true)

	local var0_22 = var0_0.Battle.BattleDataFunction.GetBulletTmpDataFromID(arg1_22.Dispatcher:GetTemplateData().bullet_ID[1])

	arg0_22._torpedoTrack:SetScale(Vector3(var0_22.range / var2_0.SPINE_SCALE, var0_22.cld_box[3] / var2_0.SPINE_SCALE, 1))
end

function var5_0.onTorpedoCancel(arg0_23, arg1_23)
	arg0_23._torpedoTrack:SetActive(false)
end

function var5_0.onTorepedoReady(arg0_24, arg1_24)
	local var0_24 = 0

	for iter0_24, iter1_24 in ipairs(arg0_24._torpedoWeaponList) do
		if iter1_24:GetCurrentState() == iter1_24.STATE_READY then
			var0_24 = var0_24 + 1
		end
	end

	for iter2_24 = 1, var0_0.Battle.BattleConst.MAX_EQUIPMENT_COUNT do
		LuaHelper.SetTFChildActive(arg0_24._torpedoIcons, "torpedo_" .. iter2_24, iter2_24 <= var0_24)
	end
end

function var5_0.onAAMissileWeaponFire(arg0_25, arg1_25)
	arg0_25:onAAMissileReady()
end

function var5_0.onWillDie(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg0_26._smokeList) do
		if iter1_26.active == true then
			iter1_26.active = false

			local var0_26 = iter1_26.smokes

			for iter2_26, iter3_26 in pairs(var0_26) do
				if iter2_26.unInitialize then
					-- block empty
				else
					SetActive(iter3_26, false)
				end
			end
		end
	end
end

function var5_0.AddHPBar(arg0_27, arg1_27)
	var5_0.super.AddHPBar(arg0_27, arg1_27)

	arg0_27._torpedoIcons = arg0_27._HPBarTf:Find("torpedoIcons")

	if #arg0_27._torpedoWeaponList <= 0 then
		arg0_27._torpedoIcons.gameObject:SetActive(false)
	end

	arg0_27._sonar = arg0_27._HPBarTf:Find("sonarMark")

	if var0_0.Battle.BattleAttr.HasSonar(arg0_27._unitData) then
		arg0_27._sonar.gameObject:SetActive(true)
	else
		arg0_27._sonar.gameObject:SetActive(false)
	end

	arg0_27._diveMark = arg0_27._HPBarTf:Find("diveMark")
	arg0_27._oxygenBar = arg0_27._HPBarTf:Find("oxygenBar")
	arg0_27._oxygenSlider = arg0_27._oxygenBar:Find("oxygen"):GetComponent(typeof(Slider))
	arg0_27._oxygenSlider.value = 1

	arg0_27:onTorepedoReady()
end

function var5_0.AddModel(arg0_28, arg1_28)
	var5_0.super.AddModel(arg0_28, arg1_28)

	arg0_28._renderer = arg0_28:GetTf():GetComponent(typeof(Renderer))
end

function var5_0.AddChargeArea(arg0_29, arg1_29)
	arg0_29._chargeWeaponArea = var0_0.Battle.BattleChargeArea.New(arg1_29)
end

function var5_0.AddTorpedoTrack(arg0_30, arg1_30)
	arg0_30._torpedoTrack = var0_0.Battle.BossSkillAlert.New(arg1_30)

	arg0_30._torpedoTrack:SetActive(false)
end

function var5_0.AddCloakBar(arg0_31, arg1_31)
	var5_0.super.AddCloakBar(arg0_31, arg1_31)

	local var0_31 = arg0_31._HPBarTf:Find("cloakBar")

	arg0_31._hpCloakBar = var0_0.Battle.BattleCloakBar.New(var0_31, var0_0.Battle.BattleCloakBar.FORM_BAR)

	arg0_31._hpCloakBar:ConfigCloak(arg0_31._unitData:GetCloak())
	arg0_31._hpCloakBar:UpdateCloakProgress()
	arg0_31._hpCloakBar:SetActive(true)
end

function var5_0.onUpdateCloakConfig(arg0_32, arg1_32)
	var5_0.super.onUpdateCloakConfig(arg0_32, arg1_32)
	arg0_32._hpCloakBar:UpdateCloakConfig()
end

function var5_0.onUpdateCloakLock(arg0_33, arg1_33)
	var5_0.super.onUpdateCloakLock(arg0_33, arg1_33)
	arg0_33._hpCloakBar:UpdateCloakLock()
end

function var5_0.InitChargeWeapon(arg0_34, arg1_34)
	arg0_34._chargeWeaponList[#arg0_34._chargeWeaponList + 1] = arg1_34

	arg0_34:RegisterWeaponListener(arg1_34)
	arg1_34:RegisterEventListener(arg0_34, var1_0.CHARGE_WEAPON_FINISH, arg0_34.onCastBlink)
end

function var5_0.InitAirAssit(arg0_35, arg1_35)
	arg0_35._airAssistList[#arg0_35._airAssistList + 1] = arg1_35

	arg1_35:RegisterEventListener(arg0_35, var1_0.CHARGE_WEAPON_FINISH, arg0_35.onCastBlink)
	arg1_35:RegisterEventListener(arg0_35, var1_0.FIRE, arg0_35.onCannonFire)
end

function var5_0.InitTorpedoWeapon(arg0_36, arg1_36)
	arg0_36._torpedoWeaponList[#arg0_36._torpedoWeaponList + 1] = arg1_36

	arg0_36:RegisterWeaponListener(arg1_36)
	arg1_36:RegisterEventListener(arg0_36, var1_0.TORPEDO_WEAPON_FIRE, arg0_36.onTorpedoWeaponFire)
	arg1_36:RegisterEventListener(arg0_36, var1_0.TORPEDO_WEAPON_PREPAR, arg0_36.onTorpedoPrepar)
	arg1_36:RegisterEventListener(arg0_36, var1_0.TORPEDO_WEAPON_CANCEL, arg0_36.onTorpedoCancel)
	arg1_36:RegisterEventListener(arg0_36, var1_0.TORPEDO_WEAPON_READY, arg0_36.onTorepedoReady)
end

function var5_0.onActiveWeaponSector(arg0_37, arg1_37)
	local var0_37 = arg1_37.Data
	local var1_37 = var0_37.isActive
	local var2_37 = var0_37.weapon

	if var1_37 then
		local var3_37 = arg0_37._factory:GetFXPool():GetCharacterFX("weaponrange", arg0_37).transform
		local var4_37 = var0_0.Battle.BattleWeaponRangeSector.New(var3_37)

		var4_37:ConfigHost(arg0_37._unitData, var2_37)

		arg0_37._weaponSectorList[var2_37] = var4_37
	else
		arg0_37._weaponSectorList[var2_37]:Dispose()

		arg0_37._weaponSectorList[var2_37] = nil
	end
end

function var5_0.onCreatePointAirStrike(arg0_38, arg1_38)
	local var0_38 = arg1_38.Data.weapon

	arg0_38:InitChargeWeapon(var0_38)
end

function var5_0.OnAnimatorTrigger(arg0_39)
	arg0_39._unitData:CharacterActionTriggerCallback()
end

function var5_0.OnAnimatorEnd(arg0_40)
	arg0_40._unitData:CharacterActionEndCallback()
end

function var5_0.OnAnimatorStart(arg0_41)
	arg0_41._unitData:CharacterActionStartCallback()
end
