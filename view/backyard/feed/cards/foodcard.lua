local var0 = class("FoodCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.mask = arg0._tf:Find("mask")
	arg0.count = arg0._tf:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0.nameTxt = arg0._tf:Find("Text"):GetComponent(typeof(Text))
	arg0.addTF = arg0._tf:Find("add")
	arg0.icon = arg0._tf:Find("icon_bg/icon")
	arg0.startPos = arg0._tf.anchoredPosition
	arg0.width = arg0._tf.sizeDelta.x
	arg0.space = 36
end

function var0.UpdatePositin(arg0, arg1)
	local var0 = arg0.startPos.x + arg1 * (arg0.width + arg0.space)

	arg0._tf.anchoredPosition3D = Vector3(var0, arg0.startPos.y, 0)
end

function var0.Update(arg0, arg1, arg2)
	arg0.foodId = arg1
	arg0.name = i18n("word_food") .. Item.getConfigData(arg1).usage_arg[1]

	arg0:UpdateCnt(arg2)

	arg0._go.name = "food_" .. arg1

	updateItem(arg0._tf, Item.New({
		id = arg1,
		cnt = arg2
	}))
end

function var0.UpdateCnt(arg0, arg1)
	arg0.count.text = arg1

	local var0 = arg1 == 0

	setActive(arg0.mask, var0)

	arg0.count.text = arg1
	arg0.nameTxt.text = arg0.name
end

function var0.Dispose(arg0)
	return
end

return var0
