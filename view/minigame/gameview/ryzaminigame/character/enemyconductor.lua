local var0 = class("EnemyConductor", import("view.miniGame.gameView.RyzaMiniGame.character.MoveEnemy"))

var0.ConfigShildList = {
	2,
	0,
	0,
	0
}
var0.BlockRange = 1

local var1 = {
	"S",
	"E",
	"N",
	"W"
}

function var0.InitUI(arg0, arg1)
	arg0.shieldCount = underscore.rest(arg0.ConfigShildList, 1)
	arg0.rtShieldDic = {
		S = arg0.rtScale:Find("front/Shield_S"),
		E = arg0.rtScale:Find("front/Shield_E"),
		N = arg0.rtScale:Find("back/Shield_N"),
		W = arg0.rtScale:Find("front/Shield_W")
	}

	for iter0, iter1 in ipairs({
		"front",
		"back"
	}) do
		eachChild(arg0.rtScale:Find(iter1), function(arg0)
			arg0:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				setActive(arg0:Find("Image"), false)
				setActive(arg0, false)
				setImageAlpha(arg0, 1)
			end)
			arg0:Find("Protect"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				setActive(arg0:Find("Protect"), false)

				local var0 = (table.indexof(var1, string.split(arg0.name, "_")[2]) - table.indexof(var1, arg0.statusMark) + 4) % 4 + 1

				if arg0.shieldCount[var0] <= 0 then
					setImageAlpha(arg0, 0)
					setActive(arg0:Find("Image"), true)
				end
			end)
		end)
	end

	var0.super.InitUI(arg0, arg1)

	arg0.hp = arg1.hp or 2
	arg0.hpMax = arg0.hp
	arg0.speed = arg1.speed or 3
end

function var0.InitRegister(arg0, arg1)
	var0.super.InitRegister(arg0, arg1)
	arg0:Register("block", function(arg0)
		arg0.shieldCount[arg0] = arg0.shieldCount[arg0] - 1

		local var0 = arg0.rtShieldDic[var1[(table.indexof(var1, arg0.statusMark) + arg0 + 2) % 4 + 1]]

		setActive(var0:Find("Protect"), true)
	end, {})
end

function var0.CheckBlock(arg0, arg1, arg2, arg3)
	if arg0.pos.x == arg1.x and arg0.pos.y == arg1.y then
		return
	elseif arg0.pos.x == arg1.x and math.clamp(arg0.pos.y - arg1.y, -arg2[3], arg2[1]) == arg0.pos.y - arg1.y or arg0.pos.y == arg1.y and math.clamp(arg0.pos.x - arg1.x, -arg2[4], arg2[2]) == arg0.pos.x - arg1.x then
		local var0

		if arg1.x < arg0.pos.x then
			var0 = "W"
		elseif arg1.x > arg0.pos.x then
			var0 = "E"
		elseif arg1.y < arg0.pos.y then
			var0 = "N"
		elseif arg1.y > arg0.pos.y then
			var0 = "S"
		else
			assert(false)
		end

		local var1 = (table.indexof(var1, var0) - table.indexof(var1, arg0.statusMark) + 4) % 4 + 1

		if arg0.shieldCount[var1] > 0 then
			local var2 = (table.indexof(var1, var0) + 1) % 4 + 1

			arg2[var2] = math.max(math.max(math.abs(arg0.pos.x - arg1.x), math.abs(arg0.pos.y - arg1.y)) - arg0.BlockRange, 0)
			arg3[var2] = {
				arg0,
				var1
			}
		end
	end
end

function var0.PlayAnim(arg0, arg1)
	var0.super.PlayAnim(arg0, arg1)

	if arg0.statusMark ~= string.split(arg0.status, "_")[2] then
		arg0.statusMark = string.split(arg0.status, "_")[2]

		arg0:UpdateShieldDisplay()
	end
end

function var0.UpdateShieldDisplay(arg0)
	local var0 = table.indexof(var1, arg0.statusMark)

	for iter0 = 0, 3 do
		local var1 = arg0.rtShieldDic[var1[(var0 - 1 + iter0) % 4 + 1]]

		eachChild(var1, function(arg0)
			setActive(arg0, false)
		end)
		setImageAlpha(var1, 1)
		setActive(var1, arg0.shieldCount[iter0 + 1] > 0)
	end
end

return var0
