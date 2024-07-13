ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBulletEvent
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleBullet = class("BattleBullet", var0_0.Battle.BattleSceneObject)
var0_0.Battle.BattleBullet.__name = "BattleBullet"

local var4_0 = var0_0.Battle.BattleBullet

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1.resMgr = var0_0.Battle.BattleResourceManager.GetInstance()
	arg0_1._cacheSpeed = Vector3.zero
	arg0_1._calcSpeed = Vector3.zero
	arg0_1._cacheTFPos = Vector3.zero
end

function var4_0.Update(arg0_2, arg1_2)
	local var0_2 = arg0_2._bulletData:GetSpeed()

	arg0_2._calcSpeed:Set(var0_2.x, var0_2.y, var0_2.z)

	local var1_2 = arg0_2._bulletData:GetVerticalSpeed()

	if var1_2 ~= 0 then
		arg0_2._calcSpeed.y = arg0_2._calcSpeed.y + var1_2
	end

	if arg0_2._cacheSpeed ~= arg0_2._calcSpeed then
		if arg0_2._rotateScript then
			arg0_2._rotateScript:SetSpeed(arg0_2._calcSpeed)
		end

		arg0_2._cacheSpeed:Set(arg0_2._calcSpeed.x, arg0_2._calcSpeed.y, arg0_2._calcSpeed.z)
	end

	if math.abs(arg0_2._calcSpeed.x) >= 0.01 or math.abs(arg0_2._calcSpeed.z) >= 0.01 or math.abs(arg0_2._calcSpeed.y) >= 0.01 then
		arg0_2:UpdatePosition()
	else
		local var2_2 = arg0_2:GetPosition()

		if math.abs(arg0_2._cacheTFPos.x - var2_2.x) >= 0.1 or math.abs(arg0_2._cacheTFPos.z - var2_2.z) >= 0.1 or math.abs(arg0_2._cacheTFPos.y - var2_2.y) >= 0.1 then
			arg0_2:UpdatePosition()
		end
	end
end

function var4_0.UpdatePosition(arg0_3)
	local var0_3 = arg0_3:GetPosition()

	arg0_3._tf.localPosition = var0_3

	arg0_3._cacheTFPos:Set(var0_3.x, var0_3.y, var0_3.z)
end

function var4_0.DoOutRange(arg0_4)
	arg0_4._bulletMissFunc(arg0_4)
end

function var4_0.SetBulletData(arg0_5, arg1_5)
	arg0_5._bulletData = arg1_5

	arg0_5._bulletData:SetStartTimeStamp(pg.TimeMgr.GetInstance():GetCombatTime())

	arg0_5._cfgTpl = arg1_5:GetTemplate()
	arg0_5._IFF = arg1_5:GetIFF()

	arg0_5:AddBulletEvent()
end

function var4_0.AddBulletEvent(arg0_6)
	arg0_6._bulletData:RegisterEventListener(arg0_6, var1_0.HIT, arg0_6.onBulletHit)
	arg0_6._bulletData:RegisterEventListener(arg0_6, var1_0.INTERCEPTED, arg0_6.onIntercepted)
	arg0_6._bulletData:RegisterEventListener(arg0_6, var1_0.OUT_RANGE, arg0_6.onOutRange)
end

function var4_0.RemoveBulletEvent(arg0_7)
	arg0_7._bulletData:UnregisterEventListener(arg0_7, var1_0.HIT)
	arg0_7._bulletData:UnregisterEventListener(arg0_7, var1_0.INTERCEPTED)
	arg0_7._bulletData:UnregisterEventListener(arg0_7, var1_0.OUT_RANGE)
end

function var4_0.onBulletHit(arg0_8, arg1_8)
	local var0_8 = arg1_8.Data
	local var1_8 = arg1_8.Data.UID
	local var2_8 = arg1_8.Data.type

	arg0_8._bulletHitFunc(arg0_8, var1_8, var2_8)
end

function var4_0.onIntercepted(arg0_9)
	local var0_9, var1_9 = var0_0.Battle.BattleFXPool.GetInstance():GetFX(arg0_9:GetBulletData():GetTemplate().hit_fx)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0_9, var1_9:Add(arg0_9:GetPosition()), true)
end

function var4_0.onOutRange(arg0_10, arg1_10)
	arg0_10:DoOutRange()
end

function var4_0.GetBulletData(arg0_11)
	return arg0_11._bulletData
end

function var4_0.GetPosition(arg0_12)
	return arg0_12._bulletData:GetPosition()
end

function var4_0.Dispose(arg0_13)
	if arg0_13._rotateScript then
		arg0_13._rotateScript:SetSpeed(Vector3.zero)
	end

	arg0_13:RemoveBulletEvent()

	if arg0_13._isTempGO then
		arg0_13._factory:RecyleTempModel(arg0_13._go)
	else
		var0_0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0_13._go)
	end

	if arg0_13._trackFX then
		arg0_13.resMgr.GetInstance():DestroyOb(arg0_13._trackFX)
	end

	arg0_13._skeleton = nil
	arg0_13._go = nil
	arg0_13._tf = nil
	arg0_13._trackFX = nil

	var0_0.EventListener.DetachEventListener(arg0_13)
end

function var4_0.GetModleID(arg0_14)
	return arg0_14._bulletData:GetModleID()
end

function var4_0.GetFXID(arg0_15)
	return arg0_15._cfgTpl.hit_fx
end

function var4_0.GetMissFXID(arg0_16)
	return arg0_16._cfgTpl.miss_fx
end

function var4_0.GetTrackFXID(arg0_17)
	return arg0_17._cfgTpl.track_fx
end

function var4_0.AddModel(arg0_18, arg1_18)
	if arg0_18._isTempGO and arg0_18._go == nil then
		var0_0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg1_18)

		return false
	else
		if arg0_18._isTempGO then
			LuaHelper.CopyTransformInfoGO(arg1_18, arg0_18._go)
			arg0_18._factory:RecyleTempModel(arg0_18._go)

			arg0_18._isTempGO = false
		end

		arg0_18:SetGO(arg1_18)
		arg0_18._bulletData:ActiveCldBox()

		if arg0_18._bulletData:IsAutoRotate() then
			arg0_18:AddRotateScript()
		end

		local var0_18 = arg0_18._tf:Find("bullet")

		if var0_18 and var0_18:GetComponent(typeof(SpineAnim)) then
			arg0_18._skeleton = var0_18:GetComponent("SkeletonAnimation")
			arg0_18._spineBullet = true

			var0_18:GetComponent(typeof(SpineAnim)):SetAction("normal", 0, false)
		end

		local var1_18 = arg0_18._tf:Find("bullet_random")

		if var1_18 and var1_18:GetComponent(typeof(SpineAnim)) then
			arg0_18._skeleton = var1_18:GetComponent("SkeletonAnimation")
			arg0_18._spineBullet = true

			local var2_18 = var1_18:GetComponent(typeof(SpineAnim))
			local var3_18 = tostring(math.random(3))

			var2_18:SetAction(var3_18, 0, false)
		end

		return true
	end
end

function var4_0.SetAnimaSpeed(arg0_19, arg1_19)
	if arg0_19._skeleton then
		arg1_19 = arg1_19 or 1
		arg0_19._skeleton.timeScale = arg1_19
	end
end

function var4_0.AddRotateScript(arg0_20)
	arg0_20._rotateScript = arg0_20.resMgr:GetRotateScript(arg0_20._go)
end

function var4_0.AddTempModel(arg0_21, arg1_21)
	arg0_21._isTempGO = true

	arg0_21:SetGO(arg1_21)

	if arg0_21._bulletData:IsAutoRotate() then
		arg0_21:AddRotateScript()
	end
end

function var4_0.AddTrack(arg0_22, arg1_22)
	arg0_22._trackFX = arg1_22

	LuaHelper.SetGOParentTF(arg1_22, arg0_22._tf, false)
end

function var4_0.SetSpawn(arg0_23, arg1_23)
	local var0_23, var1_23 = arg0_23:getHeightAdjust(arg1_23)
	local var2_23 = var0_23:Clone()

	var2_23.z = var2_23.z + var1_23
	arg0_23._tf.localPosition = var2_23

	arg0_23._bulletData:SetSpawnPosition(var2_23)

	local var3_23, var4_23, var5_23 = arg0_23._bulletData:GetRotateInfo()

	if var3_23 then
		local var6_23

		if arg0_23._bulletData:GetOffsetPriority() then
			var6_23 = math.rad2Deg * math.atan2(var3_23.z - var0_23.z, var3_23.x - var2_23.x)
		else
			var6_23 = math.rad2Deg * math.atan2(var3_23.z - var0_23.z - var1_23, var3_23.x - var2_23.x)
		end

		arg0_23._bulletData:InitSpeed(var6_23)
	else
		arg0_23._bulletData:InitSpeed(nil)
	end
end

function var4_0.getHeightAdjust(arg0_24, arg1_24)
	local var0_24 = arg0_24._bulletData:GetTemplate().extra_param

	if var0_24.airdrop then
		local var1_24 = arg0_24._bulletData:GetExplodePostion()
		local var2_24 = 0

		if var0_24.dropOffset then
			var2_24 = math.sqrt(math.abs(var0_24.offsetY * 2 / arg0_24._bulletData._gravity)) * arg0_24._bulletData:GetConvertedVelocity()

			if arg0_24._bulletData:GetHost():GetDirection() < 0 then
				var2_24 = var2_24 * -1
			end
		end

		return Vector3(var1_24.x - var2_24, var0_24.offsetY or arg1_24.y, var1_24.z), 0
	else
		local var3_24, var4_24 = arg0_24._bulletData:GetOffset()
		local var5_24 = arg1_24.x + var3_24
		local var6_24 = arg1_24.z + var4_24

		if arg0_24._bulletData:IsGravitate() then
			return Vector3(var5_24, arg1_24.y, var6_24), 0
		else
			local var7_24 = 0
			local var8_24
			local var9_24 = var2_0.BulletHeight

			if var9_24 >= arg1_24.y then
				var8_24 = arg1_24.y
			else
				var8_24 = var9_24
				var7_24 = arg0_24.GetZExtraOffset(arg1_24.y)
			end

			return Vector3(var5_24, var8_24, var6_24), var7_24
		end
	end
end

function var4_0.GetZExtraOffset(arg0_25)
	return var2_0.HeightOffsetRate * (arg0_25 - var2_0.BulletHeight)
end

function var4_0.GetFactory(arg0_26)
	return arg0_26._factory
end

function var4_0.SetFactory(arg0_27, arg1_27)
	arg0_27._factory = arg1_27
end

function var4_0.SetFXFunc(arg0_28, arg1_28, arg2_28)
	arg0_28._bulletHitFunc = arg1_28
	arg0_28._bulletMissFunc = arg2_28
end

function var4_0.Neutrailze(arg0_29)
	if arg0_29._bulletMissFunc then
		arg0_29._bulletMissFunc(arg0_29)
	end

	SetActive(arg0_29._go, false)
end
