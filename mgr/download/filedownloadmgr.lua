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
	arg0_11.dataList = nil
	arg0_11.onFinish = nil
end

function var1_0.setData(arg0_12, arg1_12)
	arg0_12.dataList = arg1_12.dataList
	arg0_12.onFinish = arg1_12.onFinish
end

function var1_0.fileProgress(arg0_13, arg1_13, arg2_13)
	local var0_13 = HashUtil.BytesToString(arg1_13)
	local var1_13 = HashUtil.BytesToString(arg2_13)

	setText(arg0_13.progressText, i18n("file_down_mgr_progress", var0_13, var1_13))
	setSlider(arg0_13.progressBar, 0, tonumber(tostring(arg2_13)), tonumber(tostring(arg1_13)))
end

function var1_0.allComplete(arg0_14, arg1_14, arg2_14)
	if arg0_14.onFinish then
		arg0_14.onFinish()
	end

	arg0_14:initData()
	arg0_14:hide()
end

function var1_0.error(arg0_15, arg1_15, arg2_15)
	local function var0_15()
		arg0_15:startDownload()
	end

	local function var1_15()
		Application.Quit()
	end

	arg0_15:hide()
	var0_0.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		locked = true,
		content = i18n("file_down_mgr_error", arg1_15, arg2_15),
		onYes = var0_15,
		onNo = var1_15,
		onClose = var1_15,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var1_0.download(arg0_18)
	local function var0_18(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19)
		arg0_18:fileProgress(arg3_19, arg4_19)
	end

	local function var1_18(arg0_20, arg1_20)
		if arg0_20 then
			arg0_18:allComplete()
		else
			arg0_18:error("", "")
		end
	end

	BundleWizardUpdater.Inst:StartUpdate(arg0_18.info, nil, var1_18, var0_18)
end

function var1_0.startDownload(arg0_21)
	if arg0_21:verifyValidData() then
		arg0_21:show()
		arg0_21:download()
	else
		arg0_21:allComplete()
	end
end

function var1_0.verifyValidData(arg0_22)
	arg0_22.info = var1_0.createDownloadFileInfo(arg0_22.dataList)

	return BundleWizardUpdater.Inst:GetFileList(arg0_22.info).Count > 0
end

function var1_0.createDownloadFileInfo(arg0_23)
	local var0_23 = BundleWizardUpdateInfo.New()
	local var1_23 = {}

	assert(#arg0_23 < 2)

	for iter0_23, iter1_23 in ipairs(arg0_23) do
		var0_23:AddGroup(iter1_23.groupName, iter1_23.fileNameList)
		table.insert(var1_23, iter1_23.groupName)
	end

	var0_23.infoName = table.concat(var1_23, "_")

	return var0_23
end
