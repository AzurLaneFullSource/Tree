ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = var0_0.Battle.BattleResourceManager
local var5_0 = var0_0.Battle.BattleFormulas
local var6_0 = class("BattleCharacter", var0_0.Battle.BattleSceneObject)

var0_0.Battle.BattleCharacter = var6_0
var6_0.__name = "BattleCharacter"

local var7_0 = Vector2(-1200, -1200)
local var8_0 = Vector3.New(0.3, -1.8, 0)

var6_0.AIM_OFFSET = Vector3.New(0, -3.5, 0)

function var6_0.Ctor(arg0_1)
	var6_0.super.Ctor(arg0_1)
	arg0_1:Init()
end

function var6_0.Init(arg0_2)
	var0_0.EventListener.AttachEventListener(arg0_2)
	arg0_2:InitBulletFactory()
	arg0_2:InitEffectView()

	arg0_2._tagFXList = {}
	arg0_2._cacheFXList = {}
	arg0_2._allFX = {}
	arg0_2._bulletCache = {}
	arg0_2._weaponRegisterList = {}
	arg0_2._characterPos = Vector3.zero
	arg0_2._orbitList = {}
	arg0_2._orbitActionCacheList = {}
	arg0_2._orbitSpeedUpdateList = {}
	arg0_2._orbitActionUpdateList = {}
	arg0_2._inViewArea = false
	arg0_2._alwaysHideArrow = false
	arg0_2._hideHP = false
	arg0_2._referenceVector = Vector3.zero
	arg0_2._referenceVectorCache = Vector3.zero
	arg0_2._referenceVectorTemp = Vector3.zero
	arg0_2._referenceUpdateFlag = false
	arg0_2._referenceVectorBorn = nil
	arg0_2._hpBarPos = Vector3.zero
	arg0_2._arrowVector = Vector3.zero
	arg0_2._arrowAngleVector = Vector3.zero
	arg0_2._blinkDict = {}
	arg0_2._coverSpineHPBarOffset = 0
	arg0_2._shaderType = nil
	arg0_2._color = nil
	arg0_2._actionIndex = nil
end

function var6_0.InitBulletFactory(arg0_3)
	arg0_3._bulletFactoryList = var0_0.Battle.BattleBulletFactory.GetFactoryList()
end

function var6_0.SetUnitData(arg0_4, arg1_4)
	arg0_4._unitData = arg1_4

	arg0_4:AddUnitEvent()
end

function var6_0.SetBoneList(arg0_5)
	arg0_5._boneList = {}
	arg0_5._remoteBoneTable = {}
	arg0_5._bonePosTable = nil
	arg0_5._posMatrix = nil

	local var0_5 = arg0_5:GetInitScale()

	for iter0_5, iter1_5 in pairs(arg0_5._unitData:GetTemplate().bound_bone) do
		if iter0_5 ~= "remote" then
			arg0_5:insertBondList(iter0_5, iter1_5)
		end
	end

	for iter2_5, iter3_5 in pairs(var3_0.CommonBone) do
		arg0_5:insertBondList(iter2_5, iter3_5)
	end
end

function var6_0.insertBondList(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in ipairs(arg2_6) do
		if type(iter1_6) == "table" then
			local var0_6 = {}

			var0_6[#var0_6 + 1] = Vector3(iter1_6[1], iter1_6[2], iter1_6[3])
			arg0_6._boneList[arg1_6] = var0_6
		end
	end
end

function var6_0.SpawnBullet(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local var0_7 = arg0_7._bulletFactoryList[arg1_7:GetTemplate().type]
	local var1_7 = arg0_7._unitData:GetRemoteBoundBone(arg2_7)
	local var2_7 = arg4_7 or var1_7 or arg0_7:GetBonePos(arg2_7)

	var0_7:CreateBullet(arg0_7._tf, arg1_7, var2_7, arg3_7, arg0_7._unitData:GetDirection())
end

function var6_0.GetBonePos(arg0_8, arg1_8)
	local var0_8 = arg0_8._boneList[arg1_8]

	if var0_8 == nil or #var0_8 == 0 then
		for iter0_8, iter1_8 in pairs(arg0_8._boneList) do
			var0_8 = iter1_8

			break
		end
	end

	local var1_8

	if not arg0_8._posMatrix then
		var1_8 = arg0_8._tf.localToWorldMatrix
		arg0_8._posMatrix = var1_8
		arg0_8._bonePosTable = {}
	else
		var1_8 = arg0_8._posMatrix
	end

	local var2_8 = arg0_8._bonePosTable[arg1_8]

	if var2_8 == nil then
		var2_8 = {}

		for iter2_8, iter3_8 in ipairs(var0_8) do
			var2_8[#var2_8 + 1] = var1_8:MultiplyPoint3x4(iter3_8)
		end

		arg0_8._bonePosTable[arg1_8] = var2_8
	end

	if #var2_8 == 1 then
		return var2_8[1]
	else
		return var2_8[math.floor(math.Random(0, #var2_8)) + 1]
	end
end

function var6_0.GetBoneList(arg0_9)
	return arg0_9._boneList
end

function var6_0.AddFXOffsets(arg0_10, arg1_10, arg2_10)
	arg0_10._FXAttachPoint = arg1_10
	arg0_10._FXOffset = arg2_10
end

function var6_0.GetFXOffsets(arg0_11, arg1_11)
	arg1_11 = arg1_11 or 1

	return arg0_11._FXOffset[arg1_11]
end

function var6_0.GetAttachPoint(arg0_12)
	return arg0_12._FXAttachPoint
end

function var6_0.GetSpecificFXScale(arg0_13)
	return {}
end

function var6_0.PlayFX(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetFactory():GetFXPool():GetFX(arg1_14)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0_14, arg0_14:GetPosition(), true)
end

function var6_0.AddFX(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	local var0_15 = arg0_15:GetFactory():GetFXPool():GetCharacterFX(arg1_15, arg0_15, not arg2_15, function(arg0_16)
		if arg4_15 then
			arg4_15()
		end

		arg0_15._allFX[arg0_16] = nil
	end, arg3_15)

	if arg2_15 then
		local var1_15 = arg0_15._cacheFXList[arg1_15] or {}

		table.insert(var1_15, var0_15)

		arg0_15._cacheFXList[arg1_15] = var1_15
	end

	arg0_15._allFX[var0_15] = true

	return var0_15
end

function var6_0.RemoveFX(arg0_17, arg1_17)
	if arg0_17._allFX and arg0_17._allFX[arg1_17] then
		arg0_17._allFX[arg1_17] = nil

		var4_0.GetInstance():DestroyOb(arg1_17)
	end
end

function var6_0.RemoveCacheFX(arg0_18, arg1_18)
	local var0_18 = arg0_18._cacheFXList[arg1_18]

	if var0_18 ~= nil and #var0_18 > 0 then
		local var1_18 = table.remove(var0_18)

		arg0_18._allFX[var1_18] = nil

		var4_0.GetInstance():DestroyOb(var1_18)
	end
end

function var6_0.AddWaveFX(arg0_19, arg1_19)
	arg0_19._waveFX = arg0_19:AddFX(arg1_19)
end

function var6_0.RemoveWaveFX(arg0_20)
	if not arg0_20._waveFX then
		return
	end

	arg0_20:RemoveFX(arg0_20._waveFX)
end

function var6_0.onAddBuffClock(arg0_21, arg1_21)
	local var0_21 = arg1_21.Data

	if var0_21.isActive then
		if not arg0_21._buffClock then
			arg0_21._factory:MakeBuffClock(arg0_21)
		end

		arg0_21._buffClock:Casting(var0_21)
	else
		arg0_21._buffClock:Interrupt(var0_21)
	end
end

function var6_0.AddBlink(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22, arg5_22, arg6_22, arg7_22)
	if arg0_22._unitData:GetDiveInvisible() then
		return nil
	end

	if not arg0_22._unitData:GetExposed() then
		return nil
	end

	arg4_22 = arg4_22 or 0.1
	arg5_22 = arg5_22 or 0.1
	arg6_22 = arg6_22 or false
	arg7_22 = arg7_22 or 0.18

	local var0_22 = SpineAnim.CharBlink(arg0_22._go, arg1_22, arg2_22, arg3_22, arg7_22, arg4_22, arg5_22, arg6_22)

	if not arg6_22 then
		arg0_22._blinkDict[var0_22] = {
			r = arg1_22,
			g = arg2_22,
			b = arg3_22,
			a = arg7_22,
			peroid = arg4_22,
			duration = arg5_22
		}
	end

	return var0_22
end

function var6_0.RemoveBlink(arg0_23, arg1_23)
	arg0_23._blinkDict[arg1_23] = nil

	SpineAnim.RemoveBlink(arg0_23._go, arg1_23)
end

function var6_0.AddShaderColor(arg0_24, arg1_24)
	if not arg0_24._unitData:GetExposed() then
		return
	end

	arg1_24 = arg1_24 or Color.New(0, 0, 0, 0)

	SpineAnim.AddShaderColor(arg0_24._go, arg1_24)
end

function var6_0.GetPosition(arg0_25)
	return arg0_25._characterPos
end

function var6_0.GetUnitData(arg0_26)
	return arg0_26._unitData
end

function var6_0.GetDestroyFXID(arg0_27)
	return arg0_27:GetUnitData():GetTemplate().bomb_fx
end

function var6_0.GetOffsetPos(arg0_28)
	return (BuildVector3(arg0_28._unitData:GetTemplate().position_offset))
end

function var6_0.GetReferenceVector(arg0_29, arg1_29)
	if arg1_29 == nil then
		return arg0_29._referenceVector
	else
		arg0_29._referenceVectorTemp:Set(arg0_29._characterPos.x, arg0_29._characterPos.y, arg0_29._characterPos.z)
		arg0_29._referenceVectorTemp:Sub(arg1_29)
		var0_0.Battle.BattleVariable.CameraPosToUICameraByRef(arg0_29._referenceVectorTemp)

		arg0_29._referenceVectorTemp.z = 2

		return arg0_29._referenceVectorTemp
	end
end

function var6_0.GetInitScale(arg0_30)
	return arg0_30._unitData:GetTemplate().scale / 50
end

function var6_0.AddUnitEvent(arg0_31)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.SPAWN_CACHE_BULLET, arg0_31.onSpawnCacheBullet)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.CREATE_TEMPORARY_WEAPON, arg0_31.onNewWeapon)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.POP_UP, arg0_31.onPopup)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.VOICE, arg0_31.onVoice)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.PLAY_FX, arg0_31.onPlayFX)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.REMOVE_WEAPON, arg0_31.onRemoveWeapon)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.ADD_BLINK, arg0_31.onBlink)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.SUBMARINE_VISIBLE, arg0_31.onUpdateDiveInvisible)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.SUBMARINE_DETECTED, arg0_31.onDetected)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.SUBMARINE_FORCE_DETECTED, arg0_31.onForceDetected)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.BLIND_VISIBLE, arg0_31.onUpdateBlindInvisible)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.BLIND_EXPOSE, arg0_31.onBlindExposed)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.INIT_ANIT_SUB_VIGILANCE, arg0_31.onInitVigilantState)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.INIT_CLOAK, arg0_31.onInitCloak)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.UPDATE_CLOAK_CONFIG, arg0_31.onUpdateCloakConfig)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.UPDATE_CLOAK_LOCK, arg0_31.onUpdateCloakLock)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.INIT_AIMBIAS, arg0_31.onInitAimBias)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.UPDATE_AIMBIAS_LOCK, arg0_31.onUpdateAimBiasLock)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.HOST_AIMBIAS, arg0_31.onHostAimBias)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.REMOVE_AIMBIAS, arg0_31.onRemoveAimBias)
	arg0_31._unitData:RegisterEventListener(arg0_31, var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE, arg0_31.onChangeSize)
	arg0_31._unitData:RegisterEventListener(arg0_31, var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_NEW_WEAPON, arg0_31.onNewWeapon)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.HIDE_WAVE_FX, arg0_31.RemoveWaveFX)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.ADD_BUFF_CLOCK, arg0_31.onAddBuffClock)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.SWITCH_SPINE, arg0_31.onSwitchSpine)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.SWITCH_SHADER, arg0_31.onSwitchShader)
	arg0_31._unitData:RegisterEventListener(arg0_31, var1_0.UPDATE_SCORE, arg0_31.onUpdateScore)

	local var0_31 = arg0_31._unitData:GetAutoWeapons()

	for iter0_31, iter1_31 in ipairs(var0_31) do
		arg0_31:RegisterWeaponListener(iter1_31)
	end

	arg0_31._effectOb:SetUnitDataEvent(arg0_31._unitData)
end

function var6_0.RemoveUnitEvent(arg0_32)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.UPDATE_HP)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.CREATE_TEMPORARY_WEAPON)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.CHANGE_ACTION)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.SPAWN_CACHE_BULLET)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.POP_UP)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.VOICE)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.PLAY_FX)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.REMOVE_WEAPON)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.ADD_BLINK)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.SUBMARINE_VISIBLE)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.SUBMARINE_DETECTED)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.SUBMARINE_FORCE_DETECTED)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.BLIND_VISIBLE)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.BLIND_EXPOSE)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.UPDATE_SCORE)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.CHANGE_ANTI_SUB_VIGILANCE)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.INIT_ANIT_SUB_VIGILANCE)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.ANTI_SUB_VIGILANCE_SONAR_CHECK)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.UPDATE_CLOAK_CONFIG)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.UPDATE_CLOAK_LOCK)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.INIT_CLOAK)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.HOST_AIMBIAS)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.UPDATE_AIMBIAS_LOCK)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.INIT_AIMBIAS)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.REMOVE_AIMBIAS)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.ADD_BUFF_CLOCK)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.SWITCH_SPINE)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var1_0.SWITCH_SHADER)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE)
	arg0_32._unitData:UnregisterEventListener(arg0_32, var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_NEW_WEAPON)

	for iter0_32, iter1_32 in pairs(arg0_32._weaponRegisterList) do
		arg0_32:UnregisterWeaponListener(iter0_32)
	end
end

function var6_0.Update(arg0_33)
	local var0_33 = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_33._bonePosSet = nil

	arg0_33:UpdateUIComponentPosition()
	arg0_33:UpdateHPPop()
	arg0_33:UpdateAniEffect(var0_33)
	arg0_33:UpdateTagEffect(var0_33)

	if arg0_33._referenceUpdateFlag then
		arg0_33:UpdateHPBarPosition()
		arg0_33:UpdateHPPopContainerPosition()
	end

	arg0_33:UpdateChatPosition()
	arg0_33:UpdateHpBar()
	arg0_33:updateSomkeFX()
	arg0_33:UpdateAimBiasBar()
	arg0_33:UpdateBuffClock()
	arg0_33:UpdateOrbit()
end

function var6_0.RegisterWeaponListener(arg0_34, arg1_34)
	if arg0_34._weaponRegisterList[arg1_34] then
		return
	end

	arg1_34:RegisterEventListener(arg0_34, var1_0.CREATE_BULLET, arg0_34.onCreateBullet)
	arg1_34:RegisterEventListener(arg0_34, var1_0.FIRE, arg0_34.onCannonFire)

	arg0_34._weaponRegisterList[arg1_34] = true
end

function var6_0.UnregisterWeaponListener(arg0_35, arg1_35)
	arg0_35._weaponRegisterList[arg1_35] = nil

	arg1_35:UnregisterEventListener(arg0_35, var1_0.CREATE_BULLET)
	arg1_35:UnregisterEventListener(arg0_35, var1_0.FIRE)
end

function var6_0.onCreateBullet(arg0_36, arg1_36)
	local var0_36 = arg1_36.Data.bullet
	local var1_36 = arg1_36.Data.spawnBound
	local var2_36 = arg1_36.Data.fireFxID
	local var3_36 = arg1_36.Data.position

	arg0_36:SpawnBullet(var0_36, var1_36, var2_36, var3_36)
end

function var6_0.onCannonFire(arg0_37, arg1_37)
	local var0_37 = arg1_37.Dispatcher
	local var1_37 = arg1_37.Data.target
	local var2_37 = arg1_37.Data.actionIndex or "attack"
	local var3_37 = arg0_37._unitData:NeedWeaponCache()
	local var4_37

	if not var3_37 then
		if arg0_37._cacheWeapon == nil then
			var4_37 = false
		else
			var4_37 = true
		end
	else
		arg0_37._cacheWeapon = {}
		var4_37 = true

		arg0_37._unitData:StateChange(var0_0.Battle.UnitState.STATE_ATTACK, var2_37)
	end

	if var4_37 == true then
		local var5_37 = {
			weapon = var0_37,
			target = var1_37,
			weapon = var0_37,
			target = var1_37
		}

		arg0_37._cacheWeapon[#arg0_37._cacheWeapon + 1] = var5_37
	else
		var0_37:DoAttack(var1_37)
	end
end

function var6_0.onSpawnCacheBullet(arg0_38)
	if arg0_38._cacheWeapon then
		for iter0_38, iter1_38 in ipairs(arg0_38._cacheWeapon) do
			iter1_38.weapon:DoAttack(iter1_38.target)

			if not arg0_38._unitData:IsAlive() then
				break
			end
		end

		arg0_38._cacheWeapon = nil
	end
end

function var6_0.onNewWeapon(arg0_39, arg1_39)
	local var0_39 = arg1_39.Data.weapon

	arg0_39:RegisterWeaponListener(var0_39)
end

function var6_0.onPopup(arg0_40, arg1_40)
	local var0_40 = arg1_40.Data
	local var1_40 = var0_40.content
	local var2_40 = var0_40.duration
	local var3_40 = var0_40.key

	arg0_40:SetPopup(var1_40, var2_40, var3_40)
end

function var6_0.onVoice(arg0_41, arg1_41)
	local var0_41 = arg1_41.Data
	local var1_41 = var0_41.content
	local var2_41 = var0_41.key

	arg0_41:Voice(var1_41, var2_41)
end

function var6_0.onPlayFX(arg0_42, arg1_42)
	local var0_42 = arg1_42.Data.fxName

	if arg1_42.Data.notAttach then
		arg0_42:PlayFX(var0_42)
	else
		arg0_42:AddFX(var0_42)
	end
end

function var6_0.onRemoveWeapon(arg0_43, arg1_43)
	local var0_43 = arg1_43.Data.weapon

	if arg0_43._cacheWeapon then
		for iter0_43, iter1_43 in ipairs(arg0_43._cacheWeapon) do
			if iter1_43.weapon == var0_43 then
				table.remove(arg0_43._cacheWeapon, iter0_43)

				break
			end
		end
	end

	arg0_43:UnregisterWeaponListener(var0_43)
end

function var6_0.onBlink(arg0_44, arg1_44)
	local var0_44 = arg1_44.Data.blink
	local var1_44 = var0_44.red
	local var2_44 = var0_44.green
	local var3_44 = var0_44.blue
	local var4_44 = var0_44.alpha
	local var5_44 = var0_44.peroid
	local var6_44 = var0_44.duration

	arg0_44:AddBlink(var1_44, var2_44, var3_44, var5_44, var6_44, true, var4_44)
end

function var6_0.onUpdateDiveInvisible(arg0_45, arg1_45)
	arg0_45:UpdateDiveInvisible()
end

function var6_0.UpdateDiveInvisible(arg0_46, arg1_46)
	if not arg0_46._go then
		return
	end

	local var0_46 = not arg0_46._unitData:GetForceExpose() and arg0_46._unitData:GetDiveInvisible()
	local var1_46 = arg0_46._unitData:GetIFF() == var3_0.FOE_CODE

	if var0_46 then
		local var2_46 = arg0_46:GetFactory():GetDivingFilterColor()

		arg0_46:updateInvisible(var0_46, var1_46 and "GRID_TRANSPARENT" or "SEMI_TRANSPARENT", var2_46)

		if not arg1_46 and var1_46 then
			arg0_46:spineSemiTransparentFade(0, 0.7, 0)
		end
	else
		arg0_46:updateInvisible(var0_46)

		if not var1_46 then
			arg0_46:AddShaderColor()
		end
	end

	if var1_46 then
		arg0_46:updateComponentVisible()
	end
end

function var6_0.onUpdateBlindInvisible(arg0_47, arg1_47)
	arg0_47:UpdateBlindInvisible()
end

function var6_0.UpdateBlindInvisible(arg0_48)
	local var0_48 = arg0_48._unitData:GetExposed()

	arg0_48:GetTf():GetComponent(typeof(Renderer)).enabled = var0_48

	arg0_48:updateComponentVisible()
end

function var6_0.updateInvisible(arg0_49, arg1_49, arg2_49, arg3_49)
	if arg1_49 then
		arg0_49:SwitchShader(arg2_49, arg3_49)
		arg0_49._animator:ChangeRenderQueue(2999)
	else
		arg0_49:SwitchShader("COLORED_ALPHA")
		arg0_49._animator:ChangeRenderQueue(3000)
	end

	if arg0_49._waveFX then
		SetActive(arg0_49._waveFX.transform, not arg1_49)
	end
end

function var6_0.onDetected(arg0_50, arg1_50)
	if not arg0_50._go then
		return
	end

	if arg0_50._unitData:GetDiveDetected() and arg0_50._unitData:GetIFF() == var3_0.FOE_CODE then
		arg0_50._shockFX = arg0_50:AddFX("shock", true, true)
	else
		arg0_50:RemoveCacheFX("shock")
	end

	if arg0_50._unitData:GetIFF() == var3_0.FOE_CODE then
		arg0_50:UpdateCharacterDetected()
	end

	arg0_50:updateComponentVisible()
end

function var6_0.UpdateCharacterDetected(arg0_51)
	if arg0_51._unitData:GetIFF() == var3_0.FRIENDLY_CODE or arg0_51._unitData:GetDiveDetected() then
		arg0_51:spineSemiTransparentFade(0, 0.7, var3_0.SUB_FADE_IN_DURATION)
	else
		arg0_51:spineSemiTransparentFade(0.7, 0, var3_0.SUB_FADE_OUT_DURATION)
	end
end

function var6_0.onForceDetected(arg0_52, arg1_52)
	arg0_52:UpdateCharacterForceDetected()
end

function var6_0.UpdateCharacterForceDetected(arg0_53)
	if arg0_53._unitData:GetIFF() == var3_0.FOE_CODE and arg0_53._unitData:GetForceExpose() then
		arg0_53:spineSemiTransparentFade(0, 0.7, var3_0.SUB_FADE_IN_DURATION)
		arg0_53:updateComponentVisible()
	end
end

function var6_0.onBlindExposed(arg0_54, arg1_54)
	local var0_54 = arg0_54._unitData:GetExposed()

	arg0_54:GetTf():GetComponent(typeof(Renderer)).enabled = var0_54

	arg0_54:updateComponentVisible()
end

function var6_0.updateComponentVisible(arg0_55)
	local var0_55

	if arg0_55._unitData:GetIFF() ~= var3_0.FOE_CODE then
		var0_55 = arg0_55._unitData:GetAttrByName(var0_0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY) > var3_0.FUSION_ELEMENT_UNIT_TYPE
	else
		local var1_55 = arg0_55._unitData:GetExposed()
		local var2_55 = arg0_55._unitData:GetDiveDetected()
		local var3_55 = arg0_55._unitData:GetDiveInvisible()

		var0_55 = arg0_55._unitData:GetForceExpose() or var1_55 and (not var3_55 or not not var2_55)
	end

	SetActive(arg0_55._arrowBarTf, var0_55)
	SetActive(arg0_55._HPBarTf, var0_55)
	SetActive(arg0_55._FXAttachPoint, var0_55)
	SetActive(arg0_55._hpPopContainerTF, var0_55)

	if arg0_55._hpCloakBar then
		arg0_55._hpCloakBar:SetActive(var0_55)
	end

	if arg0_55._cloakBar then
		arg0_55._cloakBar:SetActive(var0_55)
	end

	if arg0_55._aimBiarBar then
		arg0_55._aimBiarBar:SetActive(var0_55)
	end
end

function var6_0.updateComponentDiveInvisible(arg0_56)
	local var0_56 = arg0_56._unitData:GetDiveDetected() and arg0_56._unitData:GetIFF() == var3_0.FOE_CODE
	local var1_56 = arg0_56._unitData:GetDiveInvisible()
	local var2_56
	local var3_56 = (var0_56 or not var1_56) and true or false

	SetActive(arg0_56._arrowBarTf, var3_56)
	SetActive(arg0_56._HPBarTf, var3_56)
	SetActive(arg0_56._FXAttachPoint, var3_56)
end

function var6_0.updateComponentBlindInvisible(arg0_57)
	local var0_57 = arg0_57._unitData:GetExposed()

	arg0_57:GetTf():GetComponent(typeof(Renderer)).enabled = var0_57

	SetActive(arg0_57._arrowBarTf, var0_57)
	SetActive(arg0_57._HPBarTf, var0_57)
	SetActive(arg0_57._FXAttachPoint, var0_57)
end

function var6_0.spineSemiTransparentFade(arg0_58, arg1_58, arg2_58, arg3_58)
	LeanTween.cancel(arg0_58._go)
	onDelayTick(function()
		if not arg0_58._go then
			return
		end

		arg3_58 = arg3_58 or 0

		SpineAnim.ShaderTransparentFade(arg0_58._go, arg2_58, arg1_58, arg3_58, "_Invisible")
	end, 0.06)
end

function var6_0.onInitVigilantState(arg0_60, arg1_60)
	arg0_60._factory:MakeVigilantBar(arg0_60)

	range = arg1_60.Data.sonarRange * 0.5

	local var0_60 = arg0_60:AddFX("AntiSubArea", true).transform

	var0_60.localScale = Vector3(range, 0, range)

	local function var1_60()
		local var0_61 = var0_60:Find("Quad"):GetComponent(typeof(Animator))

		var0_61.enabled = true

		var0_61:Play("antiSubZoom", -1, 0)
	end

	arg0_60._unitData:RegisterEventListener(arg0_60, var1_0.CHANGE_ANTI_SUB_VIGILANCE, arg0_60.onVigilantStateChange)
	arg0_60._unitData:RegisterEventListener(arg0_60, var1_0.ANTI_SUB_VIGILANCE_SONAR_CHECK, var1_60)
end

function var6_0.onVigilantStateChange(arg0_62, arg1_62)
	arg0_62:updateVigilantMark()
end

function var6_0.updateVigilantMark(arg0_63)
	if arg0_63._vigilantBar then
		arg0_63._vigilantBar:UpdateVigilantMark()
	end
end

function var6_0.OnActionChange(arg0_64, arg1_64)
	local var0_64 = arg1_64.Data.actionType

	arg0_64:PlayAction(var0_64)
end

function var6_0.PlayAction(arg0_65, arg1_65)
	arg0_65._animator:SetAction(arg1_65, 0, var2_0.ActionLoop[arg1_65])

	arg0_65._actionIndex = arg1_65

	if arg1_65 == var2_0.ActionName.VICTORY or arg1_65 == var2_0.ActionName.VICTORY_SWIM then
		arg0_65._effectOb:ClearEffect()
	end

	if #arg0_65._orbitActionUpdateList > 0 then
		for iter0_65, iter1_65 in ipairs(arg0_65._orbitActionUpdateList) do
			local var0_65 = iter1_65.orbit
			local var1_65 = iter1_65.change
			local var2_65 = var1_65.condition.param
			local var3_65 = false

			for iter2_65, iter3_65 in ipairs(var2_65) do
				if string.find(arg1_65, iter3_65) then
					var3_65 = true

					break
				end
			end

			if var3_65 then
				arg0_65:changeOrbitAction(var0_65, var1_65)

				break
			end
		end
	end
end

function var6_0.SetAnimaSpeed(arg0_66, arg1_66)
	arg0_66._skeleton = arg0_66._skeleton or arg0_66:GetTf():GetComponent("SkeletonAnimation")
	arg1_66 = arg1_66 or 1
	arg0_66._skeleton.timeScale = arg1_66
end

function var6_0.UpdatePosition(arg0_67)
	if not arg0_67._go then
		return
	end

	local var0_67 = arg0_67._unitData:GetPosition()

	if arg0_67._unitData:GetSpeed() == Vector3.zero and arg0_67._characterPos == var0_67 then
		return
	end

	arg0_67._characterPos = var0_67
	arg0_67._tf.localPosition = arg0_67:getCharacterPos()
end

function var6_0.getCharacterPos(arg0_68)
	return arg0_68._characterPos
end

function var6_0.UpdateMatrix(arg0_69)
	arg0_69._bonePosTable = nil
	arg0_69._posMatrix = nil
end

function var6_0.UpdateUIComponentPosition(arg0_70)
	local var0_70 = arg0_70._unitData:GetPosition()

	arg0_70._referenceVector:Set(var0_70.x, var0_70.y, var0_70.z)
	var0_0.Battle.BattleVariable.CameraPosToUICameraByRef(arg0_70._referenceVector)

	arg0_70._referenceVector.z = 10
	arg0_70._referenceUpdateFlag = not arg0_70._referenceVector:Equals(arg0_70._referenceVectorCache)

	if arg0_70._referenceUpdateFlag then
		arg0_70._referenceVectorCache:Copy(arg0_70._referenceVector)
	end
end

function var6_0.UpdateHPPopContainerPosition(arg0_71)
	arg0_71._hpPopContainerTF.position = arg0_71._referenceVector
end

function var6_0.UpdateHPBarPosition(arg0_72)
	if not arg0_72._hideHP then
		arg0_72._hpBarPos:Copy(arg0_72._referenceVector):Add(arg0_72._hpBarOffset)

		arg0_72._HPBarTf.position = arg0_72._hpBarPos
	end
end

function var6_0.SetBarHidden(arg0_73, arg1_73, arg2_73)
	arg0_73._alwaysHideArrow = arg1_73
	arg0_73._hideHP = arg2_73

	if arg0_73._arrowBar then
		if arg0_73._alwaysHideArrow then
			arg0_73._arrowBarTf.anchoredPosition = var7_0
		else
			arg0_73._arrowBarTf.position = arg0_73._arrowVector
		end
	end
end

function var6_0.UpdateCastClockPosition(arg0_74)
	arg0_74._castClock:UpdateCastClockPosition(arg0_74._referenceVector)
end

function var6_0.UpdateBarrierClockPosition(arg0_75)
	arg0_75._barrierClock:UpdateBarrierClockPosition(arg0_75._referenceVector)
end

function var6_0.SetArrowPoint(arg0_76)
	arg0_76._arrowVector:Set()

	arg0_76._cameraUtil = var0_0.Battle.BattleCameraUtil.GetInstance()
	arg0_76._arrowCenterPos = arg0_76._cameraUtil:GetArrowCenterPos()
end

local var9_0 = Vector3(-1, 1, 1)
local var10_0 = Vector3(1, 1, 1)

function var6_0.UpdateArrowBarPostition(arg0_77)
	local var0_77 = arg0_77._cameraUtil:GetCharacterArrowBarPosition(arg0_77._referenceVector, arg0_77._arrowVector)

	if not var0_77 then
		if not arg0_77._inViewArea then
			arg0_77._inViewArea = true
			arg0_77._arrowBarTf.anchoredPosition = var7_0
		end
	else
		local var1_77 = arg0_77._unitData:GetBornPosition()

		if var1_77 and var1_77 ~= arg0_77._unitData:GetPosition() then
			var0_77 = arg0_77._cameraUtil:GetCharacterArrowBarPosition(arg0_77._referenceVectorBorn, arg0_77._arrowVector)
		end

		arg0_77._arrowVector = var0_77
		arg0_77._inViewArea = false

		if not arg0_77._alwaysHideArrow then
			arg0_77._arrowBarTf.position = arg0_77._arrowVector

			if arg0_77._arrowVector.x > 0 then
				arg0_77._arrowBarTf.localScale = var9_0
			else
				arg0_77._arrowBarTf.localScale = var10_0
			end
		end
	end
end

function var6_0.UpdateArrowBarRotation(arg0_78)
	if arg0_78._inViewArea then
		return
	end

	local var0_78 = arg0_78._arrowVector.x
	local var1_78 = arg0_78._arrowVector.y
	local var2_78 = math.rad2Deg * math.atan2(var1_78 - arg0_78._arrowCenterPos.y, var0_78 - arg0_78._arrowCenterPos.x)

	arg0_78._arrowAngleVector.z = var2_78
	arg0_78._arrowBarTf.eulerAngles = arg0_78._arrowAngleVector
end

function var6_0.UpdateChatPosition(arg0_79)
	if not arg0_79._popGO then
		return
	end

	if arg0_79._inViewArea then
		arg0_79._popTF.position = arg0_79:GetReferenceVector()
	else
		arg0_79._popTF.position = arg0_79._arrowVector + var8_0
	end
end

function var6_0.Dispose(arg0_80)
	if arg0_80._popGO then
		LeanTween.cancel(arg0_80._popGO)
	end

	if arg0_80._popNumBundle then
		arg0_80._hpPopContainerTF = nil

		arg0_80._popNumBundle:Clear()

		arg0_80._popNumBundle = nil
	end

	arg0_80._popNumPool = nil

	Object.Destroy(arg0_80._popGO)

	if arg0_80._voicePlaybackInfo then
		arg0_80._voicePlaybackInfo:PlaybackStop()
	end

	if arg0_80._cloakBar then
		arg0_80._cloakBar:Dispose()

		arg0_80._cloakBar = nil
		arg0_80._cloakBarTf = nil
	end

	if arg0_80._aimBiarBar then
		arg0_80._aimBiarBar:Dispose()

		arg0_80._aimBiarBar = nil
	end

	if arg0_80._buffClock then
		arg0_80._buffClock:Dispose()

		arg0_80._buffClock = nil
	end

	arg0_80._voicePlaybackInfo = nil
	arg0_80._popGO = nil
	arg0_80._popTF = nil
	arg0_80._cacheWeapon = nil

	for iter0_80, iter1_80 in pairs(arg0_80._allFX) do
		var4_0.GetInstance():DestroyOb(iter0_80)
	end

	for iter2_80, iter3_80 in pairs(arg0_80._orbitList) do
		var4_0.GetInstance():DestroyOb(iter2_80)
	end

	arg0_80._orbitList = nil
	arg0_80._orbitActionCacheList = nil
	arg0_80._orbitSpeedUpdateList = nil
	arg0_80._orbitActionUpdateList = nil

	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_80._voiceTimer)

	arg0_80._voiceTimer = nil

	arg0_80._effectOb:RemoveUnitEvent(arg0_80._unitData)
	arg0_80._effectOb:Dispose()

	arg0_80._HPProgressBar = nil
	arg0_80._HPProgress = nil

	arg0_80._factory:GetHPBarPool():DestroyObj(arg0_80._HPBar)

	arg0_80._HPBar = nil
	arg0_80._HPBarTf = nil
	arg0_80._arrowBar = nil
	arg0_80._arrowBarTf = nil

	if arg0_80._animator then
		arg0_80._animator:ClearOverrideMaterial()

		arg0_80._animator = nil
	end

	arg0_80._skeleton = nil
	arg0_80._posMatrix = nil
	arg0_80._shockFX = nil
	arg0_80._waveFX = nil

	arg0_80:RemoveUnitEvent()
	var0_0.EventListener.DetachEventListener(arg0_80)

	arg0_80._bulletFactoryList = nil

	for iter4_80, iter5_80 in pairs(arg0_80._tagFXList) do
		iter5_80:Dispose()
	end

	arg0_80._tagFXList = nil
	arg0_80._weaponRegisterList = nil

	var6_0.super.Dispose(arg0_80)
end

function var6_0.AddModel(arg0_81, arg1_81)
	arg0_81:SetGO(arg1_81)

	arg0_81._hpBarOffset = Vector3(0, arg0_81._unitData:GetBoxSize().y, 0)
	arg0_81._animator = arg0_81:GetTf():GetComponent(typeof(SpineAnim))

	if arg0_81._animator then
		arg0_81._animator:Start()
	end

	arg0_81:SetBoneList()
	arg0_81:UpdateMatrix()
	arg0_81._unitData:ActiveCldBox()

	local var0_81 = arg0_81:GetInitScale()

	arg0_81._tf.localScale = Vector3(var0_81 * arg0_81._unitData:GetDirection(), var0_81, var0_81)

	local var1_81 = arg0_81._unitData:GetOxyState()

	if var1_81 and var1_81:GetCurrentDiveState() == var0_0.Battle.BattleConst.OXY_STATE.DIVE then
		arg0_81:PlayAction(var0_0.Battle.BattleConst.ActionName.DIVE)
	else
		arg0_81:PlayAction(var0_0.Battle.BattleConst.ActionName.MOVE)
	end

	arg0_81._animator:SetActionCallBack(function(arg0_82)
		if arg0_82 == "finish" then
			arg0_81:OnAnimatorEnd()
		elseif arg0_82 == "action" then
			arg0_81:OnAnimatorTrigger()
		end
	end)
	arg0_81._unitData:RegisterEventListener(arg0_81, var1_0.CHANGE_ACTION, arg0_81.OnActionChange)
end

function var6_0.SwitchModel(arg0_83, arg1_83, arg2_83)
	local var0_83 = arg0_83._go

	arg0_83:SetGO(arg1_83)

	arg0_83._animator = arg0_83:GetTf():GetComponent(typeof(SpineAnim))

	if arg0_83._animator then
		arg0_83._animator:Start()
	end

	arg0_83:SetBoneList()

	arg0_83._tf.position = arg0_83._unitData:GetPosition()

	arg0_83:UpdateMatrix()

	arg0_83._hpBarOffset.y = arg0_83._hpBarOffset.y + arg0_83._coverSpineHPBarOffset

	arg0_83:UpdateHPBarPosition()

	local var1_83 = arg0_83:GetInitScale()

	arg0_83._tf.localScale = Vector3(var1_83 * arg0_83._unitData:GetDirection(), var1_83, var1_83)

	arg0_83._animator:SetActionCallBack(function(arg0_84)
		if arg0_84 == "finish" then
			arg0_83:OnAnimatorEnd()
		elseif arg0_84 == "action" then
			arg0_83:OnAnimatorTrigger()
		end
	end)
	arg0_83:SwitchShader(arg0_83._shaderType, arg0_83._color)

	local var2_83 = {}
	local var3_83 = {}

	for iter0_83, iter1_83 in pairs(arg0_83._blinkDict) do
		local var4_83 = SpineAnim.CharBlink(arg0_83._go, iter1_83.r, iter1_83.g, iter1_83.b, iter1_83.a, iter1_83.peroid, iter1_83.duration, false)

		var2_83[var4_83] = iter1_83
		var3_83[iter0_83] = var4_83
	end

	arg0_83._blinkDict = var2_83

	arg0_83:PlayAction(arg0_83._actionIndex)

	if not arg2_83 then
		for iter2_83, iter3_83 in pairs(arg0_83._orbitList) do
			SpineAnim.AddFollower(iter3_83.boundBone, arg0_83._tf, iter2_83.transform):GetComponent("Spine.Unity.BoneFollower").followBoneRotation = false
		end
	end

	arg0_83._effectOb:SwitchOwner(arg0_83, var3_83)
	arg0_83._FXAttachPoint.transform:SetParent(arg0_83:GetTf(), false)
	var4_0.GetInstance():DestroyOb(var0_83)
end

function var6_0.AddOrbit(arg0_85, arg1_85, arg2_85)
	local var0_85 = arg2_85.orbit_combat_bound[1]
	local var1_85 = arg2_85.orbit_combat_bound[2]
	local var2_85 = arg2_85.orbit_hidden_action

	arg1_85.transform.localPosition = Vector3(var1_85[1], var1_85[2], var1_85[3])

	local var3_85 = SpineAnim.AddFollower(var0_85, arg0_85._tf, arg1_85.transform):GetComponent("Spine.Unity.BoneFollower")

	if arg2_85.orbit_rotate then
		var3_85.followBoneRotation = true

		local var4_85 = arg1_85.transform.localEulerAngles

		arg1_85.transform.localEulerAngles = Vector3(var4_85.x, var4_85.y, var4_85.z - 90)
	else
		var3_85.followBoneRotation = false
	end

	arg0_85._orbitList[arg1_85] = {
		hiddenAction = var2_85,
		boundBone = var0_85
	}

	local var5_85 = arg2_85.orbit_combat_anima_change.default

	if var5_85 then
		arg0_85:changeOrbitAction(arg1_85, var5_85)

		for iter0_85, iter1_85 in ipairs(arg2_85.orbit_combat_anima_change.change) do
			if iter1_85.condition.type == 1 then
				table.insert(arg0_85._orbitSpeedUpdateList, {
					orbit = arg1_85,
					change = Clone(iter1_85)
				})
			elseif iter1_85.condition.type == 2 then
				table.insert(arg0_85._orbitActionUpdateList, {
					orbit = arg1_85,
					change = Clone(iter1_85)
				})
			end
		end
	end
end

function var6_0.changeOrbitAction(arg0_86, arg1_86, arg2_86)
	for iter0_86, iter1_86 in ipairs(arg2_86) do
		local var0_86 = arg1_86.transform:Find(iter1_86.node)

		if var0_86 then
			SetActive(var0_86, iter1_86.active)

			if iter1_86.active and arg0_86._orbitActionCacheList[var0_86] ~= iter1_86.activate then
				local var1_86 = iter1_86.activate

				var0_86:GetComponent(typeof(Animator)):SetBool("activate", var1_86)

				arg0_86._orbitActionCacheList[var0_86] = iter1_86.activate
			end
		end
	end
end

function var6_0.UpdateOrbit(arg0_87)
	if #arg0_87._orbitSpeedUpdateList <= 0 then
		return
	end

	local var0_87 = arg0_87._unitData:GetSpeed():Magnitude()

	for iter0_87, iter1_87 in pairs(arg0_87._orbitSpeedUpdateList) do
		local var1_87 = iter1_87.orbit
		local var2_87 = iter1_87.change
		local var3_87 = var2_87.condition.param
		local var4_87 = true

		for iter2_87, iter3_87 in ipairs(var3_87) do
			var4_87 = var5_0.simpleCompare(iter3_87, var0_87) and var4_87
		end

		if var4_87 then
			arg0_87:changeOrbitAction(var1_87, var2_87)
		end
	end
end

function var6_0.AddSmokeFXs(arg0_88, arg1_88)
	arg0_88._smokeList = arg1_88

	arg0_88:updateSomkeFX()
end

function var6_0.AddShadow(arg0_89, arg1_89)
	arg0_89._shadow = arg1_89
end

function var6_0.AddHPBar(arg0_90, arg1_90)
	arg0_90._HPBar = arg1_90
	arg0_90._HPBarTf = arg1_90.transform
	arg0_90._HPProgressBar = arg0_90._HPBarTf:Find("blood")
	arg0_90._HPProgress = arg0_90._HPProgressBar:GetComponent(typeof(Image))

	arg0_90._unitData:RegisterEventListener(arg0_90, var1_0.UPDATE_HP, arg0_90.OnUpdateHP)

	arg0_90._HPBarTf.position = arg0_90._referenceVector + arg0_90._hpBarOffset
end

function var6_0.AddUIComponentContainer(arg0_91, arg1_91)
	arg0_91:UpdateUIComponentPosition()
end

function var6_0.AddPopNumPool(arg0_92, arg1_92)
	arg0_92._popNumPool = arg1_92
	arg0_92._hpPopIndex_put = 1
	arg0_92._hpPopIndex_get = 1
	arg0_92._hpPopCount = 0
	arg0_92._hpPopCatch = {}
	arg0_92._popNumBundle = arg0_92._popNumPool:GetBundle(arg0_92._unitData:GetUnitType())
	arg0_92._hpPopContainerTF = arg0_92._popNumBundle:GetContainer().transform
end

function var6_0.AddArrowBar(arg0_93, arg1_93)
	arg0_93._arrowBar = arg1_93
	arg0_93._arrowBarTf = arg1_93.transform

	arg0_93:SetArrowPoint()
end

function var6_0.AddCastClock(arg0_94, arg1_94)
	local var0_94 = arg1_94.transform

	SetActive(var0_94, false)

	arg0_94._castClock = var0_0.Battle.BattleCastBar.New(var0_94)

	arg0_94:UpdateCastClockPosition()
end

function var6_0.AddBuffClock(arg0_95, arg1_95)
	local var0_95 = arg1_95.transform

	SetActive(var0_95, false)

	arg0_95._buffClock = var0_0.Battle.BattleBuffClock.New(var0_95)
end

function var6_0.AddBarrierClock(arg0_96, arg1_96)
	local var0_96 = arg1_96.transform

	SetActive(var0_96, false)

	arg0_96._barrierClock = var0_0.Battle.BattleBarrierBar.New(var0_96)

	arg0_96:UpdateBarrierClockPosition()
end

function var6_0.AddVigilantBar(arg0_97, arg1_97)
	arg0_97._vigilantBar = var0_0.Battle.BattleVigilantBar.New(arg1_97.transform)

	arg0_97._vigilantBar:ConfigVigilant(arg0_97._unitData:GetAntiSubState())
	arg0_97._vigilantBar:UpdateVigilantProgress()
	arg0_97:updateVigilantMark()
end

function var6_0.UpdateVigilantBarPosition(arg0_98)
	arg0_98._vigilantBar:UpdateVigilantBarPosition(arg0_98._hpBarPos)
end

function var6_0.AddCloakBar(arg0_99, arg1_99)
	arg0_99._cloakBarTf = arg1_99.transform
	arg0_99._cloakBar = var0_0.Battle.BattleCloakBar.New(arg0_99._cloakBarTf)

	arg0_99._cloakBar:ConfigCloak(arg0_99._unitData:GetCloak())
	arg0_99._cloakBar:UpdateCloakProgress()
end

function var6_0.UpdateCloakBarPosition(arg0_100, arg1_100)
	if arg0_100._inViewArea then
		arg0_100._cloakBarTf.anchoredPosition = var7_0
	else
		arg0_100._cloakBar:UpdateCloarBarPosition(arg0_100._arrowVector)
	end
end

function var6_0.onInitCloak(arg0_101, arg1_101)
	arg0_101._factory:MakeCloakBar(arg0_101)
end

function var6_0.onUpdateCloakConfig(arg0_102, arg1_102)
	arg0_102._cloakBar:UpdateCloakConfig()
end

function var6_0.onUpdateCloakLock(arg0_103, arg1_103)
	arg0_103._cloakBar:UpdateCloakLock()
end

function var6_0.AddAimBiasBar(arg0_104, arg1_104)
	arg0_104._aimBiarBarTF = arg1_104
	arg0_104._aimBiarBar = var0_0.Battle.BattleAimbiasBar.New(arg1_104)

	arg0_104._aimBiarBar:ConfigAimBias(arg0_104._unitData:GetAimBias())
	arg0_104._aimBiarBar:UpdateAimBiasProgress()
end

function var6_0.UpdateAimBiasBar(arg0_105)
	if arg0_105._aimBiarBar then
		arg0_105._aimBiarBar:UpdateAimBiasProgress()
	end
end

function var6_0.UpdateBuffClock(arg0_106)
	if arg0_106._buffClock and arg0_106._buffClock:IsActive() then
		arg0_106._buffClock:UpdateCastClockPosition(arg0_106._referenceVector)
		arg0_106._buffClock:UpdateCastClock()
	end
end

function var6_0.onUpdateAimBiasLock(arg0_107, arg1_107)
	arg0_107._aimBiarBar:UpdateLockStateView()
end

function var6_0.onInitAimBias(arg0_108, arg1_108)
	if arg0_108._unitData:GetAimBias():GetHost() == arg0_108._unitData then
		arg0_108._factory:MakeAimBiasBar(arg0_108)
	end
end

function var6_0.onHostAimBias(arg0_109, arg1_109)
	arg0_109._factory:MakeAimBiasBar(arg0_109)
end

function var6_0.onRemoveAimBias(arg0_110, arg1_110)
	arg0_110._aimBiarBar:SetActive(false)
	arg0_110._aimBiarBar:Dispose()

	arg0_110._aimBiarBar = nil
	arg0_110._aimBiarBarTF = nil
end

function var6_0.AddAimBiasFogFX(arg0_111)
	local var0_111 = arg0_111._unitData:GetTemplate().fog_fx

	if var0_111 and var0_111 ~= "" then
		arg0_111._fogFx = arg0_111:AddFX(var0_111)
	end
end

function var6_0.OnUpdateHP(arg0_112, arg1_112)
	arg0_112:_DealHPPop(arg1_112.Data)
end

function var6_0._DealHPPop(arg0_113, arg1_113)
	if arg0_113._hpPopIndex_put == arg0_113._hpPopIndex_get and arg0_113._hpPopCount == 0 then
		arg0_113:_PlayHPPop(arg1_113)

		arg0_113._hpPopCount = 1
	elseif arg0_113._unitData:IsAlive() then
		arg0_113._hpPopCatch[arg0_113._hpPopIndex_put] = arg1_113
		arg0_113._hpPopIndex_put = arg0_113._hpPopIndex_put + 1
	else
		arg0_113:_PlayHPPop(arg1_113)
	end
end

function var6_0.UpdateHPPop(arg0_114)
	if arg0_114._hpPopIndex_put == arg0_114._hpPopIndex_get then
		return
	else
		arg0_114._hpPopCount = arg0_114._hpPopCount + 1

		if arg0_114:_CalcHPPopCount() <= arg0_114._hpPopCount then
			arg0_114:_PlayHPPop(arg0_114._hpPopCatch[arg0_114._hpPopIndex_get])

			arg0_114._hpPopCatch[arg0_114._hpPopIndex_get] = nil
			arg0_114._hpPopIndex_get = arg0_114._hpPopIndex_get + 1
			arg0_114._hpPopCount = 0
		end
	end
end

function var6_0._PlayHPPop(arg0_115, arg1_115)
	if arg0_115._popNumBundle:IsScorePop() then
		return
	end

	local var0_115 = arg1_115.dHP
	local var1_115 = arg1_115.isCri
	local var2_115 = arg1_115.isMiss
	local var3_115 = arg1_115.isHeal
	local var4_115 = arg1_115.posOffset or Vector3.zero
	local var5_115 = arg1_115.font
	local var6_115 = arg0_115._popNumBundle:GetPop(var3_115, var1_115, var2_115, var0_115, var5_115)

	var6_115:SetReferenceCharacter(arg0_115, var4_115)
	var6_115:Play()
end

function var6_0._CalcHPPopCount(arg0_116)
	if arg0_116._hpPopIndex_put - arg0_116._hpPopIndex_get > 5 then
		return 1
	else
		return 5
	end
end

function var6_0.onUpdateScore(arg0_117, arg1_117)
	local var0_117 = arg1_117.Data.score
	local var1_117 = arg0_117._popNumBundle:GetScorePop(var0_117)

	var1_117:SetReferenceCharacter(arg0_117, Vector3.zero)
	var1_117:Play()
end

function var6_0.UpdateHpBar(arg0_118)
	local var0_118 = arg0_118._unitData:GetCurrentHP()

	if arg0_118._HPProgress and arg0_118._cacheHP ~= var0_118 then
		local var1_118 = arg0_118._unitData:GetHPRate()

		arg0_118._HPProgress.fillAmount = var1_118
		arg0_118._cacheHP = var0_118
	end
end

function var6_0.onChangeSize(arg0_119, arg1_119)
	arg0_119:doChangeSize(arg1_119)
end

function var6_0.updateSomkeFX(arg0_120)
	local var0_120 = arg0_120._unitData:GetHPRate()

	for iter0_120, iter1_120 in ipairs(arg0_120._smokeList) do
		if var0_120 < iter1_120.rate then
			if iter1_120.active == false then
				iter1_120.active = true

				local var1_120 = iter1_120.smokes

				for iter2_120, iter3_120 in pairs(var1_120) do
					if iter2_120.unInitialize then
						local var2_120 = arg0_120:AddFX(iter2_120.resID)

						var2_120.transform.localPosition = iter2_120.pos
						var1_120[iter2_120] = var2_120

						SetActive(var2_120, true)

						iter2_120.unInitialize = false
					else
						SetActive(iter3_120, true)
					end
				end
			end
		elseif iter1_120.active == true then
			iter1_120.active = false

			local var3_120 = iter1_120.smokes

			for iter4_120, iter5_120 in pairs(var3_120) do
				if iter4_120.unInitialize then
					-- block empty
				else
					SetActive(iter5_120, false)
				end
			end
		end
	end
end

function var6_0.doChangeSize(arg0_121, arg1_121)
	local var0_121 = arg1_121.Data.size_ratio

	arg0_121._tf.localScale = arg0_121._tf.localScale * var0_121
end

function var6_0.InitEffectView(arg0_122)
	arg0_122._effectOb = var0_0.Battle.BattleEffectComponent.New(arg0_122)
end

function var6_0.UpdateAniEffect(arg0_123, arg1_123)
	arg0_123._effectOb:Update(arg1_123)
end

function var6_0.UpdateTagEffect(arg0_124, arg1_124)
	local var0_124 = arg0_124._unitData:GetBoxSize().y * 0.5

	for iter0_124, iter1_124 in pairs(arg0_124._tagFXList) do
		iter1_124:Update(arg1_124)
		iter1_124:SetPosition(arg0_124._referenceVector + Vector3(0, var0_124, 0))
	end
end

function var6_0.SetPopup(arg0_125, arg1_125, arg2_125, arg3_125)
	if arg0_125._voiceTimer then
		if arg0_125._voiceKey == arg3_125 then
			arg0_125._voiceKey = nil
		else
			return
		end
	end

	if arg0_125._popGO then
		LeanTween.cancel(arg0_125._popGO)
		LeanTween.scale(rtf(arg0_125._popGO.gameObject), Vector3.New(0, 0, 1), 0.1):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function()
			arg0_125:chatPop(arg1_125, arg2_125)
		end))
	else
		arg0_125._popGO = arg0_125._factory:MakePopup()
		arg0_125._popTF = arg0_125._popGO.transform
		arg0_125._popTF.localScale = Vector3(0, 0, 0)

		arg0_125:chatPop(arg1_125, arg2_125)
	end

	SetActive(arg0_125._popGO, true)
end

function var6_0.chatPop(arg0_127, arg1_127, arg2_127)
	arg2_127 = arg2_127 or 2.5

	local var0_127 = findTF(arg0_127._popGO, "Text"):GetComponent(typeof(Text))

	setTextEN(var0_127, arg1_127)

	if #var0_127.text > CHAT_POP_STR_LEN then
		var0_127.alignment = TextAnchor.MiddleLeft
	else
		var0_127.alignment = TextAnchor.MiddleCenter
	end

	LeanTween.scale(rtf(arg0_127._popGO.gameObject), Vector3.New(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_127._popGO.gameObject), Vector3.New(0, 0, 1), 0.3):setEase(LeanTweenType.easeInBack):setDelay(arg2_127):setOnComplete(System.Action(function()
			SetActive(arg0_127._popGO, false)
		end))
	end))
end

function var6_0.Voice(arg0_130, arg1_130, arg2_130)
	if arg0_130._voiceTimer then
		return
	end

	pg.CriMgr.GetInstance():PlayMultipleSound_V3(arg1_130, function(arg0_131)
		if arg0_131 then
			arg0_130._voiceKey = arg2_130
			arg0_130._voicePlaybackInfo = arg0_131
			arg0_130._voiceTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 0, arg0_130._voicePlaybackInfo:GetLength() * 0.001, function()
				pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_130._voiceTimer)

				arg0_130._voiceTimer = nil
				arg0_130._voiceKey = nil
				arg0_130._voicePlaybackInfo = nil
			end)
		end
	end)
end

function var6_0.SonarAcitve(arg0_133, arg1_133)
	return
end

function var6_0.SwitchShader(arg0_134, arg1_134, arg2_134, arg3_134)
	LeanTween.cancel(arg0_134._go)

	arg2_134 = arg2_134 or Color.New(0, 0, 0, 0)

	if arg1_134 then
		local var0_134 = var4_0.GetInstance():GetShader(arg1_134)

		arg0_134._animator:ShiftShader(var0_134, arg2_134)

		if arg3_134 then
			arg0_134:spineSemiTransparentFade(0, arg3_134.invisible, 0)
		end
	end

	arg0_134._shaderType = arg1_134
	arg0_134._color = arg2_134
end

function var6_0.PauseActionAnimation(arg0_135, arg1_135)
	local var0_135 = arg1_135 and 0 or 1

	arg0_135._animator:GetAnimationState().TimeScale = var0_135
end

function var6_0.GetFactory(arg0_136)
	return arg0_136._factory
end

function var6_0.SetFactory(arg0_137, arg1_137)
	arg0_137._factory = arg1_137
end

function var6_0.onSwitchSpine(arg0_138, arg1_138)
	local var0_138 = arg1_138.Data
	local var1_138 = var0_138.skin

	arg0_138._coverSpineHPBarOffset = var0_138.HPBarOffset or 0

	arg0_138:SwitchSpine(var1_138)
end

function var6_0.SwitchSpine(arg0_139, arg1_139)
	for iter0_139, iter1_139 in pairs(arg0_139._blinkDict) do
		SpineAnim.RemoveBlink(arg0_139._go, iter0_139)
	end

	arg0_139._factory:SwitchCharacterSpine(arg0_139, arg1_139)
end

function var6_0.onSwitchShader(arg0_140, arg1_140)
	local var0_140 = arg1_140.Data
	local var1_140 = var0_140.shader
	local var2_140 = var0_140.color
	local var3_140 = var0_140.args

	arg0_140:SwitchShader(var1_140, var2_140, var3_140)
end
