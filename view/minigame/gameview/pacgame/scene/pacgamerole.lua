local var0_0 = class("PacGameRole")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._roleData = arg2_1
	arg0_1._tf.name = arg2_1.name
	arg0_1._autoState = arg2_1.auto_state
	arg0_1._enemyFlag = arg2_1.enemy
	arg0_1._bound = arg2_1.bound
	arg0_1._rate = arg2_1.rate and arg2_1.rate or 0
	arg0_1._rateCount = 0
	arg0_1._halfBound = {
		arg0_1._bound[1] / 2,
		arg0_1._bound[2] / 2
	}
	arg0_1._spineAnimUI = GetComponent(findTF(arg0_1._tf, "spine"), "SpineAnimUI")
	arg0_1._direct = {
		0,
		0
	}
	arg0_1._rushState = false
	arg0_1._rushTime = nil
	arg0_1._position = Vector2(0, 0)
	arg0_1._speed = arg2_1.speed
	arg0_1._rushSpeed = arg2_1.rush_speed
	arg0_1._anchoredPosition = arg0_1._tf.anchoredPosition
	arg0_1._roads = {}
	arg0_1._targetHistory = {}
	arg0_1._targetHistoryCount = 0
	arg0_1._isPlayer = false
	arg0_1._animator = GetComponent(arg0_1._tf, typeof(Animator))
	arg0_1._directArrowTf = findTF(arg0_1._tf, "player_arrow")

	arg0_1:setActionNormal()
end

function var0_0.SetPlayer(arg0_2, arg1_2)
	arg0_2._isPlayer = arg1_2
end

function var0_0.Step(arg0_3, arg1_3)
	arg0_3._deltaTime = arg1_3

	local var0_3 = arg0_3._animator:GetBool("flash")
	local var1_3 = false

	if arg0_3._rushTime and arg0_3._rushTime >= 0 then
		if arg0_3._rushTime <= 3 then
			var1_3 = true
		end

		arg0_3._rushTime = arg0_3._rushTime - arg1_3

		if arg0_3._rushTime < 0 then
			arg0_3:SetRush(false, nil)

			arg0_3._rushTime = nil
		end
	end

	if var0_3 ~= var1_3 then
		arg0_3._animator:SetBool("flash", var1_3)
	end

	if arg0_3._backStartStepTime and arg0_3._backStartStepTime >= 0 then
		arg0_3._backStartStepTime = arg0_3._backStartStepTime - arg1_3

		if arg0_3._backStartStepTime < 0 then
			arg0_3:SetAction("normal", 0)
			arg0_3:SetBackStart(false)

			arg0_3._backStartStepTime = nil
		end
	end
end

function var0_0.GetSpeed(arg0_4)
	if arg0_4._rushState then
		return arg0_4._rushSpeed
	elseif arg0_4:GetBackStart() then
		return arg0_4._speed * 4
	end

	if arg0_4._isPlayer then
		return arg0_4._speed
	end

	local var0_4 = arg0_4._speed + arg0_4._rate * arg0_4._rateCount

	return var0_4 >= PacGameConst.enemy_max_speed and PacGameConst.enemy_max_speed or var0_4
end

function var0_0.SetRateAdd(arg0_5)
	arg0_5._rateCount = arg0_5._rateCount + 1
end

function var0_0.SetStartIndex(arg0_6, arg1_6)
	arg0_6._startIndex = arg1_6
end

function var0_0.GetStartIndex(arg0_7)
	return arg0_7._startIndex
end

function var0_0.SetParent(arg0_8, arg1_8)
	setParent(arg0_8._tf, arg1_8)
end

function var0_0.GetParent(arg0_9)
	return arg0_9._tf.parent
end

function var0_0.SetPosition(arg0_10, arg1_10)
	arg0_10._tf.anchoredPosition = arg1_10
	arg0_10._anchoredPosition = arg0_10._tf.anchoredPosition
end

function var0_0.SetScale(arg0_11, arg1_11)
	arg0_11._tf.localScale = arg1_11
end

function var0_0.SetGridIndex(arg0_12, arg1_12)
	arg0_12._gridIndex = arg1_12

	if arg0_12:GetBackStart() and arg0_12._gridIndex == arg0_12._startIndex then
		arg0_12._backStartStepTime = 5
	end
end

function var0_0.GetGridIndex(arg0_13)
	return arg0_13._gridIndex
end

function var0_0.GetGridIndexNext(arg0_14)
	if arg0_14:HasTarget() then
		local var0_14 = math.abs(arg0_14._target.x - arg0_14._tf.anchoredPosition.x)
		local var1_14 = math.abs(arg0_14._target.y - arg0_14._tf.anchoredPosition.y)

		if var0_14 + var1_14 >= arg0_14._halfBound[1] then
			return arg0_14._gridIndex
		elseif var0_14 >= arg0_14._halfBound[1] then
			return arg0_14._gridIndex
		elseif var1_14 >= arg0_14._halfBound[2] then
			return arg0_14._gridIndex
		end

		return arg0_14._targetIndex
	end

	return arg0_14._gridIndex
end

function var0_0.HasTarget(arg0_15)
	return arg0_15._target ~= nil
end

function var0_0.SetBackStart(arg0_16, arg1_16)
	arg0_16._setBackToStart = arg1_16
end

function var0_0.GetBackStart(arg0_17)
	return arg0_17._setBackToStart
end

function var0_0.MoveTo(arg0_18, arg1_18)
	arg0_18._targetHistoryCount = arg0_18._targetHistoryCount + 1

	table.insert(arg0_18._targetHistory, arg1_18)
	arg0_18:SetPosition(arg1_18)
end

function var0_0.GetMove(arg0_19)
	return arg0_19._move
end

function var0_0.GetTarget(arg0_20)
	return arg0_20._target
end

function var0_0.SetRoads(arg0_21, arg1_21)
	arg0_21._roads = arg1_21
end

function var0_0.GetRoads(arg0_22)
	return arg0_22._roads
end

function var0_0.PopRoad(arg0_23)
	if #arg0_23._roads >= 0 then
		return table.remove(arg0_23._roads, 1)
	end

	return nil
end

function var0_0.SetRoadBack(arg0_24, arg1_24)
	arg0_24._roadBack = arg1_24
end

function var0_0.GetRoadBack(arg0_25)
	return arg0_25._roadBack
end

function var0_0.SetTarget(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	if arg1_26 then
		arg0_26._target = arg1_26
		arg0_26._targetIndex = arg2_26
		arg0_26._move = arg3_26
		arg0_26._targetDirect = arg4_26
		arg0_26._targetHistory = {}
		arg0_26._targetHistoryCount = 0

		arg0_26:setActionByDirect(arg4_26)

		if arg0_26._isPlayer then
			arg0_26:setDirectArrow(arg4_26)
		end
	else
		arg0_26._target = nil
		arg0_26._targetIndex = nil
		arg0_26._move = nil
		arg0_26._targetDirect = nil
		arg0_26._targetHistory = {}
		arg0_26._targetHistoryCount = 0

		arg0_26:setActionByDirect(arg0_26._direct)
	end
end

function var0_0.GetTargetHistoryCount(arg0_27)
	return arg0_27._targetHistoryCount
end

function var0_0.GetTargetDirect(arg0_28)
	return arg0_28._targetDirect
end

function var0_0.GetTargetIndex(arg0_29)
	return arg0_29._targetIndex
end

function var0_0.GetAutoState(arg0_30)
	return arg0_30._autoState
end

function var0_0.SetActive(arg0_31, arg1_31)
	setActive(arg0_31._tf, arg1_31)
end

function var0_0.SetAction(arg0_32, arg1_32, arg2_32)
	if arg0_32._playingAction == arg1_32 then
		return
	end

	arg0_32._playingAction = arg1_32

	arg0_32._spineAnimUI:SetAction(arg1_32, arg2_32)
end

function var0_0.SetActionCallBack(arg0_33, arg1_33)
	arg0_33._spineAnimUI:SetActionCallBack(arg1_33)
end

function var0_0.SetRush(arg0_34, arg1_34, arg2_34)
	print("角色开始冲刺")

	arg0_34._rushState = arg1_34
	arg0_34._rushTime = arg2_34

	arg0_34:reflashAniamtion()
end

function var0_0.GetRush(arg0_35)
	return arg0_35._rushState
end

function var0_0.GetPosition(arg0_36)
	return arg0_36._anchoredPosition
end

function var0_0.SetDirect(arg0_37, arg1_37)
	arg1_37 = arg1_37 or {
		0,
		0
	}
	arg0_37._direct = arg1_37

	if not arg0_37:HasTarget() then
		arg0_37:setActionByDirect(arg0_37._direct)
	end
end

function var0_0.GetDirect(arg0_38)
	return arg0_38._direct
end

function var0_0.SetAsLastSibling(arg0_39)
	if arg0_39._tf then
		arg0_39._tf:SetAsLastSibling()
	end
end

function var0_0.Dispose(arg0_40)
	if arg0_40._tf then
		destroy(arg0_40._tf)

		arg0_40._tf = nil
	end

	arg0_40._roleData = nil
	arg0_40._playingAction = nil

	if arg0_40._spineAnimUI then
		arg0_40._spineAnimUI:SetActionCallBack(nil)

		arg0_40._spineAnimUI = nil
	end

	arg0_40._target = nil
	arg0_40._roads = {}
end

function var0_0.setDirectArrow(arg0_41, arg1_41)
	setActive(findTF(arg0_41._tf, "bg/L"), false)
	setActive(findTF(arg0_41._tf, "bg/R"), false)
	setActive(findTF(arg0_41._tf, "bg/T"), false)
	setActive(findTF(arg0_41._tf, "bg/B"), false)

	if arg1_41[1] == 1 then
		setActive(findTF(arg0_41._tf, "bg/R"), true)
	elseif arg1_41[1] == -1 then
		setActive(findTF(arg0_41._tf, "bg/L"), true)
	elseif arg1_41[2] == 1 then
		setActive(findTF(arg0_41._tf, "bg/T"), true)
	elseif arg1_41[2] == -1 then
		setActive(findTF(arg0_41._tf, "bg/B"), true)
	end
end

function var0_0.reflashAniamtion(arg0_42)
	if arg0_42._targetDirect then
		arg0_42:setActionByDirect(arg0_42._targetDirect)
	elseif arg0_42._direct then
		arg0_42:setActionByDirect(arg0_42._direct)
	end
end

function var0_0.setActionByDirect(arg0_43, arg1_43)
	local var0_43 = arg0_43:getDirectActionName(arg1_43)
	local var1_43

	if arg0_43:GetBackStart() then
		var1_43 = "hang"
	elseif var0_43 then
		arg0_43._idleAction = "idle_" .. var0_43
		var1_43 = arg0_43._rushState and "rush_" .. var0_43 or "run_" .. var0_43
	end

	if var1_43 then
		if var1_43 and var1_43 ~= arg0_43._playingAction then
			arg0_43:SetAction(var1_43, 0)
		end
	elseif arg0_43._isPlayer and arg0_43._idleAction and arg0_43._idleAction ~= arg0_43._playingAction then
		arg0_43:SetAction(arg0_43._idleAction, 0)
	end
end

function var0_0.SetHangAction(arg0_44)
	arg0_44:SetAction("hang", 0)
end

function var0_0.getDirectActionName(arg0_45, arg1_45)
	local var0_45

	if arg1_45[1] ~= 0 then
		var0_45 = arg1_45[1] > 0 and "right" or "left"
	elseif arg1_45[2] ~= 0 then
		var0_45 = arg1_45[2] > 0 and "up" or "down"
	end

	return var0_45
end

function var0_0.setActionNormal(arg0_46)
	arg0_46:SetAction("normal", 0)
end

function var0_0.GetEnemyFlag(arg0_47)
	return arg0_47._enemyFlag
end

return var0_0
