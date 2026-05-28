local var0_0 = class("MallStaffCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.iconTF = arg0_1._tf:Find("icon")
	arg0_1.nameText = arg0_1._tf:Find("name"):GetComponent(typeof(Text))
	arg0_1.selTF = arg0_1._tf:Find("sel")
	arg0_1.orderTF = arg0_1._tf:Find("mask/order")

	setText(arg0_1.orderTF:Find("Text"), i18n("mall_staff_in_order"))

	arg0_1.floorTF = arg0_1._tf:Find("mask/floor")
	arg0_1.attrTextTFs = {
		arg0_1._tf:Find("attrs/1/Text"),
		arg0_1._tf:Find("attrs/2/Text"),
		arg0_1._tf:Find("attrs/3/Text")
	}
	arg0_1.attrBgTFs = {
		arg0_1._tf:Find("attrs/1"),
		arg0_1._tf:Find("attrs/2"),
		arg0_1._tf:Find("attrs/3")
	}
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.staff = arg1_2
	arg0_2.id = arg0_2.staff.id
	arg0_2.tid = arg0_2.staff.tid

	local var0_2 = pg.item_virtual_data_statistics[arg0_2.tid].name

	arg0_2.nameText.text = var0_2

	var0_0.StaticUpdateIcon(arg0_2.iconTF, arg0_2.tid)

	arg0_2.attrList = arg0_2.staff:GetAttrList()

	local var1_2

	var1_2 = arg4_2 or {}

	for iter0_2, iter1_2 in ipairs(arg0_2.attrList) do
		setText(arg0_2.attrTextTFs[iter0_2], iter1_2)

		if table.contains(arg4_2, iter0_2) then
			GetImageSpriteFromAtlasAsync("ui/mallstafftpl_atlas", "attr_bg2", arg0_2.attrBgTFs[iter0_2], true)
		else
			GetImageSpriteFromAtlasAsync("ui/mallstafftpl_atlas", "attr_bg1", arg0_2.attrBgTFs[iter0_2], true)
		end
	end

	local var2_2 = table.indexof(arg2_2, arg0_2.id)

	setActive(arg0_2.selTF, var2_2)

	if var2_2 then
		setText(arg0_2.selTF:Find("Text"), var2_2)
	end

	local var3_2, var4_2 = arg0_2.staff:GetStatusInfos()

	setActive(arg0_2.orderTF, var3_2 == MallStaff.STATUS.ORDER)
	setActive(arg0_2.floorTF, var3_2 == MallStaff.STATUS.FLOOR and (arg3_2 and not var2_2 or not arg3_2))

	if var3_2 == MallStaff.STATUS.FLOOR then
		setText(arg0_2.floorTF:Find("Text"), i18n("mall_staff_in_floor", var4_2.floorId))
	end
end

function var0_0.Dispose(arg0_3)
	return
end

function var0_0.StaticUpdateIcon(arg0_4, arg1_4)
	local var0_4 = pg.activity_mall_staff_template[arg1_4].icon_show

	GetImageSpriteFromAtlasAsync("ui/mallstafftpl_atlas", var0_4[1], arg0_4:Find("body"))
	GetImageSpriteFromAtlasAsync("ui/mallstafftpl_atlas", var0_4[2], arg0_4:Find("clothes"))
	GetImageSpriteFromAtlasAsync("ui/mallstafftpl_atlas", var0_4[3], arg0_4:Find("face"))
end

return var0_0
