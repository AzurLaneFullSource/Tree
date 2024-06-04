local var0 = class("SnapshotShareLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "snapshotshareui"
end

function var0.init(arg0)
	arg0.photoImgTrans = arg0:findTF("PhotoImg")
	arg0.rawImage = arg0.photoImgTrans:GetComponent("RawImage")
	arg0.shareBtnTrans = arg0:findTF("BtnPanel/ShareBtn")
	arg0.confirmBtnTrans = arg0:findTF("BtnPanel/ConfirmBtn")
	arg0.cancelBtnTrans = arg0:findTF("BtnPanel/CancelBtn")
	arg0.userAgreenTF = arg0:findTF("UserAgreement")
	arg0.userAgreenMainTF = arg0:findTF("window", arg0.userAgreenTF)
	arg0.closeUserAgreenTF = arg0:findTF("close_btn", arg0.userAgreenMainTF)
	arg0.userRefuseConfirmTF = arg0:findTF("refuse_btn", arg0.userAgreenMainTF)
	arg0.userAgreenConfirmTF = arg0:findTF("accept_btn", arg0.userAgreenMainTF)

	setActive(arg0.userAgreenTF, false)

	arg0.rawImage.texture = arg0.contextData.photoTex
	arg0.bytes = arg0.contextData.photoData
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.shareBtnTrans, function()
		local var0 = PlayerPrefs.GetInt("snapshotAgress")

		if not var0 or var0 <= 0 then
			arg0:showUserAgreement(function()
				PlayerPrefs.SetInt("snapshotAgress", 1)
				pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePhoto)
			end)
		else
			pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePhoto)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtnTrans, function()
		local var0 = pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t")
		local var1 = "azur" .. var0.year .. var0.month .. var0.day .. var0.hour .. var0.min .. var0.sec .. ".jpg"
		local var2 = Application.persistentDataPath .. "/" .. var1

		MediaSaver.SaveImageWithBytes(var2, arg0.bytes)
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
		arg0:closeView()
	end)
	onButton(arg0, arg0.cancelBtnTrans, function()
		arg0:closeView()
	end)
end

function var0.willExit(arg0)
	return
end

function var0.showUserAgreement(arg0, arg1)
	setButtonEnabled(arg0.userAgreenConfirmTF, true)

	local var0

	arg0.userAgreenTitleTF = arg0:findTF("UserAgreement/window/title")
	arg0.userAgreenTitleTF:GetComponent("Text").text = i18n("word_snapshot_share_title")

	setActive(arg0.userAgreenTF, true)
	setText(arg0.userAgreenTF:Find("window/container/scrollrect/content/Text"), i18n("word_snapshot_share_agreement"))
	onButton(arg0, arg0.userRefuseConfirmTF, function()
		setActive(arg0.userAgreenTF, false)
	end)
	onButton(arg0, arg0.userAgreenConfirmTF, function()
		setActive(arg0.userAgreenTF, false)

		if arg1 then
			arg1()
		end
	end)
	onButton(arg0, arg0.closeUserAgreenTF, function()
		setActive(arg0.userAgreenTF, false)
	end)
end

return var0
