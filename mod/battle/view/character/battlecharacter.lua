ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleConfig
local var4 = var0.Battle.BattleResourceManager
local var5 = var0.Battle.BattleFormulas
local var6 = class("BattleCharacter", var0.Battle.BattleSceneObject)

var0.Battle.BattleCharacter = var6
var6.__name = "BattleCharacter"

local var7 = Vector2(-1200, -1200)
local var8 = Vector3.New(0.3, -1.8, 0)

var6.AIM_OFFSET = Vector3.New(0, -3.5, 0)

function var6.Ctor(arg0)
	var6.super.Ctor(arg0)
	arg0:Init()
end

function var6.Init(arg0)
	var0.EventListener.AttachEventListener(arg0)
	arg0:InitBulletFactory()
	arg0:InitEffectView()

	arg0._tagFXList = {}
	arg0._cacheFXList = {}
	arg0._allFX = {}
	arg0._bulletCache = {}
	arg0._weaponRegisterList = {}
	arg0._characterPos = Vector3.zero
	arg0._orbitList = {}
	arg0._orbitActionCacheList = {}
	arg0._orbitSpeedUpdateList = {}
	arg0._orbitActionUpdateList = {}
	arg0._inViewArea = false
	arg0._alwaysHideArrow = false
	arg0._hideHP = false
	arg0._referenceVector = Vector3.zero
	arg0._referenceVectorCache = Vector3.zero
	arg0._referenceVectorTemp = Vector3.zero
	arg0._referenceUpdateFlag = false
	arg0._referenceVectorBorn = nil
	arg0._hpBarPos = Vector3.zero
	arg0._arrowVector = Vector3.zero
	arg0._arrowAngleVector = Vector3.zero
	arg0._blinkDict = {}
	arg0._coverSpineHPBarOffset = 0
	arg0._shaderType = nil
	arg0._color = nil
	arg0._actionIndex = nil
end

function var6.InitBulletFactory(arg0)
	arg0._bulletFactoryList = var0.Battle.BattleBulletFactory.GetFactoryList()
end

function var6.SetUnitData(arg0, arg1)
	arg0._unitData = arg1

	arg0:AddUnitEvent()
end

function var6.SetBoneList(arg0)
	arg0._boneList = {}
	arg0._remoteBoneTable = {}
	arg0._bonePosTable = nil
	arg0._posMatrix = nil

	local var0 = arg0:GetInitScale()

	for iter0, iter1 in pairs(arg0._unitData:GetTemplate().bound_bone) do
		if iter0 ~= "remote" then
			arg0:insertBondList(iter0, iter1)
		end
	end

	for iter2, iter3 in pairs(var3.CommonBone) do
		arg0:insertBondList(iter2, iter3)
	end
end

function var6.insertBondList(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		if type(iter1) == "table" then
			local var0 = {}

			var0[#var0 + 1] = Vector3(iter1[1], iter1[2], iter1[3])
			arg0._boneList[arg1] = var0
		end
	end
end

function var6.SpawnBullet(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0._bulletFactoryList[arg1:GetTemplate().type]
	local var1 = arg0._unitData:GetRemoteBoundBone(arg2)
	local var2 = arg4 or var1 or arg0:GetBonePos(arg2)

	var0:CreateBullet(arg0._tf, arg1, var2, arg3, arg0._unitData:GetDirection())
end

function var6.GetBonePos(arg0, arg1)
	local var0 = arg0._boneList[arg1]

	if var0 == nil or #var0 == 0 then
		for iter0, iter1 in pairs(arg0._boneList) do
			var0 = iter1

			break
		end
	end

	local var1

	if not arg0._posMatrix then
		var1 = arg0._tf.localToWorldMatrix
		arg0._posMatrix = var1
		arg0._bonePosTable = {}
	else
		var1 = arg0._posMatrix
	end

	local var2 = arg0._bonePosTable[arg1]

	if var2 == nil then
		var2 = {}

		for iter2, iter3 in ipairs(var0) do
			var2[#var2 + 1] = var1:MultiplyPoint3x4(iter3)
		end

		arg0._bonePosTable[arg1] = var2
	end

	if #var2 == 1 then
		return var2[1]
	else
		return var2[math.floor(math.Random(0, #var2)) + 1]
	end
end

function var6.GetBoneList(arg0)
	return arg0._boneList
end

function var6.AddFXOffsets(arg0, arg1, arg2)
	arg0._FXAttachPoint = arg1
	arg0._FXOffset = arg2
end

function var6.GetFXOffsets(arg0, arg1)
	arg1 = arg1 or 1

	return arg0._FXOffset[arg1]
end

function var6.GetAttachPoint(arg0)
	return arg0._FXAttachPoint
end

function var6.GetSpecificFXScale(arg0)
	return {}
end

function var6.PlayFX(arg0, arg1)
	local var0 = arg0:GetFactory():GetFXPool():GetFX(arg1)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0, arg0:GetPosition(), true)
end

function var6.AddFX(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:GetFactory():GetFXPool():GetCharacterFX(arg1, arg0, not arg2, function(arg0)
		if arg4 then
			arg4()
		end

		arg0._allFX[arg0] = nil
	end, arg3)

	if arg2 then
		local var1 = arg0._cacheFXList[arg1] or {}

		table.insert(var1, var0)

		arg0._cacheFXList[arg1] = var1
	end

	arg0._allFX[var0] = true

	return var0
end

function var6.RemoveFX(arg0, arg1)
	if arg0._allFX and arg0._allFX[arg1] then
		arg0._allFX[arg1] = nil

		var4.GetInstance():DestroyOb(arg1)
	end
end

function var6.RemoveCacheFX(arg0, arg1)
	local var0 = arg0._cacheFXList[arg1]

	if var0 ~= nil and #var0 > 0 then
		local var1 = table.remove(var0)

		arg0._allFX[var1] = nil

		var4.GetInstance():DestroyOb(var1)
	end
end

function var6.AddWaveFX(arg0, arg1)
	arg0._waveFX = arg0:AddFX(arg1)
end

function var6.RemoveWaveFX(arg0)
	if not arg0._waveFX then
		return
	end

	arg0:RemoveFX(arg0._waveFX)
end

function var6.onAddBuffClock(arg0, arg1)
	local var0 = arg1.Data

	if var0.isActive then
		if not arg0._buffClock then
			arg0._factory:MakeBuffClock(arg0)
		end

		arg0._buffClock:Casting(var0)
	else
		arg0._buffClock:Interrupt(var0)
	end
end

function var6.AddBlink(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	if arg0._unitData:GetDiveInvisible() then
		return nil
	end

	if not arg0._unitData:GetExposed() then
		return nil
	end

	arg4 = arg4 or 0.1
	arg5 = arg5 or 0.1
	arg6 = arg6 or false
	arg7 = arg7 or 0.18

	local var0 = SpineAnim.CharBlink(arg0._go, arg1, arg2, arg3, arg7, arg4, arg5, arg6)

	if not arg6 then
		arg0._blinkDict[var0] = {
			r = arg1,
			g = arg2,
			b = arg3,
			a = arg7,
			peroid = arg4,
			duration = arg5
		}
	end

	return var0
end

function var6.RemoveBlink(arg0, arg1)
	arg0._blinkDict[arg1] = nil

	SpineAnim.RemoveBlink(arg0._go, arg1)
end

function var6.AddShaderColor(arg0, arg1)
	if not arg0._unitData:GetExposed() then
		return
	end

	arg1 = arg1 or Color.New(0, 0, 0, 0)

	SpineAnim.AddShaderColor(arg0._go, arg1)
end

function var6.GetPosition(arg0)
	return arg0._characterPos
end

function var6.GetUnitData(arg0)
	return arg0._unitData
end

function var6.GetDestroyFXID(arg0)
	return arg0:GetUnitData():GetTemplate().bomb_fx
end

function var6.GetOffsetPos(arg0)
	return (BuildVector3(arg0._unitData:GetTemplate().position_offset))
end

function var6.GetReferenceVector(arg0, arg1)
	if arg1 == nil then
		return arg0._referenceVector
	else
		arg0._referenceVectorTemp:Set(arg0._characterPos.x, arg0._characterPos.y, arg0._characterPos.z)
		arg0._referenceVectorTemp:Sub(arg1)
		var0.Battle.BattleVariable.CameraPosToUICameraByRef(arg0._referenceVectorTemp)

		arg0._referenceVectorTemp.z = 2

		return arg0._referenceVectorTemp
	end
end

function var6.GetInitScale(arg0)
	return arg0._unitData:GetTemplate().scale / 50
end

function var6.AddUnitEvent(arg0)
	arg0._unitData:RegisterEventListener(arg0, var1.SPAWN_CACHE_BULLET, arg0.onSpawnCacheBullet)
	arg0._unitData:RegisterEventListener(arg0, var1.CREATE_TEMPORARY_WEAPON, arg0.onNewWeapon)
	arg0._unitData:RegisterEventListener(arg0, var1.POP_UP, arg0.onPopup)
	arg0._unitData:RegisterEventListener(arg0, var1.VOICE, arg0.onVoice)
	arg0._unitData:RegisterEventListener(arg0, var1.PLAY_FX, arg0.onPlayFX)
	arg0._unitData:RegisterEventListener(arg0, var1.REMOVE_WEAPON, arg0.onRemoveWeapon)
	arg0._unitData:RegisterEventListener(arg0, var1.ADD_BLINK, arg0.onBlink)
	arg0._unitData:RegisterEventListener(arg0, var1.SUBMARINE_VISIBLE, arg0.onUpdateDiveInvisible)
	arg0._unitData:RegisterEventListener(arg0, var1.SUBMARINE_DETECTED, arg0.onDetected)
	arg0._unitData:RegisterEventListener(arg0, var1.SUBMARINE_FORCE_DETECTED, arg0.onForceDetected)
	arg0._unitData:RegisterEventListener(arg0, var1.BLIND_VISIBLE, arg0.onUpdateBlindInvisible)
	arg0._unitData:RegisterEventListener(arg0, var1.BLIND_EXPOSE, arg0.onBlindExposed)
	arg0._unitData:RegisterEventListener(arg0, var1.INIT_ANIT_SUB_VIGILANCE, arg0.onInitVigilantState)
	arg0._unitData:RegisterEventListener(arg0, var1.INIT_CLOAK, arg0.onInitCloak)
	arg0._unitData:RegisterEventListener(arg0, var1.UPDATE_CLOAK_CONFIG, arg0.onUpdateCloakConfig)
	arg0._unitData:RegisterEventListener(arg0, var1.UPDATE_CLOAK_LOCK, arg0.onUpdateCloakLock)
	arg0._unitData:RegisterEventListener(arg0, var1.INIT_AIMBIAS, arg0.onInitAimBias)
	arg0._unitData:RegisterEventListener(arg0, var1.UPDATE_AIMBIAS_LOCK, arg0.onUpdateAimBiasLock)
	arg0._unitData:RegisterEventListener(arg0, var1.HOST_AIMBIAS, arg0.onHostAimBias)
	arg0._unitData:RegisterEventListener(arg0, var1.REMOVE_AIMBIAS, arg0.onRemoveAimBias)
	arg0._unitData:RegisterEventListener(arg0, var0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE, arg0.onChangeSize)
	arg0._unitData:RegisterEventListener(arg0, var0.Battle.BattleBuffEvent.BUFF_EFFECT_NEW_WEAPON, arg0.onNewWeapon)
	arg0._unitData:RegisterEventListener(arg0, var1.HIDE_WAVE_FX, arg0.RemoveWaveFX)
	arg0._unitData:RegisterEventListener(arg0, var1.ADD_BUFF_CLOCK, arg0.onAddBuffClock)
	arg0._unitData:RegisterEventListener(arg0, var1.SWITCH_SPINE, arg0.onSwitchSpine)
	arg0._unitData:RegisterEventListener(arg0, var1.SWITCH_SHADER, arg0.onSwitchShader)
	arg0._unitData:RegisterEventListener(arg0, var1.UPDATE_SCORE, arg0.onUpdateScore)

	local var0 = arg0._unitData:GetAutoWeapons()

	for iter0, iter1 in ipairs(var0) do
		arg0:RegisterWeaponListener(iter1)
	end

	arg0._effectOb:SetUnitDataEvent(arg0._unitData)
end

function var6.RemoveUnitEvent(arg0)
	arg0._unitData:UnregisterEventListener(arg0, var1.UPDATE_HP)
	arg0._unitData:UnregisterEventListener(arg0, var1.CREATE_TEMPORARY_WEAPON)
	arg0._unitData:UnregisterEventListener(arg0, var1.CHANGE_ACTION)
	arg0._unitData:UnregisterEventListener(arg0, var1.SPAWN_CACHE_BULLET)
	arg0._unitData:UnregisterEventListener(arg0, var1.POP_UP)
	arg0._unitData:UnregisterEventListener(arg0, var1.VOICE)
	arg0._unitData:UnregisterEventListener(arg0, var1.PLAY_FX)
	arg0._unitData:UnregisterEventListener(arg0, var1.REMOVE_WEAPON)
	arg0._unitData:UnregisterEventListener(arg0, var1.ADD_BLINK)
	arg0._unitData:UnregisterEventListener(arg0, var1.SUBMARINE_VISIBLE)
	arg0._unitData:UnregisterEventListener(arg0, var1.SUBMARINE_DETECTED)
	arg0._unitData:UnregisterEventListener(arg0, var1.SUBMARINE_FORCE_DETECTED)
	arg0._unitData:UnregisterEventListener(arg0, var1.BLIND_VISIBLE)
	arg0._unitData:UnregisterEventListener(arg0, var1.BLIND_EXPOSE)
	arg0._unitData:UnregisterEventListener(arg0, var1.UPDATE_SCORE)
	arg0._unitData:UnregisterEventListener(arg0, var1.CHANGE_ANTI_SUB_VIGILANCE)
	arg0._unitData:UnregisterEventListener(arg0, var1.INIT_ANIT_SUB_VIGILANCE)
	arg0._unitData:UnregisterEventListener(arg0, var1.ANTI_SUB_VIGILANCE_SONAR_CHECK)
	arg0._unitData:UnregisterEventListener(arg0, var1.UPDATE_CLOAK_CONFIG)
	arg0._unitData:UnregisterEventListener(arg0, var1.UPDATE_CLOAK_LOCK)
	arg0._unitData:UnregisterEventListener(arg0, var1.INIT_CLOAK)
	arg0._unitData:UnregisterEventListener(arg0, var1.HOST_AIMBIAS)
	arg0._unitData:UnregisterEventListener(arg0, var1.UPDATE_AIMBIAS_LOCK)
	arg0._unitData:UnregisterEventListener(arg0, var1.INIT_AIMBIAS)
	arg0._unitData:UnregisterEventListener(arg0, var1.REMOVE_AIMBIAS)
	arg0._unitData:UnregisterEventListener(arg0, var1.ADD_BUFF_CLOCK)
	arg0._unitData:UnregisterEventListener(arg0, var1.SWITCH_SPINE)
	arg0._unitData:UnregisterEventListener(arg0, var1.SWITCH_SHADER)
	arg0._unitData:UnregisterEventListener(arg0, var0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE)
	arg0._unitData:UnregisterEventListener(arg0, var0.Battle.BattleBuffEvent.BUFF_EFFECT_NEW_WEAPON)

	for iter0, iter1 in pairs(arg0._weaponRegisterList) do
		arg0:UnregisterWeaponListener(iter0)
	end
end

function var6.Update(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0._bonePosSet = nil

	arg0:UpdateUIComponentPosition()
	arg0:UpdateHPPop()
	arg0:UpdateAniEffect(var0)
	arg0:UpdateTagEffect(var0)

	if arg0._referenceUpdateFlag then
		arg0:UpdateHPBarPosition()
		arg0:UpdateHPPopContainerPosition()
	end

	arg0:UpdateChatPosition()
	arg0:UpdateHpBar()
	arg0:updateSomkeFX()
	arg0:UpdateAimBiasBar()
	arg0:UpdateBuffClock()
	arg0:UpdateOrbit()
end

function var6.RegisterWeaponListener(arg0, arg1)
	if arg0._weaponRegisterList[arg1] then
		return
	end

	arg1:RegisterEventListener(arg0, var1.CREATE_BULLET, arg0.onCreateBullet)
	arg1:RegisterEventListener(arg0, var1.FIRE, arg0.onCannonFire)

	arg0._weaponRegisterList[arg1] = true
end

function var6.UnregisterWeaponListener(arg0, arg1)
	arg0._weaponRegisterList[arg1] = nil

	arg1:UnregisterEventListener(arg0, var1.CREATE_BULLET)
	arg1:UnregisterEventListener(arg0, var1.FIRE)
end

function var6.onCreateBullet(arg0, arg1)
	local var0 = arg1.Data.bullet
	local var1 = arg1.Data.spawnBound
	local var2 = arg1.Data.fireFxID
	local var3 = arg1.Data.position

	arg0:SpawnBullet(var0, var1, var2, var3)
end

function var6.onCannonFire(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = arg1.Data.target
	local var2 = arg1.Data.actionIndex or "attack"
	local var3 = arg0._unitData:NeedWeaponCache()
	local var4

	if not var3 then
		if arg0._cacheWeapon == nil then
			var4 = false
		else
			var4 = true
		end
	else
		arg0._cacheWeapon = {}
		var4 = true

		arg0._unitData:StateChange(var0.Battle.UnitState.STATE_ATTACK, var2)
	end

	if var4 == true then
		local var5 = {
			weapon = var0,
			target = var1,
			weapon = var0,
			target = var1
		}

		arg0._cacheWeapon[#arg0._cacheWeapon + 1] = var5
	else
		var0:DoAttack(var1)
	end
end

function var6.onSpawnCacheBullet(arg0)
	if arg0._cacheWeapon then
		for iter0, iter1 in ipairs(arg0._cacheWeapon) do
			iter1.weapon:DoAttack(iter1.target)

			if not arg0._unitData:IsAlive() then
				break
			end
		end

		arg0._cacheWeapon = nil
	end
end

function var6.onNewWeapon(arg0, arg1)
	local var0 = arg1.Data.weapon

	arg0:RegisterWeaponListener(var0)
end

function var6.onPopup(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.content
	local var2 = var0.duration
	local var3 = var0.key

	arg0:SetPopup(var1, var2, var3)
end

function var6.onVoice(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.content
	local var2 = var0.key

	arg0:Voice(var1, var2)
end

function var6.onPlayFX(arg0, arg1)
	local var0 = arg1.Data.fxName

	if arg1.Data.notAttach then
		arg0:PlayFX(var0)
	else
		arg0:AddFX(var0)
	end
end

function var6.onRemoveWeapon(arg0, arg1)
	local var0 = arg1.Data.weapon

	if arg0._cacheWeapon then
		for iter0, iter1 in ipairs(arg0._cacheWeapon) do
			if iter1.weapon == var0 then
				table.remove(arg0._cacheWeapon, iter0)

				break
			end
		end
	end

	arg0:UnregisterWeaponListener(var0)
end

function var6.onBlink(arg0, arg1)
	local var0 = arg1.Data.blink
	local var1 = var0.red
	local var2 = var0.green
	local var3 = var0.blue
	local var4 = var0.alpha
	local var5 = var0.peroid
	local var6 = var0.duration

	arg0:AddBlink(var1, var2, var3, var5, var6, true, var4)
end

function var6.onUpdateDiveInvisible(arg0, arg1)
	arg0:UpdateDiveInvisible()
end

function var6.UpdateDiveInvisible(arg0, arg1)
	if not arg0._go then
		return
	end

	local var0 = not arg0._unitData:GetForceExpose() and arg0._unitData:GetDiveInvisible()
	local var1 = arg0._unitData:GetIFF() == var3.FOE_CODE

	if var0 then
		local var2 = arg0:GetFactory():GetDivingFilterColor()

		arg0:updateInvisible(var0, var1 and "GRID_TRANSPARENT" or "SEMI_TRANSPARENT", var2)

		if not arg1 and var1 then
			arg0:spineSemiTransparentFade(0, 0.7, 0)
		end
	else
		arg0:updateInvisible(var0)

		if not var1 then
			arg0:AddShaderColor()
		end
	end

	if var1 then
		arg0:updateComponentVisible()
	end
end

function var6.onUpdateBlindInvisible(arg0, arg1)
	arg0:UpdateBlindInvisible()
end

function var6.UpdateBlindInvisible(arg0)
	local var0 = arg0._unitData:GetExposed()

	arg0:GetTf():GetComponent(typeof(Renderer)).enabled = var0

	arg0:updateComponentVisible()
end

function var6.updateInvisible(arg0, arg1, arg2, arg3)
	if arg1 then
		arg0:SwitchShader(arg2, arg3)
		arg0._animator:ChangeRenderQueue(2999)
	else
		arg0:SwitchShader("COLORED_ALPHA")
		arg0._animator:ChangeRenderQueue(3000)
	end

	if arg0._waveFX then
		SetActive(arg0._waveFX.transform, not arg1)
	end
end

function var6.onDetected(arg0, arg1)
	if not arg0._go then
		return
	end

	if arg0._unitData:GetDiveDetected() and arg0._unitData:GetIFF() == var3.FOE_CODE then
		arg0._shockFX = arg0:AddFX("shock", true, true)
	else
		arg0:RemoveCacheFX("shock")
	end

	if arg0._unitData:GetIFF() == var3.FOE_CODE then
		arg0:UpdateCharacterDetected()
	end

	arg0:updateComponentVisible()
end

function var6.UpdateCharacterDetected(arg0)
	if arg0._unitData:GetIFF() == var3.FRIENDLY_CODE or arg0._unitData:GetDiveDetected() then
		arg0:spineSemiTransparentFade(0, 0.7, var3.SUB_FADE_IN_DURATION)
	else
		arg0:spineSemiTransparentFade(0.7, 0, var3.SUB_FADE_OUT_DURATION)
	end
end

function var6.onForceDetected(arg0, arg1)
	arg0:UpdateCharacterForceDetected()
end

function var6.UpdateCharacterForceDetected(arg0)
	if arg0._unitData:GetIFF() == var3.FOE_CODE and arg0._unitData:GetForceExpose() then
		arg0:spineSemiTransparentFade(0, 0.7, var3.SUB_FADE_IN_DURATION)
		arg0:updateComponentVisible()
	end
end

function var6.onBlindExposed(arg0, arg1)
	local var0 = arg0._unitData:GetExposed()

	arg0:GetTf():GetComponent(typeof(Renderer)).enabled = var0

	arg0:updateComponentVisible()
end

function var6.updateComponentVisible(arg0)
	local var0

	if arg0._unitData:GetIFF() ~= var3.FOE_CODE then
		var0 = arg0._unitData:GetAttrByName(var0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY) > var3.FUSION_ELEMENT_UNIT_TYPE
	else
		local var1 = arg0._unitData:GetExposed()
		local var2 = arg0._unitData:GetDiveDetected()
		local var3 = arg0._unitData:GetDiveInvisible()

		var0 = arg0._unitData:GetForceExpose() or var1 and (not var3 or not not var2)
	end

	SetActive(arg0._arrowBarTf, var0)
	SetActive(arg0._HPBarTf, var0)
	SetActive(arg0._FXAttachPoint, var0)
	SetActive(arg0._hpPopContainerTF, var0)

	if arg0._hpCloakBar then
		arg0._hpCloakBar:SetActive(var0)
	end

	if arg0._cloakBar then
		arg0._cloakBar:SetActive(var0)
	end

	if arg0._aimBiarBar then
		arg0._aimBiarBar:SetActive(var0)
	end
end

function var6.updateComponentDiveInvisible(arg0)
	local var0 = arg0._unitData:GetDiveDetected() and arg0._unitData:GetIFF() == var3.FOE_CODE
	local var1 = arg0._unitData:GetDiveInvisible()
	local var2
	local var3 = (var0 or not var1) and true or false

	SetActive(arg0._arrowBarTf, var3)
	SetActive(arg0._HPBarTf, var3)
	SetActive(arg0._FXAttachPoint, var3)
end

function var6.updateComponentBlindInvisible(arg0)
	local var0 = arg0._unitData:GetExposed()

	arg0:GetTf():GetComponent(typeof(Renderer)).enabled = var0

	SetActive(arg0._arrowBarTf, var0)
	SetActive(arg0._HPBarTf, var0)
	SetActive(arg0._FXAttachPoint, var0)
end

function var6.spineSemiTransparentFade(arg0, arg1, arg2, arg3)
	LeanTween.cancel(arg0._go)
	onDelayTick(function()
		if not arg0._go then
			return
		end

		arg3 = arg3 or 0

		SpineAnim.ShaderTransparentFade(arg0._go, arg2, arg1, arg3, "_Invisible")
	end, 0.06)
end

function var6.onInitVigilantState(arg0, arg1)
	arg0._factory:MakeVigilantBar(arg0)

	range = arg1.Data.sonarRange * 0.5

	local var0 = arg0:AddFX("AntiSubArea", true).transform

	var0.localScale = Vector3(range, 0, range)

	local function var1()
		local var0 = var0:Find("Quad"):GetComponent(typeof(Animator))

		var0.enabled = true

		var0:Play("antiSubZoom", -1, 0)
	end

	arg0._unitData:RegisterEventListener(arg0, var1.CHANGE_ANTI_SUB_VIGILANCE, arg0.onVigilantStateChange)
	arg0._unitData:RegisterEventListener(arg0, var1.ANTI_SUB_VIGILANCE_SONAR_CHECK, var1)
end

function var6.onVigilantStateChange(arg0, arg1)
	arg0:updateVigilantMark()
end

function var6.updateVigilantMark(arg0)
	if arg0._vigilantBar then
		arg0._vigilantBar:UpdateVigilantMark()
	end
end

function var6.OnActionChange(arg0, arg1)
	local var0 = arg1.Data.actionType

	arg0:PlayAction(var0)
end

function var6.PlayAction(arg0, arg1)
	arg0._animator:SetAction(arg1, 0, var2.ActionLoop[arg1])

	arg0._actionIndex = arg1

	if arg1 == var2.ActionName.VICTORY or arg1 == var2.ActionName.VICTORY_SWIM then
		arg0._effectOb:ClearEffect()
	end

	if #arg0._orbitActionUpdateList > 0 then
		for iter0, iter1 in ipairs(arg0._orbitActionUpdateList) do
			local var0 = iter1.orbit
			local var1 = iter1.change
			local var2 = var1.condition.param
			local var3 = false

			for iter2, iter3 in ipairs(var2) do
				if string.find(arg1, iter3) then
					var3 = true

					break
				end
			end

			if var3 then
				arg0:changeOrbitAction(var0, var1)

				break
			end
		end
	end
end

function var6.SetAnimaSpeed(arg0, arg1)
	arg0._skeleton = arg0._skeleton or arg0:GetTf():GetComponent("SkeletonAnimation")
	arg1 = arg1 or 1
	arg0._skeleton.timeScale = arg1
end

function var6.UpdatePosition(arg0)
	if not arg0._go then
		return
	end

	local var0 = arg0._unitData:GetPosition()

	if arg0._unitData:GetSpeed() == Vector3.zero and arg0._characterPos == var0 then
		return
	end

	arg0._characterPos = var0
	arg0._tf.localPosition = arg0:getCharacterPos()
end

function var6.getCharacterPos(arg0)
	return arg0._characterPos
end

function var6.UpdateMatrix(arg0)
	arg0._bonePosTable = nil
	arg0._posMatrix = nil
end

function var6.UpdateUIComponentPosition(arg0)
	local var0 = arg0._unitData:GetPosition()

	arg0._referenceVector:Set(var0.x, var0.y, var0.z)
	var0.Battle.BattleVariable.CameraPosToUICameraByRef(arg0._referenceVector)

	arg0._referenceVector.z = 10
	arg0._referenceUpdateFlag = not arg0._referenceVector:Equals(arg0._referenceVectorCache)

	if arg0._referenceUpdateFlag then
		arg0._referenceVectorCache:Copy(arg0._referenceVector)
	end
end

function var6.UpdateHPPopContainerPosition(arg0)
	arg0._hpPopContainerTF.position = arg0._referenceVector
end

function var6.UpdateHPBarPosition(arg0)
	if not arg0._hideHP then
		arg0._hpBarPos:Copy(arg0._referenceVector):Add(arg0._hpBarOffset)

		arg0._HPBarTf.position = arg0._hpBarPos
	end
end

function var6.SetBarHidden(arg0, arg1, arg2)
	arg0._alwaysHideArrow = arg1
	arg0._hideHP = arg2

	if arg0._arrowBar then
		if arg0._alwaysHideArrow then
			arg0._arrowBarTf.anchoredPosition = var7
		else
			arg0._arrowBarTf.position = arg0._arrowVector
		end
	end
end

function var6.UpdateCastClockPosition(arg0)
	arg0._castClock:UpdateCastClockPosition(arg0._referenceVector)
end

function var6.UpdateBarrierClockPosition(arg0)
	arg0._barrierClock:UpdateBarrierClockPosition(arg0._referenceVector)
end

function var6.SetArrowPoint(arg0)
	arg0._arrowVector:Set()

	arg0._cameraUtil = var0.Battle.BattleCameraUtil.GetInstance()
	arg0._arrowCenterPos = arg0._cameraUtil:GetArrowCenterPos()
end

local var9 = Vector3(-1, 1, 1)
local var10 = Vector3(1, 1, 1)

function var6.UpdateArrowBarPostition(arg0)
	local var0 = arg0._cameraUtil:GetCharacterArrowBarPosition(arg0._referenceVector, arg0._arrowVector)

	if not var0 then
		if not arg0._inViewArea then
			arg0._inViewArea = true
			arg0._arrowBarTf.anchoredPosition = var7
		end
	else
		local var1 = arg0._unitData:GetBornPosition()

		if var1 and var1 ~= arg0._unitData:GetPosition() then
			var0 = arg0._cameraUtil:GetCharacterArrowBarPosition(arg0._referenceVectorBorn, arg0._arrowVector)
		end

		arg0._arrowVector = var0
		arg0._inViewArea = false

		if not arg0._alwaysHideArrow then
			arg0._arrowBarTf.position = arg0._arrowVector

			if arg0._arrowVector.x > 0 then
				arg0._arrowBarTf.localScale = var9
			else
				arg0._arrowBarTf.localScale = var10
			end
		end
	end
end

function var6.UpdateArrowBarRotation(arg0)
	if arg0._inViewArea then
		return
	end

	local var0 = arg0._arrowVector.x
	local var1 = arg0._arrowVector.y
	local var2 = math.rad2Deg * math.atan2(var1 - arg0._arrowCenterPos.y, var0 - arg0._arrowCenterPos.x)

	arg0._arrowAngleVector.z = var2
	arg0._arrowBarTf.eulerAngles = arg0._arrowAngleVector
end

function var6.UpdateChatPosition(arg0)
	if not arg0._popGO then
		return
	end

	if arg0._inViewArea then
		arg0._popTF.position = arg0:GetReferenceVector()
	else
		arg0._popTF.position = arg0._arrowVector + var8
	end
end

function var6.Dispose(arg0)
	if arg0._popGO then
		LeanTween.cancel(arg0._popGO)
	end

	if arg0._popNumBundle then
		arg0._hpPopContainerTF = nil

		arg0._popNumBundle:Clear()

		arg0._popNumBundle = nil
	end

	arg0._popNumPool = nil

	Object.Destroy(arg0._popGO)

	if arg0._voicePlaybackInfo then
		arg0._voicePlaybackInfo:PlaybackStop()
	end

	if arg0._cloakBar then
		arg0._cloakBar:Dispose()

		arg0._cloakBar = nil
		arg0._cloakBarTf = nil
	end

	if arg0._aimBiarBar then
		arg0._aimBiarBar:Dispose()

		arg0._aimBiarBar = nil
	end

	if arg0._buffClock then
		arg0._buffClock:Dispose()

		arg0._buffClock = nil
	end

	arg0._voicePlaybackInfo = nil
	arg0._popGO = nil
	arg0._popTF = nil
	arg0._cacheWeapon = nil

	for iter0, iter1 in pairs(arg0._allFX) do
		var4.GetInstance():DestroyOb(iter0)
	end

	for iter2, iter3 in pairs(arg0._orbitList) do
		var4.GetInstance():DestroyOb(iter2)
	end

	arg0._orbitList = nil
	arg0._orbitActionCacheList = nil
	arg0._orbitSpeedUpdateList = nil
	arg0._orbitActionUpdateList = nil

	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._voiceTimer)

	arg0._voiceTimer = nil

	arg0._effectOb:RemoveUnitEvent(arg0._unitData)
	arg0._effectOb:Dispose()

	arg0._HPProgressBar = nil
	arg0._HPProgress = nil

	arg0._factory:GetHPBarPool():DestroyObj(arg0._HPBar)

	arg0._HPBar = nil
	arg0._HPBarTf = nil
	arg0._arrowBar = nil
	arg0._arrowBarTf = nil

	if arg0._animator then
		arg0._animator:ClearOverrideMaterial()

		arg0._animator = nil
	end

	arg0._skeleton = nil
	arg0._posMatrix = nil
	arg0._shockFX = nil
	arg0._waveFX = nil

	arg0:RemoveUnitEvent()
	var0.EventListener.DetachEventListener(arg0)

	arg0._bulletFactoryList = nil

	for iter4, iter5 in pairs(arg0._tagFXList) do
		iter5:Dispose()
	end

	arg0._tagFXList = nil
	arg0._weaponRegisterList = nil

	var6.super.Dispose(arg0)
end

function var6.AddModel(arg0, arg1)
	arg0:SetGO(arg1)

	arg0._hpBarOffset = Vector3(0, arg0._unitData:GetBoxSize().y, 0)
	arg0._animator = arg0:GetTf():GetComponent(typeof(SpineAnim))

	if arg0._animator then
		arg0._animator:Start()
	end

	arg0:SetBoneList()
	arg0:UpdateMatrix()
	arg0._unitData:ActiveCldBox()

	local var0 = arg0:GetInitScale()

	arg0._tf.localScale = Vector3(var0 * arg0._unitData:GetDirection(), var0, var0)

	local var1 = arg0._unitData:GetOxyState()

	if var1 and var1:GetCurrentDiveState() == var0.Battle.BattleConst.OXY_STATE.DIVE then
		arg0:PlayAction(var0.Battle.BattleConst.ActionName.DIVE)
	else
		arg0:PlayAction(var0.Battle.BattleConst.ActionName.MOVE)
	end

	arg0._animator:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			arg0:OnAnimatorEnd()
		elseif arg0 == "action" then
			arg0:OnAnimatorTrigger()
		end
	end)
	arg0._unitData:RegisterEventListener(arg0, var1.CHANGE_ACTION, arg0.OnActionChange)
end

function var6.SwitchModel(arg0, arg1, arg2)
	local var0 = arg0._go

	arg0:SetGO(arg1)

	arg0._animator = arg0:GetTf():GetComponent(typeof(SpineAnim))

	if arg0._animator then
		arg0._animator:Start()
	end

	arg0:SetBoneList()

	arg0._tf.position = arg0._unitData:GetPosition()

	arg0:UpdateMatrix()

	arg0._hpBarOffset.y = arg0._hpBarOffset.y + arg0._coverSpineHPBarOffset

	arg0:UpdateHPBarPosition()

	local var1 = arg0:GetInitScale()

	arg0._tf.localScale = Vector3(var1 * arg0._unitData:GetDirection(), var1, var1)

	arg0._animator:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			arg0:OnAnimatorEnd()
		elseif arg0 == "action" then
			arg0:OnAnimatorTrigger()
		end
	end)
	arg0:SwitchShader(arg0._shaderType, arg0._color)

	local var2 = {}
	local var3 = {}

	for iter0, iter1 in pairs(arg0._blinkDict) do
		local var4 = SpineAnim.CharBlink(arg0._go, iter1.r, iter1.g, iter1.b, iter1.a, iter1.peroid, iter1.duration, false)

		var2[var4] = iter1
		var3[iter0] = var4
	end

	arg0._blinkDict = var2

	arg0:PlayAction(arg0._actionIndex)

	if not arg2 then
		for iter2, iter3 in pairs(arg0._orbitList) do
			SpineAnim.AddFollower(iter3.boundBone, arg0._tf, iter2.transform):GetComponent("Spine.Unity.BoneFollower").followBoneRotation = false
		end
	end

	arg0._effectOb:SwitchOwner(arg0, var3)
	arg0._FXAttachPoint.transform:SetParent(arg0:GetTf(), false)
	var4.GetInstance():DestroyOb(var0)
end

function var6.AddOrbit(arg0, arg1, arg2)
	local var0 = arg2.orbit_combat_bound[1]
	local var1 = arg2.orbit_combat_bound[2]
	local var2 = arg2.orbit_hidden_action

	arg1.transform.localPosition = Vector3(var1[1], var1[2], var1[3])
	SpineAnim.AddFollower(var0, arg0._tf, arg1.transform):GetComponent("Spine.Unity.BoneFollower").followBoneRotation = false
	arg0._orbitList[arg1] = {
		hiddenAction = var2,
		boundBone = var0
	}

	local var3 = arg2.orbit_combat_anima_change.default

	if var3 then
		arg0:changeOrbitAction(arg1, var3)

		for iter0, iter1 in ipairs(arg2.orbit_combat_anima_change.change) do
			if iter1.condition.type == 1 then
				table.insert(arg0._orbitSpeedUpdateList, {
					orbit = arg1,
					change = Clone(iter1)
				})
			elseif iter1.condition.type == 2 then
				table.insert(arg0._orbitActionUpdateList, {
					orbit = arg1,
					change = Clone(iter1)
				})
			end
		end
	end
end

function var6.changeOrbitAction(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		local var0 = arg1.transform:Find(iter1.node)

		if var0 then
			SetActive(var0, iter1.active)

			if iter1.active and arg0._orbitActionCacheList[var0] ~= iter1.activate then
				local var1 = iter1.activate

				var0:GetComponent(typeof(Animator)):SetBool("activate", var1)

				arg0._orbitActionCacheList[var0] = iter1.activate
			end
		end
	end
end

function var6.UpdateOrbit(arg0)
	if #arg0._orbitSpeedUpdateList <= 0 then
		return
	end

	local var0 = arg0._unitData:GetSpeed():Magnitude()

	for iter0, iter1 in pairs(arg0._orbitSpeedUpdateList) do
		local var1 = iter1.orbit
		local var2 = iter1.change
		local var3 = var2.condition.param
		local var4 = true

		for iter2, iter3 in ipairs(var3) do
			var4 = var5.simpleCompare(iter3, var0) and var4
		end

		if var4 then
			arg0:changeOrbitAction(var1, var2)
		end
	end
end

function var6.AddSmokeFXs(arg0, arg1)
	arg0._smokeList = arg1

	arg0:updateSomkeFX()
end

function var6.AddShadow(arg0, arg1)
	arg0._shadow = arg1
end

function var6.AddHPBar(arg0, arg1)
	arg0._HPBar = arg1
	arg0._HPBarTf = arg1.transform
	arg0._HPProgressBar = arg0._HPBarTf:Find("blood")
	arg0._HPProgress = arg0._HPProgressBar:GetComponent(typeof(Image))

	arg0._unitData:RegisterEventListener(arg0, var1.UPDATE_HP, arg0.OnUpdateHP)

	arg0._HPBarTf.position = arg0._referenceVector + arg0._hpBarOffset
end

function var6.AddUIComponentContainer(arg0, arg1)
	arg0:UpdateUIComponentPosition()
end

function var6.AddPopNumPool(arg0, arg1)
	arg0._popNumPool = arg1
	arg0._hpPopIndex_put = 1
	arg0._hpPopIndex_get = 1
	arg0._hpPopCount = 0
	arg0._hpPopCatch = {}
	arg0._popNumBundle = arg0._popNumPool:GetBundle(arg0._unitData:GetUnitType())
	arg0._hpPopContainerTF = arg0._popNumBundle:GetContainer().transform
end

function var6.AddArrowBar(arg0, arg1)
	arg0._arrowBar = arg1
	arg0._arrowBarTf = arg1.transform

	arg0:SetArrowPoint()
end

function var6.AddCastClock(arg0, arg1)
	local var0 = arg1.transform

	SetActive(var0, false)

	arg0._castClock = var0.Battle.BattleCastBar.New(var0)

	arg0:UpdateCastClockPosition()
end

function var6.AddBuffClock(arg0, arg1)
	local var0 = arg1.transform

	SetActive(var0, false)

	arg0._buffClock = var0.Battle.BattleBuffClock.New(var0)
end

function var6.AddBarrierClock(arg0, arg1)
	local var0 = arg1.transform

	SetActive(var0, false)

	arg0._barrierClock = var0.Battle.BattleBarrierBar.New(var0)

	arg0:UpdateBarrierClockPosition()
end

function var6.AddVigilantBar(arg0, arg1)
	arg0._vigilantBar = var0.Battle.BattleVigilantBar.New(arg1.transform)

	arg0._vigilantBar:ConfigVigilant(arg0._unitData:GetAntiSubState())
	arg0._vigilantBar:UpdateVigilantProgress()
	arg0:updateVigilantMark()
end

function var6.UpdateVigilantBarPosition(arg0)
	arg0._vigilantBar:UpdateVigilantBarPosition(arg0._hpBarPos)
end

function var6.AddCloakBar(arg0, arg1)
	arg0._cloakBarTf = arg1.transform
	arg0._cloakBar = var0.Battle.BattleCloakBar.New(arg0._cloakBarTf)

	arg0._cloakBar:ConfigCloak(arg0._unitData:GetCloak())
	arg0._cloakBar:UpdateCloakProgress()
end

function var6.UpdateCloakBarPosition(arg0, arg1)
	if arg0._inViewArea then
		arg0._cloakBarTf.anchoredPosition = var7
	else
		arg0._cloakBar:UpdateCloarBarPosition(arg0._arrowVector)
	end
end

function var6.onInitCloak(arg0, arg1)
	arg0._factory:MakeCloakBar(arg0)
end

function var6.onUpdateCloakConfig(arg0, arg1)
	arg0._cloakBar:UpdateCloakConfig()
end

function var6.onUpdateCloakLock(arg0, arg1)
	arg0._cloakBar:UpdateCloakLock()
end

function var6.AddAimBiasBar(arg0, arg1)
	arg0._aimBiarBarTF = arg1
	arg0._aimBiarBar = var0.Battle.BattleAimbiasBar.New(arg1)

	arg0._aimBiarBar:ConfigAimBias(arg0._unitData:GetAimBias())
	arg0._aimBiarBar:UpdateAimBiasProgress()
end

function var6.UpdateAimBiasBar(arg0)
	if arg0._aimBiarBar then
		arg0._aimBiarBar:UpdateAimBiasProgress()
	end
end

function var6.UpdateBuffClock(arg0)
	if arg0._buffClock and arg0._buffClock:IsActive() then
		arg0._buffClock:UpdateCastClockPosition(arg0._referenceVector)
		arg0._buffClock:UpdateCastClock()
	end
end

function var6.onUpdateAimBiasLock(arg0, arg1)
	arg0._aimBiarBar:UpdateLockStateView()
end

function var6.onInitAimBias(arg0, arg1)
	if arg0._unitData:GetAimBias():GetHost() == arg0._unitData then
		arg0._factory:MakeAimBiasBar(arg0)
	end
end

function var6.onHostAimBias(arg0, arg1)
	arg0._factory:MakeAimBiasBar(arg0)
end

function var6.onRemoveAimBias(arg0, arg1)
	arg0._aimBiarBar:SetActive(false)
	arg0._aimBiarBar:Dispose()

	arg0._aimBiarBar = nil
	arg0._aimBiarBarTF = nil
end

function var6.AddAimBiasFogFX(arg0)
	local var0 = arg0._unitData:GetTemplate().fog_fx

	if var0 and var0 ~= "" then
		arg0._fogFx = arg0:AddFX(var0)
	end
end

function var6.OnUpdateHP(arg0, arg1)
	arg0:_DealHPPop(arg1.Data)
end

function var6._DealHPPop(arg0, arg1)
	if arg0._hpPopIndex_put == arg0._hpPopIndex_get and arg0._hpPopCount == 0 then
		arg0:_PlayHPPop(arg1)

		arg0._hpPopCount = 1
	elseif arg0._unitData:IsAlive() then
		arg0._hpPopCatch[arg0._hpPopIndex_put] = arg1
		arg0._hpPopIndex_put = arg0._hpPopIndex_put + 1
	else
		arg0:_PlayHPPop(arg1)
	end
end

function var6.UpdateHPPop(arg0)
	if arg0._hpPopIndex_put == arg0._hpPopIndex_get then
		return
	else
		arg0._hpPopCount = arg0._hpPopCount + 1

		if arg0:_CalcHPPopCount() <= arg0._hpPopCount then
			arg0:_PlayHPPop(arg0._hpPopCatch[arg0._hpPopIndex_get])

			arg0._hpPopCatch[arg0._hpPopIndex_get] = nil
			arg0._hpPopIndex_get = arg0._hpPopIndex_get + 1
			arg0._hpPopCount = 0
		end
	end
end

function var6._PlayHPPop(arg0, arg1)
	if arg0._popNumBundle:IsScorePop() then
		return
	end

	local var0 = arg1.dHP
	local var1 = arg1.isCri
	local var2 = arg1.isMiss
	local var3 = arg1.isHeal
	local var4 = arg1.posOffset or Vector3.zero
	local var5 = arg1.font
	local var6 = arg0._popNumBundle:GetPop(var3, var1, var2, var0, var5)

	var6:SetReferenceCharacter(arg0, var4)
	var6:Play()
end

function var6._CalcHPPopCount(arg0)
	if arg0._hpPopIndex_put - arg0._hpPopIndex_get > 5 then
		return 1
	else
		return 5
	end
end

function var6.onUpdateScore(arg0, arg1)
	local var0 = arg1.Data.score
	local var1 = arg0._popNumBundle:GetScorePop(var0)

	var1:SetReferenceCharacter(arg0, Vector3.zero)
	var1:Play()
end

function var6.UpdateHpBar(arg0)
	local var0 = arg0._unitData:GetCurrentHP()

	if arg0._HPProgress and arg0._cacheHP ~= var0 then
		local var1 = arg0._unitData:GetHPRate()

		arg0._HPProgress.fillAmount = var1
		arg0._cacheHP = var0
	end
end

function var6.onChangeSize(arg0, arg1)
	arg0:doChangeSize(arg1)
end

function var6.updateSomkeFX(arg0)
	local var0 = arg0._unitData:GetHPRate()

	for iter0, iter1 in ipairs(arg0._smokeList) do
		if var0 < iter1.rate then
			if iter1.active == false then
				iter1.active = true

				local var1 = iter1.smokes

				for iter2, iter3 in pairs(var1) do
					if iter2.unInitialize then
						local var2 = arg0:AddFX(iter2.resID)

						var2.transform.localPosition = iter2.pos
						var1[iter2] = var2

						SetActive(var2, true)

						iter2.unInitialize = false
					else
						SetActive(iter3, true)
					end
				end
			end
		elseif iter1.active == true then
			iter1.active = false

			local var3 = iter1.smokes

			for iter4, iter5 in pairs(var3) do
				if iter4.unInitialize then
					-- block empty
				else
					SetActive(iter5, false)
				end
			end
		end
	end
end

function var6.doChangeSize(arg0, arg1)
	local var0 = arg1.Data.size_ratio

	arg0._tf.localScale = arg0._tf.localScale * var0
end

function var6.InitEffectView(arg0)
	arg0._effectOb = var0.Battle.BattleEffectComponent.New(arg0)
end

function var6.UpdateAniEffect(arg0, arg1)
	arg0._effectOb:Update(arg1)
end

function var6.UpdateTagEffect(arg0, arg1)
	local var0 = arg0._unitData:GetBoxSize().y * 0.5

	for iter0, iter1 in pairs(arg0._tagFXList) do
		iter1:Update(arg1)
		iter1:SetPosition(arg0._referenceVector + Vector3(0, var0, 0))
	end
end

function var6.SetPopup(arg0, arg1, arg2, arg3)
	if arg0._voiceTimer then
		if arg0._voiceKey == arg3 then
			arg0._voiceKey = nil
		else
			return
		end
	end

	if arg0._popGO then
		LeanTween.cancel(arg0._popGO)
		LeanTween.scale(rtf(arg0._popGO.gameObject), Vector3.New(0, 0, 1), 0.1):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function()
			arg0:chatPop(arg1, arg2)
		end))
	else
		arg0._popGO = arg0._factory:MakePopup()
		arg0._popTF = arg0._popGO.transform
		arg0._popTF.localScale = Vector3(0, 0, 0)

		arg0:chatPop(arg1, arg2)
	end

	SetActive(arg0._popGO, true)
end

function var6.chatPop(arg0, arg1, arg2)
	arg2 = arg2 or 2.5

	local var0 = findTF(arg0._popGO, "Text"):GetComponent(typeof(Text))

	setTextEN(var0, arg1)

	if #var0.text > CHAT_POP_STR_LEN then
		var0.alignment = TextAnchor.MiddleLeft
	else
		var0.alignment = TextAnchor.MiddleCenter
	end

	LeanTween.scale(rtf(arg0._popGO.gameObject), Vector3.New(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0._popGO.gameObject), Vector3.New(0, 0, 1), 0.3):setEase(LeanTweenType.easeInBack):setDelay(arg2):setOnComplete(System.Action(function()
			SetActive(arg0._popGO, false)
		end))
	end))
end

function var6.Voice(arg0, arg1, arg2)
	if arg0._voiceTimer then
		return
	end

	pg.CriMgr.GetInstance():PlayMultipleSound_V3(arg1, function(arg0)
		if arg0 then
			arg0._voiceKey = arg2
			arg0._voicePlaybackInfo = arg0
			arg0._voiceTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 0, arg0._voicePlaybackInfo:GetLength() * 0.001, function()
				pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._voiceTimer)

				arg0._voiceTimer = nil
				arg0._voiceKey = nil
				arg0._voicePlaybackInfo = nil
			end)
		end
	end)
end

function var6.SonarAcitve(arg0, arg1)
	return
end

function var6.SwitchShader(arg0, arg1, arg2, arg3)
	LeanTween.cancel(arg0._go)

	arg2 = arg2 or Color.New(0, 0, 0, 0)

	if arg1 then
		local var0 = var4.GetInstance():GetShader(arg1)

		arg0._animator:ShiftShader(var0, arg2)

		if arg3 then
			arg0:spineSemiTransparentFade(0, arg3.invisible, 0)
		end
	end

	arg0._shaderType = arg1
	arg0._color = arg2
end

function var6.PauseActionAnimation(arg0, arg1)
	local var0 = arg1 and 0 or 1

	arg0._animator:GetAnimationState().TimeScale = var0
end

function var6.GetFactory(arg0)
	return arg0._factory
end

function var6.SetFactory(arg0, arg1)
	arg0._factory = arg1
end

function var6.onSwitchSpine(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.skin

	arg0._coverSpineHPBarOffset = var0.HPBarOffset or 0

	arg0:SwitchSpine(var1)
end

function var6.SwitchSpine(arg0, arg1)
	for iter0, iter1 in pairs(arg0._blinkDict) do
		SpineAnim.RemoveBlink(arg0._go, iter0)
	end

	arg0._factory:SwitchCharacterSpine(arg0, arg1)
end

function var6.onSwitchShader(arg0, arg1)
	local var0 = arg1.Data
	local var1 = var0.shader
	local var2 = var0.color
	local var3 = var0.args

	arg0:SwitchShader(var1, var2, var3)
end
