local var0_0 = class("BoatAdEnemy")
local var1_0
local var2_0

var0_0.name_index = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	var2_0 = BoatAdGameConst
	arg0_1._tf = arg1_1
	arg0_1._eventCall = arg2_1
	arg0_1._collider = GetComponent(findTF(arg0_1._tf, "ad/bound"), typeof(BoxCollider2D))
	arg0_1._moveAnimator = GetComponent(arg0_1._tf, typeof(Animator))
	arg0_1._moveDftEvent = GetComponent(arg0_1._tf, typeof(DftAniEvent))
	arg0_1._hpTf = findTF(arg0_1._tf, "ad/img/hp")
	arg0_1._ad = findTF(arg0_1._tf, "ad")
	arg0_1._imgTf = findTF(arg0_1._tf, "ad/img")
	arg0_1._speedDownTf = findTF(arg0_1._tf, "ad/img/speedDown")

	if arg0_1._speedDownTf then
		setActive(arg0_1._speedDownTf, false)
	end

	arg0_1._moveDftEvent:SetEndEvent(function()
		print("触发移除标记")
		arg0_1:setRemoveFlag(true)
	end)
end

function var0_0.setData(arg0_3, arg1_3)
	arg0_3._data = arg1_3
	arg0_3._tf.name = arg0_3._data.id
	arg0_3._moveFlag = arg0_3:getConfig("move")
	arg0_3._moveSpeed = arg0_3:getConfig("speed")

	arg0_3:update()
end

function var0_0.update(arg0_4)
	setText(arg0_4._hpTf, arg0_4._hp)
end

function var0_0.start(arg0_5)
	var0_0.name_index = var0_0.name_index + 1
	arg0_5._removeFlag = false

	local var0_5 = arg0_5:getConfig("hp")

	arg0_5._hp = 10

	if type(var0_5) == "number" then
		arg0_5._hp = var0_5
	elseif type(var0_5) == "table" then
		arg0_5._hp = math.random(var0_5[1], var0_5[2])
	end

	arg0_5.moveDirect = math.random() < 0.5 and 1 or -1

	if arg0_5._speedDownTf then
		setActive(arg0_5._speedDownTf, false)
	end

	arg0_5._battleHp = 0
	arg0_5._destroyFlag = false
	arg0_5._stopFlag = false
	arg0_5._battleFlag = false
	arg0_5._ad.anchoredPosition = Vector2(0, 0)
	arg0_5._battleSubHp = arg0_5:getConfig("boss") and var2_0.battle_sub_hp_boss or var2_0.battle_sub_hp

	arg0_5:speedDown(false)
	arg0_5:update()
end

function var0_0.step(arg0_6, arg1_6)
	if arg0_6._battleHp > 0 then
		arg0_6._hp = arg0_6._hp - arg0_6._battleSubHp

		if arg0_6._hp < 0 then
			arg0_6._hp = 0
			arg0_6._battleHp = 0
			arg0_6._battleFlag = true

			arg0_6:setRemoveFlag(true)
		end

		arg0_6:update()
	end

	if arg0_6._moveFlag and arg0_6:getSpeed() > 0 and arg0_6._battleHp <= 0 and not arg0_6:getRemoveFlag() then
		local var0_6 = arg0_6._imgTf.localScale.x
		local var1_6 = arg0_6._speedDownFlag and var2_0.speed_down_rate or 1

		arg0_6._ad.anchoredPosition = Vector2(arg0_6._ad.anchoredPosition.x + arg0_6.moveDirect * arg0_6._moveSpeed * arg1_6 * var0_6 * var1_6, arg0_6._ad.anchoredPosition.y)

		local var2_6 = false

		if arg0_6.moveDirect == 1 then
			var2_6 = var1_0.CheckPointOutRightLine(arg0_6:getScenePosition())
		elseif arg0_6.moveDirect == -1 then
			var2_6 = var1_0.CheckPointOutLeftLine(arg0_6:getScenePosition())
		end

		if var2_6 then
			arg0_6.moveDirect = -arg0_6.moveDirect
		end
	end
end

function var0_0.setMoveCount(arg0_7, arg1_7, arg2_7)
	arg0_7.moveCount = arg1_7
	arg0_7.line = arg2_7

	arg0_7:setVisible(false)
	arg0_7:setVisible(true)
	arg0_7:setSpeed(1)
	arg0_7:setInteger(arg0_7._moveAnimator, "move_count", arg1_7)
	arg0_7:setTrigger(arg0_7._moveAnimator, "move")
end

function var0_0.getScenePosition(arg0_8)
	local var0_8 = arg0_8._tf.anchoredPosition
	local var1_8 = arg0_8._ad.anchoredPosition

	return {
		x = var0_8.x + var1_8.x,
		y = var0_8.y + var1_8.y
	}
end

function var0_0.getLine(arg0_9)
	return arg0_9.line
end

function var0_0.getMoveCount(arg0_10)
	return arg0_10.moveCount
end

function var0_0.bossFocus(arg0_11, arg1_11)
	local var0_11 = arg0_11._ad.anchoredPosition

	var0_11.x = var0_11.x + arg1_11
	arg0_11._ad.anchoredPosition = var0_11
end

function var0_0.setTrigger(arg0_12, arg1_12, arg2_12)
	arg1_12:SetTrigger("move")
end

function var0_0.getBoss(arg0_13)
	return arg0_13:getConfig("boss")
end

function var0_0.setInteger(arg0_14, arg1_14, arg2_14, arg3_14)
	arg1_14:SetInteger(arg2_14, arg3_14)
end

function var0_0.getLife(arg0_15)
	return arg0_15._hp > 0
end

function var0_0.getScale(arg0_16)
	return arg0_16._imgTf.localScale.y
end

function var0_0.getHp(arg0_17)
	return arg0_17._hp
end

function var0_0.speedDown(arg0_18, arg1_18)
	if arg0_18._moveFlag then
		arg0_18._speedDownFlag = arg1_18

		setActive(arg0_18._speedDownTf, arg1_18)
	end
end

function var0_0.battle(arg0_19, arg1_19)
	arg0_19._battleHp = arg1_19
end

function var0_0.getBattle(arg0_20)
	return arg0_20._battleHp > 0
end

function var0_0.getSpeed(arg0_21)
	return arg0_21._moveAnimator.speed
end

function var0_0.setSpeed(arg0_22, arg1_22)
	arg0_22._moveAnimator.speed = arg1_22
end

function var0_0.getDestroyFlag(arg0_23)
	return arg0_23._destroyFlag
end

function var0_0.setContent(arg0_24, arg1_24)
	arg0_24._content = arg1_24

	SetParent(arg0_24._tf, arg1_24)
end

function var0_0.getId(arg0_25)
	return arg0_25._data.id
end

function var0_0.setVisible(arg0_26, arg1_26)
	setActive(arg0_26._tf, arg1_26)
end

function var0_0.getPosition(arg0_27)
	return arg0_27._tf.anchoredPosition
end

function var0_0.getRelaPositionX(arg0_28)
	return arg0_28._tf.anchoredPosition.x + arg0_28._ad.anchoredPosition.x, arg0_28._tf.anchoredPosition.y + arg0_28._ad.anchoredPosition.y
end

function var0_0.getWorld(arg0_29)
	return arg0_29._tf.position
end

function var0_0.clear(arg0_30)
	arg0_30:setVisible(false)
end

function var0_0.setRemoveFlag(arg0_31, arg1_31)
	arg0_31._removeFlag = arg1_31
end

function var0_0.getGroup(arg0_32)
	return arg0_32:getConfig("group")
end

function var0_0.getTf(arg0_33)
	return arg0_33._tf
end

function var0_0.getRemoveFlag(arg0_34)
	return arg0_34._removeFlag
end

function var0_0.getMoveCount(arg0_35)
	return arg0_35.moveCount
end

function var0_0.dispose(arg0_36)
	var1_0 = nil
end

function var0_0.getColliderData(arg0_37)
	local var0_37 = arg0_37._content:InverseTransformPoint(arg0_37._collider.bounds.min)

	if not arg0_37._boundData then
		local var1_37 = arg0_37._content:InverseTransformPoint(arg0_37._collider.bounds.max)

		arg0_37._boundData = {
			width = math.floor(var1_37.x - var0_37.x),
			height = math.floor(var1_37.y - var0_37.y)
		}
	end

	return var0_37, arg0_37._boundData
end

function var0_0.getWorldColliderData(arg0_38)
	local var0_38 = arg0_38._collider.bounds.min

	if not arg0_38._worldBoundData then
		local var1_38 = arg0_38._collider.bounds.max

		arg0_38._worldBoundData = {
			width = var1_38.x - var0_38.x,
			height = var1_38.y - var0_38.y
		}
	end

	return var0_38, arg0_38._worldBoundData
end

function var0_0.getStop(arg0_39)
	return arg0_39._stopFlag
end

function var0_0.getMinMaxPosition(arg0_40)
	return arg0_40._collider.bounds.min, arg0_40._collider.bounds.max
end

function var0_0.getBoundWidth(arg0_41)
	return arg0_41._collider.size.x / 2
end

function var0_0.checkPositionInRange(arg0_42, arg1_42)
	local var0_42 = arg0_42._tf.anchoredPosition
	local var1_42 = math.abs(var0_42.x - arg1_42.x)
	local var2_42 = math.abs(var0_42.y - arg1_42.y)
	local var3_42 = arg0_42:getConfig("range")

	if var1_42 < var3_42.x and var2_42 < var3_42.y then
		return true
	end

	return false
end

function var0_0.getConfig(arg0_43, arg1_43)
	return arg0_43._data[arg1_43]
end

return var0_0
