local var0_0 = class("Reactor", import("view.miniGame.gameView.RyzaMiniGame.BaseReactor"))

function var0_0.GetBaseOrder(arg0_1)
	return 1
end

function var0_0.CellPassability(arg0_2)
	return true
end

function var0_0.FirePassability(arg0_3)
	return 0
end

function var0_0.InTimeRiver(arg0_4)
	return false
end

function var0_0.Init(arg0_5, arg1_5)
	arg0_5.name = arg1_5.name

	if arg0_5:GetBaseOrder() ~= "floor" then
		setCanvasOverrideSorting(arg0_5._tf, true)
	end

	var0_0.UpdatePos(arg0_5, NewPos(unpack(arg1_5.pos)))

	arg0_5.realPos = NewPos(unpack(arg1_5.realPos or arg1_5.pos))

	arg0_5:UpdatePosition()
	arg0_5:InitUI(arg1_5)
	arg0_5:InitRegister(arg1_5)
end

function var0_0.InitUI(arg0_6, arg1_6)
	return
end

function var0_0.InitRegister(arg0_7, arg1_7)
	return
end

function var0_0.UpdatePos(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetBaseOrder()

	if var0_8 ~= "floor" then
		arg0_8._tf:GetComponent(typeof(Canvas)).sortingOrder = arg1_8.y * 10 + var0_8
	end

	arg0_8.pos = arg1_8
end

function var0_0.UpdatePosition(arg0_9)
	setAnchoredPosition(arg0_9._tf, {
		x = arg0_9.realPos.x * 32,
		y = arg0_9.realPos.y * -32
	})
end

return var0_0
