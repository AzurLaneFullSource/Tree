local var0_0 = class("TranscodeAlertView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "TranscodeAlertView"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.SetShareData(arg0_3, arg1_3)
	arg0_3.shareData = arg1_3
end

function var0_0.OnInit(arg0_4)
	arg0_4.transcodeAlert = arg0_4._tf
	arg0_4.tcSureBtn = arg0_4:findTF("transcode_sure", arg0_4.transcodeAlert)
	arg0_4.uidTxt = arg0_4:findTF("uid_input_txt", arg0_4.transcodeAlert):GetComponent(typeof(InputField))
	arg0_4.transcodeTxt = arg0_4:findTF("transcode_input_txt", arg0_4.transcodeAlert):GetComponent(typeof(InputField))
	arg0_4.tcDesc = arg0_4:findTF("desc", arg0_4.transcodeAlert)

	setText(arg0_4.tcDesc, i18n("transcode_desc"))
	arg0_4:InitEvent()
end

function var0_0.InitEvent(arg0_5)
	onButton(arg0_5, arg0_5.tcSureBtn, function()
		local var0_6 = arg0_5.uidTxt.text
		local var1_6 = arg0_5.transcodeTxt.text

		if var0_6 == "" or var1_6 == "" then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("transcode_empty_tip")
			})
		else
			pg.SdkMgr.GetInstance():LoginWithTranscode(var0_6, var1_6)
		end
	end)
	onButton(arg0_5, arg0_5.transcodeAlert, function()
		arg0_5:Hide()
	end)
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
