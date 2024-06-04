local var0 = class("EffectBullet", import("view.miniGame.gameView.RyzaMiniGame.effect.TargetEffect"))

function var0.GetBaseOrder(arg0)
	if arg0.mark == "N" then
		return var0.super.GetBaseOrder(arg0)
	else
		return 500
	end
end

function var0.InTimeRiver(arg0)
	return true
end

local var1 = {
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

function var0.InitUI(arg0, arg1)
	arg0.mark = arg1.mark

	arg0._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Bullet_" .. arg0.mark)

	arg0.dir = NewPos(unpack(var1[arg0.mark]))
end

function var0.GetSpeedDis(arg0)
	return 2
end

function var0.TimeUpdate(arg0, arg1)
	local var0 = arg0.dir * arg0:GetSpeedDis() * arg1

	if not arg0.responder:InRange(arg0.realPos + var0) then
		arg0:Destroy()

		return
	end

	arg0:MoveUpdate(var0)
	arg0:TimeTrigger(arg1)
end

function var0.MoveUpdate(arg0, arg1)
	if arg1.x == 0 and arg1.y == 0 then
		return arg1
	end

	arg0.realPos = arg0.realPos + arg1

	arg0:UpdatePosition()

	local var0 = arg0.realPos - arg0.pos + arg1

	if math.abs(var0.x) >= 0.5 or math.abs(var0.y) >= 0.5 then
		var0.x = math.abs(var0.x) < 0.5 and 0 or var0.x < 0 and -1 or 1
		var0.y = math.abs(var0.y) < 0.5 and 0 or var0.y < 0 and -1 or 1

		arg0:UpdatePos(arg0.pos + var0)
	end
end

function var0.UpdatePos(arg0, arg1)
	arg0.responder:UpdatePos(arg0, arg1)
	var0.super.UpdatePos(arg0, arg1)
end

function var0.TimeTrigger(arg0, arg1)
	if arg0.responder:CollideRyza(arg0) then
		arg0:Calling("hit", {
			1,
			arg0.realPos
		}, MoveRyza)
		arg0:Destroy()
	end
end

function var0.GetCollideRange(arg0)
	local var0 = {
		{
			-0.1875,
			0.1875
		},
		{
			-0.1875,
			0.1875
		}
	}

	if arg0.dir.x < 0 then
		var0[1] = {
			-0.5,
			0.25
		}
	elseif arg0.dir.x > 0 then
		var0[1] = {
			-0.25,
			0.5
		}
	elseif arg0.dir.y < 0 then
		var0[2] = {
			-0.5,
			0.25
		}
	elseif arg0.dir.y > 0 then
		var0[1] = {
			-0.25,
			0.5
		}
	else
		assert(false)
	end

	return {
		var0
	}
end

return var0
