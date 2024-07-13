local var0_0 = class("SailBoatItem")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._collider = GetComponent(findTF(arg0_1._tf, "bound"), typeof(BoxCollider2D))
end

function var0_0.setData(arg0_2, arg1_2)
	arg0_2._itemData = arg1_2
end

function var0_0.start(arg0_3)
	arg0_3._removeFlag = false
	arg0_3._sceneWidth, arg0_3._sceneHeight = var1_0.scene_width, var1_0.scene_height
	arg0_3._maxRemoveHeight = -arg0_3._sceneHeight * 2
	arg0_3._maxRemoveWidth = arg0_3._sceneWidth * 2
	arg0_3._speed = arg0_3:getConfig("speed")

	arg0_3:setVisible(true)
end

function var0_0.step(arg0_4, arg1_4)
	local var0_4 = arg0_4._tf.anchoredPosition
	local var1_4 = var1_0.GetSceneSpeed()

	arg0_4._speed.x = arg0_4._speed.x * arg1_4 + var1_4.x
	arg0_4._speed.y = arg0_4._speed.y * arg1_4 + var1_4.y
	var0_4.x = var0_4.x + arg0_4._speed.x
	var0_4.y = var0_4.y + arg0_4._speed.y
	arg0_4._tf.anchoredPosition = var0_4

	if not arg0_4._removeFlag then
		if var0_4.y < arg0_4._maxRemoveHeight then
			arg0_4._removeFlag = true
		elseif math.abs(var0_4.x) > arg0_4._maxRemoveWidth then
			arg0_4._removeFlag = true
		end
	end
end

function var0_0.getSpeed(arg0_5)
	return arg0_5._speed
end

function var0_0.setContent(arg0_6, arg1_6)
	arg0_6._content = arg1_6

	SetParent(arg0_6._tf, arg1_6)
end

function var0_0.getId(arg0_7)
	return arg0_7._itemData.id
end

function var0_0.setVisible(arg0_8, arg1_8)
	setActive(arg0_8._tf, arg1_8)
end

function var0_0.setPosition(arg0_9, arg1_9)
	arg0_9._tf.anchoredPosition = arg1_9
end

function var0_0.clear(arg0_10)
	arg0_10:setVisible(false)
end

function var0_0.setRemoveFlag(arg0_11, arg1_11)
	arg0_11._removeFlag = arg1_11
end

function var0_0.getRemoveFlag(arg0_12)
	return arg0_12._removeFlag
end

function var0_0.dispose(arg0_13)
	var1_0 = nil
end

function var0_0.getColliderData(arg0_14)
	local var0_14 = arg0_14._content:InverseTransformPoint(arg0_14._collider.bounds.min)

	if not arg0_14._boundData then
		local var1_14 = arg0_14._content:InverseTransformPoint(arg0_14._collider.bounds.max)

		arg0_14._boundData = {
			width = math.floor(var1_14.x - var0_14.x),
			height = math.floor(var1_14.y - var0_14.y)
		}
	end

	return var0_14, arg0_14._boundData
end

function var0_0.getWorldColliderData(arg0_15)
	local var0_15 = arg0_15._collider.bounds.min

	if not arg0_15._worldBoundData then
		local var1_15 = arg0_15._collider.bounds.max

		arg0_15._worldBoundData = {
			width = var1_15.x - var0_15.x,
			height = var1_15.y - var0_15.y
		}
	end

	return var0_15, arg0_15._worldBoundData
end

function var0_0.getTf(arg0_16)
	return arg0_16._tf
end

function var0_0.getUseData(arg0_17)
	return {
		score = arg0_17:getConfig("score"),
		hp = arg0_17:getConfig("hp"),
		skill = arg0_17:getConfig("skill")
	}
end

function var0_0.checkPositionInRange(arg0_18, arg1_18)
	local var0_18 = arg0_18._tf.anchoredPosition
	local var1_18 = math.abs(var0_18.x - arg1_18.x)
	local var2_18 = math.abs(var0_18.y - arg1_18.y)
	local var3_18 = arg0_18:getConfig("range")

	if var1_18 < var3_18.x and var2_18 < var3_18.y then
		return true
	end

	return false
end

function var0_0.getPosition(arg0_19)
	return arg0_19._tf.anchoredPosition
end

function var0_0.getConfig(arg0_20, arg1_20)
	return arg0_20._itemData[arg1_20]
end

return var0_0
