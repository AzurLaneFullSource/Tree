local var0 = class("RollingBallGrid")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.type = nil
	arg0.pos = nil
	arg0.eventActive = false
	arg0.gridTf = findTF(arg0._tf, "grid")
end

function var0.changeImage(arg0)
	GetSpriteFromAtlasAsync("ui/rollingBallGame_atlas", "grid_" .. arg0.type, function(arg0)
		setImageSprite(arg0.gridTf, arg0, true)
	end)
end

function var0.setType(arg0, arg1)
	arg0.type = arg1

	arg0:changeImage()
end

function var0.getType(arg0)
	return arg0.type
end

function var0.setPosData(arg0, arg1, arg2)
	arg0.x = arg1
	arg0.y = arg2

	if arg0.gridTf then
		arg0.gridTf.name = arg0:printData()
	end
end

function var0.addDownCallback(arg0, arg1)
	arg0.dragDelegate = GetOrAddComponent(arg0._tf, "EventTriggerListener")

	arg0.dragDelegate:AddPointDownFunc(function()
		if arg0.eventActive then
			arg1()
		end
	end)
end

function var0.addUpCallback(arg0, arg1)
	arg0.dragDelegate = GetOrAddComponent(arg0._tf, "EventTriggerListener")

	arg0.dragDelegate:AddPointUpFunc(function()
		if arg0.eventActive then
			arg1()
		end
	end)
end

function var0.addBeginDragCallback(arg0, arg1)
	arg0.dragDelegate = GetOrAddComponent(arg0._tf, "EventTriggerListener")

	arg0.dragDelegate:AddBeginDragFunc(function(arg0, arg1)
		if arg0.eventActive then
			arg1(arg0, arg1)
		end
	end)
end

function var0.addDragCallback(arg0, arg1)
	arg0.dragDelegate = GetOrAddComponent(arg0._tf, "EventTriggerListener")

	arg0.dragDelegate:AddDragFunc(function(arg0, arg1)
		if arg0.eventActive then
			arg1(arg0, arg1)
		end
	end)
end

function var0.onEndDrag(arg0)
	arg0.dragDelegate:RemoveDragFunc()
	arg0.dragDelegate:RemovePointUpFunc()
end

function var0.getPosData(arg0)
	return arg0.x, arg0.y
end

function var0.getPosition(arg0)
	return arg0._tf.localPosition
end

function var0.setPosition(arg0, arg1, arg2)
	arg0._tf.localPosition = Vector3(arg1, arg2, 0)
end

function var0.changePosition(arg0, arg1, arg2)
	arg0._tf.localPosition = Vector3(arg1, arg2, 0)
end

function var0.getRealPosition(arg0)
	return (arg0.x - 1) * RollingBallConst.grid_width, (arg0.y - 1) * RollingBallConst.grid_height
end

function var0.setRemoveFlagV(arg0, arg1, arg2)
	arg0.removeFlagV = arg1
	arg0.removeKey = arg2
end

function var0.getRemoveFlagV(arg0)
	return arg0.removeFlagV
end

function var0.setRemoveFlagH(arg0, arg1, arg2)
	arg0.removeFlagH = arg1
	arg0.removeKey = arg2
end

function var0.getRemoveFlagH(arg0)
	return arg0.removeFlagH
end

function var0.getRemoveId(arg0)
	return arg0.removeKey
end

function var0.setParent(arg0, arg1)
	setParent(arg0._tf, arg1, false)
end

function var0.setSelect(arg0, arg1)
	setActive(findTF(arg0._tf, "select"), arg1)
end

function var0.setDirect(arg0, arg1, arg2, arg3, arg4)
	setActive(findTF(arg0._tf, "direct/up"), arg1)
	setActive(findTF(arg0._tf, "direct/bottom"), arg2)
	setActive(findTF(arg0._tf, "direct/left"), arg3)
	setActive(findTF(arg0._tf, "direct/right"), arg4)
end

function var0.clearDirect(arg0)
	arg0:setDirect(false, false, false, false)
end

function var0.getTf(arg0)
	return arg0._tf
end

function var0.setEventActive(arg0, arg1)
	arg0.eventActive = arg1
end

function var0.printData(arg0)
	return "x:" .. arg0.x .. " , y:" .. arg0.y .. " , type:" .. arg0.type
end

function var0.getWolrdVec3(arg0)
	return arg0._tf:TransformPoint(RollingBallConst.grid_width / 2, RollingBallConst.grid_height / 2, 0)
end

function var0.clearData(arg0)
	arg0.removeFlagH = false
	arg0.removeFlagV = false
	arg0.removeKey = nil
end

function var0.dispose(arg0)
	if arg0.dragDelegate then
		ClearEventTrigger(arg0.dragDelegate)
	end
end

return var0
