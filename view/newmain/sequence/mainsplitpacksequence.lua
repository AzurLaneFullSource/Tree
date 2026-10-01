local var0_0 = class("MainSplitPackSequence")

function var0_0.Execute(arg0_1, arg1_1)
	if not SplitPackHelper.Inst:IsSplitPackMode() then
		arg1_1()

		return
	end

	local var0_1 = pg.SplitPackDownloadMgr.GetInstance()

	if not var0_1:ShouldShowTip() then
		arg1_1()

		return
	end

	var0_1:MarkTipShown()

	local var1_1 = HashUtil.BytesToString(var0_1:GetTotalSize())

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideClose = true,
		content = i18n("auto_download_tip", var1_1),
		noText = pg.MsgboxMgr.TEXT_CONFIRM,
		onNo = arg1_1,
		yesText = i18n("auto_download_btn"),
		onYes = function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SETTINGS, {
				page = NewSettingsScene.PAGE_RES
			})
		end
	})
end

return var0_0
