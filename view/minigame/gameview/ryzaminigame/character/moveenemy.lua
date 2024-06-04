local var0 = class("MoveEnemy", import("view.miniGame.gameView.RyzaMiniGame.character.TargetMove"))

function var0.InitUI(arg0, arg1)
	arg0.hp = arg1.hp or 3
	arg0.hpMax = arg0.hp
	arg0.speed = arg1.speed or 1
	arg0.search = arg1.search or 4
	arg0.wander = arg1.wander or 3
	arg0.mainTarget = arg0.rtScale:Find("main")

	arg0:PlayWait()
	arg0.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0.lock = false

		if arg0.hp <= 0 then
			arg0:Destroy()
		end
	end)
end

function var0.InitRegister(arg0, arg1)
	arg0:Register("burn", function()
		arg0:Hurt(1)
	end, {
		{
			0,
			0
		}
	})
end

function var0.Hurt(arg0, arg1)
	arg0.hp = arg0.hp - arg1

	arg0.responder:SyncStatus(arg0, "hp", {
		num = arg0.hp,
		max = arg0.hpMax
	})

	if arg0.hp > 0 then
		arg0:PlayDamage()
	else
		arg0:DeregisterAll()
		arg0:PlayDead()
	end
end

var0.SpeedDistance = {
	[0] = 0,
	1,
	1.5,
	2,
	2.5,
	3,
	3.5,
	4
}

function var0.TimeUpdate(arg0, arg1)
	if not arg0.lock then
		local var0, var1 = arg0:GetMoveInfo()
		local var2

		if var0 then
			var2 = arg0:MoveDelta(var0, arg0:GetSpeedDis() * arg1)

			arg0:ClearWander()
		else
			local var3
			local var4

			if not arg0.wanderPos then
				arg0.wanderPos = arg0.pos
				arg0.wanderDir = NewPos(0, 0)
				arg0.wanderTime = 1.5
			end

			if arg1 >= arg0.wanderTime then
				arg0.wanderDir = (arg0.wanderPos + NewPos(math.random() * 2 - 1, math.random() * 2 - 1) * arg0.wander - arg0.realPos):Normalize()
			end

			var2 = var0.super.MoveDelta(arg0, arg0.wanderDir, arg0:GetSpeedDis() * arg1)

			if var2.x == 0 and var2.y == 0 then
				arg0.wanderTime = arg0.wanderTime - arg1
			else
				arg0.wanderTime = 1.5
			end

			arg0.wanderDir = var2:Normalize()
			var1 = arg0.wanderDir
		end

		if var1.x == 0 and var1.y == 0 then
			arg0:PlayWait()
		else
			arg0:PlayMove(RyzaMiniGameConfig.GetFourDirMark(var1))
		end

		arg0:MoveUpdate(var2)
	end

	arg0:TimeTrigger(arg1)

	if arg0.hide then
		arg0:UpdateAlpha()
	end
end

function var0.MoveDelta(arg0, arg1, arg2)
	local var0 = arg1 - arg0.realPos

	if var0.x == 0 and var0.y == 0 then
		return NewPos(0, 0)
	else
		return var0 * math.min(1, arg2 / math.sqrt(var0:SqrMagnitude()))
	end
end

function var0.GetMoveInfo(arg0)
	if arg0.responder:SearchRyza(arg0, arg0.search) then
		local var0 = arg0.responder:Wayfinding(arg0)

		if var0 and #var0 > 0 then
			local var1 = var0[#var0]
			local var2 = var1 - arg0.realPos
			local var3 = var1 - arg0.pos

			if var2:SqrMagnitude() > var3:SqrMagnitude() then
				var1 = arg0.pos
			end

			local var4 = var1 - arg0.realPos

			if var4.x ~= 0 or var4.y ~= 0 then
				var4 = var4 * (1 / math.sqrt(var4:SqrMagnitude()))
			end

			return var1, var4
		end
	end

	return nil, NewPos(0, 0)
end

function var0.ClearWander(arg0)
	arg0.wanderPos = nil
	arg0.wanderDir = nil
	arg0.wanderTime = nil
end

function var0.PlayWait(arg0)
	arg0:PlayAnim("Wait_" .. (string.split(arg0.status, "_")[2] or "S"))
end

function var0.PlayMove(arg0, arg1)
	arg0:PlayAnim("Move_" .. arg1)
end

function var0.PlayDamage(arg0)
	if not arg0.lock then
		arg0:PlayAnim("Damage_" .. (string.split(arg0.status, "_")[2] or "S"))
	end
end

function var0.PlayDead(arg0)
	arg0:SetHide(false)
	arg0:PlayAnim("Dead_" .. (string.split(arg0.status, "_")[2] or "S"))
end

var0.loopDic = {
	Wait = true,
	Move = true
}

function var0.GetUIHeight(arg0)
	return 128
end

function var0.SetHide(arg0, arg1)
	var0.super.SetHide(arg0, arg1)
	arg0:UpdateAlpha()
end

local var1 = 7

function var0.UpdateAlpha(arg0)
	local var0 = 1
	local var1 = not arg0.hide and 1 or arg0.responder.reactorRyza.hide and (arg0.responder.reactorRyza.realPos - arg0.realPos):SqrMagnitude() < var1 * var1 and 0.7 or 0

	GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).alpha = var1
end

function var0.TimeTrigger(arg0, arg1)
	if arg0.hp > 0 and arg0.responder:CollideRyza(arg0) then
		arg0:Calling("hit", {
			1,
			arg0.realPos
		}, MoveRyza)
	end
end

return var0
