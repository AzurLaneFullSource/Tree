ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleUnitEvent
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleVariable
local var5_0 = var0_0.Battle.BattleConfig
local var6_0 = var0_0.Battle.BattleCardPuzzleEvent
local var7_0 = class("BattleUIMediator", var0_0.MVC.Mediator)

var0_0.Battle.BattleUIMediator = var7_0
var7_0.__name = "BattleUIMediator"

function var7_0.Ctor(arg0_1)
	var7_0.super.Ctor(arg0_1)
end

function var7_0.SetBattleUI(arg0_2)
	arg0_2._ui = arg0_2._state:GetUI()
end

function var7_0.Initialize(arg0_3)
	var7_0.super.Initialize(arg0_3)

	arg0_3._dataProxy = arg0_3._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)
	arg0_3._uiMGR = pg.UIMgr.GetInstance()
	arg0_3._fxPool = var0_0.Battle.BattleFXPool.GetInstance()
	arg0_3._updateViewList = {}

	arg0_3:SetBattleUI()
	arg0_3:AddUIEvent()
	arg0_3:InitCamera()
	arg0_3:InitGuide()
end

function var7_0.Reinitialize(arg0_4)
	arg0_4._skillView:Dispose()
end

function var7_0.EnableComponent(arg0_5, arg1_5)
	arg0_5._ui:findTF("PauseBtn"):GetComponent(typeof(Button)).enabled = arg1_5

	arg0_5._skillView:EnableWeaponButton(arg1_5)
end

function var7_0.EnableJoystick(arg0_6, arg1_6)
	arg0_6._stickController.enabled = arg1_6

	local var0_6 = arg0_6._joystick:GetComponent(typeof(Animation))

	if var0_6 then
		var0_6.enabled = arg1_6
	end

	local var1_6 = arg0_6._joystick:GetComponent(typeof(Animator))

	if var1_6 then
		var1_6.enabled = arg1_6
	end

	setActive(arg0_6._joystick, arg1_6)

	local var2_6 = arg0_6._joystick:Find("Area/BG/spine")

	if var2_6 then
		local var3_6 = var2_6:GetComponent(typeof(SpineAnimUI))

		if arg1_6 then
			var3_6:SetAction("cut_in", 0)
		end
	end
end

function var7_0.EnableWeaponButton(arg0_7, arg1_7)
	arg0_7._skillView:EnableWeaponButton(arg1_7)
end

function var7_0.EnableSkillFloat(arg0_8, arg1_8)
	arg0_8._ui:EnableSkillFloat(arg1_8)
end

function var7_0.GetAppearFX(arg0_9)
	return arg0_9._appearEffect
end

function var7_0.DisableComponent(arg0_10)
	arg0_10._ui:findTF("PauseBtn"):GetComponent(typeof(Button)).enabled = false

	arg0_10._skillView:DisableWeapnButton()
	SetActive(arg0_10._ui:findTF("HPBarContainer"), false)
	SetActive(arg0_10._ui:findTF("flagShipMark"), false)

	if arg0_10._jammingView then
		arg0_10._jammingView:Eliminate(false)
	end

	if arg0_10._inkView then
		arg0_10._inkView:SetActive(false)
	end
end

function var7_0.ActiveDebugConsole(arg0_11)
	arg0_11._debugConsoleView:SetActive(true)
end

function var7_0.OpeningEffect(arg0_12, arg1_12, arg2_12)
	arg0_12._uiMGR:SetActive(false)

	if arg2_12 == SYSTEM_SUBMARINE_RUN then
		arg0_12._skillView:SubmarineButton()

		local var0_12 = var5_0.JOY_STICK_DEFAULT_PREFERENCE

		arg0_12._joystick.anchorMin = Vector2(var0_12.x, var0_12.y)
		arg0_12._joystick.anchorMax = Vector2(var0_12.x, var0_12.y)
	elseif arg2_12 == SYSTEM_SUB_ROUTINE then
		arg0_12._skillView:SubRoutineButton()
	elseif arg2_12 == SYSTEM_AIRFIGHT then
		arg0_12._skillView:AirFightButton()
	elseif arg2_12 == SYSTEM_DEBUG then
		arg0_12._skillView:NormalButton()
	elseif arg2_12 == SYSTEM_CARDPUZZLE then
		arg0_12._skillView:CardPuzzleButton()
	else
		local var1_12 = pg.SeriesGuideMgr.GetInstance()

		if var1_12.currIndex and var1_12:isEnd() then
			arg0_12._skillView:NormalButton()
		else
			local var2_12 = arg0_12._dataProxy:GetDungeonData().skill_hide or {}

			arg0_12._skillView:CustomButton(var2_12)
		end
	end

	LeanTween.delayedCall(var5_0.COMBAT_DELAY_ACTIVE, System.Action(function()
		arg0_12._uiMGR:SetActive(true)
		arg0_12:EnableComponent(true)

		if arg1_12 then
			arg1_12()
		end
	end))
	SetActive(arg0_12._ui._go, true)
	arg0_12._skillView:ButtonInitialAnima()
end

function var7_0.InitScene(arg0_14)
	arg0_14._mapId = arg0_14._dataProxy._mapId
	arg0_14._seaView = var0_0.Battle.BattleMap.New(arg0_14._mapId)
end

function var7_0.InitJoystick(arg0_15)
	arg0_15._joystick = arg0_15._ui:findTF("Stick")

	local var0_15 = var5_0.JOY_STICK_DEFAULT_PREFERENCE
	local var1_15 = arg0_15._joystick
	local var2_15 = Screen.dpi / CameraMgr.instance.finalWidth * 5

	if PLATFORM == PLATFORM_WINDOWSEDITOR or var2_15 <= 0 then
		var2_15 = 1
	end

	local var3_15 = PlayerPrefs.GetFloat("joystick_scale", var0_15.scale)
	local var4_15 = PlayerPrefs.GetFloat("joystick_anchorX", var0_15.x)
	local var5_15 = PlayerPrefs.GetFloat("joystick_anchorY", var0_15.y)
	local var6_15 = var2_15 * var3_15

	arg0_15._joystick.localScale = Vector3(var6_15, var6_15, 1)
	var1_15.anchoredPosition = var1_15.anchoredPosition * var6_15
	arg0_15._joystick.anchorMin = Vector2(var4_15, var5_15)
	arg0_15._joystick.anchorMax = Vector2(var4_15, var5_15)
	arg0_15._stickController = arg0_15._joystick:GetComponent("StickController")

	arg0_15._uiMGR:AttachStickOb(arg0_15._joystick)

	local var7_15 = arg0_15._joystick:Find("Area/BG/spine")

	if var7_15 then
		local var8_15 = var7_15:GetComponent(typeof(SpineAnimUI))

		var8_15:SetActionCallBack(function(arg0_16)
			if arg0_16 == "finish" then
				if arg0_15._stickController.enabled then
					var8_15:SetAction("normal", 0)
				else
					SetActive(arg0_15._joystick, false)
				end
			end
		end)
	end
end

function var7_0.InitTimer(arg0_17)
	if arg0_17._dataProxy:GetInitData().battleType == SYSTEM_DUEL then
		arg0_17._timerView = var0_0.Battle.BattleTimerView.New(arg0_17._ui:findTF("DuelTimer"))
	else
		arg0_17._timerView = var0_0.Battle.BattleTimerView.New(arg0_17._ui:findTF("Timer"))
	end
end

function var7_0.InitEnemyHpBar(arg0_18)
	arg0_18._enemyHpBar = var0_0.Battle.BattleEnmeyHpBarView.New(arg0_18._ui:findTF("EnemyHPBar"))
end

function var7_0.InitAirStrikeIcon(arg0_19)
	arg0_19._airStrikeView = var0_0.Battle.BattleAirStrikeIconView.New(arg0_19._ui:findTF("AirFighterContainer/AirStrikeIcon"))
	arg0_19._airSupportTF = arg0_19._ui:findTF("AirSupportLabel")
end

function var7_0.InitCommonWarning(arg0_20)
	arg0_20._warningView = var0_0.Battle.BattleCommonWarningView.New(arg0_20._ui:findTF("WarningView"))
	arg0_20._updateViewList[arg0_20._warningView] = true
end

function var7_0.InitScoreBar(arg0_21)
	arg0_21._scoreBarView = var0_0.Battle.BattleScoreBarView.New(arg0_21._ui:findTF("DodgemCountBar"))
end

function var7_0.InitAirFightScoreBar(arg0_22)
	arg0_22._scoreBarView = var0_0.Battle.BattleScoreBarView.New(arg0_22._ui:findTF("AirFightCountBar"))
end

function var7_0.InitAutoBtn(arg0_23)
	arg0_23._autoBtn = arg0_23._ui:findTF("AutoBtn")

	local var0_23 = var5_0.AUTO_DEFAULT_PREFERENCE
	local var1_23 = PlayerPrefs.GetFloat("auto_scale", var0_23.scale)
	local var2_23 = PlayerPrefs.GetFloat("auto_anchorX", var0_23.x)
	local var3_23 = PlayerPrefs.GetFloat("auto_anchorY", var0_23.y)

	arg0_23._autoBtn.localScale = Vector3(var1_23, var1_23, 1)
	arg0_23._autoBtn.anchorMin = Vector2(var2_23, var3_23)
	arg0_23._autoBtn.anchorMax = Vector2(var2_23, var3_23)
end

function var7_0.InitDuelRateBar(arg0_24)
	arg0_24._duelRateBar = var0_0.Battle.BattleDuelDamageRateView.New(arg0_24._ui:findTF("DuelDamageRate"))

	return arg0_24._duelRateBar
end

function var7_0.InitSimulationBuffCounting(arg0_25)
	arg0_25._simulationBuffCountView = var0_0.Battle.BattleSimulationBuffCountView.New(arg0_25._ui:findTF("SimulationWarning"))

	return arg0_25._simulationBuffCountView
end

function var7_0.InitMainDamagedView(arg0_26)
	arg0_26._mainDamagedView = var0_0.Battle.BattleMainDamagedView.New(arg0_26._ui:findTF("HPWarning"))
end

function var7_0.InitInkView(arg0_27, arg1_27)
	arg0_27._inkView = var0_0.Battle.BattleInkView.New(arg0_27._ui:findTF("InkContainer"))

	arg1_27:RegisterEventListener(arg0_27, var1_0.FLEET_HORIZON_UPDATE, arg0_27.onFleetHorizonUpdate)
end

function var7_0.InitDebugConsole(arg0_28)
	arg0_28._debugConsoleView = arg0_28._debugConsoleView or var0_0.Battle.BattleDebugConsole.New(arg0_28._ui:findTF("Debug_Console"), arg0_28._state)
end

function var7_0.InitCameraGestureSlider(arg0_29)
	arg0_29._gesture = var0_0.Battle.BattleCameraSlider.New(arg0_29._ui:findTF("CameraController"))

	var0_0.Battle.BattleCameraUtil.GetInstance():SetCameraSilder(arg0_29._gesture)
	arg0_29._cameraUtil:SwitchCameraPos("FOLLOW_GESTURE")
end

function var7_0.InitAlchemistAPView(arg0_30)
	arg0_30._alchemistAP = var0_0.Battle.BattleReisalinAPView.New(arg0_30._ui:findTF("APPanel"))
end

function var7_0.InitGuide(arg0_31)
	return
end

function var7_0.InitCamera(arg0_32)
	arg0_32._camera = pg.UIMgr.GetInstance():GetMainCamera():GetComponent(typeof(Camera))
	arg0_32._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0_32._cameraUtil = var0_0.Battle.BattleCameraUtil.GetInstance()

	arg0_32._cameraUtil:RegisterEventListener(arg0_32, var1_0.CAMERA_FOCUS, arg0_32.onCameraFocus)
	arg0_32._cameraUtil:RegisterEventListener(arg0_32, var1_0.SHOW_PAINTING, arg0_32.onShowPainting)
	arg0_32._cameraUtil:RegisterEventListener(arg0_32, var1_0.BULLET_TIME, arg0_32.onBulletTime)
end

function var7_0.Update(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33._updateViewList) do
		iter0_33:Update()
	end
end

function var7_0.AddUIEvent(arg0_34)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.STAGE_DATA_INIT_FINISH, arg0_34.onStageInit)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.COMMON_DATA_INIT_FINISH, arg0_34.onCommonInit)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.ADD_FLEET, arg0_34.onAddFleet)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.ADD_UNIT, arg0_34.onAddUnit)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.REMOVE_UNIT, arg0_34.onRemoveUnit)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.HIT_ENEMY, arg0_34.onEnemyHit)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.ADD_AIR_FIGHTER_ICON, arg0_34.onAddAirStrike)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.REMOVE_AIR_FIGHTER_ICON, arg0_34.onRemoveAirStrike)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.UPDATE_AIR_SUPPORT_LABEL, arg0_34.onUpdateAirSupportLabel)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.UPDATE_HOSTILE_SUBMARINE, arg0_34.onUpdateHostileSubmarine)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.UPDATE_ENVIRONMENT_WARNING, arg0_34.onUpdateEnvironmentWarning)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.UPDATE_COUNT_DOWN, arg0_34.onUpdateCountDown)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.HIDE_INTERACTABLE_BUTTONS, arg0_34.OnHideButtons)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.ADD_UI_FX, arg0_34.OnAddUIFX)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.EDIT_CUSTOM_WARNING_LABEL, arg0_34.onEditCustomWarning)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var1_0.GRIDMAN_SKILL_FLOAT, arg0_34.onGridmanSkillFloat)
	arg0_34._dataProxy:RegisterEventListener(arg0_34, var6_0.CARD_PUZZLE_INIT, arg0_34.OnCardPuzzleInit)
end

function var7_0.RemoveUIEvent(arg0_35)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.COMMON_DATA_INIT_FINISH)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.STAGE_DATA_INIT_FINISH)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.ADD_FLEET)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.ADD_UNIT)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.REMOVE_UNIT)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.HIT_ENEMY)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.UPDATE_COUNT_DOWN)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.ADD_AIR_FIGHTER_ICON)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.REMOVE_AIR_FIGHTER_ICON)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.UPDATE_AIR_SUPPORT_LABEL)
	arg0_35._cameraUtil:UnregisterEventListener(arg0_35, var1_0.SHOW_PAINTING)
	arg0_35._cameraUtil:UnregisterEventListener(arg0_35, var1_0.CAMERA_FOCUS)
	arg0_35._cameraUtil:UnregisterEventListener(arg0_35, var1_0.BULLET_TIME)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.ADD_SUBMARINE_WARINING)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.REMOVE_SUBMARINE_WARINING)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.UPDATE_DODGEM_SCORE)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.UPDATE_DODGEM_COMBO)
	arg0_35._userFleet:UnregisterEventListener(arg0_35, var1_0.SHOW_BUFFER)
	arg0_35._userFleet:UnregisterEventListener(arg0_35, var2_0.POINT_HIT_CHARGE)
	arg0_35._userFleet:UnregisterEventListener(arg0_35, var2_0.POINT_HIT_CANCEL)
	arg0_35._userFleet:UnregisterEventListener(arg0_35, var1_0.MANUAL_SUBMARINE_SHIFT)
	arg0_35._userFleet:UnregisterEventListener(arg0_35, var1_0.FLEET_BLIND)
	arg0_35._userFleet:UnregisterEventListener(arg0_35, var1_0.FLEET_HORIZON_UPDATE)
	arg0_35._userFleet:UnregisterEventListener(arg0_35, var1_0.UPDATE_FLEET_ATTR)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.UPDATE_HOSTILE_SUBMARINE)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.UPDATE_ENVIRONMENT_WARNING)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.HIDE_INTERACTABLE_BUTTONS)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.ADD_UI_FX)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.EDIT_CUSTOM_WARNING_LABEL)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var1_0.GRIDMAN_SKILL_FLOAT)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var6_0.CARD_PUZZLE_INIT)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var6_0.UPDATE_FLEET_SHIP)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var6_0.COMMON_BUTTON_ENABLE)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var6_0.LONG_PRESS_BULLET_TIME)
	arg0_35._dataProxy:UnregisterEventListener(arg0_35, var6_0.SHOW_CARD_DETAIL)
end

function var7_0.ShowSkillPainting(arg0_36, arg1_36, arg2_36, arg3_36)
	arg3_36 = arg3_36 or 1

	local var0_36

	if arg2_36 then
		var0_36 = arg2_36.cutin_cover
	end

	arg0_36._ui:CutInPainting(arg1_36:GetTemplate(), arg3_36, arg1_36:GetIFF(), var0_36)
end

function var7_0.ShowSkillFloat(arg0_37, arg1_37, arg2_37, arg3_37)
	arg0_37._ui:SkillHrzPop(arg2_37, arg1_37, arg3_37)
end

function var7_0.ShowSkillFloatCover(arg0_38, arg1_38, arg2_38, arg3_38)
	arg0_38._ui:SkillHrzPopCover(arg2_38, arg1_38, arg3_38)
end

function var7_0.SeaSurfaceShift(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	local var0_39 = arg3_39 or var0_0.Battle.BattleConfig.calcInterval

	arg0_39._seaView:ShiftSurface(arg1_39, arg2_39, var0_39, arg4_39)
end

function var7_0.ShowAutoBtn(arg0_40)
	SetActive(arg0_40._autoBtn.transform, true)

	local var0_40 = arg0_40:GetState():GetBattleType()

	triggerToggle(arg0_40._autoBtn, var0_0.Battle.BattleState.IsAutoBotActive(var0_40))
end

function var7_0.ShowTimer(arg0_41)
	arg0_41._timerView:SetActive(true)
end

function var7_0.ShowDuelBar(arg0_42)
	arg0_42._duelRateBar:SetActive(true)
end

function var7_0.ShowSimulationView(arg0_43)
	arg0_43._simulationBuffCountView:SetActive(true)
end

function var7_0.ShowPauseButton(arg0_44, arg1_44)
	setActive(arg0_44._ui:findTF("PauseBtn"), arg1_44)
end

function var7_0.ShowDodgemScoreBar(arg0_45)
	arg0_45:InitScoreBar()
	arg0_45._dataProxy:RegisterEventListener(arg0_45, var1_0.UPDATE_DODGEM_SCORE, arg0_45.onUpdateDodgemScore)
	arg0_45._dataProxy:RegisterEventListener(arg0_45, var1_0.UPDATE_DODGEM_COMBO, arg0_45.onUpdateDodgemCombo)
	arg0_45._scoreBarView:UpdateScore(0)
	arg0_45._scoreBarView:SetActive(true)
end

function var7_0.ShowAirFightScoreBar(arg0_46)
	arg0_46:InitAirFightScoreBar()
	arg0_46._dataProxy:RegisterEventListener(arg0_46, var1_0.UPDATE_DODGEM_SCORE, arg0_46.onUpdateDodgemScore)
	arg0_46._dataProxy:RegisterEventListener(arg0_46, var1_0.UPDATE_DODGEM_COMBO, arg0_46.onUpdateDodgemCombo)
	arg0_46._scoreBarView:UpdateScore(0)
	arg0_46._scoreBarView:SetActive(true)
end

function var7_0.ScaleUISpeed(arg0_47, arg1_47)
	local var0_47 = arg0_47._ui:findTF("AutoBtn/on"):GetComponent(typeof(Animation))

	if var0_47 then
		var0_47:get_Item("autobtn_toOn").speed = arg1_47
	end

	local var1_47 = arg0_47._ui:findTF("AutoBtn/off"):GetComponent(typeof(Animation))

	if var1_47 then
		var1_47:get_Item("autobtn_toOff").speed = arg1_47
	end
end

function var7_0.onStageInit(arg0_48, arg1_48)
	arg0_48:InitJoystick()
	arg0_48:InitScene()
	arg0_48:InitTimer()
	arg0_48:InitEnemyHpBar()
	arg0_48:InitAirStrikeIcon()
	arg0_48:InitCommonWarning()
	arg0_48:InitAutoBtn()
	arg0_48:InitMainDamagedView()
end

function var7_0.onEnemyHit(arg0_49, arg1_49)
	local var0_49 = arg1_49.Data

	if var0_49:GetDiveInvisible() and not var0_49:GetDiveDetected() then
		return
	end

	local var1_49 = arg0_49._enemyHpBar:GetCurrentTarget()

	if var1_49 then
		if var1_49 ~= var0_49 then
			arg0_49._enemyHpBar:SwitchTarget(var0_49, arg0_49._dataProxy:GetUnitList())
		end
	else
		arg0_49._enemyHpBar:SwitchTarget(var0_49, arg0_49._dataProxy:GetUnitList())
	end
end

function var7_0.onEnemyHpUpdate(arg0_50, arg1_50)
	local var0_50 = arg1_50.Dispatcher

	if var0_50 == arg0_50._enemyHpBar:GetCurrentTarget() and (not var0_50:GetDiveInvisible() or var0_50:GetDiveDetected()) then
		arg0_50._enemyHpBar:UpdateHpBar()
	end
end

function var7_0.onPlayerMainUnitHpUpdate(arg0_51, arg1_51)
	if arg1_51.Data.dHP < 0 then
		arg0_51._mainDamagedView:Play()
	end
end

function var7_0.onSkillFloat(arg0_52, arg1_52)
	local var0_52 = arg1_52.Data
	local var1_52 = var0_52.coverHrzIcon
	local var2_52 = var0_52.commander
	local var3_52 = var0_52.skillName
	local var4_52 = arg1_52.Dispatcher

	if var1_52 then
		arg0_52:ShowSkillFloatCover(var4_52, var3_52, var1_52)
	else
		arg0_52:ShowSkillFloat(var4_52, var3_52, var2_52)
	end
end

function var7_0.onCommonInit(arg0_53, arg1_53)
	arg0_53._skillView = var0_0.Battle.BattleSkillView.New(arg0_53, arg1_53.Data)
	arg0_53._updateViewList[arg0_53._skillView] = true
	arg0_53._userFleet = arg0_53._dataProxy:GetFleetByIFF(var5_0.FRIENDLY_CODE)

	arg0_53._userFleet:RegisterEventListener(arg0_53, var1_0.SHOW_BUFFER, arg0_53.onShowBuffer)
	arg0_53._userFleet:RegisterEventListener(arg0_53, var2_0.POINT_HIT_CHARGE, arg0_53.onPointHitSight)
	arg0_53._userFleet:RegisterEventListener(arg0_53, var2_0.POINT_HIT_CANCEL, arg0_53.onPointHitSight)
	arg0_53._userFleet:RegisterEventListener(arg0_53, var1_0.MANUAL_SUBMARINE_SHIFT, arg0_53.onManualSubShift)
	arg0_53._userFleet:RegisterEventListener(arg0_53, var1_0.FLEET_BLIND, arg0_53.onFleetBlind)
	arg0_53._userFleet:RegisterEventListener(arg0_53, var1_0.UPDATE_FLEET_ATTR, arg0_53.onFleetAttrUpdate)

	arg0_53._sightView = var0_0.Battle.BattleOpticalSightView.New(arg0_53._ui:findTF("ChargeAreaContainer"))

	arg0_53._sightView:SetFleetVO(arg0_53._userFleet)

	local var0_53, var1_53, var2_53, var3_53 = arg0_53._dataProxy:GetTotalBounds()

	arg0_53._sightView:SetAreaBound(var2_53, var3_53)

	local var4_53
	local var5_53

	if arg0_53._dataProxy:GetInitData().ChapterBuffIDs then
		for iter0_53, iter1_53 in ipairs(arg0_53._dataProxy:GetInitData().ChapterBuffIDs) do
			if iter1_53 == 9727 then
				var4_53 = true

				break
			end
		end
	end

	if #arg0_53._dataProxy:GetFleetByIFF(var5_0.FRIENDLY_CODE):GetSupportUnitList() > 0 then
		var5_53 = true
	end

	if var5_53 and not var4_53 then
		arg0_53._airAdavantageTF = arg0_53._airSupportTF:Find("player_advantage")
	elseif var4_53 and not var5_53 then
		arg0_53._airAdavantageTF = arg0_53._airSupportTF:Find("enemy_advantage")
	elseif var4_53 and var5_53 then
		arg0_53._airAdavantageTF = arg0_53._airSupportTF:Find("draw")
	end
end

function var7_0.onAddFleet(arg0_54, arg1_54)
	local var0_54 = arg1_54.Data.fleetVO

	if PlayerPrefs.GetInt(BATTLE_EXPOSE_LINE, 1) == 1 then
		arg0_54:SetFleetCloakLine(var0_54)
	end
end

function var7_0.SetFleetCloakLine(arg0_55, arg1_55)
	if #arg1_55:GetCloakList() > 0 then
		local var0_55 = arg1_55:GetIFF()
		local var1_55 = arg1_55:GetFleetVisionLine()
		local var2_55 = arg1_55:GetFleetExposeLine()

		arg0_55._seaView:SetExposeLine(var0_55, var1_55, var2_55)
	end
end

function var7_0.onAddUnit(arg0_56, arg1_56)
	local var0_56 = arg1_56.Data.type
	local var1_56 = arg1_56.Data.unit

	if var0_56 == var3_0.UnitType.PLAYER_UNIT or var0_56 == var3_0.UnitType.ENEMY_UNIT or var0_56 == var3_0.UnitType.BOSS_UNIT then
		arg0_56:registerUnitEvent(var1_56)
	end

	if var1_56:IsBoss() and arg0_56._dataProxy:GetActiveBossCount() == 1 then
		arg0_56:AddBossWarningUI()
	elseif var0_56 == var3_0.UnitType.ENEMY_UNIT then
		arg0_56:registerNPCUnitEvent(var1_56)
	elseif var0_56 == var3_0.UnitType.PLAYER_UNIT and var1_56:IsMainFleetUnit() and var1_56:GetIFF() == var5_0.FRIENDLY_CODE then
		arg0_56:registerPlayerMainUnitEvent(var1_56)
	end

	local var2_56 = var1_56:GetTemplate().nationality

	if table.contains(var5_0.ALCHEMIST_AP_UI, var2_56) and var1_56:GetIFF() == var5_0.FRIENDLY_CODE then
		arg0_56:InitAlchemistAPView()
	end
end

function var7_0.onSubmarineDetected(arg0_57, arg1_57)
	local var0_57 = arg1_57.Dispatcher

	if arg0_57._enemyHpBar:GetCurrentTarget() and arg0_57._enemyHpBar:GetCurrentTarget() == var0_57 and var0_57:GetDiveDetected() == false then
		arg0_57._enemyHpBar:RemoveUnit()
	end
end

function var7_0.onRemoveUnit(arg0_58, arg1_58)
	local var0_58 = arg1_58.Data.unit
	local var1_58 = arg1_58.Data.type

	if var1_58 == var3_0.UnitType.PLAYER_UNIT or var1_58 == var3_0.UnitType.ENEMY_UNIT or var1_58 == var3_0.UnitType.BOSS_UNIT then
		arg0_58:unregisterUnitEvent(var0_58)
	end

	if var1_58 == var3_0.UnitType.ENEMY_UNIT and not var0_58:IsBoss() then
		arg0_58:unregisterNPCUnitEvent(var0_58)
	elseif var0_58:GetIFF() == var5_0.FRIENDLY_CODE and var0_58:IsMainFleetUnit() then
		arg0_58:unregisterPlayerMainUnitEvent(var0_58)
	end

	if arg1_58.Data.deadReason == var3_0.UnitDeathReason.LEAVE and arg0_58._enemyHpBar:GetCurrentTarget() and arg0_58._enemyHpBar:GetCurrentTarget() == arg1_58.Data.unit then
		arg0_58._enemyHpBar:RemoveUnit(arg1_58.Data.deadReason)
	end
end

function var7_0.onUpdateCountDown(arg0_59, arg1_59)
	arg0_59._timerView:SetCountDownText(arg0_59._dataProxy:GetCountDown())
end

function var7_0.onUpdateDodgemScore(arg0_60, arg1_60)
	local var0_60 = arg1_60.Data.totalScore

	arg0_60._scoreBarView:UpdateScore(var0_60)
end

function var7_0.onUpdateDodgemCombo(arg0_61, arg1_61)
	local var0_61 = arg1_61.Data.combo

	arg0_61._scoreBarView:UpdateCombo(var0_61)
end

function var7_0.onAddAirStrike(arg0_62, arg1_62)
	local var0_62 = arg1_62.Data.index
	local var1_62 = arg0_62._dataProxy:GetAirFighterInfo(var0_62)

	arg0_62._airStrikeView:AppendIcon(var0_62, var1_62)
end

function var7_0.onRemoveAirStrike(arg0_63, arg1_63)
	local var0_63 = arg1_63.Data.index
	local var1_63 = arg0_63._dataProxy:GetAirFighterInfo(var0_63)

	arg0_63._airStrikeView:RemoveIcon(var0_63, var1_63)
end

function var7_0.onUpdateAirSupportLabel(arg0_64, arg1_64)
	local var0_64 = arg0_64._dataProxy:GetAirFighterList()
	local var1_64 = 0

	for iter0_64, iter1_64 in ipairs(var0_64) do
		var1_64 = var1_64 + iter1_64.totalNumber
	end

	if var1_64 == 0 or arg0_64._warningView:GetCount() > 0 then
		eachChild(arg0_64._airSupportTF, function(arg0_65)
			setActive(arg0_65, false)
		end)
	elseif arg0_64._airAdavantageTF then
		setActive(arg0_64._airAdavantageTF, true)
	end
end

function var7_0.onUpdateHostileSubmarine(arg0_66, arg1_66)
	local var0_66 = arg0_66._dataProxy:GetEnemySubmarineCount()

	arg0_66._warningView:UpdateHostileSubmarineCount(var0_66)
	arg0_66:onUpdateAirSupportLabel()
end

function var7_0.onUpdateEnvironmentWarning(arg0_67, arg1_67)
	if arg1_67.Data.isActive then
		arg0_67._warningView:ActiveWarning(arg0_67._warningView.WARNING_TYPE_ARTILLERY)
	else
		arg0_67._warningView:DeactiveWarning(arg0_67._warningView.WARNING_TYPE_ARTILLERY)
	end
end

function var7_0.onCameraFocus(arg0_68, arg1_68)
	local var0_68 = arg1_68.Data

	if var0_68.unit ~= nil then
		local var1_68 = var0_68.skill or false

		arg0_68:EnableComponent(false)
		arg0_68:EnableSkillFloat(var1_68)
	else
		local var2_68 = var0_68.duration + var0_68.extraBulletTime

		LeanTween.delayedCall(arg0_68._ui._go, var2_68, System.Action(function()
			arg0_68:EnableComponent(true)
			arg0_68:EnableSkillFloat(true)
		end))
	end
end

function var7_0.onShowPainting(arg0_70, arg1_70)
	local var0_70 = arg1_70.Data

	arg0_70:ShowSkillPainting(var0_70.caster, var0_70.skill, var0_70.speed)
end

function var7_0.onBulletTime(arg0_71, arg1_71)
	local var0_71 = arg1_71.Data
	local var1_71 = var0_71.key
	local var2_71 = var0_71.rate

	if var2_71 then
		var4_0.AppendMapFactor(var1_71, var2_71)
	else
		var4_0.RemoveMapFactor(var1_71)
	end

	arg0_71._seaView:UpdateSpeedScaler()
end

function var7_0.onShowBuffer(arg0_72, arg1_72)
	local var0_72 = arg1_72.Data.dist

	arg0_72._seaView:UpdateBufferAlpha(var0_72)
end

function var7_0.onManualSubShift(arg0_73, arg1_73)
	local var0_73 = arg1_73.Data.state

	arg0_73._skillView:ShiftSubmarineManualButton(var0_73)
end

function var7_0.onPointHitSight(arg0_74, arg1_74)
	local var0_74 = arg1_74.ID

	if var0_74 == var2_0.POINT_HIT_CHARGE then
		arg0_74._sightView:SetActive(true)

		arg0_74._updateViewList[arg0_74._sightView] = true
	elseif var0_74 == var2_0.POINT_HIT_CANCEL then
		arg0_74._sightView:SetActive(false)

		arg0_74._updateViewList[arg0_74._sightView] = nil
	end
end

function var7_0.onFleetBlind(arg0_75, arg1_75)
	local var0_75 = arg1_75.Data.isBlind
	local var1_75 = arg1_75.Dispatcher

	if not arg0_75._inkView then
		arg0_75:InitInkView(var1_75)
	end

	if var0_75 then
		local var2_75 = var1_75:GetUnitList()

		arg0_75._inkView:SetActive(true, var2_75)
		arg0_75._skillView:HideSkillButton(true)

		arg0_75._updateViewList[arg0_75._inkView] = true
	else
		arg0_75._inkView:SetActive(false)
		arg0_75._skillView:HideSkillButton(false)

		arg0_75._updateViewList[arg0_75._inkView] = nil
	end
end

function var7_0.onFleetHorizonUpdate(arg0_76, arg1_76)
	if not arg0_76._inkView then
		return
	end

	local var0_76 = arg1_76.Dispatcher:GetUnitList()

	arg0_76._inkView:UpdateHollow(var0_76)
end

function var7_0.onFleetAttrUpdate(arg0_77, arg1_77)
	if arg0_77._alchemistAP then
		local var0_77 = arg1_77.Dispatcher
		local var1_77 = arg1_77.Data.attr
		local var2_77 = arg1_77.Data.value

		if var1_77 == arg0_77._alchemistAP:GetAttrName() then
			arg0_77._alchemistAP:UpdateAP(var2_77)
		end
	end
end

function var7_0.OnAddUIFX(arg0_78, arg1_78)
	local var0_78 = arg1_78.Data.FXID
	local var1_78 = arg1_78.Data.position
	local var2_78 = arg1_78.Data.localScale
	local var3_78 = arg1_78.Data.orderDiff

	arg0_78:AddUIFX(var3_78, var0_78, var1_78, var2_78)
end

function var7_0.AddUIFX(arg0_79, arg1_79, arg2_79, arg3_79, arg4_79)
	local var0_79 = arg0_79._fxPool:GetFX(arg2_79)

	arg1_79 = arg1_79 or 1

	local var1_79

	var1_79 = arg1_79 > 0

	local var2_79 = arg0_79._ui:AddUIFX(var0_79, arg1_79)

	arg4_79 = arg4_79 or 1
	var0_79.transform.localScale = Vector3(arg4_79 / var2_79.x, arg4_79 / var2_79.y, arg4_79 / var2_79.z)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0_79, arg3_79, true)
end

function var7_0.AddBossWarningUI(arg0_80)
	arg0_80._dataProxy:BlockManualCast(true)

	local var0_80 = var0_0.Battle.BattleResourceManager.GetInstance()

	arg0_80._appearEffect = var0_80:InstBossWarningUI()

	local var1_80 = arg0_80._appearEffect:GetComponent(typeof(Animator))
	local var2_80 = {
		Pause = function()
			var1_80.speed = 0
		end,
		Resume = function()
			var1_80.speed = 1
		end
	}

	arg0_80._state:SetTakeoverProcess(var2_80)

	var1_80.speed = 1 / arg0_80._state:GetTimeScaleRate()

	setParent(arg0_80._appearEffect, arg0_80._ui.uiCanvas, false)
	arg0_80._appearEffect:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_83)
		arg0_80._userFleet:CoupleEncourage()
		arg0_80._dataProxy:BlockManualCast(false)
		arg0_80._state:ClearTakeoverProcess()
		var0_80:DestroyOb(arg0_80._appearEffect)

		arg0_80._appearEffect = nil
	end)
	SetActive(arg0_80._appearEffect, true)
end

function var7_0.OnHideButtons(arg0_84, arg1_84)
	local var0_84 = arg1_84.Data.isActive

	arg0_84._skillView:HideSkillButton(not var0_84)
	SetActive(arg0_84._autoBtn.transform, var0_84)
end

function var7_0.onEditCustomWarning(arg0_85, arg1_85)
	local var0_85 = arg1_85.Data.labelData

	arg0_85._warningView:EditCustomWarning(var0_85)
end

function var7_0.onGridmanSkillFloat(arg0_86, arg1_86)
	if not arg0_86._gridmanSkillFloat then
		local var0_86 = var0_0.Battle.BattleResourceManager.GetInstance():InstGridmanSkillUI()

		arg0_86._gridmanSkillFloat = var0_0.Battle.BattleGridmanSkillFloatView.New(var0_86)

		setParent(var0_86, arg0_86._ui.uiCanvas, false)
	end

	local var1_86 = arg1_86.Data
	local var2_86 = var1_86.type
	local var3_86 = var1_86.IFF

	if var2_86 == 5 then
		arg0_86._gridmanSkillFloat:DoFusionFloat(var3_86)
	else
		arg0_86._gridmanSkillFloat:DoSkillFloat(var2_86, var3_86)
	end
end

function var7_0.registerUnitEvent(arg0_87, arg1_87)
	arg1_87:RegisterEventListener(arg0_87, var2_0.SKILL_FLOAT, arg0_87.onSkillFloat)
	arg1_87:RegisterEventListener(arg0_87, var2_0.CUT_INT, arg0_87.onShowPainting)
end

function var7_0.registerNPCUnitEvent(arg0_88, arg1_88)
	arg1_88:RegisterEventListener(arg0_88, var2_0.UPDATE_HP, arg0_88.onEnemyHpUpdate)

	local var0_88 = arg1_88:GetTemplate().type

	if table.contains(TeamType.SubShipType, var0_88) then
		arg1_88:RegisterEventListener(arg0_88, var2_0.SUBMARINE_DETECTED, arg0_88.onSubmarineDetected)
	end
end

function var7_0.registerPlayerMainUnitEvent(arg0_89, arg1_89)
	arg1_89:RegisterEventListener(arg0_89, var2_0.UPDATE_HP, arg0_89.onPlayerMainUnitHpUpdate)
end

function var7_0.unregisterUnitEvent(arg0_90, arg1_90)
	arg1_90:UnregisterEventListener(arg0_90, var2_0.SKILL_FLOAT)
	arg1_90:UnregisterEventListener(arg0_90, var2_0.CUT_INT)
end

function var7_0.unregisterNPCUnitEvent(arg0_91, arg1_91)
	arg1_91:UnregisterEventListener(arg0_91, var2_0.SKILL_FLOAT)
	arg1_91:UnregisterEventListener(arg0_91, var2_0.CUT_INT)
	arg1_91:UnregisterEventListener(arg0_91, var2_0.UPDATE_HP)

	local var0_91 = arg1_91:GetTemplate().type

	if table.contains(TeamType.SubShipType, var0_91) then
		arg1_91:UnregisterEventListener(arg0_91, var2_0.SUBMARINE_DETECTED)
	end
end

function var7_0.unregisterPlayerMainUnitEvent(arg0_92, arg1_92)
	arg1_92:UnregisterEventListener(arg0_92, var2_0.UPDATE_HP)
end

function var7_0.Dispose(arg0_93)
	LeanTween.cancel(arg0_93._ui._go)
	arg0_93._uiMGR:ClearStick()

	arg0_93._uiMGR = nil

	if arg0_93._appearEffect then
		Destroy(arg0_93._appearEffect)
	end

	arg0_93:RemoveUIEvent()

	arg0_93._updateViewList = nil

	arg0_93._timerView:Dispose()
	arg0_93._enemyHpBar:Dispose()
	arg0_93._skillView:Dispose()
	arg0_93._seaView:Dispose()
	arg0_93._airStrikeView:Dispose()
	arg0_93._sightView:Dispose()
	arg0_93._mainDamagedView:Dispose()
	arg0_93._warningView:Dispose()

	arg0_93._seaView = nil
	arg0_93._enemyHpBar = nil
	arg0_93._skillView = nil
	arg0_93._timerView = nil
	arg0_93._joystick = nil
	arg0_93._airStrikeView = nil
	arg0_93._warningView = nil
	arg0_93._mainDamagedView = nil

	if arg0_93._duelRateBar then
		arg0_93._duelRateBar:Dispose()

		arg0_93._duelRateBar = nil
	end

	if arg0_93._simulationBuffCountView then
		arg0_93._simulationBuffCountView:Dispose()

		arg0_93._simulationBuffCountView = nil
	end

	if arg0_93._jammingView then
		arg0_93._jammingView:Dispose()

		arg0_93._jammingView = nil
	end

	if arg0_93._inkView then
		arg0_93._inkView:Dispose()

		arg0_93._inkView = nil
	end

	if arg0_93._alchemistAP then
		arg0_93._alchemistAP:Dispose()

		arg0_93._alchemistAP = nil
	end

	if arg0_93._gridmanSkillFloat then
		arg0_93._gridmanSkillFloat:Dispose()
	end

	if go(arg0_93._ui:findTF("CardPuzzleConsole")).activeSelf then
		arg0_93:DisposeCardPuzzleComponent()
	end

	var7_0.super.Dispose(arg0_93)
end

function var7_0.OnCardPuzzleInit(arg0_94, arg1_94)
	arg0_94._cardPuzzleComponent = arg0_94._dataProxy:GetFleetByIFF(var5_0.FRIENDLY_CODE):GetCardPuzzleComponent()

	arg0_94:ShowCardPuzzleComponent()
	arg0_94:RegisterCardPuzzleEvent()
end

function var7_0.RegisterCardPuzzleEvent(arg0_95)
	arg0_95._cardPuzzleComponent:RegisterEventListener(arg0_95, var6_0.UPDATE_FLEET_SHIP, arg0_95.onUpdateFleetShip)
	arg0_95._cardPuzzleComponent:RegisterEventListener(arg0_95, var6_0.COMMON_BUTTON_ENABLE, arg0_95.onBlockCommonButton)
	arg0_95._cardPuzzleComponent:RegisterEventListener(arg0_95, var6_0.LONG_PRESS_BULLET_TIME, arg0_95.onLongPressBulletTime)
	arg0_95._cardPuzzleComponent:RegisterEventListener(arg0_95, var6_0.SHOW_CARD_DETAIL, arg0_95.onShowCardDetail)
end

function var7_0.ShowCardPuzzleComponent(arg0_96)
	setActive(arg0_96._ui:findTF("CardPuzzleConsole"), true)
	arg0_96:InitCardPuzzleCommonHPBar()
	arg0_96:InitCardPuzzleEnergyBar()
	arg0_96:IntCardPuzzleFleetHead()
	arg0_96:InitCameraCardBoardClicker()
	arg0_96:InitCardPuzzleMovePile()
	arg0_96:InitCardPuzzleDeckPile()
	arg0_96:InitCardPuzzleIconList()
	arg0_96:InitCardPuzzleHandBoard()
	arg0_96:InitCardPuzzleCardDetail()
	arg0_96:InitCardPuzzleGoalRemind()
end

function var7_0.InitCardPuzzleCommonHPBar(arg0_97)
	arg0_97._cardPuzzleHPBar = var0_0.Battle.CardPuzzleCommonHPBar.New(arg0_97._ui:findTF("CardPuzzleConsole/commonHP"))

	arg0_97._cardPuzzleHPBar:SetCardPuzzleComponent(arg0_97._cardPuzzleComponent)

	arg0_97._updateViewList[arg0_97._cardPuzzleHPBar] = true
end

function var7_0.InitCardPuzzleEnergyBar(arg0_98)
	arg0_98._cardPuzzleEnergyBar = var0_0.Battle.CardPuzzleEnergyBar.New(arg0_98._ui:findTF("CardPuzzleConsole/energy_block"))

	arg0_98._cardPuzzleEnergyBar:SetCardPuzzleComponent(arg0_98._cardPuzzleComponent)

	arg0_98._updateViewList[arg0_98._cardPuzzleEnergyBar] = true
end

function var7_0.InitCameraCardBoardClicker(arg0_99)
	arg0_99._cardPuzzleBoardClicker = var0_0.Battle.CardPuzzleBoardClicker.New(arg0_99._ui:findTF("CardBoardController"))

	arg0_99._cardPuzzleBoardClicker:SetCardPuzzleComponent(arg0_99._cardPuzzleComponent)
end

function var7_0.IntCardPuzzleFleetHead(arg0_100)
	arg0_100._cardPuzzleFleetHead = var0_0.Battle.CardPuzzleFleetHead.New(arg0_100._ui:findTF("CardPuzzleConsole/fleet"))

	arg0_100._cardPuzzleFleetHead:SetCardPuzzleComponent(arg0_100._cardPuzzleComponent)
end

function var7_0.InitCardPuzzleMovePile(arg0_101)
	arg0_101._cardPuzzleMovePile = var0_0.Battle.CardPuzzleMovePile.New(arg0_101._ui:findTF("CardPuzzleConsole/movedeck"))

	arg0_101._cardPuzzleMovePile:SetCardPuzzleComponent(arg0_101._cardPuzzleComponent)

	arg0_101._updateViewList[arg0_101._cardPuzzleMovePile] = true
end

function var7_0.InitCardPuzzleDeckPile(arg0_102)
	arg0_102._cardPuzzleDeckPile = var0_0.Battle.CardPuzzleDeckPool.New(arg0_102._ui:findTF("CardPuzzleConsole/deck"))

	arg0_102._cardPuzzleDeckPile:SetCardPuzzleComponent(arg0_102._cardPuzzleComponent)
end

function var7_0.InitCardPuzzleIconList(arg0_103)
	arg0_103._cardPuzzleStatusIcon = var0_0.Battle.CardPuzzleFleetIconList.New(arg0_103._ui:findTF("CardPuzzleConsole/statusIcon"))

	arg0_103._cardPuzzleStatusIcon:SetCardPuzzleComponent(arg0_103._cardPuzzleComponent)

	arg0_103._updateViewList[arg0_103._cardPuzzleStatusIcon] = true
end

function var7_0.InitCardPuzzleHandBoard(arg0_104)
	arg0_104._cardPuzzleHandBoard = var0_0.Battle.CardPuzzleHandBoard.New(arg0_104._ui:findTF("CardPuzzleConsole/cardboard"), arg0_104._ui:findTF("CardPuzzleConsole/hand"))

	arg0_104._cardPuzzleHandBoard:SetCardPuzzleComponent(arg0_104._cardPuzzleComponent)

	arg0_104._updateViewList[arg0_104._cardPuzzleHandBoard] = true
end

function var7_0.InitCardPuzzleGoalRemind(arg0_105)
	arg0_105._cardPuzzleGoalRemind = var0_0.Battle.CardPuzzleGoalRemind.New(arg0_105._ui:findTF("CardPuzzleConsole/goal"))

	arg0_105._cardPuzzleGoalRemind:SetCardPuzzleComponent(arg0_105._cardPuzzleComponent)
end

function var7_0.InitCardPuzzleCardDetail(arg0_106)
	arg0_106._cardPuzzleCardDetail = var0_0.Battle.CardPuzzleCardDetail.New(arg0_106._ui:findTF("CardPuzzleConsole/cardDetail"))
end

function var7_0.DisposeCardPuzzleComponent(arg0_107)
	arg0_107._cardPuzzleHPBar:Dispose()
	arg0_107._cardPuzzleEnergyBar:Dispose()
	arg0_107._cardPuzzleBoardClicker:Dispose()
	arg0_107._cardPuzzleFleetHead:Dispose()
	arg0_107._cardPuzzleMovePile:Dispose()
	arg0_107._cardPuzzleDeckPile:Dispose()
	arg0_107._cardPuzzleStatusIcon:Dispose()
	arg0_107._cardPuzzleHandBoard:Dispose()
	arg0_107._cardPuzzleGoalRemind:Dispose()
	arg0_107._cardPuzzleCardDetail:Dispose()
end

function var7_0.onUpdateFleetBuff(arg0_108)
	return
end

function var7_0.onUpdateFleetShip(arg0_109, arg1_109)
	arg0_109._cardPuzzleFleetHead:UpdateShipIcon(arg1_109.Data.teamType)
end

function var7_0.onBlockCommonButton(arg0_110, arg1_110)
	local var0_110 = arg1_110.Data.flag

	arg0_110:EnableComponent(var0_110)
end

function var7_0.onLongPressBulletTime(arg0_111, arg1_111)
	local var0_111 = arg1_111.Data.timeScale

	arg0_111._state:ScaleTimer(var0_111)
end

function var7_0.onShowCardDetail(arg0_112, arg1_112)
	local var0_112 = arg1_112.Data.card

	if var0_112 then
		arg0_112._cardPuzzleCardDetail:Active(true)
		arg0_112._cardPuzzleCardDetail:SetReferenceCard(var0_112)
	else
		arg0_112._cardPuzzleCardDetail:Active(false)
	end
end
