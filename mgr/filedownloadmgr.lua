pg = pg or {}

local var0_0 = pg

var0_0.FileDownloadMgr = singletonClass("FileDownloadMgr")

local var1_0 = var0_0.FileDownloadMgr
local var2_0 = FileDownloadConst

function var1_0.Init(arg0_1, arg1_1)
	print("initializing filedownloadmgr manager...")
	LoadAndInstantiateAsync("ui", "FileDownloadUI", function(arg0_2)
		arg0_1._go = arg0_2

		arg0_1._go:SetActive(false)

		arg0_1._tf = arg0_1._go.transform

		arg0_1._tf:SetParent(var0_0.UIMgr.GetInstance().OverlayMain, false)
		arg0_1:initUI()
		arg0_1:initUITextTips()
		arg1_1()
	end, true, true)
end

function var1_0.Main(arg0_3, arg1_3)
	arg0_3:initData()
	arg0_3:setData(arg1_3)
	arg0_3:show()
	arg0_3:startDownload()
end

function var1_0.IsRunning(arg0_4)
	return isActive(arg0_4._go)
end

var1_0.KEY_STOP_REMIND = "File_Download_Remind_Time"

function var1_0.SetRemind(arg0_5, arg1_5)
	arg0_5.isStopRemind = arg1_5
end

function var1_0.IsNeedRemind(arg0_6)
	if arg0_6.isStopRemind == true then
		return false
	else
		return true
	end
end

function var1_0.show(arg0_7)
	arg0_7._go:SetActive(true)
end

function var1_0.hide(arg0_8)
	arg0_8._go:SetActive(false)
end

function var1_0.initUI(arg0_9)
	arg0_9.mainTF = arg0_9._tf:Find("Main")
	arg0_9.titleText = arg0_9.mainTF:Find("Title")
	arg0_9.progressText = arg0_9.mainTF:Find("ProgressText")
	arg0_9.progressBar = arg0_9.mainTF:Find("ProgressBar")
end

function var1_0.initUITextTips(arg0_10)
	setText(arg0_10.titleText, i18n("file_down_mgr_title"))
end

function var1_0.initData(arg0_11)
	arg0_11.curGroupIndex = 0
	arg0_11.curGroupMgr = nil
	arg0_11.validGroupNameList = nil
	arg0_11.validFileNameArrMap = nil
	arg0_11.dataList = nil
	arg0_11.onFinish = nil
end

function var1_0.setData(arg0_12, arg1_12)
	arg0_12.dataList = arg1_12.dataList
	arg0_12.onFinish = arg1_12.onFinish
end

function var1_0.fileProgress(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = HashUtil.BytesToString(arg3_13)
	local var1_13 = HashUtil.BytesToString(arg4_13)

	setText(arg0_13.progressText, i18n("file_down_mgr_progress", var0_13, var1_13))
	setSlider(arg0_13.progressBar, 0, arg4_13, arg3_13)
end

function var1_0.fileFinish(arg0_14, arg1_14, arg2_14)
	return
end

function var1_0.groupComplete(arg0_15, arg1_15)
	local var0_15 = HashUtil.BytesToString(arg1_15)

	setText(arg0_15.progressText, i18n("file_down_mgr_progress", var0_15, var0_15))
	setSlider(arg0_15.progressBar, 0, 1, 1)

	arg0_15.curGroupIndex = arg0_15.curGroupIndex + 1

	if arg0_15.curGroupIndex > #arg0_15.validGroupNameList then
		arg0_15:allComplete()
	else
		arg0_15:download(arg0_15.curGroupIndex)
	end
end

function var1_0.allComplete(arg0_16)
	if arg0_16.onFinish then
		arg0_16.onFinish()
	end

	arg0_16:initData()
	arg0_16:hide()
end

function var1_0.error(arg0_17, arg1_17, arg2_17)
	local function var0_17()
		arg0_17:show()
		arg0_17:startDownload()
	end

	local function var1_17()
		Application.Quit()
	end

	arg0_17:hide()
	var0_0.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		locked = true,
		content = i18n("file_down_mgr_error", arg1_17, arg2_17),
		onYes = var0_17,
		onNo = var1_17,
		onClose = var1_17,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var1_0.download(arg0_20)
	local var0_20 = arg0_20.validGroupNameList[arg0_20.curGroupIndex]
	local var1_20 = arg0_20.validFileNameArrMap[var0_20]

	if not var1_20 or var1_20.Length == 0 then
		arg0_20:groupComplete()

		return
	end

	arg0_20.curGroupMgr = GroupHelper.GetGroupMgrByName(var0_20)

	local function var2_20(arg0_21, arg1_21, arg2_21, arg3_21)
		arg0_20:fileProgress(arg0_21, arg1_21, arg2_21, arg3_21)
	end

	local function var3_20(arg0_22, arg1_22)
		arg0_20:fileFinish(arg0_22, arg1_22)
	end

	local function var4_20(arg0_23, arg1_23)
		warning("----------------------Tag 单组下载完成,恢复UpdateD----------------------")

		arg0_20.curGroupMgr.isPauseUpdateD = false

		warning("----------------------Tag 单组下载完成,调用groupComplete----------------------")
		arg0_20:groupComplete(arg1_23)
	end

	local function var5_20(arg0_24, arg1_24)
		arg0_20:error(arg0_24, arg1_24)
	end

	warning("----------------------Tag 停止UpdateD----------------------")

	arg0_20.curGroupMgr.isPauseUpdateD = true

	warning("----------------------Tag 开始UpdateFileArray----------------------")
	arg0_20.curGroupMgr:UpdateFileArray(var1_20, var2_20, var3_20, var4_20, var5_20)
end

function var1_0.startDownload(arg0_25)
	if arg0_25:verifyValidData() then
		arg0_25.curGroupIndex = 1

		arg0_25:download(arg0_25.curGroupIndex)
	else
		arg0_25:allComplete()
	end
end

function var1_0.verifyValidData(arg0_26)
	arg0_26.validGroupNameList = {}
	arg0_26.validFileNameArrMap = {}

	for iter0_26, iter1_26 in ipairs(arg0_26.dataList) do
		local var0_26 = iter1_26.groupName
		local var1_26 = iter1_26.fileNameList
		local var2_26

		if var1_26 and #var1_26 > 0 then
			var2_26 = GroupHelper.CreateArrByLuaFileList(var0_26, var1_26)
		end

		if var2_26 and var2_26.Length > 0 then
			table.insert(arg0_26.validGroupNameList, var0_26)

			arg0_26.validFileNameArrMap[var0_26] = var2_26
		end
	end

	return #arg0_26.validGroupNameList > 0
end
