local var0 = class("TargetMove", import("view.miniGame.gameView.RyzaMiniGame.Reactor"))

function var0.GetBaseOrder(arg0)
	return 2
end

function var0.InTimeRiver(arg0)
	return true
end

function var0.Init(arg0, arg1)
	arg0.rtScale = arg0._tf:Find("scale")

	var0.super.Init(arg0, arg1)
end

function var0.UpdatePos(arg0, arg1)
	arg0.responder:UpdatePos(arg0, arg1)

	for iter0, iter1 in pairs(arg0.rangeDic) do
		arg0.responder:RemoveListener(iter0, arg0, iter1)
	end

	arg0:Calling("leave", {
		arg0
	}, {
		{
			0,
			0
		}
	})
	var0.super.UpdatePos(arg0, arg1)

	for iter2, iter3 in pairs(arg0.rangeDic) do
		arg0.responder:AddListener(iter2, arg0, iter3)
	end

	arg0:Calling("move", {
		arg0
	}, {
		{
			0,
			0
		}
	})
end

function var0.SetHide(arg0, arg1)
	arg0.hide = arg1

	arg0.responder:UpdateHide(arg0, arg1)
end

function var0.GetSpeed(arg0)
	return arg0.speed
end

var0.SpeedDistance = {
	[0] = 1.5,
	2,
	2.5,
	3,
	3.5,
	4,
	4.5,
	5
}

function var0.GetSpeedDis(arg0)
	return arg0.SpeedDistance[arg0:GetSpeed()]
end

function var0.TimeUpdate(arg0, arg1)
	arg0:MoveUpdate(NewPos(0, 0))
end

function var0.MoveUpdate(arg0, arg1)
	if arg1.x == 0 and arg1.y == 0 then
		return arg1
	end

	arg0.realPos = arg0.realPos + arg1

	arg0:UpdatePosition()

	local var0 = arg0.realPos - arg0.pos

	for iter0, iter1 in ipairs({
		"x",
		"y"
	}) do
		if math.abs(var0[iter1]) > 0.5 then
			var0[iter1] = var0[iter1] < 0 and -1 or 1
		else
			var0[iter1] = 0
		end
	end

	if var0.x ~= 0 or var0.y ~= 0 then
		arg0:UpdatePos(arg0.pos + var0)
	end
end

local var1 = {
	x = "y",
	y = "x"
}

function var0.MoveDelta(arg0, arg1, arg2)
	if arg1.x == 0 and arg1.y == 0 or arg2 == 0 then
		return NewPos(0, 0)
	end

	local function var0(arg0)
		local var0 = arg0 - arg0.realPos

		if var0.x * var0.x < 1 and var0.y * var0.y < 1 then
			return true
		else
			return arg0.responder:GetCellPassability(arg0)
		end
	end

	local var1 = {
		x = {
			0,
			0
		},
		y = {
			0,
			0
		}
	}

	for iter0, iter1 in ipairs({
		"x",
		"y"
	}) do
		for iter2, iter3 in ipairs({
			-1,
			1
		}) do
			local var2 = NewPos(arg0.pos.x, arg0.pos.y)

			var2[iter1] = var2[iter1] + iter3

			if var0(var2) then
				var1[iter1][iter2] = var1[iter1][iter2] + iter3
			end
		end
	end

	local var3 = arg0.realPos - arg0.pos
	local var4 = var3 + arg1 * arg2

	var4.x = math.clamp(var4.x, unpack(var1.x))
	var4.y = math.clamp(var4.y, unpack(var1.y))

	if var4.x == 0 and var4.y == 0 then
		return var4 - var3
	elseif var4.x == 0 then
		var4.y = math.clamp(var3.y + arg1.y * arg2, unpack(var1.y))

		return var4 - var3
	elseif var4.y == 0 then
		var4.x = math.clamp(var3.x + arg1.x * arg2, unpack(var1.x))

		return var4 - var3
	else
		local var5 = NewPos(arg0.pos.x + (var4.x < 0 and -1 or 1), arg0.pos.y + (var4.y < 0 and -1 or 1))

		if not var0(var5) then
			local var6 = arg1.y * arg1.y > arg1.x * arg1.x and "y" or "x"
			local var7 = var1[var6]
			local var8 = NewPos(0, 0)

			if var3[var7] * var3[var7] > arg2 * arg2 then
				var8[var6] = -var3[var6]
				var8[var7] = (-var3[var7] < 0 and -1 or 1) * math.sqrt(arg2 * arg2 - var8[var6] * var8[var6])
			else
				var8[var7] = -var3[var7]
				var8[var6] = (arg1[var6] < 0 and -1 or 1) * math.sqrt(arg2 * arg2 - var8[var7] * var8[var7])
			end

			local var9 = var3 + var8

			var9.x = math.clamp(var9.x, unpack(var1.x))
			var9.y = math.clamp(var9.y, unpack(var1.y))

			return var9 - var3
		else
			return arg1 * arg2
		end
	end
end

function var0.GetMoveInfo(arg0)
	return arg0.pos, NewPos(0, 0)
end

function var0.GetCollideRange(arg0)
	return {
		{
			{
				-0.5,
				0.5
			},
			{
				-0.5,
				0.5
			}
		}
	}
end

var0.loopDic = {}

function var0.PlayAnim(arg0, arg1)
	if arg0.status ~= arg1 then
		arg0.status = arg1

		if not arg0.loopDic[string.split(arg1, "_")[1]] then
			arg0.lock = true
		end

		arg0.mainTarget:GetComponent(typeof(Animator)):Play(arg1)
	end
end

return var0
