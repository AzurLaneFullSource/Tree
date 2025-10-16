local var0_0 = class("IslandRemindMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxWithRemind"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.remindToggle = arg0_2._tf:Find("remind")

	setText(arg0_2._tf:Find("remind/Text"), i18n("island_no_remind_today"))
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.onYes then
			arg0_3.onYes()
		end

		arg0_3:SaveValue(arg0_3.settings.key, arg0_3.flag and GetZeroTime() or 0)
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5)
	var0_0.super.OnShow(arg0_5)

	local var0_5 = arg0_5.settings

	arg0_5.flag = false

	assert(var0_5.key)
	arg0_5:Flush(var0_5)
end

function var0_0.Flush(arg0_6, arg1_6)
	onToggle(arg0_6, arg0_6.remindToggle, function(arg0_7)
		arg0_6.flag = arg0_7
	end, SFX_PANEL)
	triggerToggle(arg0_6.remindToggle, arg0_6.flag)
end

function var0_0.SaveValue(arg0_8, arg1_8, arg2_8)
	PlayerPrefs.SetInt(arg1_8, arg2_8)
	PlayerPrefs.Save()
end

return var0_0
