local var0_0 = class("SkinDiscountItemExpireDisplayPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SkinDicountItemExpiredUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.confirmBtn = arg0_2:findTF("confirm_btn")
	arg0_2.tipTxt = arg0_2:findTF("title/label"):GetComponent(typeof(Text))
	arg0_2.leftList = UIItemList.New(arg0_2:findTF("left/scrollrect/list"), arg0_2:findTF("left/scrollrect/list/tpl"))
	arg0_2.rightList = UIItemList.New(arg0_2:findTF("right/scrollrect/list"), arg0_2:findTF("left/scrollrect/list/tpl"))

	setText(arg0_2.tipTxt, i18n("skin_discount_item_tran_tip"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5)
	arg0_5:InitLeftList(arg1_5)
	arg0_5:InitRightList(arg1_5)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.InitLeftList(arg0_6, arg1_6)
	local var0_6 = getProxy(BagProxy)
	local var1_6 = _.map(arg1_6, function(arg0_7)
		local var0_7 = var0_6:getItemCountById(arg0_7.id)

		return {
			DROP_TYPE_ITEM,
			arg0_7.id,
			var0_7
		}
	end)

	arg0_6.leftList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = var1_6[arg1_8 + 1]

			arg0_6:UpdateItem(var0_8, arg2_8)
		end
	end)
	arg0_6.leftList:align(#var1_6)
end

function var0_0.InitRightList(arg0_9, arg1_9)
	local var0_9 = getProxy(BagProxy):GetSellingPrice(arg1_9)

	arg0_9.rightList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg0_9:UpdateItem(var0_9[arg1_10 + 1], arg2_10)
		end
	end)
	arg0_9.rightList:align(#var0_9)
end

function var0_0.UpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = Drop.Create(arg1_11)

	updateDrop(arg2_11, var0_11)
	setScrollText(arg2_11:Find("name_bg/Text"), var0_11:getName())
	onButton(arg0_11, arg2_11, function()
		pg.m02:sendNotification(NewMainMediator.ON_DROP, var0_11)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_13)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_13._tf, pg.UIMgr.GetInstance()._normalUIMain)
end

return var0_0
