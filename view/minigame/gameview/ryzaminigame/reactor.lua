local var0 = class("Reactor", import("view.miniGame.gameView.RyzaMiniGame.BaseReactor"))

function var0.GetBaseOrder(arg0)
	return 1
end

function var0.CellPassability(arg0)
	return true
end

function var0.FirePassability(arg0)
	return 0
end

function var0.InTimeRiver(arg0)
	return false
end

function var0.Init(arg0, arg1)
	arg0.name = arg1.name

	if arg0:GetBaseOrder() ~= "floor" then
		setCanvasOverrideSorting(arg0._tf, true)
	end

	var0.UpdatePos(arg0, NewPos(unpack(arg1.pos)))

	arg0.realPos = NewPos(unpack(arg1.realPos or arg1.pos))

	arg0:UpdatePosition()
	arg0:InitUI(arg1)
	arg0:InitRegister(arg1)
end

function var0.InitUI(arg0, arg1)
	return
end

function var0.InitRegister(arg0, arg1)
	return
end

function var0.UpdatePos(arg0, arg1)
	local var0 = arg0:GetBaseOrder()

	if var0 ~= "floor" then
		arg0._tf:GetComponent(typeof(Canvas)).sortingOrder = arg1.y * 10 + var0
	end

	arg0.pos = arg1
end

function var0.UpdatePosition(arg0)
	setAnchoredPosition(arg0._tf, {
		x = arg0.realPos.x * 32,
		y = arg0.realPos.y * -32
	})
end

return var0
