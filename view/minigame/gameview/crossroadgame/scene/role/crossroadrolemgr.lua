local var0_0 = class("CrossRoadRoleMgr")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tpl = arg1_1
	arg0_1._runningData = arg2_1
	arg0_1._event = arg3_1
	arg0_1.roleList = {}
	arg0_1._roleState = CrossRoadGameConst.SHIP_STATE
	arg0_1.itemList = arg2_1:GetItemGoList()
	arg0_1.frontRoadList = arg2_1:GetRoadList(CrossRoadGameConst.FRONT_ROAD_NAME)

	local var0_1 = arg2_1:GetRoadTF(CrossRoadGameConst.FRONT_ROAD_NAME)

	arg0_1.frontRoadTF = var0_1:Find("content")
	arg0_1.comboGroupTF = var0_1:Find("comboGroup")
	arg0_1.roleFinishCntTF = var0_1:Find("role_finish")
	arg0_1.roleStartCntTF = var0_1:Find("role_start")
	arg0_1.allFinishTF = var0_1:Find("allFinish")
	arg0_1.roleFinishCnt = 0
	arg0_1.roleStartCnt = 14
	arg0_1.selectRoleId = -1
	arg0_1.joyData = nil
	arg0_1.lastSelectTime = 0
	arg0_1.time = 0
	arg0_1.comboTime = 0
	arg0_1.comboCnt = 0
	arg0_1.needwalkTime = 0
	arg0_1.lastComboTF = nil
	arg0_1.lastFinishShowTime = CrossRoadGameConst.GAME_TIME
end

function var0_0.Prepare(arg0_2)
	local var0_2 = arg0_2._runningData:GetAllShipTpl()

	for iter0_2 = 1, #var0_2 do
		local var1_2 = var0_2[iter0_2]
		local var2_2 = CrossRoadRole.New(var1_2, iter0_2, arg0_2._tpl, arg0_2._runningData)

		table.insert(arg0_2.roleList, var2_2)
	end

	arg0_2.joyData = arg0_2._runningData:GetJoyData()
	arg0_2.lastSelectTime = 0

	arg0_2._runningData:RefreshRound()
	arg0_2:ReStatrGroup()

	arg0_2.addScoreTF = arg0_2.allFinishTF:Find("addScore")

	setText(arg0_2.addScoreTF, "+" .. CrossRoadGameHelper.GetAddNum(CrossRoadGameConst.SCORE_GROUP))
	setActive(arg0_2.allFinishTF, false)

	local var3_2, var4_2 = arg0_2.roleList[1]:GetHW()

	arg0_2.needwalkTime = var3_2 / arg0_2.roleList[1]:GetSpeed()
	arg0_2.finishAnimator = GetComponent(arg0_2.allFinishTF, typeof(Animator))
	arg0_2.finishDft = GetOrAddComponent(arg0_2.allFinishTF, typeof(DftAniEvent))

	arg0_2.finishDft:SetStartEvent(function()
		setActive(arg0_2.addScoreTF, true)
		arg0_2.finishAnimator:Play("anim_CrossRoadGameUI_pac_addScore")
	end)
	arg0_2.finishDft:SetEndEvent(function()
		if arg0_2.finishAnimator then
			arg0_2.finishAnimator:Rebind()
			arg0_2.finishAnimator:Update(0)
		end

		setActive(arg0_2.allFinishTF, false)
	end)
end

function var0_0.Step(arg0_5, arg1_5)
	arg0_5.time = arg0_5.time + arg1_5

	arg0_5:UpdateSelect()

	arg0_5.itemList = arg0_5._runningData:GetItemGoList()
	arg0_5.joyData = arg0_5._runningData:GetJoyData()

	for iter0_5, iter1_5 in ipairs(arg0_5.roleList) do
		if iter1_5:GetRunState() == arg0_5._roleState.crash then
			iter1_5:SetRoleActionByState(arg0_5._roleState.crash)
		else
			if iter0_5 == arg0_5.selectRoleId then
				arg0_5:updateSelectRole(iter1_5)
			end

			if iter1_5:CanAngryStart(arg0_5.time) and iter1_5:CanAngryMove(arg0_5.time) then
				iter1_5:SetRunState(arg0_5._roleState.walk)
				iter1_5:SetAngryActive(false)
			end

			local var0_5, var1_5 = arg0_5:CheckCanMoveRole(iter1_5)

			if var0_5 then
				if iter1_5:GetID() == iter1_5:GetFatherID() then
					arg0_5._runningData:TryUpdateUnion(iter1_5)
				end

				arg0_5:UpdateRoleMove(iter1_5, arg1_5)
			else
				if var1_5 then
					arg0_5._runningData:InRoleUnion(iter1_5, arg0_5.roleList[var1_5])

					if iter1_5:GetTrack() ~= CrossRoadGameConst.BACK_ROAD_NAME then
						iter1_5:SetRunState(arg0_5._roleState.stop)
					end
				end

				iter1_5:setActionNormal()
			end
		end
	end

	if not arg0_5:CanShowCombo() then
		arg0_5:ShowCombo(0, 0)
	end

	if arg0_5._runningData:CanRefreshRound() then
		arg0_5._runningData:RefreshRound()

		local var2_5 = arg0_5._runningData:GetRoundCnt()

		arg0_5._event(CrossRoadGameConst.NEW_ROUND, var2_5)

		if var2_5 >= 0 then
			arg0_5.lastFinishShowTime = arg0_5.time

			setActive(arg0_5.allFinishTF, true)
			setActive(arg0_5.addScoreTF, false)
			arg0_5.finishAnimator:Play("anim_CrossRoadGameUI_pac_allFinish_in")
			arg0_5._event(CrossRoadGameConst.GET_SCORE, {
				CrossRoadGameConst.SCORE_GROUP
			})
		end

		arg0_5:ReStatrGroup()
	end

	if arg0_5.lastFinishShowTime + CrossRoadGameConst.SHOW_GROUP_TIME < arg0_5.time then
		arg0_5.lastFinishShowTime = arg0_5.time + CrossRoadGameConst.GAME_TIME

		arg0_5.finishAnimator:Play("anim_CrossRoadGameUI_pac_allFinish_out")
	end
end

function var0_0.UpdateSelect(arg0_6)
	local var0_6 = 999999999
	local var1_6 = -1
	local var2_6 = arg0_6._runningData:GetPlayerPosition().x

	for iter0_6, iter1_6 in ipairs(arg0_6.roleList) do
		if iter1_6:GetRunState() == arg0_6._roleState.crash then
			-- block empty
		else
			local var3_6 = arg0_6._runningData:FindRoleFa(iter1_6)
			local var4_6 = arg0_6.roleList[var3_6]:GetPosition().x

			if var0_6 > math.abs(var2_6 - var4_6) then
				var0_6 = math.abs(var2_6 - var4_6)
				var1_6 = var3_6
			end
		end
	end

	if var0_6 > CrossRoadGameConst.PLAYER_DISTANCE then
		var1_6 = -1
	end

	if var1_6 ~= -1 then
		arg0_6.roleList[var1_6]:SetSelectTime(arg0_6.time)
		arg0_6.roleList[var1_6]:SetAngryActive(false)
	end

	if arg0_6.selectRoleId ~= var1_6 and arg0_6.lastSelectTime + CrossRoadGameConst.PLAYER_SELECT_TIME < arg0_6.time then
		if arg0_6.selectRoleId ~= -1 then
			arg0_6.roleList[arg0_6.selectRoleId]:SetSelectActive(false)
		end

		arg0_6.lastSelectTime = arg0_6.time
		arg0_6.selectRoleId = var1_6
	end
end

function var0_0.updateSelectRole(arg0_7, arg1_7)
	arg1_7:SetSelectActive(true)

	local var0_7 = arg1_7:GetRunState()

	if not arg0_7.joyData.stop == arg0_7.joyData.go then
		var0_7 = arg0_7.joyData.stop and arg0_7._roleState.stop or arg0_7._roleState.walk

		arg1_7:SetPlayerHaveSelect(true)
	end

	arg1_7:SetRunState(var0_7)
end

function var0_0.CheckCanMoveRole(arg0_8, arg1_8)
	if arg1_8:GetStartTime() > arg0_8.time then
		return false, nil
	end

	if arg1_8:GetTrack() == CrossRoadGameConst.FRONT_ROAD_NAME then
		return true, nil
	end

	if arg1_8:GetRunState() == arg0_8._roleState.stop then
		return false, nil
	end

	return arg0_8:CheckFrontCanMove(arg1_8)
end

function var0_0.CheckFrontCanMove(arg0_9, arg1_9)
	for iter0_9 = arg1_9:GetID() - 1, 1, -1 do
		if arg0_9.roleList[iter0_9]:GetRunState() == arg0_9._roleState.crash then
			-- block empty
		elseif CrossRoadGameHelper:CheckTwoRoleIsCrash(arg1_9, arg0_9.roleList[iter0_9]) then
			return false, iter0_9
		else
			break
		end
	end

	return true, nil
end

function var0_0.UpdateRoleMove(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg1_10:GetPosition()
	local var1_10 = arg1_10:GetSpeed()
	local var2_10 = arg1_10:GetTarget()
	local var3_10 = arg1_10:GetTrack()
	local var4_10 = arg1_10:GetDirect()

	if var3_10 == CrossRoadGameConst.SCENE_ROAD_NAME then
		for iter0_10 = 1, 6 do
			local var5_10 = arg0_10.itemList[iter0_10]

			if var5_10 ~= nil and CrossRoadGameHelper:CheckRoleInItem(arg1_10, var5_10) then
				if var5_10.id == CrossRoadGameConst.BING_MIAN then
					var1_10 = CrossRoadGameConst.CHILD_RUSH_SPEED
				elseif arg0_10:xuanWoStop(arg1_10) then
					arg1_10:SetRunState(arg0_10._roleState.stop)
					arg1_10:setActionNormal()

					return
				end
			end
		end
	end

	local var6_10 = {
		var1_10 * var4_10[1] * arg2_10,
		var1_10 * var4_10[2] * arg2_10
	}
	local var7_10 = Vector2(var0_10.x + var6_10[1], var0_10.y + var6_10[2])

	arg1_10:SetAction(CrossRoadGameConst.SHIP_STATE_ACTION.walk, 0)

	if CrossRoadGameHelper:isMiddle(var7_10.x, var2_10.x, var0_10.x) or var0_10.x < var2_10.x then
		if var3_10 == CrossRoadGameConst.BACK_ROAD_NAME then
			arg0_10:SetRoleSceneTaget(arg1_10)
		elseif var3_10 == CrossRoadGameConst.SCENE_ROAD_NAME then
			arg0_10:SetRoleEndTarget(arg1_10)
		elseif var3_10 == CrossRoadGameConst.FRONT_ROAD_NAME then
			arg0_10:SetRoleOver(arg1_10)

			return
		end
	end

	arg1_10:SetPosition(var7_10)
end

function var0_0.SetRoleSceneTaget(arg0_11, arg1_11)
	if arg1_11:GetPlayerHaveSelect() == false then
		arg1_11:SetRunState(arg0_11._roleState.stop)
		arg1_11:SetRoleActionByState()
	end

	arg0_11.roleStartCnt = arg0_11.roleStartCnt - 1

	arg0_11:SetImageNumber(arg0_11.roleStartCntTF, arg0_11.roleStartCnt)
	arg1_11:SetTrack(CrossRoadGameConst.SCENE_ROAD_NAME)
	arg1_11:SetTarget(arg0_11.frontRoadList.lightTF.anchoredPosition)
end

function var0_0.SetRoleEndTarget(arg0_12, arg1_12)
	if arg0_12:CanShowCombo() then
		arg0_12.comboCnt = arg0_12.comboCnt + 1
	else
		arg0_12.comboCnt = 0
	end

	arg0_12.comboTime = arg0_12.time

	local var0_12 = CrossRoadGameConst.SCORE_ONE * arg0_12.comboCnt + CrossRoadGameConst.SCORE_BASE

	arg0_12.roleFinishCnt = arg0_12.roleFinishCnt + 1

	arg0_12:SetImageNumber(arg0_12.roleFinishCntTF, arg0_12.roleFinishCnt)
	arg0_12:ShowCombo(arg0_12.comboCnt, CrossRoadGameConst.SCORE_ONE * arg0_12.comboCnt)
	arg0_12._event(CrossRoadGameConst.GET_SCORE, {
		var0_12
	}, nil)
	arg0_12._event(CrossRoadGameConst.ADD_ROLE, nil, nil)
	arg1_12:SetTrack(CrossRoadGameConst.FRONT_ROAD_NAME)
	arg1_12:SetTarget(arg0_12.frontRoadList.endTF.anchoredPosition)
end

function var0_0.CanShowCombo(arg0_13)
	return arg0_13.comboTime + CrossRoadGameConst.COMOBO_TIME + arg0_13.needwalkTime > arg0_13.time
end

function var0_0.SetRoleOver(arg0_14, arg1_14)
	arg1_14:SetActive(false)
	arg1_14:SetRunState(arg0_14._roleState.crash)
	arg1_14:Clear()
end

function var0_0.ReStatrGroup(arg0_15)
	arg0_15.roleList = CrossRoadGameHelper:GetRandomList(arg0_15.roleList)

	for iter0_15, iter1_15 in ipairs(arg0_15.roleList) do
		iter1_15:SetID(iter0_15)
		iter1_15:SetFatherID(iter0_15)
		iter1_15:SetScale(Vector3(-1, 1, 1))
		iter1_15:SetActive(true)
		iter1_15:SetParent(arg0_15.frontRoadTF)
		iter1_15:SetPlayerHaveSelect(false)
		iter1_15:SetPosition(arg0_15.frontRoadList.startTF.anchoredPosition)
		iter1_15:SetStartTime(arg0_15.time + CrossRoadGameConst.WALKER_GO_AGIN_TIME * (iter0_15 - 1))
		iter1_15:SetTarget(arg0_15.frontRoadList.midTF.anchoredPosition)
		iter1_15:SetTrack(CrossRoadGameConst.BACK_ROAD_NAME)
		iter1_15:SetRunState(arg0_15._roleState.walk)
		iter1_15:RandomAngryTime()
	end

	arg0_15.roleStartCnt = #arg0_15.roleList
	arg0_15.roleFinishCnt = 0

	arg0_15:RefreshRoleCountNum()
	arg0_15._runningData:SetRoleList(arg0_15.roleList)
end

function var0_0.ShowCombo(arg0_16, arg1_16, arg2_16)
	local var0_16

	if arg0_16.lastComboTF then
		setActive(arg0_16.lastComboTF, false)
	end

	for iter0_16 = 1, #CrossRoadGameConst.ROLE_COMOBO_LV do
		if arg1_16 >= CrossRoadGameConst.ROLE_COMOBO_LV[iter0_16] then
			var0_16 = "combo" .. tostring(iter0_16)
		end
	end

	if var0_16 then
		arg0_16.lastComboTF = arg0_16.comboGroupTF:Find(var0_16)

		arg0_16.lastComboTF:GetComponent(typeof(Animation)):Play("anim_CrossRoadGameUI_pac_combo")
		setText(arg0_16.lastComboTF:Find("combocnt"), "X " .. arg1_16)
		setText(arg0_16.lastComboTF:Find("addScore"), "+" .. arg2_16)
		setActive(arg0_16.lastComboTF, true)
	end
end

function var0_0.xuanWoStop(arg0_17, arg1_17)
	if arg1_17:GetXuanWoRollTime() + CrossRoadGameConst.XUANWO_LIFE_TIME > arg0_17.time then
		return false
	end

	arg1_17:SetXuanWRollTime(arg0_17.time)

	if math.random(1, 100) > CrossRoadGameConst.XUANWO_STOP_PERCENT then
		return false
	end

	return true
end

function var0_0.SetImageNumber(arg0_18, arg1_18, arg2_18)
	local var0_18 = math.floor(arg2_18 / 10)
	local var1_18 = (var0_18 + 1) % 2

	setActive(arg1_18:Find("wei2/0_" .. var0_18), true)
	setActive(arg1_18:Find("wei2/0_" .. var1_18), false)

	local var2_18 = arg2_18 % 10

	for iter0_18 = 0, 9 do
		setActive(arg1_18:Find("wei1/0_" .. iter0_18), false)
	end

	setActive(arg1_18:Find("wei1/0_" .. var2_18), true)
end

function var0_0.RefreshRoleCountNum(arg0_19)
	arg0_19:SetImageNumber(arg0_19.roleFinishCntTF, arg0_19.roleFinishCnt)
	arg0_19:SetImageNumber(arg0_19.roleStartCntTF, arg0_19.roleStartCnt)
end

function var0_0.Clear(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.roleList) do
		iter1_20:Clear()
	end

	arg0_20.roleList = {}
end

return var0_0
