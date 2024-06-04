local var0 = class("PipePassTest")
local var1

function var0.Ctor(arg0, arg1, arg2, arg3)
	var1 = PipeGameVo
	arg0._tf = arg1
	arg0._leftId = 1
	arg0._rightId = 1
	arg0._leftIndex = 1
	arg0._rightIndex = 2
	arg0._leftDirect = {
		0,
		0
	}
	arg0._rightDirect = {
		0,
		0
	}
	arg0._leftTrigger = GetOrAddComponent(findTF(arg0._tf, "left/ok"), typeof(EventTriggerListener))

	arg0._leftTrigger:AddPointClickFunc(function()
		arg0._leftId = tonumber(GetComponent(findTF(arg0._tf, "left/inputId"), typeof(Text)).text)
		arg0._leftIndex = tonumber(GetComponent(findTF(arg0._tf, "left/inputIndex"), typeof(Text)).text)

		local var0 = PipeGameConst.map_item_data[arg0._leftId]

		arg0._leftDirect = var0.direct

		setImageSprite(findTF(arg0._tf, "left/icon"), var1.GetSprite(var0.img), false)
	end)

	arg0._rightTrigger = GetOrAddComponent(findTF(arg0._tf, "right/ok"), typeof(EventTriggerListener))

	arg0._rightTrigger:AddPointClickFunc(function()
		arg0._rightId = tonumber(GetComponent(findTF(arg0._tf, "right/inputId"), typeof(Text)).text)
		arg0._rightIndex = tonumber(GetComponent(findTF(arg0._tf, "right/inputIndex"), typeof(Text)).text)

		local var0 = PipeGameConst.map_item_data[arg0._rightId]

		arg0._rightDirect = var0.direct

		setImageSprite(findTF(arg0._tf, "right/icon"), var1.GetSprite(PipeGameConst.map_item_data[arg0._rightId].img), false)
	end)

	arg0._passTrigger = GetOrAddComponent(findTF(arg0._tf, "btnPass"), typeof(EventTriggerListener))

	arg0._passTrigger:AddPointClickFunc(function()
		if callback then
			callback(arg0._leftIndex, arg0._rightIndex, arg0._leftDirect, arg0._rightDirect)
		end
	end)
end

function var0.setPassDesc(arg0, arg1)
	if arg1 then
		setText(findTF(arg0._tf, "passDesc"), "检测通过")
	else
		setText(findTF(arg0._tf, "passDesc"), "检测失败")
	end
end

function var0.setVisible(arg0, arg1)
	setActive(arg0._tf, arg1)
end

function var0.dispose(arg0)
	ClearEventTrigger(arg0._leftTrigger)
	ClearEventTrigger(arg0._rightTrigger)
end

return var0
