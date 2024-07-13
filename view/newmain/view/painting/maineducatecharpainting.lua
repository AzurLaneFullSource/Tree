local var0_0 = class("MainEducateCharPainting", import(".MainMeshImagePainting"))
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	var1_0 = pg.AssistantInfo
end

function var0_0.OnLoad(arg0_2, arg1_2)
	seriesAsync({
		function(arg0_3)
			var0_0.super.OnLoad(arg0_2, arg0_3)
		end
	}, function()
		arg0_2:InitTellTimeService()
		arg1_2()
	end)
end

function var0_0.OnFirstTimeTriggerEvent(arg0_5)
	local var0_5 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_5, var2_5, var3_5 = ChineseCalendar.GetCurrYearMonthDay(var0_5)

	local function var4_5(arg0_6)
		arg0_5:DisplayWord(arg0_6)
		getProxy(SettingsProxy):RecordTipDay(var1_5, var2_5, var3_5)
	end

	local function var5_5()
		return getProxy(SettingsProxy):IsTipDay(var1_5, var2_5, var3_5)
	end

	if ChineseCalendar.IsNewYear(var1_5, var2_5, var3_5) and not var5_5() then
		var4_5(EducateCharWordHelper.WORD_KEY_NEWYEAR)
	elseif ChineseCalendar.IsLunarNewYear(var1_5, var2_5, var3_5) and not var5_5() then
		var4_5(EducateCharWordHelper.WORD_KEY_LUNARNEWYEAR)
	elseif ChineseCalendar.IsValentineDay(var1_5, var2_5, var3_5) and not var5_5() then
		var4_5(EducateCharWordHelper.WORD_KEY_VALENTINE)
	elseif ChineseCalendar.IsMidAutumnFestival(var1_5, var2_5, var3_5) and not var5_5() then
		var4_5(EducateCharWordHelper.WORD_KEY_MIDAUTUMNFESTIVAL)
	elseif ChineseCalendar.AllHallowsDay(var1_5, var2_5, var3_5) and not var5_5() then
		var4_5(EducateCharWordHelper.WORD_KEY_ALLHALLOWSDAY)
	elseif ChineseCalendar.IsChristmas(var1_5, var2_5, var3_5) and not var5_5() then
		var4_5(EducateCharWordHelper.WORD_KEY_CHRISTMAS)
	elseif not getProxy(PlayerProxy):getFlag("tb_activity") and arg0_5:ExistImportantActivity() then
		getProxy(PlayerProxy):setFlag("tb_activity", true)
		arg0_5:DisplayWord(EducateCharWordHelper.WORD_KEY_ACT)
	elseif getProxy(PlayerProxy):getFlag("change_tb") then
		getProxy(PlayerProxy):setFlag("change_tb", nil)
		arg0_5:DisplayWord(EducateCharWordHelper.WORD_KEY_CHANGE_TB)
	else
		var0_0.super.OnFirstTimeTriggerEvent(arg0_5)
	end
end

function var0_0.ExistImportantActivity(arg0_8)
	local var0_8 = pg.gameset.secretary_special_ship_event_type.description
	local var1_8 = getProxy(ActivityProxy)

	return _.any(var0_8, function(arg0_9)
		local var0_9 = var1_8:getActivityByType(arg0_9)

		return var0_9 and not var0_9:isEnd()
	end)
end

function var0_0.InitTellTimeService(arg0_10)
	arg0_10:RemoveTellTimeTimer()

	local var0_10 = GetNextHour(1)
	local var1_10 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_10 = var0_10 - var1_10

	if var2_10 >= 86400 then
		arg0_10:TriggerTellTime(var1_10)
	else
		arg0_10:AddTellTimeTimer(var0_10, var2_10)
	end
end

function var0_0.AddTellTimeTimer(arg0_11, arg1_11, arg2_11)
	arg0_11.tellTimeTimer = Timer.New(function()
		if arg0_11.chatting then
			arg0_11.waitForCharEnd = arg1_11

			return
		end

		arg0_11:DisplayTellTimeWord(arg1_11)
		arg0_11:RemoveTellTimeTimer()
	end, arg2_11, 1)

	arg0_11.tellTimeTimer:Start()
end

function var0_0.RemoveTellTimeTimer(arg0_13)
	if arg0_13.tellTimeTimer then
		arg0_13.tellTimeTimer:Stop()

		arg0_13.tellTimeTimer = nil
	end
end

function var0_0.DisplayTellTimeWord(arg0_14, arg1_14)
	local var0_14 = pg.TimeMgr.GetInstance():STimeDescC(arg1_14, "%Y:%m:%d:%H:%M:%S")
	local var1_14 = string.split(var0_14, ":")
	local var2_14 = tonumber(var1_14[4])

	arg0_14:DisplayWord(EducateCharWordHelper.WORD_KEY_TELL_TIME .. var2_14)
end

function var0_0.TriggerPersonalTask(arg0_15)
	if arg0_15.isFoldState then
		return
	end

	arg0_15:TriggerInterActionTask()
end

function var0_0.OnLongPress(arg0_16)
	return
end

function var0_0.OnDisplayWorld(arg0_17, arg1_17)
	local var0_17 = EducateCharWordHelper.GetExpression(arg0_17.ship.educateCharId, arg1_17)

	if var0_17 and var0_17 ~= "" then
		ShipExpressionHelper.UpdateExpression(findTF(arg0_17.container, "fitter"):GetChild(0), arg0_17.paintingName, var0_17)
	else
		ShipExpressionHelper.UpdateExpression(findTF(arg0_17.container, "fitter"):GetChild(0), arg0_17.paintingName, "")
	end
end

function var0_0.OnDisplayWordEnd(arg0_18)
	arg0_18:RemoveDelayTellTimeTimer()

	if arg0_18.waitForCharEnd then
		local var0_18 = math.random(1, 3)

		arg0_18.delayTellTimeTimer = Timer.New(function()
			arg0_18:DisplayTellTimeWord(arg0_18.waitForCharEnd)
			arg0_18:RemoveDelayTellTimeTimer()
			var0_0.super.OnDisplayWordEnd(arg0_18)
		end, var0_18, 1)

		arg0_18.delayTellTimeTimer:Start()

		arg0_18.waitForCharEnd = nil
	else
		var0_0.super.OnDisplayWordEnd(arg0_18)
	end
end

function var0_0.RemoveDelayTellTimeTimer(arg0_20)
	if arg0_20.delayTellTimeTimer then
		arg0_20.delayTellTimeTimer:Stop()

		arg0_20.delayTellTimeTimer = nil
	end
end

function var0_0.GetWordAndCv(arg0_21, arg1_21, arg2_21)
	local var0_21, var1_21, var2_21 = EducateCharWordHelper.GetWordAndCV(arg1_21.educateCharId, arg2_21)

	return var0_21, var1_21, var2_21
end

function var0_0.PlayCV(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	local var0_22 = EducateCharWordHelper.RawGetCVKey(arg0_22.ship.educateCharId)

	if not var0_22 or var0_22 == "" then
		arg4_22()

		return
	end

	local var1_22 = var0_22

	arg0_22.cvLoader:Load(var1_22, arg3_22, 0, arg4_22)
end

function var0_0.CollectIdleEvents(arg0_23, arg1_23)
	local var0_23 = {}

	if getProxy(EventProxy):hasFinishState() and arg1_23 ~= "event_complete" then
		table.insert(var0_23, "event_complete")
	else
		if getProxy(TaskProxy):getCanReceiveCount() > 0 and arg1_23 ~= "mission_complete" then
			table.insert(var0_23, "mission_complete")
		end

		if getProxy(MailProxy):GetUnreadCount() > 0 and arg1_23 ~= "mail" then
			table.insert(var0_23, "mail")
		end

		if #var0_23 == 0 then
			var0_23 = arg0_23:FilterExistEvents(var1_0.IdleEvents)

			if getProxy(TaskProxy):getNotFinishCount() and getProxy(TaskProxy):getNotFinishCount() > 0 and arg1_23 ~= "mission" then
				table.insert(var0_23, "mission")
			end
		end
	end

	return var0_23
end

function var0_0.FilterExistEvents(arg0_24, arg1_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg1_24) do
		local var1_24 = var1_0.assistantEvents[iter1_24]

		if var1_24 and var1_24.dialog and EducateCharWordHelper.ExistWord(arg0_24.ship.educateCharId, var1_24.dialog) then
			table.insert(var0_24, iter1_24)
		end
	end

	return var0_24
end

function var0_0.CollectTouchEvents(arg0_25)
	return (arg0_25:FilterExistEvents(var1_0.PaintingTouchEvents))
end

function var0_0.EnableOrDisableMove(arg0_26, arg1_26)
	var0_0.super.EnableOrDisableMove(arg0_26, arg1_26)

	if arg1_26 then
		arg0_26.waitForCharEnd = nil

		arg0_26:RemoveTellTimeTimer()
		arg0_26:RemoveDelayTellTimeTimer()
	else
		arg0_26:InitTellTimeService()
	end
end

function var0_0.OnPuase(arg0_27)
	var0_0.super.OnPuase(arg0_27)

	arg0_27.waitForCharEnd = nil

	arg0_27:RemoveTellTimeTimer()
	arg0_27:RemoveDelayTellTimeTimer()
end

function var0_0.OnResume(arg0_28)
	var0_0.super.OnResume(arg0_28)
	arg0_28:RemoveTellTimeTimer()
	arg0_28:RemoveDelayTellTimeTimer()
	arg0_28:InitTellTimeService()
end

function var0_0.OnUnload(arg0_29)
	var0_0.super.OnUnload(arg0_29)

	arg0_29.waitForCharEnd = nil

	arg0_29:RemoveTellTimeTimer()
	arg0_29:RemoveDelayTellTimeTimer()
end

function var0_0.Dispose(arg0_30)
	var0_0.super.Dispose(arg0_30)

	arg0_30.waitForCharEnd = nil

	arg0_30:RemoveTellTimeTimer()
	arg0_30:RemoveDelayTellTimeTimer()
end

return var0_0
