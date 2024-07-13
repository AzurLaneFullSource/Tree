ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleUnitEvent
local var3_0 = var0_0.Battle.BattleTargetChoise
local var4_0 = class("BattleManualAAMissileUnit", var0_0.Battle.BattleManualTorpedoUnit)

var0_0.Battle.BattleManualAAMissileUnit = var4_0
var4_0.__name = "BattleManualAAMissileUnit"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)

	arg0_1._strikeMode = nil
	arg0_1._strikeModeData = nil
end

function var4_0.createMajorEmitter(arg0_2, arg1_2, arg2_2, arg3_2)
	local function var0_2(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
		local var0_3 = arg0_2._emitBulletIDList[arg2_2]
		local var1_3 = arg0_2:Spawn(var0_3, arg4_3, var4_0.INTERNAL)

		var1_3:SetOffsetPriority(arg3_3)
		var1_3:SetShiftInfo(arg0_3, arg1_3)

		if arg0_2._tmpData.aim_type == var1_0.WeaponAimType.AIM and arg4_3 ~= nil then
			var1_3:SetRotateInfo(arg4_3:GetBeenAimedPosition(), arg0_2:GetBaseAngle(), arg2_3)
		else
			var1_3:SetRotateInfo(nil, arg0_2:GetBaseAngle(), arg2_3)
		end

		var1_3:setTrackingTarget(arg4_3)

		local var2_3 = {}

		for iter0_3, iter1_3 in pairs(arg0_2._strikeModeData) do
			var2_3[iter0_3] = iter1_3
		end

		var1_3:SetTrackingFXData(var2_3)
		arg0_2:DispatchBulletEvent(var1_3)

		return var1_3
	end

	local function var1_2()
		for iter0_4, iter1_4 in ipairs(arg0_2._majorEmitterList) do
			if iter1_4:GetState() ~= iter1_4.STATE_STOP then
				return
			end
		end

		arg0_2:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_WEAPON_FIRE, {}))

		arg0_2._strikeModeData = nil
	end

	arg3_2 = arg3_2 or var4_0.EMITTER_NORMAL

	local var2_2 = var0_0.Battle[arg3_2].New(var0_2, var1_2, arg1_2)

	arg0_2._majorEmitterList[#arg0_2._majorEmitterList + 1] = var2_2

	return var2_2
end

function var4_0.IsStrikeMode(arg0_5)
	return arg0_5._strikeMode
end

function var4_0.IsAttacking(arg0_6)
	return arg0_6._currentState == var4_0.STATE_ATTACK
end

function var4_0.Update(arg0_7)
	arg0_7:UpdateReload()

	if arg0_7:IsStrikeMode() then
		arg0_7:MarkTarget()
	end
end

function var4_0.EnterStrikeMode(arg0_8)
	arg0_8._strikeMode = true
	arg0_8._strikeModeData = {}
	arg0_8._strikeModeData.fxName = arg0_8._preCastInfo.fx

	arg0_8:MarkTarget()
end

function var4_0.MarkTarget(arg0_9)
	local var0_9 = arg0_9._strikeModeData.aimingTarget

	arg0_9:updateMovementInfo()

	local var1_9 = arg0_9:Tracking()

	if var0_9 == var1_9 then
		return
	end

	local var2_9 = var0_0.Battle.BattleState.GetInstance():GetSceneMediator()

	if arg0_9._strikeModeData.aimingTarget and arg0_9._strikeModeData.aimingFX then
		local var3_9 = var2_9:GetCharacter(var0_9:GetUniqueID())

		if var3_9 then
			var3_9:RemoveFX(arg0_9._strikeModeData.aimingFX)
		end
	end

	table.clear(arg0_9._strikeModeData)

	if not var1_9 then
		return
	end

	local var4_9 = var2_9:GetCharacter(var1_9:GetUniqueID())
	local var5_9

	if arg0_9._preCastInfo.fx and #arg0_9._preCastInfo.fx > 0 then
		var5_9 = var4_9:AddFX(arg0_9._preCastInfo.fx)
	end

	arg0_9._strikeModeData.aimingTarget = var1_9
	arg0_9._strikeModeData.aimingFX = var5_9
end

function var4_0.CancelStrikeMode(arg0_10)
	if arg0_10._strikeModeData.aimingTarget and arg0_10._strikeModeData.aimingFX then
		local var0_10 = var0_0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(arg0_10._strikeModeData.aimingTarget:GetUniqueID())

		if var0_10 then
			var0_10:RemoveFX(arg0_10._strikeModeData.aimingFX)
		end
	end

	arg0_10._strikeMode = nil
	arg0_10._strikeModeData = nil
end

function var4_0.Tracking(arg0_11)
	return var3_0.TargetWeightiest(arg0_11, nil, arg0_11:GetFilteredList())[1]
end

function var4_0.Fire(arg0_12)
	arg0_12._strikeMode = nil

	var0_0.Battle.BattleWeaponUnit.Fire(arg0_12, arg0_12._strikeModeData.aimingTarget)

	return true
end

function var4_0.DoAttack(arg0_13, arg1_13, ...)
	if arg1_13 == nil or not arg1_13:IsAlive() or arg0_13:outOfFireRange(arg1_13) then
		arg1_13 = nil

		if arg0_13._strikeModeData.aimingTarget and arg0_13._strikeModeData.aimingFX then
			local var0_13 = var0_0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(arg0_13._strikeModeData.aimingTarget:GetUniqueID())

			if var0_13 then
				var0_13:RemoveFX(arg0_13._strikeModeData.aimingFX)
			end
		end

		arg0_13._strikeModeData.aimingTarget = nil
		arg0_13._strikeModeData.aimingFX = nil
	end

	var0_0.Battle.BattleWeaponUnit.DoAttack(arg0_13, arg1_13, ...)
end

function var4_0.Prepar(arg0_14)
	arg0_14._currentState = arg0_14.STATE_PRECAST

	arg0_14:EnterStrikeMode()
end

function var4_0.Cancel(arg0_15)
	arg0_15._currentState = arg0_15.STATE_READY

	arg0_15:CancelStrikeMode()
end
