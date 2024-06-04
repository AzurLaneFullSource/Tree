ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleUnitEvent
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleVariable
local var5 = var0.Battle.BattleConfig
local var6 = var0.Battle.BattleCardPuzzleEvent
local var7 = class("BattleUIMediator", var0.MVC.Mediator)

var0.Battle.BattleUIMediator = var7
var7.__name = "BattleUIMediator"

function var7.Ctor(arg0)
	var7.super.Ctor(arg0)
end

function var7.SetBattleUI(arg0)
	arg0._ui = arg0._state:GetUI()
end

function var7.Initialize(arg0)
	var7.super.Initialize(arg0)

	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)
	arg0._uiMGR = pg.UIMgr.GetInstance()
	arg0._fxPool = var0.Battle.BattleFXPool.GetInstance()
	arg0._updateViewList = {}

	arg0:SetBattleUI()
	arg0:AddUIEvent()
	arg0:InitCamera()
	arg0:InitGuide()
end

function var7.Reinitialize(arg0)
	arg0._skillView:Dispose()
end

function var7.EnableComponent(arg0, arg1)
	arg0._ui:findTF("PauseBtn"):GetComponent(typeof(Button)).enabled = arg1

	arg0._skillView:EnableWeaponButton(arg1)
end

function var7.EnableJoystick(arg0, arg1)
	arg0._stickController.enabled = arg1

	setActive(arg0._joystick, arg1)
end

function var7.EnableWeaponButton(arg0, arg1)
	arg0._skillView:EnableWeaponButton(arg1)
end

function var7.EnableSkillFloat(arg0, arg1)
	arg0._ui:EnableSkillFloat(arg1)
end

function var7.GetAppearFX(arg0)
	return arg0._appearEffect
end

function var7.DisableComponent(arg0)
	arg0._ui:findTF("PauseBtn"):GetComponent(typeof(Button)).enabled = false

	arg0._skillView:DisableWeapnButton()
	SetActive(arg0._ui:findTF("HPBarContainer"), false)
	SetActive(arg0._ui:findTF("flagShipMark"), false)

	if arg0._jammingView then
		arg0._jammingView:Eliminate(false)
	end

	if arg0._inkView then
		arg0._inkView:SetActive(false)
	end
end

function var7.ActiveDebugConsole(arg0)
	arg0._debugConsoleView:SetActive(true)
end

function var7.OpeningEffect(arg0, arg1, arg2)
	arg0._uiMGR:SetActive(false)

	if arg2 == SYSTEM_SUBMARINE_RUN then
		arg0._skillView:SubmarineButton()

		local var0 = var5.JOY_STICK_DEFAULT_PREFERENCE

		arg0._joystick.anchorMin = Vector2(var0.x, var0.y)
		arg0._joystick.anchorMax = Vector2(var0.x, var0.y)
	elseif arg2 == SYSTEM_SUB_ROUTINE then
		arg0._skillView:SubRoutineButton()
	elseif arg2 == SYSTEM_AIRFIGHT then
		arg0._skillView:AirFightButton()
	elseif arg2 == SYSTEM_DEBUG then
		arg0._skillView:NormalButton()
	elseif arg2 == SYSTEM_CARDPUZZLE then
		arg0._skillView:CardPuzzleButton()
	else
		local var1 = pg.SeriesGuideMgr.GetInstance()

		if var1.currIndex and var1:isEnd() then
			arg0._skillView:NormalButton()
		else
			local var2 = arg0._dataProxy:GetDungeonData().skill_hide or {}

			arg0._skillView:CustomButton(var2)
		end
	end

	arg0._ui._go:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
		arg0._uiMGR:SetActive(true)
		arg0:EnableComponent(true)

		if arg1 then
			arg1()
		end
	end)
	SetActive(arg0._ui._go, true)
	arg0._skillView:ButtonInitialAnima()
end

function var7.InitScene(arg0)
	arg0._mapId = arg0._dataProxy._mapId
	arg0._seaView = var0.Battle.BattleMap.New(arg0._mapId)
end

function var7.InitJoystick(arg0)
	arg0._joystick = arg0._ui:findTF("Stick")

	local var0 = var5.JOY_STICK_DEFAULT_PREFERENCE
	local var1 = arg0._joystick
	local var2 = Screen.dpi / CameraMgr.instance.finalWidth * 5

	if var2 <= 0 then
		var2 = 1
	end

	local var3 = PlayerPrefs.GetFloat("joystick_scale", var0.scale)
	local var4 = PlayerPrefs.GetFloat("joystick_anchorX", var0.x)
	local var5 = PlayerPrefs.GetFloat("joystick_anchorY", var0.y)
	local var6 = var2 * var3

	arg0._joystick.localScale = Vector3(var6, var6, 1)
	var1.anchoredPosition = var1.anchoredPosition * var6
	arg0._joystick.anchorMin = Vector2(var4, var5)
	arg0._joystick.anchorMax = Vector2(var4, var5)
	arg0._stickController = arg0._joystick:GetComponent("StickController")

	arg0._uiMGR:AttachStickOb(arg0._joystick)
end

function var7.InitTimer(arg0)
	if arg0._dataProxy:GetInitData().battleType == SYSTEM_DUEL then
		arg0._timerView = var0.Battle.BattleTimerView.New(arg0._ui:findTF("DuelTimer"))
	else
		arg0._timerView = var0.Battle.BattleTimerView.New(arg0._ui:findTF("Timer"))
	end
end

function var7.InitEnemyHpBar(arg0)
	arg0._enemyHpBar = var0.Battle.BattleEnmeyHpBarView.New(arg0._ui:findTF("EnemyHPBar"))
end

function var7.InitAirStrikeIcon(arg0)
	arg0._airStrikeView = var0.Battle.BattleAirStrikeIconView.New(arg0._ui:findTF("AirFighterContainer/AirStrikeIcon"))
	arg0._airSupportTF = arg0._ui:findTF("AirSupportLabel")
end

function var7.InitCommonWarning(arg0)
	arg0._warningView = var0.Battle.BattleCommonWarningView.New(arg0._ui:findTF("WarningView"))
	arg0._updateViewList[arg0._warningView] = true
end

function var7.InitScoreBar(arg0)
	arg0._scoreBarView = var0.Battle.BattleScoreBarView.New(arg0._ui:findTF("DodgemCountBar"))
end

function var7.InitAirFightScoreBar(arg0)
	arg0._scoreBarView = var0.Battle.BattleScoreBarView.New(arg0._ui:findTF("AirFightCountBar"))
end

function var7.InitAutoBtn(arg0)
	arg0._autoBtn = arg0._ui:findTF("AutoBtn")

	local var0 = var5.AUTO_DEFAULT_PREFERENCE
	local var1 = PlayerPrefs.GetFloat("auto_scale", var0.scale)
	local var2 = PlayerPrefs.GetFloat("auto_anchorX", var0.x)
	local var3 = PlayerPrefs.GetFloat("auto_anchorY", var0.y)

	arg0._autoBtn.localScale = Vector3(var1, var1, 1)
	arg0._autoBtn.anchorMin = Vector2(var2, var3)
	arg0._autoBtn.anchorMax = Vector2(var2, var3)
end

function var7.InitDuelRateBar(arg0)
	arg0._duelRateBar = var0.Battle.BattleDuelDamageRateView.New(arg0._ui:findTF("DuelDamageRate"))

	return arg0._duelRateBar
end

function var7.InitSimulationBuffCounting(arg0)
	arg0._simulationBuffCountView = var0.Battle.BattleSimulationBuffCountView.New(arg0._ui:findTF("SimulationWarning"))

	return arg0._simulationBuffCountView
end

function var7.InitMainDamagedView(arg0)
	arg0._mainDamagedView = var0.Battle.BattleMainDamagedView.New(arg0._ui:findTF("HPWarning"))
end

function var7.InitInkView(arg0, arg1)
	arg0._inkView = var0.Battle.BattleInkView.New(arg0._ui:findTF("InkContainer"))

	arg1:RegisterEventListener(arg0, var1.FLEET_HORIZON_UPDATE, arg0.onFleetHorizonUpdate)
end

function var7.InitDebugConsole(arg0)
	arg0._debugConsoleView = arg0._debugConsoleView or var0.Battle.BattleDebugConsole.New(arg0._ui:findTF("Debug_Console"), arg0._state)
end

function var7.InitCameraGestureSlider(arg0)
	arg0._gesture = var0.Battle.BattleCameraSlider.New(arg0._ui:findTF("CameraController"))

	var0.Battle.BattleCameraUtil.GetInstance():SetCameraSilder(arg0._gesture)
	arg0._cameraUtil:SwitchCameraPos("FOLLOW_GESTURE")
end

function var7.InitAlchemistAPView(arg0)
	arg0._alchemistAP = var0.Battle.BattleReisalinAPView.New(arg0._ui:findTF("APPanel"))
end

function var7.InitGuide(arg0)
	return
end

function var7.InitCamera(arg0)
	arg0._camera = pg.UIMgr.GetInstance():GetMainCamera():GetComponent(typeof(Camera))
	arg0._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0._cameraUtil = var0.Battle.BattleCameraUtil.GetInstance()

	arg0._cameraUtil:RegisterEventListener(arg0, var1.CAMERA_FOCUS, arg0.onCameraFocus)
	arg0._cameraUtil:RegisterEventListener(arg0, var1.SHOW_PAINTING, arg0.onShowPainting)
	arg0._cameraUtil:RegisterEventListener(arg0, var1.BULLET_TIME, arg0.onBulletTime)
end

function var7.Update(arg0)
	for iter0, iter1 in pairs(arg0._updateViewList) do
		iter0:Update()
	end
end

function var7.AddUIEvent(arg0)
	arg0._dataProxy:RegisterEventListener(arg0, var1.STAGE_DATA_INIT_FINISH, arg0.onStageInit)
	arg0._dataProxy:RegisterEventListener(arg0, var1.COMMON_DATA_INIT_FINISH, arg0.onCommonInit)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_FLEET, arg0.onAddFleet)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_UNIT, arg0.onAddUnit)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_UNIT, arg0.onRemoveUnit)
	arg0._dataProxy:RegisterEventListener(arg0, var1.HIT_ENEMY, arg0.onEnemyHit)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_AIR_FIGHTER_ICON, arg0.onAddAirStrike)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_AIR_FIGHTER_ICON, arg0.onRemoveAirStrike)
	arg0._dataProxy:RegisterEventListener(arg0, var1.UPDATE_AIR_SUPPORT_LABEL, arg0.onUpdateAirSupportLabel)
	arg0._dataProxy:RegisterEventListener(arg0, var1.UPDATE_HOSTILE_SUBMARINE, arg0.onUpdateHostileSubmarine)
	arg0._dataProxy:RegisterEventListener(arg0, var1.UPDATE_ENVIRONMENT_WARNING, arg0.onUpdateEnvironmentWarning)
	arg0._dataProxy:RegisterEventListener(arg0, var1.UPDATE_COUNT_DOWN, arg0.onUpdateCountDown)
	arg0._dataProxy:RegisterEventListener(arg0, var1.HIDE_INTERACTABLE_BUTTONS, arg0.OnHideButtons)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_UI_FX, arg0.OnAddUIFX)
	arg0._dataProxy:RegisterEventListener(arg0, var1.EDIT_CUSTOM_WARNING_LABEL, arg0.onEditCustomWarning)
	arg0._dataProxy:RegisterEventListener(arg0, var1.GRIDMAN_SKILL_FLOAT, arg0.onGridmanSkillFloat)
	arg0._dataProxy:RegisterEventListener(arg0, var6.CARD_PUZZLE_INIT, arg0.OnCardPuzzleInit)
end

function var7.RemoveUIEvent(arg0)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.COMMON_DATA_INIT_FINISH)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.STAGE_DATA_INIT_FINISH)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_FLEET)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_UNIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_UNIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.HIT_ENEMY)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.UPDATE_COUNT_DOWN)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_AIR_FIGHTER_ICON)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_AIR_FIGHTER_ICON)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.UPDATE_AIR_SUPPORT_LABEL)
	arg0._cameraUtil:UnregisterEventListener(arg0, var1.SHOW_PAINTING)
	arg0._cameraUtil:UnregisterEventListener(arg0, var1.CAMERA_FOCUS)
	arg0._cameraUtil:UnregisterEventListener(arg0, var1.BULLET_TIME)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_SUBMARINE_WARINING)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_SUBMARINE_WARINING)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.UPDATE_DODGEM_SCORE)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.UPDATE_DODGEM_COMBO)
	arg0._userFleet:UnregisterEventListener(arg0, var1.SHOW_BUFFER)
	arg0._userFleet:UnregisterEventListener(arg0, var2.POINT_HIT_CHARGE)
	arg0._userFleet:UnregisterEventListener(arg0, var2.POINT_HIT_CANCEL)
	arg0._userFleet:UnregisterEventListener(arg0, var1.MANUAL_SUBMARINE_SHIFT)
	arg0._userFleet:UnregisterEventListener(arg0, var1.FLEET_BLIND)
	arg0._userFleet:UnregisterEventListener(arg0, var1.FLEET_HORIZON_UPDATE)
	arg0._userFleet:UnregisterEventListener(arg0, var1.UPDATE_FLEET_ATTR)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.UPDATE_HOSTILE_SUBMARINE)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.UPDATE_ENVIRONMENT_WARNING)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.HIDE_INTERACTABLE_BUTTONS)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_UI_FX)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.EDIT_CUSTOM_WARNING_LABEL)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.GRIDMAN_SKILL_FLOAT)
	arg0._dataProxy:UnregisterEventListener(arg0, var6.CARD_PUZZLE_INIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var6.UPDATE_FLEET_SHIP)
	arg0._dataProxy:UnregisterEventListener(arg0, var6.COMMON_BUTTON_ENABLE)
	arg0._dataProxy:UnregisterEventListener(arg0, var6.LONG_PRESS_BULLET_TIME)
	arg0._dataProxy:UnregisterEventListener(arg0, var6.SHOW_CARD_DETAIL)
end

function var7.ShowSkillPainting(arg0, arg1, arg2, arg3)
	arg3 = arg3 or 1

	local var0

	if arg2 then
		var0 = arg2.cutin_cover
	end

	arg0._ui:CutInPainting(arg1:GetTemplate(), arg3, arg1:GetIFF(), var0)
end

function var7.ShowSkillFloat(arg0, arg1, arg2, arg3)
	arg0._ui:SkillHrzPop(arg2, arg1, arg3)
end

function var7.ShowSkillFloatCover(arg0, arg1, arg2, arg3)
	arg0._ui:SkillHrzPopCover(arg2, arg1, arg3)
end

function var7.SeaSurfaceShift(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg3 or var0.Battle.BattleConfig.calcInterval

	arg0._seaView:ShiftSurface(arg1, arg2, var0, arg4)
end

function var7.ShowAutoBtn(arg0)
	SetActive(arg0._autoBtn.transform, true)

	local var0 = arg0:GetState():GetBattleType()

	triggerToggle(arg0._autoBtn, var0.Battle.BattleState.IsAutoBotActive(var0))
end

function var7.ShowTimer(arg0)
	arg0._timerView:SetActive(true)
end

function var7.ShowDuelBar(arg0)
	arg0._duelRateBar:SetActive(true)
end

function var7.ShowSimulationView(arg0)
	arg0._simulationBuffCountView:SetActive(true)
end

function var7.ShowPauseButton(arg0, arg1)
	setActive(arg0._ui:findTF("PauseBtn"), arg1)
end

function var7.ShowDodgemScoreBar(arg0)
	arg0:InitScoreBar()
	arg0._dataProxy:RegisterEventListener(arg0, var1.UPDATE_DODGEM_SCORE, arg0.onUpdateDodgemScore)
	arg0._dataProxy:RegisterEventListener(arg0, var1.UPDATE_DODGEM_COMBO, arg0.onUpdateDodgemCombo)
	arg0._scoreBarView:UpdateScore(0)
	arg0._scoreBarView:SetActive(true)
end

function var7.ShowAirFightScoreBar(arg0)
	arg0:InitAirFightScoreBar()
	arg0._dataProxy:RegisterEventListener(arg0, var1.UPDATE_DODGEM_SCORE, arg0.onUpdateDodgemScore)
	arg0._dataProxy:RegisterEventListener(arg0, var1.UPDATE_DODGEM_COMBO, arg0.onUpdateDodgemCombo)
	arg0._scoreBarView:UpdateScore(0)
	arg0._scoreBarView:SetActive(true)
end

function var7.onStageInit(arg0, arg1)
	arg0:InitJoystick()
	arg0:InitScene()
	arg0:InitTimer()
	arg0:InitEnemyHpBar()
	arg0:InitAirStrikeIcon()
	arg0:InitCommonWarning()
	arg0:InitAutoBtn()
	arg0:InitMainDamagedView()
end

function var7.onEnemyHit(arg0, arg1)
	local var0 = arg1.Data

	if var0:GetDiveInvisible() and not var0:GetDiveDetected() then
		return
	end

	local var1 = arg0._enemyHpBar:GetCurrentTarget()

	if var1 then
		if var1 ~= var0 then
			arg0._enemyHpBar:SwitchTarget(var0, arg0._dataProxy:GetUnitList())
		end
	else
		arg0._enemyHpBar:SwitchTarget(var0, arg0._dataProxy:GetUnitList())
	end
end

function var7.onEnemyHpUpdate(arg0, arg1)
	local var0 = arg1.Dispatcher

	if var0 == arg0._enemyHpBar:GetCurrentTarget() and (not var0:GetDiveInvisible() or var0:GetDiveDetected()) then
		arg0._enemyHpBar:UpdateHpBar()
	end
end

function var7.onPlayerMainUnitHpUpdate(arg0, arg1)
	if arg1.Data.dHP < 0 then
		arg0._mainDamagedView:Play()
	end
end

function var7.onSkillFloat(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.coverHrzIcon
	local var2 = var0.commander
	local var3 = var0.skillName
	local var4 = arg1.Dispatcher

	if var1 then
		arg0:ShowSkillFloatCover(var4, var3, var1)
	else
		arg0:ShowSkillFloat(var4, var3, var2)
	end
end

function var7.onCommonInit(arg0, arg1)
	arg0._skillView = var0.Battle.BattleSkillView.New(arg0, arg1.Data)
	arg0._updateViewList[arg0._skillView] = true
	arg0._userFleet = arg0._dataProxy:GetFleetByIFF(var5.FRIENDLY_CODE)

	arg0._userFleet:RegisterEventListener(arg0, var1.SHOW_BUFFER, arg0.onShowBuffer)
	arg0._userFleet:RegisterEventListener(arg0, var2.POINT_HIT_CHARGE, arg0.onPointHitSight)
	arg0._userFleet:RegisterEventListener(arg0, var2.POINT_HIT_CANCEL, arg0.onPointHitSight)
	arg0._userFleet:RegisterEventListener(arg0, var1.MANUAL_SUBMARINE_SHIFT, arg0.onManualSubShift)
	arg0._userFleet:RegisterEventListener(arg0, var1.FLEET_BLIND, arg0.onFleetBlind)
	arg0._userFleet:RegisterEventListener(arg0, var1.UPDATE_FLEET_ATTR, arg0.onFleetAttrUpdate)

	arg0._sightView = var0.Battle.BattleOpticalSightView.New(arg0._ui:findTF("ChargeAreaContainer"))

	arg0._sightView:SetFleetVO(arg0._userFleet)

	local var0, var1, var2, var3 = arg0._dataProxy:GetTotalBounds()

	arg0._sightView:SetAreaBound(var2, var3)

	local var4
	local var5

	if arg0._dataProxy:GetInitData().ChapterBuffIDs then
		for iter0, iter1 in ipairs(arg0._dataProxy:GetInitData().ChapterBuffIDs) do
			if iter1 == 9727 then
				var4 = true

				break
			end
		end
	end

	if #arg0._dataProxy:GetFleetByIFF(var5.FRIENDLY_CODE):GetSupportUnitList() > 0 then
		var5 = true
	end

	if var5 and not var4 then
		arg0._airAdavantageTF = arg0._airSupportTF:Find("player_advantage")
	elseif var4 and not var5 then
		arg0._airAdavantageTF = arg0._airSupportTF:Find("enemy_advantage")
	elseif var4 and var5 then
		arg0._airAdavantageTF = arg0._airSupportTF:Find("draw")
	end
end

function var7.onAddFleet(arg0, arg1)
	local var0 = arg1.Data.fleetVO

	if PlayerPrefs.GetInt(BATTLE_EXPOSE_LINE, 1) == 1 then
		arg0:SetFleetCloakLine(var0)
	end
end

function var7.SetFleetCloakLine(arg0, arg1)
	if #arg1:GetCloakList() > 0 then
		local var0 = arg1:GetIFF()
		local var1 = arg1:GetFleetVisionLine()
		local var2 = arg1:GetFleetExposeLine()

		arg0._seaView:SetExposeLine(var0, var1, var2)
	end
end

function var7.onAddUnit(arg0, arg1)
	local var0 = arg1.Data.type
	local var1 = arg1.Data.unit

	if var0 == var3.UnitType.PLAYER_UNIT or var0 == var3.UnitType.ENEMY_UNIT or var0 == var3.UnitType.BOSS_UNIT then
		arg0:registerUnitEvent(var1)
	end

	if var1:IsBoss() and arg0._dataProxy:GetActiveBossCount() == 1 then
		arg0:AddBossWarningUI()
	elseif var0 == var3.UnitType.ENEMY_UNIT then
		arg0:registerNPCUnitEvent(var1)
	elseif var0 == var3.UnitType.PLAYER_UNIT and var1:IsMainFleetUnit() and var1:GetIFF() == var5.FRIENDLY_CODE then
		arg0:registerPlayerMainUnitEvent(var1)
	end

	local var2 = var1:GetTemplate().nationality

	if table.contains(var5.ALCHEMIST_AP_UI, var2) and var1:GetIFF() == var5.FRIENDLY_CODE then
		arg0:InitAlchemistAPView()
	end
end

function var7.onSubmarineDetected(arg0, arg1)
	local var0 = arg1.Dispatcher

	if arg0._enemyHpBar:GetCurrentTarget() and arg0._enemyHpBar:GetCurrentTarget() == var0 and var0:GetDiveDetected() == false then
		arg0._enemyHpBar:RemoveUnit()
	end
end

function var7.onRemoveUnit(arg0, arg1)
	local var0 = arg1.Data.unit
	local var1 = arg1.Data.type

	if var1 == var3.UnitType.PLAYER_UNIT or var1 == var3.UnitType.ENEMY_UNIT or var1 == var3.UnitType.BOSS_UNIT then
		arg0:unregisterUnitEvent(var0)
	end

	if var1 == var3.UnitType.ENEMY_UNIT and not var0:IsBoss() then
		arg0:unregisterNPCUnitEvent(var0)
	elseif var0:GetIFF() == var5.FRIENDLY_CODE and var0:IsMainFleetUnit() then
		arg0:unregisterPlayerMainUnitEvent(var0)
	end

	if arg1.Data.deadReason == var3.UnitDeathReason.LEAVE and arg0._enemyHpBar:GetCurrentTarget() and arg0._enemyHpBar:GetCurrentTarget() == arg1.Data.unit then
		arg0._enemyHpBar:RemoveUnit(arg1.Data.deadReason)
	end
end

function var7.onUpdateCountDown(arg0, arg1)
	arg0._timerView:SetCountDownText(arg0._dataProxy:GetCountDown())
end

function var7.onUpdateDodgemScore(arg0, arg1)
	local var0 = arg1.Data.totalScore

	arg0._scoreBarView:UpdateScore(var0)
end

function var7.onUpdateDodgemCombo(arg0, arg1)
	local var0 = arg1.Data.combo

	arg0._scoreBarView:UpdateCombo(var0)
end

function var7.onAddAirStrike(arg0, arg1)
	local var0 = arg1.Data.index
	local var1 = arg0._dataProxy:GetAirFighterInfo(var0)

	arg0._airStrikeView:AppendIcon(var0, var1)
end

function var7.onRemoveAirStrike(arg0, arg1)
	local var0 = arg1.Data.index
	local var1 = arg0._dataProxy:GetAirFighterInfo(var0)

	arg0._airStrikeView:RemoveIcon(var0, var1)
end

function var7.onUpdateAirSupportLabel(arg0, arg1)
	local var0 = arg0._dataProxy:GetAirFighterList()
	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 + iter1.totalNumber
	end

	if var1 == 0 or arg0._warningView:GetCount() > 0 then
		eachChild(arg0._airSupportTF, function(arg0)
			setActive(arg0, false)
		end)
	elseif arg0._airAdavantageTF then
		setActive(arg0._airAdavantageTF, true)
	end
end

function var7.onUpdateHostileSubmarine(arg0, arg1)
	local var0 = arg0._dataProxy:GetEnemySubmarineCount()

	arg0._warningView:UpdateHostileSubmarineCount(var0)
	arg0:onUpdateAirSupportLabel()
end

function var7.onUpdateEnvironmentWarning(arg0, arg1)
	if arg1.Data.isActive then
		arg0._warningView:ActiveWarning(arg0._warningView.WARNING_TYPE_ARTILLERY)
	else
		arg0._warningView:DeactiveWarning(arg0._warningView.WARNING_TYPE_ARTILLERY)
	end
end

function var7.onCameraFocus(arg0, arg1)
	local var0 = arg1.Data

	if var0.unit ~= nil then
		local var1 = var0.skill or false

		arg0:EnableComponent(false)
		arg0:EnableSkillFloat(var1)
	else
		local var2 = var0.duration + var0.extraBulletTime

		LeanTween.delayedCall(arg0._ui._go, var2, System.Action(function()
			arg0:EnableComponent(true)
			arg0:EnableSkillFloat(true)
		end))
	end
end

function var7.onShowPainting(arg0, arg1)
	local var0 = arg1.Data

	arg0:ShowSkillPainting(var0.caster, var0.skill, var0.speed)
end

function var7.onBulletTime(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.key
	local var2 = var0.rate

	if var2 then
		var4.AppendMapFactor(var1, var2)
	else
		var4.RemoveMapFactor(var1)
	end

	arg0._seaView:UpdateSpeedScaler()
end

function var7.onShowBuffer(arg0, arg1)
	local var0 = arg1.Data.dist

	arg0._seaView:UpdateBufferAlpha(var0)
end

function var7.onManualSubShift(arg0, arg1)
	local var0 = arg1.Data.state

	arg0._skillView:ShiftSubmarineManualButton(var0)
end

function var7.onPointHitSight(arg0, arg1)
	local var0 = arg1.ID

	if var0 == var2.POINT_HIT_CHARGE then
		arg0._sightView:SetActive(true)

		arg0._updateViewList[arg0._sightView] = true
	elseif var0 == var2.POINT_HIT_CANCEL then
		arg0._sightView:SetActive(false)

		arg0._updateViewList[arg0._sightView] = nil
	end
end

function var7.onFleetBlind(arg0, arg1)
	local var0 = arg1.Data.isBlind
	local var1 = arg1.Dispatcher

	if not arg0._inkView then
		arg0:InitInkView(var1)
	end

	if var0 then
		local var2 = var1:GetUnitList()

		arg0._inkView:SetActive(true, var2)
		arg0._skillView:HideSkillButton(true)

		arg0._updateViewList[arg0._inkView] = true
	else
		arg0._inkView:SetActive(false)
		arg0._skillView:HideSkillButton(false)

		arg0._updateViewList[arg0._inkView] = nil
	end
end

function var7.onFleetHorizonUpdate(arg0, arg1)
	if not arg0._inkView then
		return
	end

	local var0 = arg1.Dispatcher:GetUnitList()

	arg0._inkView:UpdateHollow(var0)
end

function var7.onFleetAttrUpdate(arg0, arg1)
	if arg0._alchemistAP then
		local var0 = arg1.Dispatcher
		local var1 = arg1.Data.attr
		local var2 = arg1.Data.value

		if var1 == arg0._alchemistAP:GetAttrName() then
			arg0._alchemistAP:UpdateAP(var2)
		end
	end
end

function var7.OnAddUIFX(arg0, arg1)
	local var0 = arg1.Data.FXID
	local var1 = arg1.Data.position
	local var2 = arg1.Data.localScale
	local var3 = arg1.Data.orderDiff

	arg0:AddUIFX(var3, var0, var1, var2)
end

function var7.AddUIFX(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0._fxPool:GetFX(arg2)

	arg1 = arg1 or 1

	local var1

	var1 = arg1 > 0

	local var2 = arg0._ui:AddUIFX(var0, arg1)

	arg4 = arg4 or 1
	var0.transform.localScale = Vector3(arg4 / var2.x, arg4 / var2.y, arg4 / var2.z)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0, arg3, true)
end

function var7.AddBossWarningUI(arg0)
	arg0._dataProxy:BlockManualCast(true)

	local var0 = var0.Battle.BattleResourceManager.GetInstance()

	arg0._appearEffect = var0:InstBossWarningUI()

	local var1 = arg0._appearEffect:GetComponent(typeof(Animator))
	local var2 = {
		Pause = function()
			var1.speed = 0
		end,
		Resume = function()
			var1.speed = 1
		end
	}

	arg0._state:SetTakeoverProcess(var2)

	var1.speed = 1 / arg0._state:GetTimeScaleRate()

	setParent(arg0._appearEffect, arg0._ui.uiCanvas, false)
	arg0._appearEffect:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		arg0._userFleet:CoupleEncourage()
		arg0._dataProxy:BlockManualCast(false)
		arg0._state:ClearTakeoverProcess()
		var0:DestroyOb(arg0._appearEffect)

		arg0._appearEffect = nil
	end)
	SetActive(arg0._appearEffect, true)
end

function var7.OnHideButtons(arg0, arg1)
	local var0 = arg1.Data.isActive

	arg0._skillView:HideSkillButton(not var0)
	SetActive(arg0._autoBtn.transform, var0)
end

function var7.onEditCustomWarning(arg0, arg1)
	local var0 = arg1.Data.labelData

	arg0._warningView:EditCustomWarning(var0)
end

function var7.onGridmanSkillFloat(arg0, arg1)
	if not arg0._gridmanSkillFloat then
		local var0 = var0.Battle.BattleResourceManager.GetInstance():InstGridmanSkillUI()

		arg0._gridmanSkillFloat = var0.Battle.BattleGridmanSkillFloatView.New(var0)

		setParent(var0, arg0._ui.uiCanvas, false)
	end

	local var1 = arg1.Data
	local var2 = var1.type
	local var3 = var1.IFF

	if var2 == 5 then
		arg0._gridmanSkillFloat:DoFusionFloat(var3)
	else
		arg0._gridmanSkillFloat:DoSkillFloat(var2, var3)
	end
end

function var7.registerUnitEvent(arg0, arg1)
	arg1:RegisterEventListener(arg0, var2.SKILL_FLOAT, arg0.onSkillFloat)
	arg1:RegisterEventListener(arg0, var2.CUT_INT, arg0.onShowPainting)
end

function var7.registerNPCUnitEvent(arg0, arg1)
	arg1:RegisterEventListener(arg0, var2.UPDATE_HP, arg0.onEnemyHpUpdate)

	local var0 = arg1:GetTemplate().type

	if table.contains(TeamType.SubShipType, var0) then
		arg1:RegisterEventListener(arg0, var2.SUBMARINE_DETECTED, arg0.onSubmarineDetected)
	end
end

function var7.registerPlayerMainUnitEvent(arg0, arg1)
	arg1:RegisterEventListener(arg0, var2.UPDATE_HP, arg0.onPlayerMainUnitHpUpdate)
end

function var7.unregisterUnitEvent(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var2.SKILL_FLOAT)
	arg1:UnregisterEventListener(arg0, var2.CUT_INT)
end

function var7.unregisterNPCUnitEvent(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var2.SKILL_FLOAT)
	arg1:UnregisterEventListener(arg0, var2.CUT_INT)
	arg1:UnregisterEventListener(arg0, var2.UPDATE_HP)

	local var0 = arg1:GetTemplate().type

	if table.contains(TeamType.SubShipType, var0) then
		arg1:UnregisterEventListener(arg0, var2.SUBMARINE_DETECTED)
	end
end

function var7.unregisterPlayerMainUnitEvent(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var2.UPDATE_HP)
end

function var7.Dispose(arg0)
	LeanTween.cancel(arg0._ui._go)
	arg0._uiMGR:ClearStick()

	arg0._uiMGR = nil

	if arg0._appearEffect then
		Destroy(arg0._appearEffect)
	end

	arg0:RemoveUIEvent()

	arg0._updateViewList = nil

	arg0._timerView:Dispose()
	arg0._enemyHpBar:Dispose()
	arg0._skillView:Dispose()
	arg0._seaView:Dispose()
	arg0._airStrikeView:Dispose()
	arg0._sightView:Dispose()
	arg0._mainDamagedView:Dispose()
	arg0._warningView:Dispose()

	arg0._seaView = nil
	arg0._enemyHpBar = nil
	arg0._skillView = nil
	arg0._timerView = nil
	arg0._joystick = nil
	arg0._airStrikeView = nil
	arg0._warningView = nil
	arg0._mainDamagedView = nil

	if arg0._duelRateBar then
		arg0._duelRateBar:Dispose()

		arg0._duelRateBar = nil
	end

	if arg0._simulationBuffCountView then
		arg0._simulationBuffCountView:Dispose()

		arg0._simulationBuffCountView = nil
	end

	if arg0._jammingView then
		arg0._jammingView:Dispose()

		arg0._jammingView = nil
	end

	if arg0._inkView then
		arg0._inkView:Dispose()

		arg0._inkView = nil
	end

	if arg0._alchemistAP then
		arg0._alchemistAP:Dispose()

		arg0._alchemistAP = nil
	end

	if arg0._gridmanSkillFloat then
		arg0._gridmanSkillFloat:Dispose()
	end

	if go(arg0._ui:findTF("CardPuzzleConsole")).activeSelf then
		arg0:DisposeCardPuzzleComponent()
	end

	var7.super.Dispose(arg0)
end

function var7.OnCardPuzzleInit(arg0, arg1)
	arg0._cardPuzzleComponent = arg0._dataProxy:GetFleetByIFF(var5.FRIENDLY_CODE):GetCardPuzzleComponent()

	arg0:ShowCardPuzzleComponent()
	arg0:RegisterCardPuzzleEvent()
end

function var7.RegisterCardPuzzleEvent(arg0)
	arg0._cardPuzzleComponent:RegisterEventListener(arg0, var6.UPDATE_FLEET_SHIP, arg0.onUpdateFleetShip)
	arg0._cardPuzzleComponent:RegisterEventListener(arg0, var6.COMMON_BUTTON_ENABLE, arg0.onBlockCommonButton)
	arg0._cardPuzzleComponent:RegisterEventListener(arg0, var6.LONG_PRESS_BULLET_TIME, arg0.onLongPressBulletTime)
	arg0._cardPuzzleComponent:RegisterEventListener(arg0, var6.SHOW_CARD_DETAIL, arg0.onShowCardDetail)
end

function var7.ShowCardPuzzleComponent(arg0)
	setActive(arg0._ui:findTF("CardPuzzleConsole"), true)
	arg0:InitCardPuzzleCommonHPBar()
	arg0:InitCardPuzzleEnergyBar()
	arg0:IntCardPuzzleFleetHead()
	arg0:InitCameraCardBoardClicker()
	arg0:InitCardPuzzleMovePile()
	arg0:InitCardPuzzleDeckPile()
	arg0:InitCardPuzzleIconList()
	arg0:InitCardPuzzleHandBoard()
	arg0:InitCardPuzzleCardDetail()
	arg0:InitCardPuzzleGoalRemind()
end

function var7.InitCardPuzzleCommonHPBar(arg0)
	arg0._cardPuzzleHPBar = var0.Battle.CardPuzzleCommonHPBar.New(arg0._ui:findTF("CardPuzzleConsole/commonHP"))

	arg0._cardPuzzleHPBar:SetCardPuzzleComponent(arg0._cardPuzzleComponent)

	arg0._updateViewList[arg0._cardPuzzleHPBar] = true
end

function var7.InitCardPuzzleEnergyBar(arg0)
	arg0._cardPuzzleEnergyBar = var0.Battle.CardPuzzleEnergyBar.New(arg0._ui:findTF("CardPuzzleConsole/energy_block"))

	arg0._cardPuzzleEnergyBar:SetCardPuzzleComponent(arg0._cardPuzzleComponent)

	arg0._updateViewList[arg0._cardPuzzleEnergyBar] = true
end

function var7.InitCameraCardBoardClicker(arg0)
	arg0._cardPuzzleBoardClicker = var0.Battle.CardPuzzleBoardClicker.New(arg0._ui:findTF("CardBoardController"))

	arg0._cardPuzzleBoardClicker:SetCardPuzzleComponent(arg0._cardPuzzleComponent)
end

function var7.IntCardPuzzleFleetHead(arg0)
	arg0._cardPuzzleFleetHead = var0.Battle.CardPuzzleFleetHead.New(arg0._ui:findTF("CardPuzzleConsole/fleet"))

	arg0._cardPuzzleFleetHead:SetCardPuzzleComponent(arg0._cardPuzzleComponent)
end

function var7.InitCardPuzzleMovePile(arg0)
	arg0._cardPuzzleMovePile = var0.Battle.CardPuzzleMovePile.New(arg0._ui:findTF("CardPuzzleConsole/movedeck"))

	arg0._cardPuzzleMovePile:SetCardPuzzleComponent(arg0._cardPuzzleComponent)

	arg0._updateViewList[arg0._cardPuzzleMovePile] = true
end

function var7.InitCardPuzzleDeckPile(arg0)
	arg0._cardPuzzleDeckPile = var0.Battle.CardPuzzleDeckPool.New(arg0._ui:findTF("CardPuzzleConsole/deck"))

	arg0._cardPuzzleDeckPile:SetCardPuzzleComponent(arg0._cardPuzzleComponent)
end

function var7.InitCardPuzzleIconList(arg0)
	arg0._cardPuzzleStatusIcon = var0.Battle.CardPuzzleFleetIconList.New(arg0._ui:findTF("CardPuzzleConsole/statusIcon"))

	arg0._cardPuzzleStatusIcon:SetCardPuzzleComponent(arg0._cardPuzzleComponent)

	arg0._updateViewList[arg0._cardPuzzleStatusIcon] = true
end

function var7.InitCardPuzzleHandBoard(arg0)
	arg0._cardPuzzleHandBoard = var0.Battle.CardPuzzleHandBoard.New(arg0._ui:findTF("CardPuzzleConsole/cardboard"), arg0._ui:findTF("CardPuzzleConsole/hand"))

	arg0._cardPuzzleHandBoard:SetCardPuzzleComponent(arg0._cardPuzzleComponent)

	arg0._updateViewList[arg0._cardPuzzleHandBoard] = true
end

function var7.InitCardPuzzleGoalRemind(arg0)
	arg0._cardPuzzleGoalRemind = var0.Battle.CardPuzzleGoalRemind.New(arg0._ui:findTF("CardPuzzleConsole/goal"))

	arg0._cardPuzzleGoalRemind:SetCardPuzzleComponent(arg0._cardPuzzleComponent)
end

function var7.InitCardPuzzleCardDetail(arg0)
	arg0._cardPuzzleCardDetail = var0.Battle.CardPuzzleCardDetail.New(arg0._ui:findTF("CardPuzzleConsole/cardDetail"))
end

function var7.DisposeCardPuzzleComponent(arg0)
	arg0._cardPuzzleHPBar:Dispose()
	arg0._cardPuzzleEnergyBar:Dispose()
	arg0._cardPuzzleBoardClicker:Dispose()
	arg0._cardPuzzleFleetHead:Dispose()
	arg0._cardPuzzleMovePile:Dispose()
	arg0._cardPuzzleDeckPile:Dispose()
	arg0._cardPuzzleStatusIcon:Dispose()
	arg0._cardPuzzleHandBoard:Dispose()
	arg0._cardPuzzleGoalRemind:Dispose()
	arg0._cardPuzzleCardDetail:Dispose()
end

function var7.onUpdateFleetBuff(arg0)
	return
end

function var7.onUpdateFleetShip(arg0, arg1)
	arg0._cardPuzzleFleetHead:UpdateShipIcon(arg1.Data.teamType)
end

function var7.onBlockCommonButton(arg0, arg1)
	local var0 = arg1.Data.flag

	arg0:EnableComponent(var0)
end

function var7.onLongPressBulletTime(arg0, arg1)
	local var0 = arg1.Data.timeScale

	arg0._state:ScaleTimer(var0)
end

function var7.onShowCardDetail(arg0, arg1)
	local var0 = arg1.Data.card

	if var0 then
		arg0._cardPuzzleCardDetail:Active(true)
		arg0._cardPuzzleCardDetail:SetReferenceCard(var0)
	else
		arg0._cardPuzzleCardDetail:Active(false)
	end
end
