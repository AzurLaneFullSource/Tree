pg = pg or {}
pg.MainGroupMgr = singletonClass("MainGroupMgr")

local var0_0 = pg.MainGroupMgr

var0_0.GroupNameList = {
	PaintingGroupConst.PaintingGroupName
}

function var0_0.Ctor(arg0_1)
	arg0_1:initData()
end

function var0_0.StartCheckD(arg0_2)
	arg0_2.curGroupIndex = 1

	arg0_2:checkWithIndex(arg0_2.curGroupIndex)
	arg0_2:createCheckTimer()
end

function var0_0.StartUpdateD(arg0_3)
	arg0_3.finishCount = 0

	arg0_3:SetTotalCount()

	arg0_3.curGroupIndex = 1

	arg0_3:updateWithIndex(arg0_3.curGroupIndex)
	arg0_3:createUpdateTimer()
end

function var0_0.GetState(arg0_4)
	local var0_4

	if arg0_4.curGroupIndex > #var0_0.GroupNameList then
		var0_4 = #var0_0.GroupNameList
	else
		var0_4 = arg0_4.curGroupIndex
	end

	return arg0_4.groupList[var0_4].state
end

function var0_0.GetCountProgress(arg0_5)
	local var0_5 = arg0_5.groupList[arg0_5.curGroupIndex]

	return arg0_5.finishCount + var0_5.downloadCount, arg0_5.totalCount
end

function var0_0.SetTotalCount(arg0_6)
	arg0_6.totalCount = 0

	for iter0_6, iter1_6 in ipairs(arg0_6.groupList) do
		arg0_6.totalCount = arg0_6.totalCount + iter1_6.toUpdate.Count
	end

	return arg0_6.totalCount
end

function var0_0.GetTotalSize(arg0_7)
	local var0_7 = 0

	for iter0_7, iter1_7 in ipairs(var0_0.GroupNameList) do
		var0_7 = var0_7 + GroupHelper.GetGroupSize(iter1_7)
	end

	return var0_7
end

function var0_0.initData(arg0_8)
	arg0_8.curGroupIndex = 1
	arg0_8.frameTimer = nil
	arg0_8.finishCount = 0
	arg0_8.totalCount = 0
	arg0_8.groupList = {}

	for iter0_8, iter1_8 in ipairs(var0_0.GroupNameList) do
		local var0_8 = GroupHelper.GetGroupMgrByName(iter1_8)

		table.insert(arg0_8.groupList, var0_8)
	end
end

function var0_0.clearTimer(arg0_9)
	if arg0_9.frameTimer then
		arg0_9.frameTimer:Stop()

		arg0_9.frameTimer = nil
	end
end

function var0_0.checkWithIndex(arg0_10, arg1_10)
	if arg1_10 > #var0_0.GroupNameList then
		arg0_10:clearTimer()

		return
	end

	arg0_10.groupList[arg0_10.curGroupIndex]:CheckD()
end

function var0_0.onCheckD(arg0_11)
	local var0_11 = arg0_11.groupList[arg0_11.curGroupIndex]
	local var1_11 = var0_11.state

	if var1_11 == DownloadState.CheckToUpdate or var1_11 == DownloadState.CheckOver or var1_11 == DownloadState.UpdateSuccess then
		arg0_11.curGroupIndex = arg0_11.curGroupIndex + 1

		arg0_11:checkWithIndex(arg0_11.curGroupIndex)
	elseif var0_11.state == DownloadState.CheckFailure then
		arg0_11:clearTimer()
	end
end

function var0_0.createCheckTimer(arg0_12)
	arg0_12.frameTimer = FrameTimer.New(function()
		arg0_12:onCheckD()
	end, 1, -1)

	arg0_12.frameTimer:Start()
end

function var0_0.updateWithIndex(arg0_14, arg1_14)
	if arg1_14 > #var0_0.GroupNameList then
		arg0_14:clearTimer()

		return
	end

	arg0_14.groupList[arg0_14.curGroupIndex]:UpdateD()
end

function var0_0.onUpdateD(arg0_15)
	local var0_15 = arg0_15.groupList[arg0_15.curGroupIndex]

	if var0_15.state == DownloadState.UpdateSuccess then
		arg0_15.finishCount = arg0_15.finishCount + var0_15.downloadTotal
		arg0_15.curGroupIndex = arg0_15.curGroupIndex + 1

		arg0_15:updateWithIndex(arg0_15.curGroupIndex)
	elseif var0_15.state == DownloadState.UpdateFailure then
		arg0_15:clearTimer()
	end
end

function var0_0.createUpdateTimer(arg0_16)
	arg0_16.frameTimer = FrameTimer.New(function()
		arg0_16:onUpdateD()
	end, 1, -1)

	arg0_16.frameTimer:Start()
end
