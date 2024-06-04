local var0 = class("AwardWindow", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "ActivitybonusWindow_nonPt"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("window/top/btnBack")
	arg0.uiItemList = UIItemList.New(arg0:findTF("window/panel/list"), arg0:findTF("window/panel/list/item"))
	arg0.currentTitle = arg0:findTF("window/pt/title"):GetComponent(typeof(Text))
	arg0.currentTxt = arg0:findTF("window/pt/Text"):GetComponent(typeof(Text))

	setText(arg0:findTF("window/top/bg/infomation"), i18n("world_expedition_reward_display"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateItem(arg1, arg2)
		end
	end)
end

function var0.UpdateItem(arg0, arg1, arg2)
	local var0 = arg0.awards[arg1 + 1]
	local var1 = arg2:Find("award")
	local var2 = {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}

	updateDrop(var1, var2)
	onButton(arg0, var1, function()
		arg0:emit(BaseUI.ON_DROP, var2)
	end, SFX_PANEL)
	setActive(arg2:Find("award/mask"), arg1 + 1 <= arg0.finishIndex)
	setText(arg2:Find("target/title"), arg0.targetTitle)
	setText(arg2:Find("target/Text"), arg1 + 1)
	setText(arg2:Find("title/Text"), "PHASE  " .. arg1 + 1)
end

function var0.Flush(arg0, arg1, arg2, arg3)
	arg0.awards = arg1
	arg0.finishIndex = arg2
	arg0.targetTitle = arg3[2]

	arg0.uiItemList:align(#arg0.awards)

	arg0.currentTitle.text = arg3[1]
	arg0.currentTxt.text = arg2

	arg0:Show()
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	return
end

return var0
