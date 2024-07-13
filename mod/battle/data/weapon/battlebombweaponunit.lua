ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = class("BattleBombWeaponUnit", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattleBombWeaponUnit = var2_0
var2_0.__name = "BattleBombWeaponUnit"

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)

	arg0_1._alertCache = {}
	arg0_1._cacheList = {}
end

function var2_0.Clear(arg0_2)
	if arg0_2._alertTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_2._alertTimer)
	end

	arg0_2._alertTimer = nil

	for iter0_2, iter1_2 in pairs(arg0_2._cacheList) do
		iter1_2:Destroy()
	end

	var2_0._cacheList = nil

	var2_0.super.Clear(arg0_2)
end

function var2_0.HostOnEnemy(arg0_3)
	var2_0.super.HostOnEnemy(arg0_3)

	if arg0_3._preCastInfo.alertTime ~= nil then
		arg0_3._showPrecastAlert = true

		local function var0_3()
			arg0_3._alertTimer:Stop()
			arg0_3:Fire()
		end

		arg0_3._alertTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, arg0_3._preCastInfo.alertTime or 3, var0_3, true, true)
	end
end

function var2_0.Update(arg0_5, arg1_5)
	arg0_5:UpdateReload()

	if arg0_5._currentState == arg0_5.STATE_READY then
		arg0_5:updateMovementInfo()

		local var0_5 = arg0_5:Tracking()

		if var0_5 then
			if arg0_5._showPrecastAlert then
				arg0_5:PreCast(var0_5)
			else
				arg0_5._currentState = arg0_5.STATE_PRECAST_FINISH
			end
		end
	end

	if arg0_5._currentState == arg0_5.STATE_PRECAST_FINISH then
		arg0_5:updateMovementInfo()

		local var1_5 = arg0_5:Tracking()
		local var2_5 = arg0_5:GetDirection()
		local var3_5 = arg0_5:GetAttackAngle()

		for iter0_5, iter1_5 in ipairs(arg0_5._majorEmitterList) do
			iter1_5:Ready()
		end

		for iter2_5, iter3_5 in ipairs(arg0_5._majorEmitterList) do
			iter3_5:Fire(var1_5, var2_5, var3_5)
		end

		var2_0.super.Fire(arg0_5, var1_5)
	end
end

function var2_0.PreCast(arg0_6, arg1_6)
	arg0_6:cacheBulletID()

	for iter0_6, iter1_6 in ipairs(arg0_6._majorEmitterList) do
		iter1_6:Ready()
	end

	for iter2_6, iter3_6 in ipairs(arg0_6._majorEmitterList) do
		iter3_6:Fire(arg1_6, arg0_6:GetDirection(), arg0_6:GetAttackAngle())
	end

	var2_0.super.PreCast(arg0_6)
	arg0_6._alertTimer:Start()
end

function var2_0.AddPreCastTimer(arg0_7)
	local function var0_7()
		arg0_7._currentState = arg0_7.STATE_OVER_HEAT

		arg0_7:RemovePrecastTimer()

		local var0_8 = arg0_7._preCastInfo
		local var1_8 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.WEAPON_PRE_CAST_FINISH, var0_8)

		arg0_7._host:SetWeaponPreCastBound(false)
		arg0_7:DispatchEvent(var1_8)
	end

	arg0_7._precastTimer = pg.TimeMgr.GetInstance():AddBattleTimer("weaponPrecastTimer", 0, arg0_7._preCastInfo.time, var0_7, true)
end

function var2_0.createMajorEmitter(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9)
	local var0_9 = {}
	local var1_9

	local function var2_9()
		arg0_9:DispatchBulletEvent(table.remove(var0_9, 1))
	end

	local var3_9

	local function var4_9()
		for iter0_11, iter1_11 in ipairs(arg0_9._cacheList) do
			if iter1_11:GetState() ~= iter1_11.STATE_STOP then
				return
			end
		end

		arg0_9:EnterCoolDown()
	end

	local var5_9 = var0_0.Battle.BattleBulletEmitter.New(var2_9, var4_9, arg1_9)

	arg0_9._cacheList[var5_9] = var5_9

	local function var6_9(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
		local var0_12 = arg0_9._emitBulletIDList[arg2_9]
		local var1_12 = arg0_9:Spawn(var0_12, arg4_12)

		var1_12:SetOffsetPriority(arg3_12)
		var1_12:SetShiftInfo(arg0_12, arg1_12)

		if arg0_9._tmpData.aim_type == var0_0.Battle.BattleConst.WeaponAimType.AIM and arg4_12 ~= nil then
			var1_12:SetRotateInfo(arg4_12:GetBeenAimedPosition(), arg0_9:GetBaseAngle(), arg2_12)
		else
			var1_12:SetRotateInfo(nil, arg0_9:GetBaseAngle(), arg2_12)
		end

		table.insert(var0_9, var1_12)
		arg0_9:showBombAlert(var1_12)
	end

	local function var7_9()
		return
	end

	var2_0.super.createMajorEmitter(arg0_9, arg1_9, arg2_9, nil, var6_9, var7_9)
end

function var2_0.DoAttack(arg0_14)
	arg0_14:TriggerBuffOnSteday()

	for iter0_14, iter1_14 in pairs(arg0_14._cacheList) do
		iter1_14:Ready()
	end

	for iter2_14, iter3_14 in pairs(arg0_14._cacheList) do
		iter3_14:Fire(nil, arg0_14:GetDirection())
	end

	var0_0.Battle.PlayBattleSFX(arg0_14._tmpData.fire_sfx)
	arg0_14:TriggerBuffOnFire()
	arg0_14:CheckAndShake()
end

function var2_0.showBombAlert(arg0_15, arg1_15)
	arg1_15:SetExist(false)

	if arg1_15:GetTemplate().alert_fx ~= "" then
		var0_0.Battle.BattleBombBulletFactory.CreateBulletAlert(arg1_15)
	end
end
