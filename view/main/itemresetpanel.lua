local var0 = class("ItemResetPanel")

var0.SINGLE = 1
var0.BATCH = 2
var0.INFO = 3
var0.SEE = 4

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._parent = arg2
	arg0._go = arg1
	arg0._tf = tf(arg1)

	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Close()
	end, SFX_PANEL)
	setActive(arg0._go, false)

	arg0.backBtn = arg0._tf:Find("window/top/btnBack")

	onButton(arg0, arg0.backBtn, function()
		arg0:Close()
	end, SFX_PANEL)

	arg0.infoPanel = arg0._tf:Find("window/panel/info")
	arg0.fromListPanel = arg0._tf:Find("window/panel/list")
	arg0.fromItemList = UIItemList.New(arg0.fromListPanel:Find("view/content"), arg0.fromListPanel:Find("view/content/item"))

	arg0.fromItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.infoList[arg1]

			setActive(arg2:Find("from"), var0)
			setActive(arg2:Find("nothing"), not var0)

			if var0 then
				setText(arg2:Find("from/Text"), pg.world_item_data_origin[var0].origin_text)
			end
		end
	end)
end

function var0.Open(arg0, arg1)
	arg0.itemVO = WorldItem.New(arg1)

	arg0:Update(arg0.itemVO)
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Close(arg0)
	arg0.itemVO = nil

	setActive(arg0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parent)
end

function var0.Update(arg0, arg1)
	local var0 = Drop.New({
		type = arg1.type,
		id = arg1.id,
		count = arg1.count
	})
	local var1

	if arg1:getConfig("item_transform_item_type") > 0 then
		var0.count = arg1:getConfig("item_transform_num")
		var1 = Drop.New({
			type = arg1:getConfig("item_transform_item_type"),
			id = arg1:getConfig("item_transform_item_id"),
			count = arg1:getConfig("item_transform_item_number")
		})
	end

	setText(arg0.infoPanel:Find("top_text"), i18n("world_item_recycle_" .. (var1 and 1 or 2)))
	setText(arg0.infoPanel:Find("bottom_text"), i18n("world_item_origin"))
	updateDrop(arg0.infoPanel:Find("before"), var0)
	updateDrop(arg0.infoPanel:Find("after"), defaultValue(var1, var0))
	setActive(arg0.infoPanel:Find("after/destroy_mask"), not var1)

	arg0.infoList = arg1:getConfig("item_origin")

	if #arg0.infoList == 0 then
		table.insert(arg0.infoList, 1)
	end

	arg0.fromItemList:align(math.max(#arg0.infoList, 3))
end

function var0.Dispose(arg0)
	arg0:Close()
	pg.DelegateInfo.Dispose(arg0)
end

return var0
