local var0_0 = class("RollingBallGrid")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.type = nil
	arg0_1.pos = nil
	arg0_1.eventActive = false
	arg0_1.gridTf = findTF(arg0_1._tf, "grid")
end

function var0_0.changeImage(arg0_2)
	GetSpriteFromAtlasAsync("ui/rollingBallGame_atlas", "grid_" .. arg0_2.type, function(arg0_3)
		setImageSprite(arg0_2.gridTf, arg0_3, true)
	end)
end

function var0_0.setType(arg0_4, arg1_4)
	arg0_4.type = arg1_4

	arg0_4:changeImage()
end

function var0_0.getType(arg0_5)
	return arg0_5.type
end

function var0_0.setPosData(arg0_6, arg1_6, arg2_6)
	arg0_6.x = arg1_6
	arg0_6.y = arg2_6

	if arg0_6.gridTf then
		arg0_6.gridTf.name = arg0_6:printData()
	end
end

function var0_0.addDownCallback(arg0_7, arg1_7)
	arg0_7.dragDelegate = GetOrAddComponent(arg0_7._tf, "EventTriggerListener")

	arg0_7.dragDelegate:AddPointDownFunc(function()
		if arg0_7.eventActive then
			arg1_7()
		end
	end)
end

function var0_0.addUpCallback(arg0_9, arg1_9)
	arg0_9.dragDelegate = GetOrAddComponent(arg0_9._tf, "EventTriggerListener")

	arg0_9.dragDelegate:AddPointUpFunc(function()
		if arg0_9.eventActive then
			arg1_9()
		end
	end)
end

function var0_0.addBeginDragCallback(arg0_11, arg1_11)
	arg0_11.dragDelegate = GetOrAddComponent(arg0_11._tf, "EventTriggerListener")

	arg0_11.dragDelegate:AddBeginDragFunc(function(arg0_12, arg1_12)
		if arg0_11.eventActive then
			arg1_11(arg0_12, arg1_12)
		end
	end)
end

function var0_0.addDragCallback(arg0_13, arg1_13)
	arg0_13.dragDelegate = GetOrAddComponent(arg0_13._tf, "EventTriggerListener")

	arg0_13.dragDelegate:AddDragFunc(function(arg0_14, arg1_14)
		if arg0_13.eventActive then
			arg1_13(arg0_14, arg1_14)
		end
	end)
end

function var0_0.onEndDrag(arg0_15)
	arg0_15.dragDelegate:RemoveDragFunc()
	arg0_15.dragDelegate:RemovePointUpFunc()
end

function var0_0.getPosData(arg0_16)
	return arg0_16.x, arg0_16.y
end

function var0_0.getPosition(arg0_17)
	return arg0_17._tf.localPosition
end

function var0_0.setPosition(arg0_18, arg1_18, arg2_18)
	arg0_18._tf.localPosition = Vector3(arg1_18, arg2_18, 0)
end

function var0_0.changePosition(arg0_19, arg1_19, arg2_19)
	arg0_19._tf.localPosition = Vector3(arg1_19, arg2_19, 0)
end

function var0_0.getRealPosition(arg0_20)
	return (arg0_20.x - 1) * RollingBallConst.grid_width, (arg0_20.y - 1) * RollingBallConst.grid_height
end

function var0_0.setRemoveFlagV(arg0_21, arg1_21, arg2_21)
	arg0_21.removeFlagV = arg1_21
	arg0_21.removeKey = arg2_21
end

function var0_0.getRemoveFlagV(arg0_22)
	return arg0_22.removeFlagV
end

function var0_0.setRemoveFlagH(arg0_23, arg1_23, arg2_23)
	arg0_23.removeFlagH = arg1_23
	arg0_23.removeKey = arg2_23
end

function var0_0.getRemoveFlagH(arg0_24)
	return arg0_24.removeFlagH
end

function var0_0.getRemoveId(arg0_25)
	return arg0_25.removeKey
end

function var0_0.setParent(arg0_26, arg1_26)
	setParent(arg0_26._tf, arg1_26, false)
end

function var0_0.setSelect(arg0_27, arg1_27)
	setActive(findTF(arg0_27._tf, "select"), arg1_27)
end

function var0_0.setDirect(arg0_28, arg1_28, arg2_28, arg3_28, arg4_28)
	setActive(findTF(arg0_28._tf, "direct/up"), arg1_28)
	setActive(findTF(arg0_28._tf, "direct/bottom"), arg2_28)
	setActive(findTF(arg0_28._tf, "direct/left"), arg3_28)
	setActive(findTF(arg0_28._tf, "direct/right"), arg4_28)
end

function var0_0.clearDirect(arg0_29)
	arg0_29:setDirect(false, false, false, false)
end

function var0_0.getTf(arg0_30)
	return arg0_30._tf
end

function var0_0.setEventActive(arg0_31, arg1_31)
	arg0_31.eventActive = arg1_31
end

function var0_0.printData(arg0_32)
	return "x:" .. arg0_32.x .. " , y:" .. arg0_32.y .. " , type:" .. arg0_32.type
end

function var0_0.getWolrdVec3(arg0_33)
	return arg0_33._tf:TransformPoint(RollingBallConst.grid_width / 2, RollingBallConst.grid_height / 2, 0)
end

function var0_0.clearData(arg0_34)
	arg0_34.removeFlagH = false
	arg0_34.removeFlagV = false
	arg0_34.removeKey = nil
end

function var0_0.dispose(arg0_35)
	if arg0_35.dragDelegate then
		ClearEventTrigger(arg0_35.dragDelegate)
	end
end

return var0_0
