local var0_0 = class("DreamlandSwitcherPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "DreamlandSwitcherUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.confirmBtn = arg0_2._tf:Find("bg/confirm")
	arg0_2.times = {
		arg0_2._tf:Find("bg/conent/1"),
		arg0_2._tf:Find("bg/conent/2"),
		arg0_2._tf:Find("bg/conent/3")
	}

	setText(arg0_2.times[1]:Find("title"), i18n("dreamland_label_day"))
	setText(arg0_2.times[2]:Find("title"), i18n("dreamland_label_dusk"))
	setText(arg0_2.times[3]:Find("title"), i18n("dreamland_label_night"))
end

function var0_0.OnInit(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.times) do
		onToggle(arg0_3, iter1_3, function(arg0_4)
			if arg0_4 then
				arg0_3.selected = iter0_3
			end

			arg0_3:UpdateToggleStyle(iter1_3, arg0_4)
		end, SFX_PANEL)
	end

	onButton(arg0_3, arg0_3.confirmBtn, function()
		if not arg0_3.selected then
			return
		end

		arg0_3:emit(DreamlandScene.EVENT_SWITCH_TIME, arg0_3.selected)
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)
	triggerToggle(arg0_7.times[arg1_7], true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
	arg0_7:InitTogglesStyle(arg1_7)
end

function var0_0.InitTogglesStyle(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.times) do
		if iter0_8 ~= arg1_8 then
			arg0_8:UpdateToggleStyle(iter1_8, false)
		end
	end
end

function var0_0.UpdateToggleStyle(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9:Find("icon"):GetComponent(typeof(Image))
	local var1_9 = arg1_9:Find("title_icon"):GetComponent(typeof(Image))
	local var2_9 = arg1_9:Find("title"):GetComponent(typeof(Text))
	local var3_9 = Color.New(1, 1, 1, 1)
	local var4_9 = Color.New(0.4235294, 0.4313726, 0.5137255, 1)

	var0_9.color = arg2_9 and var3_9 or var4_9
	var1_9.color = arg2_9 and var3_9 or var4_9
	var2_9.color = arg2_9 and var3_9 or var4_9
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, arg0_10._parentTf)
end

function var0_0.OnDestroy(arg0_11)
	if arg0_11:isShowing() then
		arg0_11:Hide()
	end
end

return var0_0
