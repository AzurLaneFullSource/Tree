local var0_0 = class("EnemyConductor", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

var0_0.ConfigShildList = {
	2,
	0,
	0,
	0
}
var0_0.BlockRange = 1

local var1_0 = {
	"S",
	"E",
	"N",
	"W"
}

function var0_0.InitUI(arg0_1, arg1_1)
	arg0_1.shieldCount = underscore.rest(arg0_1.ConfigShildList, 1)
	arg0_1.rtShieldDic = {
		S = arg0_1.rtScale:Find("front/Shield_S"),
		E = arg0_1.rtScale:Find("front/Shield_E"),
		N = arg0_1.rtScale:Find("back/Shield_N"),
		W = arg0_1.rtScale:Find("front/Shield_W")
	}

	for iter0_1, iter1_1 in ipairs({
		"front",
		"back"
	}) do
		eachChild(arg0_1.rtScale:Find(iter1_1), function(arg0_2)
			arg0_2:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				setActive(arg0_2:Find("Image"), false)
				setActive(arg0_2, false)
				setImageAlpha(arg0_2, 1)
			end)
			arg0_2:Find("Protect"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				setActive(arg0_2:Find("Protect"), false)

				local var0_4 = (table.indexof(var1_0, string.split(arg0_2.name, "_")[2]) - table.indexof(var1_0, arg0_1.statusMark) + 4) % 4 + 1

				if arg0_1.shieldCount[var0_4] <= 0 then
					setImageAlpha(arg0_2, 0)
					setActive(arg0_2:Find("Image"), true)
				end
			end)
		end)
	end

	var0_0.super.InitUI(arg0_1, arg1_1)

	arg0_1.hp = arg1_1.hp or 2
	arg0_1.hpMax = arg0_1.hp
	arg0_1.speed = arg1_1.speed or 3
end

function var0_0.InitRegister(arg0_5, arg1_5)
	var0_0.super.InitRegister(arg0_5, arg1_5)
	arg0_5:Register("block", function(arg0_6)
		arg0_5.shieldCount[arg0_6] = arg0_5.shieldCount[arg0_6] - 1

		local var0_6 = arg0_5.rtShieldDic[var1_0[(table.indexof(var1_0, arg0_5.statusMark) + arg0_6 + 2) % 4 + 1]]

		setActive(var0_6:Find("Protect"), true)
	end, {})
end

function var0_0.CheckBlock(arg0_7, arg1_7, arg2_7, arg3_7)
	if arg0_7.pos.x == arg1_7.x and arg0_7.pos.y == arg1_7.y then
		return
	elseif arg0_7.pos.x == arg1_7.x and math.clamp(arg0_7.pos.y - arg1_7.y, -arg2_7[3], arg2_7[1]) == arg0_7.pos.y - arg1_7.y or arg0_7.pos.y == arg1_7.y and math.clamp(arg0_7.pos.x - arg1_7.x, -arg2_7[4], arg2_7[2]) == arg0_7.pos.x - arg1_7.x then
		local var0_7

		if arg1_7.x < arg0_7.pos.x then
			var0_7 = "W"
		elseif arg1_7.x > arg0_7.pos.x then
			var0_7 = "E"
		elseif arg1_7.y < arg0_7.pos.y then
			var0_7 = "N"
		elseif arg1_7.y > arg0_7.pos.y then
			var0_7 = "S"
		else
			assert(false)
		end

		local var1_7 = (table.indexof(var1_0, var0_7) - table.indexof(var1_0, arg0_7.statusMark) + 4) % 4 + 1

		if arg0_7.shieldCount[var1_7] > 0 then
			local var2_7 = (table.indexof(var1_0, var0_7) + 1) % 4 + 1

			arg2_7[var2_7] = math.max(math.max(math.abs(arg0_7.pos.x - arg1_7.x), math.abs(arg0_7.pos.y - arg1_7.y)) - arg0_7.BlockRange, 0)
			arg3_7[var2_7] = {
				arg0_7,
				var1_7
			}
		end
	end
end

function var0_0.PlayAnim(arg0_8, arg1_8)
	var0_0.super.PlayAnim(arg0_8, arg1_8)

	if arg0_8.statusMark ~= string.split(arg0_8.status, "_")[2] then
		arg0_8.statusMark = string.split(arg0_8.status, "_")[2]

		arg0_8:UpdateShieldDisplay()
	end
end

function var0_0.UpdateShieldDisplay(arg0_9)
	local var0_9 = table.indexof(var1_0, arg0_9.statusMark)

	for iter0_9 = 0, 3 do
		local var1_9 = arg0_9.rtShieldDic[var1_0[(var0_9 - 1 + iter0_9) % 4 + 1]]

		eachChild(var1_9, function(arg0_10)
			setActive(arg0_10, false)
		end)
		setImageAlpha(var1_9, 1)
		setActive(var1_9, arg0_9.shieldCount[iter0_9 + 1] > 0)
	end
end

return var0_0
