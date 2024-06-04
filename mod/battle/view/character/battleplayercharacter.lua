ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleCardPuzzleEvent
local var5 = class("BattlePlayerCharacter", var0.Battle.BattleCharacter)

var0.Battle.BattlePlayerCharacter = var5
var5.__name = "BattlePlayerCharacter"

function var5.Ctor(arg0)
	var5.super.Ctor(arg0)
end

function var5.SetUnitData(arg0, arg1)
	var5.super.SetUnitData(arg0, arg1)

	arg0._chargeWeaponList = {}

	for iter0, iter1 in ipairs(arg1:GetChargeList()) do
		arg0:InitChargeWeapon(iter1)
	end

	arg0._torpedoWeaponList = {}

	for iter2, iter3 in ipairs(arg1:GetTorpedoList()) do
		arg0:InitTorpedoWeapon(iter3)
	end

	arg0._airAssistList = {}

	local var0 = arg1:GetAirAssistList()

	if var0 ~= nil then
		for iter4, iter5 in ipairs(var0) do
			arg0:InitAirAssit(iter5)
		end
	end

	arg0._weaponSectorList = {}
end

function var5.AddUnitEvent(arg0)
	var5.super.AddUnitEvent(arg0)
	arg0._unitData:RegisterEventListener(arg0, var1.WILL_DIE, arg0.onWillDie)
	arg0._unitData:RegisterEventListener(arg0, var1.INIT_COOL_DOWN, arg0.onInitWeaponCD)
	arg0._unitData:RegisterEventListener(arg0, var1.WEAPON_SECTOR, arg0.onActiveWeaponSector)

	if arg0._unitData:GetFleetRangeAAWeapon() then
		arg0:RegisterWeaponListener(arg0._unitData:GetFleetRangeAAWeapon())
	end
end

function var5.RemoveUnitEvent(arg0)
	if arg0._unitData:GetFleetRangeAAWeapon() then
		arg0:UnregisterWeaponListener(arg0._unitData:GetFleetRangeAAWeapon())
	end

	for iter0, iter1 in ipairs(arg0._chargeWeaponList) do
		iter1:UnregisterEventListener(arg0, var1.CHARGE_WEAPON_FINISH)
		arg0:UnregisterWeaponListener(iter1)
	end

	for iter2, iter3 in ipairs(arg0._torpedoWeaponList) do
		iter3:UnregisterEventListener(arg0, var1.TORPEDO_WEAPON_FIRE)
		iter3:UnregisterEventListener(arg0, var1.TORPEDO_WEAPON_PREPAR)
		iter3:UnregisterEventListener(arg0, var1.TORPEDO_WEAPON_CANCEL)
		iter3:UnregisterEventListener(arg0, var1.TORPEDO_WEAPON_READY)
		arg0:UnregisterWeaponListener(iter3)
	end

	for iter4, iter5 in ipairs(arg0._airAssistList) do
		iter5:UnregisterEventListener(arg0, var1.CHARGE_WEAPON_FINISH)
		iter5:UnregisterEventListener(arg0, var1.FIRE)
	end

	arg0._unitData:UnregisterEventListener(arg0, var1.WILL_DIE)
	arg0._unitData:UnregisterEventListener(arg0, var1.INIT_COOL_DOWN)
	var5.super.RemoveUnitEvent(arg0)
end

function var5.Update(arg0)
	var5.super.Update(arg0)
	arg0:UpdatePosition()
	arg0:UpdateMatrix()

	if not arg0._inViewArea or not arg0._alwaysHideArrow then
		arg0:UpdateArrowBarPostition()
	end

	if arg0._unitData:GetOxyState() then
		arg0:UpdateOxygenBar()
	end

	if arg0._cloakBar then
		arg0._cloakBar:UpdateCloakProgress()
		arg0._hpCloakBar:UpdateCloakProgress()

		if not arg0._inViewArea or not arg0._alwaysHideArrow then
			arg0:UpdateCloakBarPosition()
		end
	end
end

function var5.UpdateHpBar(arg0)
	var5.super.UpdateHpBar(arg0)

	if arg0._unitData.__name == var0.Battle.BattleCardPuzzlePlayerUnit.__name then
		arg0:UpdateVectorBar()
	end
end

function var5.UpdateOxygenBar(arg0)
	arg0._oxygenSlider.value = arg0._unitData:GetOxygenProgress()
end

function var5.UpdateVectorBar(arg0)
	local var0 = arg0._unitData:GetHPRate()

	arg0._vectorProgress.fillAmount = var0
end

function var5.UpdateUIComponentPosition(arg0)
	var5.super.UpdateUIComponentPosition(arg0)

	local var0 = arg0._unitData:GetBornPosition()

	if var0 then
		if not arg0._referenceVectorBorn then
			arg0._referenceVectorBorn = Vector3.New(var0.x, var0.y, var0.z)
		else
			arg0._referenceVectorBorn:Set(var0.x, var0.y, var0.z)
		end

		var0.Battle.BattleVariable.CameraPosToUICameraByRef(arg0._referenceVectorBorn)
	end
end

function var5.AddArrowBar(arg0, arg1)
	var5.super.AddArrowBar(arg0, arg1)

	arg0._vectorProgress = arg0._arrowBarTf:Find("HPBar/HPProgress"):GetComponent(typeof(Image))

	local var0 = var0.Battle.BattleResourceManager.GetInstance():GetCharacterQIcon(arg0._unitData:GetTemplate().painting)

	setImageSprite(findTF(arg0._arrowBar, "icon"), var0)

	if arg0._unitData:IsMainFleetUnit() and arg0._unitData:GetFleetVO():GetMainList()[3] == arg0._unitData then
		arg1.transform:SetSiblingIndex(arg1.transform.parent.childCount - 3)
	end

	arg0:UpdateVectorBar()
end

function var5.GetReferenceVector(arg0, arg1)
	if arg0._inViewArea then
		return var5.super.GetReferenceVector(arg0, arg1)
	else
		return arg0._arrowVector
	end
end

function var5.DisableWeaponTrack(arg0)
	if arg0._torpedoTrack then
		arg0._torpedoTrack:SetActive(false)
	end
end

function var5.SonarAcitve(arg0, arg1)
	if var0.Battle.BattleAttr.HasSonar(arg0._unitData) then
		arg0._sonar:GetComponent(typeof(Animator)).enabled = arg1
	end
end

function var5.UpdateDiveInvisible(arg0)
	var5.super.UpdateDiveInvisible(arg0)

	local var0 = arg0._unitData:GetDiveInvisible()

	SetActive(arg0._diveMark, var0)

	local var1 = arg0._unitData:GetOxygenVisible()

	SetActive(arg0._oxygenBar, var1)
end

function var5.Dispose(arg0)
	arg0._torpedoIcons = nil
	arg0._renderer = nil
	arg0._sonar = nil
	arg0._diveMark = nil
	arg0._oxygenBar = nil
	arg0._oxygenSlider = nil

	Object.Destroy(arg0._arrowBar)

	for iter0, iter1 in ipairs(arg0._weaponSectorList) do
		iter1:Dispose()
	end

	arg0._weaponSectorList = nil

	var5.super.Dispose(arg0)
end

function var5.GetModleID(arg0)
	return arg0._unitData:GetTemplate().prefab
end

function var5.OnUpdateHP(arg0, arg1)
	var5.super.OnUpdateHP(arg0, arg1)
	arg0:UpdateVectorBar()
end

function var5.onInitWeaponCD(arg0, arg1)
	arg0:onTorepedoReady()
end

function var5.onCastBlink(arg0, arg1)
	local var0 = arg1.Data.callbackFunc
	local var1 = arg1.Data.timeScale

	arg0:AddFX("jineng", false, var1, var0)
end

function var5.onTorpedoWeaponFire(arg0, arg1)
	arg0._torpedoTrack:SetActive(false)
	arg0:onTorepedoReady()
end

function var5.onTorpedoPrepar(arg0, arg1)
	arg0._torpedoTrack:SetActive(true)

	local var0 = var0.Battle.BattleDataFunction.GetBulletTmpDataFromID(arg1.Dispatcher:GetTemplateData().bullet_ID[1])

	arg0._torpedoTrack:SetScale(Vector3(var0.range / var2.SPINE_SCALE, var0.cld_box[3] / var2.SPINE_SCALE, 1))
end

function var5.onTorpedoCancel(arg0, arg1)
	arg0._torpedoTrack:SetActive(false)
end

function var5.onTorepedoReady(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0._torpedoWeaponList) do
		if iter1:GetCurrentState() == iter1.STATE_READY then
			var0 = var0 + 1
		end
	end

	for iter2 = 1, var0.Battle.BattleConst.MAX_EQUIPMENT_COUNT do
		LuaHelper.SetTFChildActive(arg0._torpedoIcons, "torpedo_" .. iter2, iter2 <= var0)
	end
end

function var5.onAAMissileWeaponFire(arg0, arg1)
	arg0:onAAMissileReady()
end

function var5.onWillDie(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._smokeList) do
		if iter1.active == true then
			iter1.active = false

			local var0 = iter1.smokes

			for iter2, iter3 in pairs(var0) do
				if iter2.unInitialize then
					-- block empty
				else
					SetActive(iter3, false)
				end
			end
		end
	end
end

function var5.AddHPBar(arg0, arg1)
	var5.super.AddHPBar(arg0, arg1)

	arg0._torpedoIcons = arg0._HPBarTf:Find("torpedoIcons")

	if #arg0._torpedoWeaponList <= 0 then
		arg0._torpedoIcons.gameObject:SetActive(false)
	end

	arg0._sonar = arg0._HPBarTf:Find("sonarMark")

	if var0.Battle.BattleAttr.HasSonar(arg0._unitData) then
		arg0._sonar.gameObject:SetActive(true)
	else
		arg0._sonar.gameObject:SetActive(false)
	end

	arg0._diveMark = arg0._HPBarTf:Find("diveMark")
	arg0._oxygenBar = arg0._HPBarTf:Find("oxygenBar")
	arg0._oxygenSlider = arg0._oxygenBar:Find("oxygen"):GetComponent(typeof(Slider))
	arg0._oxygenSlider.value = 1

	arg0:onTorepedoReady()
end

function var5.AddModel(arg0, arg1)
	var5.super.AddModel(arg0, arg1)

	arg0._renderer = arg0:GetTf():GetComponent(typeof(Renderer))
end

function var5.AddChargeArea(arg0, arg1)
	arg0._chargeWeaponArea = var0.Battle.BattleChargeArea.New(arg1)
end

function var5.AddTorpedoTrack(arg0, arg1)
	arg0._torpedoTrack = var0.Battle.BossSkillAlert.New(arg1)

	arg0._torpedoTrack:SetActive(false)
end

function var5.AddCloakBar(arg0, arg1)
	var5.super.AddCloakBar(arg0, arg1)

	local var0 = arg0._HPBarTf:Find("cloakBar")

	arg0._hpCloakBar = var0.Battle.BattleCloakBar.New(var0, var0.Battle.BattleCloakBar.FORM_BAR)

	arg0._hpCloakBar:ConfigCloak(arg0._unitData:GetCloak())
	arg0._hpCloakBar:UpdateCloakProgress()
	arg0._hpCloakBar:SetActive(true)
end

function var5.onUpdateCloakConfig(arg0, arg1)
	var5.super.onUpdateCloakConfig(arg0, arg1)
	arg0._hpCloakBar:UpdateCloakConfig()
end

function var5.onUpdateCloakLock(arg0, arg1)
	var5.super.onUpdateCloakLock(arg0, arg1)
	arg0._hpCloakBar:UpdateCloakLock()
end

function var5.InitChargeWeapon(arg0, arg1)
	arg0._chargeWeaponList[#arg0._chargeWeaponList + 1] = arg1

	arg0:RegisterWeaponListener(arg1)
	arg1:RegisterEventListener(arg0, var1.CHARGE_WEAPON_FINISH, arg0.onCastBlink)
end

function var5.InitAirAssit(arg0, arg1)
	arg0._airAssistList[#arg0._airAssistList + 1] = arg1

	arg1:RegisterEventListener(arg0, var1.CHARGE_WEAPON_FINISH, arg0.onCastBlink)
	arg1:RegisterEventListener(arg0, var1.FIRE, arg0.onCannonFire)
end

function var5.InitTorpedoWeapon(arg0, arg1)
	arg0._torpedoWeaponList[#arg0._torpedoWeaponList + 1] = arg1

	arg0:RegisterWeaponListener(arg1)
	arg1:RegisterEventListener(arg0, var1.TORPEDO_WEAPON_FIRE, arg0.onTorpedoWeaponFire)
	arg1:RegisterEventListener(arg0, var1.TORPEDO_WEAPON_PREPAR, arg0.onTorpedoPrepar)
	arg1:RegisterEventListener(arg0, var1.TORPEDO_WEAPON_CANCEL, arg0.onTorpedoCancel)
	arg1:RegisterEventListener(arg0, var1.TORPEDO_WEAPON_READY, arg0.onTorepedoReady)
end

function var5.onActiveWeaponSector(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.isActive
	local var2 = var0.weapon

	if var1 then
		local var3 = arg0._factory:GetFXPool():GetCharacterFX("weaponrange", arg0).transform
		local var4 = var0.Battle.BattleWeaponRangeSector.New(var3)

		var4:ConfigHost(arg0._unitData, var2)

		arg0._weaponSectorList[var2] = var4
	else
		arg0._weaponSectorList[var2]:Dispose()

		arg0._weaponSectorList[var2] = nil
	end
end

function var5.OnAnimatorTrigger(arg0)
	arg0._unitData:CharacterActionTriggerCallback()
end

function var5.OnAnimatorEnd(arg0)
	arg0._unitData:CharacterActionEndCallback()
end

function var5.OnAnimatorStart(arg0)
	arg0._unitData:CharacterActionStartCallback()
end
