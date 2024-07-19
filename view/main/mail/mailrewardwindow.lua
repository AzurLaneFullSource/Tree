local var0_0 = class("MailRewardWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MailRewardMsgboxUI"
end

function var0_0.OnInit(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.closeBtn = arg0_2:findTF("adapt/window/top/btnBack")

	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.cancelButton = arg0_2:findTF("adapt/window/button_container/btn_not")
	arg0_2.confirmButton = arg0_2:findTF("adapt/window/button_container/btn_ok")
	arg0_2._window = arg0_2._tf:Find("adapt/window")
	arg0_2.item_panel = arg0_2._window:Find("item_panel")
	arg0_2.reward_gold = arg0_2.item_panel:Find("parentAdpter/textAdpter/reward_gold")
	arg0_2.reward_goldText = arg0_2.reward_gold:Find("gold_text")
	arg0_2.reward_oil = arg0_2.item_panel:Find("parentAdpter/textAdpter/reward_oil")
	arg0_2.reward_oilText = arg0_2.reward_oil:Find("oil_text")
	arg0_2._itemListItemContainer = arg0_2.item_panel:Find("parentAdpter/rewardAdpter/list")
	arg0_2._itemListItemTpl = arg0_2.item_panel:Find("parentAdpter/rewardAdpter/item")
	arg0_2.titleTips = arg0_2._window:Find("top/bg/infomation/title")

	setText(arg0_2.reward_goldText, i18n("mail_storeroom_max_4"))
	setText(arg0_2.reward_oilText, i18n("mail_storeroom_max_3"))
	setText(arg0_2.titleTips, i18n("mail_boxtitle_information"))
	setText(arg0_2.item_panel:Find("parentAdpter/rewardAdpter/Text"), i18n("mail_storeroom_collect"))
	setText(arg0_2.cancelButton:Find("Text"), i18n("mail_box_cancel"))
	setText(arg0_2.confirmButton:Find("Text"), i18n("mail_box_confirm"))
end

function var0_0.Show(arg0_5, arg1_5)
	var0_0.super.Show(arg0_5)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
	onButton(arg0_5, arg0_5.cancelButton, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.confirmButton, function()
		arg0_5:Hide()

		if arg1_5.onYes then
			arg1_5.onYes()
		end
	end, SFX_PANEL)

	local var0_5 = getProxy(PlayerProxy):getData()
	local var1_5 = false
	local var2_5 = false
	local var3_5 = {}

	if arg1_5.content.oil > 0 then
		table.insert(var3_5, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResOil,
			count = arg1_5.content.oil
		}))

		var2_5 = var0_5:getResource(PlayerConst.ResOil) + arg1_5.content.oil >= var0_5:getLevelMaxOil()
	end

	if arg1_5.content.gold > 0 then
		table.insert(var3_5, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold,
			count = arg1_5.content.gold
		}))

		var1_5 = var0_5:getResource(PlayerConst.ResGold) + arg1_5.content.gold >= var0_5:getLevelMaxGold()
	end

	setActive(arg0_5.reward_oil, var2_5)
	setActive(arg0_5.reward_gold, var1_5)

	local var4_5 = var1_5 or var2_5

	setActive(arg0_5.item_panel:Find("parentAdpter/textAdpter"), var4_5)
	UIItemList.StaticAlign(arg0_5._itemListItemContainer, arg0_5._itemListItemTpl, #var3_5, function(arg0_8, arg1_8, arg2_8)
		arg1_8 = arg1_8 + 1

		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = var3_5[arg1_8]

			updateDrop(arg2_8:Find("IconTpl"), var0_8)
		end
	end)

	local var5_5 = var4_5 and 17 or 32
	local var6_5 = arg0_5.item_panel:Find("parentAdpter"):GetComponent(typeof(UnityEngine.UI.HorizontalOrVerticalLayoutGroup))
	local var7_5 = UnityEngine.RectOffset.New()

	var7_5.bottom = 0
	var7_5.left = 0
	var7_5.right = 0
	var7_5.top = var5_5
	var6_5.padding = var7_5

	Canvas.ForceUpdateCanvases()
end

function var0_0.Hide(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, arg0_9._parentTf)
	var0_0.super.Hide(arg0_9)
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10:isShowing() then
		arg0_10:Hide()
	end
end

return var0_0
