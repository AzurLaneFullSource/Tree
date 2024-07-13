local var0_0 = class("PipePassTest")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var1_0 = PipeGameVo
	arg0_1._tf = arg1_1
	arg0_1._leftId = 1
	arg0_1._rightId = 1
	arg0_1._leftIndex = 1
	arg0_1._rightIndex = 2
	arg0_1._leftDirect = {
		0,
		0
	}
	arg0_1._rightDirect = {
		0,
		0
	}
	arg0_1._leftTrigger = GetOrAddComponent(findTF(arg0_1._tf, "left/ok"), typeof(EventTriggerListener))

	arg0_1._leftTrigger:AddPointClickFunc(function()
		arg0_1._leftId = tonumber(GetComponent(findTF(arg0_1._tf, "left/inputId"), typeof(Text)).text)
		arg0_1._leftIndex = tonumber(GetComponent(findTF(arg0_1._tf, "left/inputIndex"), typeof(Text)).text)

		local var0_2 = PipeGameConst.map_item_data[arg0_1._leftId]

		arg0_1._leftDirect = var0_2.direct

		setImageSprite(findTF(arg0_1._tf, "left/icon"), var1_0.GetSprite(var0_2.img), false)
	end)

	arg0_1._rightTrigger = GetOrAddComponent(findTF(arg0_1._tf, "right/ok"), typeof(EventTriggerListener))

	arg0_1._rightTrigger:AddPointClickFunc(function()
		arg0_1._rightId = tonumber(GetComponent(findTF(arg0_1._tf, "right/inputId"), typeof(Text)).text)
		arg0_1._rightIndex = tonumber(GetComponent(findTF(arg0_1._tf, "right/inputIndex"), typeof(Text)).text)

		local var0_3 = PipeGameConst.map_item_data[arg0_1._rightId]

		arg0_1._rightDirect = var0_3.direct

		setImageSprite(findTF(arg0_1._tf, "right/icon"), var1_0.GetSprite(PipeGameConst.map_item_data[arg0_1._rightId].img), false)
	end)

	arg0_1._passTrigger = GetOrAddComponent(findTF(arg0_1._tf, "btnPass"), typeof(EventTriggerListener))

	arg0_1._passTrigger:AddPointClickFunc(function()
		if callback then
			callback(arg0_1._leftIndex, arg0_1._rightIndex, arg0_1._leftDirect, arg0_1._rightDirect)
		end
	end)
end

function var0_0.setPassDesc(arg0_5, arg1_5)
	if arg1_5 then
		setText(findTF(arg0_5._tf, "passDesc"), "检测通过")
	else
		setText(findTF(arg0_5._tf, "passDesc"), "检测失败")
	end
end

function var0_0.setVisible(arg0_6, arg1_6)
	setActive(arg0_6._tf, arg1_6)
end

function var0_0.dispose(arg0_7)
	ClearEventTrigger(arg0_7._leftTrigger)
	ClearEventTrigger(arg0_7._rightTrigger)
end

return var0_0
