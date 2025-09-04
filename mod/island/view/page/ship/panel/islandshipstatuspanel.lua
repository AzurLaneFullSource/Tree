local var0_0 = class("IslandShipStatusPanel")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.tf = arg1_1
	arg0_1.emptyTf = arg2_1
	arg0_1.state1Tr = findTF(arg1_1, "1")
	arg0_1.state2Tr = findTF(arg1_1, "2")
	arg0_1.state3Tr = findTF(arg1_1, "3")
	arg0_1.viewBtn = findTF(arg1_1, "view")
end

function var0_0.Flush(arg0_2, arg1_2)
	local var0_2 = arg1_2:GetDisplayStatus()

	arg0_2:UpdateLayout(#var0_2)
	arg0_2:UpdateStatus(var0_2)
	setActive(arg0_2.emptyTf, #var0_2 <= 0)
	setActive(arg0_2.tf, #var0_2 > 0)
end

function var0_0.UpdateStatus(arg0_3, arg1_3)
	setActive(arg0_3.viewBtn, #arg1_3 > 0)
	arg0_3:UpdateStatusTpl(arg0_3.state1Tr, arg1_3[1])
	arg0_3:UpdateStatusTpl(arg0_3.state2Tr, arg1_3[2])
	arg0_3:UpdateStatusTpl(arg0_3.state3Tr, arg1_3[3])
end

function var0_0.UpdateStatusTpl(arg0_4, arg1_4, arg2_4)
	setActive(arg1_4, arg2_4 ~= nil)

	if arg2_4 then
		setText(arg1_4:Find("Text"), arg2_4:GetName())

		local var0_4 = Color.New(1, 0.5490196, 0.5490196, 1)
		local var1_4 = Color.New(0.3137255, 0.6745098, 0.9372549, 1)

		arg1_4:GetComponent(typeof(Image)).color = arg2_4:IsRed() and var0_4 or var1_4
	end
end

function var0_0.UpdateLayout(arg0_5, arg1_5)
	if arg1_5 == 1 then
		setAnchoredPosition3D(arg0_5.state1Tr, {
			x = -16.7,
			y = -4.7
		})
		setAnchoredPosition3D(arg0_5.viewBtn, {
			x = 123,
			y = -22
		})
	elseif arg1_5 == 2 then
		setAnchoredPosition3D(arg0_5.state1Tr, {
			x = -90,
			y = 11
		})
		setAnchoredPosition3D(arg0_5.state2Tr, {
			x = 56.7,
			y = -32
		})
		setAnchoredPosition3D(arg0_5.viewBtn, {
			x = 165,
			y = 0
		})
	elseif arg1_5 > 2 then
		setAnchoredPosition3D(arg0_5.state1Tr, {
			x = -118.6,
			y = 15
		})
		setAnchoredPosition3D(arg0_5.state2Tr, {
			x = 132,
			y = 5.1
		})
		setAnchoredPosition3D(arg0_5.state3Tr, {
			x = -20.6,
			y = -31.8
		})
		setAnchoredPosition3D(arg0_5.viewBtn, {
			x = 188,
			y = -31.8
		})
	end
end

function var0_0.Dispose(arg0_6)
	return
end

return var0_0
