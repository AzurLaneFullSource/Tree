local var0 = class("TowerClimbingPlayerVO")
local var1 = 0
local var2 = 1
local var3 = 2
local var4 = 3
local var5 = 4
local var6 = 5
local var7 = 6

function var0.Ctor(arg0, arg1, arg2)
	arg0.view = arg1
	arg0.id = arg2.id
	arg0.life = arg2.life
	arg0.pageIndex = arg2.pageIndex
	arg0.higestscore = arg2.higestscore or 0
	arg0.shipConfig = pg.ship_data_statistics[arg0.id]
	arg0.skinId = arg0.shipConfig.skin_id
	arg0.shipName = pg.ship_skin_template[arg0.skinId].prefab
	arg0.mapScore = arg2.mapScore or 0
	arg0.verticalVelocity = TowerClimbingGameSettings.JUMP_VELOCITY
	arg0.horizontalVelocity = TowerClimbingGameSettings.MOVE_VELOCITY
	arg0.beInjuredVelocity = TowerClimbingGameSettings.BEINJURED_VELOCITY
	arg0.state = var1
	arg0.isStand = true
	arg0.prevMoveDir = var3
	arg0.score = 0
	arg0.isStand = true
	arg0.InvincibleTime = 0
end

function var0.IsOverMapScore(arg0)
	return arg0.score > arg0.mapScore
end

function var0.UpdateStand(arg0, arg1)
	arg0.isStand = arg1
end

function var0.SetPosition(arg0, arg1)
	arg0.position = arg1

	arg0:SendPlayerEvent("ChangePosition", arg1)
end

function var0.GetShipName(arg0)
	return arg0.shipName
end

function var0.CanJump(arg0)
	return not arg0:IsDeath() and arg0.state ~= var2 and arg0.isStand
end

function var0.Jump(arg0)
	if arg0:IsFatalInjured() then
		return
	end

	if not arg0:CanJump() then
		return
	end

	arg0:SendPlayerEvent("Jump", arg0.verticalVelocity)

	arg0.state = var2
end

function var0.MoveRight(arg0)
	if arg0:IsFatalInjured() then
		return
	end

	if arg0:IsDeath() then
		return
	end

	arg0.prevMoveDir = var4

	arg0:SendPlayerEvent("MoveRight", arg0.horizontalVelocity)

	arg0.state = var4
end

function var0.MoveLeft(arg0)
	if arg0:IsFatalInjured() then
		return
	end

	if arg0:IsDeath() then
		return
	end

	arg0.prevMoveDir = var3

	arg0:SendPlayerEvent("MoveLeft", arg0.horizontalVelocity)

	arg0.state = var3
end

function var0.Idle(arg0)
	if arg0:IsDeath() then
		return
	end

	arg0:SendPlayerEvent("Idle")

	arg0.state = var1
end

function var0.BeInjured(arg0)
	if arg0:IsFatalInjured() then
		return
	end

	if arg0:IsDeath() then
		return
	end

	local var0 = arg0.beInjuredVelocity

	if arg0.prevMoveDir == var4 then
		var0.x = -var0.x
	end

	arg0:SendPlayerEvent("BeInjured", var0)

	arg0.state = var5

	arg0:ReduceLife(1)
end

function var0.BeFatalInjured(arg0, arg1)
	if arg0:IsFatalInjured() then
		return
	end

	if arg0:IsDeath() then
		return
	end

	arg0.state = var7

	arg0:ReduceLife(1)
	arg0:SendPlayerEvent("BeFatalInjured", arg1)
end

function var0.ReduceLife(arg0, arg1)
	arg0.life = arg0.life - arg1

	if arg0.life == 0 then
		arg0.state = var6

		arg0:SendPlayerEvent("Dead")
	end

	arg0:SendMapEvent("OnPlayerLifeUpdate", arg0.life)
end

function var0.IsIdle(arg0)
	return arg0.state == var1
end

function var0.IsDeath(arg0)
	return arg0.state == var6
end

function var0.IsFatalInjured(arg0)
	return arg0.state == var7
end

function var0.AddScore(arg0)
	arg0.score = arg0.score + 1

	arg0:SendMapEvent("OnScoreUpdate", arg0.score)
end

function var0.AddInvincibleEffect(arg0, arg1)
	local var0 = arg0:IsInvincible()

	arg0.InvincibleTime = arg1

	local var1 = arg0:IsInvincible()

	if var0 ~= var1 then
		arg0:SendPlayerEvent("Invincible", var1)
	end
end

function var0.GetInvincibleTime(arg0)
	return arg0.InvincibleTime
end

function var0.SetInvincibleTime(arg0, arg1)
	arg0:AddInvincibleEffect(arg1)
end

function var0.IsInvincible(arg0)
	return arg0.InvincibleTime > 0
end

function var0.SendPlayerEvent(arg0, arg1, ...)
	local var0 = arg0.view.map:GetPlayer()

	var0[arg1](var0, unpack({
		...
	}))
end

function var0.SendMapEvent(arg0, arg1, ...)
	local var0 = arg0.view.map

	var0[arg1](var0, unpack({
		...
	}))
end

function var0.IsOverHigestScore(arg0)
	return arg0.score > arg0.higestscore
end

function var0.Dispose(arg0)
	return
end

return var0
