local var0_0 = class("IslandItemCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.nameTxt = arg0_1._tf:Find("name_bg/name"):GetComponent(typeof(Text))
	arg0_1.cntTxt = arg0_1._tf:Find("icon_bg/count_bg/count"):GetComponent(typeof(Text))
	arg0_1.calcPanel = arg0_1._tf:Find("calc")
	arg0_1.reduceBtn = arg0_1._tf:Find("calc/btn")
	arg0_1.valueInput = arg0_1.calcPanel:Find("InputField")
	arg0_1.mask = arg0_1._tf:Find("mask")
	arg0_1.maskTxt = arg0_1.mask:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.item = arg1_2
	arg0_2.nameTxt.text = arg0_2:ShortenString(arg1_2:GetName(), 6)

	updateCustomDrop(arg0_2._tf, Drop.New({
		type = DROP_TYPE_ISLAND_ITEM,
		id = arg1_2.id,
		count = arg1_2:GetCount()
	}))

	local var0_2 = arg2_2 == IslandInventoryPage.MODE_EDIT

	setActive(arg0_2.calcPanel, var0_2)

	if var0_2 then
		arg0_2:UpdateValue(arg3_2)
	end

	arg0_2:UpdateTip(arg1_2, arg4_2)
end

function var0_0.UpdateTip(arg0_3, arg1_3, arg2_3)
	if arg2_3 ~= IslandInventoryPage.INVENTORY_TYPE_OVERFLOW then
		setActive(arg0_3.mask, false)

		return
	end

	setActive(arg0_3.mask, true)

	local var0_3 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	arg0_3.maskTxt.text = var0_3:OwnItem() and i18n("island_item_overflow", arg1_3:GetCount()) or i18n("island_item_no_capacity")
end

function var0_0.UpdateValue(arg0_4, arg1_4)
	setActive(arg0_4.calcPanel, arg1_4 > 0)
	setInputText(arg0_4.valueInput, arg1_4)
end

function var0_0.Dispose(arg0_5)
	return
end

function var0_0.ShortenString(arg0_6, arg1_6, arg2_6)
	local var0_6 = 1
	local var1_6 = 0
	local var2_6 = 0
	local var3_6 = #arg1_6
	local var4_6 = false

	while var0_6 <= var3_6 do
		local var5_6 = string.byte(arg1_6, var0_6)
		local var6_6, var7_6 = GetPerceptualSize(var5_6)

		var0_6 = var0_6 + var6_6
		var1_6 = var1_6 + var7_6

		local var8_6 = math.ceil(var1_6)

		if var8_6 == arg2_6 - 1 then
			var2_6 = var0_6
		elseif arg2_6 < var8_6 then
			var4_6 = true

			break
		end
	end

	if var2_6 == 0 or var3_6 < var2_6 or not var4_6 then
		return arg1_6
	end

	return string.sub(arg1_6, 1, var2_6 - 1) .. ".."
end

return var0_0
