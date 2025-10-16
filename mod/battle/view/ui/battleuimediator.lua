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
	arg0_5._ui._tf:Find("PauseBtn"):GetComponent(typeof(Button)).enabled = arg1_5

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
	arg0_10._ui._tf:Find("PauseBtn"):GetComponent(typeof(Button)).enabled = false

	arg0_10._skillView:DisableWeapnButton()
	SetActive(arg0_10._ui._tf:Find("HPBarContainer"), false)
	SetActive(arg0_10._ui._tf:Find("flagShipMark"), false)

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
	arg0_15._joystick = arg0_15._ui._tf:Find("Stick")

	local var0_15 = var5_0.JOY_STICK_DEFAULT_PREFERENCE
	local var1_15 = arg0_15._joystick
	local var2_15 = 1
	local var3_15 = PlayerPrefs.GetFloat("joystick_scale", var0_15.scale)
	local var4_15 = PlayerPrefs.GetFloat("joystick_anchorX", var0_15.x)
	local var5_15 = PlayerPrefs.GetFloat("joystick_anchorY", var0_15.y)
	local var6_15 = var2_15 * var3_15

	arg0_15._joystick.localScale = Vector3(var6_15, var6_15, 1)

	originalPrint("scale: ", arg0_15._joystick.localScale)

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
		arg0_17._timerView = var0_0.Battle.BattleTimerView.New(arg0_17._ui._tf:Find("DuelTimer"))
	else
		arg0_17._timerView = var0_0.Battle.BattleTimerView.New(arg0_17._ui._tf:Find("Timer"))
	end
end

function var7_0.InitEnemyHpBar(arg0_18)
	arg0_18._enemyHpBar = var0_0.Battle.BattleEnmeyHpBarView.New(arg0_18._ui._tf:Find("EnemyHPBar"))
end

function var7_0.InitAirStrikeIcon(arg0_19)
	arg0_19._airStrikeView = var0_0.Battle.BattleAirStrikeIconView.New(arg0_19._ui._tf:Find("AirFighterContainer/AirStrikeIcon"))
	arg0_19._airSupportTF = arg0_19._ui._tf:Find("AirSupportLabel")
end

function var7_0.InitCommonWarning(arg0_20)
	arg0_20._warningView = var0_0.Battle.BattleCommonWarningView.New(arg0_20._ui._tf:Find("WarningView"))
	arg0_20._updateViewList[arg0_20._warningView] = true
end

function var7_0.InitScoreBar(arg0_21)
	arg0_21._scoreBarView = var0_0.Battle.BattleScoreBarView.New(arg0_21._ui._tf:Find("DodgemCountBar"))
end

function var7_0.InitAirFightScoreBar(arg0_22)
	arg0_22._scoreBarView = var0_0.Battle.BattleScoreBarView.New(arg0_22._ui._tf:Find("AirFightCountBar"))
end

function var7_0.InitAutoBtn(arg0_23)
	arg0_23._autoBtn = arg0_23._ui._tf:Find("AutoBtn")

	local var0_23 = var5_0.AUTO_DEFAULT_PREFERENCE
	local var1_23 = PlayerPrefs.GetFloat("auto_scale", var0_23.scale)
	local var2_23 = PlayerPrefs.GetFloat("auto_anchorX", var0_23.x)
	local var3_23 = PlayerPrefs.GetFloat("auto_anchorY", var0_23.y)

	arg0_23._autoBtn.localScale = Vector3(var1_23, var1_23, 1)
	arg0_23._autoBtn.anchorMin = Vector2(var2_23, var3_23)
	arg0_23._autoBtn.anchorMax = Vector2(var2_23, var3_23)
end

function var7_0.InitDuelRateBar(arg0_24)
	arg0_24._duelRateBar = var0_0.Battle.BattleDuelDamageRateView.New(arg0_24._ui._tf:Find("DuelDamageRate"))

	return arg0_24._duelRateBar
end

function var7_0.InitSimulationBuffCounting(arg0_25)
	arg0_25._simulationBuffCountView = var0_0.Battle.BattleSimulationBuffCountView.New(arg0_25._ui._tf:Find("SimulationWarning"))

	return arg0_25._simulationBuffCountView
end

function var7_0.InitMainDamagedView(arg0_26)
	arg0_26._mainDamagedView = var0_0.Battle.BattleMainDamagedView.New(arg0_26._ui._tf:Find("HPWarning"))
end

function var7_0.InitInkView(arg0_27, arg1_27)
	arg0_27._inkView = var0_0.Battle.BattleInkView.New(arg0_27._ui._tf:Find("InkContainer"))

	arg1_27:RegisterEventListener(arg0_27, var1_0.FLEET_HORIZON_UPDATE, arg0_27.onFleetHorizonUpdate)
end

function var7_0.InitDebugConsole(arg0_28)
	arg0_28._debugConsoleView = arg0_28._debugConsoleView or var0_0.Battle.BattleDebugConsole.New(arg0_28._ui._tf:Find("Debug_Console"), arg0_28._state)
end

function var7_0.InitCameraGestureSlider(arg0_29)
	arg0_29._gesture = var0_0.Battle.BattleCameraSlider.New(arg0_29._ui._tf:Find("CameraController"))

	var0_0.Battle.BattleCameraUtil.GetInstance():SetCameraSilder(arg0_29._gesture)
	arg0_29._cameraUtil:SwitchCameraPos("FOLLOW_GESTURE")
end

function var7_0.InitAlchemistAPView(arg0_30)
	if not arg0_30._alchemistAP then
		local var0_30 = var0_0.Battle.BattleResourceManager.GetInstance():InstReisalinAPUI()

		setParent(var0_30, arg0_30._ui.uiCanvas, false)

		arg0_30._alchemistAP = var0_0.Battle.BattleReisalinAPView.New(var0_30.transform:Find("APPanel"))
	end
end

function var7_0.InitAlchemistManaView(arg0_31)
	if not arg0_31._alchemistMana then
		local var0_31 = var0_0.Battle.BattleResourceManager.GetInstance():InstYumiaManaUI()

		setParent(var0_31, arg0_31._ui.uiCanvas, false)

		arg0_31._alchemistMana = var0_0.Battle.BattleYumiaManaView.New(var0_31.transform:Find("ManaPanel"))
	end
end

function var7_0.InitGuide(arg0_32)
	return
end

function var7_0.InitCamera(arg0_33)
	arg0_33._camera = pg.UIMgr.GetInstance():GetMainCamera():GetComponent(typeof(Camera))
	arg0_33._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0_33._cameraUtil = var0_0.Battle.BattleCameraUtil.GetInstance()

	arg0_33._cameraUtil:RegisterEventListener(arg0_33, var1_0.CAMERA_FOCUS, arg0_33.onCameraFocus)
	arg0_33._cameraUtil:RegisterEventListener(arg0_33, var1_0.SHOW_PAINTING, arg0_33.onShowPainting)
	arg0_33._cameraUtil:RegisterEventListener(arg0_33, var1_0.BULLET_TIME, arg0_33.onBulletTime)
end

function var7_0.Update(arg0_34)
	for iter0_34, iter1_34 in pairs(arg0_34._updateViewList) do
		iter0_34:Update()
	end
end

function var7_0.AddUIEvent(arg0_35)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.STAGE_DATA_INIT_FINISH, arg0_35.onStageInit)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.COMMON_DATA_INIT_FINISH, arg0_35.onCommonInit)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.ADD_FLEET, arg0_35.onAddFleet)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.ADD_UNIT, arg0_35.onAddUnit)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.REMOVE_UNIT, arg0_35.onRemoveUnit)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.HIT_ENEMY, arg0_35.onEnemyHit)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.ADD_AIR_FIGHTER_ICON, arg0_35.onAddAirStrike)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.REMOVE_AIR_FIGHTER_ICON, arg0_35.onRemoveAirStrike)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.UPDATE_AIR_SUPPORT_LABEL, arg0_35.onUpdateAirSupportLabel)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.UPDATE_HOSTILE_SUBMARINE, arg0_35.onUpdateHostileSubmarine)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.UPDATE_ENVIRONMENT_WARNING, arg0_35.onUpdateEnvironmentWarning)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.UPDATE_COUNT_DOWN, arg0_35.onUpdateCountDown)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.HIDE_INTERACTABLE_BUTTONS, arg0_35.OnHideButtons)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.ADD_UI_FX, arg0_35.OnAddUIFX)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.EDIT_CUSTOM_WARNING_LABEL, arg0_35.onEditCustomWarning)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var1_0.GRIDMAN_SKILL_FLOAT, arg0_35.onGridmanSkillFloat)
	arg0_35._dataProxy:RegisterEventListener(arg0_35, var6_0.CARD_PUZZLE_INIT, arg0_35.OnCardPuzzleInit)
end

function var7_0.RemoveUIEvent(arg0_36)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.COMMON_DATA_INIT_FINISH)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.STAGE_DATA_INIT_FINISH)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.ADD_FLEET)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.ADD_UNIT)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.REMOVE_UNIT)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.HIT_ENEMY)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.UPDATE_COUNT_DOWN)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.ADD_AIR_FIGHTER_ICON)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.REMOVE_AIR_FIGHTER_ICON)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.UPDATE_AIR_SUPPORT_LABEL)
	arg0_36._cameraUtil:UnregisterEventListener(arg0_36, var1_0.SHOW_PAINTING)
	arg0_36._cameraUtil:UnregisterEventListener(arg0_36, var1_0.CAMERA_FOCUS)
	arg0_36._cameraUtil:UnregisterEventListener(arg0_36, var1_0.BULLET_TIME)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.ADD_SUBMARINE_WARINING)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.REMOVE_SUBMARINE_WARINING)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.UPDATE_DODGEM_SCORE)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.UPDATE_DODGEM_COMBO)
	arg0_36._userFleet:UnregisterEventListener(arg0_36, var1_0.SHOW_BUFFER)
	arg0_36._userFleet:UnregisterEventListener(arg0_36, var2_0.POINT_HIT_CHARGE)
	arg0_36._userFleet:UnregisterEventListener(arg0_36, var2_0.POINT_HIT_CANCEL)
	arg0_36._userFleet:UnregisterEventListener(arg0_36, var1_0.MANUAL_SUBMARINE_SHIFT)
	arg0_36._userFleet:UnregisterEventListener(arg0_36, var1_0.FLEET_BLIND)
	arg0_36._userFleet:UnregisterEventListener(arg0_36, var1_0.FLEET_HORIZON_UPDATE)
	arg0_36._userFleet:UnregisterEventListener(arg0_36, var1_0.UPDATE_FLEET_ATTR)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.UPDATE_HOSTILE_SUBMARINE)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.UPDATE_ENVIRONMENT_WARNING)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.HIDE_INTERACTABLE_BUTTONS)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.ADD_UI_FX)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.EDIT_CUSTOM_WARNING_LABEL)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var1_0.GRIDMAN_SKILL_FLOAT)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var6_0.CARD_PUZZLE_INIT)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var6_0.UPDATE_FLEET_SHIP)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var6_0.COMMON_BUTTON_ENABLE)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var6_0.LONG_PRESS_BULLET_TIME)
	arg0_36._dataProxy:UnregisterEventListener(arg0_36, var6_0.SHOW_CARD_DETAIL)
end

function var7_0.ShowSkillPainting(arg0_37, arg1_37, arg2_37, arg3_37)
	arg3_37 = arg3_37 or 1

	local var0_37

	if arg2_37 then
		var0_37 = arg2_37.cutin_cover
	end

	arg0_37._ui:CutInPainting(arg1_37:GetTemplate(), arg3_37, arg1_37:GetIFF(), var0_37)
end

function var7_0.ShowSkillFloat(arg0_38, arg1_38, arg2_38, arg3_38)
	arg0_38._ui:SkillHrzPop(arg2_38, arg1_38, arg3_38)
end

function var7_0.ShowSkillFloatCover(arg0_39, arg1_39, arg2_39, arg3_39)
	arg0_39._ui:SkillHrzPopCover(arg2_39, arg1_39, arg3_39)
end

function var7_0.SeaSurfaceShift(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40)
	local var0_40 = arg3_40 or var0_0.Battle.BattleConfig.calcInterval

	arg0_40._seaView:ShiftSurface(arg1_40, arg2_40, var0_40, arg4_40)
end

function var7_0.ShowAutoBtn(arg0_41)
	SetActive(arg0_41._autoBtn.transform, true)

	local var0_41 = arg0_41:GetState():GetBattleType()

	triggerToggle(arg0_41._autoBtn, var0_0.Battle.BattleState.IsAutoBotActive(var0_41))
end

function var7_0.ShowTimer(arg0_42)
	arg0_42._timerView:SetActive(true)
end

function var7_0.ShowDuelBar(arg0_43)
	arg0_43._duelRateBar:SetActive(true)
end

function var7_0.ShowSimulationView(arg0_44)
	arg0_44._simulationBuffCountView:SetActive(true)
end

function var7_0.ShowPauseButton(arg0_45, arg1_45)
	setActive(arg0_45._ui._tf:Find("PauseBtn"), arg1_45)
end

function var7_0.ShowDodgemScoreBar(arg0_46)
	arg0_46:InitScoreBar()
	arg0_46._dataProxy:RegisterEventListener(arg0_46, var1_0.UPDATE_DODGEM_SCORE, arg0_46.onUpdateDodgemScore)
	arg0_46._dataProxy:RegisterEventListener(arg0_46, var1_0.UPDATE_DODGEM_COMBO, arg0_46.onUpdateDodgemCombo)
	arg0_46._scoreBarView:UpdateScore(0)
	arg0_46._scoreBarView:SetActive(true)
end

function var7_0.ShowAirFightScoreBar(arg0_47)
	arg0_47:InitAirFightScoreBar()
	arg0_47._dataProxy:RegisterEventListener(arg0_47, var1_0.UPDATE_DODGEM_SCORE, arg0_47.onUpdateDodgemScore)
	arg0_47._dataProxy:RegisterEventListener(arg0_47, var1_0.UPDATE_DODGEM_COMBO, arg0_47.onUpdateDodgemCombo)
	arg0_47._scoreBarView:UpdateScore(0)
	arg0_47._scoreBarView:SetActive(true)
end

function var7_0.ScaleUISpeed(arg0_48, arg1_48)
	local var0_48 = arg0_48._ui._tf:Find("AutoBtn/on"):GetComponent(typeof(Animation))

	if var0_48 then
		var0_48:get_Item("autobtn_toOn").speed = arg1_48
	end

	local var1_48 = arg0_48._ui._tf:Find("AutoBtn/off"):GetComponent(typeof(Animation))

	if var1_48 then
		var1_48:get_Item("autobtn_toOff").speed = arg1_48
	end
end

function var7_0.onStageInit(arg0_49, arg1_49)
	arg0_49:InitJoystick()
	arg0_49:InitScene()
	arg0_49:InitTimer()
	arg0_49:InitEnemyHpBar()
	arg0_49:InitAirStrikeIcon()
	arg0_49:InitCommonWarning()
	arg0_49:InitAutoBtn()
	arg0_49:InitMainDamagedView()
end

function var7_0.onEnemyHit(arg0_50, arg1_50)
	local var0_50 = arg1_50.Data

	if var0_50:GetDiveInvisible() and not var0_50:GetDiveDetected() then
		return
	end

	local var1_50 = arg0_50._enemyHpBar:GetCurrentTarget()

	if var1_50 then
		if var1_50 ~= var0_50 then
			arg0_50._enemyHpBar:SwitchTarget(var0_50, arg0_50._dataProxy:GetUnitList())
		end
	else
		arg0_50._enemyHpBar:SwitchTarget(var0_50, arg0_50._dataProxy:GetUnitList())
	end
end

function var7_0.onEnemyHpUpdate(arg0_51, arg1_51)
	local var0_51 = arg1_51.Dispatcher

	if var0_51 == arg0_51._enemyHpBar:GetCurrentTarget() and (not var0_51:GetDiveInvisible() or var0_51:GetDiveDetected()) then
		arg0_51._enemyHpBar:UpdateHpBar()
	end
end

function var7_0.onPlayerMainUnitHpUpdate(arg0_52, arg1_52)
	if arg1_52.Data.dHP < 0 then
		arg0_52._mainDamagedView:Play()
	end
end

function var7_0.onSkillFloat(arg0_53, arg1_53)
	local var0_53 = arg1_53.Data
	local var1_53 = var0_53.coverHrzIcon
	local var2_53 = var0_53.commander
	local var3_53 = var0_53.skillName
	local var4_53 = arg1_53.Dispatcher

	if var1_53 then
		arg0_53:ShowSkillFloatCover(var4_53, var3_53, var1_53)
	else
		arg0_53:ShowSkillFloat(var4_53, var3_53, var2_53)
	end
end

function var7_0.onCommonInit(arg0_54, arg1_54)
	arg0_54._skillView = var0_0.Battle.BattleSkillView.New(arg0_54, arg1_54.Data)
	arg0_54._updateViewList[arg0_54._skillView] = true
	arg0_54._userFleet = arg0_54._dataProxy:GetFleetByIFF(var5_0.FRIENDLY_CODE)

	arg0_54._userFleet:RegisterEventListener(arg0_54, var1_0.SHOW_BUFFER, arg0_54.onShowBuffer)
	arg0_54._userFleet:RegisterEventListener(arg0_54, var2_0.POINT_HIT_CHARGE, arg0_54.onPointHitSight)
	arg0_54._userFleet:RegisterEventListener(arg0_54, var2_0.POINT_HIT_CANCEL, arg0_54.onPointHitSight)
	arg0_54._userFleet:RegisterEventListener(arg0_54, var1_0.MANUAL_SUBMARINE_SHIFT, arg0_54.onManualSubShift)
	arg0_54._userFleet:RegisterEventListener(arg0_54, var1_0.FLEET_BLIND, arg0_54.onFleetBlind)
	arg0_54._userFleet:RegisterEventListener(arg0_54, var1_0.UPDATE_FLEET_ATTR, arg0_54.onFleetAttrUpdate)

	arg0_54._sightView = var0_0.Battle.BattleOpticalSightView.New(arg0_54._ui._tf:Find("ChargeAreaContainer"))

	arg0_54._sightView:SetFleetVO(arg0_54._userFleet)

	local var0_54, var1_54, var2_54, var3_54 = arg0_54._dataProxy:GetTotalBounds()

	arg0_54._sightView:SetAreaBound(var2_54, var3_54)

	local var4_54
	local var5_54

	if arg0_54._dataProxy:GetInitData().ChapterBuffIDs then
		for iter0_54, iter1_54 in ipairs(arg0_54._dataProxy:GetInitData().ChapterBuffIDs) do
			if iter1_54 == 9727 then
				var4_54 = true

				break
			end
		end
	end

	if #arg0_54._dataProxy:GetFleetByIFF(var5_0.FRIENDLY_CODE):GetSupportUnitList() > 0 then
		var5_54 = true
	end

	if var5_54 and not var4_54 then
		arg0_54._airAdavantageTF = arg0_54._airSupportTF:Find("player_advantage")
	elseif var4_54 and not var5_54 then
		arg0_54._airAdavantageTF = arg0_54._airSupportTF:Find("enemy_advantage")
	elseif var4_54 and var5_54 then
		arg0_54._airAdavantageTF = arg0_54._airSupportTF:Find("draw")
	end
end

function var7_0.onAddFleet(arg0_55, arg1_55)
	local var0_55 = arg1_55.Data.fleetVO

	if PlayerPrefs.GetInt(BATTLE_EXPOSE_LINE, 1) == 1 then
		arg0_55:SetFleetCloakLine(var0_55)
	end
end

function var7_0.SetFleetCloakLine(arg0_56, arg1_56)
	if #arg1_56:GetCloakList() > 0 then
		local var0_56 = arg1_56:GetIFF()
		local var1_56 = arg1_56:GetFleetVisionLine()
		local var2_56 = arg1_56:GetFleetExposeLine()

		arg0_56._seaView:SetExposeLine(var0_56, var1_56, var2_56)
	end
end

function var7_0.onAddUnit(arg0_57, arg1_57)
	local var0_57 = arg1_57.Data.type
	local var1_57 = arg1_57.Data.unit

	if var0_57 == var3_0.UnitType.PLAYER_UNIT or var0_57 == var3_0.UnitType.ENEMY_UNIT or var0_57 == var3_0.UnitType.BOSS_UNIT then
		arg0_57:registerUnitEvent(var1_57)
	end

	if var1_57:IsBoss() and arg0_57._dataProxy:GetActiveBossCount() == 1 then
		arg0_57:AddBossWarningUI()
	elseif var0_57 == var3_0.UnitType.ENEMY_UNIT then
		arg0_57:registerNPCUnitEvent(var1_57)
	elseif var0_57 == var3_0.UnitType.PLAYER_UNIT and var1_57:IsMainFleetUnit() and var1_57:GetIFF() == var5_0.FRIENDLY_CODE then
		arg0_57:registerPlayerMainUnitEvent(var1_57)
	end

	local var2_57 = var1_57:GetTemplate().nationality

	if table.contains(var5_0.ALCHEMIST_AP_UI, var2_57) and var1_57:GetIFF() == var5_0.FRIENDLY_CODE then
		arg0_57:InitAlchemistAPView()
	end

	if table.contains(var5_0.YUMIA_MANA_UI, var2_57) and var1_57:GetIFF() == var5_0.FRIENDLY_CODE then
		arg0_57:InitAlchemistManaView()
	end
end

function var7_0.onSubmarineDetected(arg0_58, arg1_58)
	local var0_58 = arg1_58.Dispatcher

	if arg0_58._enemyHpBar:GetCurrentTarget() and arg0_58._enemyHpBar:GetCurrentTarget() == var0_58 and var0_58:GetDiveDetected() == false then
		arg0_58._enemyHpBar:RemoveUnit()
	end
end

function var7_0.onRemoveUnit(arg0_59, arg1_59)
	local var0_59 = arg1_59.Data.unit
	local var1_59 = arg1_59.Data.type

	if var1_59 == var3_0.UnitType.PLAYER_UNIT or var1_59 == var3_0.UnitType.ENEMY_UNIT or var1_59 == var3_0.UnitType.BOSS_UNIT then
		arg0_59:unregisterUnitEvent(var0_59)
	end

	if var1_59 == var3_0.UnitType.ENEMY_UNIT and not var0_59:IsBoss() then
		arg0_59:unregisterNPCUnitEvent(var0_59)
	elseif var0_59:GetIFF() == var5_0.FRIENDLY_CODE and var0_59:IsMainFleetUnit() then
		arg0_59:unregisterPlayerMainUnitEvent(var0_59)
	end

	if arg1_59.Data.deadReason == var3_0.UnitDeathReason.LEAVE and arg0_59._enemyHpBar:GetCurrentTarget() and arg0_59._enemyHpBar:GetCurrentTarget() == arg1_59.Data.unit then
		arg0_59._enemyHpBar:RemoveUnit(arg1_59.Data.deadReason)
	end
end

function var7_0.onUpdateCountDown(arg0_60, arg1_60)
	arg0_60._timerView:SetCountDownText(arg0_60._dataProxy:GetCountDown())
end

function var7_0.onUpdateDodgemScore(arg0_61, arg1_61)
	local var0_61 = arg1_61.Data.totalScore

	arg0_61._scoreBarView:UpdateScore(var0_61)
end

function var7_0.onUpdateDodgemCombo(arg0_62, arg1_62)
	local var0_62 = arg1_62.Data.combo

	arg0_62._scoreBarView:UpdateCombo(var0_62)
end

function var7_0.onAddAirStrike(arg0_63, arg1_63)
	local var0_63 = arg1_63.Data.index
	local var1_63 = arg0_63._dataProxy:GetAirFighterInfo(var0_63)

	arg0_63._airStrikeView:AppendIcon(var0_63, var1_63)
end

function var7_0.onRemoveAirStrike(arg0_64, arg1_64)
	local var0_64 = arg1_64.Data.index
	local var1_64 = arg0_64._dataProxy:GetAirFighterInfo(var0_64)

	arg0_64._airStrikeView:RemoveIcon(var0_64, var1_64)
end

function var7_0.onUpdateAirSupportLabel(arg0_65, arg1_65)
	local var0_65 = arg0_65._dataProxy:GetAirFighterList()
	local var1_65 = 0

	for iter0_65, iter1_65 in ipairs(var0_65) do
		var1_65 = var1_65 + iter1_65.totalNumber
	end

	if var1_65 == 0 or arg0_65._warningView:GetCount() > 0 then
		eachChild(arg0_65._airSupportTF, function(arg0_66)
			setActive(arg0_66, false)
		end)
	elseif arg0_65._airAdavantageTF then
		setActive(arg0_65._airAdavantageTF, true)
	end
end

function var7_0.onUpdateHostileSubmarine(arg0_67, arg1_67)
	local var0_67 = arg0_67._dataProxy:GetEnemySubmarineCount()

	arg0_67._warningView:UpdateHostileSubmarineCount(var0_67)
	arg0_67:onUpdateAirSupportLabel()
end

function var7_0.onUpdateEnvironmentWarning(arg0_68, arg1_68)
	if arg1_68.Data.isActive then
		arg0_68._warningView:ActiveWarning(arg0_68._warningView.WARNING_TYPE_ARTILLERY)
	else
		arg0_68._warningView:DeactiveWarning(arg0_68._warningView.WARNING_TYPE_ARTILLERY)
	end
end

function var7_0.onCameraFocus(arg0_69, arg1_69)
	local var0_69 = arg1_69.Data

	if var0_69.unit ~= nil then
		local var1_69 = var0_69.skill or false

		arg0_69:EnableComponent(false)
		arg0_69:EnableSkillFloat(var1_69)
	else
		local var2_69 = var0_69.duration + var0_69.extraBulletTime

		LeanTween.delayedCall(arg0_69._ui._go, var2_69, System.Action(function()
			arg0_69:EnableComponent(true)
			arg0_69:EnableSkillFloat(true)
		end))
	end
end

function var7_0.onShowPainting(arg0_71, arg1_71)
	local var0_71 = arg1_71.Data

	arg0_71:ShowSkillPainting(var0_71.caster, var0_71.skill, var0_71.speed)
end

function var7_0.onBulletTime(arg0_72, arg1_72)
	local var0_72 = arg1_72.Data
	local var1_72 = var0_72.key
	local var2_72 = var0_72.rate

	if var2_72 then
		var4_0.AppendMapFactor(var1_72, var2_72)
	else
		var4_0.RemoveMapFactor(var1_72)
	end

	arg0_72._seaView:UpdateSpeedScaler()
end

function var7_0.onShowBuffer(arg0_73, arg1_73)
	local var0_73 = arg1_73.Data.dist

	arg0_73._seaView:UpdateBufferAlpha(var0_73)
end

function var7_0.onManualSubShift(arg0_74, arg1_74)
	local var0_74 = arg1_74.Data.state

	arg0_74._skillView:ShiftSubmarineManualButton(var0_74)
end

function var7_0.onPointHitSight(arg0_75, arg1_75)
	local var0_75 = arg1_75.ID

	if var0_75 == var2_0.POINT_HIT_CHARGE then
		arg0_75._sightView:SetActive(true)

		arg0_75._updateViewList[arg0_75._sightView] = true
	elseif var0_75 == var2_0.POINT_HIT_CANCEL then
		arg0_75._sightView:SetActive(false)

		arg0_75._updateViewList[arg0_75._sightView] = nil
	end
end

function var7_0.onFleetBlind(arg0_76, arg1_76)
	local var0_76 = arg1_76.Data.isBlind
	local var1_76 = arg1_76.Dispatcher

	if not arg0_76._inkView then
		arg0_76:InitInkView(var1_76)
	end

	if var0_76 then
		local var2_76 = var1_76:GetUnitList()

		arg0_76._inkView:SetActive(true, var2_76)
		arg0_76._skillView:HideSkillButton(true)

		arg0_76._updateViewList[arg0_76._inkView] = true
	else
		arg0_76._inkView:SetActive(false)
		arg0_76._skillView:HideSkillButton(false)

		arg0_76._updateViewList[arg0_76._inkView] = nil
	end
end

function var7_0.onFleetHorizonUpdate(arg0_77, arg1_77)
	if not arg0_77._inkView then
		return
	end

	local var0_77 = arg1_77.Dispatcher:GetUnitList()

	arg0_77._inkView:UpdateHollow(var0_77)
end

function var7_0.onFleetAttrUpdate(arg0_78, arg1_78)
	if arg0_78._alchemistAP and arg1_78.Data.attr == arg0_78._alchemistAP:GetAttrName() then
		arg0_78._alchemistAP:UpdateAP(arg1_78.Data.value)
	end

	if arg0_78._alchemistMana and arg1_78.Data.attr == arg0_78._alchemistMana:GetAttrName() then
		arg0_78._alchemistMana:UpdateMana(arg1_78.Data.value)
	end
end

function var7_0.OnAddUIFX(arg0_79, arg1_79)
	local var0_79 = arg1_79.Data.FXID
	local var1_79 = arg1_79.Data.position
	local var2_79 = arg1_79.Data.localScale
	local var3_79 = arg1_79.Data.orderDiff

	arg0_79:AddUIFX(var3_79, var0_79, var1_79, var2_79)
end

function var7_0.AddUIFX(arg0_80, arg1_80, arg2_80, arg3_80, arg4_80)
	local var0_80 = arg0_80._fxPool:GetFX(arg2_80)

	arg1_80 = arg1_80 or 1

	local var1_80

	var1_80 = arg1_80 > 0

	local var2_80 = arg0_80._ui:AddUIFX(var0_80, arg1_80)

	arg4_80 = arg4_80 or 1
	var0_80.transform.localScale = Vector3(arg4_80 / var2_80.x, arg4_80 / var2_80.y, arg4_80 / var2_80.z)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0_80, arg3_80, true)
end

function var7_0.AddBossWarningUI(arg0_81)
	arg0_81._dataProxy:BlockManualCast(true)

	local var0_81 = var0_0.Battle.BattleResourceManager.GetInstance()

	arg0_81._appearEffect = var0_81:InstBossWarningUI()

	local var1_81 = arg0_81._appearEffect:GetComponent(typeof(Animator))
	local var2_81 = {
		Pause = function()
			var1_81.speed = 0
		end,
		Resume = function()
			var1_81.speed = 1
		end
	}

	arg0_81._state:SetTakeoverProcess(var2_81)

	var1_81.speed = 1 / arg0_81._state:GetTimeScaleRate()

	setParent(arg0_81._appearEffect, arg0_81._ui.uiCanvas, false)
	arg0_81._appearEffect:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_84)
		arg0_81._userFleet:CoupleEncourage()
		arg0_81._dataProxy:BlockManualCast(false)
		arg0_81._state:ClearTakeoverProcess()
		var0_81:DestroyOb(arg0_81._appearEffect)

		arg0_81._appearEffect = nil
	end)
	SetActive(arg0_81._appearEffect, true)
end

function var7_0.OnHideButtons(arg0_85, arg1_85)
	local var0_85 = arg1_85.Data.isActive

	arg0_85._skillView:HideSkillButton(not var0_85)
	SetActive(arg0_85._autoBtn.transform, var0_85)
end

function var7_0.onEditCustomWarning(arg0_86, arg1_86)
	local var0_86 = arg1_86.Data.labelData

	arg0_86._warningView:EditCustomWarning(var0_86)
end

function var7_0.onGridmanSkillFloat(arg0_87, arg1_87)
	if not arg0_87._gridmanSkillFloat then
		local var0_87 = var0_0.Battle.BattleResourceManager.GetInstance():InstGridmanSkillUI()

		arg0_87._gridmanSkillFloat = var0_0.Battle.BattleGridmanSkillFloatView.New(var0_87)

		setParent(var0_87, arg0_87._ui.uiCanvas, false)
	end

	local var1_87 = arg1_87.Data
	local var2_87 = var1_87.type
	local var3_87 = var1_87.IFF

	if var2_87 == 5 then
		arg0_87._gridmanSkillFloat:DoFusionFloat(var3_87)
	else
		arg0_87._gridmanSkillFloat:DoSkillFloat(var2_87, var3_87)
	end
end

function var7_0.registerUnitEvent(arg0_88, arg1_88)
	arg1_88:RegisterEventListener(arg0_88, var2_0.SKILL_FLOAT, arg0_88.onSkillFloat)
	arg1_88:RegisterEventListener(arg0_88, var2_0.CUT_INT, arg0_88.onShowPainting)
end

function var7_0.registerNPCUnitEvent(arg0_89, arg1_89)
	arg1_89:RegisterEventListener(arg0_89, var2_0.UPDATE_HP, arg0_89.onEnemyHpUpdate)

	local var0_89 = arg1_89:GetTemplate().type

	if table.contains(TeamType.SubShipType, var0_89) then
		arg1_89:RegisterEventListener(arg0_89, var2_0.SUBMARINE_DETECTED, arg0_89.onSubmarineDetected)
	end
end

function var7_0.registerPlayerMainUnitEvent(arg0_90, arg1_90)
	arg1_90:RegisterEventListener(arg0_90, var2_0.UPDATE_HP, arg0_90.onPlayerMainUnitHpUpdate)
end

function var7_0.unregisterUnitEvent(arg0_91, arg1_91)
	arg1_91:UnregisterEventListener(arg0_91, var2_0.SKILL_FLOAT)
	arg1_91:UnregisterEventListener(arg0_91, var2_0.CUT_INT)
end

function var7_0.unregisterNPCUnitEvent(arg0_92, arg1_92)
	arg1_92:UnregisterEventListener(arg0_92, var2_0.SKILL_FLOAT)
	arg1_92:UnregisterEventListener(arg0_92, var2_0.CUT_INT)
	arg1_92:UnregisterEventListener(arg0_92, var2_0.UPDATE_HP)

	local var0_92 = arg1_92:GetTemplate().type

	if table.contains(TeamType.SubShipType, var0_92) then
		arg1_92:UnregisterEventListener(arg0_92, var2_0.SUBMARINE_DETECTED)
	end
end

function var7_0.unregisterPlayerMainUnitEvent(arg0_93, arg1_93)
	arg1_93:UnregisterEventListener(arg0_93, var2_0.UPDATE_HP)
end

function var7_0.Dispose(arg0_94)
	LeanTween.cancel(arg0_94._ui._go)
	arg0_94._uiMGR:ClearStick()

	arg0_94._uiMGR = nil

	if arg0_94._appearEffect then
		Destroy(arg0_94._appearEffect)
	end

	arg0_94:RemoveUIEvent()

	arg0_94._updateViewList = nil

	arg0_94._timerView:Dispose()
	arg0_94._enemyHpBar:Dispose()
	arg0_94._skillView:Dispose()
	arg0_94._seaView:Dispose()
	arg0_94._airStrikeView:Dispose()
	arg0_94._sightView:Dispose()
	arg0_94._mainDamagedView:Dispose()
	arg0_94._warningView:Dispose()

	arg0_94._seaView = nil
	arg0_94._enemyHpBar = nil
	arg0_94._skillView = nil
	arg0_94._timerView = nil
	arg0_94._joystick = nil
	arg0_94._airStrikeView = nil
	arg0_94._warningView = nil
	arg0_94._mainDamagedView = nil

	if arg0_94._duelRateBar then
		arg0_94._duelRateBar:Dispose()

		arg0_94._duelRateBar = nil
	end

	if arg0_94._simulationBuffCountView then
		arg0_94._simulationBuffCountView:Dispose()

		arg0_94._simulationBuffCountView = nil
	end

	if arg0_94._jammingView then
		arg0_94._jammingView:Dispose()

		arg0_94._jammingView = nil
	end

	if arg0_94._inkView then
		arg0_94._inkView:Dispose()

		arg0_94._inkView = nil
	end

	if arg0_94._alchemistAP then
		arg0_94._alchemistAP:Dispose()

		arg0_94._alchemistAP = nil
	end

	if arg0_94._alchemistMana then
		arg0_94._alchemistMana:Dispose()

		arg0_94._alchemistMana = nil
	end

	if arg0_94._gridmanSkillFloat then
		arg0_94._gridmanSkillFloat:Dispose()
	end

	if go(arg0_94._ui._tf:Find("CardPuzzleConsole")).activeSelf then
		arg0_94:DisposeCardPuzzleComponent()
	end

	var7_0.super.Dispose(arg0_94)
end

function var7_0.OnCardPuzzleInit(arg0_95, arg1_95)
	arg0_95._cardPuzzleComponent = arg0_95._dataProxy:GetFleetByIFF(var5_0.FRIENDLY_CODE):GetCardPuzzleComponent()

	arg0_95:ShowCardPuzzleComponent()
	arg0_95:RegisterCardPuzzleEvent()
end

function var7_0.RegisterCardPuzzleEvent(arg0_96)
	arg0_96._cardPuzzleComponent:RegisterEventListener(arg0_96, var6_0.UPDATE_FLEET_SHIP, arg0_96.onUpdateFleetShip)
	arg0_96._cardPuzzleComponent:RegisterEventListener(arg0_96, var6_0.COMMON_BUTTON_ENABLE, arg0_96.onBlockCommonButton)
	arg0_96._cardPuzzleComponent:RegisterEventListener(arg0_96, var6_0.LONG_PRESS_BULLET_TIME, arg0_96.onLongPressBulletTime)
	arg0_96._cardPuzzleComponent:RegisterEventListener(arg0_96, var6_0.SHOW_CARD_DETAIL, arg0_96.onShowCardDetail)
end

function var7_0.ShowCardPuzzleComponent(arg0_97)
	setActive(arg0_97._ui._tf:Find("CardPuzzleConsole"), true)
	arg0_97:InitCardPuzzleCommonHPBar()
	arg0_97:InitCardPuzzleEnergyBar()
	arg0_97:IntCardPuzzleFleetHead()
	arg0_97:InitCameraCardBoardClicker()
	arg0_97:InitCardPuzzleMovePile()
	arg0_97:InitCardPuzzleDeckPile()
	arg0_97:InitCardPuzzleIconList()
	arg0_97:InitCardPuzzleHandBoard()
	arg0_97:InitCardPuzzleCardDetail()
	arg0_97:InitCardPuzzleGoalRemind()
end

function var7_0.InitCardPuzzleCommonHPBar(arg0_98)
	arg0_98._cardPuzzleHPBar = var0_0.Battle.CardPuzzleCommonHPBar.New(arg0_98._ui._tf:Find("CardPuzzleConsole/commonHP"))

	arg0_98._cardPuzzleHPBar:SetCardPuzzleComponent(arg0_98._cardPuzzleComponent)

	arg0_98._updateViewList[arg0_98._cardPuzzleHPBar] = true
end

function var7_0.InitCardPuzzleEnergyBar(arg0_99)
	arg0_99._cardPuzzleEnergyBar = var0_0.Battle.CardPuzzleEnergyBar.New(arg0_99._ui._tf:Find("CardPuzzleConsole/energy_block"))

	arg0_99._cardPuzzleEnergyBar:SetCardPuzzleComponent(arg0_99._cardPuzzleComponent)

	arg0_99._updateViewList[arg0_99._cardPuzzleEnergyBar] = true
end

function var7_0.InitCameraCardBoardClicker(arg0_100)
	arg0_100._cardPuzzleBoardClicker = var0_0.Battle.CardPuzzleBoardClicker.New(arg0_100._ui._tf:Find("CardBoardController"))

	arg0_100._cardPuzzleBoardClicker:SetCardPuzzleComponent(arg0_100._cardPuzzleComponent)
end

function var7_0.IntCardPuzzleFleetHead(arg0_101)
	arg0_101._cardPuzzleFleetHead = var0_0.Battle.CardPuzzleFleetHead.New(arg0_101._ui._tf:Find("CardPuzzleConsole/fleet"))

	arg0_101._cardPuzzleFleetHead:SetCardPuzzleComponent(arg0_101._cardPuzzleComponent)
end

function var7_0.InitCardPuzzleMovePile(arg0_102)
	arg0_102._cardPuzzleMovePile = var0_0.Battle.CardPuzzleMovePile.New(arg0_102._ui._tf:Find("CardPuzzleConsole/movedeck"))

	arg0_102._cardPuzzleMovePile:SetCardPuzzleComponent(arg0_102._cardPuzzleComponent)

	arg0_102._updateViewList[arg0_102._cardPuzzleMovePile] = true
end

function var7_0.InitCardPuzzleDeckPile(arg0_103)
	arg0_103._cardPuzzleDeckPile = var0_0.Battle.CardPuzzleDeckPool.New(arg0_103._ui._tf:Find("CardPuzzleConsole/deck"))

	arg0_103._cardPuzzleDeckPile:SetCardPuzzleComponent(arg0_103._cardPuzzleComponent)
end

function var7_0.InitCardPuzzleIconList(arg0_104)
	arg0_104._cardPuzzleStatusIcon = var0_0.Battle.CardPuzzleFleetIconList.New(arg0_104._ui._tf:Find("CardPuzzleConsole/statusIcon"))

	arg0_104._cardPuzzleStatusIcon:SetCardPuzzleComponent(arg0_104._cardPuzzleComponent)

	arg0_104._updateViewList[arg0_104._cardPuzzleStatusIcon] = true
end

function var7_0.InitCardPuzzleHandBoard(arg0_105)
	arg0_105._cardPuzzleHandBoard = var0_0.Battle.CardPuzzleHandBoard.New(arg0_105._ui._tf:Find("CardPuzzleConsole/cardboard"), arg0_105._ui._tf:Find("CardPuzzleConsole/hand"))

	arg0_105._cardPuzzleHandBoard:SetCardPuzzleComponent(arg0_105._cardPuzzleComponent)

	arg0_105._updateViewList[arg0_105._cardPuzzleHandBoard] = true
end

function var7_0.InitCardPuzzleGoalRemind(arg0_106)
	arg0_106._cardPuzzleGoalRemind = var0_0.Battle.CardPuzzleGoalRemind.New(arg0_106._ui._tf:Find("CardPuzzleConsole/goal"))

	arg0_106._cardPuzzleGoalRemind:SetCardPuzzleComponent(arg0_106._cardPuzzleComponent)
end

function var7_0.InitCardPuzzleCardDetail(arg0_107)
	arg0_107._cardPuzzleCardDetail = var0_0.Battle.CardPuzzleCardDetail.New(arg0_107._ui._tf:Find("CardPuzzleConsole/cardDetail"))
end

function var7_0.DisposeCardPuzzleComponent(arg0_108)
	arg0_108._cardPuzzleHPBar:Dispose()
	arg0_108._cardPuzzleEnergyBar:Dispose()
	arg0_108._cardPuzzleBoardClicker:Dispose()
	arg0_108._cardPuzzleFleetHead:Dispose()
	arg0_108._cardPuzzleMovePile:Dispose()
	arg0_108._cardPuzzleDeckPile:Dispose()
	arg0_108._cardPuzzleStatusIcon:Dispose()
	arg0_108._cardPuzzleHandBoard:Dispose()
	arg0_108._cardPuzzleGoalRemind:Dispose()
	arg0_108._cardPuzzleCardDetail:Dispose()
end

function var7_0.onUpdateFleetBuff(arg0_109)
	return
end

function var7_0.onUpdateFleetShip(arg0_110, arg1_110)
	arg0_110._cardPuzzleFleetHead:UpdateShipIcon(arg1_110.Data.teamType)
end

function var7_0.onBlockCommonButton(arg0_111, arg1_111)
	local var0_111 = arg1_111.Data.flag

	arg0_111:EnableComponent(var0_111)
end

function var7_0.onLongPressBulletTime(arg0_112, arg1_112)
	local var0_112 = arg1_112.Data.timeScale

	arg0_112._state:ScaleTimer(var0_112)
end

function var7_0.onShowCardDetail(arg0_113, arg1_113)
	local var0_113 = arg1_113.Data.card

	if var0_113 then
		arg0_113._cardPuzzleCardDetail:Active(true)
		arg0_113._cardPuzzleCardDetail:SetReferenceCard(var0_113)
	else
		arg0_113._cardPuzzleCardDetail:Active(false)
	end
end
