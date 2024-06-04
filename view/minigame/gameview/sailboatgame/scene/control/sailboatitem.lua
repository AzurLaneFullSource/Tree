local var0 = class("SailBoatItem")
local var1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._tf = arg1
	arg0._event = arg2
	arg0._collider = GetComponent(findTF(arg0._tf, "bound"), typeof(BoxCollider2D))
end

function var0.setData(arg0, arg1)
	arg0._itemData = arg1
end

function var0.start(arg0)
	arg0._removeFlag = false
	arg0._sceneWidth, arg0._sceneHeight = var1.scene_width, var1.scene_height
	arg0._maxRemoveHeight = -arg0._sceneHeight * 2
	arg0._maxRemoveWidth = arg0._sceneWidth * 2
	arg0._speed = arg0:getConfig("speed")

	arg0:setVisible(true)
end

function var0.step(arg0, arg1)
	local var0 = arg0._tf.anchoredPosition
	local var1 = var1.GetSceneSpeed()

	arg0._speed.x = arg0._speed.x * arg1 + var1.x
	arg0._speed.y = arg0._speed.y * arg1 + var1.y
	var0.x = var0.x + arg0._speed.x
	var0.y = var0.y + arg0._speed.y
	arg0._tf.anchoredPosition = var0

	if not arg0._removeFlag then
		if var0.y < arg0._maxRemoveHeight then
			arg0._removeFlag = true
		elseif math.abs(var0.x) > arg0._maxRemoveWidth then
			arg0._removeFlag = true
		end
	end
end

function var0.getSpeed(arg0)
	return arg0._speed
end

function var0.setContent(arg0, arg1)
	arg0._content = arg1

	SetParent(arg0._tf, arg1)
end

function var0.getId(arg0)
	return arg0._itemData.id
end

function var0.setVisible(arg0, arg1)
	setActive(arg0._tf, arg1)
end

function var0.setPosition(arg0, arg1)
	arg0._tf.anchoredPosition = arg1
end

function var0.clear(arg0)
	arg0:setVisible(false)
end

function var0.setRemoveFlag(arg0, arg1)
	arg0._removeFlag = arg1
end

function var0.getRemoveFlag(arg0)
	return arg0._removeFlag
end

function var0.dispose(arg0)
	var1 = nil
end

function var0.getColliderData(arg0)
	local var0 = arg0._content:InverseTransformPoint(arg0._collider.bounds.min)

	if not arg0._boundData then
		local var1 = arg0._content:InverseTransformPoint(arg0._collider.bounds.max)

		arg0._boundData = {
			width = math.floor(var1.x - var0.x),
			height = math.floor(var1.y - var0.y)
		}
	end

	return var0, arg0._boundData
end

function var0.getWorldColliderData(arg0)
	local var0 = arg0._collider.bounds.min

	if not arg0._worldBoundData then
		local var1 = arg0._collider.bounds.max

		arg0._worldBoundData = {
			width = var1.x - var0.x,
			height = var1.y - var0.y
		}
	end

	return var0, arg0._worldBoundData
end

function var0.getTf(arg0)
	return arg0._tf
end

function var0.getUseData(arg0)
	return {
		score = arg0:getConfig("score"),
		hp = arg0:getConfig("hp"),
		skill = arg0:getConfig("skill")
	}
end

function var0.checkPositionInRange(arg0, arg1)
	local var0 = arg0._tf.anchoredPosition
	local var1 = math.abs(var0.x - arg1.x)
	local var2 = math.abs(var0.y - arg1.y)
	local var3 = arg0:getConfig("range")

	if var1 < var3.x and var2 < var3.y then
		return true
	end

	return false
end

function var0.getPosition(arg0)
	return arg0._tf.anchoredPosition
end

function var0.getConfig(arg0, arg1)
	return arg0._itemData[arg1]
end

return var0
