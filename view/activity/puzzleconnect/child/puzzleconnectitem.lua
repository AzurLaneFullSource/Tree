local var0_0 = class("PuzzleConnectItem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._canvasGroup = GetComponent(arg0_1._tf, typeof(CanvasGroup))
	arg0_1._iconContent = findTF(arg0_1._tf, "icons")
	arg0_1._eventTrigger = GetComponent(findTF(arg0_1._tf, "icons"), typeof(EventTriggerListener))
	arg0_1._iconTpl = arg2_1
	arg0_1._iconTfs = {}
	arg0_1._textTf = findTF(arg0_1._tf, "text")
	arg0_1._bgTf = findTF(arg0_1._tf, "bg")
	arg0_1._boundData = Vector2(PuzzleConnectConst.item_bound[1] + PuzzleConnectConst.item_spacing, PuzzleConnectConst.item_bound[2] + PuzzleConnectConst.item_spacing)
end

function var0_0.setData(arg0_2, arg1_2)
	arg0_2:clear()

	arg0_2._itemData = arg1_2
	arg0_2._id = arg1_2.id
	arg0_2._count = arg1_2.count
	arg0_2._color = arg1_2.color
	arg0_2._itemMap = Clone(PuzzleConnectConst.item_data[arg0_2._id])

	arg0_2:updateIcon()
	arg0_2:updateAlpha()
	setGray(arg0_2._tf, false, true)
end

function var0_0.updateIcon(arg0_3)
	local var0_3 = 0

	for iter0_3, iter1_3 in ipairs(arg0_3._itemMap) do
		for iter2_3, iter3_3 in ipairs(iter1_3) do
			if iter3_3 > 0 then
				var0_3 = var0_3 + 1

				if var0_3 > #arg0_3._iconTfs then
					local var1_3 = tf(instantiate(arg0_3._iconTpl))

					setActive(var1_3, true)
					setParent(var1_3, arg0_3._iconContent)
					setActive(findTF(var1_3, "line"), false)
					setActive(findTF(var1_3, "lineBound"), false)
					table.insert(arg0_3._iconTfs, var1_3)
				end

				setActive(arg0_3._iconTfs[var0_3], true)

				arg0_3._iconTfs[var0_3].anchoredPosition = Vector2((iter2_3 - 1) * arg0_3._boundData.x, -(iter0_3 - 1) * arg0_3._boundData.y)
			end
		end
	end

	for iter4_3 = var0_3, #arg0_3._iconTfs do
		if iter4_3 > #arg0_3._iconTfs then
			setActive(arg0_3.iconTfs[iter4_3], false)
		end
	end

	for iter5_3, iter6_3 in ipairs(arg0_3._iconTfs) do
		for iter7_3 = 1, PuzzleConnectConst.color_count do
			setActive(findTF(iter6_3, iter7_3), iter7_3 == arg0_3._color)
		end
	end

	arg0_3:updateCount()
end

function var0_0.updateCount(arg0_4)
	setText(arg0_4._textTf, "X" .. arg0_4._count)
end

function var0_0.getId(arg0_5)
	return arg0_5._id
end

function var0_0.getCount(arg0_6)
	return arg0_6._count
end

function var0_0.getData(arg0_7)
	return arg0_7._itemData
end

function var0_0.setActive(arg0_8, arg1_8)
	setActive(arg0_8._tf, arg1_8)
end

function var0_0.setContent(arg0_9, arg1_9)
	setParent(arg0_9._tf, arg1_9)
end

function var0_0.setState(arg0_10, arg1_10)
	arg0_10._state = arg1_10
end

function var0_0.getEventTrigger(arg0_11)
	return arg0_11._eventTrigger
end

function var0_0.setPosition(arg0_12, arg1_12)
	arg0_12._tf.anchoredPosition = arg1_12
end

function var0_0.getName(arg0_13)
	if not arg0_13._gridName then
		arg0_13._gridName = arg0_13._h .. "-" .. arg0_13._v
	end

	return arg0_13._gridName
end

function var0_0.setMoveItem(arg0_14, arg1_14)
	if arg1_14 then
		arg0_14._iconContent.localScale = Vector3(1, 1, 1)

		setActive(arg0_14._textTf, false)
		setActive(arg0_14._bgTf, false)
	end
end

function var0_0.changeCount(arg0_15, arg1_15)
	arg0_15._count = arg0_15._count + arg1_15

	arg0_15:updateCount()
end

function var0_0.getPosition(arg0_16)
	return arg0_16._tf.anchoredPosition
end

function var0_0.getColor(arg0_17)
	return arg0_17._color
end

function var0_0.getItemIconWorld(arg0_18, arg1_18)
	return arg0_18._iconTfs[arg1_18].position
end

function var0_0.getPuzzleWorldPos(arg0_19)
	local var0_19 = {}

	for iter0_19 = 1, #arg0_19._iconTfs do
		local var1_19 = arg0_19._iconTfs[iter0_19]

		if isActive(var1_19) then
			table.insert(var0_19, var1_19.position)
		end
	end

	return var0_19
end

function var0_0.setDraging(arg0_20, arg1_20)
	arg0_20._draging = arg1_20

	arg0_20:updateAlpha()
end

function var0_0.updateAlpha(arg0_21)
	if arg0_21._draging or arg0_21._count == 0 then
		arg0_21._canvasGroup.alpha = 0.5
	else
		arg0_21._canvasGroup.alpha = 1
	end

	if arg0_21._count == 0 then
		setGray(arg0_21._tf, true, true)
	else
		setGray(arg0_21._tf, false, true)
	end
end

function var0_0.clear(arg0_22)
	for iter0_22 = 1, #arg0_22._iconTfs do
		setActive(arg0_22._iconTfs[iter0_22], false)
	end
end

function var0_0.dispose(arg0_23)
	if arg0_23._eventTrigger then
		ClearEventTrigger(arg0_23._eventTrigger)
	end
end

return var0_0
