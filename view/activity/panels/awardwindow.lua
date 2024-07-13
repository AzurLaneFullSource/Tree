local var0_0 = class("AwardWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ActivitybonusWindow_nonPt"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("window/panel/list"), arg0_2:findTF("window/panel/list/item"))
	arg0_2.currentTitle = arg0_2:findTF("window/pt/title"):GetComponent(typeof(Text))
	arg0_2.currentTxt = arg0_2:findTF("window/pt/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("window/top/bg/infomation"), i18n("world_expedition_reward_display"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.uiItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_6, arg2_6)
		end
	end)
end

function var0_0.UpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.awards[arg1_7 + 1]
	local var1_7 = arg2_7:Find("award")
	local var2_7 = {
		type = var0_7[1],
		id = var0_7[2],
		count = var0_7[3]
	}

	updateDrop(var1_7, var2_7)
	onButton(arg0_7, var1_7, function()
		arg0_7:emit(BaseUI.ON_DROP, var2_7)
	end, SFX_PANEL)
	setActive(arg2_7:Find("award/mask"), arg1_7 + 1 <= arg0_7.finishIndex)
	setText(arg2_7:Find("target/title"), arg0_7.targetTitle)
	setText(arg2_7:Find("target/Text"), arg1_7 + 1)
	setText(arg2_7:Find("title/Text"), "PHASE  " .. arg1_7 + 1)
end

function var0_0.Flush(arg0_9, arg1_9, arg2_9, arg3_9)
	arg0_9.awards = arg1_9
	arg0_9.finishIndex = arg2_9
	arg0_9.targetTitle = arg3_9[2]

	arg0_9.uiItemList:align(#arg0_9.awards)

	arg0_9.currentTitle.text = arg3_9[1]
	arg0_9.currentTxt.text = arg2_9

	arg0_9:Show()
end

function var0_0.Show(arg0_10)
	var0_0.super.Show(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)
end

function var0_0.Hide(arg0_11)
	var0_0.super.Hide(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, arg0_11._parentTf)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
