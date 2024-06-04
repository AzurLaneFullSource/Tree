local var0 = class("TranscodeAlertView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "TranscodeAlertView"
end

function var0.OnLoaded(arg0)
	return
end

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.OnInit(arg0)
	arg0.transcodeAlert = arg0._tf
	arg0.tcSureBtn = arg0:findTF("transcode_sure", arg0.transcodeAlert)
	arg0.uidTxt = arg0:findTF("uid_input_txt", arg0.transcodeAlert):GetComponent(typeof(InputField))
	arg0.transcodeTxt = arg0:findTF("transcode_input_txt", arg0.transcodeAlert):GetComponent(typeof(InputField))
	arg0.tcDesc = arg0:findTF("desc", arg0.transcodeAlert)

	setText(arg0.tcDesc, i18n("transcode_desc"))
	arg0:InitEvent()
end

function var0.InitEvent(arg0)
	onButton(arg0, arg0.tcSureBtn, function()
		local var0 = arg0.uidTxt.text
		local var1 = arg0.transcodeTxt.text

		if var0 == "" or var1 == "" then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("transcode_empty_tip")
			})
		else
			pg.SdkMgr.GetInstance():LoginWithTranscode(var0, var1)
		end
	end)
	onButton(arg0, arg0.transcodeAlert, function()
		arg0:Hide()
	end)
end

function var0.OnDestroy(arg0)
	return
end

return var0
