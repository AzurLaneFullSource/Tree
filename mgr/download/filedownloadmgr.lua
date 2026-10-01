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
	arg0_3.requestQueue = arg0_3.requestQueue or {}

	table.insert(arg0_3.requestQueue, arg1_3)
	arg0_3:processNext()
end

function var1_0.processNext(arg0_4)
	if arg0_4.currentRequest then
		return
	end

	arg0_4.requestQueue = arg0_4.requestQueue or {}

	local var0_4 = table.remove(arg0_4.requestQueue, 1)

	if not var0_4 then
		arg0_4:hide()

		return
	end

	arg0_4.currentRequest = var0_4

	arg0_4:setData(var0_4)
	arg0_4:startDownload()
end

function var1_0.IsRunning(arg0_5)
	return arg0_5.currentRequest ~= nil or #(arg0_5.requestQueue or {}) > 0 or isActive(arg0_5._go)
end

var1_0.KEY_STOP_REMIND = "File_Download_Remind_Time"

function var1_0.SetRemind(arg0_6, arg1_6)
	arg0_6.isStopRemind = arg1_6
end

function var1_0.IsNeedRemind(arg0_7)
	if arg0_7.isStopRemind == true then
		return false
	else
		return true
	end
end

function var1_0.show(arg0_8)
	setActive(arg0_8.maskTF, arg0_8.showMask)
	arg0_8._go:SetActive(true)
end

function var1_0.hide(arg0_9)
	arg0_9._go:SetActive(false)
end

function var1_0.initUI(arg0_10)
	arg0_10.mainTF = arg0_10._tf:Find("Main")
	arg0_10.maskTF = arg0_10._tf:Find("Mask")
	arg0_10.titleText = arg0_10.mainTF:Find("Title")
	arg0_10.progressText = arg0_10.mainTF:Find("ProgressText")
	arg0_10.progressBar = arg0_10.mainTF:Find("ProgressBar")

	setActive(arg0_10.maskTF, false)
end

function var1_0.initUITextTips(arg0_11)
	setText(arg0_11.titleText, i18n("file_down_mgr_title"))
end

function var1_0.initData(arg0_12)
	arg0_12.curGroupIndex = 0
	arg0_12.curGroupMgr = nil
	arg0_12.dataList = nil
	arg0_12.onFinish = nil
	arg0_12.showMask = false
end

function var1_0.setData(arg0_13, arg1_13)
	arg0_13.dataList = arg1_13.dataList
	arg0_13.onFinish = arg1_13.onFinish
	arg0_13.showMask = arg1_13.showMask == true
end

function var1_0.fileProgress(arg0_14, arg1_14, arg2_14)
	local var0_14 = HashUtil.BytesToString(arg1_14)
	local var1_14 = HashUtil.BytesToString(arg2_14)

	setText(arg0_14.progressText, i18n("file_down_mgr_progress", var0_14, var1_14))
	setSlider(arg0_14.progressBar, 0, tonumber(tostring(arg2_14)), tonumber(tostring(arg1_14)))
end

function var1_0.allComplete(arg0_15, arg1_15)
	local var0_15 = arg1_15 or arg0_15.onFinish

	arg0_15:initData()

	arg0_15.currentRequest = nil

	arg0_15:hide()

	if var0_15 then
		var0_15()
	end

	arg0_15:processNext()
end

function var1_0.error(arg0_16, arg1_16, arg2_16)
	local function var0_16()
		arg0_16:startDownload()
	end

	local function var1_16()
		Application.Quit()
	end

	arg0_16:hide()
	var0_0.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		locked = true,
		content = i18n("file_down_mgr_error", arg1_16, arg2_16),
		onYes = var0_16,
		onNo = var1_16,
		onClose = var1_16
	})
end

function var1_0.download(arg0_19)
	local function var0_19(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20, arg5_20)
		arg0_19:fileProgress(arg3_20, arg4_20)
	end

	local var1_19 = arg0_19.onFinish

	local function var2_19(arg0_21, arg1_21)
		if arg0_21 then
			arg0_19:allComplete(var1_19)
		else
			arg0_19:error("", "")
		end
	end

	BundleWizardUpdater.Inst:StartUpdate(arg0_19.info, nil, var2_19, var0_19)
end

function var1_0.startDownload(arg0_22)
	if arg0_22:verifyValidData() then
		arg0_22:show()
		arg0_22:download()
	else
		arg0_22:allComplete()
	end
end

function var1_0.verifyValidData(arg0_23)
	arg0_23.info = var1_0.createDownloadFileInfo(arg0_23.dataList)

	return BundleWizardUpdater.Inst:GetFileList(arg0_23.info).Count > 0
end

function var1_0.createDownloadFileInfo(arg0_24)
	local var0_24 = BundleWizardUpdateInfo.New()
	local var1_24 = {}

	for iter0_24, iter1_24 in ipairs(arg0_24) do
		var0_24:AddGroup(iter1_24.groupName, iter1_24.fileNameList)
		table.insert(var1_24, iter1_24.groupName)
	end

	var0_24.infoName = table.concat(var1_24, "_")

	return var0_24
end
