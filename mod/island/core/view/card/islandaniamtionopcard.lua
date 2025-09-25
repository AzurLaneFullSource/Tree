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

function var0_0.Update(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg1_3[1]
	local var1_3 = arg1_3[2]

	arg0_3.firstId = var0_3
	arg0_3.secondId = var1_3

	arg0_3:UpdateItem(arg0_3.item1, var0_3)
	arg0_3:UpdateItem(arg0_3.item2, var1_3)
	arg0_3:UpdateSelected(arg2_3)
	arg0_3:LoadingEffect(arg3_3)
	setActive(arg0_3.tipTr, false)
end

function var0_0.UpdateItem(arg0_4, arg1_4, arg2_4)
	setActive(arg1_4, arg2_4)

	if not arg2_4 then
		return
	end

	local var0_4 = pg.island_action[arg2_4]

	setText(arg1_4:Find("Text"), var0_4.name)
	setActive(arg1_4:Find("double"), var0_4.type == IslandConst.ANIMATION_OP_DOUBLE)
	LoadImageSpriteAsync("island/IslandActionIcon/" .. var0_4.resource, arg1_4:Find("icon"), true)
end

function var0_0.UpdateSelected(arg0_5, arg1_5)
	local var0_5 = arg0_5.firstId and arg1_5 == arg0_5.firstId
	local var1_5 = arg0_5.secondId and arg1_5 == arg0_5.secondId

	arg0_5:PlayAnimtion(var0_5, var1_5)
end

function var0_0.PlayAnimtion(arg0_6, arg1_6, arg2_6)
	if arg1_6 then
		arg0_6.animationItem1:Play("Anim_IslandActionOpUI_Selected")
	else
		arg0_6.animationItem1:Play("Anim_IslandActionOpUI_UnSelected")
	end

	if arg2_6 then
		arg0_6.animationItem2:Play("Anim_IslandActionOpUI_Selected")
	else
		arg0_6.animationItem2:Play("Anim_IslandActionOpUI_UnSelected")
	end
end

function var0_0.Clear(arg0_7, ...)
	arg0_7.animationItem1:Play("Anim_IslandActionOpUI_UnSelected")
	arg0_7.animationItem2:Play("Anim_IslandActionOpUI_UnSelected")
	LeanTween.cancel(go(arg0_7.item1TimeTr))
	LeanTween.cancel(go(arg0_7.item2TimeTr))
end

function var0_0.LoadingEffect(arg0_8, arg1_8)
	arg0_8:ClearLoadingEffect()

	if not arg1_8 then
		return
	end

	local var0_8 = arg0_8.firstId and arg1_8.id == arg0_8.firstId
	local var1_8 = arg0_8.secondId and arg1_8.id == arg0_8.secondId
	local var2_8

	if var0_8 then
		var2_8 = arg0_8.item1TimeTr
	elseif var1_8 then
		var2_8 = arg0_8.item2TimeTr
	end

	if not var2_8 then
		return
	end

	local var3_8 = arg1_8.startTime
	local var4_8 = arg1_8.endTime
	local var5_8 = var4_8 - var3_8
	local var6_8 = pg.TimeMgr.GetInstance():GetServerTime()
	local var7_8 = (var6_8 - var3_8) / var5_8
	local var8_8 = var4_8 - var6_8

	setActive(var2_8, true)
	LeanTween.value(go(var2_8), var7_8, 1, var8_8):setOnUpdate(System.Action_float(function(arg0_9)
		setFillAmount(var2_8, arg0_9)
	end)):setOnComplete(System.Action(function()
		setActive(var2_8, false)
	end))
end

function var0_0.ClearLoadingEffect(arg0_11)
	setActive(arg0_11.item1TimeTr, false)
	setActive(arg0_11.item2TimeTr, false)
	LeanTween.cancel(go(arg0_11.item1TimeTr))
	LeanTween.cancel(go(arg0_11.item2TimeTr))
end

function var0_0.Dispose(arg0_12)
	arg0_12:Clear()
end

return var0_0
