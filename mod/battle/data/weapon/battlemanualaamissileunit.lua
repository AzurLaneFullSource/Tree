ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleUnitEvent
local var3 = var0.Battle.BattleTargetChoise
local var4 = class("BattleManualAAMissileUnit", var0.Battle.BattleManualTorpedoUnit)

var0.Battle.BattleManualAAMissileUnit = var4
var4.__name = "BattleManualAAMissileUnit"

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)

	arg0._strikeMode = nil
	arg0._strikeModeData = nil
end

function var4.createMajorEmitter(arg0, arg1, arg2, arg3)
	local function var0(arg0, arg1, arg2, arg3, arg4)
		local var0 = arg0._emitBulletIDList[arg2]
		local var1 = arg0:Spawn(var0, arg4, var4.INTERNAL)

		var1:SetOffsetPriority(arg3)
		var1:SetShiftInfo(arg0, arg1)

		if arg0._tmpData.aim_type == var1.WeaponAimType.AIM and arg4 ~= nil then
			var1:SetRotateInfo(arg4:GetBeenAimedPosition(), arg0:GetBaseAngle(), arg2)
		else
			var1:SetRotateInfo(nil, arg0:GetBaseAngle(), arg2)
		end

		var1:setTrackingTarget(arg4)

		local var2 = {}

		for iter0, iter1 in pairs(arg0._strikeModeData) do
			var2[iter0] = iter1
		end

		var1:SetTrackingFXData(var2)
		arg0:DispatchBulletEvent(var1)

		return var1
	end

	local function var1()
		for iter0, iter1 in ipairs(arg0._majorEmitterList) do
			if iter1:GetState() ~= iter1.STATE_STOP then
				return
			end
		end

		arg0:DispatchEvent(var0.Event.New(var2.MANUAL_WEAPON_FIRE, {}))

		arg0._strikeModeData = nil
	end

	arg3 = arg3 or var4.EMITTER_NORMAL

	local var2 = var0.Battle[arg3].New(var0, var1, arg1)

	arg0._majorEmitterList[#arg0._majorEmitterList + 1] = var2

	return var2
end

function var4.IsStrikeMode(arg0)
	return arg0._strikeMode
end

function var4.IsAttacking(arg0)
	return arg0._currentState == var4.STATE_ATTACK
end

function var4.Update(arg0)
	arg0:UpdateReload()

	if arg0:IsStrikeMode() then
		arg0:MarkTarget()
	end
end

function var4.EnterStrikeMode(arg0)
	arg0._strikeMode = true
	arg0._strikeModeData = {}
	arg0._strikeModeData.fxName = arg0._preCastInfo.fx

	arg0:MarkTarget()
end

function var4.MarkTarget(arg0)
	local var0 = arg0._strikeModeData.aimingTarget

	arg0:updateMovementInfo()

	local var1 = arg0:Tracking()

	if var0 == var1 then
		return
	end

	local var2 = var0.Battle.BattleState.GetInstance():GetSceneMediator()

	if arg0._strikeModeData.aimingTarget and arg0._strikeModeData.aimingFX then
		local var3 = var2:GetCharacter(var0:GetUniqueID())

		if var3 then
			var3:RemoveFX(arg0._strikeModeData.aimingFX)
		end
	end

	table.clear(arg0._strikeModeData)

	if not var1 then
		return
	end

	local var4 = var2:GetCharacter(var1:GetUniqueID())
	local var5

	if arg0._preCastInfo.fx and #arg0._preCastInfo.fx > 0 then
		var5 = var4:AddFX(arg0._preCastInfo.fx)
	end

	arg0._strikeModeData.aimingTarget = var1
	arg0._strikeModeData.aimingFX = var5
end

function var4.CancelStrikeMode(arg0)
	if arg0._strikeModeData.aimingTarget and arg0._strikeModeData.aimingFX then
		local var0 = var0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(arg0._strikeModeData.aimingTarget:GetUniqueID())

		if var0 then
			var0:RemoveFX(arg0._strikeModeData.aimingFX)
		end
	end

	arg0._strikeMode = nil
	arg0._strikeModeData = nil
end

function var4.Tracking(arg0)
	return var3.TargetWeightiest(arg0, nil, arg0:GetFilteredList())[1]
end

function var4.Fire(arg0)
	arg0._strikeMode = nil

	var0.Battle.BattleWeaponUnit.Fire(arg0, arg0._strikeModeData.aimingTarget)

	return true
end

function var4.DoAttack(arg0, arg1, ...)
	if arg1 == nil or not arg1:IsAlive() or arg0:outOfFireRange(arg1) then
		arg1 = nil

		if arg0._strikeModeData.aimingTarget and arg0._strikeModeData.aimingFX then
			local var0 = var0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(arg0._strikeModeData.aimingTarget:GetUniqueID())

			if var0 then
				var0:RemoveFX(arg0._strikeModeData.aimingFX)
			end
		end

		arg0._strikeModeData.aimingTarget = nil
		arg0._strikeModeData.aimingFX = nil
	end

	var0.Battle.BattleWeaponUnit.DoAttack(arg0, arg1, ...)
end

function var4.Prepar(arg0)
	arg0._currentState = arg0.STATE_PRECAST

	arg0:EnterStrikeMode()
end

function var4.Cancel(arg0)
	arg0._currentState = arg0.STATE_READY

	arg0:CancelStrikeMode()
end
