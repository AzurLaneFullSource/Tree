local var0_0 = class("TargetObject", import("view.miniGame.gameView.RyzaMiniGame.Reactor"))

function var0_0.CellPassability(arg0_1)
	return false
end

function var0_0.FirePassability(arg0_2)
	return 2
end

local function var1_0(arg0_3)
	local var0_3 = math.random()

	for iter0_3, iter1_3 in ipairs(arg0_3) do
		if var0_3 < iter1_3[2] then
			return {
				name = "Item",
				type = iter1_3[1]
			}
		else
			var0_3 = var0_3 - iter1_3[2]
		end
	end
end

function var0_0.TryDrop(arg0_4, arg1_4, arg2_4)
	if not arg1_4 then
		return
	end

	local var0_4 = var1_0(arg1_4)

	if var0_4 then
		var0_4.drop = arg2_4
		var0_4.pos = {
			arg0_4.pos.x,
			arg0_4.pos.y
		}

		arg0_4.responder:Create(var0_4)
	end
end

return var0_0
