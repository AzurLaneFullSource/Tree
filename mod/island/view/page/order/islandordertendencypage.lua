local var0_0 = class("IslandOrderTendencyPage", import("Mod.Island.View.page.msgbox.window.IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandOrderTendencyUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.toggles = {
		[IslandOrderSlot.TENDENCY_TYPE_COMMON] = arg0_2:findTF("toggle/1"),
		[IslandOrderSlot.TENDENCY_TYPE_EASY] = arg0_2:findTF("toggle/0"),
		[IslandOrderSlot.TENDENCY_TYPE_HARD] = arg0_2:findTF("toggle/2")
	}

	setText(arg0_2:findTF("toggle/0/Text"), i18n1("更易完成"))
	setText(arg0_2:findTF("toggle/1/Text"), i18n1("标准"))
	setText(arg0_2:findTF("toggle/2/Text"), i18n1("更具挑战"))
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.onYes then
			arg0_3.onYes(arg0_3.selectedIndex)
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	local var0_6 = {
		onYes = arg2_6,
		title = i18n1("订单倾向")
	}

	var0_0.super.Show(arg0_6, var0_6)

	arg0_6.selectedIndex = arg1_6 or IslandOrderSlot.TENDENCY_TYPE_COMMON

	arg0_6:FlushToggles()
end

function var0_0.Hide(arg0_7)
	setActive(arg0_7._tf, false)
	arg0_7:OnHide()

	arg0_7.settings = nil
end

function var0_0.FlushToggles(arg0_8)
	for iter0_8, iter1_8 in pairs(arg0_8.toggles) do
		onToggle(arg0_8, iter1_8, function(arg0_9)
			if arg0_9 then
				arg0_8.selectedIndex = iter0_8

				arg0_8:UpdateContent()
			end
		end, SFX_PANEL)
	end

	triggerToggle(arg0_8.toggles[arg0_8.selectedIndex], true)
end

function var0_0.UpdateContent(arg0_10)
	local var0_10 = IslandOrderSlot.TENDENCY2TIP(arg0_10.selectedIndex)

	arg0_10.contentTxt.text = var0_10
end

return var0_0
