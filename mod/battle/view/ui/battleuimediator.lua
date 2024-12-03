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
end

function var7_0.InitTimer(arg0_16)
	if arg0_16._dataProxy:GetInitData().battleType == SYSTEM_DUEL then
		arg0_16._timerView = var0_0.Battle.BattleTimerView.New(arg0_16._ui:findTF("DuelTimer"))
	else
		arg0_16._timerView = var0_0.Battle.BattleTimerView.New(arg0_16._ui:findTF("Timer"))
	end
end

function var7_0.InitEnemyHpBar(arg0_17)
	arg0_17._enemyHpBar = var0_0.Battle.BattleEnmeyHpBarView.New(arg0_17._ui:findTF("EnemyHPBar"))
end

function var7_0.InitAirStrikeIcon(arg0_18)
	arg0_18._airStrikeView = var0_0.Battle.BattleAirStrikeIconView.New(arg0_18._ui:findTF("AirFighterContainer/AirStrikeIcon"))
	arg0_18._airSupportTF = arg0_18._ui:findTF("AirSupportLabel")
end

function var7_0.InitCommonWarning(arg0_19)
	arg0_19._warningView = var0_0.Battle.BattleCommonWarningView.New(arg0_19._ui:findTF("WarningView"))
	arg0_19._updateViewList[arg0_19._warningView] = true
end

function var7_0.InitScoreBar(arg0_20)
	arg0_20._scoreBarView = var0_0.Battle.BattleScoreBarView.New(arg0_20._ui:findTF("DodgemCountBar"))
end

function var7_0.InitAirFightScoreBar(arg0_21)
	arg0_21._scoreBarView = var0_0.Battle.BattleScoreBarView.New(arg0_21._ui:findTF("AirFightCountBar"))
end

function var7_0.InitAutoBtn(arg0_22)
	arg0_22._autoBtn = arg0_22._ui:findTF("AutoBtn")

	local var0_22 = var5_0.AUTO_DEFAULT_PREFERENCE
	local var1_22 = PlayerPrefs.GetFloat("auto_scale", var0_22.scale)
	local var2_22 = PlayerPrefs.GetFloat("auto_anchorX", var0_22.x)
	local var3_22 = PlayerPrefs.GetFloat("auto_anchorY", var0_22.y)

	arg0_22._autoBtn.localScale = Vector3(var1_22, var1_22, 1)
	arg0_22._autoBtn.anchorMin = Vector2(var2_22, var3_22)
	arg0_22._autoBtn.anchorMax = Vector2(var2_22, var3_22)
end

function var7_0.InitDuelRateBar(arg0_23)
	arg0_23._duelRateBar = var0_0.Battle.BattleDuelDamageRateView.New(arg0_23._ui:findTF("DuelDamageRate"))

	return arg0_23._duelRateBar
end

function var7_0.InitSimulationBuffCounting(arg0_24)
	arg0_24._simulationBuffCountView = var0_0.Battle.BattleSimulationBuffCountView.New(arg0_24._ui:findTF("SimulationWarning"))

	return arg0_24._simulationBuffCountView
end

function var7_0.InitMainDamagedView(arg0_25)
	arg0_25._mainDamagedView = var0_0.Battle.BattleMainDamagedView.New(arg0_25._ui:findTF("HPWarning"))
end

function var7_0.InitInkView(arg0_26, arg1_26)
	arg0_26._inkView = var0_0.Battle.BattleInkView.New(arg0_26._ui:findTF("InkContainer"))

	arg1_26:RegisterEventListener(arg0_26, var1_0.FLEET_HORIZON_UPDATE, arg0_26.onFleetHorizonUpdate)
end

function var7_0.InitDebugConsole(arg0_27)
	arg0_27._debugConsoleView = arg0_27._debugConsoleView or var0_0.Battle.BattleDebugConsole.New(arg0_27._ui:findTF("Debug_Console"), arg0_27._state)
end

function var7_0.InitCameraGestureSlider(arg0_28)
	arg0_28._gesture = var0_0.Battle.BattleCameraSlider.New(arg0_28._ui:findTF("CameraController"))

	var0_0.Battle.BattleCameraUtil.GetInstance():SetCameraSilder(arg0_28._gesture)
	arg0_28._cameraUtil:SwitchCameraPos("FOLLOW_GESTURE")
end

function var7_0.InitAlchemistAPView(arg0_29)
	arg0_29._alchemistAP = var0_0.Battle.BattleReisalinAPView.New(arg0_29._ui:findTF("APPanel"))
end

function var7_0.InitGuide(arg0_30)
	return
end

function var7_0.InitCamera(arg0_31)
	arg0_31._camera = pg.UIMgr.GetInstance():GetMainCamera():GetComponent(typeof(Camera))
	arg0_31._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0_31._cameraUtil = var0_0.Battle.BattleCameraUtil.GetInstance()

	arg0_31._cameraUtil:RegisterEventListener(arg0_31, var1_0.CAMERA_FOCUS, arg0_31.onCameraFocus)
	arg0_31._cameraUtil:RegisterEventListener(arg0_31, var1_0.SHOW_PAINTING, arg0_31.onShowPainting)
	arg0_31._cameraUtil:RegisterEventListener(arg0_31, var1_0.BULLET_TIME, arg0_31.onBulletTime)
end

function var7_0.Update(arg0_32)
	for iter0_32, iter1_32 in pairs(arg0_32._updateViewList) do
		iter0_32:Update()
	end
end

function var7_0.AddUIEvent(arg0_33)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.STAGE_DATA_INIT_FINISH, arg0_33.onStageInit)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.COMMON_DATA_INIT_FINISH, arg0_33.onCommonInit)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.ADD_FLEET, arg0_33.onAddFleet)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.ADD_UNIT, arg0_33.onAddUnit)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.REMOVE_UNIT, arg0_33.onRemoveUnit)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.HIT_ENEMY, arg0_33.onEnemyHit)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.ADD_AIR_FIGHTER_ICON, arg0_33.onAddAirStrike)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.REMOVE_AIR_FIGHTER_ICON, arg0_33.onRemoveAirStrike)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.UPDATE_AIR_SUPPORT_LABEL, arg0_33.onUpdateAirSupportLabel)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.UPDATE_HOSTILE_SUBMARINE, arg0_33.onUpdateHostileSubmarine)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.UPDATE_ENVIRONMENT_WARNING, arg0_33.onUpdateEnvironmentWarning)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.UPDATE_COUNT_DOWN, arg0_33.onUpdateCountDown)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.HIDE_INTERACTABLE_BUTTONS, arg0_33.OnHideButtons)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.ADD_UI_FX, arg0_33.OnAddUIFX)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.EDIT_CUSTOM_WARNING_LABEL, arg0_33.onEditCustomWarning)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var1_0.GRIDMAN_SKILL_FLOAT, arg0_33.onGridmanSkillFloat)
	arg0_33._dataProxy:RegisterEventListener(arg0_33, var6_0.CARD_PUZZLE_INIT, arg0_33.OnCardPuzzleInit)
end

function var7_0.RemoveUIEvent(arg0_34)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.COMMON_DATA_INIT_FINISH)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.STAGE_DATA_INIT_FINISH)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.ADD_FLEET)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.ADD_UNIT)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.REMOVE_UNIT)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.HIT_ENEMY)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.UPDATE_COUNT_DOWN)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.ADD_AIR_FIGHTER_ICON)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.REMOVE_AIR_FIGHTER_ICON)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.UPDATE_AIR_SUPPORT_LABEL)
	arg0_34._cameraUtil:UnregisterEventListener(arg0_34, var1_0.SHOW_PAINTING)
	arg0_34._cameraUtil:UnregisterEventListener(arg0_34, var1_0.CAMERA_FOCUS)
	arg0_34._cameraUtil:UnregisterEventListener(arg0_34, var1_0.BULLET_TIME)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.ADD_SUBMARINE_WARINING)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.REMOVE_SUBMARINE_WARINING)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.UPDATE_DODGEM_SCORE)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.UPDATE_DODGEM_COMBO)
	arg0_34._userFleet:UnregisterEventListener(arg0_34, var1_0.SHOW_BUFFER)
	arg0_34._userFleet:UnregisterEventListener(arg0_34, var2_0.POINT_HIT_CHARGE)
	arg0_34._userFleet:UnregisterEventListener(arg0_34, var2_0.POINT_HIT_CANCEL)
	arg0_34._userFleet:UnregisterEventListener(arg0_34, var1_0.MANUAL_SUBMARINE_SHIFT)
	arg0_34._userFleet:UnregisterEventListener(arg0_34, var1_0.FLEET_BLIND)
	arg0_34._userFleet:UnregisterEventListener(arg0_34, var1_0.FLEET_HORIZON_UPDATE)
	arg0_34._userFleet:UnregisterEventListener(arg0_34, var1_0.UPDATE_FLEET_ATTR)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.UPDATE_HOSTILE_SUBMARINE)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.UPDATE_ENVIRONMENT_WARNING)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.HIDE_INTERACTABLE_BUTTONS)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.ADD_UI_FX)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.EDIT_CUSTOM_WARNING_LABEL)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var1_0.GRIDMAN_SKILL_FLOAT)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var6_0.CARD_PUZZLE_INIT)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var6_0.UPDATE_FLEET_SHIP)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var6_0.COMMON_BUTTON_ENABLE)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var6_0.LONG_PRESS_BULLET_TIME)
	arg0_34._dataProxy:UnregisterEventListener(arg0_34, var6_0.SHOW_CARD_DETAIL)
end

function var7_0.ShowSkillPainting(arg0_35, arg1_35, arg2_35, arg3_35)
	arg3_35 = arg3_35 or 1

	local var0_35

	if arg2_35 then
		var0_35 = arg2_35.cutin_cover
	end

	arg0_35._ui:CutInPainting(arg1_35:GetTemplate(), arg3_35, arg1_35:GetIFF(), var0_35)
end

function var7_0.ShowSkillFloat(arg0_36, arg1_36, arg2_36, arg3_36)
	arg0_36._ui:SkillHrzPop(arg2_36, arg1_36, arg3_36)
end

function var7_0.ShowSkillFloatCover(arg0_37, arg1_37, arg2_37, arg3_37)
	arg0_37._ui:SkillHrzPopCover(arg2_37, arg1_37, arg3_37)
end

function var7_0.SeaSurfaceShift(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	local var0_38 = arg3_38 or var0_0.Battle.BattleConfig.calcInterval

	arg0_38._seaView:ShiftSurface(arg1_38, arg2_38, var0_38, arg4_38)
end

function var7_0.ShowAutoBtn(arg0_39)
	SetActive(arg0_39._autoBtn.transform, true)

	local var0_39 = arg0_39:GetState():GetBattleType()

	triggerToggle(arg0_39._autoBtn, var0_0.Battle.BattleState.IsAutoBotActive(var0_39))
end

function var7_0.ShowTimer(arg0_40)
	arg0_40._timerView:SetActive(true)
end

function var7_0.ShowDuelBar(arg0_41)
	arg0_41._duelRateBar:SetActive(true)
end

function var7_0.ShowSimulationView(arg0_42)
	arg0_42._simulationBuffCountView:SetActive(true)
end

function var7_0.ShowPauseButton(arg0_43, arg1_43)
	setActive(arg0_43._ui:findTF("PauseBtn"), arg1_43)
end

function var7_0.ShowDodgemScoreBar(arg0_44)
	arg0_44:InitScoreBar()
	arg0_44._dataProxy:RegisterEventListener(arg0_44, var1_0.UPDATE_DODGEM_SCORE, arg0_44.onUpdateDodgemScore)
	arg0_44._dataProxy:RegisterEventListener(arg0_44, var1_0.UPDATE_DODGEM_COMBO, arg0_44.onUpdateDodgemCombo)
	arg0_44._scoreBarView:UpdateScore(0)
	arg0_44._scoreBarView:SetActive(true)
end

function var7_0.ShowAirFightScoreBar(arg0_45)
	arg0_45:InitAirFightScoreBar()
	arg0_45._dataProxy:RegisterEventListener(arg0_45, var1_0.UPDATE_DODGEM_SCORE, arg0_45.onUpdateDodgemScore)
	arg0_45._dataProxy:RegisterEventListener(arg0_45, var1_0.UPDATE_DODGEM_COMBO, arg0_45.onUpdateDodgemCombo)
	arg0_45._scoreBarView:UpdateScore(0)
	arg0_45._scoreBarView:SetActive(true)
end

function var7_0.ScaleUISpeed(arg0_46, arg1_46)
	local var0_46 = arg0_46._ui:findTF("AutoBtn/on"):GetComponent(typeof(Animation))

	if var0_46 then
		var0_46:get_Item("autobtn_toOn").speed = arg1_46
	end

	local var1_46 = arg0_46._ui:findTF("AutoBtn/off"):GetComponent(typeof(Animation))

	if var1_46 then
		var1_46:get_Item("autobtn_toOff").speed = arg1_46
	end
end

function var7_0.onStageInit(arg0_47, arg1_47)
	arg0_47:InitJoystick()
	arg0_47:InitScene()
	arg0_47:InitTimer()
	arg0_47:InitEnemyHpBar()
	arg0_47:InitAirStrikeIcon()
	arg0_47:InitCommonWarning()
	arg0_47:InitAutoBtn()
	arg0_47:InitMainDamagedView()
end

function var7_0.onEnemyHit(arg0_48, arg1_48)
	local var0_48 = arg1_48.Data

	if var0_48:GetDiveInvisible() and not var0_48:GetDiveDetected() then
		return
	end

	local var1_48 = arg0_48._enemyHpBar:GetCurrentTarget()

	if var1_48 then
		if var1_48 ~= var0_48 then
			arg0_48._enemyHpBar:SwitchTarget(var0_48, arg0_48._dataProxy:GetUnitList())
		end
	else
		arg0_48._enemyHpBar:SwitchTarget(var0_48, arg0_48._dataProxy:GetUnitList())
	end
end

function var7_0.onEnemyHpUpdate(arg0_49, arg1_49)
	local var0_49 = arg1_49.Dispatcher

	if var0_49 == arg0_49._enemyHpBar:GetCurrentTarget() and (not var0_49:GetDiveInvisible() or var0_49:GetDiveDetected()) then
		arg0_49._enemyHpBar:UpdateHpBar()
	end
end

function var7_0.onPlayerMainUnitHpUpdate(arg0_50, arg1_50)
	if arg1_50.Data.dHP < 0 then
		arg0_50._mainDamagedView:Play()
	end
end

function var7_0.onSkillFloat(arg0_51, arg1_51)
	local var0_51 = arg1_51.Data
	local var1_51 = var0_51.coverHrzIcon
	local var2_51 = var0_51.commander
	local var3_51 = var0_51.skillName
	local var4_51 = arg1_51.Dispatcher

	if var1_51 then
		arg0_51:ShowSkillFloatCover(var4_51, var3_51, var1_51)
	else
		arg0_51:ShowSkillFloat(var4_51, var3_51, var2_51)
	end
end

function var7_0.onCommonInit(arg0_52, arg1_52)
	arg0_52._skillView = var0_0.Battle.BattleSkillView.New(arg0_52, arg1_52.Data)
	arg0_52._updateViewList[arg0_52._skillView] = true
	arg0_52._userFleet = arg0_52._dataProxy:GetFleetByIFF(var5_0.FRIENDLY_CODE)

	arg0_52._userFleet:RegisterEventListener(arg0_52, var1_0.SHOW_BUFFER, arg0_52.onShowBuffer)
	arg0_52._userFleet:RegisterEventListener(arg0_52, var2_0.POINT_HIT_CHARGE, arg0_52.onPointHitSight)
	arg0_52._userFleet:RegisterEventListener(arg0_52, var2_0.POINT_HIT_CANCEL, arg0_52.onPointHitSight)
	arg0_52._userFleet:RegisterEventListener(arg0_52, var1_0.MANUAL_SUBMARINE_SHIFT, arg0_52.onManualSubShift)
	arg0_52._userFleet:RegisterEventListener(arg0_52, var1_0.FLEET_BLIND, arg0_52.onFleetBlind)
	arg0_52._userFleet:RegisterEventListener(arg0_52, var1_0.UPDATE_FLEET_ATTR, arg0_52.onFleetAttrUpdate)

	arg0_52._sightView = var0_0.Battle.BattleOpticalSightView.New(arg0_52._ui:findTF("ChargeAreaContainer"))

	arg0_52._sightView:SetFleetVO(arg0_52._userFleet)

	local var0_52, var1_52, var2_52, var3_52 = arg0_52._dataProxy:GetTotalBounds()

	arg0_52._sightView:SetAreaBound(var2_52, var3_52)

	local var4_52
	local var5_52

	if arg0_52._dataProxy:GetInitData().ChapterBuffIDs then
		for iter0_52, iter1_52 in ipairs(arg0_52._dataProxy:GetInitData().ChapterBuffIDs) do
			if iter1_52 == 9727 then
				var4_52 = true

				break
			end
		end
	end

	if #arg0_52._dataProxy:GetFleetByIFF(var5_0.FRIENDLY_CODE):GetSupportUnitList() > 0 then
		var5_52 = true
	end

	if var5_52 and not var4_52 then
		arg0_52._airAdavantageTF = arg0_52._airSupportTF:Find("player_advantage")
	elseif var4_52 and not var5_52 then
		arg0_52._airAdavantageTF = arg0_52._airSupportTF:Find("enemy_advantage")
	elseif var4_52 and var5_52 then
		arg0_52._airAdavantageTF = arg0_52._airSupportTF:Find("draw")
	end
end

function var7_0.onAddFleet(arg0_53, arg1_53)
	local var0_53 = arg1_53.Data.fleetVO

	if PlayerPrefs.GetInt(BATTLE_EXPOSE_LINE, 1) == 1 then
		arg0_53:SetFleetCloakLine(var0_53)
	end
end

function var7_0.SetFleetCloakLine(arg0_54, arg1_54)
	if #arg1_54:GetCloakList() > 0 then
		local var0_54 = arg1_54:GetIFF()
		local var1_54 = arg1_54:GetFleetVisionLine()
		local var2_54 = arg1_54:GetFleetExposeLine()

		arg0_54._seaView:SetExposeLine(var0_54, var1_54, var2_54)
	end
end

function var7_0.onAddUnit(arg0_55, arg1_55)
	local var0_55 = arg1_55.Data.type
	local var1_55 = arg1_55.Data.unit

	if var0_55 == var3_0.UnitType.PLAYER_UNIT or var0_55 == var3_0.UnitType.ENEMY_UNIT or var0_55 == var3_0.UnitType.BOSS_UNIT then
		arg0_55:registerUnitEvent(var1_55)
	end

	if var1_55:IsBoss() and arg0_55._dataProxy:GetActiveBossCount() == 1 then
		arg0_55:AddBossWarningUI()
	elseif var0_55 == var3_0.UnitType.ENEMY_UNIT then
		arg0_55:registerNPCUnitEvent(var1_55)
	elseif var0_55 == var3_0.UnitType.PLAYER_UNIT and var1_55:IsMainFleetUnit() and var1_55:GetIFF() == var5_0.FRIENDLY_CODE then
		arg0_55:registerPlayerMainUnitEvent(var1_55)
	end

	local var2_55 = var1_55:GetTemplate().nationality

	if table.contains(var5_0.ALCHEMIST_AP_UI, var2_55) and var1_55:GetIFF() == var5_0.FRIENDLY_CODE then
		arg0_55:InitAlchemistAPView()
	end
end

function var7_0.onSubmarineDetected(arg0_56, arg1_56)
	local var0_56 = arg1_56.Dispatcher

	if arg0_56._enemyHpBar:GetCurrentTarget() and arg0_56._enemyHpBar:GetCurrentTarget() == var0_56 and var0_56:GetDiveDetected() == false then
		arg0_56._enemyHpBar:RemoveUnit()
	end
end

function var7_0.onRemoveUnit(arg0_57, arg1_57)
	local var0_57 = arg1_57.Data.unit
	local var1_57 = arg1_57.Data.type

	if var1_57 == var3_0.UnitType.PLAYER_UNIT or var1_57 == var3_0.UnitType.ENEMY_UNIT or var1_57 == var3_0.UnitType.BOSS_UNIT then
		arg0_57:unregisterUnitEvent(var0_57)
	end

	if var1_57 == var3_0.UnitType.ENEMY_UNIT and not var0_57:IsBoss() then
		arg0_57:unregisterNPCUnitEvent(var0_57)
	elseif var0_57:GetIFF() == var5_0.FRIENDLY_CODE and var0_57:IsMainFleetUnit() then
		arg0_57:unregisterPlayerMainUnitEvent(var0_57)
	end

	if arg1_57.Data.deadReason == var3_0.UnitDeathReason.LEAVE and arg0_57._enemyHpBar:GetCurrentTarget() and arg0_57._enemyHpBar:GetCurrentTarget() == arg1_57.Data.unit then
		arg0_57._enemyHpBar:RemoveUnit(arg1_57.Data.deadReason)
	end
end

function var7_0.onUpdateCountDown(arg0_58, arg1_58)
	arg0_58._timerView:SetCountDownText(arg0_58._dataProxy:GetCountDown())
end

function var7_0.onUpdateDodgemScore(arg0_59, arg1_59)
	local var0_59 = arg1_59.Data.totalScore

	arg0_59._scoreBarView:UpdateScore(var0_59)
end

function var7_0.onUpdateDodgemCombo(arg0_60, arg1_60)
	local var0_60 = arg1_60.Data.combo

	arg0_60._scoreBarView:UpdateCombo(var0_60)
end

function var7_0.onAddAirStrike(arg0_61, arg1_61)
	local var0_61 = arg1_61.Data.index
	local var1_61 = arg0_61._dataProxy:GetAirFighterInfo(var0_61)

	arg0_61._airStrikeView:AppendIcon(var0_61, var1_61)
end

function var7_0.onRemoveAirStrike(arg0_62, arg1_62)
	local var0_62 = arg1_62.Data.index
	local var1_62 = arg0_62._dataProxy:GetAirFighterInfo(var0_62)

	arg0_62._airStrikeView:RemoveIcon(var0_62, var1_62)
end

function var7_0.onUpdateAirSupportLabel(arg0_63, arg1_63)
	local var0_63 = arg0_63._dataProxy:GetAirFighterList()
	local var1_63 = 0

	for iter0_63, iter1_63 in ipairs(var0_63) do
		var1_63 = var1_63 + iter1_63.totalNumber
	end

	if var1_63 == 0 or arg0_63._warningView:GetCount() > 0 then
		eachChild(arg0_63._airSupportTF, function(arg0_64)
			setActive(arg0_64, false)
		end)
	elseif arg0_63._airAdavantageTF then
		setActive(arg0_63._airAdavantageTF, true)
	end
end

function var7_0.onUpdateHostileSubmarine(arg0_65, arg1_65)
	local var0_65 = arg0_65._dataProxy:GetEnemySubmarineCount()

	arg0_65._warningView:UpdateHostileSubmarineCount(var0_65)
	arg0_65:onUpdateAirSupportLabel()
end

function var7_0.onUpdateEnvironmentWarning(arg0_66, arg1_66)
	if arg1_66.Data.isActive then
		arg0_66._warningView:ActiveWarning(arg0_66._warningView.WARNING_TYPE_ARTILLERY)
	else
		arg0_66._warningView:DeactiveWarning(arg0_66._warningView.WARNING_TYPE_ARTILLERY)
	end
end

function var7_0.onCameraFocus(arg0_67, arg1_67)
	local var0_67 = arg1_67.Data

	if var0_67.unit ~= nil then
		local var1_67 = var0_67.skill or false

		arg0_67:EnableComponent(false)
		arg0_67:EnableSkillFloat(var1_67)
	else
		local var2_67 = var0_67.duration + var0_67.extraBulletTime

		LeanTween.delayedCall(arg0_67._ui._go, var2_67, System.Action(function()
			arg0_67:EnableComponent(true)
			arg0_67:EnableSkillFloat(true)
		end))
	end
end

function var7_0.onShowPainting(arg0_69, arg1_69)
	local var0_69 = arg1_69.Data

	arg0_69:ShowSkillPainting(var0_69.caster, var0_69.skill, var0_69.speed)
end

function var7_0.onBulletTime(arg0_70, arg1_70)
	local var0_70 = arg1_70.Data
	local var1_70 = var0_70.key
	local var2_70 = var0_70.rate

	if var2_70 then
		var4_0.AppendMapFactor(var1_70, var2_70)
	else
		var4_0.RemoveMapFactor(var1_70)
	end

	arg0_70._seaView:UpdateSpeedScaler()
end

function var7_0.onShowBuffer(arg0_71, arg1_71)
	local var0_71 = arg1_71.Data.dist

	arg0_71._seaView:UpdateBufferAlpha(var0_71)
end

function var7_0.onManualSubShift(arg0_72, arg1_72)
	local var0_72 = arg1_72.Data.state

	arg0_72._skillView:ShiftSubmarineManualButton(var0_72)
end

function var7_0.onPointHitSight(arg0_73, arg1_73)
	local var0_73 = arg1_73.ID

	if var0_73 == var2_0.POINT_HIT_CHARGE then
		arg0_73._sightView:SetActive(true)

		arg0_73._updateViewList[arg0_73._sightView] = true
	elseif var0_73 == var2_0.POINT_HIT_CANCEL then
		arg0_73._sightView:SetActive(false)

		arg0_73._updateViewList[arg0_73._sightView] = nil
	end
end

function var7_0.onFleetBlind(arg0_74, arg1_74)
	local var0_74 = arg1_74.Data.isBlind
	local var1_74 = arg1_74.Dispatcher

	if not arg0_74._inkView then
		arg0_74:InitInkView(var1_74)
	end

	if var0_74 then
		local var2_74 = var1_74:GetUnitList()

		arg0_74._inkView:SetActive(true, var2_74)
		arg0_74._skillView:HideSkillButton(true)

		arg0_74._updateViewList[arg0_74._inkView] = true
	else
		arg0_74._inkView:SetActive(false)
		arg0_74._skillView:HideSkillButton(false)

		arg0_74._updateViewList[arg0_74._inkView] = nil
	end
end

function var7_0.onFleetHorizonUpdate(arg0_75, arg1_75)
	if not arg0_75._inkView then
		return
	end

	local var0_75 = arg1_75.Dispatcher:GetUnitList()

	arg0_75._inkView:UpdateHollow(var0_75)
end

function var7_0.onFleetAttrUpdate(arg0_76, arg1_76)
	if arg0_76._alchemistAP then
		local var0_76 = arg1_76.Dispatcher
		local var1_76 = arg1_76.Data.attr
		local var2_76 = arg1_76.Data.value

		if var1_76 == arg0_76._alchemistAP:GetAttrName() then
			arg0_76._alchemistAP:UpdateAP(var2_76)
		end
	end
end

function var7_0.OnAddUIFX(arg0_77, arg1_77)
	local var0_77 = arg1_77.Data.FXID
	local var1_77 = arg1_77.Data.position
	local var2_77 = arg1_77.Data.localScale
	local var3_77 = arg1_77.Data.orderDiff

	arg0_77:AddUIFX(var3_77, var0_77, var1_77, var2_77)
end

function var7_0.AddUIFX(arg0_78, arg1_78, arg2_78, arg3_78, arg4_78)
	local var0_78 = arg0_78._fxPool:GetFX(arg2_78)

	arg1_78 = arg1_78 or 1

	local var1_78

	var1_78 = arg1_78 > 0

	local var2_78 = arg0_78._ui:AddUIFX(var0_78, arg1_78)

	arg4_78 = arg4_78 or 1
	var0_78.transform.localScale = Vector3(arg4_78 / var2_78.x, arg4_78 / var2_78.y, arg4_78 / var2_78.z)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0_78, arg3_78, true)
end

function var7_0.AddBossWarningUI(arg0_79)
	arg0_79._dataProxy:BlockManualCast(true)

	local var0_79 = var0_0.Battle.BattleResourceManager.GetInstance()

	arg0_79._appearEffect = var0_79:InstBossWarningUI()

	local var1_79 = arg0_79._appearEffect:GetComponent(typeof(Animator))
	local var2_79 = {
		Pause = function()
			var1_79.speed = 0
		end,
		Resume = function()
			var1_79.speed = 1
		end
	}

	arg0_79._state:SetTakeoverProcess(var2_79)

	var1_79.speed = 1 / arg0_79._state:GetTimeScaleRate()

	setParent(arg0_79._appearEffect, arg0_79._ui.uiCanvas, false)
	arg0_79._appearEffect:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_82)
		arg0_79._userFleet:CoupleEncourage()
		arg0_79._dataProxy:BlockManualCast(false)
		arg0_79._state:ClearTakeoverProcess()
		var0_79:DestroyOb(arg0_79._appearEffect)

		arg0_79._appearEffect = nil
	end)
	SetActive(arg0_79._appearEffect, true)
end

function var7_0.OnHideButtons(arg0_83, arg1_83)
	local var0_83 = arg1_83.Data.isActive

	arg0_83._skillView:HideSkillButton(not var0_83)
	SetActive(arg0_83._autoBtn.transform, var0_83)
end

function var7_0.onEditCustomWarning(arg0_84, arg1_84)
	local var0_84 = arg1_84.Data.labelData

	arg0_84._warningView:EditCustomWarning(var0_84)
end

function var7_0.onGridmanSkillFloat(arg0_85, arg1_85)
	if not arg0_85._gridmanSkillFloat then
		local var0_85 = var0_0.Battle.BattleResourceManager.GetInstance():InstGridmanSkillUI()

		arg0_85._gridmanSkillFloat = var0_0.Battle.BattleGridmanSkillFloatView.New(var0_85)

		setParent(var0_85, arg0_85._ui.uiCanvas, false)
	end

	local var1_85 = arg1_85.Data
	local var2_85 = var1_85.type
	local var3_85 = var1_85.IFF

	if var2_85 == 5 then
		arg0_85._gridmanSkillFloat:DoFusionFloat(var3_85)
	else
		arg0_85._gridmanSkillFloat:DoSkillFloat(var2_85, var3_85)
	end
end

function var7_0.registerUnitEvent(arg0_86, arg1_86)
	arg1_86:RegisterEventListener(arg0_86, var2_0.SKILL_FLOAT, arg0_86.onSkillFloat)
	arg1_86:RegisterEventListener(arg0_86, var2_0.CUT_INT, arg0_86.onShowPainting)
end

function var7_0.registerNPCUnitEvent(arg0_87, arg1_87)
	arg1_87:RegisterEventListener(arg0_87, var2_0.UPDATE_HP, arg0_87.onEnemyHpUpdate)

	local var0_87 = arg1_87:GetTemplate().type

	if table.contains(TeamType.SubShipType, var0_87) then
		arg1_87:RegisterEventListener(arg0_87, var2_0.SUBMARINE_DETECTED, arg0_87.onSubmarineDetected)
	end
end

function var7_0.registerPlayerMainUnitEvent(arg0_88, arg1_88)
	arg1_88:RegisterEventListener(arg0_88, var2_0.UPDATE_HP, arg0_88.onPlayerMainUnitHpUpdate)
end

function var7_0.unregisterUnitEvent(arg0_89, arg1_89)
	arg1_89:UnregisterEventListener(arg0_89, var2_0.SKILL_FLOAT)
	arg1_89:UnregisterEventListener(arg0_89, var2_0.CUT_INT)
end

function var7_0.unregisterNPCUnitEvent(arg0_90, arg1_90)
	arg1_90:UnregisterEventListener(arg0_90, var2_0.SKILL_FLOAT)
	arg1_90:UnregisterEventListener(arg0_90, var2_0.CUT_INT)
	arg1_90:UnregisterEventListener(arg0_90, var2_0.UPDATE_HP)

	local var0_90 = arg1_90:GetTemplate().type

	if table.contains(TeamType.SubShipType, var0_90) then
		arg1_90:UnregisterEventListener(arg0_90, var2_0.SUBMARINE_DETECTED)
	end
end

function var7_0.unregisterPlayerMainUnitEvent(arg0_91, arg1_91)
	arg1_91:UnregisterEventListener(arg0_91, var2_0.UPDATE_HP)
end

function var7_0.Dispose(arg0_92)
	LeanTween.cancel(arg0_92._ui._go)
	arg0_92._uiMGR:ClearStick()

	arg0_92._uiMGR = nil

	if arg0_92._appearEffect then
		Destroy(arg0_92._appearEffect)
	end

	arg0_92:RemoveUIEvent()

	arg0_92._updateViewList = nil

	arg0_92._timerView:Dispose()
	arg0_92._enemyHpBar:Dispose()
	arg0_92._skillView:Dispose()
	arg0_92._seaView:Dispose()
	arg0_92._airStrikeView:Dispose()
	arg0_92._sightView:Dispose()
	arg0_92._mainDamagedView:Dispose()
	arg0_92._warningView:Dispose()

	arg0_92._seaView = nil
	arg0_92._enemyHpBar = nil
	arg0_92._skillView = nil
	arg0_92._timerView = nil
	arg0_92._joystick = nil
	arg0_92._airStrikeView = nil
	arg0_92._warningView = nil
	arg0_92._mainDamagedView = nil

	if arg0_92._duelRateBar then
		arg0_92._duelRateBar:Dispose()

		arg0_92._duelRateBar = nil
	end

	if arg0_92._simulationBuffCountView then
		arg0_92._simulationBuffCountView:Dispose()

		arg0_92._simulationBuffCountView = nil
	end

	if arg0_92._jammingView then
		arg0_92._jammingView:Dispose()

		arg0_92._jammingView = nil
	end

	if arg0_92._inkView then
		arg0_92._inkView:Dispose()

		arg0_92._inkView = nil
	end

	if arg0_92._alchemistAP then
		arg0_92._alchemistAP:Dispose()

		arg0_92._alchemistAP = nil
	end

	if arg0_92._gridmanSkillFloat then
		arg0_92._gridmanSkillFloat:Dispose()
	end

	if go(arg0_92._ui:findTF("CardPuzzleConsole")).activeSelf then
		arg0_92:DisposeCardPuzzleComponent()
	end

	var7_0.super.Dispose(arg0_92)
end

function var7_0.OnCardPuzzleInit(arg0_93, arg1_93)
	arg0_93._cardPuzzleComponent = arg0_93._dataProxy:GetFleetByIFF(var5_0.FRIENDLY_CODE):GetCardPuzzleComponent()

	arg0_93:ShowCardPuzzleComponent()
	arg0_93:RegisterCardPuzzleEvent()
end

function var7_0.RegisterCardPuzzleEvent(arg0_94)
	arg0_94._cardPuzzleComponent:RegisterEventListener(arg0_94, var6_0.UPDATE_FLEET_SHIP, arg0_94.onUpdateFleetShip)
	arg0_94._cardPuzzleComponent:RegisterEventListener(arg0_94, var6_0.COMMON_BUTTON_ENABLE, arg0_94.onBlockCommonButton)
	arg0_94._cardPuzzleComponent:RegisterEventListener(arg0_94, var6_0.LONG_PRESS_BULLET_TIME, arg0_94.onLongPressBulletTime)
	arg0_94._cardPuzzleComponent:RegisterEventListener(arg0_94, var6_0.SHOW_CARD_DETAIL, arg0_94.onShowCardDetail)
end

function var7_0.ShowCardPuzzleComponent(arg0_95)
	setActive(arg0_95._ui:findTF("CardPuzzleConsole"), true)
	arg0_95:InitCardPuzzleCommonHPBar()
	arg0_95:InitCardPuzzleEnergyBar()
	arg0_95:IntCardPuzzleFleetHead()
	arg0_95:InitCameraCardBoardClicker()
	arg0_95:InitCardPuzzleMovePile()
	arg0_95:InitCardPuzzleDeckPile()
	arg0_95:InitCardPuzzleIconList()
	arg0_95:InitCardPuzzleHandBoard()
	arg0_95:InitCardPuzzleCardDetail()
	arg0_95:InitCardPuzzleGoalRemind()
end

function var7_0.InitCardPuzzleCommonHPBar(arg0_96)
	arg0_96._cardPuzzleHPBar = var0_0.Battle.CardPuzzleCommonHPBar.New(arg0_96._ui:findTF("CardPuzzleConsole/commonHP"))

	arg0_96._cardPuzzleHPBar:SetCardPuzzleComponent(arg0_96._cardPuzzleComponent)

	arg0_96._updateViewList[arg0_96._cardPuzzleHPBar] = true
end

function var7_0.InitCardPuzzleEnergyBar(arg0_97)
	arg0_97._cardPuzzleEnergyBar = var0_0.Battle.CardPuzzleEnergyBar.New(arg0_97._ui:findTF("CardPuzzleConsole/energy_block"))

	arg0_97._cardPuzzleEnergyBar:SetCardPuzzleComponent(arg0_97._cardPuzzleComponent)

	arg0_97._updateViewList[arg0_97._cardPuzzleEnergyBar] = true
end

function var7_0.InitCameraCardBoardClicker(arg0_98)
	arg0_98._cardPuzzleBoardClicker = var0_0.Battle.CardPuzzleBoardClicker.New(arg0_98._ui:findTF("CardBoardController"))

	arg0_98._cardPuzzleBoardClicker:SetCardPuzzleComponent(arg0_98._cardPuzzleComponent)
end

function var7_0.IntCardPuzzleFleetHead(arg0_99)
	arg0_99._cardPuzzleFleetHead = var0_0.Battle.CardPuzzleFleetHead.New(arg0_99._ui:findTF("CardPuzzleConsole/fleet"))

	arg0_99._cardPuzzleFleetHead:SetCardPuzzleComponent(arg0_99._cardPuzzleComponent)
end

function var7_0.InitCardPuzzleMovePile(arg0_100)
	arg0_100._cardPuzzleMovePile = var0_0.Battle.CardPuzzleMovePile.New(arg0_100._ui:findTF("CardPuzzleConsole/movedeck"))

	arg0_100._cardPuzzleMovePile:SetCardPuzzleComponent(arg0_100._cardPuzzleComponent)

	arg0_100._updateViewList[arg0_100._cardPuzzleMovePile] = true
end

function var7_0.InitCardPuzzleDeckPile(arg0_101)
	arg0_101._cardPuzzleDeckPile = var0_0.Battle.CardPuzzleDeckPool.New(arg0_101._ui:findTF("CardPuzzleConsole/deck"))

	arg0_101._cardPuzzleDeckPile:SetCardPuzzleComponent(arg0_101._cardPuzzleComponent)
end

function var7_0.InitCardPuzzleIconList(arg0_102)
	arg0_102._cardPuzzleStatusIcon = var0_0.Battle.CardPuzzleFleetIconList.New(arg0_102._ui:findTF("CardPuzzleConsole/statusIcon"))

	arg0_102._cardPuzzleStatusIcon:SetCardPuzzleComponent(arg0_102._cardPuzzleComponent)

	arg0_102._updateViewList[arg0_102._cardPuzzleStatusIcon] = true
end

function var7_0.InitCardPuzzleHandBoard(arg0_103)
	arg0_103._cardPuzzleHandBoard = var0_0.Battle.CardPuzzleHandBoard.New(arg0_103._ui:findTF("CardPuzzleConsole/cardboard"), arg0_103._ui:findTF("CardPuzzleConsole/hand"))

	arg0_103._cardPuzzleHandBoard:SetCardPuzzleComponent(arg0_103._cardPuzzleComponent)

	arg0_103._updateViewList[arg0_103._cardPuzzleHandBoard] = true
end

function var7_0.InitCardPuzzleGoalRemind(arg0_104)
	arg0_104._cardPuzzleGoalRemind = var0_0.Battle.CardPuzzleGoalRemind.New(arg0_104._ui:findTF("CardPuzzleConsole/goal"))

	arg0_104._cardPuzzleGoalRemind:SetCardPuzzleComponent(arg0_104._cardPuzzleComponent)
end

function var7_0.InitCardPuzzleCardDetail(arg0_105)
	arg0_105._cardPuzzleCardDetail = var0_0.Battle.CardPuzzleCardDetail.New(arg0_105._ui:findTF("CardPuzzleConsole/cardDetail"))
end

function var7_0.DisposeCardPuzzleComponent(arg0_106)
	arg0_106._cardPuzzleHPBar:Dispose()
	arg0_106._cardPuzzleEnergyBar:Dispose()
	arg0_106._cardPuzzleBoardClicker:Dispose()
	arg0_106._cardPuzzleFleetHead:Dispose()
	arg0_106._cardPuzzleMovePile:Dispose()
	arg0_106._cardPuzzleDeckPile:Dispose()
	arg0_106._cardPuzzleStatusIcon:Dispose()
	arg0_106._cardPuzzleHandBoard:Dispose()
	arg0_106._cardPuzzleGoalRemind:Dispose()
	arg0_106._cardPuzzleCardDetail:Dispose()
end

function var7_0.onUpdateFleetBuff(arg0_107)
	return
end

function var7_0.onUpdateFleetShip(arg0_108, arg1_108)
	arg0_108._cardPuzzleFleetHead:UpdateShipIcon(arg1_108.Data.teamType)
end

function var7_0.onBlockCommonButton(arg0_109, arg1_109)
	local var0_109 = arg1_109.Data.flag

	arg0_109:EnableComponent(var0_109)
end

function var7_0.onLongPressBulletTime(arg0_110, arg1_110)
	local var0_110 = arg1_110.Data.timeScale

	arg0_110._state:ScaleTimer(var0_110)
end

function var7_0.onShowCardDetail(arg0_111, arg1_111)
	local var0_111 = arg1_111.Data.card

	if var0_111 then
		arg0_111._cardPuzzleCardDetail:Active(true)
		arg0_111._cardPuzzleCardDetail:SetReferenceCard(var0_111)
	else
		arg0_111._cardPuzzleCardDetail:Active(false)
	end
end
