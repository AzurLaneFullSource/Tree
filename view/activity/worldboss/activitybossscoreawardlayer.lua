local var0 = class("ActivityBossScoreAwardLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "ActivitybonusWindow_nonPt"
end

function var0.init(arg0)
	arg0.closeBtn = arg0:findTF("window/top/btnBack")
	arg0.uiItemList = UIItemList.New(arg0:findTF("window/panel/list"), arg0:findTF("window/panel/list/item"))

	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateItem(arg1, arg2)
		end
	end)

	arg0.currentTxt = arg0:findTF("window/pt/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("window/top/bg/infomation"), i18n("world_expedition_reward_display"))
	setText(arg0:findTF("window/pt/title"), i18n("activityboss_sp_window_best_score"))
	setText(arg0:findTF("window/panel/list/item/target/title"), i18n("activityboss_sp_score_target"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	arg0:Flush()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Flush(arg0, arg1)
	arg0.awards = arg0.contextData.awards
	arg0.targets = arg0.contextData.targets
	arg0.score = arg0.contextData.score

	arg0.uiItemList:align(#arg0.awards)

	arg0.currentTxt.text = arg0.score
end

function var0.UpdateItem(arg0, arg1, arg2)
	local var0 = arg0.awards[arg1 + 1]
	local var1 = arg0.targets[arg1 + 1]
	local var2 = arg2:Find("award")
	local var3 = {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}

	updateDrop(var2, var3)
	onButton(arg0, var2, function()
		arg0:emit(BaseUI.ON_DROP, var3)
	end, SFX_PANEL)
	setActive(arg2:Find("award/mask"), var1 <= arg0.score)
	setText(arg2:Find("target/Text"), var1)
	setText(arg2:Find("title/Text"), "PHASE  " .. arg1 + 1)
end

function var0.Hide(arg0)
	arg0:closeView()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
