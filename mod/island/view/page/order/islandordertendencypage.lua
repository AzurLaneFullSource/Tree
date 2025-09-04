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

	setText(arg0_2:findTF("toggle/0/Text"), i18n("island_order_difficulty_2"))
	setText(arg0_2:findTF("toggle/1/Text"), i18n("island_order_difficulty_1"))
	setText(arg0_2:findTF("toggle/2/Text"), i18n("island_order_difficulty_3"))
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.onYes then
			arg0_3.onYes(arg0_3.selectedIndex)
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5)
	var0_0.super.OnShow(arg0_5)

	arg0_5.selectedIndex = arg0_5.settings.selected or IslandOrderSlot.TENDENCY_TYPE_COMMON

	arg0_5:FlushToggles()
end

function var0_0.OnHide(arg0_6)
	var0_0.super.OnHide(arg0_6)

	arg0_6.settings = nil
end

function var0_0.FlushToggles(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.toggles) do
		onToggle(arg0_7, iter1_7, function(arg0_8)
			if arg0_8 then
				arg0_7.selectedIndex = iter0_7

				arg0_7:UpdateContent()
			end
		end, SFX_PANEL)
	end

	triggerToggle(arg0_7.toggles[arg0_7.selectedIndex], true)
end

function var0_0.UpdateContent(arg0_9)
	local var0_9 = IslandOrderSlot.TENDENCY2TIP(arg0_9.selectedIndex)

	arg0_9.contentTxt.text = var0_9
end

return var0_0
