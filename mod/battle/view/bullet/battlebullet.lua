ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBulletEvent
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleVariable

var0.Battle.BattleBullet = class("BattleBullet", var0.Battle.BattleSceneObject)
var0.Battle.BattleBullet.__name = "BattleBullet"

local var4 = var0.Battle.BattleBullet

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0.resMgr = var0.Battle.BattleResourceManager.GetInstance()
	arg0._cacheSpeed = Vector3.zero
	arg0._calcSpeed = Vector3.zero
	arg0._cacheTFPos = Vector3.zero
end

function var4.Update(arg0, arg1)
	local var0 = arg0._bulletData:GetSpeed()

	arg0._calcSpeed:Set(var0.x, var0.y, var0.z)

	local var1 = arg0._bulletData:GetVerticalSpeed()

	if var1 ~= 0 then
		arg0._calcSpeed.y = arg0._calcSpeed.y + var1
	end

	if arg0._cacheSpeed ~= arg0._calcSpeed then
		if arg0._rotateScript then
			arg0._rotateScript:SetSpeed(arg0._calcSpeed)
		end

		arg0._cacheSpeed:Set(arg0._calcSpeed.x, arg0._calcSpeed.y, arg0._calcSpeed.z)
	end

	if math.abs(arg0._calcSpeed.x) >= 0.01 or math.abs(arg0._calcSpeed.z) >= 0.01 or math.abs(arg0._calcSpeed.y) >= 0.01 then
		arg0:UpdatePosition()
	else
		local var2 = arg0:GetPosition()

		if math.abs(arg0._cacheTFPos.x - var2.x) >= 0.1 or math.abs(arg0._cacheTFPos.z - var2.z) >= 0.1 or math.abs(arg0._cacheTFPos.y - var2.y) >= 0.1 then
			arg0:UpdatePosition()
		end
	end
end

function var4.UpdatePosition(arg0)
	local var0 = arg0:GetPosition()

	arg0._tf.localPosition = var0

	arg0._cacheTFPos:Set(var0.x, var0.y, var0.z)
end

function var4.DoOutRange(arg0)
	arg0._bulletMissFunc(arg0)
end

function var4.SetBulletData(arg0, arg1)
	arg0._bulletData = arg1

	arg0._bulletData:SetStartTimeStamp(pg.TimeMgr.GetInstance():GetCombatTime())

	arg0._cfgTpl = arg1:GetTemplate()
	arg0._IFF = arg1:GetIFF()

	arg0:AddBulletEvent()
end

function var4.AddBulletEvent(arg0)
	arg0._bulletData:RegisterEventListener(arg0, var1.HIT, arg0.onBulletHit)
	arg0._bulletData:RegisterEventListener(arg0, var1.INTERCEPTED, arg0.onIntercepted)
	arg0._bulletData:RegisterEventListener(arg0, var1.OUT_RANGE, arg0.onOutRange)
end

function var4.RemoveBulletEvent(arg0)
	arg0._bulletData:UnregisterEventListener(arg0, var1.HIT)
	arg0._bulletData:UnregisterEventListener(arg0, var1.INTERCEPTED)
	arg0._bulletData:UnregisterEventListener(arg0, var1.OUT_RANGE)
end

function var4.onBulletHit(arg0, arg1)
	local var0 = arg1.Data
	local var1 = arg1.Data.UID
	local var2 = arg1.Data.type

	arg0._bulletHitFunc(arg0, var1, var2)
end

function var4.onIntercepted(arg0)
	local var0, var1 = var0.Battle.BattleFXPool.GetInstance():GetFX(arg0:GetBulletData():GetTemplate().hit_fx)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0, var1:Add(arg0:GetPosition()), true)
end

function var4.onOutRange(arg0, arg1)
	arg0:DoOutRange()
end

function var4.GetBulletData(arg0)
	return arg0._bulletData
end

function var4.GetPosition(arg0)
	return arg0._bulletData:GetPosition()
end

function var4.Dispose(arg0)
	if arg0._rotateScript then
		arg0._rotateScript:SetSpeed(Vector3.zero)
	end

	arg0:RemoveBulletEvent()

	if arg0._isTempGO then
		arg0._factory:RecyleTempModel(arg0._go)
	else
		var0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0._go)
	end

	if arg0._trackFX then
		arg0.resMgr.GetInstance():DestroyOb(arg0._trackFX)
	end

	arg0._skeleton = nil
	arg0._go = nil
	arg0._tf = nil
	arg0._trackFX = nil

	var0.EventListener.DetachEventListener(arg0)
end

function var4.GetModleID(arg0)
	return arg0._bulletData:GetModleID()
end

function var4.GetFXID(arg0)
	return arg0._cfgTpl.hit_fx
end

function var4.GetMissFXID(arg0)
	return arg0._cfgTpl.miss_fx
end

function var4.GetTrackFXID(arg0)
	return arg0._cfgTpl.track_fx
end

function var4.AddModel(arg0, arg1)
	if arg0._isTempGO and arg0._go == nil then
		var0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg1)

		return false
	else
		if arg0._isTempGO then
			LuaHelper.CopyTransformInfoGO(arg1, arg0._go)
			arg0._factory:RecyleTempModel(arg0._go)

			arg0._isTempGO = false
		end

		arg0:SetGO(arg1)
		arg0._bulletData:ActiveCldBox()

		if arg0._bulletData:IsAutoRotate() then
			arg0:AddRotateScript()
		end

		local var0 = arg0._tf:Find("bullet")

		if var0 and var0:GetComponent(typeof(SpineAnim)) then
			arg0._skeleton = var0:GetComponent("SkeletonAnimation")
			arg0._spineBullet = true

			var0:GetComponent(typeof(SpineAnim)):SetAction("normal", 0, false)
		end

		local var1 = arg0._tf:Find("bullet_random")

		if var1 and var1:GetComponent(typeof(SpineAnim)) then
			arg0._skeleton = var1:GetComponent("SkeletonAnimation")
			arg0._spineBullet = true

			local var2 = var1:GetComponent(typeof(SpineAnim))
			local var3 = tostring(math.random(3))

			var2:SetAction(var3, 0, false)
		end

		return true
	end
end

function var4.SetAnimaSpeed(arg0, arg1)
	if arg0._skeleton then
		arg1 = arg1 or 1
		arg0._skeleton.timeScale = arg1
	end
end

function var4.AddRotateScript(arg0)
	arg0._rotateScript = arg0.resMgr:GetRotateScript(arg0._go)
end

function var4.AddTempModel(arg0, arg1)
	arg0._isTempGO = true

	arg0:SetGO(arg1)

	if arg0._bulletData:IsAutoRotate() then
		arg0:AddRotateScript()
	end
end

function var4.AddTrack(arg0, arg1)
	arg0._trackFX = arg1

	LuaHelper.SetGOParentTF(arg1, arg0._tf, false)
end

function var4.SetSpawn(arg0, arg1)
	local var0, var1 = arg0:getHeightAdjust(arg1)
	local var2 = var0:Clone()

	var2.z = var2.z + var1
	arg0._tf.localPosition = var2

	arg0._bulletData:SetSpawnPosition(var2)

	local var3, var4, var5 = arg0._bulletData:GetRotateInfo()

	if var3 then
		local var6

		if arg0._bulletData:GetOffsetPriority() then
			var6 = math.rad2Deg * math.atan2(var3.z - var0.z, var3.x - var2.x)
		else
			var6 = math.rad2Deg * math.atan2(var3.z - var0.z - var1, var3.x - var2.x)
		end

		arg0._bulletData:InitSpeed(var6)
	else
		arg0._bulletData:InitSpeed(nil)
	end
end

function var4.getHeightAdjust(arg0, arg1)
	local var0 = arg0._bulletData:GetTemplate().extra_param

	if var0.airdrop then
		local var1 = arg0._bulletData:GetExplodePostion()
		local var2 = 0

		if var0.dropOffset then
			var2 = math.sqrt(math.abs(var0.offsetY * 2 / arg0._bulletData._gravity)) * arg0._bulletData:GetConvertedVelocity()

			if arg0._bulletData:GetHost():GetDirection() < 0 then
				var2 = var2 * -1
			end
		end

		return Vector3(var1.x - var2, var0.offsetY or arg1.y, var1.z), 0
	else
		local var3, var4 = arg0._bulletData:GetOffset()
		local var5 = arg1.x + var3
		local var6 = arg1.z + var4

		if arg0._bulletData:IsGravitate() then
			return Vector3(var5, arg1.y, var6), 0
		else
			local var7 = 0
			local var8
			local var9 = var2.BulletHeight

			if var9 >= arg1.y then
				var8 = arg1.y
			else
				var8 = var9
				var7 = arg0.GetZExtraOffset(arg1.y)
			end

			return Vector3(var5, var8, var6), var7
		end
	end
end

function var4.GetZExtraOffset(arg0)
	return var2.HeightOffsetRate * (arg0 - var2.BulletHeight)
end

function var4.GetFactory(arg0)
	return arg0._factory
end

function var4.SetFactory(arg0, arg1)
	arg0._factory = arg1
end

function var4.SetFXFunc(arg0, arg1, arg2)
	arg0._bulletHitFunc = arg1
	arg0._bulletMissFunc = arg2
end

function var4.Neutrailze(arg0)
	if arg0._bulletMissFunc then
		arg0._bulletMissFunc(arg0)
	end

	SetActive(arg0._go, false)
end
