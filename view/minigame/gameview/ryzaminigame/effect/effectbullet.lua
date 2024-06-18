local var0_0 = class("EffectBullet", import("view.miniGame.gameView.RyzaMiniGame.effect.TargetEffect"))

function var0_0.GetBaseOrder(arg0_1)
	if arg0_1.mark == "N" then
		return var0_0.super.GetBaseOrder(arg0_1)
	else
		return 500
	end
end

function var0_0.InTimeRiver(arg0_2)
	return true
end

local var1_0 = {
	S = {
		0,
		1
	},
	N = {
		0,
		-1
	},
	E = {
		1,
		0
	},
	W = {
		-1,
		0
	}
}

function var0_0.InitUI(arg0_3, arg1_3)
	arg0_3.mark = arg1_3.mark

	arg0_3._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Bullet_" .. arg0_3.mark)

	arg0_3.dir = NewPos(unpack(var1_0[arg0_3.mark]))
end

function var0_0.GetSpeedDis(arg0_4)
	return 2
end

function var0_0.TimeUpdate(arg0_5, arg1_5)
	local var0_5 = arg0_5.dir * arg0_5:GetSpeedDis() * arg1_5

	if not arg0_5.responder:InRange(arg0_5.realPos + var0_5) then
		arg0_5:Destroy()

		return
	end

	arg0_5:MoveUpdate(var0_5)
	arg0_5:TimeTrigger(arg1_5)
end

function var0_0.MoveUpdate(arg0_6, arg1_6)
	if arg1_6.x == 0 and arg1_6.y == 0 then
		return arg1_6
	end

	arg0_6.realPos = arg0_6.realPos + arg1_6

	arg0_6:UpdatePosition()

	local var0_6 = arg0_6.realPos - arg0_6.pos + arg1_6

	if math.abs(var0_6.x) >= 0.5 or math.abs(var0_6.y) >= 0.5 then
		var0_6.x = math.abs(var0_6.x) < 0.5 and 0 or var0_6.x < 0 and -1 or 1
		var0_6.y = math.abs(var0_6.y) < 0.5 and 0 or var0_6.y < 0 and -1 or 1

		arg0_6:UpdatePos(arg0_6.pos + var0_6)
	end
end

function var0_0.UpdatePos(arg0_7, arg1_7)
	arg0_7.responder:UpdatePos(arg0_7, arg1_7)
	var0_0.super.UpdatePos(arg0_7, arg1_7)
end

function var0_0.TimeTrigger(arg0_8, arg1_8)
	if arg0_8.responder:CollideRyza(arg0_8) then
		arg0_8:Calling("hit", {
			1,
			arg0_8.realPos
		}, MoveRyza)
		arg0_8:Destroy()
	end
end

function var0_0.GetCollideRange(arg0_9)
	local var0_9 = {
		{
			-0.1875,
			0.1875
		},
		{
			-0.1875,
			0.1875
		}
	}

	if arg0_9.dir.x < 0 then
		var0_9[1] = {
			-0.5,
			0.25
		}
	elseif arg0_9.dir.x > 0 then
		var0_9[1] = {
			-0.25,
			0.5
		}
	elseif arg0_9.dir.y < 0 then
		var0_9[2] = {
			-0.5,
			0.25
		}
	elseif arg0_9.dir.y > 0 then
		var0_9[1] = {
			-0.25,
			0.5
		}
	else
		assert(false)
	end

	return {
		var0_9
	}
end

return var0_0
