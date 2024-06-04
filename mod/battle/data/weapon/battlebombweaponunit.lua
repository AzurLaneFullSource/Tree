ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = class("BattleBombWeaponUnit", var0.Battle.BattleWeaponUnit)

var0.Battle.BattleBombWeaponUnit = var2
var2.__name = "BattleBombWeaponUnit"

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)

	arg0._alertCache = {}
	arg0._cacheList = {}
end

function var2.Clear(arg0)
	if arg0._alertTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._alertTimer)
	end

	arg0._alertTimer = nil

	for iter0, iter1 in pairs(arg0._cacheList) do
		iter1:Destroy()
	end

	var2._cacheList = nil

	var2.super.Clear(arg0)
end

function var2.HostOnEnemy(arg0)
	var2.super.HostOnEnemy(arg0)

	if arg0._preCastInfo.alertTime ~= nil then
		arg0._showPrecastAlert = true

		local function var0()
			arg0._alertTimer:Stop()
			arg0:Fire()
		end

		arg0._alertTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, arg0._preCastInfo.alertTime or 3, var0, true, true)
	end
end

function var2.Update(arg0, arg1)
	arg0:UpdateReload()

	if arg0._currentState == arg0.STATE_READY then
		arg0:updateMovementInfo()

		local var0 = arg0:Tracking()

		if var0 then
			if arg0._showPrecastAlert then
				arg0:PreCast(var0)
			else
				arg0._currentState = arg0.STATE_PRECAST_FINISH
			end
		end
	end

	if arg0._currentState == arg0.STATE_PRECAST_FINISH then
		arg0:updateMovementInfo()

		local var1 = arg0:Tracking()
		local var2 = arg0:GetDirection()
		local var3 = arg0:GetAttackAngle()

		for iter0, iter1 in ipairs(arg0._majorEmitterList) do
			iter1:Ready()
		end

		for iter2, iter3 in ipairs(arg0._majorEmitterList) do
			iter3:Fire(var1, var2, var3)
		end

		var2.super.Fire(arg0, var1)
	end
end

function var2.PreCast(arg0, arg1)
	arg0:cacheBulletID()

	for iter0, iter1 in ipairs(arg0._majorEmitterList) do
		iter1:Ready()
	end

	for iter2, iter3 in ipairs(arg0._majorEmitterList) do
		iter3:Fire(arg1, arg0:GetDirection(), arg0:GetAttackAngle())
	end

	var2.super.PreCast(arg0)
	arg0._alertTimer:Start()
end

function var2.AddPreCastTimer(arg0)
	local var0 = function()
		arg0._currentState = arg0.STATE_OVER_HEAT

		arg0:RemovePrecastTimer()

		local var0 = arg0._preCastInfo
		local var1 = var0.Event.New(var0.Battle.BattleUnitEvent.WEAPON_PRE_CAST_FINISH, var0)

		arg0._host:SetWeaponPreCastBound(false)
		arg0:DispatchEvent(var1)
	end

	arg0._precastTimer = pg.TimeMgr.GetInstance():AddBattleTimer("weaponPrecastTimer", 0, arg0._preCastInfo.time, var0, true)
end

function var2.createMajorEmitter(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = {}
	local var1

	local function var2()
		arg0:DispatchBulletEvent(table.remove(var0, 1))
	end

	local var3

	local function var4()
		for iter0, iter1 in ipairs(arg0._cacheList) do
			if iter1:GetState() ~= iter1.STATE_STOP then
				return
			end
		end

		arg0:EnterCoolDown()
	end

	local var5 = var0.Battle.BattleBulletEmitter.New(var2, var4, arg1)

	arg0._cacheList[var5] = var5

	local function var6(arg0, arg1, arg2, arg3, arg4)
		local var0 = arg0._emitBulletIDList[arg2]
		local var1 = arg0:Spawn(var0, arg4)

		var1:SetOffsetPriority(arg3)
		var1:SetShiftInfo(arg0, arg1)

		if arg0._tmpData.aim_type == var0.Battle.BattleConst.WeaponAimType.AIM and arg4 ~= nil then
			var1:SetRotateInfo(arg4:GetBeenAimedPosition(), arg0:GetBaseAngle(), arg2)
		else
			var1:SetRotateInfo(nil, arg0:GetBaseAngle(), arg2)
		end

		table.insert(var0, var1)
		arg0:showBombAlert(var1)
	end

	local function var7()
		return
	end

	var2.super.createMajorEmitter(arg0, arg1, arg2, nil, var6, var7)
end

function var2.DoAttack(arg0)
	arg0:TriggerBuffOnSteday()

	for iter0, iter1 in pairs(arg0._cacheList) do
		iter1:Ready()
	end

	for iter2, iter3 in pairs(arg0._cacheList) do
		iter3:Fire(nil, arg0:GetDirection())
	end

	var0.Battle.PlayBattleSFX(arg0._tmpData.fire_sfx)
	arg0:TriggerBuffOnFire()
	arg0:CheckAndShake()
end

function var2.showBombAlert(arg0, arg1)
	arg1:SetExist(false)

	if arg1:GetTemplate().alert_fx ~= "" then
		var0.Battle.BattleBombBulletFactory.CreateBulletAlert(arg1)
	end
end
