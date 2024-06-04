local var0 = class("TargetObject", import("view.miniGame.gameView.RyzaMiniGame.Reactor"))

function var0.CellPassability(arg0)
	return false
end

function var0.FirePassability(arg0)
	return 2
end

local function var1(arg0)
	local var0 = math.random()

	for iter0, iter1 in ipairs(arg0) do
		if var0 < iter1[2] then
			return {
				name = "Item",
				type = iter1[1]
			}
		else
			var0 = var0 - iter1[2]
		end
	end
end

function var0.TryDrop(arg0, arg1, arg2)
	if not arg1 then
		return
	end

	local var0 = var1(arg1)

	if var0 then
		var0.drop = arg2
		var0.pos = {
			arg0.pos.x,
			arg0.pos.y
		}

		arg0.responder:Create(var0)
	end
end

return var0
