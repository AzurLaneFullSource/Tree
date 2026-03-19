local var0_0 = class("NewEducateProxy", import(".NetProxy"))

var0_0.RESOURCE_UPDATED = "NewEducateProxy.RESOURCE_UPDATED"
var0_0.ATTR_UPDATED = "NewEducateProxy.ATTR_UPDATED"
var0_0.PERSONALITY_UPDATED = "NewEducateProxy.PERSONALITY_UPDATED"
var0_0.TALENT_UPDATED = "NewEducateProxy.TALENT_UPDATED"
var0_0.STATUS_UPDATED = "NewEducateProxy.STATUS_UPDATED"
var0_0.TAROT_UPDATED = "NewEducateProxy.TAROT_UPDATED"
var0_0.POLAROID_UPDATED = "NewEducateProxy.POLAROID_UPDATED"
var0_0.ENDING_UPDATED = "NewEducateProxy.ENDING_UPDATED"
var0_0.NEXT_ROUND = "NewEducateProxy.NEXT_ROUND"

function var0_0.register(arg0_1)
	arg0_1.data = {}
end

function var0_0.ReqDataCheck(arg0_2, arg1_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(pg.child2_data.all) do
		table.insert(var0_2, function(arg0_3)
			if not arg0_2.data[iter1_2] then
				pg.m02:sendNotification(GAME.NEW_EDUCATE_REQUEST, {
					id = iter1_2,
					callback = arg0_3
				})
			else
				arg0_3()
			end
		end)
	end

	seriesAsync(var0_2, function()
		existCall(arg1_2)
	end)
end

function var0_0.GetChar(arg0_5, arg1_5)
	return arg0_5.data[arg1_5]
end

function var0_0.UpdateChar(arg0_6, arg1_6, arg2_6)
	local var0_6 = NewEducateChar.New(arg1_6)

	arg0_6.data[var0_6.id] = var0_6

	arg0_6.data[var0_6.id]:InitPermanent(arg2_6)
	arg0_6.data[var0_6.id]:InitFSM(arg1_6.fsm)
end

function var0_0.ResetChar(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.data[arg1_7]:GetPermanentData()

	var0_7:AddGameCnt()

	arg0_7.data[arg1_7] = NewEducateChar.New(arg2_7)

	arg0_7.data[arg1_7]:SetPermanent(var0_7)
	arg0_7.data[arg1_7]:InitFSM(arg2_7.fsm)
end

function var0_0.RefreshChar(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.data[arg1_8]:GetPermanentData()

	arg0_8.data[arg1_8] = NewEducateChar.New(arg2_8)

	arg0_8.data[arg1_8]:SetPermanent(var0_8)
	arg0_8.data[arg1_8]:InitFSM(arg2_8.fsm)
	NewEducateHelper.ClearEventPerformance(arg0_8.data[arg1_8])
end

function var0_0.SetCurChar(arg0_9, arg1_9)
	arg0_9.curId = arg1_9
end

function var0_0.GetCurChar(arg0_10)
	return arg0_10.data[arg0_10.curId]
end

function var0_0.AddTempRound(arg0_11, arg1_11)
	arg0_11.data[arg0_11.curId]:GetRoundData():AddTempCnt(arg1_11)
end

function var0_0.AddBuff(arg0_12, arg1_12, arg2_12)
	assert(pg.child2_benefit_list[arg1_12], "child2_benefit_list不存在id" .. arg1_12)

	if not pg.child2_benefit_list[arg1_12] then
		return
	end

	arg0_12.data[arg0_12.curId]:AddBuff(arg1_12, arg2_12)

	local var0_12 = pg.child2_benefit_list[arg1_12].type

	if var0_12 == NewEducateBuff.TYPE.TALENT then
		arg0_12:sendNotification(var0_0.TALENT_UPDATED)
	elseif var0_12 == NewEducateBuff.TYPE.STATUS then
		arg0_12:sendNotification(var0_0.STATUS_UPDATED)
	else
		arg0_12:sendNotification(var0_0.TAROT_UPDATED)
	end
end

function var0_0.UpdateResources(arg0_13, arg1_13)
	arg0_13.data[arg0_13.curId]:SetResources(arg1_13)
	arg0_13:sendNotification(var0_0.RESOURCE_UPDATED)
end

function var0_0.UpdateRes(arg0_14, arg1_14, arg2_14)
	arg0_14.data[arg0_14.curId]:UpdateRes(arg1_14, arg2_14)
	arg0_14:sendNotification(var0_0.RESOURCE_UPDATED)
end

function var0_0.UpdateAttrs(arg0_15, arg1_15)
	arg0_15.data[arg0_15.curId]:SetAttrs(arg1_15)
	arg0_15:sendNotification(var0_0.ATTR_UPDATED)
end

function var0_0.UpdateAttr(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.data[arg0_16.curId]:GetPersonalityTag()

	arg0_16.data[arg0_16.curId]:UpdateAttr(arg1_16, arg2_16)
	arg0_16:sendNotification(var0_0.ATTR_UPDATED)

	if arg1_16 == arg0_16.data[arg0_16.curId]:GetPersonalityId() then
		arg0_16:sendNotification(var0_0.PERSONALITY_UPDATED, {
			number = arg2_16,
			oldTag = var0_16
		})
	end
end

function var0_0.AddPolaroid(arg0_17, arg1_17, arg2_17)
	arg0_17.data[arg0_17.curId]:GetPermanentData():AddPolaroid(arg1_17)
	arg0_17:sendNotification(var0_0.POLAROID_UPDATED)
	pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataPolariod(arg0_17.data[arg0_17.curId]:GetGameCnt(), arg0_17.data[arg0_17.curId]:GetRoundData().round, arg1_17))
end

function var0_0.AddActivatedEndings(arg0_18, arg1_18)
	arg0_18.data[arg0_18.curId]:GetPermanentData():AddActivatedEndings(arg1_18)
	arg0_18:sendNotification(var0_0.ENDING_UPDATED)
end

function var0_0.AddFinishedEnding(arg0_19, arg1_19)
	arg0_19.data[arg0_19.curId]:GetPermanentData():AddFinishedEnding(arg1_19)
	arg0_19:sendNotification(var0_0.ENDING_UPDATED)
end

function var0_0.UpdateUnlock(arg0_20, arg1_20)
	arg1_20 = arg1_20 or arg0_20.curId

	if not arg0_20.data[arg1_20] then
		return
	end

	arg0_20.data[arg1_20]:GetPermanentData():UpdateSecretaryIDs(true)
end

function var0_0.Costs(arg0_21, arg1_21)
	underscore.each(arg1_21, function(arg0_22)
		arg0_21:Cost(arg0_22)
	end)
end

function var0_0.Cost(arg0_23, arg1_23)
	switch(arg1_23.type, {
		[NewEducateConst.DROP_TYPE.ATTR] = function()
			arg0_23:UpdateAttr(arg1_23.id, -arg1_23.number)
		end,
		[NewEducateConst.DROP_TYPE.RES] = function()
			arg0_23:UpdateRes(arg1_23.id, -arg1_23.number)
		end
	}, function()
		assert(false, "非法消耗类型:" .. arg1_23.type)
	end)
end

function var0_0.NextRound(arg0_27)
	arg0_27.data[arg0_27.curId]:OnNextRound()
	arg0_27:sendNotification(var0_0.NEXT_ROUND)
end

function var0_0.GetStoryInfo(arg0_28)
	local var0_28 = arg0_28.data[arg0_28.curId]

	return var0_28:GetPaintingName(), var0_28:GetCallName(), var0_28:GetBGName()
end

function var0_0.RecordEnterTime(arg0_29, arg1_29)
	arg0_29.enterTimeStamp = arg1_29 and 0 or pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetEnterTime(arg0_30)
	return arg0_30.enterTimeStamp or 0
end

function var0_0.remove(arg0_31)
	return
end

return var0_0
