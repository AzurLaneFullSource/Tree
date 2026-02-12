local var0_0 = class("PacGameGrid")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._index = arg2_1
	arg0_1._id = arg3_1

	if arg0_1._id == 0 then
		arg0_1._id = PacGameConst.default_grid
	end

	arg0_1._data = PacGameConst.grid_data[arg0_1._id]
	arg0_1._selectTF = findTF(arg1_1, "ad/select")

	setActive(arg0_1._selectTF, false)

	if arg0_1._data.score then
		arg0_1._scoreTF = findTF(arg1_1, "ad/score")

		setActive(arg0_1._scoreTF, false)

		arg0_1._scoreFlag = false
		arg0_1._score = arg0_1._data.score
	end
end

function var0_0.GetId(arg0_2)
	return arg0_2._id
end

function var0_0.SetParent(arg0_3, arg1_3)
	setParent(arg0_3._tf, arg1_3, false)
end

function var0_0.SetPosition(arg0_4, arg1_4)
	arg0_4._tf.anchoredPosition = arg1_4
end

function var0_0.GetPosition(arg0_5)
	return arg0_5._tf.anchoredPosition
end

function var0_0.SetScale(arg0_6, arg1_6)
	arg0_6._tf.localScale = arg1_6
end

function var0_0.HasScore(arg0_7)
	return arg0_7._data.score and true or false
end

function var0_0.SetScoreFlag(arg0_8, arg1_8)
	if arg0_8:HasScore() then
		setActive(arg0_8._scoreTF, arg1_8)

		arg0_8._scoreFlag = arg1_8
	end
end

function var0_0.SetVH(arg0_9, arg1_9, arg2_9)
	arg0_9._vetical = arg1_9
	arg0_9._horizontal = arg2_9
end

function var0_0.GetVH(arg0_10)
	return arg0_10._vetical, arg0_10._horizontal
end

function var0_0.GetScoreFlag(arg0_11)
	return arg0_11._scoreFlag
end

function var0_0.GetScore(arg0_12)
	return arg0_12._score
end

function var0_0.SetActive(arg0_13, arg1_13)
	setActive(arg0_13._tf, arg1_13)
end

function var0_0.GetIndex(arg0_14)
	return arg0_14._index
end

function var0_0.GetPassAble(arg0_15)
	return arg0_15._data.pass
end

function var0_0.Dispose(arg0_16)
	if arg0_16._tf then
		Destroy(arg0_16._tf)

		arg0_16._tf = nil
	end

	arg0_16._data = nil
end

return var0_0
