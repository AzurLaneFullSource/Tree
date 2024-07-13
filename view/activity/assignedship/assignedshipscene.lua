local var0_0 = class("AssignedShipScene", import(".BaseAssignedShipScene"))

function var0_0.getUIName(arg0_1)
	return "AssignedShipUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.scrollrect = arg0_2:findTF("layer/select_panel")
	arg0_2.rightBtn = arg0_2:findTF("layer/right")
	arg0_2.leftBtn = arg0_2:findTF("layer/left")
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)

	arg0_3.isZero = true
	arg0_3.isOne = false

	onScroll(arg0_3, arg0_3.scrollrect, function(arg0_4)
		local var0_4 = Mathf.Clamp01(arg0_4.x)
		local var1_4 = arg0_3.isZero
		local var2_4 = arg0_3.isOne

		arg0_3.isZero = var0_4 - 0.0001 <= 0
		arg0_3.isOne = var0_4 + 0.0001 >= 1

		if var1_4 ~= arg0_3.isZero or var2_4 ~= arg0_3.isOne then
			arg0_3:UpdateArr()
		end
	end)
	arg0_3:UpdateArr()
end

function var0_0.UpdateArr(arg0_5)
	setActive(arg0_5.rightBtn, not arg0_5.isZero)
	setActive(arg0_5.leftBtn, not arg0_5.isOne)
end

return var0_0
