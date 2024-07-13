ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleSkillView = class("BattleSkillView")

local var2_0 = var0_0.Battle.BattleSkillView

var2_0.__name = "BattleSkillView"

function var2_0.Ctor(arg0_1, arg1_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1._mediator = arg1_1
	arg0_1._ui = arg1_1._ui

	arg0_1:InitBtns()
	arg0_1:EnableWeaponButton(false)
end

function var2_0.EnableWeaponButton(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg0_2._skillBtnList) do
		iter1_2:Enabled(arg1_2)
	end
end

function var2_0.DisableWeapnButton(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3._skillBtnList) do
		iter1_3:Disable()
	end
end

function var2_0.JamSkillButton(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4._skillBtnList) do
		iter1_4:SetJam(arg1_4)
	end
end

function var2_0.ShiftSubmarineManualButton(arg0_5, arg1_5)
	if arg1_5 == var0_0.Battle.OxyState.STATE_FREE_FLOAT then
		arg0_5._diveBtn:SetActive(true)
		arg0_5._floatBtn:SetActive(false)
	elseif arg1_5 == var0_0.Battle.OxyState.STATE_FREE_DIVE then
		arg0_5._diveBtn:SetActive(false)
		arg0_5._floatBtn:SetActive(true)
	end
end

function var2_0.InitBtns(arg0_6)
	arg0_6._skillBtnList = {}
	arg0_6._activeBtnList = {}
	arg0_6._delayAnimaList = {}
	arg0_6._fleetVO = arg0_6._mediator._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
	arg0_6._buttonContainer = arg0_6._ui:findTF("Weapon_button_container")
	arg0_6._buttonRes = arg0_6._ui:findTF("Weapon_button_Resource")

	local function var0_6()
		pg.TipsMgr.GetInstance():ShowTips(i18n("battle_emptyBlock"))
	end

	local function var1_6()
		return
	end

	local function var2_6()
		if arg0_6._main_cannon_sound then
			arg0_6._main_cannon_sound:Stop(true)
		end

		arg0_6._main_cannon_sound = pg.CriMgr.GetInstance():PlaySE_V3("battle-cannon-main-prepared")

		arg0_6._fleetVO:CastChargeWeapon()
	end

	local function var3_6()
		arg0_6._fleetVO:UnleashChrageWeapon()
	end

	local function var4_6()
		if arg0_6._main_cannon_sound then
			arg0_6._main_cannon_sound:Stop(true)
		end

		arg0_6._fleetVO:CancelChargeWeapon()
	end

	arg0_6._chargeBtn = arg0_6:generateCommonButton(1)

	arg0_6._chargeBtn:ConfigCallback(var2_6, var3_6, var4_6, var0_6)

	local var5_6 = arg0_6._fleetVO:GetChargeWeaponVO()

	arg0_6._chargeBtn:SetProgressInfo(var5_6)

	local function var6_6()
		arg0_6._fleetVO:CastTorpedo()
	end

	local function var7_6()
		arg0_6._fleetVO:UnleashTorpedo()
	end

	local function var8_6()
		arg0_6._fleetVO:CancelTorpedo()
	end

	arg0_6._torpedoBtn = arg0_6:generateCommonButton(2)

	arg0_6._torpedoBtn:ConfigCallback(var6_6, var7_6, var8_6, var0_6)

	local var9_6 = arg0_6._fleetVO:GetTorpedoWeaponVO()

	arg0_6._torpedoBtn:SetProgressInfo(var9_6)

	local function var10_6()
		arg0_6._fleetVO:UnleashAllInStrike(true)
	end

	arg0_6._airStrikeBtn = arg0_6:generateCommonButton(3)

	arg0_6._airStrikeBtn:ConfigCallback(var1_6, var10_6, var1_6, var0_6)

	local var11_6 = arg0_6._fleetVO:GetAirAssistVO()

	arg0_6._airStrikeBtn:SetProgressInfo(var11_6)

	local function var12_6()
		arg0_6._fleetVO:ChangeSubmarineState(var0_0.Battle.OxyState.STATE_FREE_DIVE, true)
	end

	arg0_6._diveBtn = arg0_6:generateSubmarineFuncButton(5)

	arg0_6._diveBtn:ConfigCallback(var1_6, var12_6, var1_6, var0_6)

	local var13_6 = arg0_6._fleetVO:GetSubFreeDiveVO()

	arg0_6._diveBtn:SetProgressInfo(var13_6)
	arg0_6._diveBtn:SetActive(false)

	local function var14_6()
		arg0_6._fleetVO:ChangeSubmarineState(var0_0.Battle.OxyState.STATE_FREE_FLOAT, true)
	end

	arg0_6._floatBtn = arg0_6:generateSubmarineFuncButton(6)

	arg0_6._floatBtn:ConfigCallback(var1_6, var14_6, var1_6, var0_6)

	local var15_6 = arg0_6._fleetVO:GetSubFreeFloatVO()

	arg0_6._floatBtn:SetProgressInfo(var15_6)
	arg0_6._floatBtn:SetActive(false)

	local function var16_6()
		arg0_6._fleetVO:SubmarinBoost()
	end

	arg0_6._boostBtn = arg0_6:generateSubmarineFuncButton(7)

	arg0_6._boostBtn:ConfigCallback(var1_6, var16_6, var1_6, var0_6)

	local var17_6 = arg0_6._fleetVO:GetSubBoostVO()

	arg0_6._boostBtn:SetProgressInfo(var17_6)

	local function var18_6()
		arg0_6._fleetVO:UnleashSubmarineSpecial()
	end

	arg0_6._specialBtn = arg0_6:generateSubmarineButton(9)

	arg0_6._specialBtn:ConfigCallback(var1_6, var18_6, var1_6, var0_6)

	local var19_6 = arg0_6._fleetVO:GetSubSpecialVO()

	arg0_6._specialBtn:SetProgressInfo(var19_6)

	local function var20_6()
		arg0_6._fleetVO:ShiftManualSub()
	end

	arg0_6._shiftBtn = arg0_6:generateSubmarineFuncButton(8)

	arg0_6._shiftBtn:ConfigCallback(var1_6, var20_6, var1_6, var0_6)

	local var21_6 = arg0_6._fleetVO:GetSubShiftVO()

	arg0_6._shiftBtn:SetProgressInfo(var21_6)

	local var22_6 = arg0_6._fleetVO._submarineVO

	if var22_6:GetUseable() and var22_6:GetCount() > 0 then
		local function var23_6()
			arg0_6._mediator._dataProxy:SubmarineStrike(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
		end

		arg0_6._subStriveBtn = arg0_6:generateSubmarineButton(4)

		local var24_6 = arg0_6._subStriveBtn:GetSkin()

		arg0_6:setSkillButtonPreferences(var24_6, 4)
		arg0_6._subStriveBtn:ConfigCallback(var1_6, var23_6, var1_6, var0_6)
		arg0_6._subStriveBtn:SetProgressInfo(var22_6)
		table.insert(arg0_6._activeBtnList, arg0_6._subStriveBtn)
	end

	local var25_6 = var0_0.Battle.BattleWeaponButton.New()
	local var26_6 = cloneTplTo(arg0_6._progressSkin, arg0_6._buttonContainer)

	arg0_6:setSkillButtonPreferences(var26_6, 2)
	var25_6:ConfigSkin(var26_6)
	var25_6:SwitchIcon(10)
	var25_6:SwitchIconEffect(2)
	var25_6:ConfigCallback(var6_6, var7_6, var8_6, var0_6)
	table.insert(arg0_6._skillBtnList, var25_6)
	var25_6:SetProgressInfo(var9_6)
	var25_6:SetActive(false)
	arg0_6._boostBtn:SetActive(false)
	arg0_6._diveBtn:SetActive(false)
	arg0_6._floatBtn:SetActive(false)
	arg0_6._specialBtn:SetActive(false)
	arg0_6._shiftBtn:SetActive(false)
end

function var2_0.generateCommonButton(arg0_22, arg1_22)
	local var0_22 = var0_0.Battle.BattleWeaponButton.New()

	arg0_22._progressSkin = arg0_22._progressSkin or arg0_22._ui:findTF("Weapon_button_progress")

	local var1_22 = cloneTplTo(arg0_22._progressSkin, arg0_22._buttonContainer)

	var1_22.name = "Skill_" .. arg1_22

	arg0_22:setSkillButtonPreferences(var1_22, arg1_22)
	var0_22:ConfigSkin(var1_22)
	var0_22:SwitchIcon(arg1_22)
	var0_22:SwitchIconEffect(arg1_22)
	var0_22:SetTextActive(true)
	table.insert(arg0_22._skillBtnList, var0_22)

	return var0_22
end

function var2_0.generateSubmarineFuncButton(arg0_23, arg1_23)
	local var0_23 = var0_0.Battle.BattleSubmarineFuncButton.New()

	arg0_23._progressSkin = arg0_23._progressSkin or arg0_23._ui:findTF("Weapon_button_progress")

	local var1_23 = cloneTplTo(arg0_23._progressSkin, arg0_23._buttonContainer)

	var0_23:ConfigSkin(var1_23)
	var0_23:SwitchIcon(arg1_23)
	var0_23:SetTextActive(false)
	table.insert(arg0_23._skillBtnList, var0_23)

	return var0_23
end

function var2_0.generateSubmarineButton(arg0_24, arg1_24)
	local var0_24 = var0_0.Battle.BattleSubmarineButton.New()

	arg0_24._disposableSkin = arg0_24._disposableSkin or arg0_24._ui:findTF("Weapon_button")

	local var1_24 = cloneTplTo(arg0_24._disposableSkin, arg0_24._buttonContainer)

	var0_24:ConfigSkin(var1_24)
	var0_24:SwitchIcon(arg1_24)
	table.insert(arg0_24._skillBtnList, var0_24)

	return var0_24
end

function var2_0.CustomButton(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg1_25) do
		arg0_25._skillBtnList[iter1_25]:SetActive(false)
	end
end

function var2_0.NormalButton(arg0_26)
	arg0_26._chargeBtn:SetActive(true)
	arg0_26._torpedoBtn:SetActive(true)
	arg0_26._airStrikeBtn:SetActive(true)
	arg0_26._boostBtn:SetActive(false)
	arg0_26._diveBtn:SetActive(false)
	arg0_26._floatBtn:SetActive(false)
	arg0_26._specialBtn:SetActive(false)
	arg0_26._shiftBtn:SetActive(false)
	table.insert(arg0_26._activeBtnList, arg0_26._chargeBtn)
	table.insert(arg0_26._activeBtnList, arg0_26._torpedoBtn)
	table.insert(arg0_26._activeBtnList, arg0_26._airStrikeBtn)
	table.insert(arg0_26._delayAnimaList, arg0_26._chargeBtn)
	table.insert(arg0_26._delayAnimaList, arg0_26._torpedoBtn)
	table.insert(arg0_26._delayAnimaList, arg0_26._airStrikeBtn)

	if arg0_26._subStriveBtn then
		table.insert(arg0_26._delayAnimaList, arg0_26._subStriveBtn)
	end
end

function var2_0.SubmarineButton(arg0_27)
	arg0_27._chargeBtn:SetActive(false)
	arg0_27._torpedoBtn:SetActive(true)
	arg0_27._airStrikeBtn:SetActive(false)
	arg0_27._boostBtn:SetActive(true)
	arg0_27._diveBtn:SetActive(true)
	arg0_27._floatBtn:SetActive(true)
	table.insert(arg0_27._activeBtnList, arg0_27._diveBtn)
	table.insert(arg0_27._activeBtnList, arg0_27._torpedoBtn)
	table.insert(arg0_27._activeBtnList, arg0_27._boostBtn)
	table.insert(arg0_27._activeBtnList, arg0_27._floatBtn)
	table.insert(arg0_27._delayAnimaList, arg0_27._floatBtn)
	table.insert(arg0_27._delayAnimaList, arg0_27._torpedoBtn)
	table.insert(arg0_27._delayAnimaList, arg0_27._boostBtn)

	local var0_27 = arg0_27._torpedoBtn:GetSkin().transform
	local var1_27 = var1_0.SKILL_BUTTON_DEFAULT_PREFERENCE[2]

	var0_27.anchorMin = Vector2(var1_27.x, var1_27.y)
	var0_27.anchorMax = Vector2(var1_27.x, var1_27.y)
end

function var2_0.SubRoutineButton(arg0_28)
	arg0_28._chargeBtn:SetActive(false)
	arg0_28._torpedoBtn:SetActive(true)
	arg0_28._airStrikeBtn:SetActive(false)
	arg0_28._boostBtn:SetActive(false)
	arg0_28._diveBtn:SetActive(true)
	arg0_28._floatBtn:SetActive(true)
	arg0_28._specialBtn:SetActive(true)
	arg0_28._shiftBtn:SetActive(true)
	table.insert(arg0_28._activeBtnList, arg0_28._diveBtn)
	table.insert(arg0_28._activeBtnList, arg0_28._torpedoBtn)
	table.insert(arg0_28._activeBtnList, arg0_28._specialBtn)
	table.insert(arg0_28._activeBtnList, arg0_28._floatBtn)
	table.insert(arg0_28._activeBtnList, arg0_28._shiftBtn)
	table.insert(arg0_28._delayAnimaList, arg0_28._floatBtn)
	table.insert(arg0_28._delayAnimaList, arg0_28._torpedoBtn)
	table.insert(arg0_28._delayAnimaList, arg0_28._shiftBtn)
	table.insert(arg0_28._delayAnimaList, arg0_28._specialBtn)
	arg0_28:setSkillButtonPreferences(arg0_28._diveBtn:GetSkin(), 1)
	arg0_28:setSkillButtonPreferences(arg0_28._floatBtn:GetSkin(), 1)
	arg0_28:setSkillButtonPreferences(arg0_28._torpedoBtn:GetSkin(), 2)
	arg0_28:setSkillButtonPreferences(arg0_28._shiftBtn:GetSkin(), 3)
	arg0_28:setSkillButtonPreferences(arg0_28._specialBtn:GetSkin(), 4)
end

function var2_0.AirFightButton(arg0_29)
	local var0_29 = {
		9
	}

	for iter0_29, iter1_29 in ipairs(arg0_29._skillBtnList) do
		local var1_29 = table.indexof(var0_29, iter0_29)

		iter1_29:SetActive(var1_29)

		if var1_29 then
			table.insert(arg0_29._activeBtnList, iter1_29)
			arg0_29:setSkillButtonPreferences(iter1_29:GetSkin(), var1_29)
		end
	end
end

function var2_0.ButtonInitialAnima(arg0_30)
	for iter0_30, iter1_30 in ipairs(arg0_30._delayAnimaList) do
		iter1_30:InitialAnima(iter0_30 * 0.2)
	end
end

function var2_0.CardPuzzleButton(arg0_31)
	arg0_31._chargeBtn:SetActive(false)
	arg0_31._torpedoBtn:SetActive(false)
	arg0_31._airStrikeBtn:SetActive(false)
	arg0_31._boostBtn:SetActive(false)
	arg0_31._diveBtn:SetActive(false)
	arg0_31._floatBtn:SetActive(false)
	arg0_31._specialBtn:SetActive(false)
	arg0_31._shiftBtn:SetActive(false)
end

function var2_0.HideSkillButton(arg0_32, arg1_32)
	for iter0_32, iter1_32 in ipairs(arg0_32._activeBtnList) do
		iter1_32:SetActive(not arg1_32)
	end
end

function var2_0.OnSkillCd(arg0_33, arg1_33)
	local var0_33 = arg1_33.Data.skillID
	local var1_33 = arg1_33.Data.coolDownTime

	if var1_33 < pg.TimeMgr.GetInstance():GetCombatTime() then
		return
	end

	arg0_33._skillCd[var0_33] = var1_33
end

function var2_0.Dispose(arg0_34)
	arg0_34._delayAnimaList = nil
	arg0_34._activeBtnList = nil

	for iter0_34, iter1_34 in ipairs(arg0_34._skillBtnList) do
		iter1_34:Dispose()
	end

	arg0_34._ui = nil

	if arg0_34._main_cannon_sound then
		arg0_34._main_cannon_sound:Stop(true)

		arg0_34._main_cannon_sound = nil
	end

	var0_0.EventListener.DetachEventListener(arg0_34)
end

function var2_0.Update(arg0_35)
	for iter0_35, iter1_35 in ipairs(arg0_35._skillBtnList) do
		iter1_35:Update()
	end
end

function var2_0.setSkillButtonPreferences(arg0_36, arg1_36, arg2_36)
	local var0_36 = var1_0.SKILL_BUTTON_DEFAULT_PREFERENCE[arg2_36]
	local var1_36 = PlayerPrefs.GetFloat("skill_" .. arg2_36 .. "_scale", var0_36.scale)
	local var2_36 = PlayerPrefs.GetFloat("skill_" .. arg2_36 .. "_anchorX", var0_36.x)
	local var3_36 = PlayerPrefs.GetFloat("skill_" .. arg2_36 .. "_anchorY", var0_36.y)
	local var4_36 = arg1_36.transform

	var4_36.localScale = Vector3(var1_36, var1_36, 0)
	var4_36.anchorMin = Vector2(var2_36, var3_36)
	var4_36.anchorMax = Vector2(var2_36, var3_36)
end
