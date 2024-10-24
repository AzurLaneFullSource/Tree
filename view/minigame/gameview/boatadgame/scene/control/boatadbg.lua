local var0_0 = class("BoatAdBg")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._moveAnimator = GetComponent(arg0_1._tf, typeof(Animator))
	arg0_1._moveDftEvent = GetComponent(arg0_1._tf, typeof(DftAniEvent))
	arg0_1.spineTf = findTF(arg0_1._tf, "ad/img/spine")

	arg0_1._moveDftEvent:SetEndEvent(function()
		arg0_1:setRemoveFlag(true)
	end)
end

function var0_0.setData(arg0_3, arg1_3)
	arg0_3._data = arg1_3
end

function var0_0.setSpeed(arg0_4, arg1_4)
	arg0_4._moveAnimator.speed = arg1_4
end

function var0_0.getMoveCount(arg0_5)
	return arg0_5.moveCount
end

function var0_0.setRemoveFlag(arg0_6, arg1_6)
	arg0_6._removeFlag = arg1_6
end

function var0_0.getRemoveFlag(arg0_7)
	return arg0_7._removeFlag
end

function var0_0.getId(arg0_8)
	return arg0_8:getConfig("id")
end

function var0_0.getConfig(arg0_9, arg1_9)
	return arg0_9._data[arg1_9]
end

function var0_0.setMoveCount(arg0_10, arg1_10)
	arg0_10.moveCount = arg1_10

	arg0_10:setVisible(false)
	arg0_10:setVisible(true)
	arg0_10:setSpeed(1)
	arg0_10:setInteger(arg0_10._moveAnimator, "move_count", arg1_10)
	arg0_10:setTrigger(arg0_10._moveAnimator, "bg")
end

function var0_0.setInteger(arg0_11, arg1_11, arg2_11, arg3_11)
	arg1_11:SetInteger(arg2_11, arg3_11)
end

function var0_0.setTrigger(arg0_12, arg1_12, arg2_12)
	arg1_12:SetTrigger(arg2_12)
end

function var0_0.setContent(arg0_13, arg1_13)
	arg0_13._content = arg1_13

	SetParent(arg0_13._tf, arg1_13)
end

function var0_0.setVisible(arg0_14, arg1_14)
	setActive(arg0_14._tf, arg1_14)
end

function var0_0.getPosition(arg0_15)
	return arg0_15._tf.anchoredPosition
end

function var0_0.start(arg0_16)
	arg0_16._removeFlag = false
end

function var0_0.step(arg0_17)
	return
end

function var0_0.checkEmptyGrid(arg0_18)
	return
end

function var0_0.stop(arg0_19)
	return
end

function var0_0.clear(arg0_20)
	return
end

function var0_0.dispose(arg0_21)
	return
end

return var0_0
