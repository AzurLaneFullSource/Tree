pg = pg or {}

local var0_0 = pg

var0_0.SettingsGroupMgr = singletonClass("SettingsGroupMgr")

local var1_0 = var0_0.SettingsGroupMgr

var1_0.State = {
	None = 1,
	Updating = 2,
	Fail = 4,
	Success = 3
}

function var1_0.Init(arg0_1, arg1_1)
	arg0_1.infoDict = {}
end

function var1_0.StartDownload(arg0_2, arg1_2, arg2_2)
	local function var0_2(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
		arg0_2:onProgress(arg1_2, arg0_3, arg1_3, arg2_3)
	end

	local function var1_2(arg0_4, arg1_4)
		arg0_2:onFinish(arg1_2, arg0_4, arg1_4)
	end

	local var2_2 = BundleWizardUpdater.Inst:GetFileList(arg2_2)
	local var3_2 = BundleWizardUpdater.Inst:CreateListInfo(arg1_2, var2_2, nil, var1_2, var0_2)

	BundleWizardUpdater.Inst:StartUpdate(var3_2)
end

function var1_0.GetState(arg0_5, arg1_5)
	local var0_5 = arg0_5.infoDict[arg1_5]

	if var0_5 == nil then
		return var1_0.State.None
	else
		return var0_5.state
	end
end

function var1_0.GetCountProgress(arg0_6, arg1_6)
	local var0_6 = arg0_6.infoDict[arg1_6]

	if var0_6 == nil then
		return 0, 0
	else
		return var0_6.curCount, var0_6.totalCount
	end
end

function var1_0.GetTotalSize(arg0_7, arg1_7)
	local var0_7 = 0

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		var0_7 = var0_7 + GroupHelper.GetGroupSize(iter1_7)
	end

	return var0_7
end

function var1_0.beforeStart(arg0_8, arg1_8)
	local var0_8 = arg0_8.infoDict[arg1_8]

	if var0_8 == nil then
		var0_8 = {}
		arg0_8.infoDict[arg1_8] = var0_8
	end

	var0_8.state = var1_0.State.Updating
end

function var1_0.onProgress(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = arg0_9.infoDict[arg1_9]

	if var0_9 == nil then
		var0_9 = {}
		arg0_9.infoDict[arg1_9] = var0_9
	end

	var0_9.state = var1_0.State.Updating
	var0_9.successCount = arg2_9
	var0_9.failCount = arg3_9
	var0_9.totalCount = arg4_9
	var0_9.curCount = arg2_9 + arg3_9
end

function var1_0.onFinish(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg0_10.infoDict[arg1_10]

	if var0_10 == nil then
		var0_10 = {}
		arg0_10.infoDict[arg1_10] = var0_10
	end

	if arg2_10 then
		var0_10.state = var1_0.State.Success
	else
		var0_10.state = var1_0.State.Fail
	end
end
