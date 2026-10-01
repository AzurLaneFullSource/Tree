local var0_0 = class("SettingsSplitPackBtn")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.mgr = pg.SplitPackDownloadMgr.GetInstance()

	arg0_1:findUI(arg1_1)
	arg0_1:addListener()
	arg0_1:check()
end

function var0_0.Dispose(arg0_2)
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:stopTimer()
end

function var0_0.findUI(arg0_3, arg1_3)
	arg0_3._tf = arg1_3

	local var0_3 = findTF(arg0_3._tf, "MainGroup/Content")

	arg0_3.progressBar = findTF(var0_3, "Progress")
	arg0_3.btn = findTF(var0_3, "Btn")
	arg0_3.btnText = findTF(arg0_3.btn, "Text")
	arg0_3.loadingIcon = findTF(var0_3, "Status/Loading")
	arg0_3.newIcon = findTF(var0_3, "Status/New")
	arg0_3.finishIcon = findTF(var0_3, "Status/Finish")

	setText(findTF(arg0_3._tf, "Title/Text"), i18n("setting_download_basic_assets"))
	setText(findTF(var0_3, "Title"), i18n("setting_download_basic_assets"))
end

function var0_0.addListener(arg0_4)
	onButton(arg0_4, arg0_4._tf, function()
		if arg0_4.mgr:GetState() == pg.SplitPackDownloadMgr.State.Fail then
			arg0_4.mgr:StartMainDownload()
			arg0_4:updateUI()
		end
	end, SFX_PANEL)
end

function var0_0.check(arg0_6)
	arg0_6.timer = Timer.New(function()
		arg0_6:updateUI()
	end, 0.5, -1)

	arg0_6.timer:Start()
	arg0_6:updateUI()
end

function var0_0.stopTimer(arg0_8)
	if arg0_8.timer then
		arg0_8.timer:Stop()

		arg0_8.timer = nil
	end
end

function var0_0.updateUI(arg0_9)
	local var0_9 = arg0_9.mgr:GetState()
	local var1_9 = arg0_9.mgr:IsDownloading()
	local var2_9 = var0_9 == pg.SplitPackDownloadMgr.State.Success
	local var3_9 = arg0_9.mgr:GetProgress()
	local var4_9 = var3_9 and var3_9.successCount or 0
	local var5_9 = var3_9 and var3_9.totalCount or 0

	setActive(arg0_9.loadingIcon, var1_9)
	setActive(arg0_9.newIcon, false)
	setActive(arg0_9.finishIcon, var2_9)

	if var5_9 > 0 then
		setSlider(arg0_9.progressBar, 0, var5_9, var2_9 and var5_9 or var4_9)
		setText(arg0_9.btnText, (var2_9 and var5_9 or var4_9) .. "/" .. var5_9)
	else
		setSlider(arg0_9.progressBar, 0, 1, var2_9 and 1 or 0)
		setText(arg0_9.btnText, (var2_9 and 1 or 0) .. "/" .. 1)
	end

	if var0_9 == pg.SplitPackDownloadMgr.State.Fail then
		setText(arg0_9.btnText, i18n("setting_restart_download_btn"))
	elseif var0_9 == pg.SplitPackDownloadMgr.State.Success then
		setText(arg0_9.btnText, i18n("word_maingroup_updatesuccess"))
	end

	if var2_9 then
		arg0_9:stopTimer()
	end
end

return var0_0
