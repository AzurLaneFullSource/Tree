ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleCardPuzzleEvent
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleConfig
local var5 = var0.Battle.BattleVariable
local var6 = var0.Battle.BattleTargetChoise
local var7 = class("BattleSceneMediator", var0.MVC.Mediator)

var0.Battle.BattleSceneMediator = var7
var7.__name = "BattleSceneMediator"

local var8 = Vector3(0, 0.8, 0)

function var7.Ctor(arg0)
	var7.super.Ctor(arg0)

	arg0.FlagShipUIPos = Vector3.zero
end

function var7.Initialize(arg0)
	var7.super.Initialize(arg0)

	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)

	arg0:InitCharacterFactory()
	arg0:Init()
	arg0:AddEvent()
end

function var7.Init(arg0)
	arg0._characterList = {}
	arg0._bulletList = {}
	arg0._particleBulletList = {}
	arg0._aircraftList = {}
	arg0._areaList = {}
	arg0._shelterList = {}
	arg0._arcEffectList = {}
	arg0._bulletContainer = GameObject.Find("BulletContainer")
	arg0._fxPool = var0.Battle.BattleFXPool.GetInstance()
	arg0._aimBiasTFList = {}

	var0.Battle.BattleCharacterFXContainersPool.GetInstance():Init()
	arg0:InitPlayerAntiAirArea()
	arg0:InitPlayerAntiSubArea()
	arg0:InitFlagShipMark()
	arg0:InitSkillAim()
	pg.CameraFixMgr.GetInstance():Adapt()
	pg.CameraFixMgr.GetInstance():SetMaskAsTopLayer(true)
end

function var7.InitCamera(arg0)
	arg0._cameraUtil = var0.Battle.BattleCameraUtil.GetInstance()

	arg0._cameraUtil:RegisterEventListener(arg0, var1.CAMERA_FOCUS_RESET, arg0.onCameraFocusReset)
	arg0._cameraUtil:RegisterEventListener(arg0, var1.BULLET_TIME, arg0.onBulletTime)
end

function var7.InitPopNumPool(arg0)
	local var0 = var0.Battle.BattlePopNumManager

	arg0._popNumMgr = var0.GetInstance()

	local var1 = arg0._state:GetUI()

	if arg0._dataProxy:GetInitData().battleType == SYSTEM_DODGEM then
		arg0._popNumMgr:InitialScorePool(var1:findTF(var0.CONTAINER_CHARACTER_HP .. "/container"))
	else
		arg0._popNumMgr:InitialBundlePool(var1:findTF(var0.CONTAINER_CHARACTER_HP .. "/container"))
	end
end

function var7.InitFlagShipMark(arg0)
	local var0 = arg0._state:GetUI():findGO("flagShipMark")

	var0:SetActive(true)

	arg0._goFlagShipMarkTf = var0.transform
end

function var7.InitSkillAim(arg0)
	arg0._cardAimTargetFilter = {}
	arg0._cardAimTargetList = {}
end

function var7.InitCharacterFactory(arg0)
	local var0 = arg0._state:GetUI()

	var0.Battle.BattleHPBarManager.GetInstance():InitialPoolRoot(var0:findTF(var0.Battle.BattleHPBarManager.ROOT_NAME))
	var0.Battle.BattleArrowManager.GetInstance():Init(var0:findTF(var0.Battle.BattleArrowManager.ROOT_NAME))

	arg0._characterFactoryList = {
		[var3.UnitType.PLAYER_UNIT] = var0.Battle.BattlePlayerCharacterFactory.GetInstance(),
		[var3.UnitType.ENEMY_UNIT] = var0.Battle.BattleEnemyCharacterFactory.GetInstance(),
		[var3.UnitType.MINION_UNIT] = var0.Battle.BattleMinionCharacterFactory.GetInstance(),
		[var3.UnitType.BOSS_UNIT] = var0.Battle.BattleBossCharacterFactory.GetInstance(),
		[var3.UnitType.AIRCRAFT_UNIT] = var0.Battle.BattleAircraftCharacterFactory.GetInstance(),
		[var3.UnitType.AIRFIGHTER_UNIT] = var0.Battle.BattleAirFighterCharacterFactory.GetInstance(),
		[var3.UnitType.SUB_UNIT] = var0.Battle.BattleSubCharacterFactory.GetInstance()
	}
end

function var7.InitPlayerAntiAirArea(arg0)
	arg0._antiAirArea = arg0._fxPool:GetFX("AntiAirArea")
	arg0._antiAirAreaTF = arg0._antiAirArea.transform

	arg0._antiAirArea:SetActive(false)
end

function var7.InitPlayerAntiSubArea(arg0)
	arg0._anitSubArea = arg0._fxPool:GetFX("AntiSubArea")
	arg0._anitSubAreaTF = arg0._anitSubArea.transform

	arg0._anitSubArea:SetActive(false)

	arg0._antiSubScanAnima = arg0._anitSubAreaTF:Find("Quad"):GetComponent(typeof(Animator))
	arg0._anitSubAreaTFList = {}
	arg0._anitSubAreaTFList[arg0._anitSubAreaTF] = true
end

function var7.InitDetailAntiSubArea(arg0)
	local var0, var1, var2, var3 = arg0._leftFleet:GetFleetSonar():GetTotalRangeDetail()

	local function var4(arg0, arg1, arg2)
		local var0 = arg0._fxPool:GetFX("AntiSubArea")

		var0.name = arg2

		local var1 = var0.transform

		var1.localScale = Vector3(arg0, 0, arg0)
		var1:Find("static"):GetComponent("SpriteRenderer").color = arg1

		var0:SetActive(true)

		arg0._anitSubAreaTFList[var1] = true
	end

	var4(var0 + var1 + var2 + var3, Color.New(1, 1, 1, 1), "技能额外直径：" .. var3)
	var4(var0 + var1 + var2, Color.New(0.07, 1, 0, 1), "装备提供直径：" .. var2)
	var4(var0 + var1, Color.New(1, 0.32, 0, 1), "主力提供直径：" .. var1)
	var4(var0, Color.New(1, 0, 0, 1), "基础直径：" .. var0)
end

function var7.AddEvent(arg0)
	arg0._dataProxy:RegisterEventListener(arg0, var1.STAGE_DATA_INIT_FINISH, arg0.onStageInitFinish)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_UNIT, arg0.onAddUnit)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_UNIT, arg0.onRemoveUnit)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_BULLET, arg0.onRemoveBullet)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_AIR_CRAFT, arg0.onRemoveAircraft)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_AIR_FIGHTER, arg0.onRemoveAirFighter)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_AREA, arg0.onAddArea)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_AREA, arg0.onRemoveArea)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_EFFECT, arg0.onAddEffect)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_SHELTER, arg0.onAddShelter)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_SHELTER, arg0.onRemoveShleter)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ANTI_AIR_AREA, arg0.onAntiAirArea)
	arg0._dataProxy:RegisterEventListener(arg0, var1.UPDATE_HOSTILE_SUBMARINE, arg0.onUpdateHostileSubmarine)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_CAMERA_FX, arg0.onAddCameraFX)
	arg0._dataProxy:RegisterEventListener(arg0, var1.ADD_AIM_BIAS, arg0.onAddAimBias)
	arg0._dataProxy:RegisterEventListener(arg0, var1.REMOVE_AIM_BIAS, arg0.onRemoveAimBias)

	arg0._camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function()
		arg0._dataProxy:OnCameraRatioUpdate()
	end)
end

function var7.RemoveEvent(arg0)
	arg0._leftFleet:UnregisterEventListener(arg0, var1.SONAR_SCAN)
	arg0._leftFleet:UnregisterEventListener(arg0, var1.SONAR_UPDATE)
	arg0._leftFleet:UnregisterEventListener(arg0, var1.ADD_AIM_BIAS)
	arg0._leftFleet:UnregisterEventListener(arg0, var1.REMOVE_AIM_BIAS)
	arg0._leftFleet:UnregisterEventListener(arg0, var2.FLEET_MOVE_TO)
	arg0._leftFleet:UnregisterEventListener(arg0, var2.UPDATE_CARD_TARGET_FILTER)
	arg0._leftFleet:UnregisterEventListener(arg0, var1.ON_BOARD_CLICK)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.STAGE_DATA_INIT_FINISH)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_UNIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_UNIT)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_BULLET)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_AIR_CRAFT)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_AIR_FIGHTER)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_AREA)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_AREA)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_EFFECT)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_SHELTER)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_SHELTER)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ANTI_AIR_AREA)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.UPDATE_HOSTILE_SUBMARINE)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_CAMERA_FX)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.ADD_AIM_BIAS)
	arg0._dataProxy:UnregisterEventListener(arg0, var1.REMOVE_AIM_BIAS)
	arg0._cameraUtil:UnregisterEventListener(arg0, var1.CAMERA_FOCUS_RESET)
	arg0._cameraUtil:UnregisterEventListener(arg0, var1.BULLET_TIME)
	pg.CameraFixMgr.GetInstance():disconnect(arg0._camEventId)
end

function var7.onStageInitFinish(arg0, arg1)
	arg0._leftFleet = arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE)
	arg0._leftFleetMotion = arg0._leftFleet:GetMotion()

	arg0:InitCamera()
	arg0._leftFleet:RegisterEventListener(arg0, var1.SONAR_SCAN, arg0.onSonarScan)
	arg0._leftFleet:RegisterEventListener(arg0, var1.SONAR_UPDATE, arg0.onUpdateHostileSubmarine)
	arg0._leftFleet:RegisterEventListener(arg0, var1.ADD_AIM_BIAS, arg0.onAddAimBias)
	arg0._leftFleet:RegisterEventListener(arg0, var1.REMOVE_AIM_BIAS, arg0.onRemoveAimBias)
	arg0._leftFleet:RegisterEventListener(arg0, var2.FLEET_MOVE_TO, arg0.onUpdateMoveMark)
	arg0._leftFleet:RegisterEventListener(arg0, var2.ON_BOARD_CLICK, arg0.onBoardClick)
	arg0._leftFleet:RegisterEventListener(arg0, var2.UPDATE_CARD_TARGET_FILTER, arg0.onUpdateSkillAim)
	arg0:InitPopNumPool()
end

function var7.onAddUnit(arg0, arg1)
	local var0 = arg1.Data.type
	local var1 = arg0._characterFactoryList[var0]
	local var2 = arg1.Data

	var1:CreateCharacter(var2)
end

function var7.onRemoveUnit(arg0, arg1)
	local var0 = arg1.Data.UID
	local var1 = arg1.Data.deadReason
	local var2 = arg0._characterList[var0]

	if var2 then
		var2:GetFactory():RemoveCharacter(var2, var1)

		arg0._characterList[var0] = nil
	end
end

function var7.onRemoveAircraft(arg0, arg1)
	local var0 = arg1.Data.UID
	local var1 = arg0._aircraftList[var0]

	if var1 then
		var1:GetFactory():RemoveCharacter(var1)

		arg0._aircraftList[var0] = nil
	end
end

function var7.onRemoveAirFighter(arg0, arg1)
	local var0 = arg1.Data.UID
	local var1 = arg0._aircraftList[var0]

	if var1 then
		var1:GetFactory():RemoveCharacter(var1)

		arg0._aircraftList[var0] = nil
	end
end

function var7.onRemoveBullet(arg0, arg1)
	local var0 = arg1.Data.UID

	arg0:RemoveBullet(var0)
end

function var7.onAddArea(arg0, arg1)
	local var0 = arg1.Data.FXID
	local var1 = arg1.Data.area

	arg0:AddArea(var1, var0)
end

function var7.onRemoveArea(arg0, arg1)
	local var0 = arg1.Data.id

	arg0:RemoveArea(var0)
end

function var7.onAddEffect(arg0, arg1)
	local var0 = arg1.Data.FXID
	local var1 = arg1.Data.position
	local var2 = arg1.Data.localScale

	arg0:AddEffect(var0, var1, var2)
end

function var7.onAddShelter(arg0, arg1)
	local var0 = arg1.Data.shelter
	local var1, var2 = arg0._fxPool:GetFX(var0:GetFXID())
	local var3 = var0:GetPosition()

	pg.EffectMgr.GetInstance():PlayBattleEffect(var1, var3:Add(var2), true)

	if var0:GetIFF() == var4.FOE_CODE then
		local var4 = var1.transform
		local var5 = var4.localEulerAngles

		var5.y = 180
		var4.localEulerAngles = var5
	end

	arg0._shelterList[var0:GetUniqueID()] = var1
end

function var7.onRemoveShleter(arg0, arg1)
	local var0 = arg1.Data.uid
	local var1 = arg0._shelterList[var0]

	if var1 then
		var0.Battle.BattleResourceManager.GetInstance():DestroyOb(var1)

		arg0._shelterList[var0] = nil
	end
end

function var7.onAntiAirArea(arg0, arg1)
	local var0 = arg1.Data.isShow

	if var0 ~= nil then
		arg0._antiAirArea.gameObject:SetActive(arg1.Data.isShow)

		if var0 == true then
			local var1 = arg0._leftFleet:GetFleetAntiAirWeapon():GetRange() * 2

			arg0._antiAirAreaTF.localScale = Vector3(var1, 0, var1)
		end
	end
end

function var7.onAntiAirOverload(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = arg0._antiAirAreaTF:Find("Quad"):GetComponent(typeof(Animator))

	if var0:IsOverLoad() then
		var1.enabled = false
	else
		var1.enabled = true
	end
end

function var7.onUpdateHostileSubmarine(arg0, arg1)
	arg0:updateSonarView()
end

function var7.updateSonarView(arg0)
	local var0 = arg0._dataProxy:GetEnemySubmarineCount() > 0

	arg0._sonarActive = var0

	for iter0, iter1 in pairs(arg0._characterList) do
		iter1:SonarAcitve(var0)
	end

	local var1 = arg0._leftFleet:GetFleetSonar():GetCurrentState() ~= var0.Battle.BattleFleetStaticSonar.STATE_DISABLE and var0

	arg0._anitSubArea.gameObject:SetActive(var1)

	if var1 then
		local var2 = arg0._leftFleet:GetFleetSonar():GetRange()

		arg0._anitSubAreaTF.localScale = Vector3(var2, 0, var2)
	end
end

function var7.onSonarScan(arg0, arg1)
	if arg1.Data.indieSonar then
		local var0 = arg0._fxPool:GetFX("AntiSubArea").transform

		var0.localScale = Vector3(100, 0, 100)

		SetActive(var0:Find("static"), false)

		local var1 = var0:Find("Quad")
		local var2 = var1:GetComponent(typeof(Animator))

		var2.enabled = true

		var2:Play("antiSubZoom", -1, 0)

		arg0._anitSubAreaTFList[var0] = true

		var1:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			arg0._anitSubAreaTFList[var0] = nil
		end)
	elseif arg0._antiSubScanAnima and arg0._sonarActive then
		arg0._antiSubScanAnima.enabled = true

		arg0._antiSubScanAnima:Play("antiSubZoom", -1, 0)
	end
end

function var7.onAddAimBias(arg0, arg1)
	local var0 = arg1.Data.aimBias
	local var1 = arg0._fxPool:GetFX("AimBiasArea").transform

	arg0._aimBiasTFList[var0] = {
		tf = var1,
		vector = Vector3(5, 0, 5)
	}
end

function var7.onRemoveAimBias(arg0, arg1)
	local var0 = arg1.Data.aimBias
	local var1 = arg0._aimBiasTFList[var0]

	if var1 then
		local var2 = var1.tf.gameObject

		var0.Battle.BattleResourceManager.GetInstance():DestroyOb(var2)

		arg0._aimBiasTFList[var0] = nil
	end
end

function var7.onUpdateMoveMark(arg0, arg1)
	local var0 = arg1.Data.pos

	if not arg0._moveMarkFXTF then
		arg0._moveMarkFX = arg0._fxPool:GetFX("kapai_weizhi")
		arg0._moveMarkFXTF = arg0._moveMarkFX.transform
	end

	if var0 then
		setActive(arg0._moveMarkFXTF, true)

		arg0._moveMarkFXTF.position = var0
	else
		setActive(arg0._moveMarkFXTF, false)
	end
end

function var7.onBoardClick(arg0, arg1)
	local var0 = arg1.Data.click
	local var1 = arg0._leftFleet:GetCardPuzzleComponent():GetTouchScreenPoint()

	if var0 == var0.Battle.CardPuzzleBoardClicker.CLICK_STATE_CLICK then
		arg0._clickMarkFxTF = arg0._fxPool:GetFX("kapai_weizhi").transform
		arg0._clickMarkFxTF.position = var1
	elseif var0 == var0.Battle.CardPuzzleBoardClicker.CLICK_STATE_DRAG then
		arg0._clickMarkFxTF.position = var1
	elseif var0 == var0.Battle.CardPuzzleBoardClicker.CLICK_STATE_RELEASE and arg0._clickMarkFxTF then
		var0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0._clickMarkFxTF.gameObject)
	end
end

function var7.onCameraFocusReset(arg0, arg1)
	arg0:ResetFocus()
end

function var7.onAddCameraFX(arg0, arg1)
	local var0 = arg1.Data.FXID
	local var1 = arg1.Data.position
	local var2 = arg1.Data.localScale
	local var3 = arg1.Data.orderDiff

	arg0:AddCameraFX(var3, var0, var1, var2)
end

function var7.AddCameraFX(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0._fxPool:GetFX(arg2)
	local var1 = arg0._cameraUtil:Add2Camera(var0, arg1)

	arg4 = arg4 or 1
	var0.transform.localScale = Vector3(arg4 / var1.x, arg4 / var1.y, arg4 / var1.z)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0, arg3, true)
end

function var7.onUpdateSkillAim(arg0, arg1)
	arg0._cardAimTargetFilter = arg1.Data.targetFilterList
end

function var7.Update(arg0)
	for iter0, iter1 in pairs(arg0._characterList) do
		iter1:Update()
	end

	for iter2, iter3 in pairs(arg0._aircraftList) do
		iter3:Update()
	end

	for iter4, iter5 in pairs(arg0._bulletList) do
		iter5:Update()
	end

	for iter6, iter7 in pairs(arg0._areaList) do
		iter7:Update()
	end

	for iter8, iter9 in ipairs(arg0._arcEffectList) do
		iter9:Update()
	end

	arg0:updateCardAim()
	arg0:UpdateAntiAirArea()
	arg0:UpdateAimBiasArea()
	arg0:UpdateFlagShipMark()
end

function var7.UpdatePause(arg0)
	for iter0, iter1 in pairs(arg0._characterList) do
		iter1:UpdateUIComponentPosition()
		iter1:UpdateHPBarPosition()
	end

	for iter2, iter3 in pairs(arg0._aircraftList) do
		iter3:UpdateUIComponentPosition()

		if iter3:GetUnitData():GetUniqueID() == var4.FOE_CODE then
			iter3:UpdateHPBarPosition()
		end
	end

	arg0:UpdateFlagShipMark()
end

function var7.UpdateEscapeOnly(arg0, arg1)
	for iter0, iter1 in pairs(arg0._characterList) do
		if iter1.__name == var0.Battle.BattleEnemyCharacter.__name or iter1.__name == var0.Battle.BattleBossCharacter.__name then
			iter1:Update(arg1)
		end
	end
end

function var7.Pause(arg0)
	arg0:PauseCharacterAction(true)

	for iter0, iter1 in pairs(arg0._areaList) do
		local var0 = iter1._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter2 = 0, var0.Length - 1 do
			var0[iter2]:Pause()
		end
	end

	arg0._cameraUtil:PauseShake()

	for iter3, iter4 in ipairs(arg0._arcEffectList) do
		local var1 = iter4._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter5 = 0, var1.Length - 1 do
			var1[iter5]:Pause()
		end
	end

	for iter6, iter7 in pairs(arg0._particleBulletList) do
		local var2 = iter6._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter8 = 0, var2.Length - 1 do
			var2[iter8]:Pause()
		end
	end
end

function var7.Resume(arg0)
	arg0:PauseCharacterAction(false)

	for iter0, iter1 in pairs(arg0._areaList) do
		local var0 = iter1._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter2 = 0, var0.Length - 1 do
			var0[iter2]:Play()
		end
	end

	arg0._cameraUtil:ResumeShake()

	for iter3, iter4 in ipairs(arg0._arcEffectList) do
		local var1 = iter4._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter5 = 0, var1.Length - 1 do
			var1[iter5]:Play()
		end
	end

	for iter6, iter7 in pairs(arg0._particleBulletList) do
		local var2 = iter6._go:GetComponentsInChildren(typeof(ParticleSystem))

		for iter8 = 0, var2.Length - 1 do
			var2[iter8]:Play()
		end
	end
end

function var7.onBulletTime(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.key
	local var2 = var0.speed

	if var2 then
		local var3 = var0.exemptUnit:GetUniqueID()

		var5.AppendIFFFactor(var4.FOE_CODE, var1, var2)
		var5.AppendIFFFactor(var4.FRIENDLY_CODE, var1, var2)

		for iter0, iter1 in pairs(arg0._characterList) do
			if iter0 == var3 then
				iter1:SetAnimaSpeed(1 / var2)

				break
			end
		end
	else
		var5.RemoveIFFFactor(var4.FOE_CODE, var1)
		var5.RemoveIFFFactor(var4.FRIENDLY_CODE, var1)

		for iter2, iter3 in pairs(arg0._characterList) do
			iter3:SetAnimaSpeed(1)
		end

		for iter4, iter5 in pairs(arg0._bulletList) do
			iter5:SetAnimaSpeed(1)
		end
	end
end

function var7.ResetFocus(arg0)
	var5.RemoveIFFFactor(var4.FOE_CODE, var4.SPEED_FACTOR_FOCUS_CHARACTER)
	var5.RemoveIFFFactor(var4.FRIENDLY_CODE, var4.SPEED_FACTOR_FOCUS_CHARACTER)

	for iter0, iter1 in pairs(arg0._characterList) do
		iter1:SetAnimaSpeed(1)
	end

	for iter2, iter3 in pairs(arg0._bulletList) do
		iter3:SetAnimaSpeed(1)
	end

	arg0._cameraUtil:ZoomCamara(nil, nil, var4.CAM_RESET_DURATION)
end

function var7.UpdateFlagShipMark(arg0)
	local var0 = arg0.FlagShipUIPos:Copy(arg0._leftFleetMotion:GetPos())

	arg0._goFlagShipMarkTf.position = var5.CameraPosToUICamera(var0):Add(var8)
end

function var7.UpdateAntiAirArea(arg0)
	arg0._antiAirAreaTF.position = arg0._leftFleetMotion:GetPos()

	for iter0, iter1 in pairs(arg0._anitSubAreaTFList) do
		iter0.position = arg0._leftFleetMotion:GetPos()
	end
end

function var7.UpdateAimBiasArea(arg0)
	for iter0, iter1 in pairs(arg0._aimBiasTFList) do
		local var0 = iter1.tf
		local var1 = iter1.vector
		local var2 = iter1.cacheState
		local var3 = iter0:GetRange() * 2

		var1:Set(var3, 0, var3)

		var0.position = iter0:GetPosition()
		var0.localScale = var1

		local var4 = iter0:GetCurrentState()

		if var4 ~= var2 then
			setActive(var0:Find("suofang/Quad"), var4 ~= iter0.STATE_SKILL_EXPOSE)
		end

		iter1.cacheState = var4
	end
end

function var7.updateCardAim(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0._cardAimTargetFilter) do
		local var1 = var6.TargetFleetIndex(nil, {
			fleetPos = iter0
		})[1]

		for iter2, iter3 in ipairs(iter1) do
			local var2

			for iter4, iter5 in ipairs(iter3) do
				var2 = var6[iter5](var1, nil, var2)
			end

			for iter6, iter7 in ipairs(var2) do
				var0[iter7:GetUniqueID()] = true
			end
		end
	end

	for iter8, iter9 in pairs(arg0._cardAimTargetList) do
		if not var0[iter8] then
			Object.Destroy(go(iter9))

			arg0._cardAimTargetList[iter8] = nil
		end
	end

	for iter10, iter11 in pairs(var0) do
		local var3 = arg0._cardAimTargetList[iter10] or arg0:InstantiateCharacterComponent("SkillAimContainer/SkillAim").transform

		arg0._cardAimTargetList[iter10] = var3

		local var4 = arg0._characterList[iter10]

		if var4 then
			var3.position = var4:GetReferenceVector(var4.AIM_OFFSET)
		end
	end
end

function var7.AddBullet(arg0, arg1)
	local var0 = arg1:GetBulletData()

	arg0._bulletList[var0:GetUniqueID()] = arg1

	local var1 = arg1:GetGO()

	if var1 and var1:GetComponent(typeof(ParticleSystem)) then
		arg0._particleBulletList[arg1] = true
	end

	if var5.focusExemptList[var0:GetSpeedExemptKey()] then
		local var2 = arg0._state:GetTimeScaleRate()

		arg1:SetAnimaSpeed(1 / var2)
	end
end

function var7.RemoveBullet(arg0, arg1)
	local var0 = arg0._bulletList[arg1]

	if var0 then
		arg0._particleBulletList[var0] = nil

		var0:GetFactory():RemoveBullet(var0)
	end

	arg0._bulletList[arg1] = nil
end

function var7.GetBulletRoot(arg0)
	return arg0._bulletContainer
end

function var7.EnablePopContainer(arg0, arg1, arg2)
	setActive(arg0._state:GetUI():findTF(arg1), arg2)
end

function var7.AddPlayerCharacter(arg0, arg1)
	arg0:AppendCharacter(arg1)

	local var0 = arg0._dataProxy:GetInitData().battleType
	local var1 = arg1:GetUnitData():IsMainFleetUnit()

	if var0 == SYSTEM_DUEL then
		-- block empty
	elseif var0 == SYSTEM_SUBMARINE_RUN or var0 == SYSTEM_SUB_ROUTINE then
		arg1:SetBarHidden(false, false)
	else
		arg1:SetBarHidden(not var1, var1)
	end
end

function var7.AddEnemyCharacter(arg0, arg1)
	arg0:AppendCharacter(arg1)
end

function var7.AppendCharacter(arg0, arg1)
	local var0 = arg1:GetUnitData()

	arg0._characterList[var0:GetUniqueID()] = arg1
end

function var7.InstantiateCharacterComponent(arg0, arg1)
	local var0 = arg0._state:GetUI():findTF(arg1)

	return cloneTplTo(var0, var0.parent).gameObject
end

function var7.GetCharacterList(arg0)
	return arg0._characterList
end

function var7.GetPopNumPool(arg0)
	return arg0._popNumMgr
end

function var7.PauseCharacterAction(arg0, arg1)
	for iter0, iter1 in pairs(arg0._characterList) do
		iter1:PauseActionAnimation(arg1)
	end
end

function var7.GetCharacter(arg0, arg1)
	return arg0._characterList[arg1]
end

function var7.GetAircraft(arg0, arg1)
	return arg0._aircraftList[arg1]
end

function var7.AddAirCraftCharacter(arg0, arg1)
	local var0 = arg1:GetUnitData()

	arg0._aircraftList[var0:GetUniqueID()] = arg1
end

function var7.AddArea(arg0, arg1, arg2)
	local var0 = arg0._fxPool:GetFX(arg2)
	local var1 = pg.effect_offset[arg2]
	local var2 = false

	if var1 and var1.top_cover_offset == true then
		var2 = true
	end

	local var3 = var0.Battle.BattleEffectArea.New(var0, arg1, var2)

	arg0._areaList[arg1:GetUniqueID()] = var3
end

function var7.RemoveArea(arg0, arg1)
	if arg0._areaList[arg1] then
		arg0._areaList[arg1]:Dispose()

		arg0._areaList[arg1] = nil
	end
end

function var7.AddEffect(arg0, arg1, arg2, arg3)
	local var0 = arg0._fxPool:GetFX(arg1)

	arg3 = arg3 or 1
	var0.transform.localScale = Vector3(arg3, 1, arg3)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0, arg2, true)
end

function var7.AddArcEffect(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0._fxPool:GetFX(arg1)
	local var1 = var0.Battle.BattleArcEffect.New(var0, arg2, arg3, arg4)

	local function var2()
		arg0:RemoveArcEffect(var1)
	end

	var1:ConfigCallback(var2)
	table.insert(arg0._arcEffectList, var1)
end

function var7.RemoveArcEffect(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._arcEffectList) do
		if iter1 == arg1 then
			iter1:Dispose()
			table.remove(arg0._arcEffectList, iter0)

			break
		end
	end
end

function var7.Reinitialize(arg0)
	arg0:Clear()
	arg0:Init()
end

function var7.AllBulletNeutralize(arg0)
	for iter0, iter1 in pairs(arg0._characterList) do
		if iter1.__name == var0.Battle.BattlePlayerCharacter.__name or iter1.__name == var0.Battle.BattleSubCharacter.__name then
			iter1:DisableWeaponTrack()
		end
	end

	arg0._antiAirArea:SetActive(false)

	local var0 = 0

	for iter2, iter3 in pairs(arg0._bulletList) do
		var0 = var0 + 1

		iter3:Neutrailze()
	end

	var0.Battle.BattleBulletFactory.NeutralizeBullet()
end

function var7.Clear(arg0)
	for iter0, iter1 in pairs(arg0._characterList) do
		iter1:GetFactory():RemoveCharacter(iter1)
	end

	for iter2, iter3 in pairs(arg0._aircraftList) do
		iter3:GetFactory():RemoveCharacter(iter3)
	end

	arg0._characterList = nil
	arg0._characterFactoryList = nil

	for iter4, iter5 in pairs(arg0._bulletList) do
		arg0:RemoveBullet(iter4)
	end

	local var0 = var0.Battle.BattleBulletFactory.GetFactoryList()

	for iter6, iter7 in pairs(var0) do
		iter7:Clear()
	end

	arg0._fxPool:Clear()

	for iter8, iter9 in pairs(arg0._areaList) do
		arg0:RemoveArea(iter8)
	end

	arg0._areaList = nil

	for iter10, iter11 in ipairs(arg0._arcEffectList) do
		iter11:Dispose()
	end

	arg0._arcEffectList = nil

	for iter12, iter13 in pairs(arg0._cardAimTargetList) do
		Object.Destroy(go(iter13))
	end

	arg0._cardAimTargetList = nil

	var0.Battle.BattleCharacterFXContainersPool.GetInstance():Clear()
	arg0._popNumMgr:Clear()
	var0.Battle.BattleHPBarManager.GetInstance():Clear()
	var0.Battle.BattleArrowManager.GetInstance():Clear()

	arg0._anitSubAreaTFList = nil

	pg.CameraFixMgr.GetInstance():SetMaskAsTopLayer(false)
end

function var7.Dispose(arg0)
	arg0:Clear()
	arg0:RemoveEvent()
	var7.super.Dispose(arg0)
end
