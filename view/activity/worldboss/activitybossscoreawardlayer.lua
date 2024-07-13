local var0_0 = class("ActivityBossScoreAwardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ActivitybonusWindow_nonPt"
end

function var0_0.init(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("window/panel/list"), arg0_2:findTF("window/panel/list/item"))

	arg0_2.uiItemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg0_2:UpdateItem(arg1_3, arg2_3)
		end
	end)

	arg0_2.currentTxt = arg0_2:findTF("window/pt/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("window/top/bg/infomation"), i18n("world_expedition_reward_display"))
	setText(arg0_2:findTF("window/pt/title"), i18n("activityboss_sp_window_best_score"))
	setText(arg0_2:findTF("window/panel/list/item/target/title"), i18n("activityboss_sp_score_target"))
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.closeBtn, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	arg0_4:Flush()
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.Flush(arg0_7, arg1_7)
	arg0_7.awards = arg0_7.contextData.awards
	arg0_7.targets = arg0_7.contextData.targets
	arg0_7.score = arg0_7.contextData.score

	arg0_7.uiItemList:align(#arg0_7.awards)

	arg0_7.currentTxt.text = arg0_7.score
end

function var0_0.UpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.awards[arg1_8 + 1]
	local var1_8 = arg0_8.targets[arg1_8 + 1]
	local var2_8 = arg2_8:Find("award")
	local var3_8 = {
		type = var0_8[1],
		id = var0_8[2],
		count = var0_8[3]
	}

	updateDrop(var2_8, var3_8)
	onButton(arg0_8, var2_8, function()
		arg0_8:emit(BaseUI.ON_DROP, var3_8)
	end, SFX_PANEL)
	setActive(arg2_8:Find("award/mask"), var1_8 <= arg0_8.score)
	setText(arg2_8:Find("target/Text"), var1_8)
	setText(arg2_8:Find("title/Text"), "PHASE  " .. arg1_8 + 1)
end

function var0_0.Hide(arg0_10)
	arg0_10:closeView()
end

function var0_0.willExit(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf)
end

return var0_0
