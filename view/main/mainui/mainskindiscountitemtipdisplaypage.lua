local var0_0 = class("MainSkinDiscountItemTipDisplayPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MainSkinDiscountItemTipUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.cancelBtn = arg0_2:findTF("window/btn_cancel")
	arg0_2.goBtn = arg0_2:findTF("window/btn_go")
	arg0_2.helpBtn = arg0_2:findTF("window/btn_help")
	arg0_2.remindBtn = arg0_2:findTF("window/stopRemind")
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("window/item_panel/scrollview/list"), arg0_2:findTF("window/item_panel/scrollview/list/tpl"))

	setText(arg0_2:findTF("window/item_panel/label/Text"), i18n("skin_discount_item_expired_tip"))
	setText(arg0_2:findTF("window/stopRemind/Label"), i18n("skin_discount_item_repeat_remind_label"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.skin_discount_item_notice.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.goBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE)
		arg0_3:Destroy()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.remindBtn, function(arg0_8)
		if arg0_8 then
			arg0_3:MarkRemind()
		else
			arg0_3:UnMarkRemind()
		end
	end, SFX_PANEl)
	triggerToggle(arg0_3.remindBtn, true)
end

function var0_0.MarkRemind(arg0_9)
	local var0_9 = GetZeroTime() + 1
	local var1_9 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString("SkinDiscountItemTip" .. var1_9, var0_9)
	PlayerPrefs.Save()
end

function var0_0.UnMarkRemind(arg0_10)
	local var0_10 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.DeleteKey("SkinDiscountItemTip" .. var0_10)
	PlayerPrefs.Save()
end

function var0_0.Show(arg0_11, arg1_11)
	arg0_11:UpdateList(arg1_11)
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.UpdateList(arg0_12, arg1_12)
	arg0_12.uiItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			arg0_12:UpdateItem(arg1_12[arg1_13 + 1], arg2_13)
		end
	end)
	arg0_12.uiItemList:align(#arg1_12)
end

function var0_0.UpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = Drop.Create({
		DROP_TYPE_ITEM,
		arg1_14.id,
		arg1_14.count
	})

	updateDrop(arg2_14, var0_14)
	setScrollText(arg2_14:Find("name_bg/Text"), var0_14:getName())
	onButton(arg0_14, arg2_14, function()
		pg.m02:sendNotification(NewMainMediator.ON_DROP, var0_14)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_16)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf, pg.UIMgr.GetInstance()._normalUIMain)
end

return var0_0
