local var0_0 = class("BoatAdItem")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._collider = GetComponent(findTF(arg0_1._tf, "ad/bound"), typeof(BoxCollider2D))
	arg0_1._moveAnimator = GetComponent(arg0_1._tf, typeof(Animator))
	arg0_1._moveDftEvent = GetComponent(arg0_1._tf, typeof(DftAniEvent))
	arg0_1._hpTf = findTF(arg0_1._tf, "ad/img/hp")
	arg0_1.leftTf = findTF(arg0_1._tf, "ad/img/left")
	arg0_1.rightTf = findTF(arg0_1._tf, "ad/img/right")
	arg0_1.textureTf = findTF(arg0_1._tf, "ad/img/texture")

	arg0_1._moveDftEvent:SetEndEvent(function()
		arg0_1:setRemoveFlag(true)
	end)
end

function var0_0.setData(arg0_3, arg1_3)
	arg0_3._itemData = arg1_3

	local var0_3 = 0

	arg0_3._tf.name = arg1_3.id

	if type(arg0_3:getConfig("hp")) == "number" then
		var0_3 = arg0_3:getConfig("hp")
	elseif type(arg0_3:getConfig("hp")) == "table" then
		local var1_3 = arg0_3:getConfig("hp")

		var0_3 = math.random(var1_3[1], var1_3[2])
	end

	arg0_3._hp = var0_3
end

function var0_0.start(arg0_4)
	arg0_4._removeFlag = false

	setActive(arg0_4.textureTf, true)

	arg0_4._touchFlag = false

	arg0_4:updateUI()
end

function var0_0.step(arg0_5, arg1_5)
	return
end

function var0_0.updateUI(arg0_6)
	if arg0_6:getConfig("buff") then
		if arg0_6._hp and not arg0_6:getConfig("item") then
			local var0_6 = arg0_6:getConfig("hp_type")
			local var1_6 = ""

			if var0_6 == BoatAdGameConst.hp_type_sub then
				var1_6 = arg0_6._hp >= 0 and "+" or ""
			elseif var0_6 == BoatAdGameConst.hp_type_mul then
				var1_6 = "*"
			elseif var0_6 == BoatAdGameConst.hp_type_div then
				var1_6 = "/"
			end

			setText(arg0_6._hpTf, var1_6 .. arg0_6._hp)
			setActive(arg0_6._hpTf, true)
		else
			setActive(arg0_6._hpTf, false)
		end
	end
end

function var0_0.getHp(arg0_7)
	return arg0_7._hp
end

function var0_0.setMoveCount(arg0_8, arg1_8, arg2_8)
	arg0_8.moveCount = arg1_8
	arg0_8.line = arg2_8

	arg0_8:setVisible(false)
	arg0_8:setVisible(true)
	arg0_8:setSpeed(1)
	arg0_8:setInteger(arg0_8._moveAnimator, "move_count", arg1_8)

	if arg0_8:getConfig("buff") then
		arg0_8:setTrigger(arg0_8._moveAnimator, "buff")
	else
		arg0_8:setTrigger(arg0_8._moveAnimator, "move")
	end

	setActive(arg0_8.leftTf, false)
	setActive(arg0_8.rightTf, false)

	arg0_8.leftTf.localScale = Vector3(-1, 1, 1)
	arg0_8.rightTf.localScale = Vector3(1, 1, 1)

	if arg0_8.moveCount == 3 then
		setActive(arg0_8.leftTf, true)
		setActive(arg0_8.rightTf, true)
	elseif arg0_8.moveCount < 3 then
		setActive(arg0_8.leftTf, true)
	elseif arg0_8.moveCount > 3 then
		setActive(arg0_8.rightTf, true)
	end
end

function var0_0.getLine(arg0_9)
	return arg0_9.line
end

function var0_0.setSpeed(arg0_10, arg1_10)
	arg0_10._moveAnimator.speed = arg1_10
end

function var0_0.getMoveCount(arg0_11)
	return arg0_11.moveCount
end

function var0_0.getBuff(arg0_12)
	return arg0_12:getConfig("buff")
end

function var0_0.setTrigger(arg0_13, arg1_13, arg2_13)
	arg1_13:SetTrigger(arg2_13)
end

function var0_0.setTouch(arg0_14)
	setActive(arg0_14.textureTf, false)
	setActive(arg0_14._hpTf, false)

	arg0_14._touchFlag = true
end

function var0_0.getTouchFlag(arg0_15)
	return arg0_15._touchFlag
end

function var0_0.setInteger(arg0_16, arg1_16, arg2_16, arg3_16)
	arg1_16:SetInteger(arg2_16, arg3_16)
end

function var0_0.getSpeed(arg0_17)
	return arg0_17._speed
end

function var0_0.setContent(arg0_18, arg1_18)
	arg0_18._content = arg1_18

	SetParent(arg0_18._tf, arg1_18)
end

function var0_0.getId(arg0_19)
	return arg0_19._itemData.id
end

function var0_0.setVisible(arg0_20, arg1_20)
	setActive(arg0_20._tf, arg1_20)
end

function var0_0.clear(arg0_21)
	arg0_21:setVisible(false)
end

function var0_0.setRemoveFlag(arg0_22, arg1_22)
	arg0_22._removeFlag = arg1_22
end

function var0_0.getRemoveFlag(arg0_23)
	return arg0_23._removeFlag
end

function var0_0.dispose(arg0_24)
	var1_0 = nil
end

function var0_0.getColliderData(arg0_25)
	local var0_25 = arg0_25._content:InverseTransformPoint(arg0_25._collider.bounds.min)

	if not arg0_25._boundData then
		local var1_25 = arg0_25._content:InverseTransformPoint(arg0_25._collider.bounds.max)

		arg0_25._boundData = {
			width = math.floor(var1_25.x - var0_25.x),
			height = math.floor(var1_25.y - var0_25.y)
		}
	end

	return var0_25, arg0_25._boundData
end

function var0_0.getWorldColliderData(arg0_26)
	local var0_26 = arg0_26._collider.bounds.min

	if not arg0_26._worldBoundData then
		local var1_26 = arg0_26._collider.bounds.max

		arg0_26._worldBoundData = {
			width = var1_26.x - var0_26.x,
			height = var1_26.y - var0_26.y
		}
	end

	return var0_26, arg0_26._worldBoundData
end

function var0_0.getTf(arg0_27)
	return arg0_27._tf
end

function var0_0.getUseData(arg0_28)
	return {
		score = arg0_28:getConfig("score"),
		hp = arg0_28:getConfig("hp"),
		skill = arg0_28:getConfig("skill")
	}
end

function var0_0.getScore(arg0_29)
	return arg0_29:getConfig("score")
end

function var0_0.checkPositionInRange(arg0_30, arg1_30)
	local var0_30 = arg0_30._tf.anchoredPosition
	local var1_30 = math.abs(var0_30.x - arg1_30.x)
	local var2_30 = math.abs(var0_30.y - arg1_30.y)
	local var3_30 = arg0_30:getConfig("range")

	if var1_30 < var3_30.x and var2_30 < var3_30.y then
		return true
	end

	return false
end

function var0_0.getPosition(arg0_31)
	return arg0_31._tf.anchoredPosition
end

function var0_0.getConfig(arg0_32, arg1_32)
	return arg0_32._itemData[arg1_32]
end

return var0_0
