local var0_0 = class("SnapshotShareLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "snapshotshareui"
end

function var0_0.init(arg0_2)
	arg0_2.photoImgTrans = arg0_2:findTF("PhotoImg")
	arg0_2.rawImage = arg0_2.photoImgTrans:GetComponent("RawImage")
	arg0_2.shareBtnTrans = arg0_2:findTF("BtnPanel/ShareBtn")
	arg0_2.confirmBtnTrans = arg0_2:findTF("BtnPanel/ConfirmBtn")
	arg0_2.cancelBtnTrans = arg0_2:findTF("BtnPanel/CancelBtn")
	arg0_2.userAgreenTF = arg0_2:findTF("UserAgreement")
	arg0_2.userAgreenMainTF = arg0_2:findTF("window", arg0_2.userAgreenTF)
	arg0_2.closeUserAgreenTF = arg0_2:findTF("close_btn", arg0_2.userAgreenMainTF)
	arg0_2.userRefuseConfirmTF = arg0_2:findTF("refuse_btn", arg0_2.userAgreenMainTF)
	arg0_2.userAgreenConfirmTF = arg0_2:findTF("accept_btn", arg0_2.userAgreenMainTF)

	setActive(arg0_2.userAgreenTF, false)

	arg0_2.rawImage.texture = arg0_2.contextData.photoTex
	arg0_2.bytes = arg0_2.contextData.photoData
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.shareBtnTrans, function()
		local var0_4 = PlayerPrefs.GetInt("snapshotAgress")

		if not var0_4 or var0_4 <= 0 then
			arg0_3:showUserAgreement(function()
				PlayerPrefs.SetInt("snapshotAgress", 1)
				pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePhoto)
			end)
		else
			pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePhoto)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtnTrans, function()
		YSNormalTool.MediaTool.SaveImageWithBytes(arg0_3.bytes, function(arg0_7, arg1_7)
			if arg0_7 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
			end
		end)
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
		arg0_3:closeView()
	end)
	onButton(arg0_3, arg0_3.cancelBtnTrans, function()
		arg0_3:closeView()
	end)
end

function var0_0.willExit(arg0_9)
	return
end

function var0_0.showUserAgreement(arg0_10, arg1_10)
	setButtonEnabled(arg0_10.userAgreenConfirmTF, true)

	local var0_10

	arg0_10.userAgreenTitleTF = arg0_10:findTF("UserAgreement/window/title")
	arg0_10.userAgreenTitleTF:GetComponent("Text").text = i18n("word_snapshot_share_title")

	setActive(arg0_10.userAgreenTF, true)
	setText(arg0_10.userAgreenTF:Find("window/container/scrollrect/content/Text"), i18n("word_snapshot_share_agreement"))
	onButton(arg0_10, arg0_10.userRefuseConfirmTF, function()
		setActive(arg0_10.userAgreenTF, false)
	end)
	onButton(arg0_10, arg0_10.userAgreenConfirmTF, function()
		setActive(arg0_10.userAgreenTF, false)

		if arg1_10 then
			arg1_10()
		end
	end)
	onButton(arg0_10, arg0_10.closeUserAgreenTF, function()
		setActive(arg0_10.userAgreenTF, false)
	end)
end

return var0_0
