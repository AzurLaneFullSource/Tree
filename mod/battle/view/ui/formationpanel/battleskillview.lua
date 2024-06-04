ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.BattleSkillView = class("BattleSkillView")

local var2 = var0.Battle.BattleSkillView

var2.__name = "BattleSkillView"

function var2.Ctor(arg0, arg1)
	var0.EventListener.AttachEventListener(arg0)

	arg0._mediator = arg1
	arg0._ui = arg1._ui

	arg0:InitBtns()
	arg0:EnableWeaponButton(false)
end

function var2.EnableWeaponButton(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._skillBtnList) do
		iter1:Enabled(arg1)
	end
end

function var2.DisableWeapnButton(arg0)
	for iter0, iter1 in ipairs(arg0._skillBtnList) do
		iter1:Disable()
	end
end

function var2.JamSkillButton(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._skillBtnList) do
		iter1:SetJam(arg1)
	end
end

function var2.ShiftSubmarineManualButton(arg0, arg1)
	if arg1 == var0.Battle.OxyState.STATE_FREE_FLOAT then
		arg0._diveBtn:SetActive(true)
		arg0._floatBtn:SetActive(false)
	elseif arg1 == var0.Battle.OxyState.STATE_FREE_DIVE then
		arg0._diveBtn:SetActive(false)
		arg0._floatBtn:SetActive(true)
	end
end

function var2.InitBtns(arg0)
	arg0._skillBtnList = {}
	arg0._activeBtnList = {}
	arg0._delayAnimaList = {}
	arg0._fleetVO = arg0._mediator._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)
	arg0._buttonContainer = arg0._ui:findTF("Weapon_button_container")
	arg0._buttonRes = arg0._ui:findTF("Weapon_button_Resource")

	local function var0()
		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_emptyBlock"))
	end

	local function var1()
		return
	end

	local function var2()
		if arg0._main_cannon_sound then
			arg0._main_cannon_sound:Stop(true)
		end

		arg0._main_cannon_sound = pg.CriMgr.GetInstance():PlaySE_V3("battle-cannon-main-prepared")

		arg0._fleetVO:CastChargeWeapon()
	end

	local function var3()
		arg0._fleetVO:UnleashChrageWeapon()
	end

	local function var4()
		if arg0._main_cannon_sound then
			arg0._main_cannon_sound:Stop(true)
		end

		arg0._fleetVO:CancelChargeWeapon()
	end

	arg0._chargeBtn = arg0:generateCommonButton(1)

	arg0._chargeBtn:ConfigCallback(var2, var3, var4, var0)

	local var5 = arg0._fleetVO:GetChargeWeaponVO()

	arg0._chargeBtn:SetProgressInfo(var5)

	local function var6()
		arg0._fleetVO:CastTorpedo()
	end

	local function var7()
		arg0._fleetVO:UnleashTorpedo()
	end

	local function var8()
		arg0._fleetVO:CancelTorpedo()
	end

	arg0._torpedoBtn = arg0:generateCommonButton(2)

	arg0._torpedoBtn:ConfigCallback(var6, var7, var8, var0)

	local var9 = arg0._fleetVO:GetTorpedoWeaponVO()

	arg0._torpedoBtn:SetProgressInfo(var9)

	local function var10()
		arg0._fleetVO:UnleashAllInStrike(true)
	end

	arg0._airStrikeBtn = arg0:generateCommonButton(3)

	arg0._airStrikeBtn:ConfigCallback(var1, var10, var1, var0)

	local var11 = arg0._fleetVO:GetAirAssistVO()

	arg0._airStrikeBtn:SetProgressInfo(var11)

	local function var12()
		arg0._fleetVO:ChangeSubmarineState(var0.Battle.OxyState.STATE_FREE_DIVE, true)
	end

	arg0._diveBtn = arg0:generateSubmarineFuncButton(5)

	arg0._diveBtn:ConfigCallback(var1, var12, var1, var0)

	local var13 = arg0._fleetVO:GetSubFreeDiveVO()

	arg0._diveBtn:SetProgressInfo(var13)
	arg0._diveBtn:SetActive(false)

	local function var14()
		arg0._fleetVO:ChangeSubmarineState(var0.Battle.OxyState.STATE_FREE_FLOAT, true)
	end

	arg0._floatBtn = arg0:generateSubmarineFuncButton(6)

	arg0._floatBtn:ConfigCallback(var1, var14, var1, var0)

	local var15 = arg0._fleetVO:GetSubFreeFloatVO()

	arg0._floatBtn:SetProgressInfo(var15)
	arg0._floatBtn:SetActive(false)

	local function var16()
		arg0._fleetVO:SubmarinBoost()
	end

	arg0._boostBtn = arg0:generateSubmarineFuncButton(7)

	arg0._boostBtn:ConfigCallback(var1, var16, var1, var0)

	local var17 = arg0._fleetVO:GetSubBoostVO()

	arg0._boostBtn:SetProgressInfo(var17)

	local function var18()
		arg0._fleetVO:UnleashSubmarineSpecial()
	end

	arg0._specialBtn = arg0:generateSubmarineButton(9)

	arg0._specialBtn:ConfigCallback(var1, var18, var1, var0)

	local var19 = arg0._fleetVO:GetSubSpecialVO()

	arg0._specialBtn:SetProgressInfo(var19)

	local function var20()
		arg0._fleetVO:ShiftManualSub()
	end

	arg0._shiftBtn = arg0:generateSubmarineFuncButton(8)

	arg0._shiftBtn:ConfigCallback(var1, var20, var1, var0)

	local var21 = arg0._fleetVO:GetSubShiftVO()

	arg0._shiftBtn:SetProgressInfo(var21)

	local var22 = arg0._fleetVO._submarineVO

	if var22:GetUseable() and var22:GetCount() > 0 then
		local function var23()
			arg0._mediator._dataProxy:SubmarineStrike(var0.Battle.BattleConfig.FRIENDLY_CODE)
		end

		arg0._subStriveBtn = arg0:generateSubmarineButton(4)

		local var24 = arg0._subStriveBtn:GetSkin()

		arg0:setSkillButtonPreferences(var24, 4)
		arg0._subStriveBtn:ConfigCallback(var1, var23, var1, var0)
		arg0._subStriveBtn:SetProgressInfo(var22)
		table.insert(arg0._activeBtnList, arg0._subStriveBtn)
	end

	local var25 = var0.Battle.BattleWeaponButton.New()
	local var26 = cloneTplTo(arg0._progressSkin, arg0._buttonContainer)

	arg0:setSkillButtonPreferences(var26, 2)
	var25:ConfigSkin(var26)
	var25:SwitchIcon(10)
	var25:SwitchIconEffect(2)
	var25:ConfigCallback(var6, var7, var8, var0)
	table.insert(arg0._skillBtnList, var25)
	var25:SetProgressInfo(var9)
	var25:SetActive(false)
	arg0._boostBtn:SetActive(false)
	arg0._diveBtn:SetActive(false)
	arg0._floatBtn:SetActive(false)
	arg0._specialBtn:SetActive(false)
	arg0._shiftBtn:SetActive(false)
end

function var2.generateCommonButton(arg0, arg1)
	local var0 = var0.Battle.BattleWeaponButton.New()

	arg0._progressSkin = arg0._progressSkin or arg0._ui:findTF("Weapon_button_progress")

	local var1 = cloneTplTo(arg0._progressSkin, arg0._buttonContainer)

	var1.name = "Skill_" .. arg1

	arg0:setSkillButtonPreferences(var1, arg1)
	var0:ConfigSkin(var1)
	var0:SwitchIcon(arg1)
	var0:SwitchIconEffect(arg1)
	var0:SetTextActive(true)
	table.insert(arg0._skillBtnList, var0)

	return var0
end

function var2.generateSubmarineFuncButton(arg0, arg1)
	local var0 = var0.Battle.BattleSubmarineFuncButton.New()

	arg0._progressSkin = arg0._progressSkin or arg0._ui:findTF("Weapon_button_progress")

	local var1 = cloneTplTo(arg0._progressSkin, arg0._buttonContainer)

	var0:ConfigSkin(var1)
	var0:SwitchIcon(arg1)
	var0:SetTextActive(false)
	table.insert(arg0._skillBtnList, var0)

	return var0
end

function var2.generateSubmarineButton(arg0, arg1)
	local var0 = var0.Battle.BattleSubmarineButton.New()

	arg0._disposableSkin = arg0._disposableSkin or arg0._ui:findTF("Weapon_button")

	local var1 = cloneTplTo(arg0._disposableSkin, arg0._buttonContainer)

	var0:ConfigSkin(var1)
	var0:SwitchIcon(arg1)
	table.insert(arg0._skillBtnList, var0)

	return var0
end

function var2.CustomButton(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0._skillBtnList[iter1]:SetActive(false)
	end
end

function var2.NormalButton(arg0)
	arg0._chargeBtn:SetActive(true)
	arg0._torpedoBtn:SetActive(true)
	arg0._airStrikeBtn:SetActive(true)
	arg0._boostBtn:SetActive(false)
	arg0._diveBtn:SetActive(false)
	arg0._floatBtn:SetActive(false)
	arg0._specialBtn:SetActive(false)
	arg0._shiftBtn:SetActive(false)
	table.insert(arg0._activeBtnList, arg0._chargeBtn)
	table.insert(arg0._activeBtnList, arg0._torpedoBtn)
	table.insert(arg0._activeBtnList, arg0._airStrikeBtn)
	table.insert(arg0._delayAnimaList, arg0._chargeBtn)
	table.insert(arg0._delayAnimaList, arg0._torpedoBtn)
	table.insert(arg0._delayAnimaList, arg0._airStrikeBtn)

	if arg0._subStriveBtn then
		table.insert(arg0._delayAnimaList, arg0._subStriveBtn)
	end
end

function var2.SubmarineButton(arg0)
	arg0._chargeBtn:SetActive(false)
	arg0._torpedoBtn:SetActive(true)
	arg0._airStrikeBtn:SetActive(false)
	arg0._boostBtn:SetActive(true)
	arg0._diveBtn:SetActive(true)
	arg0._floatBtn:SetActive(true)
	table.insert(arg0._activeBtnList, arg0._diveBtn)
	table.insert(arg0._activeBtnList, arg0._torpedoBtn)
	table.insert(arg0._activeBtnList, arg0._boostBtn)
	table.insert(arg0._activeBtnList, arg0._floatBtn)
	table.insert(arg0._delayAnimaList, arg0._floatBtn)
	table.insert(arg0._delayAnimaList, arg0._torpedoBtn)
	table.insert(arg0._delayAnimaList, arg0._boostBtn)

	local var0 = arg0._torpedoBtn:GetSkin().transform
	local var1 = var1.SKILL_BUTTON_DEFAULT_PREFERENCE[2]

	var0.anchorMin = Vector2(var1.x, var1.y)
	var0.anchorMax = Vector2(var1.x, var1.y)
end

function var2.SubRoutineButton(arg0)
	arg0._chargeBtn:SetActive(false)
	arg0._torpedoBtn:SetActive(true)
	arg0._airStrikeBtn:SetActive(false)
	arg0._boostBtn:SetActive(false)
	arg0._diveBtn:SetActive(true)
	arg0._floatBtn:SetActive(true)
	arg0._specialBtn:SetActive(true)
	arg0._shiftBtn:SetActive(true)
	table.insert(arg0._activeBtnList, arg0._diveBtn)
	table.insert(arg0._activeBtnList, arg0._torpedoBtn)
	table.insert(arg0._activeBtnList, arg0._specialBtn)
	table.insert(arg0._activeBtnList, arg0._floatBtn)
	table.insert(arg0._activeBtnList, arg0._shiftBtn)
	table.insert(arg0._delayAnimaList, arg0._floatBtn)
	table.insert(arg0._delayAnimaList, arg0._torpedoBtn)
	table.insert(arg0._delayAnimaList, arg0._shiftBtn)
	table.insert(arg0._delayAnimaList, arg0._specialBtn)
	arg0:setSkillButtonPreferences(arg0._diveBtn:GetSkin(), 1)
	arg0:setSkillButtonPreferences(arg0._floatBtn:GetSkin(), 1)
	arg0:setSkillButtonPreferences(arg0._torpedoBtn:GetSkin(), 2)
	arg0:setSkillButtonPreferences(arg0._shiftBtn:GetSkin(), 3)
	arg0:setSkillButtonPreferences(arg0._specialBtn:GetSkin(), 4)
end

function var2.AirFightButton(arg0)
	local var0 = {
		9
	}

	for iter0, iter1 in ipairs(arg0._skillBtnList) do
		local var1 = table.indexof(var0, iter0)

		iter1:SetActive(var1)

		if var1 then
			table.insert(arg0._activeBtnList, iter1)
			arg0:setSkillButtonPreferences(iter1:GetSkin(), var1)
		end
	end
end

function var2.ButtonInitialAnima(arg0)
	for iter0, iter1 in ipairs(arg0._delayAnimaList) do
		iter1:InitialAnima(iter0 * 0.2)
	end
end

function var2.CardPuzzleButton(arg0)
	arg0._chargeBtn:SetActive(false)
	arg0._torpedoBtn:SetActive(false)
	arg0._airStrikeBtn:SetActive(false)
	arg0._boostBtn:SetActive(false)
	arg0._diveBtn:SetActive(false)
	arg0._floatBtn:SetActive(false)
	arg0._specialBtn:SetActive(false)
	arg0._shiftBtn:SetActive(false)
end

function var2.HideSkillButton(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._activeBtnList) do
		iter1:SetActive(not arg1)
	end
end

function var2.OnSkillCd(arg0, arg1)
	local var0 = arg1.Data.skillID
	local var1 = arg1.Data.coolDownTime

	if var1 < pg.TimeMgr.GetInstance():GetCombatTime() then
		return
	end

	arg0._skillCd[var0] = var1
end

function var2.Dispose(arg0)
	arg0._delayAnimaList = nil
	arg0._activeBtnList = nil

	for iter0, iter1 in ipairs(arg0._skillBtnList) do
		iter1:Dispose()
	end

	arg0._ui = nil

	if arg0._main_cannon_sound then
		arg0._main_cannon_sound:Stop(true)

		arg0._main_cannon_sound = nil
	end

	var0.EventListener.DetachEventListener(arg0)
end

function var2.Update(arg0)
	for iter0, iter1 in ipairs(arg0._skillBtnList) do
		iter1:Update()
	end
end

function var2.setSkillButtonPreferences(arg0, arg1, arg2)
	local var0 = var1.SKILL_BUTTON_DEFAULT_PREFERENCE[arg2]
	local var1 = PlayerPrefs.GetFloat("skill_" .. arg2 .. "_scale", var0.scale)
	local var2 = PlayerPrefs.GetFloat("skill_" .. arg2 .. "_anchorX", var0.x)
	local var3 = PlayerPrefs.GetFloat("skill_" .. arg2 .. "_anchorY", var0.y)
	local var4 = arg1.transform

	var4.localScale = Vector3(var1, var1, 0)
	var4.anchorMin = Vector2(var2, var3)
	var4.anchorMax = Vector2(var2, var3)
end
