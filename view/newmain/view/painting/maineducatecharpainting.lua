local var0 = class("MainEducateCharPainting", import(".MainMeshImagePainting"))
local var1

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	var1 = pg.AssistantInfo
end

function var0.OnLoad(arg0, arg1)
	seriesAsync({
		function(arg0)
			var0.super.OnLoad(arg0, arg0)
		end
	}, function()
		arg0:InitTellTimeService()
		arg1()
	end)
end

function var0.OnFirstTimeTriggerEvent(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1, var2, var3 = ChineseCalendar.GetCurrYearMonthDay(var0)

	local function var4(arg0)
		arg0:DisplayWord(arg0)
		getProxy(SettingsProxy):RecordTipDay(var1, var2, var3)
	end

	local function var5()
		return getProxy(SettingsProxy):IsTipDay(var1, var2, var3)
	end

	if ChineseCalendar.IsNewYear(var1, var2, var3) and not var5() then
		var4(EducateCharWordHelper.WORD_KEY_NEWYEAR)
	elseif ChineseCalendar.IsLunarNewYear(var1, var2, var3) and not var5() then
		var4(EducateCharWordHelper.WORD_KEY_LUNARNEWYEAR)
	elseif ChineseCalendar.IsValentineDay(var1, var2, var3) and not var5() then
		var4(EducateCharWordHelper.WORD_KEY_VALENTINE)
	elseif ChineseCalendar.IsMidAutumnFestival(var1, var2, var3) and not var5() then
		var4(EducateCharWordHelper.WORD_KEY_MIDAUTUMNFESTIVAL)
	elseif ChineseCalendar.AllHallowsDay(var1, var2, var3) and not var5() then
		var4(EducateCharWordHelper.WORD_KEY_ALLHALLOWSDAY)
	elseif ChineseCalendar.IsChristmas(var1, var2, var3) and not var5() then
		var4(EducateCharWordHelper.WORD_KEY_CHRISTMAS)
	elseif not getProxy(PlayerProxy):getFlag("tb_activity") and arg0:ExistImportantActivity() then
		getProxy(PlayerProxy):setFlag("tb_activity", true)
		arg0:DisplayWord(EducateCharWordHelper.WORD_KEY_ACT)
	elseif getProxy(PlayerProxy):getFlag("change_tb") then
		getProxy(PlayerProxy):setFlag("change_tb", nil)
		arg0:DisplayWord(EducateCharWordHelper.WORD_KEY_CHANGE_TB)
	else
		var0.super.OnFirstTimeTriggerEvent(arg0)
	end
end

function var0.ExistImportantActivity(arg0)
	local var0 = pg.gameset.secretary_special_ship_event_type.description
	local var1 = getProxy(ActivityProxy)

	return _.any(var0, function(arg0)
		local var0 = var1:getActivityByType(arg0)

		return var0 and not var0:isEnd()
	end)
end

function var0.InitTellTimeService(arg0)
	arg0:RemoveTellTimeTimer()

	local var0 = GetNextHour(1)
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = var0 - var1

	if var2 >= 86400 then
		arg0:TriggerTellTime(var1)
	else
		arg0:AddTellTimeTimer(var0, var2)
	end
end

function var0.AddTellTimeTimer(arg0, arg1, arg2)
	arg0.tellTimeTimer = Timer.New(function()
		if arg0.chatting then
			arg0.waitForCharEnd = arg1

			return
		end

		arg0:DisplayTellTimeWord(arg1)
		arg0:RemoveTellTimeTimer()
	end, arg2, 1)

	arg0.tellTimeTimer:Start()
end

function var0.RemoveTellTimeTimer(arg0)
	if arg0.tellTimeTimer then
		arg0.tellTimeTimer:Stop()

		arg0.tellTimeTimer = nil
	end
end

function var0.DisplayTellTimeWord(arg0, arg1)
	local var0 = pg.TimeMgr.GetInstance():STimeDescC(arg1, "%Y:%m:%d:%H:%M:%S")
	local var1 = string.split(var0, ":")
	local var2 = tonumber(var1[4])

	arg0:DisplayWord(EducateCharWordHelper.WORD_KEY_TELL_TIME .. var2)
end

function var0.TriggerPersonalTask(arg0)
	if arg0.isFoldState then
		return
	end

	arg0:TriggerInterActionTask()
end

function var0.OnLongPress(arg0)
	return
end

function var0.OnDisplayWorld(arg0, arg1)
	local var0 = EducateCharWordHelper.GetExpression(arg0.ship.educateCharId, arg1)

	if var0 and var0 ~= "" then
		ShipExpressionHelper.UpdateExpression(findTF(arg0.container, "fitter"):GetChild(0), arg0.paintingName, var0)
	else
		ShipExpressionHelper.UpdateExpression(findTF(arg0.container, "fitter"):GetChild(0), arg0.paintingName, "")
	end
end

function var0.OnDisplayWordEnd(arg0)
	arg0:RemoveDelayTellTimeTimer()

	if arg0.waitForCharEnd then
		local var0 = math.random(1, 3)

		arg0.delayTellTimeTimer = Timer.New(function()
			arg0:DisplayTellTimeWord(arg0.waitForCharEnd)
			arg0:RemoveDelayTellTimeTimer()
			var0.super.OnDisplayWordEnd(arg0)
		end, var0, 1)

		arg0.delayTellTimeTimer:Start()

		arg0.waitForCharEnd = nil
	else
		var0.super.OnDisplayWordEnd(arg0)
	end
end

function var0.RemoveDelayTellTimeTimer(arg0)
	if arg0.delayTellTimeTimer then
		arg0.delayTellTimeTimer:Stop()

		arg0.delayTellTimeTimer = nil
	end
end

function var0.GetWordAndCv(arg0, arg1, arg2)
	local var0, var1, var2 = EducateCharWordHelper.GetWordAndCV(arg1.educateCharId, arg2)

	return var0, var1, var2
end

function var0.PlayCV(arg0, arg1, arg2, arg3, arg4)
	local var0 = EducateCharWordHelper.RawGetCVKey(arg0.ship.educateCharId)

	if not var0 or var0 == "" then
		arg4()

		return
	end

	local var1 = var0

	arg0.cvLoader:Load(var1, arg3, 0, arg4)
end

function var0.CollectIdleEvents(arg0, arg1)
	local var0 = {}

	if getProxy(EventProxy):hasFinishState() and arg1 ~= "event_complete" then
		table.insert(var0, "event_complete")
	else
		if getProxy(TaskProxy):getCanReceiveCount() > 0 and arg1 ~= "mission_complete" then
			table.insert(var0, "mission_complete")
		end

		if getProxy(MailProxy):GetUnreadCount() > 0 and arg1 ~= "mail" then
			table.insert(var0, "mail")
		end

		if #var0 == 0 then
			var0 = arg0:FilterExistEvents(var1.IdleEvents)

			if getProxy(TaskProxy):getNotFinishCount() and getProxy(TaskProxy):getNotFinishCount() > 0 and arg1 ~= "mission" then
				table.insert(var0, "mission")
			end
		end
	end

	return var0
end

function var0.FilterExistEvents(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg1) do
		local var1 = var1.assistantEvents[iter1]

		if var1 and var1.dialog and EducateCharWordHelper.ExistWord(arg0.ship.educateCharId, var1.dialog) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.CollectTouchEvents(arg0)
	return (arg0:FilterExistEvents(var1.PaintingTouchEvents))
end

function var0.EnableOrDisableMove(arg0, arg1)
	var0.super.EnableOrDisableMove(arg0, arg1)

	if arg1 then
		arg0.waitForCharEnd = nil

		arg0:RemoveTellTimeTimer()
		arg0:RemoveDelayTellTimeTimer()
	else
		arg0:InitTellTimeService()
	end
end

function var0.OnPuase(arg0)
	var0.super.OnPuase(arg0)

	arg0.waitForCharEnd = nil

	arg0:RemoveTellTimeTimer()
	arg0:RemoveDelayTellTimeTimer()
end

function var0.OnResume(arg0)
	var0.super.OnResume(arg0)
	arg0:RemoveTellTimeTimer()
	arg0:RemoveDelayTellTimeTimer()
	arg0:InitTellTimeService()
end

function var0.OnUnload(arg0)
	var0.super.OnUnload(arg0)

	arg0.waitForCharEnd = nil

	arg0:RemoveTellTimeTimer()
	arg0:RemoveDelayTellTimeTimer()
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	arg0.waitForCharEnd = nil

	arg0:RemoveTellTimeTimer()
	arg0:RemoveDelayTellTimeTimer()
end

return var0
