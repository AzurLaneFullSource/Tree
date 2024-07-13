local var0_0 = class("ItemResetPanel")

var0_0.SINGLE = 1
var0_0.BATCH = 2
var0_0.INFO = 3
var0_0.SEE = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._parent = arg2_1
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)

	onButton(arg0_1, arg0_1._tf:Find("bg"), function()
		arg0_1:Close()
	end, SFX_PANEL)
	setActive(arg0_1._go, false)

	arg0_1.backBtn = arg0_1._tf:Find("window/top/btnBack")

	onButton(arg0_1, arg0_1.backBtn, function()
		arg0_1:Close()
	end, SFX_PANEL)

	arg0_1.infoPanel = arg0_1._tf:Find("window/panel/info")
	arg0_1.fromListPanel = arg0_1._tf:Find("window/panel/list")
	arg0_1.fromItemList = UIItemList.New(arg0_1.fromListPanel:Find("view/content"), arg0_1.fromListPanel:Find("view/content/item"))

	arg0_1.fromItemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_1.infoList[arg1_4]

			setActive(arg2_4:Find("from"), var0_4)
			setActive(arg2_4:Find("nothing"), not var0_4)

			if var0_4 then
				setText(arg2_4:Find("from/Text"), pg.world_item_data_origin[var0_4].origin_text)
			end
		end
	end)
end

function var0_0.Open(arg0_5, arg1_5)
	arg0_5.itemVO = WorldItem.New(arg1_5)

	arg0_5:Update(arg0_5.itemVO)
	setActive(arg0_5._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
end

function var0_0.Close(arg0_6)
	arg0_6.itemVO = nil

	setActive(arg0_6._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_6._tf, arg0_6._parent)
end

function var0_0.Update(arg0_7, arg1_7)
	local var0_7 = Drop.New({
		type = arg1_7.type,
		id = arg1_7.id,
		count = arg1_7.count
	})
	local var1_7

	if arg1_7:getConfig("item_transform_item_type") > 0 then
		var0_7.count = arg1_7:getConfig("item_transform_num")
		var1_7 = Drop.New({
			type = arg1_7:getConfig("item_transform_item_type"),
			id = arg1_7:getConfig("item_transform_item_id"),
			count = arg1_7:getConfig("item_transform_item_number")
		})
	end

	setText(arg0_7.infoPanel:Find("top_text"), i18n("world_item_recycle_" .. (var1_7 and 1 or 2)))
	setText(arg0_7.infoPanel:Find("bottom_text"), i18n("world_item_origin"))
	updateDrop(arg0_7.infoPanel:Find("before"), var0_7)
	updateDrop(arg0_7.infoPanel:Find("after"), defaultValue(var1_7, var0_7))
	setActive(arg0_7.infoPanel:Find("after/destroy_mask"), not var1_7)

	arg0_7.infoList = arg1_7:getConfig("item_origin")

	if #arg0_7.infoList == 0 then
		table.insert(arg0_7.infoList, 1)
	end

	arg0_7.fromItemList:align(math.max(#arg0_7.infoList, 3))
end

function var0_0.Dispose(arg0_8)
	arg0_8:Close()
	pg.DelegateInfo.Dispose(arg0_8)
end

return var0_0
