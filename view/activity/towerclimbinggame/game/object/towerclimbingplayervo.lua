local var0_0 = class("TowerClimbingPlayerVO")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3
local var5_0 = 4
local var6_0 = 5
local var7_0 = 6

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.view = arg1_1
	arg0_1.id = arg2_1.id
	arg0_1.life = arg2_1.life
	arg0_1.pageIndex = arg2_1.pageIndex
	arg0_1.higestscore = arg2_1.higestscore or 0
	arg0_1.shipConfig = pg.ship_data_statistics[arg0_1.id]
	arg0_1.skinId = arg0_1.shipConfig.skin_id
	arg0_1.shipName = pg.ship_skin_template[arg0_1.skinId].prefab
	arg0_1.mapScore = arg2_1.mapScore or 0
	arg0_1.verticalVelocity = TowerClimbingGameSettings.JUMP_VELOCITY
	arg0_1.horizontalVelocity = TowerClimbingGameSettings.MOVE_VELOCITY
	arg0_1.beInjuredVelocity = TowerClimbingGameSettings.BEINJURED_VELOCITY
	arg0_1.state = var1_0
	arg0_1.isStand = true
	arg0_1.prevMoveDir = var3_0
	arg0_1.score = 0
	arg0_1.isStand = true
	arg0_1.InvincibleTime = 0
end

function var0_0.IsOverMapScore(arg0_2)
	return arg0_2.score > arg0_2.mapScore
end

function var0_0.UpdateStand(arg0_3, arg1_3)
	arg0_3.isStand = arg1_3
end

function var0_0.SetPosition(arg0_4, arg1_4)
	arg0_4.position = arg1_4

	arg0_4:SendPlayerEvent("ChangePosition", arg1_4)
end

function var0_0.GetShipName(arg0_5)
	return arg0_5.shipName
end

function var0_0.CanJump(arg0_6)
	return not arg0_6:IsDeath() and arg0_6.state ~= var2_0 and arg0_6.isStand
end

function var0_0.Jump(arg0_7)
	if arg0_7:IsFatalInjured() then
		return
	end

	if not arg0_7:CanJump() then
		return
	end

	arg0_7:SendPlayerEvent("Jump", arg0_7.verticalVelocity)

	arg0_7.state = var2_0
end

function var0_0.MoveRight(arg0_8)
	if arg0_8:IsFatalInjured() then
		return
	end

	if arg0_8:IsDeath() then
		return
	end

	arg0_8.prevMoveDir = var4_0

	arg0_8:SendPlayerEvent("MoveRight", arg0_8.horizontalVelocity)

	arg0_8.state = var4_0
end

function var0_0.MoveLeft(arg0_9)
	if arg0_9:IsFatalInjured() then
		return
	end

	if arg0_9:IsDeath() then
		return
	end

	arg0_9.prevMoveDir = var3_0

	arg0_9:SendPlayerEvent("MoveLeft", arg0_9.horizontalVelocity)

	arg0_9.state = var3_0
end

function var0_0.Idle(arg0_10)
	if arg0_10:IsDeath() then
		return
	end

	arg0_10:SendPlayerEvent("Idle")

	arg0_10.state = var1_0
end

function var0_0.BeInjured(arg0_11)
	if arg0_11:IsFatalInjured() then
		return
	end

	if arg0_11:IsDeath() then
		return
	end

	local var0_11 = arg0_11.beInjuredVelocity

	if arg0_11.prevMoveDir == var4_0 then
		var0_11.x = -var0_11.x
	end

	arg0_11:SendPlayerEvent("BeInjured", var0_11)

	arg0_11.state = var5_0

	arg0_11:ReduceLife(1)
end

function var0_0.BeFatalInjured(arg0_12, arg1_12)
	if arg0_12:IsFatalInjured() then
		return
	end

	if arg0_12:IsDeath() then
		return
	end

	arg0_12.state = var7_0

	arg0_12:ReduceLife(1)
	arg0_12:SendPlayerEvent("BeFatalInjured", arg1_12)
end

function var0_0.ReduceLife(arg0_13, arg1_13)
	arg0_13.life = arg0_13.life - arg1_13

	if arg0_13.life == 0 then
		arg0_13.state = var6_0

		arg0_13:SendPlayerEvent("Dead")
	end

	arg0_13:SendMapEvent("OnPlayerLifeUpdate", arg0_13.life)
end

function var0_0.IsIdle(arg0_14)
	return arg0_14.state == var1_0
end

function var0_0.IsDeath(arg0_15)
	return arg0_15.state == var6_0
end

function var0_0.IsFatalInjured(arg0_16)
	return arg0_16.state == var7_0
end

function var0_0.AddScore(arg0_17)
	arg0_17.score = arg0_17.score + 1

	arg0_17:SendMapEvent("OnScoreUpdate", arg0_17.score)
end

function var0_0.AddInvincibleEffect(arg0_18, arg1_18)
	local var0_18 = arg0_18:IsInvincible()

	arg0_18.InvincibleTime = arg1_18

	local var1_18 = arg0_18:IsInvincible()

	if var0_18 ~= var1_18 then
		arg0_18:SendPlayerEvent("Invincible", var1_18)
	end
end

function var0_0.GetInvincibleTime(arg0_19)
	return arg0_19.InvincibleTime
end

function var0_0.SetInvincibleTime(arg0_20, arg1_20)
	arg0_20:AddInvincibleEffect(arg1_20)
end

function var0_0.IsInvincible(arg0_21)
	return arg0_21.InvincibleTime > 0
end

function var0_0.SendPlayerEvent(arg0_22, arg1_22, ...)
	local var0_22 = arg0_22.view.map:GetPlayer()

	var0_22[arg1_22](var0_22, unpack({
		...
	}))
end

function var0_0.SendMapEvent(arg0_23, arg1_23, ...)
	local var0_23 = arg0_23.view.map

	var0_23[arg1_23](var0_23, unpack({
		...
	}))
end

function var0_0.IsOverHigestScore(arg0_24)
	return arg0_24.score > arg0_24.higestscore
end

function var0_0.Dispose(arg0_25)
	return
end

return var0_0
