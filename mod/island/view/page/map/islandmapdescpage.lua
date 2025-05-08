local var0_0 = class("IslandMapDescPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandMapDescUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameTxt = arg0_2:findTF("frame/title/name/Text"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0_2.goBtn = arg0_2:findTF("frame/go")
	arg0_2.uiProductionList = UIItemList.New(arg0_2:findTF("frame/list"), arg0_2:findTF("frame/list/tpl"))
	arg0_2.iconTr = arg0_2:findTF("frame/icon")
	arg0_2.fullMark = arg0_2:findTF("frame/icon/tag")

	setText(arg0_2:findTF("frame/go/Text"), i18n1("前往"))

	arg0_2.timers = {}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(IslandMapPage.HIDE_DESC)
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5, arg1_5)
	local var0_5 = pg.island_map[arg1_5]

	arg0_5.nameTxt.text = var0_5.name
	arg0_5.descTxt.text = var0_5.desc

	GetImageSpriteFromAtlasAsync("IslandMapIcon/" .. arg1_5, "", arg0_5.iconTr)
	onButton(arg0_5, arg0_5.goBtn, function()
		arg0_5:emit(IslandMediator.SWITCH_MAP, arg1_5, var0_5.born_object)
		arg0_5:ClosePage(IslandMapPage)
	end, SFX_PANEL)
	setActive(arg0_5.fullMark, false)
	arg0_5:UpdateProductionList(arg1_5)
end

function var0_0.UpdateProductionList(arg0_7, arg1_7)
	local var0_7 = pg.island_production_place.get_id_list_by_map_id[arg1_7] or {}
	local var1_7 = {}

	for iter0_7, iter1_7 in pairs(var0_7) do
		local var2_7 = pg.island_production_place[iter1_7]

		table.insert(var1_7, var2_7)
	end

	arg0_7.uiProductionList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = var1_7[arg1_8 + 1]

			GetImageSpriteFromAtlasAsync("IslandMapRes", var0_8.id, arg2_8)
			setText(arg2_8:Find("Text"), var0_8.name)
			arg0_7:AddTimer(arg2_8, var0_8)
		end
	end)
	arg0_7.uiProductionList:align(#var1_7)
end

function var0_0.AddTimer(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9:Find("full")

	setActive(var0_9, false)
	arg0_9:RemoveTimer(arg2_9.id)

	local var1_9 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg2_9.id)
	local var2_9 = var1_9 and var1_9:GetMinRoleDeleGationTime() or -1

	if var2_9 < 0 then
		return
	end

	local var3_9 = pg.TimeMgr.GetInstance():GetServerTime()

	if var2_9 <= var3_9 then
		setActive(var0_9, true)
		arg0_9:UpdateAnyFullMark()

		return
	end

	local var4_9 = var2_9 - var3_9

	arg0_9.timers[arg2_9.id] = Timer.New(function()
		setActive(var0_9, true)
		arg0_9:UpdateAnyFullMark()
		arg0_9:RemoveTimer(arg2_9.id)
	end, var4_9, 1)

	arg0_9.timers[arg2_9.id]:Start()
end

function var0_0.UpdateAnyFullMark(arg0_11)
	setActive(arg0_11.fullMark, true)
end

function var0_0.RemoveTimer(arg0_12, arg1_12)
	if arg0_12.timers[arg1_12] then
		arg0_12.timers[arg1_12]:Stop()

		arg0_12.timers[arg1_12] = nil
	end
end

function var0_0.OnHide(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.timers) do
		iter1_13:Stop()
	end

	arg0_13.timers = {}
end

return var0_0
