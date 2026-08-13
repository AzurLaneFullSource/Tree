local var0_0 = class("CrossRoadRole")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._tf = arg1_1
	arg0_1._runningData = arg4_1
	arg0_1._tpl = arg3_1
	arg0_1.id = arg2_1
	arg0_1.fa = arg2_1
	arg0_1.startTime = 0
	arg0_1.speed = CrossRoadGameConst.CHILD_SPEED
	arg0_1.target = nil
	arg0_1.spineAnimUI = GetComponent(findTF(arg0_1._tf, "spine"), "SpineAnimUI")
	arg0_1.playingAction = nil
	arg0_1.arrowGroup = arg0_1._tf:Find("player_arrow/ad/arrow")
	arg0_1.selectTF = arg0_1.arrowGroup:Find("select")
	arg0_1.angryTF = arg0_1.arrowGroup:Find("angry")
	arg0_1.angryAni = arg0_1.angryTF:GetComponent(typeof(Animation))
	arg0_1.selectAni = arg0_1.selectTF:GetComponent(typeof(Animation))
	arg0_1.direct = {
		-1,
		0
	}
	arg0_1.trackName = CrossRoadGameConst.BACK_ROAD_NAME
	arg0_1.runState = nil
	arg0_1.playerHaveSelect = false
	arg0_1.angryTime = 0
	arg0_1.lastSelectTime = 0
	arg0_1.startAngryTime = 0
	arg0_1.lastAngryRollTime = 0
	arg0_1.lastXuanWoRollTime = 0

	arg0_1:setActionNormal()
end

function var0_0.GetRoleRectPoint(arg0_2)
	local var0_2 = arg0_2:GetPosition()
	local var1_2 = arg0_2._tf.rect

	return var0_2.x - var1_2.width / 2, var0_2.y - var1_2.height / 2, var0_2.x + var1_2.width / 2, var0_2.y + var1_2.height / 2
end

function var0_0.SetRoleActionByState(arg0_3, arg1_3)
	if arg1_3 == nil then
		arg1_3 = arg0_3:GetRunState()
	end

	if arg1_3 == CrossRoadGameConst.SHIP_STATE.stop then
		arg0_3:SetAction(CrossRoadGameConst.SHIP_STATE_ACTION.normal, 0)
	elseif arg1_3 == CrossRoadGameConst.SHIP_STATE.walk then
		arg0_3:SetAction(CrossRoadGameConst.SHIP_STATE_ACTION.walk, 0)
	elseif arg1_3 == CrossRoadGameConst.SHIP_STATE.crash then
		arg0_3:SetAction(CrossRoadGameConst.SHIP_STATE_ACTION.crash, 0)
	end
end

function var0_0.RandomAngryTime(arg0_4)
	arg0_4.angryTime = math.random(CrossRoadGameConst.CHILD_ANGER_TIME[1], CrossRoadGameConst.CHILD_ANGER_TIME[2])
end

function var0_0.CanAngryStart(arg0_5, arg1_5)
	if arg0_5.id ~= arg0_5.fa or arg0_5.runState ~= CrossRoadGameConst.SHIP_STATE.stop then
		arg0_5:SetAngryActive(false)

		arg0_5.startAngryTime = nil

		return false
	end

	if arg0_5.startAngryTime ~= nil then
		return true
	end

	if arg1_5 > arg0_5.lastSelectTime + CrossRoadGameConst.CAN_ANGRY_TIME then
		if arg1_5 > arg0_5.lastAngryRollTime + CrossRoadGameConst.ONCE_ANGRY_TIME then
			if arg0_5:RollAngryState() then
				arg0_5.startAngryTime = arg1_5

				arg0_5:SetAngryActive(true)
			else
				arg0_5.lastAngryRollTime = arg1_5
			end
		end

		return true
	else
		arg0_5.startAngryTime = nil
	end

	return false
end

function var0_0.CanAngryMove(arg0_6, arg1_6)
	if arg0_6.startAngryTime == nil then
		return
	end

	if arg1_6 > arg0_6.startAngryTime + arg0_6.angryTime then
		return true
	end
end

function var0_0.RollAngryState(arg0_7)
	return math.random(1, 100) < CrossRoadGameConst.ANGRY_PERCENT
end

function var0_0.SetSelectTime(arg0_8, arg1_8)
	arg0_8.lastSelectTime = arg1_8
	arg0_8.startAngryTime = nil
end

function var0_0.SetAction(arg0_9, arg1_9, arg2_9)
	if arg0_9.playingAction == arg1_9 then
		return
	end

	arg0_9.playingAction = arg1_9

	arg0_9.spineAnimUI:SetAction(arg1_9, arg2_9)
end

function var0_0.SetActionCallBack(arg0_10, arg1_10)
	arg0_10._spineAnimUI:SetActionCallBack(arg1_10)
end

function var0_0.setActionNormal(arg0_11)
	arg0_11:SetAction("normal", 0)
end

function var0_0.SetActive(arg0_12, arg1_12)
	setActive(arg0_12._tf, arg1_12)
end

function var0_0.SetAngryActive(arg0_13, arg1_13)
	if arg1_13 then
		arg0_13.angryAni:Play("anim_CrossRoadGameUI_pac_angry")
	end

	setActive(arg0_13.angryTF, arg1_13)
end

function var0_0.SetSelectActive(arg0_14, arg1_14)
	if arg1_14 then
		arg0_14.selectAni:Play("anim_CrossRoadGameUI_pac_select")
	end

	setActive(arg0_14.selectTF, arg1_14)
end

function var0_0.SetParent(arg0_15, arg1_15)
	setParent(arg0_15._tf, arg1_15, false)
end

function var0_0.SetScale(arg0_16, arg1_16)
	arg0_16._tf.localScale = arg1_16
end

function var0_0.SetPosition(arg0_17, arg1_17)
	arg0_17._tf.anchoredPosition = arg1_17
end

function var0_0.GetPosition(arg0_18)
	return arg0_18._tf.anchoredPosition
end

function var0_0.GetHW(arg0_19)
	return arg0_19._tf.rect.width, arg0_19._tf.rect.height
end

function var0_0.SetTarget(arg0_20, arg1_20)
	arg0_20.target = arg1_20
end

function var0_0.GetTarget(arg0_21)
	return arg0_21.target
end

function var0_0.GetDirect(arg0_22)
	return arg0_22.direct
end

function var0_0.SetSpeed(arg0_23, arg1_23)
	arg0_23.speed = arg1_23
end

function var0_0.GetSpeed(arg0_24)
	return arg0_24.speed
end

function var0_0.SetRunState(arg0_25, arg1_25)
	arg0_25.runState = arg1_25
end

function var0_0.GetRunState(arg0_26)
	return arg0_26.runState
end

function var0_0.SetStartTime(arg0_27, arg1_27)
	arg0_27.startTime = arg1_27
end

function var0_0.GetStartTime(arg0_28)
	return arg0_28.startTime
end

function var0_0.GetFatherID(arg0_29)
	return arg0_29.fa
end

function var0_0.SetFatherID(arg0_30, arg1_30)
	arg0_30.fa = arg1_30
end

function var0_0.GetID(arg0_31)
	return arg0_31.id
end

function var0_0.SetID(arg0_32, arg1_32)
	arg0_32.id = arg1_32
end

function var0_0.GetTrack(arg0_33)
	return arg0_33.trackName
end

function var0_0.SetTrack(arg0_34, arg1_34)
	arg0_34.trackName = arg1_34
end

function var0_0.SetPlayerHaveSelect(arg0_35, arg1_35)
	arg0_35.playerHaveSelect = arg1_35
end

function var0_0.GetXuanWoRollTime(arg0_36)
	return arg0_36.lastXuanWoRollTime
end

function var0_0.SetXuanWRollTime(arg0_37, arg1_37)
	arg0_37.lastXuanWoRollTime = arg1_37
end

function var0_0.GetPlayerHaveSelect(arg0_38)
	return arg0_38.playerHaveSelect
end

function var0_0.Clear(arg0_39)
	arg0_39:SetParent(arg0_39._tpl)
	arg0_39._runningData:CrashDeadRole()
end

return var0_0
