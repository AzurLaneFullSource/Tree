local var0_0 = class("FoodCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.mask = arg0_1._tf:Find("mask")
	arg0_1.count = arg0_1._tf:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0_1.nameTxt = arg0_1._tf:Find("Text"):GetComponent(typeof(Text))
	arg0_1.addTF = arg0_1._tf:Find("add")
	arg0_1.icon = arg0_1._tf:Find("icon_bg/icon")
	arg0_1.startPos = arg0_1._tf.anchoredPosition
	arg0_1.width = arg0_1._tf.sizeDelta.x
	arg0_1.space = 36
end

function var0_0.UpdatePositin(arg0_2, arg1_2)
	local var0_2 = arg0_2.startPos.x + arg1_2 * (arg0_2.width + arg0_2.space)

	arg0_2._tf.anchoredPosition3D = Vector3(var0_2, arg0_2.startPos.y, 0)
end

function var0_0.Update(arg0_3, arg1_3, arg2_3)
	arg0_3.foodId = arg1_3
	arg0_3.name = i18n("word_food") .. Item.getConfigData(arg1_3).usage_arg[1]

	arg0_3:UpdateCnt(arg2_3)

	arg0_3._go.name = "food_" .. arg1_3

	updateItem(arg0_3._tf, Item.New({
		id = arg1_3,
		cnt = arg2_3
	}))
end

function var0_0.UpdateCnt(arg0_4, arg1_4)
	arg0_4.count.text = arg1_4

	local var0_4 = arg1_4 == 0

	setActive(arg0_4.mask, var0_4)

	arg0_4.count.text = arg1_4
	arg0_4.nameTxt.text = arg0_4.name
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
