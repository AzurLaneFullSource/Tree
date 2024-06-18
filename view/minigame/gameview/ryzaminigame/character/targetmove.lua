local var0_0 = class("TargetMove", import("view.miniGame.gameView.RyzaMiniGame.Reactor"))

function var0_0.GetBaseOrder(arg0_1)
	return 2
end

function var0_0.InTimeRiver(arg0_2)
	return true
end

function var0_0.Init(arg0_3, arg1_3)
	arg0_3.rtScale = arg0_3._tf:Find("scale")

	var0_0.super.Init(arg0_3, arg1_3)
end

function var0_0.UpdatePos(arg0_4, arg1_4)
	arg0_4.responder:UpdatePos(arg0_4, arg1_4)

	for iter0_4, iter1_4 in pairs(arg0_4.rangeDic) do
		arg0_4.responder:RemoveListener(iter0_4, arg0_4, iter1_4)
	end

	arg0_4:Calling("leave", {
		arg0_4
	}, {
		{
			0,
			0
		}
	})
	var0_0.super.UpdatePos(arg0_4, arg1_4)

	for iter2_4, iter3_4 in pairs(arg0_4.rangeDic) do
		arg0_4.responder:AddListener(iter2_4, arg0_4, iter3_4)
	end

	arg0_4:Calling("move", {
		arg0_4
	}, {
		{
			0,
			0
		}
	})
end

function var0_0.SetHide(arg0_5, arg1_5)
	arg0_5.hide = arg1_5

	arg0_5.responder:UpdateHide(arg0_5, arg1_5)
end

function var0_0.GetSpeed(arg0_6)
	return arg0_6.speed
end

var0_0.SpeedDistance = {
	[0] = 1.5,
	2,
	2.5,
	3,
	3.5,
	4,
	4.5,
	5
}

function var0_0.GetSpeedDis(arg0_7)
	return arg0_7.SpeedDistance[arg0_7:GetSpeed()]
end

function var0_0.TimeUpdate(arg0_8, arg1_8)
	arg0_8:MoveUpdate(NewPos(0, 0))
end

function var0_0.MoveUpdate(arg0_9, arg1_9)
	if arg1_9.x == 0 and arg1_9.y == 0 then
		return arg1_9
	end

	arg0_9.realPos = arg0_9.realPos + arg1_9

	arg0_9:UpdatePosition()

	local var0_9 = arg0_9.realPos - arg0_9.pos

	for iter0_9, iter1_9 in ipairs({
		"x",
		"y"
	}) do
		if math.abs(var0_9[iter1_9]) > 0.5 then
			var0_9[iter1_9] = var0_9[iter1_9] < 0 and -1 or 1
		else
			var0_9[iter1_9] = 0
		end
	end

	if var0_9.x ~= 0 or var0_9.y ~= 0 then
		arg0_9:UpdatePos(arg0_9.pos + var0_9)
	end
end

local var1_0 = {
	x = "y",
	y = "x"
}

function var0_0.MoveDelta(arg0_10, arg1_10, arg2_10)
	if arg1_10.x == 0 and arg1_10.y == 0 or arg2_10 == 0 then
		return NewPos(0, 0)
	end

	local function var0_10(arg0_11)
		local var0_11 = arg0_11 - arg0_10.realPos

		if var0_11.x * var0_11.x < 1 and var0_11.y * var0_11.y < 1 then
			return true
		else
			return arg0_10.responder:GetCellPassability(arg0_11)
		end
	end

	local var1_10 = {
		x = {
			0,
			0
		},
		y = {
			0,
			0
		}
	}

	for iter0_10, iter1_10 in ipairs({
		"x",
		"y"
	}) do
		for iter2_10, iter3_10 in ipairs({
			-1,
			1
		}) do
			local var2_10 = NewPos(arg0_10.pos.x, arg0_10.pos.y)

			var2_10[iter1_10] = var2_10[iter1_10] + iter3_10

			if var0_10(var2_10) then
				var1_10[iter1_10][iter2_10] = var1_10[iter1_10][iter2_10] + iter3_10
			end
		end
	end

	local var3_10 = arg0_10.realPos - arg0_10.pos
	local var4_10 = var3_10 + arg1_10 * arg2_10

	var4_10.x = math.clamp(var4_10.x, unpack(var1_10.x))
	var4_10.y = math.clamp(var4_10.y, unpack(var1_10.y))

	if var4_10.x == 0 and var4_10.y == 0 then
		return var4_10 - var3_10
	elseif var4_10.x == 0 then
		var4_10.y = math.clamp(var3_10.y + arg1_10.y * arg2_10, unpack(var1_10.y))

		return var4_10 - var3_10
	elseif var4_10.y == 0 then
		var4_10.x = math.clamp(var3_10.x + arg1_10.x * arg2_10, unpack(var1_10.x))

		return var4_10 - var3_10
	else
		local var5_10 = NewPos(arg0_10.pos.x + (var4_10.x < 0 and -1 or 1), arg0_10.pos.y + (var4_10.y < 0 and -1 or 1))

		if not var0_10(var5_10) then
			local var6_10 = arg1_10.y * arg1_10.y > arg1_10.x * arg1_10.x and "y" or "x"
			local var7_10 = var1_0[var6_10]
			local var8_10 = NewPos(0, 0)

			if var3_10[var7_10] * var3_10[var7_10] > arg2_10 * arg2_10 then
				var8_10[var6_10] = -var3_10[var6_10]
				var8_10[var7_10] = (-var3_10[var7_10] < 0 and -1 or 1) * math.sqrt(arg2_10 * arg2_10 - var8_10[var6_10] * var8_10[var6_10])
			else
				var8_10[var7_10] = -var3_10[var7_10]
				var8_10[var6_10] = (arg1_10[var6_10] < 0 and -1 or 1) * math.sqrt(arg2_10 * arg2_10 - var8_10[var7_10] * var8_10[var7_10])
			end

			local var9_10 = var3_10 + var8_10

			var9_10.x = math.clamp(var9_10.x, unpack(var1_10.x))
			var9_10.y = math.clamp(var9_10.y, unpack(var1_10.y))

			return var9_10 - var3_10
		else
			return arg1_10 * arg2_10
		end
	end
end

function var0_0.GetMoveInfo(arg0_12)
	return arg0_12.pos, NewPos(0, 0)
end

function var0_0.GetCollideRange(arg0_13)
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

var0_0.loopDic = {}

function var0_0.PlayAnim(arg0_14, arg1_14)
	if arg0_14.status ~= arg1_14 then
		arg0_14.status = arg1_14

		if not arg0_14.loopDic[string.split(arg1_14, "_")[1]] then
			arg0_14.lock = true
		end

		arg0_14.mainTarget:GetComponent(typeof(Animator)):Play(arg1_14)
	end
end

return var0_0
