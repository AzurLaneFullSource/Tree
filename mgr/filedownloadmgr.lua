pg = pg or {}

local var0 = pg

var0.FileDownloadMgr = singletonClass("FileDownloadMgr")

local var1 = var0.FileDownloadMgr
local var2 = FileDownloadConst

function var1.Init(arg0, arg1)
	print("initializing filedownloadmgr manager...")
	PoolMgr.GetInstance():GetUI("FileDownloadUI", true, function(arg0)
		arg0._go = arg0

		arg0._go:SetActive(false)

		arg0._tf = arg0._go.transform

		arg0._tf:SetParent(var0.UIMgr.GetInstance().OverlayMain, false)
		arg0:initUI()
		arg0:initUITextTips()
		arg1()
	end)
end

function var1.Main(arg0, arg1)
	arg0:initData()
	arg0:setData(arg1)
	arg0:show()
	arg0:startDownload()
end

function var1.IsRunning(arg0)
	return isActive(arg0._go)
end

var1.KEY_STOP_REMIND = "File_Download_Remind_Time"

function var1.SetRemind(arg0, arg1)
	arg0.isStopRemind = arg1
end

function var1.IsNeedRemind(arg0)
	if arg0.isStopRemind == true then
		return false
	else
		return true
	end
end

function var1.show(arg0)
	arg0._go:SetActive(true)
end

function var1.hide(arg0)
	arg0._go:SetActive(false)
end

function var1.initUI(arg0)
	arg0.mainTF = arg0._tf:Find("Main")
	arg0.titleText = arg0.mainTF:Find("Title")
	arg0.progressText = arg0.mainTF:Find("ProgressText")
	arg0.progressBar = arg0.mainTF:Find("ProgressBar")
end

function var1.initUITextTips(arg0)
	setText(arg0.titleText, i18n("file_down_mgr_title"))
end

function var1.initData(arg0)
	arg0.curGroupIndex = 0
	arg0.curGroupMgr = nil
	arg0.validGroupNameList = nil
	arg0.validFileNameArrMap = nil
	arg0.dataList = nil
	arg0.onFinish = nil
end

function var1.setData(arg0, arg1)
	arg0.dataList = arg1.dataList
	arg0.onFinish = arg1.onFinish
end

function var1.fileProgress(arg0, arg1, arg2, arg3, arg4)
	local var0 = HashUtil.BytesToString(arg3)
	local var1 = HashUtil.BytesToString(arg4)

	setText(arg0.progressText, i18n("file_down_mgr_progress", var0, var1))
	setSlider(arg0.progressBar, 0, arg4, arg3)
end

function var1.fileFinish(arg0, arg1, arg2)
	return
end

function var1.groupComplete(arg0, arg1)
	local var0 = HashUtil.BytesToString(arg1)

	setText(arg0.progressText, i18n("file_down_mgr_progress", var0, var0))
	setSlider(arg0.progressBar, 0, 1, 1)

	arg0.curGroupIndex = arg0.curGroupIndex + 1

	if arg0.curGroupIndex > #arg0.validGroupNameList then
		arg0:allComplete()
	else
		arg0:download(arg0.curGroupIndex)
	end
end

function var1.allComplete(arg0)
	if arg0.onFinish then
		arg0.onFinish()
	end

	arg0:initData()
	arg0:hide()
end

function var1.error(arg0, arg1, arg2)
	local function var0()
		arg0:show()
		arg0:startDownload()
	end

	local function var1()
		Application.Quit()
	end

	arg0:hide()
	var0.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		locked = true,
		content = i18n("file_down_mgr_error", arg1, arg2),
		onYes = var0,
		onNo = var1,
		onClose = var1,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var1.download(arg0)
	local var0 = arg0.validGroupNameList[arg0.curGroupIndex]
	local var1 = arg0.validFileNameArrMap[var0]

	if not var1 or var1.Length == 0 then
		arg0:groupComplete()

		return
	end

	arg0.curGroupMgr = GroupHelper.GetGroupMgrByName(var0)

	local function var2(arg0, arg1, arg2, arg3)
		arg0:fileProgress(arg0, arg1, arg2, arg3)
	end

	local function var3(arg0, arg1)
		arg0:fileFinish(arg0, arg1)
	end

	local function var4(arg0, arg1)
		warning("----------------------Tag 单组下载完成,恢复UpdateD----------------------")

		arg0.curGroupMgr.isPauseUpdateD = false

		warning("----------------------Tag 单组下载完成,调用groupComplete----------------------")
		arg0:groupComplete(arg1)
	end

	local function var5(arg0, arg1)
		arg0:error(arg0, arg1)
	end

	warning("----------------------Tag 停止UpdateD----------------------")

	arg0.curGroupMgr.isPauseUpdateD = true

	warning("----------------------Tag 开始UpdateFileArray----------------------")
	arg0.curGroupMgr:UpdateFileArray(var1, var2, var3, var4, var5)
end

function var1.startDownload(arg0)
	if arg0:verifyValidData() then
		arg0.curGroupIndex = 1

		arg0:download(arg0.curGroupIndex)
	else
		arg0:allComplete()
	end
end

function var1.verifyValidData(arg0)
	arg0.validGroupNameList = {}
	arg0.validFileNameArrMap = {}

	for iter0, iter1 in ipairs(arg0.dataList) do
		local var0 = iter1.groupName
		local var1 = iter1.fileNameList
		local var2

		if var1 and #var1 > 0 then
			var2 = GroupHelper.CreateArrByLuaFileList(var0, var1)
		end

		if var2 and var2.Length > 0 then
			table.insert(arg0.validGroupNameList, var0)

			arg0.validFileNameArrMap[var0] = var2
		end
	end

	return #arg0.validGroupNameList > 0
end
