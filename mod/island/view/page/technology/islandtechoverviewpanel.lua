local var0_0 = class("IslandTechOverviewPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandTechOverviewPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.toggle = arg0_2._tf:Find("toggle")
	arg0_2.panel = arg0_2._tf:Find("panel")
end

function var0_0.OnInit(arg0_3)
	arg0_3.config = pg.island_technology_template
	arg0_3.types = underscore.keys(IslandTechBelong.Fields)

	table.sort(arg0_3.types)

	local var0_3 = arg0_3.panel:Find("content")

	arg0_3.uiList = UIItemList.New(var0_3, var0_3:Find("tpl"))

	arg0_3.uiList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			arg2_4.name = arg0_3.types[arg1_4 + 1]

			arg0_3:InitItem(arg1_4, arg2_4)
		elseif arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_4, arg2_4)
		end
	end)

	arg0_3.uiListDic = {}

	arg0_3:Flush()
	onToggle(arg0_3, arg0_3.toggle, function(arg0_5)
		if arg0_5 then
			pg.UIMgr.GetInstance():OverlayPanelPB(arg0_3._tf, {
				pbList = {
					arg0_3.panel
				},
				groupName = LayerWeightConst.GROUP_DORM3D
			})
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_3._tf, arg0_3._parentTf)
		end
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_6)
	arg0_6.techAgency = getProxy(IslandProxy):GetIsland():GetTechnologyAgency()
	arg0_6.type2Ids = {}

	for iter0_6, iter1_6 in ipairs(arg0_6.types) do
		local var0_6 = underscore.select(arg0_6.config.get_id_list_by_tech_belong[iter1_6], function(arg0_7)
			return arg0_6.techAgency:IsFinishedTech(arg0_7)
		end)

		arg0_6.type2Ids[iter1_6] = var0_6
	end

	arg0_6.uiList:align(#arg0_6.types)
end

function var0_0.InitItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.types[arg1_8 + 1]

	arg2_8.name = var0_8

	local var1_8 = arg2_8:Find("view/content")
	local var2_8 = UIItemList.New(var1_8, var1_8:Find("tpl"))

	var2_8:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_8:UpdateInfo(arg1_9, arg2_9, var0_8)
		end
	end)

	arg0_8.uiListDic[var0_8] = var2_8
end

function var0_0.UpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.types[arg1_10 + 1]
	local var1_10 = arg0_10.techAgency:GetPctByType(var0_10)

	setText(arg2_10:Find("toggle/content/Text"), string.format("%s %d%%", IslandTechBelong.Names[var0_10], var1_10))
	arg0_10.uiListDic[var0_10]:align(#arg0_10.type2Ids[var0_10])
end

function var0_0.UpdateInfo(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg0_11.type2Ids[arg3_11][arg1_11 + 1]

	setText(arg2_11:Find("name"), arg0_11.config[var0_11].tech_name)
	setText(arg2_11:Find("lv"), arg0_11.config[var0_11].tech_level)
	LoadImageSpriteAsync("islandtechnology/" .. arg0_11.config[var0_11].tech_icon, arg2_11:Find("icon"))
	setActive(arg2_11:Find("bg"), arg1_11 % 2 == 0)
end

function var0_0.OffToggle(arg0_12)
	triggerToggle(arg0_12.toggle, false)
end

function var0_0.Hide(arg0_13)
	arg0_13:OffToggle()
	var0_0.super.Hide(arg0_13)
end

function var0_0.OnDestroy(arg0_14)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf, arg0_14._parentTf)
end

return var0_0
