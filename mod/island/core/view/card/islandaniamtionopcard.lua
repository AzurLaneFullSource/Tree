local var0_0 = class("IslandAniamtionOpCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.tipTr = arg0_1._tf:Find("tip")
	arg0_1.cutoffTr = arg0_1._tf:Find("cut_off ")
	arg0_1.item1 = arg0_1._tf:Find("1/main")
	arg0_1.item2 = arg0_1._tf:Find("2/main")
	arg0_1.layoutElement = arg0_1._tf:GetComponent(typeof(LayoutElement))
	arg0_1.baseHeight = arg0_1.layoutElement.preferredHeight
	arg0_1.cutOffHeight = arg0_1.cutoffTr:GetComponent(typeof(LayoutElement)).preferredHeight
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg1_2[1]
	local var1_2 = arg1_2[2]

	arg0_2.firstId = var0_2
	arg0_2.secondId = var1_2

	arg0_2:UpdateItem(arg0_2.item1, var0_2)
	arg0_2:UpdateItem(arg0_2.item2, var1_2)
	arg0_2:UpdateSelected(arg2_2)
	setActive(arg0_2.tipTr, false)

	local var2_2 = var0_2 and var0_2 == arg3_2 or var1_2 and var1_2 == arg3_2

	setActive(arg0_2.cutoffTr, var2_2)

	arg0_2.layoutElement.preferredHeight = var2_2 and arg0_2.baseHeight + arg0_2.cutOffHeight or arg0_2.baseHeight
end

function var0_0.UpdateItem(arg0_3, arg1_3, arg2_3)
	setActive(arg1_3, arg2_3)

	if not arg2_3 then
		return
	end

	local var0_3 = pg.island_action[arg2_3]

	setText(arg1_3:Find("Text"), var0_3.name)
	setActive(arg1_3:Find("double"), var0_3.type == IslandConst.ANIMATION_OP_DOUBLE)

	if var0_3.resource ~= arg0_3.resource then
		LoadImageSpriteAsync("island/IslandActionIcon/" .. var0_3.resource, arg1_3:Find("icon"), true)

		arg0_3.resource = var0_3.resource
	end
end

function var0_0.UpdateSelected(arg0_4, arg1_4)
	setActive(arg0_4.item1:Find("sel"), arg0_4.firstId and arg1_4 == arg0_4.firstId)
	setActive(arg0_4.item2:Find("sel"), arg0_4.secondId and arg1_4 == arg0_4.secondId)
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
