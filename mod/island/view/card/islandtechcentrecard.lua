local var0_0 = class("IslandTechCentreCard")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.lvTF = arg0_1._tf:Find("level/lv")
	arg0_1.lineTF = arg0_1._tf:Find("line")
	arg0_1.lockTF = arg0_1._tf:Find("lock")

	setText(arg0_1.lockTF:Find("Image/tip/Text"), i18n("island_tech_lock"))

	local var0_1 = arg0_1._tf:Find("items_view/content")

	arg0_1.uiList = UIItemList.New(var0_1, var0_1:Find("tpl"))

	arg0_1.uiList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg0_1:UpdateItem(arg1_2, arg2_2)
		end
	end)
end

function var0_0.UpdateItem(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3.ids[arg1_3 + 1]
	local var1_3 = getProxy(IslandProxy):GetIsland():GetTechnologyAgency():GetTechnology(var0_3)

	setText(arg2_3:Find("corner/Text"), var1_3:getConfig("tech_level"))
	LoadImageSpriteAsync("island/IslandTechnology/" .. var1_3:getConfig("tech_icon"), arg2_3:Find("icon"), true)
	setActive(arg2_3:Find("line"), arg1_3 + 1 ~= #arg0_3.ids)

	local var2_3 = var1_3:GetStatus()

	setActive(arg2_3:Find("receive"), var2_3 == IslandTechnology.STATUS.RECEIVE)
	setActive(arg2_3:Find("studying"), var2_3 == IslandTechnology.STATUS.STUDYING)

	local var3_3 = var2_3 == IslandTechnology.STATUS.STUDYING or var2_3 == IslandTechnology.STATUS.LOCK or var2_3 == IslandTechnology.STATUS.NORMAL and var1_3:GetFinishedCnt() == 0

	setImageAlpha(arg2_3:Find("icon"), var3_3 and 0.5 or 1)

	local var4_3 = arg2_3:GetComponent(typeof(Animation))

	if var2_3 == IslandTechnology.STATUS.NORMAL and var1_3:GetFinishedCnt() == 0 then
		var4_3:Play("anim_Island_technology_tplicon_in")
	elseif var2_3 == IslandTechnology.STATUS.STUDYING then
		var4_3:Play("anim_Island_technology_tplstudy_in")
	elseif var2_3 == IslandTechnology.STATUS.RECEIVE then
		var4_3:Play("anim_Island_technology_tplreceive_in")
	else
		var4_3:Stop()
	end

	onButton(arg0_3, arg2_3, function()
		existCall(arg0_3.onItemClick, var0_3)
	end, SFX_PANEL)
end

function var0_0.Update(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	arg0_5.ids = arg2_5
	arg0_5.onItemClick = arg5_5

	setText(arg0_5.lvTF, "LV." .. arg1_5)
	setActive(arg0_5.lineTF, not arg3_5)
	setActive(arg0_5.lockTF, arg4_5)
	arg0_5.uiList:align(#arg0_5.ids)
end

function var0_0.Dispose(arg0_6)
	pg.DelegateInfo.Dispose(arg0_6)
end

return var0_0
