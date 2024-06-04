local var0 = class("EnemyNavigator", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

var0.SkillDistance = 7

function var0.InitUI(arg0, arg1)
	var0.super.InitUI(arg0, arg1)

	arg0.hp = arg1.hp or 2
	arg0.hpMax = arg0.hp
	arg0.speed = arg1.speed or 3
	arg0.skillCD = 0
	arg0.skillDis = 0
	arg0.rate = arg1.rate or 2
end

local var1 = {
	x = "y",
	y = "x"
}

function var0.TimeUpdate(arg0, arg1)
	if arg0.skillDis > 0 then
		local var0 = arg0:GetSpeedDis() * arg1 * arg0.rate
		local var1 = arg0.dir * var0
		local var2 = arg0.realPos - arg0.pos
		local var3
		local var4

		if var1.x ~= 0 then
			var3 = "x"
		elseif var1.y ~= 0 then
			var3 = "y"
		else
			assert(false)
		end

		local var5 = var1[var3]
		local var6 = true
		local var7 = {}

		local function var8(arg0)
			local var0, var1 = arg0.responder:GetCellPassability(arg0)

			if not var0 then
				if var1 and isa(var1, ObjectBreakable) then
					table.insert(var7, var1)
				else
					var6 = false
				end
			end
		end

		if var2[var3] * (var2[var3] + var1[var3]) <= 0 then
			local var9 = NewPos(arg0.pos.x, arg0.pos.y)

			var9[var3] = var9[var3] + (var1[var3] < 0 and -1 or 1)

			var8(var9)

			if var6 and var2[var5] ~= 0 then
				var9[var5] = var9[var5] + (var2[var5] < 0 and -1 or 1)

				var8(var9)
			end
		end

		if var6 then
			for iter0, iter1 in ipairs(var7) do
				arg0:Calling("break", {}, iter1)
			end

			arg0.skillDis = arg0.skillDis - math.abs(var1[var3])
		end

		if not var6 or arg0.skillDis <= 0 then
			var1[var3] = -var2[var3]
			arg0.skillDis = 0

			arg0:PlayAnim("Attack3_" .. arg0.assaultMark)
		end

		arg0:MoveUpdate(var1)
		arg0:TimeTrigger(arg1)
	else
		var0.super.TimeUpdate(arg0, arg1)
	end
end

local var2 = {
	["0_1"] = "S",
	["1_0"] = "E",
	["-1_0"] = "W",
	["0_-1"] = "N"
}
local var3 = {
	S = {
		0,
		1
	},
	E = {
		1,
		0
	},
	N = {
		0,
		-1
	},
	W = {
		-1,
		0
	}
}

function var0.TimeTrigger(arg0, arg1)
	var0.super.TimeTrigger(arg0, arg1)

	arg0.skillCD = arg0.skillCD - arg1

	if not arg0.lock and arg0.skillCD <= 0 and arg0.responder:SearchRyza(arg0, arg0.search) then
		local var0 = arg0.responder.reactorRyza.pos

		if (arg0.pos.x - var0.x) * (arg0.pos.y - var0.y) == 0 then
			arg0.skillCD = 10
			arg0.skillDis = arg0.SkillDistance
			arg0.assaultMark = string.split(arg0.status, "_")[2]
			arg0.dir = NewPos(unpack(var3[arg0.assaultMark]))

			arg0:PlayAnim("Attack1_" .. arg0.assaultMark)
		end
	end
end

return var0
