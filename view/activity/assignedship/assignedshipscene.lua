local var0 = class("AssignedShipScene", import(".BaseAssignedShipScene"))

function var0.getUIName(arg0)
	return "AssignedShipUI"
end

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.scrollrect = arg0:findTF("layer/select_panel")
	arg0.rightBtn = arg0:findTF("layer/right")
	arg0.leftBtn = arg0:findTF("layer/left")
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)

	arg0.isZero = true
	arg0.isOne = false

	onScroll(arg0, arg0.scrollrect, function(arg0)
		local var0 = Mathf.Clamp01(arg0.x)
		local var1 = arg0.isZero
		local var2 = arg0.isOne

		arg0.isZero = var0 - 0.0001 <= 0
		arg0.isOne = var0 + 0.0001 >= 1

		if var1 ~= arg0.isZero or var2 ~= arg0.isOne then
			arg0:UpdateArr()
		end
	end)
	arg0:UpdateArr()
end

function var0.UpdateArr(arg0)
	setActive(arg0.rightBtn, not arg0.isZero)
	setActive(arg0.leftBtn, not arg0.isOne)
end

return var0
