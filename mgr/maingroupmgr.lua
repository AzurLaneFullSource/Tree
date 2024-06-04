pg = pg or {}
pg.MainGroupMgr = singletonClass("MainGroupMgr")

local var0 = pg.MainGroupMgr

var0.GroupNameList = {
	PaintingGroupConst.PaintingGroupName
}

function var0.Ctor(arg0)
	arg0:initData()
end

function var0.StartCheckD(arg0)
	arg0.curGroupIndex = 1

	arg0:checkWithIndex(arg0.curGroupIndex)
	arg0:createCheckTimer()
end

function var0.StartUpdateD(arg0)
	arg0.finishCount = 0

	arg0:SetTotalCount()

	arg0.curGroupIndex = 1

	arg0:updateWithIndex(arg0.curGroupIndex)
	arg0:createUpdateTimer()
end

function var0.GetState(arg0)
	local var0

	if arg0.curGroupIndex > #var0.GroupNameList then
		var0 = #var0.GroupNameList
	else
		var0 = arg0.curGroupIndex
	end

	return arg0.groupList[var0].state
end

function var0.GetCountProgress(arg0)
	local var0 = arg0.groupList[arg0.curGroupIndex]

	return arg0.finishCount + var0.downloadCount, arg0.totalCount
end

function var0.SetTotalCount(arg0)
	arg0.totalCount = 0

	for iter0, iter1 in ipairs(arg0.groupList) do
		arg0.totalCount = arg0.totalCount + iter1.toUpdate.Count
	end

	return arg0.totalCount
end

function var0.GetTotalSize(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(var0.GroupNameList) do
		var0 = var0 + GroupHelper.GetGroupSize(iter1)
	end

	return var0
end

function var0.initData(arg0)
	arg0.curGroupIndex = 1
	arg0.frameTimer = nil
	arg0.finishCount = 0
	arg0.totalCount = 0
	arg0.groupList = {}

	for iter0, iter1 in ipairs(var0.GroupNameList) do
		local var0 = GroupHelper.GetGroupMgrByName(iter1)

		table.insert(arg0.groupList, var0)
	end
end

function var0.clearTimer(arg0)
	if arg0.frameTimer then
		arg0.frameTimer:Stop()

		arg0.frameTimer = nil
	end
end

function var0.checkWithIndex(arg0, arg1)
	if arg1 > #var0.GroupNameList then
		arg0:clearTimer()

		return
	end

	arg0.groupList[arg0.curGroupIndex]:CheckD()
end

function var0.onCheckD(arg0)
	local var0 = arg0.groupList[arg0.curGroupIndex]
	local var1 = var0.state

	if var1 == DownloadState.CheckToUpdate or var1 == DownloadState.CheckOver or var1 == DownloadState.UpdateSuccess then
		arg0.curGroupIndex = arg0.curGroupIndex + 1

		arg0:checkWithIndex(arg0.curGroupIndex)
	elseif var0.state == DownloadState.CheckFailure then
		arg0:clearTimer()
	end
end

function var0.createCheckTimer(arg0)
	arg0.frameTimer = FrameTimer.New(function()
		arg0:onCheckD()
	end, 1, -1)

	arg0.frameTimer:Start()
end

function var0.updateWithIndex(arg0, arg1)
	if arg1 > #var0.GroupNameList then
		arg0:clearTimer()

		return
	end

	arg0.groupList[arg0.curGroupIndex]:UpdateD()
end

function var0.onUpdateD(arg0)
	local var0 = arg0.groupList[arg0.curGroupIndex]

	if var0.state == DownloadState.UpdateSuccess then
		arg0.finishCount = arg0.finishCount + var0.downloadTotal
		arg0.curGroupIndex = arg0.curGroupIndex + 1

		arg0:updateWithIndex(arg0.curGroupIndex)
	elseif var0.state == DownloadState.UpdateFailure then
		arg0:clearTimer()
	end
end

function var0.createUpdateTimer(arg0)
	arg0.frameTimer = FrameTimer.New(function()
		arg0:onUpdateD()
	end, 1, -1)

	arg0.frameTimer:Start()
end
