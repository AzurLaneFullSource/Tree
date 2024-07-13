ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleCardPuzzleEvent
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleConfig
local var5_0 = var0_0.Battle.BattleVariable
local var6_0 = var0_0.Battle.BattleTargetChoise
local var7_0 = class("BattleSceneMediator", var0_0.MVC.Mediator)

var0_0.Battle.BattleSceneMediator = var7_0
var7_0.__name = "BattleSceneMediator"

local var8_0 = Vector3(0, 0.8, 0)

function var7_0.Ctor(arg0_1)
	var7_0.super.Ctor(arg0_1)

	arg0_1.FlagShipUIPos = Vector3.zero
end

function var7_0.Initialize(arg0_2)
	var7_0.super.Initialize(arg0_2)

	arg0_2._dataProxy = arg0_2._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)

	arg0_2:InitCharacterFactory()
	arg0_2:Init()
	arg0_2:AddEvent()
end

function var7_0.Init(arg0_3)
	arg0_3._characterList = {}
	arg0_3._bulletList = {}
	arg0_3._particleBulletList = {}
	arg0_3._aircraftList = {}
	arg0_3._areaList = {}
	arg0_3._shelterList = {}
	arg0_3._arcEffectList = {}
	arg0_3._bulletContainer = GameObject.Find("BulletContainer")
	arg0_3._fxPool = var0_0.Battle.BattleFXPool.GetInstance()
	arg0_3._aimBiasTFList = {}

	var0_0.Battle.BattleCharacterFXContainersPool.GetInstance():Init()
	arg0_3:InitPlayerAntiAirArea()
	arg0_3:InitPlayerAntiSubArea()
	arg0_3:InitFlagShipMark()
	arg0_3:InitSkillAim()
	pg.CameraFixMgr.GetInstance():Adapt()
	pg.CameraFixMgr.GetInstance():SetMaskAsTopLayer(true)
end

function var7_0.InitCamera(arg0_4)
	arg0_4._cameraUtil = var0_0.Battle.BattleCameraUtil.GetInstance()

	arg0_4._cameraUtil:RegisterEventListener(arg0_4, var1_0.CAMERA_FOCUS_RESET, arg0_4.onCameraFocusReset)
	arg0_4._cameraUtil:RegisterEventListener(arg0_4, var1_0.BULLET_TIME, arg0_4.onBulletTime)
end

function var7_0.InitPopNumPool(arg0_5)
	local var0_5 = var0_0.Battle.BattlePopNumManager

	arg0_5._popNumMgr = var0_5.GetInstance()

	local var1_5 = arg0_5._state:GetUI()

	if arg0_5._dataProxy:GetInitData().battleType == SYSTEM_DODGEM then
		arg0_5._popNumMgr:InitialScorePool(var1_5:findTF(var0_5.CONTAINER_CHARACTER_HP .. "/container"))
	else
		arg0_5._popNumMgr:InitialBundlePool(var1_5:findTF(var0_5.CONTAINER_CHARACTER_HP .. "/container"))
	end
end

function var7_0.InitFlagShipMark(arg0_6)
	local var0_6 = arg0_6._state:GetUI():findGO("flagShipMark")

	var0_6:SetActive(true)

	arg0_6._goFlagShipMarkTf = var0_6.transform
end

function var7_0.InitSkillAim(arg0_7)
	arg0_7._cardAimTargetFilter = {}
	arg0_7._cardAimTargetList = {}
end

function var7_0.InitCharacterFactory(arg0_8)
	local var0_8 = arg0_8._state:GetUI()

	var0_0.Battle.BattleHPBarManager.GetInstance():InitialPoolRoot(var0_8:findTF(var0_0.Battle.BattleHPBarManager.ROOT_NAME))
	var0_0.Battle.BattleArrowManager.GetInstance():Init(var0_8:findTF(var0_0.Battle.BattleArrowManager.ROOT_NAME))

	arg0_8._characterFactoryList = {
		[var3_0.UnitType.PLAYER_UNIT] = var0_0.Battle.BattlePlayerCharacterFactory.GetInstance(),
		[var3_0.UnitType.ENEMY_UNIT] = var0_0.Battle.BattleEnemyCharacterFactory.GetInstance(),
		[var3_0.UnitType.MINION_UNIT] = var0_0.Battle.BattleMinionCharacterFactory.GetInstance(),
		[var3_0.UnitType.BOSS_UNIT] = var0_0.Battle.BattleBossCharacterFactory.GetInstance(),
		[var3_0.UnitType.AIRCRAFT_UNIT] = var0_0.Battle.BattleAircraftCharacterFactory.GetInstance(),
		[var3_0.UnitType.AIRFIGHTER_UNIT] = var0_0.Battle.BattleAirFighterCharacterFactory.GetInstance(),
		[var3_0.UnitType.SUB_UNIT] = var0_0.Battle.BattleSubCharacterFactory.GetInstance()
	}
end

function var7_0.InitPlayerAntiAirArea(arg0_9)
	arg0_9._antiAirArea = arg0_9._fxPool:GetFX("AntiAirArea")
	arg0_9._antiAirAreaTF = arg0_9._antiAirArea.transform

	arg0_9._antiAirArea:SetActive(false)
end

function var7_0.InitPlayerAntiSubArea(arg0_10)
	arg0_10._anitSubArea = arg0_10._fxPool:GetFX("AntiSubArea")
	arg0_10._anitSubAreaTF = arg0_10._anitSubArea.transform

	arg0_10._anitSubArea:SetActive(false)

	arg0_10._antiSubScanAnima = arg0_10._anitSubAreaTF:Find("Quad"):GetComponent(typeof(Animator))
	arg0_10._anitSubAreaTFList = {}
	arg0_10._anitSubAreaTFList[arg0_10._anitSubAreaTF] = true
end

function var7_0.InitDetailAntiSubArea(arg0_11)
	local var0_11, var1_11, var2_11, var3_11 = arg0_11._leftFleet:GetFleetSonar():GetTotalRangeDetail()

	local function var4_11(arg0_12, arg1_12, arg2_12)
		local var0_12 = arg0_11._fxPool:GetFX("AntiSubArea")

		var0_12.name = arg2_12

		local var1_12 = var0_12.transform

		var1_12.localScale = Vector3(arg0_12, 0, arg0_12)
		var1_12:Find("static"):GetComponent("SpriteRenderer").color = arg1_12

		var0_12:SetActive(true)

		arg0_11._anitSubAreaTFList[var1_12] = true
	end

	var4_11(var0_11 + var1_11 + var2_11 + var3_11, Color.New(1, 1, 1, 1), "技能额外直径：" .. var3_11)
	var4_11(var0_11 + var1_11 + var2_11, Color.New(0.07, 1, 0, 1), "装备提供直径：" .. var2_11)
	var4_11(var0_11 + var1_11, Color.New(1, 0.32, 0, 1), "主力提供直径：" .. var1_11)
	var4_11(var0_11, Color.New(1, 0, 0, 1), "基础直径：" .. var0_11)
end

function var7_0.AddEvent(arg0_13)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.STAGE_DATA_INIT_FINISH, arg0_13.onStageInitFinish)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.ADD_UNIT, arg0_13.onAddUnit)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.REMOVE_UNIT, arg0_13.onRemoveUnit)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.REMOVE_BULLET, arg0_13.onRemoveBullet)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.REMOVE_AIR_CRAFT, arg0_13.onRemoveAircraft)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.REMOVE_AIR_FIGHTER, arg0_13.onRemoveAirFighter)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.ADD_AREA, arg0_13.onAddArea)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.REMOVE_AREA, arg0_13.onRemoveArea)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.ADD_EFFECT, arg0_13.onAddEffect)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.ADD_SHELTER, arg0_13.onAddShelter)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.REMOVE_SHELTER, arg0_13.onRemoveShleter)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.ANTI_AIR_AREA, arg0_13.onAntiAirArea)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.UPDATE_HOSTILE_SUBMARINE, arg0_13.onUpdateHostileSubmarine)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.ADD_CAMERA_FX, arg0_13.onAddCameraFX)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.ADD_AIM_BIAS, arg0_13.onAddAimBias)
	arg0_13._dataProxy:RegisterEventListener(arg0_13, var1_0.REMOVE_AIM_BIAS, arg0_13.onRemoveAimBias)

	arg0_13._camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function()
		arg0_13._dataProxy:OnCameraRatioUpdate()
	end)
end

function var7_0.RemoveEvent(arg0_15)
	arg0_15._leftFleet:UnregisterEventListener(arg0_15, var1_0.SONAR_SCAN)
	arg0_15._leftFleet:UnregisterEventListener(arg0_15, var1_0.SONAR_UPDATE)
	arg0_15._leftFleet:UnregisterEventListener(arg0_15, var1_0.ADD_AIM_BIAS)
	arg0_15._leftFleet:UnregisterEventListener(arg0_15, var1_0.REMOVE_AIM_BIAS)
	arg0_15._leftFleet:UnregisterEventListener(arg0_15, var2_0.FLEET_MOVE_TO)
	arg0_15._leftFleet:UnregisterEventListener(arg0_15, var2_0.UPDATE_CARD_TARGET_FILTER)
	arg0_15._leftFleet:UnregisterEventListener(arg0_15, var1_0.ON_BOARD_CLICK)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.STAGE_DATA_INIT_FINISH)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.ADD_UNIT)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.REMOVE_UNIT)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.REMOVE_BULLET)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.REMOVE_AIR_CRAFT)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.REMOVE_AIR_FIGHTER)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.ADD_AREA)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.REMOVE_AREA)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.ADD_EFFECT)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.ADD_SHELTER)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.REMOVE_SHELTER)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.ANTI_AIR_AREA)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.UPDATE_HOSTILE_SUBMARINE)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.ADD_CAMERA_FX)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.ADD_AIM_BIAS)
	arg0_15._dataProxy:UnregisterEventListener(arg0_15, var1_0.REMOVE_AIM_BIAS)
	arg0_15._cameraUtil:UnregisterEventListener(arg0_15, var1_0.CAMERA_FOCUS_RESET)
	arg0_15._cameraUtil:UnregisterEventListener(arg0_15, var1_0.BULLET_TIME)
	pg.CameraFixMgr.GetInstance():disconnect(arg0_15._camEventId)
end

function var7_0.onStageInitFinish(arg0_16, arg1_16)
	arg0_16._leftFleet = arg0_16._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE)
	arg0_16._leftFleetMotion = arg0_16._leftFleet:GetMotion()

	arg0_16:InitCamera()
	arg0_16._leftFleet:RegisterEventListener(arg0_16, var1_0.SONAR_SCAN, arg0_16.onSonarScan)
	arg0_16._leftFleet:RegisterEventListener(arg0_16, var1_0.SONAR_UPDATE, arg0_16.onUpdateHostileSubmarine)
	arg0_16._leftFleet:RegisterEventListener(arg0_16, var1_0.ADD_AIM_BIAS, arg0_16.onAddAimBias)
	arg0_16._leftFleet:RegisterEventListener(arg0_16, var1_0.REMOVE_AIM_BIAS, arg0_16.onRemoveAimBias)
	arg0_16._leftFleet:RegisterEventListener(arg0_16, var2_0.FLEET_MOVE_TO, arg0_16.onUpdateMoveMark)
	arg0_16._leftFleet:RegisterEventListener(arg0_16, var2_0.ON_BOARD_CLICK, arg0_16.onBoardClick)
	arg0_16._leftFleet:RegisterEventListener(arg0_16, var2_0.UPDATE_CARD_TARGET_FILTER, arg0_16.onUpdateSkillAim)
	arg0_16:InitPopNumPool()
end

function var7_0.onAddUnit(arg0_17, arg1_17)
	local var0_17 = arg1_17.Data.type
	local var1_17 = arg0_17._characterFactoryList[var0_17]
	local var2_17 = arg1_17.Data

	var1_17:CreateCharacter(var2_17)
end

function var7_0.onRemoveUnit(arg0_18, arg1_18)
	local var0_18 = arg1_18.Data.UID
	local var1_18 = arg1_18.Data.deadReason
	local var2_18 = arg0_18._characterList[var0_18]

	if var2_18 then
		var2_18:GetFactory():RemoveCharacter(var2_18, var1_18)

		arg0_18._characterList[var0_18] = nil
	end
end

function var7_0.onRemoveAircraft(arg0_19, arg1_19)
	local var0_19 = arg1_19.Data.UID
	local var1_19 = arg0_19._aircraftList[var0_19]

	if var1_19 then
		var1_19:GetFactory():RemoveCharacter(var1_19)

		arg0_19._aircraftList[var0_19] = nil
	end
end

function var7_0.onRemoveAirFighter(arg0_20, arg1_20)
	local var0_20 = arg1_20.Data.UID
	local var1_20 = arg0_20._aircraftList[var0_20]

	if var1_20 then
		var1_20:GetFactory():RemoveCharacter(var1_20)

		arg0_20._aircraftList[var0_20] = nil
	end
end

function var7_0.onRemoveBullet(arg0_21, arg1_21)
	local var0_21 = arg1_21.Data.UID

	arg0_21:RemoveBullet(var0_21)
end

function var7_0.onAddArea(arg0_22, arg1_22)
	local var0_22 = arg1_22.Data.FXID
	local var1_22 = arg1_22.Data.area

	arg0_22:AddArea(var1_22, var0_22)
end

function var7_0.onRemoveArea(arg0_23, arg1_23)
	local var0_23 = arg1_23.Data.id

	arg0_23:RemoveArea(var0_23)
end

function var7_0.onAddEffect(arg0_24, arg1_24)
	local var0_24 = arg1_24.Data.FXID
	local var1_24 = arg1_24.Data.position
	local var2_24 = arg1_24.Data.localScale

	arg0_24:AddEffect(var0_24, var1_24, var2_24)
end

function var7_0.onAddShelter(arg0_25, arg1_25)
	local var0_25 = arg1_25.Data.shelter
	local var1_25, var2_25 = arg0_25._fxPool:GetFX(var0_25:GetFXID())
	local var3_25 = var0_25:GetPosition()

	pg.EffectMgr.GetInstance():PlayBattleEffect(var1_25, var3_25:Add(var2_25), true)

	if var0_25:GetIFF() == var4_0.FOE_CODE then
		local var4_25 = var1_25.transform
		local var5_25 = var4_25.localEulerAngles

		var5_25.y = 180
		var4_25.localEulerAngles = var5_25
	end

	arg0_25._shelterList[var0_25:GetUniqueID()] = var1_25
end

function var7_0.onRemoveShleter(arg0_26, arg1_26)
	local var0_26 = arg1_26.Data.uid
	local var1_26 = arg0_26._shelterList[var0_26]

	if var1_26 then
		var0_0.Battle.BattleResourceManager.GetInstance():DestroyOb(var1_26)

		arg0_26._shelterList[var0_26] = nil
	end
end

function var7_0.onAntiAirArea(arg0_27, arg1_27)
	local var0_27 = arg1_27.Data.isShow

	if var0_27 ~= nil then
		arg0_27._antiAirArea.gameObject:SetActive(arg1_27.Data.isShow)

		if var0_27 == true then
			local var1_27 = arg0_27._leftFleet:GetFleetAntiAirWeapon():GetRange() * 2

			arg0_27._antiAirAreaTF.localScale = Vector3(var1_27, 0, var1_27)
		end
	end
end

function var7_0.onAntiAirOverload(arg0_28, arg1_28)
	local var0_28 = arg1_28.Dispatcher
	local var1_28 = arg0_28._antiAirAreaTF:Find("Quad"):GetComponent(typeof(Animator))

	if var0_28:IsOverLoad() then
		var1_28.enabled = false
	else
		var1_28.enabled = true
	end
end

function var7_0.onUpdateHostileSubmarine(arg0_29, arg1_29)
	arg0_29:updateSonarView()
end

function var7_0.updateSonarView(arg0_30)
	local var0_30 = arg0_30._dataProxy:GetEnemySubmarineCount() > 0

	arg0_30._sonarActive = var0_30

	for iter0_30, iter1_30 in pairs(arg0_30._characterList) do
		iter1_30:SonarAcitve(var0_30)
	end

	local var1_30 = arg0_30._leftFleet:GetFleetSonar():GetCurrentState() ~= var0_0.Battle.BattleFleetStaticSonar.STATE_DISABLE and var0_30

	arg0_30._anitSubArea.gameObject:SetActive(var1_30)

	if var1_30 then
		local var2_30 = arg0_30._leftFleet:GetFleetSonar():GetRange()

		arg0_30._anitSubAreaTF.localScale = Vector3(var2_30, 0, var2_30)
	end
end

function var7_0.onSonarScan(arg0_31, arg1_31)
	if arg1_31.Data.indieSonar then
		local var0_31 = arg0_31._fxPool:GetFX("AntiSubArea").transform

		var0_31.localScale = Vector3(100, 0, 100)

		SetActive(var0_31:Find("static"), false)

		local var1_31 = var0_31:Find("Quad")
		local var2_31 = var1_31:GetComponent(typeof(Animator))

		var2_31.enabled = true

		var2_31:Play("antiSubZoom", -1, 0)

		arg0_31._anitSubAreaTFList[var0_31] = true

		var1_31:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_32)
			arg0_31._anitSubAreaTFList[var0_31] = nil
		end)
	elseif arg0_31._antiSubScanAnima and arg0_31._sonarActive then
		arg0_31._antiSubScanAnima.enabled = true

		arg0_31._antiSubScanAnima:Play("antiSubZoom", -1, 0)
	end
end

function var7_0.onAddAimBias(arg0_33, arg1_33)
	local var0_33 = arg1_33.Data.aimBias
	local var1_33 = arg0_33._fxPool:GetFX("AimBiasArea").transform

	arg0_33._aimBiasTFList[var0_33] = {
		tf = var1_33,
		vector = Vector3(5, 0, 5)
	}
end

function var7_0.onRemoveAimBias(arg0_34, arg1_34)
	local var0_34 = arg1_34.Data.aimBias
	local var1_34 = arg0_34._aimBiasTFList[var0_34]

	if var1_34 then
		local var2_34 = var1_34.tf.gameObject

		var0_0.Battle.BattleResourceManager.GetInstance():DestroyOb(var2_34)

		arg0_34._aimBiasTFList[var0_34] = nil
	end
end

function var7_0.onUpdateMoveMark(arg0_35, arg1_35)
	local var0_35 = arg1_35.Data.pos

	if not arg0_35._moveMarkFXTF then
		arg0_35._moveMarkFX = arg0_35._fxPool:GetFX("kapai_weizhi")
		arg0_35._moveMarkFXTF = arg0_35._moveMarkFX.transform
	end

	if var0_35 then
		setActive(arg0_35._moveMarkFXTF, true)

		arg0_35._moveMarkFXTF.position = var0_35
	else
		setActive(arg0_35._moveMarkFXTF, false)
	end
end

function var7_0.onBoardClick(arg0_36, arg1_36)
	local var0_36 = arg1_36.Data.click
	local var1_36 = arg0_36._leftFleet:GetCardPuzzleComponent():GetTouchScreenPoint()

	if var0_36 == var0_0.Battle.CardPuzzleBoardClicker.CLICK_STATE_CLICK then
		arg0_36._clickMarkFxTF = arg0_36._fxPool:GetFX("kapai_weizhi").transform
		arg0_36._clickMarkFxTF.position = var1_36
	elseif var0_36 == var0_0.Battle.CardPuzzleBoardClicker.CLICK_STATE_DRAG then
		arg0_36._clickMarkFxTF.position = var1_36
	elseif var0_36 == var0_0.Battle.CardPuzzleBoardClicker.CLICK_STATE_RELEASE and arg0_36._clickMarkFxTF then
		var0_0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0_36._clickMarkFxTF.gameObject)
	end
end

function var7_0.onCameraFocusReset(arg0_37, arg1_37)
	arg0_37:ResetFocus()
end

function var7_0.onAddCameraFX(arg0_38, arg1_38)
	local var0_38 = arg1_38.Data.FXID
	local var1_38 = arg1_38.Data.position
	local var2_38 = arg1_38.Data.localScale
	local var3_38 = arg1_38.Data.orderDiff

	arg0_38:AddCameraFX(var3_38, var0_38, var1_38, var2_38)
end

function var7_0.AddCameraFX(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	local var0_39 = arg0_39._fxPool:GetFX(arg2_39)
	local var1_39 = arg0_39._cameraUtil:Add2Camera(var0_39, arg1_39)

	arg4_39 = arg4_39 or 1
	var0_39.transform.localScale = Vector3(arg4_39 / var1_39.x, arg4_39 / var1_39.y, arg4_39 / var1_39.z)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0_39, arg3_39, true)
end

function var7_0.onUpdateSkillAim(arg0_40, arg1_40)
	arg0_40._cardAimTargetFilter = arg1_40.Data.targetFilterList
end

function var7_0.Update(arg0_41)
	for iter0_41, iter1_41 in pairs(arg0_41._characterList) do
		iter1_41:Update()
	end

	for iter2_41, iter3_41 in pairs(arg0_41._aircraftList) do
		iter3_41:Update()
	end

	for iter4_41, iter5_41 in pairs(arg0_41._bulletList) do
		iter5_41:Update()
	end

	for iter6_41, iter7_41 in pairs(arg0_41._areaList) do
		iter7_41:Update()
	end

	for iter8_41, iter9_41 in ipairs(arg0_41._arcEffectList) do
		iter9_41:Update()
	end

	arg0_41:updateCardAim()
	arg0_41:UpdateAntiAirArea()
	arg0_41:UpdateAimBiasArea()
	arg0_41:UpdateFlagShipMark()
end

function var7_0.UpdatePause(arg0_42)
	for iter0_42, iter1_42 in pairs(arg0_42._characterList) do
		iter1_42:UpdateUIComponentPosition()
		iter1_42:UpdateHPBarPosition()
	end

	for iter2_42, iter3_42 in pairs(arg0_42._aircraftList) do
		iter3_42:UpdateUIComponentPosition()

		if iter3_42:GetUnitData():GetUniqueID() == var4_0.FOE_CODE then
			iter3_42:UpdateHPBarPosition()
		end
	end

	arg0_42:UpdateFlagShipMark()
end

function var7_0.UpdateEscapeOnly(arg0_43, arg1_43)
	for iter0_43, iter1_43 in pairs(arg0_43._characterList) do
		if iter1_43.__name == var0_0.Battle.BattleEnemyCharacter.__name or iter1_43.__name == var0_0.Battle.BattleBossCharacter.__name then
			iter1_43:Update(arg1_43)
		end
	end
end

function var7_0.Pause(arg0_44)
	arg0_44:PauseCharacterAction(true)

	for iter0_44, iter1_44 in pairs(arg0_44._areaList) do
		local var0_44 = iter1_44._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter2_44 = 0, var0_44.Length - 1 do
			var0_44[iter2_44]:Pause()
		end
	end

	arg0_44._cameraUtil:PauseShake()

	for iter3_44, iter4_44 in ipairs(arg0_44._arcEffectList) do
		local var1_44 = iter4_44._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter5_44 = 0, var1_44.Length - 1 do
			var1_44[iter5_44]:Pause()
		end
	end

	for iter6_44, iter7_44 in pairs(arg0_44._particleBulletList) do
		local var2_44 = iter6_44._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter8_44 = 0, var2_44.Length - 1 do
			var2_44[iter8_44]:Pause()
		end
	end
end

function var7_0.Resume(arg0_45)
	arg0_45:PauseCharacterAction(false)

	for iter0_45, iter1_45 in pairs(arg0_45._areaList) do
		local var0_45 = iter1_45._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter2_45 = 0, var0_45.Length - 1 do
			var0_45[iter2_45]:Play()
		end
	end

	arg0_45._cameraUtil:ResumeShake()

	for iter3_45, iter4_45 in ipairs(arg0_45._arcEffectList) do
		local var1_45 = iter4_45._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter5_45 = 0, var1_45.Length - 1 do
			var1_45[iter5_45]:Play()
		end
	end

	for iter6_45, iter7_45 in pairs(arg0_45._particleBulletList) do
		local var2_45 = iter6_45._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter8_45 = 0, var2_45.Length - 1 do
			var2_45[iter8_45]:Play()
		end
	end
end

function var7_0.onBulletTime(arg0_46, arg1_46)
	local var0_46 = arg1_46.Data
	local var1_46 = var0_46.key
	local var2_46 = var0_46.speed

	if var2_46 then
		local var3_46 = var0_46.exemptUnit:GetUniqueID()

		var5_0.AppendIFFFactor(var4_0.FOE_CODE, var1_46, var2_46)
		var5_0.AppendIFFFactor(var4_0.FRIENDLY_CODE, var1_46, var2_46)

		for iter0_46, iter1_46 in pairs(arg0_46._characterList) do
			if iter0_46 == var3_46 then
				iter1_46:SetAnimaSpeed(1 / var2_46)

				break
			end
		end
	else
		var5_0.RemoveIFFFactor(var4_0.FOE_CODE, var1_46)
		var5_0.RemoveIFFFactor(var4_0.FRIENDLY_CODE, var1_46)

		for iter2_46, iter3_46 in pairs(arg0_46._characterList) do
			iter3_46:SetAnimaSpeed(1)
		end

		for iter4_46, iter5_46 in pairs(arg0_46._bulletList) do
			iter5_46:SetAnimaSpeed(1)
		end
	end
end

function var7_0.ResetFocus(arg0_47)
	var5_0.RemoveIFFFactor(var4_0.FOE_CODE, var4_0.SPEED_FACTOR_FOCUS_CHARACTER)
	var5_0.RemoveIFFFactor(var4_0.FRIENDLY_CODE, var4_0.SPEED_FACTOR_FOCUS_CHARACTER)

	for iter0_47, iter1_47 in pairs(arg0_47._characterList) do
		iter1_47:SetAnimaSpeed(1)
	end

	for iter2_47, iter3_47 in pairs(arg0_47._bulletList) do
		iter3_47:SetAnimaSpeed(1)
	end

	arg0_47._cameraUtil:ZoomCamara(nil, nil, var4_0.CAM_RESET_DURATION)
end

function var7_0.UpdateFlagShipMark(arg0_48)
	local var0_48 = arg0_48.FlagShipUIPos:Copy(arg0_48._leftFleetMotion:GetPos())

	arg0_48._goFlagShipMarkTf.position = var5_0.CameraPosToUICamera(var0_48):Add(var8_0)
end

function var7_0.UpdateAntiAirArea(arg0_49)
	arg0_49._antiAirAreaTF.position = arg0_49._leftFleetMotion:GetPos()

	for iter0_49, iter1_49 in pairs(arg0_49._anitSubAreaTFList) do
		iter0_49.position = arg0_49._leftFleetMotion:GetPos()
	end
end

function var7_0.UpdateAimBiasArea(arg0_50)
	for iter0_50, iter1_50 in pairs(arg0_50._aimBiasTFList) do
		local var0_50 = iter1_50.tf
		local var1_50 = iter1_50.vector
		local var2_50 = iter1_50.cacheState
		local var3_50 = iter0_50:GetRange() * 2

		var1_50:Set(var3_50, 0, var3_50)

		var0_50.position = iter0_50:GetPosition()
		var0_50.localScale = var1_50

		local var4_50 = iter0_50:GetCurrentState()

		if var4_50 ~= var2_50 then
			setActive(var0_50:Find("suofang/Quad"), var4_50 ~= iter0_50.STATE_SKILL_EXPOSE)
		end

		iter1_50.cacheState = var4_50
	end
end

function var7_0.updateCardAim(arg0_51)
	local var0_51 = {}

	for iter0_51, iter1_51 in pairs(arg0_51._cardAimTargetFilter) do
		local var1_51 = var6_0.TargetFleetIndex(nil, {
			fleetPos = iter0_51
		})[1]

		for iter2_51, iter3_51 in ipairs(iter1_51) do
			local var2_51

			for iter4_51, iter5_51 in ipairs(iter3_51) do
				var2_51 = var6_0[iter5_51](var1_51, nil, var2_51)
			end

			for iter6_51, iter7_51 in ipairs(var2_51) do
				var0_51[iter7_51:GetUniqueID()] = true
			end
		end
	end

	for iter8_51, iter9_51 in pairs(arg0_51._cardAimTargetList) do
		if not var0_51[iter8_51] then
			Object.Destroy(go(iter9_51))

			arg0_51._cardAimTargetList[iter8_51] = nil
		end
	end

	for iter10_51, iter11_51 in pairs(var0_51) do
		local var3_51 = arg0_51._cardAimTargetList[iter10_51] or arg0_51:InstantiateCharacterComponent("SkillAimContainer/SkillAim").transform

		arg0_51._cardAimTargetList[iter10_51] = var3_51

		local var4_51 = arg0_51._characterList[iter10_51]

		if var4_51 then
			var3_51.position = var4_51:GetReferenceVector(var4_51.AIM_OFFSET)
		end
	end
end

function var7_0.AddBullet(arg0_52, arg1_52)
	local var0_52 = arg1_52:GetBulletData()

	arg0_52._bulletList[var0_52:GetUniqueID()] = arg1_52

	local var1_52 = arg1_52:GetGO()

	if var1_52 and var1_52:GetComponent(typeof(ParticleSystem)) then
		arg0_52._particleBulletList[arg1_52] = true
	end

	if var5_0.focusExemptList[var0_52:GetSpeedExemptKey()] then
		local var2_52 = arg0_52._state:GetTimeScaleRate()

		arg1_52:SetAnimaSpeed(1 / var2_52)
	end
end

function var7_0.RemoveBullet(arg0_53, arg1_53)
	local var0_53 = arg0_53._bulletList[arg1_53]

	if var0_53 then
		arg0_53._particleBulletList[var0_53] = nil

		var0_53:GetFactory():RemoveBullet(var0_53)
	end

	arg0_53._bulletList[arg1_53] = nil
end

function var7_0.GetBulletRoot(arg0_54)
	return arg0_54._bulletContainer
end

function var7_0.EnablePopContainer(arg0_55, arg1_55, arg2_55)
	setActive(arg0_55._state:GetUI():findTF(arg1_55), arg2_55)
end

function var7_0.AddPlayerCharacter(arg0_56, arg1_56)
	arg0_56:AppendCharacter(arg1_56)

	local var0_56 = arg0_56._dataProxy:GetInitData().battleType
	local var1_56 = arg1_56:GetUnitData():IsMainFleetUnit()

	if var0_56 == SYSTEM_DUEL then
		-- block empty
	elseif var0_56 == SYSTEM_SUBMARINE_RUN or var0_56 == SYSTEM_SUB_ROUTINE then
		arg1_56:SetBarHidden(false, false)
	else
		arg1_56:SetBarHidden(not var1_56, var1_56)
	end
end

function var7_0.AddEnemyCharacter(arg0_57, arg1_57)
	arg0_57:AppendCharacter(arg1_57)
end

function var7_0.AppendCharacter(arg0_58, arg1_58)
	local var0_58 = arg1_58:GetUnitData()

	arg0_58._characterList[var0_58:GetUniqueID()] = arg1_58
end

function var7_0.InstantiateCharacterComponent(arg0_59, arg1_59)
	local var0_59 = arg0_59._state:GetUI():findTF(arg1_59)

	return cloneTplTo(var0_59, var0_59.parent).gameObject
end

function var7_0.GetCharacterList(arg0_60)
	return arg0_60._characterList
end

function var7_0.GetPopNumPool(arg0_61)
	return arg0_61._popNumMgr
end

function var7_0.PauseCharacterAction(arg0_62, arg1_62)
	for iter0_62, iter1_62 in pairs(arg0_62._characterList) do
		iter1_62:PauseActionAnimation(arg1_62)
	end
end

function var7_0.GetCharacter(arg0_63, arg1_63)
	return arg0_63._characterList[arg1_63]
end

function var7_0.GetAircraft(arg0_64, arg1_64)
	return arg0_64._aircraftList[arg1_64]
end

function var7_0.AddAirCraftCharacter(arg0_65, arg1_65)
	local var0_65 = arg1_65:GetUnitData()

	arg0_65._aircraftList[var0_65:GetUniqueID()] = arg1_65
end

function var7_0.AddArea(arg0_66, arg1_66, arg2_66)
	local var0_66 = arg0_66._fxPool:GetFX(arg2_66)
	local var1_66 = pg.effect_offset[arg2_66]
	local var2_66 = false

	if var1_66 and var1_66.top_cover_offset == true then
		var2_66 = true
	end

	local var3_66 = var0_0.Battle.BattleEffectArea.New(var0_66, arg1_66, var2_66)

	arg0_66._areaList[arg1_66:GetUniqueID()] = var3_66
end

function var7_0.RemoveArea(arg0_67, arg1_67)
	if arg0_67._areaList[arg1_67] then
		arg0_67._areaList[arg1_67]:Dispose()

		arg0_67._areaList[arg1_67] = nil
	end
end

function var7_0.AddEffect(arg0_68, arg1_68, arg2_68, arg3_68)
	local var0_68 = arg0_68._fxPool:GetFX(arg1_68)

	arg3_68 = arg3_68 or 1
	var0_68.transform.localScale = Vector3(arg3_68, 1, arg3_68)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0_68, arg2_68, true)
end

function var7_0.AddArcEffect(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69)
	local var0_69 = arg0_69._fxPool:GetFX(arg1_69)
	local var1_69 = var0_0.Battle.BattleArcEffect.New(var0_69, arg2_69, arg3_69, arg4_69)

	local function var2_69()
		arg0_69:RemoveArcEffect(var1_69)
	end

	var1_69:ConfigCallback(var2_69)
	table.insert(arg0_69._arcEffectList, var1_69)
end

function var7_0.RemoveArcEffect(arg0_71, arg1_71)
	for iter0_71, iter1_71 in ipairs(arg0_71._arcEffectList) do
		if iter1_71 == arg1_71 then
			iter1_71:Dispose()
			table.remove(arg0_71._arcEffectList, iter0_71)

			break
		end
	end
end

function var7_0.Reinitialize(arg0_72)
	arg0_72:Clear()
	arg0_72:Init()
end

function var7_0.AllBulletNeutralize(arg0_73)
	for iter0_73, iter1_73 in pairs(arg0_73._characterList) do
		if iter1_73.__name == var0_0.Battle.BattlePlayerCharacter.__name or iter1_73.__name == var0_0.Battle.BattleSubCharacter.__name then
			iter1_73:DisableWeaponTrack()
		end
	end

	arg0_73._antiAirArea:SetActive(false)

	local var0_73 = 0

	for iter2_73, iter3_73 in pairs(arg0_73._bulletList) do
		var0_73 = var0_73 + 1

		iter3_73:Neutrailze()
	end

	var0_0.Battle.BattleBulletFactory.NeutralizeBullet()
end

function var7_0.Clear(arg0_74)
	for iter0_74, iter1_74 in pairs(arg0_74._characterList) do
		iter1_74:GetFactory():RemoveCharacter(iter1_74)
	end

	for iter2_74, iter3_74 in pairs(arg0_74._aircraftList) do
		iter3_74:GetFactory():RemoveCharacter(iter3_74)
	end

	arg0_74._characterList = nil
	arg0_74._characterFactoryList = nil

	for iter4_74, iter5_74 in pairs(arg0_74._bulletList) do
		arg0_74:RemoveBullet(iter4_74)
	end

	local var0_74 = var0_0.Battle.BattleBulletFactory.GetFactoryList()

	for iter6_74, iter7_74 in pairs(var0_74) do
		iter7_74:Clear()
	end

	arg0_74._fxPool:Clear()

	for iter8_74, iter9_74 in pairs(arg0_74._areaList) do
		arg0_74:RemoveArea(iter8_74)
	end

	arg0_74._areaList = nil

	for iter10_74, iter11_74 in ipairs(arg0_74._arcEffectList) do
		iter11_74:Dispose()
	end

	arg0_74._arcEffectList = nil

	for iter12_74, iter13_74 in pairs(arg0_74._cardAimTargetList) do
		Object.Destroy(go(iter13_74))
	end

	arg0_74._cardAimTargetList = nil

	var0_0.Battle.BattleCharacterFXContainersPool.GetInstance():Clear()
	arg0_74._popNumMgr:Clear()
	var0_0.Battle.BattleHPBarManager.GetInstance():Clear()
	var0_0.Battle.BattleArrowManager.GetInstance():Clear()

	arg0_74._anitSubAreaTFList = nil

	pg.CameraFixMgr.GetInstance():SetMaskAsTopLayer(false)
end

function var7_0.Dispose(arg0_75)
	arg0_75:Clear()
	arg0_75:RemoveEvent()
	var7_0.super.Dispose(arg0_75)
end
