local var0_0 = class("BoatAdChar")
local var1_0
local var2_0
local var3_0 = 0.5

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	var2_0 = BoatAdGameConst
	arg0_1._tf = arg1_1
	arg0_1._eventCallback = arg2_1
	arg0_1._collider = GetComponent(findTF(arg0_1._tf, "bound"), typeof(BoxCollider2D))
	arg0_1.imgTf = findTF(arg0_1._tf, "img")
	arg0_1._charSpineAnim = GetComponent(findTF(arg0_1.imgTf, "char"), typeof(SpineAnimUI))
	arg0_1._yanwuTf = findTF(arg0_1.imgTf, "yanwu")
	arg0_1._yanwuAnimUI = GetComponent(arg0_1._yanwuTf, typeof(SpineAnimUI))
	arg0_1._hpTf = findTF(arg0_1._tf, "hp")

	setActive(arg0_1._tf, false)

	arg0_1._playerAnimator = GetComponent(arg0_1._tf, typeof(Animator))
	arg0_1.battleEffectTf = findTF(arg0_1._tf, "battleEffect")
	arg0_1.battleEffectSpine1 = GetComponent(findTF(arg0_1.battleEffectTf, "spine1"), typeof(SpineAnimUI))
	arg0_1.battleEffectSpine2 = GetComponent(findTF(arg0_1.battleEffectTf, "spine2"), typeof(SpineAnimUI))
	arg0_1.guardTf = findTF(arg0_1._tf, "guard")
end

function var0_0.setData(arg0_2, arg1_2)
	arg0_2._data = arg1_2
	arg0_2._baseSpeed = arg0_2:getConfig("speed")
	arg0_2._baseHp = arg0_2:getConfig("hp")
end

function var0_0.setContent(arg0_3, arg1_3)
	arg0_3._content = arg1_3

	SetParent(arg0_3._tf, arg1_3)
end

function var0_0.changeDirect(arg0_4, arg1_4, arg2_4)
	arg0_4._directX = arg1_4
	arg0_4._directY = arg2_4

	if arg0_4._battleHp > 0 then
		arg0_4.imgTf.localEulerAngles = Vector3(0, 0, 0)
	elseif arg0_4._directX < 0 then
		arg0_4.imgTf.localEulerAngles = Vector3(0, 0, 3)
	elseif arg0_4._directX > 0 then
		arg0_4.imgTf.localEulerAngles = Vector3(0, 0, -3)
	else
		arg0_4.imgTf.localEulerAngles = Vector3(0, 0, 0)
	end
end

function var0_0.getWorld(arg0_5)
	return arg0_5._tf.position
end

function var0_0.start(arg0_6)
	arg0_6._directX = 0
	arg0_6._directY = 0

	setActive(arg0_6._tf, true)

	arg0_6._tf.anchoredPosition = arg0_6:getConfig("start_pos")
	arg0_6._speed = Vector2(0, 0)
	arg0_6._speed.x = arg0_6._baseSpeed.x
	arg0_6._speed.y = arg0_6._baseSpeed.y
	arg0_6._hp = arg0_6._baseHp
	arg0_6._timeForDead = nil
	arg0_6._battleHp = 0
	arg0_6.colliderLine = 0
	arg0_6.guardTime = 0
	arg0_6.stopFlag = false

	arg0_6:updateCharMoveCount()
	arg0_6:updateUI()
	arg0_6:updateChange(false)

	arg0_6.stepSound = 0
end

function var0_0.step(arg0_7, arg1_7)
	local var0_7 = false

	arg0_7.stepSound = arg0_7.stepSound - arg1_7

	if arg0_7._battleHp > 0 then
		local var1_7 = arg0_7._battleHp > arg0_7._battleSubHp and arg0_7._battleSubHp or arg0_7._battleHp

		arg0_7._battleHp = arg0_7._battleHp - var1_7

		arg0_7:subHp(var1_7)

		if arg0_7._hp <= 0 then
			arg0_7._hp = 0
			arg0_7._battleHp = 0
		end

		local var2_7 = true

		arg0_7:updateUI()

		if arg0_7.stepSound <= 0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_SOUND_BATTLE)

			arg0_7.stepSound = var3_0
		end
	end

	if arg0_7:getLife() and arg0_7._battleHp == 0 then
		local var3_7 = arg0_7:getNextPosition(arg0_7._directX, arg0_7._directY)

		if math.abs(var3_7.x) > var2_0.player_width / 2 + 50 or math.abs(var3_7.y) > var2_0.player_height / 2 + 50 then
			-- block empty
		else
			arg0_7._tf.anchoredPosition = var3_7

			arg0_7:updateCharMoveCount()
		end
	end

	if arg0_7.guardTime and arg0_7.guardTime > 0 and arg0_7._battleHp <= 0 then
		arg0_7.guardTime = arg0_7.guardTime - arg1_7

		if arg0_7.guardTime <= 0 then
			arg0_7.guardTime = 0

			arg0_7:updateGuard()
		end
	end

	if arg0_7:getLife() and arg0_7._battleHp <= 0 and arg0_7._changeIndex ~= arg0_7:getCharChange() then
		arg0_7:updateChange(true)
	end
end

function var0_0.getGuard(arg0_8)
	return arg0_8.guardTime > 0
end

function var0_0.addGuard(arg0_9, arg1_9)
	arg0_9.guardTime = arg1_9

	arg0_9:updateGuard()
end

function var0_0.subHp(arg0_10, arg1_10)
	if not arg0_10:getGuard() then
		arg0_10._hp = arg0_10._hp - arg1_10
	end

	if arg0_10._hp < 0 then
		arg0_10._hp = 0
	end

	arg0_10:updateUI()
end

function var0_0.updateGuard(arg0_11)
	if not arg0_11.stopFlag then
		setActive(arg0_11.guardTf, arg0_11.guardTime > 0)
	end
end

function var0_0.updateChange(arg0_12, arg1_12)
	arg0_12._changeIndex = arg0_12:getCharChange()

	if arg1_12 then
		setActive(arg0_12._yanwuTf, true)
		arg0_12:setAnimation(arg0_12._yanwuAnimUI, "normal", function()
			setActive(arg0_12._yanwuTf, false)
		end)
		arg0_12:setAnimation(arg0_12._charSpineAnim, "normal" .. arg0_12._changeIndex)
	else
		setActive(arg0_12._yanwuTf, false)
		arg0_12:setAnimation(arg0_12._charSpineAnim, "normal" .. arg0_12._changeIndex)
	end
end

function var0_0.getCharChange(arg0_14)
	local var0_14 = 1

	for iter0_14 = 1, #BoatAdGameConst.char_change_hp do
		if arg0_14._hp >= BoatAdGameConst.char_change_hp[iter0_14] then
			var0_14 = iter0_14 + 1
		end
	end

	return var0_14
end

function var0_0.setAnimation(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	arg1_15:SetActionCallBack(nil)
	arg1_15:SetAction(arg2_15, 0)
	arg1_15:SetActionCallBack(function(arg0_16)
		if arg0_16 == "action" and arg4_15 then
			arg4_15()
		end

		if arg0_16 == "finish" then
			arg1_15:SetActionCallBack(nil)

			if arg3_15 then
				arg3_15()
			end
		end
	end)
end

function var0_0.updateUI(arg0_17)
	if arg0_17._battleHp > 0 and not isActive(arg0_17.battleEffectTf) then
		setActive(arg0_17.battleEffectTf, true)
		arg0_17:setAnimation(arg0_17.battleEffectSpine1, "normal")
		arg0_17:setAnimation(arg0_17.battleEffectSpine2, "normal")
	elseif arg0_17._battleHp <= 0 and isActive(arg0_17.battleEffectTf) then
		setActive(arg0_17.battleEffectTf, false)
	end

	setText(arg0_17._hpTf, arg0_17._hp)
	arg0_17:updateGuard()
end

function var0_0.updateCharMoveCount(arg0_18)
	local var0_18 = arg0_18._tf.anchoredPosition.x
	local var1_18
	local var2_18

	for iter0_18, iter1_18 in ipairs(BoatAdGameConst.move_line_width) do
		if not var2_18 then
			var2_18 = math.abs(var0_18 - iter1_18)
			var1_18 = iter0_18
		elseif var2_18 > math.abs(var0_18 - iter1_18) then
			var2_18 = math.abs(var0_18 - iter1_18)
			var1_18 = iter0_18
		end
	end

	if arg0_18.moveCount ~= var1_18 then
		print("设置角色moveCount" .. var1_18)
	end

	arg0_18.moveCount = var1_18
end

function var0_0.setLine(arg0_19, arg1_19)
	arg0_19.colliderLine = arg1_19
end

function var0_0.getLine(arg0_20)
	return arg0_20.colliderLine
end

function var0_0.getMoveCount(arg0_21)
	return arg0_21.moveCount
end

function var0_0.battle(arg0_22, arg1_22, arg2_22)
	arg0_22._battleHp = arg1_22
	arg0_22._battleBoss = arg2_22
	arg0_22._battleSubHp = arg2_22 and var2_0.battle_sub_hp_boss or var2_0.battle_sub_hp
end

function var0_0.getBattle(arg0_23)
	return arg0_23._battleHp > 0
end

function var0_0.getHpPos(arg0_24)
	return arg0_24._hpTf.position
end

function var0_0.getNextPosition(arg0_25, arg1_25, arg2_25)
	local var0_25 = 0

	if arg1_25 ~= 0 then
		var0_25 = arg0_25._speed.x * arg1_25 * var1_0.deltaTime
	end

	local var1_25 = 0

	if arg2_25 ~= 0 then
		var1_25 = arg0_25._speed.y * arg2_25 * var1_0.deltaTime
	end

	local var2_25 = arg0_25._tf.anchoredPosition

	if var0_25 ~= 0 or var1_25 ~= 0 then
		var2_25.x = var2_25.x + var0_25
		var2_25.y = var2_25.y + var1_25

		return var2_25
	end

	return var2_25
end

function var0_0.getTf(arg0_26)
	return arg0_26._tf
end

function var0_0.getHp(arg0_27)
	return arg0_27._hp
end

function var0_0.getColliderData(arg0_28)
	local var0_28 = arg0_28._content:InverseTransformPoint(arg0_28._collider.bounds.min)

	if not arg0_28._boundData then
		local var1_28 = arg0_28._content:InverseTransformPoint(arg0_28._collider.bounds.max)

		arg0_28._boundData = {
			width = math.floor(var1_28.x - var0_28.x),
			height = math.floor(var1_28.y - var0_28.y)
		}
	end

	return var0_28, arg0_28._boundData
end

function var0_0.flash(arg0_29)
	arg0_29._playerAnimator:SetTrigger("flash")
end

function var0_0.changeHp(arg0_30, arg1_30, arg2_30)
	if arg1_30 ~= 0 then
		local var0_30 = arg0_30._hp

		if arg2_30 == BoatAdGameConst.hp_type_sub then
			var0_30 = arg0_30._hp + arg1_30
		elseif arg2_30 == BoatAdGameConst.hp_type_mul then
			var0_30 = arg0_30._hp * arg1_30
		elseif arg2_30 == BoatAdGameConst.hp_type_div then
			var0_30 = arg0_30._hp / arg1_30
		end

		local var1_30 = math.floor(var0_30)

		if var1_30 < arg0_30._hp then
			arg0_30:flash()
		end

		if arg0_30:getGuard() and var1_30 <= arg0_30._hp then
			arg0_30._hp = arg0_30._hp
		else
			arg0_30._hp = var1_30
		end

		arg0_30:updateUI()

		if arg0_30._changeIndex ~= arg0_30:getCharChange() then
			arg0_30:updateChange(true)
		end
	end
end

function var0_0.getWorldColliderData(arg0_31)
	local var0_31 = arg0_31._collider.bounds.min

	if not arg0_31._worldBoundData then
		local var1_31 = arg0_31._collider.bounds.max

		arg0_31._worldBoundData = {
			width = var1_31.x - var0_31.x,
			height = var1_31.y - var0_31.y
		}
	end

	return var0_31, arg0_31._worldBoundData
end

function var0_0.getLife(arg0_32)
	return arg0_32._hp > 0
end

function var0_0.getColliderMinPosition(arg0_33)
	if not arg0_33._minPosition then
		arg0_33._minPosition = arg0_33._tf:InverseTransformPoint(arg0_33._collider.bounds.min)
	end

	return arg0_33._minPosition
end

function var0_0.getBoundData(arg0_34)
	local var0_34 = arg0_34._content:InverseTransformPoint(arg0_34._collider.bounds.min)

	if not arg0_34._boundData then
		local var1_34 = arg0_34._content:InverseTransformPoint(arg0_34._collider.bounds.max)

		arg0_34._boundData = {
			width = math.floor(var1_34.x - var0_34.x),
			height = math.floor(var1_34.y - var0_34.y)
		}
	end

	return arg0_34._boundData
end

function var0_0.getPosition(arg0_35)
	return arg0_35._tf.anchoredPosition
end

function var0_0.getGroup(arg0_36)
	return arg0_36:getConfig("group")
end

function var0_0.clear(arg0_37)
	arg0_37._battleHp = 0

	arg0_37:updateUI()
end

function var0_0.stop(arg0_38)
	arg0_38.stopFlag = true

	setActive(arg0_38.guardTf, false)
end

function var0_0.resume(arg0_39)
	arg0_39.stopFlag = false

	arg0_39:updateGuard()
end

function var0_0.getMinMaxPosition(arg0_40)
	return arg0_40._collider.bounds.min, arg0_40._collider.bounds.max
end

function var0_0.getConfig(arg0_41, arg1_41)
	return arg0_41._data[arg1_41]
end

function var0_0.checkPositionInRange(arg0_42, arg1_42)
	local var0_42 = arg0_42._tf.anchoredPosition
	local var1_42 = math.abs(var0_42.x - arg1_42.x)
	local var2_42 = math.abs(var0_42.y - arg1_42.y)

	if var1_42 < arg0_42:getConfig("range") and var2_42 < arg0_42:getConfig("range") then
		return true
	end

	return false
end

function var0_0.dispose(arg0_43)
	return
end

return var0_0
