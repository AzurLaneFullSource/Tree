local var0_0 = class("IslandAchvDetailPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandAchvDetailUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_achievement_title"))
	setText(arg0_2._tf:Find("top/total/Text"), i18n("island_achv_total"))

	arg0_2.totalTF = arg0_2._tf:Find("top/total/value")

	local var0_2 = arg0_2._tf:Find("toggles/content")

	arg0_2.typeUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	local var1_2 = arg0_2._tf:Find("view/content")

	arg0_2.itemUIList = UIItemList.New(var1_2, var1_2:Find("tpl"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.typeUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			arg0_3:InitToggle(arg1_5, arg2_5)
		elseif arg0_5 == UIItemList.EventUpdate then
			arg0_3:UpdateToggle(arg1_5, arg2_5)
		end
	end)

	arg0_3.typeIds = pg.island_achievement_group.all

	arg0_3.itemUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_6, arg2_6)
		end
	end)
end

function var0_0.InitToggle(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.typeIds[arg1_7 + 1]

	arg2_7.name = var0_7

	local var1_7 = pg.island_achievement_group[var0_7]

	LoadImageSpriteAtlasAsync("island/islandachievement", var1_7.icon, arg2_7:Find("icon"), true)
	setText(arg2_7:Find("name"), var1_7.name)
	onToggle(arg0_7, arg2_7, function(arg0_8)
		if arg0_8 then
			arg0_7.showType = var0_7

			arg0_7:FlushDetail()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateToggle(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.typeIds[arg1_9 + 1]
	local var1_9 = pg.island_achievement_group[var0_9].achievement_list
	local var2_9 = {}

	for iter0_9, iter1_9 in ipairs(var1_9) do
		local var3_9 = arg0_9.achvAgency:GetGroup(iter1_9)

		for iter2_9, iter3_9 in ipairs(var3_9:GetSortAchvList()) do
			table.insert(var2_9, iter3_9)
		end
	end

	local var4_9 = underscore.any(var2_9, function(arg0_10)
		return arg0_10:GetStatus() == IslandAchievement.STATUS.GET
	end)

	setActive(arg2_9:Find("name/tip"), var4_9)

	local var5_9 = underscore.all(var2_9, function(arg0_11)
		return arg0_11:GetStatus() == IslandAchievement.STATUS.GOT
	end)

	setActive(arg2_9:Find("bg"), not var5_9)
	setActive(arg2_9:Find("bg_all"), var5_9)
end

function var0_0.AddListeners(arg0_12)
	arg0_12:AddListener(GAME.ISLAND_GET_ACHV_AWARD_DONE, arg0_12.Flush)
end

function var0_0.RemoveListeners(arg0_13)
	arg0_13:RemoveListener(GAME.ISLAND_GET_ACHV_AWARD_DONE, arg0_13.Flush)
end

function var0_0.OnShow(arg0_14, arg1_14)
	arg0_14.showType = arg1_14

	arg0_14:Flush()
end

function var0_0.Flush(arg0_15)
	arg0_15.achvAgency = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	setText(arg0_15.totalTF, #arg0_15.achvAgency:GetGotList() .. "/" .. arg0_15.achvAgency:GetTotalCnt())
	arg0_15.typeUIList:align(#arg0_15.typeIds)
	triggerToggle(arg0_15.typeUIList.container:Find(tostring(arg0_15.showType)), true)
end

function var0_0.FlushDetail(arg0_16)
	arg0_16.showGroupIds = pg.island_achievement_group[arg0_16.showType].achievement_list
	arg0_16.showAchvList = underscore.map(arg0_16.showGroupIds, function(arg0_17)
		local var0_17 = arg0_16.achvAgency:GetGroup(arg0_17):GetSortAchvList()
		local var1_17 = underscore.select(var0_17, function(arg0_18)
			return not arg0_18:IsHideType() or arg0_18:GetStatus() == IslandAchievement.STATUS.GET
		end)

		return underscore.detect(var1_17, function(arg0_19)
			return arg0_19:GetStatus() ~= IslandAchievement.STATUS.GOT
		end) or var1_17[#var1_17]
	end)

	table.sort(arg0_16.showAchvList, CompareFuncs({
		function(arg0_20)
			return arg0_20:GetStatus() == IslandAchievement.STATUS.GET and 0 or 1
		end,
		function(arg0_21)
			return arg0_21:GetStatus() == IslandAchievement.STATUS.GOT and 1 or 0
		end,
		function(arg0_22)
			return arg0_22.id
		end
	}))
	arg0_16.itemUIList:align(#arg0_16.showAchvList)
end

function var0_0.UpdateItem(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.showAchvList[arg1_23 + 1]

	arg2_23.name = var0_23.id

	setText(arg2_23:Find("name"), var0_23:getConfig("name"))
	setText(arg2_23:Find("desc"), var0_23:getConfig("desc"))

	local var1_23 = var0_23:GetAwards()

	UIItemList.StaticAlign(arg2_23:Find("awards"), arg2_23:Find("awards/tpl"), #var1_23, function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			local var0_24 = var1_23[arg1_24 + 1]
			local var1_24 = var0_24:getConfigTable().icon

			GetImageSpriteFromAtlasAsync("island/" .. var1_24, "", arg2_24:Find("icon"))
			setText(arg2_24:Find("count"), var0_24.count)
		end
	end)

	local var2_23 = var0_23:GetStatus()

	setActive(arg2_23:Find("status/got"), var2_23 == IslandAchievement.STATUS.GOT)

	local var3_23 = var2_23 == IslandAchievement.STATUS.GET

	setActive(arg2_23:Find("status/get"), var3_23)

	if var3_23 then
		onButton(arg0_23, arg2_23:Find("status/get"), function()
			arg0_23:emit(IslandMediator.GET_ACHIEVEMENT_AWARD, {
				var0_23.id
			})
		end, SFX_PANEL)
	else
		removeOnButton(arg2_23:Find("status/get"))
	end

	local var4_23 = var2_23 == IslandAchievement.STATUS.NORMAL

	setActive(arg2_23:Find("status/go"), var4_23)

	if var4_23 then
		local var5_23 = arg0_23.achvAgency:GetCurProgress(var0_23)

		setText(arg2_23:Find("status/go/Text"), var5_23 .. "/" .. var0_23:GetNum())
	end

	local var6_23 = var0_23:getConfig("group")
	local var7_23 = arg0_23.achvAgency:GetGroup(var6_23):GetSortAchvList()
	local var8_23 = underscore.select(var7_23, function(arg0_26)
		return not arg0_26:IsHideType() or arg0_26:GetStatus() == IslandAchievement.STATUS.GET
	end)

	UIItemList.StaticAlign(arg2_23:Find("stages"), arg2_23:Find("stages/tpl"), #var8_23, function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = arg1_27 + 1

			GetImageSpriteFromAtlasAsync("ui/islandachievementui_atlas", "stage_" .. var0_27, arg2_27:Find("icon"))

			local var1_27 = var0_27 == #var8_23
			local var2_27 = var8_23[var0_27]

			setActive(arg2_27:Find("line"), not var1_27)

			local var3_27 = var2_27:GetStatus() == IslandAchievement.STATUS.GOT

			setActive(arg2_27:Find("line/got"), var3_27)
			setActive(arg2_27:Find("circle/got"), var3_27)
		end
	end)
end

return var0_0
