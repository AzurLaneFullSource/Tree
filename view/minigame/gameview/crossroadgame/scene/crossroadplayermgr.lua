local var0_0 = class("CrossRoadPlayerMgr")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tpl = arg1_1
	arg0_1._runningData = arg2_1
	arg0_1._event = arg3_1
	arg0_1.playingAction = "normal"
	arg0_1._tf = arg0_1._tpl:Find("zhihui_tpl")
	arg0_1.spineAnimUI = GetComponent(findTF(arg0_1._tf, "spine"), "SpineAnimUI")
	arg0_1.frontRoadTF = arg2_1:GetRoadTF(CrossRoadGameConst.FRONT_ROAD_NAME):Find("content")
	arg0_1.frontRoadList = arg2_1:GetRoadList(CrossRoadGameConst.FRONT_ROAD_NAME)
	arg0_1.joyData = {
		go = false,
		right = false,
		left = false,
		stop = false
	}
	arg0_1.state = CrossRoadGameConst.PLAYER_STATE.normal
	arg0_1.roleList = arg2_1:GetRoleList()
	arg0_1.speed = CrossRoadGameConst.PLAYER_SPEED
	arg0_1.carshChangePos = true
	arg0_1.hongCha = arg0_1._runningData:GetHongChaTpl()

	arg0_1:setActionNormal()

	arg0_1.itemList = arg0_1._runningData:GetItemGoList()
end

function var0_0.Prepare(arg0_2)
	local var0_2 = arg0_2.frontRoadList.lightTF.anchoredPosition

	setParent(arg0_2._tf, arg0_2.frontRoadTF, false)
	arg0_2:SetPosition(var0_2)
	arg0_2._runningData:SetPlayerPosition(arg0_2:GetPosition())
	arg0_2.spineAnimUI:SetActionCallBack(function(arg0_3)
		if arg0_3 == "finish" and arg0_2.state == CrossRoadGameConst.PLAYER_STATE.crash then
			arg0_2:SetAction("recover2", 0)

			arg0_2.state = CrossRoadGameConst.PLAYER_STATE.recover

			return
		elseif arg0_3 == "action" and arg0_2.state == CrossRoadGameConst.PLAYER_STATE.recover then
			arg0_2.state = CrossRoadGameConst.PLAYER_STATE.normal
			arg0_2.carshChangePos = true

			arg0_2:setActionNormal()

			return
		end
	end)
end

function var0_0.Step(arg0_4, arg1_4)
	arg0_4.joyData = arg0_4._runningData:GetJoyData()
	arg0_4.roleList = arg0_4._runningData:GetRoleList()

	arg0_4:UpdateAction()
	arg0_4:UpdateMove(arg1_4)
	arg0_4:CheckAndClearBin()
end

function var0_0.UpdateAction(arg0_5)
	if arg0_5:GetCrashState() then
		return
	end

	local var0_5 = arg0_5.joyData
	local var1_5
	local var2_5
	local var3_5

	if not var0_5.left == var0_5.right then
		var2_5 = CrossRoadGameConst.PLAYER_STATE.walk
	end

	if not var0_5.stop == var0_5.go then
		var3_5 = var0_5.stop and CrossRoadGameConst.PLAYER_STATE.stop or CrossRoadGameConst.PLAYER_STATE.sign
	end

	if var2_5 == CrossRoadGameConst.PLAYER_STATE.walk then
		if var3_5 then
			var1_5 = var0_5.stop and CrossRoadGameConst.PLAYER_STATE.stop_walk or CrossRoadGameConst.PLAYER_STATE.sign_walk
		else
			var1_5 = var2_5
		end
	else
		var1_5 = var3_5 or CrossRoadGameConst.PLAYER_STATE.normal
	end

	arg0_5.state = var1_5

	arg0_5:SetAction(arg0_5.state, 0)
end

function var0_0.UpdateMove(arg0_6, arg1_6)
	local var0_6 = arg0_6.joyData
	local var1_6 = {
		0,
		0
	}

	if arg0_6:GetCrashState() then
		if arg0_6.carshChangePos then
			local var2_6 = arg0_6._runningData:GetPlayerCrashDir()
			local var3_6 = arg0_6._runningData:GetPlayerCarshSize()

			arg0_6:SetPlayerCarshPos(var2_6, var3_6)
		end

		return
	end

	if not var0_6.left == var0_6.right then
		local var4_6 = var0_6.left and {
			-1,
			0
		} or {
			1,
			0
		}

		arg0_6:SetFaceDir(var4_6[1])
		arg0_6:SetPlayerPositionByDir(var4_6, arg1_6)
	end
end

function var0_0.SetPlayerPositionByDir(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7:GetPosition()
	local var1_7 = arg0_7.speed * arg1_7[1] * arg2_7
	local var2_7 = Vector2(var0_7.x + var1_7, var0_7.y)
	local var3_7 = arg0_7._runningData:GetSceneWidth()

	if isActive(arg0_7.hongCha) and CrossRoadGameHelper:CheckPlayerInItem(arg0_7._tf, arg0_7.hongCha) then
		arg0_7._event(CrossRoadGameConst.GET_HONGCHA)
		setActive(arg0_7.hongCha, false)
	end

	if var2_7.x > -var3_7 / 2 and var2_7.x < var3_7 / 2 then
		arg0_7:SetPosition(var2_7)
	end

	arg0_7._runningData:SetPlayerPosition(arg0_7:GetPosition())
end

function var0_0.SetPlayerCarshPos(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8:GetPosition()

	arg0_8:SetFaceDir(-arg1_8[1])

	local var1_8 = Vector2(var0_8.x + arg2_8 * arg1_8[1], var0_8.y)
	local var2_8 = arg0_8._runningData:GetSceneWidth()

	if var1_8.x > -var2_8 / 2 and var1_8.x < var2_8 / 2 then
		arg0_8:SetPosition(var1_8)
	end

	arg0_8.carshChangePos = false

	arg0_8._runningData:SetPlayerPosition(arg0_8:GetPosition())
end

function var0_0.SetFaceDir(arg0_9, arg1_9)
	if arg1_9 == 0 then
		return
	end

	local var0_9 = arg0_9._tf.localScale

	var0_9.x = math.abs(var0_9.x) * arg1_9
	arg0_9._tf.localScale = var0_9
end

function var0_0.GetCrashState(arg0_10)
	return arg0_10.state == CrossRoadGameConst.PLAYER_STATE.crash or arg0_10.state == CrossRoadGameConst.PLAYER_STATE.recover
end

function var0_0.PlayZhihuiHit(arg0_11)
	if arg0_11:GetCrashState() then
		return
	end

	arg0_11.state = CrossRoadGameConst.PLAYER_STATE.crash

	arg0_11:SetAction(CrossRoadGameConst.PLAYER_STATE.crash, 0)
end

function var0_0.CheckAndClearBin(arg0_12)
	arg0_12.itemList = arg0_12._runningData:GetItemGoList()

	for iter0_12 = 1, CrossRoadGameConst.GAME_TRACK_COUNT do
		if arg0_12.itemList[iter0_12] ~= nil and arg0_12.itemList[iter0_12].id == CrossRoadGameConst.BING_MIAN and CrossRoadGameHelper:CheckPlayerInItem(arg0_12._tf, arg0_12.itemList[iter0_12].go) then
			arg0_12._event(CrossRoadGameConst.DISPOSE_BIN, iter0_12)
		end
	end
end

function var0_0.SetAction(arg0_13, arg1_13, arg2_13)
	if arg0_13.playingAction == arg1_13 then
		return
	end

	arg0_13.playingAction = arg1_13

	arg0_13.spineAnimUI:SetAction(arg1_13, arg2_13)
end

function var0_0.setActionNormal(arg0_14)
	arg0_14:SetAction("normal", 0)
end

function var0_0.SetPosition(arg0_15, arg1_15)
	arg0_15._tf.anchoredPosition = arg1_15
end

function var0_0.GetPosition(arg0_16)
	return arg0_16._tf.anchoredPosition
end

function var0_0.Clear(arg0_17)
	arg0_17:setActionNormal()
	setParent(arg0_17._tf, arg0_17._tpl, false)

	if arg0_17.spineAnimUI then
		arg0_17.spineAnimUI:SetActionCallBack(nil)
	end
end

function var0_0.Dispose(arg0_18)
	return
end

return var0_0
