local var0_0 = class("PuzzleConnectGrid")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._tf = arg1_1
	arg0_1._h, arg0_1._v = arg2_1, arg3_1
	arg0_1._eventTrigger = GetComponent(arg0_1._tf, typeof(EventTriggerListener))
	arg0_1._unLockTf = findTF(arg0_1._tf, "unlock")
	arg0_1._iconContent = findTF(arg0_1._tf, "iconContent")
	arg0_1._iconTf = tf(instantiate(arg4_1))

	setActive(arg0_1._iconTf, true)
	setParent(arg0_1._iconTf, arg0_1._iconContent)

	arg0_1._iconTf.anchoredPosition = Vector2(0, 0)
	arg0_1._iconCanvasGroup = GetComponent(arg0_1._iconContent, typeof(CanvasGroup))

	arg0_1:setChildVisible(arg0_1._iconTf, false)
	setActive(arg0_1._unLockTf, false)

	arg0_1._lineTf = findTF(arg0_1._iconTf, "line")

	setActive(arg0_1._lineTf, false)
	arg0_1:setChildVisible(arg0_1._lineTf, false)

	arg0_1._lineEventTrigger = GetComponent(findTF(arg0_1._iconTf, "lineBound"), typeof(EventTriggerListener))
end

function var0_0.getLineTrigger(arg0_2)
	return arg0_2._lineEventTrigger
end

function var0_0.setActive(arg0_3, arg1_3)
	setActive(arg0_3._tf, arg1_3)
end

function var0_0.setContent(arg0_4, arg1_4)
	setParent(arg0_4._tf, arg1_4)
end

function var0_0.getPosition(arg0_5)
	return arg0_5._tf.anchoredPosition
end

function var0_0.setPrepare(arg0_6, arg1_6)
	if arg0_6._fillItem then
		return
	end

	arg0_6._prepareColor = arg1_6
	arg0_6._iconCanvasGroup.alpha = 0.5

	arg0_6:setChildVisible(arg0_6._iconTf, false)
	setActive(findTF(arg0_6._iconTf, tostring(arg1_6)), true)
end

function var0_0.getPrepare(arg0_7)
	return arg0_7._prepareColor and arg0_7._prepareColor > 0
end

function var0_0.clearPrepare(arg0_8)
	if arg0_8._prepareColor and arg0_8._prepareColor > 0 then
		GetComponent(findTF(arg0_8._iconTf, arg0_8._prepareColor), typeof(Image)).color = Color.New(1, 1, 1, 1)
		arg0_8._prepareColor = nil
		arg0_8._iconCanvasGroup.alpha = 1

		arg0_8:setChildVisible(arg0_8._iconTf, false)
	end
end

function var0_0.setLine(arg0_9, arg1_9, arg2_9)
	if arg1_9 then
		local var0_9 = arg0_9:getLineStrByGrid(arg1_9)

		if var0_9 then
			setActive(findTF(arg0_9._lineTf, var0_9), true)
		end
	end

	if arg2_9 then
		local var1_9 = arg0_9:getLineStrByGrid(arg2_9)

		if var1_9 then
			setActive(findTF(arg0_9._lineTf, var1_9), true)
		end
	end
end

function var0_0.getLineStrByGrid(arg0_10, arg1_10)
	local var0_10 = arg0_10._h - arg1_10.h
	local var1_10 = arg0_10._v - arg1_10.v
	local var2_10

	if var0_10 == 1 then
		if var1_10 == 1 then
			var2_10 = "LT"
		elseif var1_10 == 0 then
			var2_10 = "L"
		elseif var1_10 == -1 then
			var2_10 = "LB"
		end
	elseif var0_10 == 0 then
		if var1_10 == 1 then
			var2_10 = "T"
		elseif var1_10 == -1 then
			var2_10 = "B"
		end
	elseif var0_10 == -1 then
		if var1_10 == 1 then
			var2_10 = "RT"
		elseif var1_10 == 0 then
			var2_10 = "R"
		elseif var1_10 == -1 then
			var2_10 = "RB"
		end
	end

	return var2_10
end

function var0_0.clearLine(arg0_11)
	arg0_11:setChildVisible(arg0_11._lineTf, false)
end

function var0_0.setChildVisible(arg0_12, arg1_12, arg2_12)
	for iter0_12 = 1, arg1_12.childCount do
		local var0_12 = arg1_12:GetChild(iter0_12 - 1)

		setActive(var0_12, arg2_12)
	end
end

function var0_0.setIndex(arg0_13, arg1_13, arg2_13)
	arg0_13:clear()

	arg0_13._mapIndex = arg1_13
	arg0_13._state = arg2_13

	arg0_13:updateGrid()
end

function var0_0.updateGrid(arg0_14)
	setActive(arg0_14._unLockTf, false)

	if arg0_14._state == PuzzleConnectPlaying.game_state_puzzle then
		setActive(arg0_14._lineTf, false)

		if arg0_14._mapIndex and arg0_14._mapIndex > 0 then
			setActive(arg0_14._unLockTf, true)
		end

		setActive(findTF(arg0_14._iconTf, "lineBound"), false)
		setActive(findTF(arg0_14._unLockTf, "whiteImg"), false)
	elseif arg0_14._state == PuzzleConnectPlaying.game_state_connect then
		setActive(arg0_14._lineTf, true)

		if arg0_14._mapIndex and arg0_14._mapIndex > 0 then
			setActive(findTF(arg0_14._iconTf, arg0_14._mapIndex), true)
			setActive(findTF(arg0_14._iconTf, "lineBound"), true)
			setActive(arg0_14._unLockTf, true)
			setActive(findTF(arg0_14._unLockTf, "whiteImg"), true)
		end
	end
end

function var0_0.setStart(arg0_15, arg1_15)
	arg0_15._startFlag = arg1_15
end

function var0_0.getStart(arg0_16)
	return arg0_16._startFlag
end

function var0_0.setEnd(arg0_17, arg1_17)
	arg0_17._endFlag = arg1_17
end

function var0_0.getEnd(arg0_18)
	return arg0_18._endFlag
end

function var0_0.getUnlock(arg0_19)
	return arg0_19._mapIndex and arg0_19._mapIndex > 0
end

function var0_0.setFillItem(arg0_20, arg1_20, arg2_20, arg3_20)
	arg0_20._fillItem = arg1_20
	arg0_20._fillIndex = arg2_20
	arg0_20._fillCount = arg3_20

	arg0_20:clearPrepare()

	local var0_20 = arg0_20._fillItem:getColor()

	setActive(findTF(arg0_20._iconTf, tostring(var0_20)), true)

	if arg0_20._mapIndex and arg0_20._mapIndex > 0 then
		setActive(findTF(arg0_20._unLockTf, "whiteImg"), true)
	else
		setActive(findTF(arg0_20._unLockTf, "whiteImg"), false)
	end
end

function var0_0.getFillItem(arg0_21)
	return arg0_21._fillItem, arg0_21._fillIndex, arg0_21._fillCount
end

function var0_0.clearFillItem(arg0_22)
	if arg0_22._fillItem then
		arg0_22._fillItem = nil
		arg0_22._iconCanvasGroup.alpha = 1
	end

	arg0_22:setChildVisible(arg0_22._iconTf, false)

	if arg0_22._mapIndex and arg0_22._mapIndex > 0 then
		setActive(findTF(arg0_22._unLockTf, "whiteImg"), false)
	end
end

function var0_0.getFill(arg0_23)
	return arg0_23._fillItem and true or false
end

function var0_0.setPrepareAlpha(arg0_24, arg1_24)
	if arg0_24._prepareColor and arg0_24._prepareColor > 0 then
		local var0_24 = findTF(arg0_24._iconTf, arg0_24._prepareColor)

		GetComponent(var0_24, typeof(Image)).color = arg1_24
	end
end

function var0_0.setState(arg0_25, arg1_25)
	arg0_25._state = arg1_25
end

function var0_0.getPoint(arg0_26)
	return {
		h = arg0_26._h,
		v = arg0_26._v
	}
end

function var0_0.getEventTrigger(arg0_27)
	return arg0_27._eventTrigger
end

function var0_0.getName(arg0_28)
	if not arg0_28._gridName then
		arg0_28._gridName = arg0_28._h .. "-" .. arg0_28._v
	end

	return arg0_28._gridName
end

function var0_0.getMapIndex(arg0_29)
	return arg0_29._mapIndex
end

function var0_0.getComplete(arg0_30)
	if arg0_30._mapIndex > 0 and arg0_30._fillItem then
		return true
	end

	return false
end

function var0_0.clear(arg0_31)
	arg0_31:setStart(false)
	arg0_31:setEnd(false)
	arg0_31:clearPrepare()
	arg0_31:clearFillItem()
end

function var0_0.dispose(arg0_32)
	if arg0_32._eventTrigger then
		ClearEventTrigger(arg0_32._eventTrigger)
	end
end

return var0_0
