local var0_0 = class("IslandAniamtionOpCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.tipTr = arg0_1._tf:Find("tip")
	arg0_1.cutoffTr = arg0_1._tf:Find("cut_off ")
	arg0_1.item1 = arg0_1._tf:Find("1/main")
	arg0_1.item2 = arg0_1._tf:Find("2/main")
	arg0_1.item1TimeTr = arg0_1.item1:Find("time")
	arg0_1.item2TimeTr = arg0_1.item2:Find("time")
	arg0_1.item1MarkTr = arg0_1.item1:Find("mark")
	arg0_1.item2MarkTr = arg0_1.item2:Find("mark")

	setActive(arg0_1.item1TimeTr, false)
	setActive(arg0_1.item2TimeTr, false)

	arg0_1.layoutElement = arg0_1._tf:GetComponent(typeof(LayoutElement))
	arg0_1.baseHeight = arg0_1.layoutElement.preferredHeight
	arg0_1.cutOffHeight = arg0_1.cutoffTr:GetComponent(typeof(LayoutElement)).preferredHeight
	arg0_1.animationItem1 = arg0_1._tf:Find("1"):GetComponent(typeof(Animation))
	arg0_1.animationItem2 = arg0_1._tf:Find("2"):GetComponent(typeof(Animation))
end

function var0_0.Contains(arg0_2, arg1_2)
	return arg0_2.firstId == arg1_2 or arg0_2.secondId == arg1_2
end

function var0_0.Update(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = arg1_3[1]
	local var1_3 = arg1_3[2]

	arg0_3.firstId = var0_3
	arg0_3.secondId = var1_3

	arg0_3:UpdateItem(arg0_3.item1, var0_3)
	arg0_3:UpdateItem(arg0_3.item2, var1_3)
	arg0_3:UpdateSelected(arg2_3)
	arg0_3:LoadingEffect(arg3_3)
	arg0_3:UpdateMards(arg4_3)
	setActive(arg0_3.tipTr, false)
end

function var0_0.UpdateMards(arg0_4, arg1_4)
	setActive(arg0_4.item1MarkTr, arg1_4 == arg0_4.firstId)
	setActive(arg0_4.item2MarkTr, arg1_4 == arg0_4.secondId)
end

function var0_0.UpdateItem(arg0_5, arg1_5, arg2_5)
	setActive(arg1_5, arg2_5)

	if not arg2_5 then
		return
	end

	local var0_5 = pg.island_action[arg2_5]

	setText(arg1_5:Find("Text"), var0_5.name)
	setActive(arg1_5:Find("double"), var0_5.type == IslandConst.ANIMATION_OP_DOUBLE)
	LoadImageSpriteAsync("island/IslandActionIcon/" .. var0_5.resource, arg1_5:Find("icon"), true)
end

function var0_0.UpdateSelected(arg0_6, arg1_6)
	local var0_6 = arg0_6.firstId and arg1_6 == arg0_6.firstId
	local var1_6 = arg0_6.secondId and arg1_6 == arg0_6.secondId

	arg0_6:PlayAnimtion(var0_6, var1_6)
end

function var0_0.PlayAnimtion(arg0_7, arg1_7, arg2_7)
	if arg1_7 then
		arg0_7.animationItem1:Play("Anim_IslandActionOpUI_Selected")
	else
		arg0_7.animationItem1:Play("Anim_IslandActionOpUI_UnSelected")
	end

	if arg2_7 then
		arg0_7.animationItem2:Play("Anim_IslandActionOpUI_Selected")
	else
		arg0_7.animationItem2:Play("Anim_IslandActionOpUI_UnSelected")
	end
end

function var0_0.Clear(arg0_8, ...)
	arg0_8.animationItem1:Play("Anim_IslandActionOpUI_UnSelected")
	arg0_8.animationItem2:Play("Anim_IslandActionOpUI_UnSelected")
	LeanTween.cancel(go(arg0_8.item1TimeTr))
	LeanTween.cancel(go(arg0_8.item2TimeTr))
end

function var0_0.LoadingEffect(arg0_9, arg1_9)
	arg0_9:ClearLoadingEffect()

	if not arg1_9 then
		return
	end

	local var0_9 = arg0_9.firstId and arg1_9.id == arg0_9.firstId
	local var1_9 = arg0_9.secondId and arg1_9.id == arg0_9.secondId
	local var2_9

	if var0_9 then
		var2_9 = arg0_9.item1TimeTr
	elseif var1_9 then
		var2_9 = arg0_9.item2TimeTr
	end

	if not var2_9 then
		return
	end

	local var3_9 = arg1_9.startTime
	local var4_9 = arg1_9.endTime
	local var5_9 = var4_9 - var3_9
	local var6_9 = pg.TimeMgr.GetInstance():GetServerTime()
	local var7_9 = (var6_9 - var3_9) / var5_9
	local var8_9 = var4_9 - var6_9

	setActive(var2_9, true)
	LeanTween.value(go(var2_9), var7_9, 1, var8_9):setOnUpdate(System.Action_float(function(arg0_10)
		setFillAmount(var2_9, arg0_10)
	end)):setOnComplete(System.Action(function()
		setActive(var2_9, false)
	end))
end

function var0_0.ClearLoadingEffect(arg0_12)
	setActive(arg0_12.item1TimeTr, false)
	setActive(arg0_12.item2TimeTr, false)
	LeanTween.cancel(go(arg0_12.item1TimeTr))
	LeanTween.cancel(go(arg0_12.item2TimeTr))
end

function var0_0.Dispose(arg0_13)
	arg0_13:Clear()
end

return var0_0
