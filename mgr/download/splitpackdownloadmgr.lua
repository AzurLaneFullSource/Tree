pg = pg or {}

local var0_0 = pg

var0_0.SplitPackDownloadMgr = singletonClass("SplitPackDownloadMgr")

local var1_0 = var0_0.SplitPackDownloadMgr

var1_0.State = {
	None = 1,
	Fail = 3,
	Success = 2
}

function var1_0.Init(arg0_1)
	arg0_1.isDownloading = false
	arg0_1.state = var1_0.State.None
	arg0_1.hasShownTip = false
	arg0_1.message = ""
	arg0_1.progress = {
		curSize = 0,
		successCount = 0,
		failCount = 0,
		speed = "",
		totalSize = 0,
		totalCount = 0
	}
end

function var1_0.StartMainDownload(arg0_2)
	if not SplitPackHelper.Inst:IsSplitPackMode() then
		return
	end

	if arg0_2.progress == nil then
		arg0_2:Init()
	end

	if arg0_2.isDownloading then
		return
	end

	arg0_2.isDownloading = true
	arg0_2.state = var1_0.State.None
	arg0_2.message = ""

	local var0_2 = GroupMainHelper.DefaultGroupName
	local var1_2 = {
		var0_2
	}
	local var2_2 = BundleWizardUpdater.Inst:GetFileList(var1_2)

	arg0_2.progress.successCount = 0
	arg0_2.progress.failCount = 0
	arg0_2.progress.totalCount = var2_2.Count
	arg0_2.progress.curSize = 0
	arg0_2.progress.totalSize = GroupHelper.GetGroupSize(var0_2)
	arg0_2.progress.speed = ""

	local function var3_2(arg0_3, arg1_3)
		arg0_2.isDownloading = false
		arg0_2.state = arg0_3 and var1_0.State.Success or var1_0.State.Fail
		arg0_2.message = arg1_3 or ""
	end

	local function var4_2(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
		arg0_2.isDownloading = true
		arg0_2.progress.successCount = arg0_4
		arg0_2.progress.failCount = arg1_4
		arg0_2.progress.totalCount = arg2_4
		arg0_2.progress.curSize = arg3_4
		arg0_2.progress.totalSize = arg4_4
		arg0_2.progress.speed = arg5_4 or ""
	end

	local var5_2 = BundleWizardUpdater.Inst:CreateListInfo(var0_2, var2_2, nil, var3_2, var4_2)

	BundleWizardUpdater.Inst:StartUpdate(var5_2)
end

function var1_0.IsDownloading(arg0_5)
	return arg0_5.isDownloading
end

function var1_0.GetState(arg0_6)
	return arg0_6.state
end

function var1_0.GetProgress(arg0_7)
	return arg0_7.progress
end

function var1_0.GetTotalSize(arg0_8)
	return arg0_8.progress and arg0_8.progress.totalSize or 0
end

function var1_0.ShouldShowTip(arg0_9)
	return arg0_9.isDownloading and not arg0_9.hasShownTip
end

function var1_0.MarkTipShown(arg0_10)
	arg0_10.hasShownTip = true
end
