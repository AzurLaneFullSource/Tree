local var0_0 = class("IslandShipOrderLoadUpPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandShipOrderLoadUpUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.itemTr = arg0_2:findTF("award")
	arg0_2.cntTxt = arg0_2:findTF("count/Text"):GetComponent(typeof(Text))
	arg0_2.uiAwardList = UIItemList.New(arg0_2:findTF("list"), arg0_2:findTF("list/tpl"))
	arg0_2.submitBtn = arg0_2:findTF("btn")

	setText(arg0_2:findTF("title/Text"), i18n1("装载奖励"))
	setText(arg0_2:findTF("btn/Text"), i18n1("装载"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.submitBtn, function()
		if not arg0_3.slot or not arg0_3.index then
			return
		end

		arg0_3:emit(IslandMediator.SUBMIT_SHIP_ORDER_ITME, arg0_3.slot.id, arg0_3.index)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5, arg2_5, arg3_5)
	var0_0.super.Show(arg0_5)

	arg0_5.slot = arg2_5
	arg0_5.index = arg3_5
	arg0_5._tf.localPosition = arg1_5

	local var0_5 = arg2_5:GetOrder():GetComsume(arg3_5)
	local var1_5 = Drop.New(var0_5)

	updateDrop(arg0_5.itemTr, var1_5)

	arg0_5.cntTxt.text = var1_5:getOwnedCount() .. "/" .. var1_5.count

	arg0_5:UpdateAwards(arg2_5, arg3_5)
end

function var0_0.UpdateAwards(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetOrder():GetConsumeAwards(arg2_6)

	arg0_6.uiAwardList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = Drop.New(var0_6[arg1_7 + 1])

			GetImageSpriteFromAtlasAsync(var0_7.cfg.icon, "", arg2_7:Find("icon"))
			setText(arg2_7:Find("Text"), "X" .. var0_7.count)
		end
	end)
	arg0_6.uiAwardList:align(#var0_6)
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
