local var0_0 = class("ItemRecycleConfirmationPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ItemRecycleConfirmationUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.cancelBtn = arg0_2:findTF("window/button_container/cancel")
	arg0_2.confirmBtn = arg0_2:findTF("window/button_container/confirm")
	arg0_2.content = arg0_2:findTF("window/single_item_panel/Text")
	arg0_2.itemTpl = arg0_2:findTF("window/single_item_panel/left")
	arg0_2.resTpl = arg0_2:findTF("window/single_item_panel/right")
	arg0_2.itemName = arg0_2.itemTpl:Find("name_bg/Text"):GetComponent(typeof(Text))
	arg0_2.resName = arg0_2.resTpl:Find("name_bg/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("window/top/bg/infomation/title"), i18n("words_information"))
	setText(arg0_2:findTF("window/button_container/cancel/pic"), i18n("word_cancel"))
	setText(arg0_2:findTF("window/button_container/confirm/pic"), i18n("word_ok"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.itemId then
			pg.m02:sendNotification(GAME.SELL_ITEM, {
				items = {
					{
						count = 1,
						id = arg0_3.itemId
					}
				}
			})
		end
	end, SFX_PANEL)
end

function var0_0.SetCallback(arg0_8, arg1_8, arg2_8)
	arg0_8.onShowFunc = arg1_8
	arg0_8.onHideFunc = arg2_8
end

function var0_0.Hide(arg0_9)
	var0_0.super.Hide(arg0_9)

	if arg0_9.onHideFunc then
		arg0_9.onHideFunc()
	end
end

function var0_0.Show(arg0_10, arg1_10)
	var0_0.super.Show(arg0_10)

	arg0_10.itemId = arg1_10.itemId

	setText(arg0_10.content, arg1_10.content)
	arg0_10:UpdateItem()
	arg0_10:UpdateResource()

	if arg0_10.onShowFunc then
		arg0_10.onShowFunc()
	end
end

function var0_0.UpdateItem(arg0_11)
	local var0_11 = arg0_11.itemId
	local var1_11 = Drop.Create({
		DROP_TYPE_ITEM,
		var0_11,
		1
	})

	updateDrop(arg0_11.itemTpl, var1_11)

	arg0_11.itemName.text = shortenString(var1_11:getName(), 5)
end

function var0_0.UpdateResource(arg0_12)
	local var0_12 = arg0_12.itemId
	local var1_12 = Item.New({
		id = var0_12
	}):GetPrice() or {
		1,
		0
	}
	local var2_12 = Drop.Create({
		DROP_TYPE_RESOURCE,
		var1_12[1],
		var1_12[2]
	})

	updateDrop(arg0_12.resTpl, var2_12)

	arg0_12.resName.text = shortenString(var2_12:getName(), 5)
end

function var0_0.OnDestroy(arg0_13)
	arg0_13:SetCallback(nil, nil)
end

return var0_0
