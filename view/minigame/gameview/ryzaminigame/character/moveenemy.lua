local var0_0 = class("MoveEnemy", import("view.miniGame.gameView.RyzaMiniGame.character.TargetMove"))

function var0_0.InitUI(arg0_1, arg1_1)
	arg0_1.hp = arg1_1.hp or 3
	arg0_1.hpMax = arg0_1.hp
	arg0_1.speed = arg1_1.speed or 1
	arg0_1.search = arg1_1.search or 4
	arg0_1.wander = arg1_1.wander or 3
	arg0_1.mainTarget = arg0_1.rtScale:Find("main")

	arg0_1:PlayWait()
	arg0_1.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_1.lock = false

		if arg0_1.hp <= 0 then
			arg0_1:Destroy()
		end
	end)
end

function var0_0.InitRegister(arg0_3, arg1_3)
	arg0_3:Register("burn", function()
		arg0_3:Hurt(1)
	end, {
		{
			0,
			0
		}
	})
end

function var0_0.Hurt(arg0_5, arg1_5)
	arg0_5.hp = arg0_5.hp - arg1_5

	arg0_5.responder:SyncStatus(arg0_5, "hp", {
		num = arg0_5.hp,
		max = arg0_5.hpMax
	})

	if arg0_5.hp > 0 then
		arg0_5:PlayDamage()
	else
		arg0_5:DeregisterAll()
		arg0_5:PlayDead()
	end
end

var0_0.SpeedDistance = {
	[0] = 0,
	1,
	1.5,
	2,
	2.5,
	3,
	3.5,
	4
}

function var0_0.TimeUpdate(arg0_6, arg1_6)
	if not arg0_6.lock then
		local var0_6, var1_6 = arg0_6:GetMoveInfo()
		local var2_6

		if var0_6 then
			var2_6 = arg0_6:MoveDelta(var0_6, arg0_6:GetSpeedDis() * arg1_6)

			arg0_6:ClearWander()
		else
			local var3_6
			local var4_6

			if not arg0_6.wanderPos then
				arg0_6.wanderPos = arg0_6.pos
				arg0_6.wanderDir = NewPos(0, 0)
				arg0_6.wanderTime = 1.5
			end

			if arg1_6 >= arg0_6.wanderTime then
				arg0_6.wanderDir = (arg0_6.wanderPos + NewPos(math.random() * 2 - 1, math.random() * 2 - 1) * arg0_6.wander - arg0_6.realPos):Normalize()
			end

			var2_6 = var0_0.super.MoveDelta(arg0_6, arg0_6.wanderDir, arg0_6:GetSpeedDis() * arg1_6)

			if var2_6.x == 0 and var2_6.y == 0 then
				arg0_6.wanderTime = arg0_6.wanderTime - arg1_6
			else
				arg0_6.wanderTime = 1.5
			end

			arg0_6.wanderDir = var2_6:Normalize()
			var1_6 = arg0_6.wanderDir
		end

		if var1_6.x == 0 and var1_6.y == 0 then
			arg0_6:PlayWait()
		else
			arg0_6:PlayMove(RyzaMiniGameConfig.GetFourDirMark(var1_6))
		end

		arg0_6:MoveUpdate(var2_6)
	end

	arg0_6:TimeTrigger(arg1_6)

	if arg0_6.hide then
		arg0_6:UpdateAlpha()
	end
end

function var0_0.MoveDelta(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7 - arg0_7.realPos

	if var0_7.x == 0 and var0_7.y == 0 then
		return NewPos(0, 0)
	else
		return var0_7 * math.min(1, arg2_7 / math.sqrt(var0_7:SqrMagnitude()))
	end
end

function var0_0.GetMoveInfo(arg0_8)
	if arg0_8.responder:SearchRyza(arg0_8, arg0_8.search) then
		local var0_8 = arg0_8.responder:Wayfinding(arg0_8)

		if var0_8 and #var0_8 > 0 then
			local var1_8 = var0_8[#var0_8]
			local var2_8 = var1_8 - arg0_8.realPos
			local var3_8 = var1_8 - arg0_8.pos

			if var2_8:SqrMagnitude() > var3_8:SqrMagnitude() then
				var1_8 = arg0_8.pos
			end

			local var4_8 = var1_8 - arg0_8.realPos

			if var4_8.x ~= 0 or var4_8.y ~= 0 then
				var4_8 = var4_8 * (1 / math.sqrt(var4_8:SqrMagnitude()))
			end

			return var1_8, var4_8
		end
	end

	return nil, NewPos(0, 0)
end

function var0_0.ClearWander(arg0_9)
	arg0_9.wanderPos = nil
	arg0_9.wanderDir = nil
	arg0_9.wanderTime = nil
end

function var0_0.PlayWait(arg0_10)
	arg0_10:PlayAnim("Wait_" .. (string.split(arg0_10.status, "_")[2] or "S"))
end

function var0_0.PlayMove(arg0_11, arg1_11)
	arg0_11:PlayAnim("Move_" .. arg1_11)
end

function var0_0.PlayDamage(arg0_12)
	if not arg0_12.lock then
		arg0_12:PlayAnim("Damage_" .. (string.split(arg0_12.status, "_")[2] or "S"))
	end
end

function var0_0.PlayDead(arg0_13)
	arg0_13:SetHide(false)
	arg0_13:PlayAnim("Dead_" .. (string.split(arg0_13.status, "_")[2] or "S"))
end

var0_0.loopDic = {
	Wait = true,
	Move = true
}

function var0_0.GetUIHeight(arg0_14)
	return 128
end

function var0_0.SetHide(arg0_15, arg1_15)
	var0_0.super.SetHide(arg0_15, arg1_15)
	arg0_15:UpdateAlpha()
end

local var1_0 = 7

function var0_0.UpdateAlpha(arg0_16)
	local var0_16 = 1
	local var1_16 = not arg0_16.hide and 1 or arg0_16.responder.reactorRyza.hide and (arg0_16.responder.reactorRyza.realPos - arg0_16.realPos):SqrMagnitude() < var1_0 * var1_0 and 0.7 or 0

	GetOrAddComponent(arg0_16._tf, typeof(CanvasGroup)).alpha = var1_16
end

function var0_0.TimeTrigger(arg0_17, arg1_17)
	if arg0_17.hp > 0 and arg0_17.responder:CollideRyza(arg0_17) then
		arg0_17:Calling("hit", {
			1,
			arg0_17.realPos
		}, MoveRyza)
	end
end

return var0_0
