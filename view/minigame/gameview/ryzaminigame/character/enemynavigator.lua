local var0_0 = class("EnemyNavigator", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

var0_0.SkillDistance = 7

function var0_0.InitUI(arg0_1, arg1_1)
	var0_0.super.InitUI(arg0_1, arg1_1)

	arg0_1.hp = arg1_1.hp or 2
	arg0_1.hpMax = arg0_1.hp
	arg0_1.speed = arg1_1.speed or 3
	arg0_1.skillCD = 0
	arg0_1.skillDis = 0
	arg0_1.rate = arg1_1.rate or 2
end

local var1_0 = {
	x = "y",
	y = "x"
}

function var0_0.TimeUpdate(arg0_2, arg1_2)
	if arg0_2.skillDis > 0 then
		local var0_2 = arg0_2:GetSpeedDis() * arg1_2 * arg0_2.rate
		local var1_2 = arg0_2.dir * var0_2
		local var2_2 = arg0_2.realPos - arg0_2.pos
		local var3_2
		local var4_2

		if var1_2.x ~= 0 then
			var3_2 = "x"
		elseif var1_2.y ~= 0 then
			var3_2 = "y"
		else
			assert(false)
		end

		local var5_2 = var1_0[var3_2]
		local var6_2 = true
		local var7_2 = {}

		local function var8_2(arg0_3)
			local var0_3, var1_3 = arg0_2.responder:GetCellPassability(arg0_3)

			if not var0_3 then
				if var1_3 and isa(var1_3, ObjectBreakable) then
					table.insert(var7_2, var1_3)
				else
					var6_2 = false
				end
			end
		end

		if var2_2[var3_2] * (var2_2[var3_2] + var1_2[var3_2]) <= 0 then
			local var9_2 = NewPos(arg0_2.pos.x, arg0_2.pos.y)

			var9_2[var3_2] = var9_2[var3_2] + (var1_2[var3_2] < 0 and -1 or 1)

			var8_2(var9_2)

			if var6_2 and var2_2[var5_2] ~= 0 then
				var9_2[var5_2] = var9_2[var5_2] + (var2_2[var5_2] < 0 and -1 or 1)

				var8_2(var9_2)
			end
		end

		if var6_2 then
			for iter0_2, iter1_2 in ipairs(var7_2) do
				arg0_2:Calling("break", {}, iter1_2)
			end

			arg0_2.skillDis = arg0_2.skillDis - math.abs(var1_2[var3_2])
		end

		if not var6_2 or arg0_2.skillDis <= 0 then
			var1_2[var3_2] = -var2_2[var3_2]
			arg0_2.skillDis = 0

			arg0_2:PlayAnim("Attack3_" .. arg0_2.assaultMark)
		end

		arg0_2:MoveUpdate(var1_2)
		arg0_2:TimeTrigger(arg1_2)
	else
		var0_0.super.TimeUpdate(arg0_2, arg1_2)
	end
end

local var2_0 = {
	["0_1"] = "S",
	["1_0"] = "E",
	["-1_0"] = "W",
	["0_-1"] = "N"
}
local var3_0 = {
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

function var0_0.TimeTrigger(arg0_4, arg1_4)
	var0_0.super.TimeTrigger(arg0_4, arg1_4)

	arg0_4.skillCD = arg0_4.skillCD - arg1_4

	if not arg0_4.lock and arg0_4.skillCD <= 0 and arg0_4.responder:SearchRyza(arg0_4, arg0_4.search) then
		local var0_4 = arg0_4.responder.reactorRyza.pos

		if (arg0_4.pos.x - var0_4.x) * (arg0_4.pos.y - var0_4.y) == 0 then
			arg0_4.skillCD = 10
			arg0_4.skillDis = arg0_4.SkillDistance
			arg0_4.assaultMark = string.split(arg0_4.status, "_")[2]
			arg0_4.dir = NewPos(unpack(var3_0[arg0_4.assaultMark]))

			arg0_4:PlayAnim("Attack1_" .. arg0_4.assaultMark)
		end
	end
end

return var0_0
