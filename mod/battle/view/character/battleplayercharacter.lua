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
	var5_0.super.RemoveUnitEvent(arg0_4)
end

function var5_0.Update(arg0_5)
	var5_0.super.Update(arg0_5)
	arg0_5:UpdatePosition()
	arg0_5:UpdateMatrix()

	if not arg0_5._inViewArea or not arg0_5._alwaysHideArrow then
		arg0_5:UpdateArrowBarPostition()
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

function var5_0.UpdateHpBar(arg0_6)
	var5_0.super.UpdateHpBar(arg0_6)

	if arg0_6._unitData.__name == var0_0.Battle.BattleCardPuzzlePlayerUnit.__name then
		arg0_6:UpdateVectorBar()
	end
end

function var5_0.UpdateOxygenBar(arg0_7)
	arg0_7._oxygenSlider.value = arg0_7._unitData:GetOxygenProgress()
end

function var5_0.UpdateVectorBar(arg0_8)
	local var0_8 = arg0_8._unitData:GetHPRate()

	arg0_8._vectorProgress.fillAmount = var0_8
end

function var5_0.UpdateUIComponentPosition(arg0_9)
	var5_0.super.UpdateUIComponentPosition(arg0_9)

	local var0_9 = arg0_9._unitData:GetBornPosition()

	if var0_9 then
		if not arg0_9._referenceVectorBorn then
			arg0_9._referenceVectorBorn = Vector3.New(var0_9.x, var0_9.y, var0_9.z)
		else
			arg0_9._referenceVectorBorn:Set(var0_9.x, var0_9.y, var0_9.z)
		end

		var0_0.Battle.BattleVariable.CameraPosToUICameraByRef(arg0_9._referenceVectorBorn)
	end
end

function var5_0.AddArrowBar(arg0_10, arg1_10)
	var5_0.super.AddArrowBar(arg0_10, arg1_10)

	arg0_10._vectorProgress = arg0_10._arrowBarTf:Find("HPBar/HPProgress"):GetComponent(typeof(Image))

	local var0_10 = var0_0.Battle.BattleResourceManager.GetInstance():GetCharacterQIcon(arg0_10._unitData:GetTemplate().painting)

	setImageSprite(findTF(arg0_10._arrowBar, "icon"), var0_10)

	if arg0_10._unitData:IsMainFleetUnit() and arg0_10._unitData:GetFleetVO():GetMainList()[3] == arg0_10._unitData then
		arg1_10.transform:SetSiblingIndex(arg1_10.transform.parent.childCount - 3)
	end

	arg0_10:UpdateVectorBar()
end

function var5_0.GetReferenceVector(arg0_11, arg1_11)
	if arg0_11._inViewArea then
		return var5_0.super.GetReferenceVector(arg0_11, arg1_11)
	else
		return arg0_11._arrowVector
	end
end

function var5_0.DisableWeaponTrack(arg0_12)
	if arg0_12._torpedoTrack then
		arg0_12._torpedoTrack:SetActive(false)
	end
end

function var5_0.SonarAcitve(arg0_13, arg1_13)
	if var0_0.Battle.BattleAttr.HasSonar(arg0_13._unitData) then
		arg0_13._sonar:GetComponent(typeof(Animator)).enabled = arg1_13
	end
end

function var5_0.UpdateDiveInvisible(arg0_14)
	var5_0.super.UpdateDiveInvisible(arg0_14)

	local var0_14 = arg0_14._unitData:GetDiveInvisible()

	SetActive(arg0_14._diveMark, var0_14)

	local var1_14 = arg0_14._unitData:GetOxygenVisible()

	SetActive(arg0_14._oxygenBar, var1_14)
end

function var5_0.Dispose(arg0_15)
	arg0_15._torpedoIcons = nil
	arg0_15._renderer = nil
	arg0_15._sonar = nil
	arg0_15._diveMark = nil
	arg0_15._oxygenBar = nil
	arg0_15._oxygenSlider = nil

	Object.Destroy(arg0_15._arrowBar)

	for iter0_15, iter1_15 in ipairs(arg0_15._weaponSectorList) do
		iter1_15:Dispose()
	end

	arg0_15._weaponSectorList = nil

	var5_0.super.Dispose(arg0_15)
end

function var5_0.GetModleID(arg0_16)
	return arg0_16._unitData:GetTemplate().prefab
end

function var5_0.OnUpdateHP(arg0_17, arg1_17)
	var5_0.super.OnUpdateHP(arg0_17, arg1_17)
	arg0_17:UpdateVectorBar()
end

function var5_0.onInitWeaponCD(arg0_18, arg1_18)
	arg0_18:onTorepedoReady()
end

function var5_0.onCastBlink(arg0_19, arg1_19)
	local var0_19 = arg1_19.Data.callbackFunc
	local var1_19 = arg1_19.Data.timeScale

	arg0_19:AddFX("jineng", false, var1_19, var0_19)
end

function var5_0.onTorpedoWeaponFire(arg0_20, arg1_20)
	arg0_20._torpedoTrack:SetActive(false)
	arg0_20:onTorepedoReady()
end

function var5_0.onTorpedoPrepar(arg0_21, arg1_21)
	arg0_21._torpedoTrack:SetActive(true)

	local var0_21 = var0_0.Battle.BattleDataFunction.GetBulletTmpDataFromID(arg1_21.Dispatcher:GetTemplateData().bullet_ID[1])

	arg0_21._torpedoTrack:SetScale(Vector3(var0_21.range / var2_0.SPINE_SCALE, var0_21.cld_box[3] / var2_0.SPINE_SCALE, 1))
end

function var5_0.onTorpedoCancel(arg0_22, arg1_22)
	arg0_22._torpedoTrack:SetActive(false)
end

function var5_0.onTorepedoReady(arg0_23, arg1_23)
	local var0_23 = 0

	for iter0_23, iter1_23 in ipairs(arg0_23._torpedoWeaponList) do
		if iter1_23:GetCurrentState() == iter1_23.STATE_READY then
			var0_23 = var0_23 + 1
		end
	end

	for iter2_23 = 1, var0_0.Battle.BattleConst.MAX_EQUIPMENT_COUNT do
		LuaHelper.SetTFChildActive(arg0_23._torpedoIcons, "torpedo_" .. iter2_23, iter2_23 <= var0_23)
	end
end

function var5_0.onAAMissileWeaponFire(arg0_24, arg1_24)
	arg0_24:onAAMissileReady()
end

function var5_0.onWillDie(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg0_25._smokeList) do
		if iter1_25.active == true then
			iter1_25.active = false

			local var0_25 = iter1_25.smokes

			for iter2_25, iter3_25 in pairs(var0_25) do
				if iter2_25.unInitialize then
					-- block empty
				else
					SetActive(iter3_25, false)
				end
			end
		end
	end
end

function var5_0.AddHPBar(arg0_26, arg1_26)
	var5_0.super.AddHPBar(arg0_26, arg1_26)

	arg0_26._torpedoIcons = arg0_26._HPBarTf:Find("torpedoIcons")

	if #arg0_26._torpedoWeaponList <= 0 then
		arg0_26._torpedoIcons.gameObject:SetActive(false)
	end

	arg0_26._sonar = arg0_26._HPBarTf:Find("sonarMark")

	if var0_0.Battle.BattleAttr.HasSonar(arg0_26._unitData) then
		arg0_26._sonar.gameObject:SetActive(true)
	else
		arg0_26._sonar.gameObject:SetActive(false)
	end

	arg0_26._diveMark = arg0_26._HPBarTf:Find("diveMark")
	arg0_26._oxygenBar = arg0_26._HPBarTf:Find("oxygenBar")
	arg0_26._oxygenSlider = arg0_26._oxygenBar:Find("oxygen"):GetComponent(typeof(Slider))
	arg0_26._oxygenSlider.value = 1

	arg0_26:onTorepedoReady()
end

function var5_0.AddModel(arg0_27, arg1_27)
	var5_0.super.AddModel(arg0_27, arg1_27)

	arg0_27._renderer = arg0_27:GetTf():GetComponent(typeof(Renderer))
end

function var5_0.AddChargeArea(arg0_28, arg1_28)
	arg0_28._chargeWeaponArea = var0_0.Battle.BattleChargeArea.New(arg1_28)
end

function var5_0.AddTorpedoTrack(arg0_29, arg1_29)
	arg0_29._torpedoTrack = var0_0.Battle.BossSkillAlert.New(arg1_29)

	arg0_29._torpedoTrack:SetActive(false)
end

function var5_0.AddCloakBar(arg0_30, arg1_30)
	var5_0.super.AddCloakBar(arg0_30, arg1_30)

	local var0_30 = arg0_30._HPBarTf:Find("cloakBar")

	arg0_30._hpCloakBar = var0_0.Battle.BattleCloakBar.New(var0_30, var0_0.Battle.BattleCloakBar.FORM_BAR)

	arg0_30._hpCloakBar:ConfigCloak(arg0_30._unitData:GetCloak())
	arg0_30._hpCloakBar:UpdateCloakProgress()
	arg0_30._hpCloakBar:SetActive(true)
end

function var5_0.onUpdateCloakConfig(arg0_31, arg1_31)
	var5_0.super.onUpdateCloakConfig(arg0_31, arg1_31)
	arg0_31._hpCloakBar:UpdateCloakConfig()
end

function var5_0.onUpdateCloakLock(arg0_32, arg1_32)
	var5_0.super.onUpdateCloakLock(arg0_32, arg1_32)
	arg0_32._hpCloakBar:UpdateCloakLock()
end

function var5_0.InitChargeWeapon(arg0_33, arg1_33)
	arg0_33._chargeWeaponList[#arg0_33._chargeWeaponList + 1] = arg1_33

	arg0_33:RegisterWeaponListener(arg1_33)
	arg1_33:RegisterEventListener(arg0_33, var1_0.CHARGE_WEAPON_FINISH, arg0_33.onCastBlink)
end

function var5_0.InitAirAssit(arg0_34, arg1_34)
	arg0_34._airAssistList[#arg0_34._airAssistList + 1] = arg1_34

	arg1_34:RegisterEventListener(arg0_34, var1_0.CHARGE_WEAPON_FINISH, arg0_34.onCastBlink)
	arg1_34:RegisterEventListener(arg0_34, var1_0.FIRE, arg0_34.onCannonFire)
end

function var5_0.InitTorpedoWeapon(arg0_35, arg1_35)
	arg0_35._torpedoWeaponList[#arg0_35._torpedoWeaponList + 1] = arg1_35

	arg0_35:RegisterWeaponListener(arg1_35)
	arg1_35:RegisterEventListener(arg0_35, var1_0.TORPEDO_WEAPON_FIRE, arg0_35.onTorpedoWeaponFire)
	arg1_35:RegisterEventListener(arg0_35, var1_0.TORPEDO_WEAPON_PREPAR, arg0_35.onTorpedoPrepar)
	arg1_35:RegisterEventListener(arg0_35, var1_0.TORPEDO_WEAPON_CANCEL, arg0_35.onTorpedoCancel)
	arg1_35:RegisterEventListener(arg0_35, var1_0.TORPEDO_WEAPON_READY, arg0_35.onTorepedoReady)
end

function var5_0.onActiveWeaponSector(arg0_36, arg1_36)
	local var0_36 = arg1_36.Data
	local var1_36 = var0_36.isActive
	local var2_36 = var0_36.weapon

	if var1_36 then
		local var3_36 = arg0_36._factory:GetFXPool():GetCharacterFX("weaponrange", arg0_36).transform
		local var4_36 = var0_0.Battle.BattleWeaponRangeSector.New(var3_36)

		var4_36:ConfigHost(arg0_36._unitData, var2_36)

		arg0_36._weaponSectorList[var2_36] = var4_36
	else
		arg0_36._weaponSectorList[var2_36]:Dispose()

		arg0_36._weaponSectorList[var2_36] = nil
	end
end

function var5_0.OnAnimatorTrigger(arg0_37)
	arg0_37._unitData:CharacterActionTriggerCallback()
end

function var5_0.OnAnimatorEnd(arg0_38)
	arg0_38._unitData:CharacterActionEndCallback()
end

function var5_0.OnAnimatorStart(arg0_39)
	arg0_39._unitData:CharacterActionStartCallback()
end
