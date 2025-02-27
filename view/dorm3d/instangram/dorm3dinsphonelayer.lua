local var0_0 = class("Dorm3dInsPhoneLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dInsPhoneUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.btnBack = arg0_2.bg:Find("top/back")
	arg0_2.voiceListContainer = arg0_2.bg:Find("main/voice/scroll/mask/list")
	arg0_2.voiceItemList = UIItemList.New(arg0_2.voiceListContainer, arg0_2.voiceListContainer:Find("tpl"))

	arg0_2.voiceItemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg0_2:UpdateVoiceItem(arg1_3, arg2_3)
		end
	end)

	arg0_2.data = getProxy(Dorm3dInsProxy):GetPhoneListByGroup(arg0_2.contextData.groupId) or {}

	if arg0_2.contextData.tf then
		SetParent(arg0_2._tf, arg0_2.contextData.tf)
	end

	arg0_2.player = VoiceChatLoader.New(arg0_2._tf)
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.btnBack, function()
		arg0_4:closeView()
	end)
	setText(arg0_4.voiceListContainer:Find("tpl/bg/uncheck/Text"), i18n("dorm3d_privatechat_telephone_noviewed"))
	setText(arg0_4.bg:Find("top/title"), i18n("dorm3d_privatechat_telephone_calllog"))
	setText(arg0_4.bg:Find("main/voice/title/Text"), i18n("dorm3d_privatechat_telephone_call"))
	arg0_4:Flush()
end

function var0_0.Flush(arg0_6)
	arg0_6.voiceItemList:align(#arg0_6.data)
end

function var0_0.UpdateVoiceItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.data[arg1_7 + 1]
	local var1_7 = var0_7:IsLock()

	setText(arg2_7:Find("bg/name"), var0_7:GetName())
	setActive(arg2_7:Find("bg/day"), not var1_7)
	setActive(arg2_7:Find("bg/lock"), var1_7)
	setActive(arg2_7:Find("bg/uncheck"), var0_7:ShouldTip())

	if var1_7 then
		setText(arg2_7:Find("bg/lock/info"), var0_7:GetDesc())
	else
		setText(arg2_7:Find("bg/day"), var0_7:GetDay())
	end

	onButton(arg0_7, arg2_7, function()
		if var1_7 then
			return
		end

		arg0_7.player:ExecuteAction("Play", var0_7:GetContent())
	end)
end

return var0_0
