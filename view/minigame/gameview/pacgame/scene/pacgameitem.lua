local var0_0 = class("PacGameItem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._index = arg2_1
	arg0_1._data = arg3_1
end

function var0_0.SetParent(arg0_2, arg1_2)
	setParent(arg0_2._tf, arg1_2, false)
end

function var0_0.SetPosition(arg0_3, arg1_3)
	arg0_3._tf.anchoredPosition = arg1_3
end

function var0_0.GetPosition(arg0_4)
	return arg0_4._tf.anchoredPosition
end

function var0_0.SetScale(arg0_5, arg1_5)
	arg0_5._tf.localScale = arg1_5
end

function var0_0.SetActive(arg0_6, arg1_6)
	setActive(arg0_6._tf, arg1_6)
end

function var0_0.GetIndex(arg0_7)
	return arg0_7._index
end

function var0_0.GetConfig(arg0_8, arg1_8)
	return arg0_8._data[arg1_8]
end

function var0_0.Dispose(arg0_9)
	if arg0_9._tf then
		Destroy(arg0_9._tf)

		arg0_9._tf = nil
	end

	arg0_9._index = nil
	arg0_9._data = nil
end

return var0_0
