local var0_0 = class("IslandAchvDetailPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandAchvDetailUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_achievement_title"))
	setText(arg0_2._tf:Find("total/Text"), i18n("island_achv_total"))

	arg0_2.totalTF = arg0_2._tf:Find("total/value")

	local var0_2 = arg0_2._tf:Find("toggles/content")

	arg0_2.typeUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	setActive(arg0_2._tf:Find("tpl"), false)

	arg0_2.scrollRect = arg0_2._tf:Find("view"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("top/back"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	arg0_5.typeUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventInit then
			arg0_5:InitToggle(arg1_7, arg2_7)
		elseif arg0_7 == UIItemList.EventUpdate then
			arg0_5:UpdateToggle(arg1_7, arg2_7)
		end
	end)

	arg0_5.typeIds = pg.island_achievement_group.all
	arg0_5.cards = {}
end

function var0_0.InitToggle(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.typeIds[arg1_8 + 1]

	arg2_8.name = var0_8

	local var1_8 = pg.island_achievement_group[var0_8]

	LoadImageSpriteAtlasAsync("islandachievement", var1_8.icon, arg2_8:Find("icon"), true)
	setText(arg2_8:Find("name"), var1_8.name)
	onToggle(arg0_8, arg2_8, function(arg0_9)
		if arg0_9 then
			arg2_8:GetComponent(typeof(Animation)):Play()

			arg0_8.showType = var0_8

			arg0_8:FlushDetail()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateToggle(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.typeIds[arg1_10 + 1]
	local var1_10 = pg.island_achievement_group[var0_10].achievement_list
	local var2_10 = {}

	for iter0_10, iter1_10 in ipairs(var1_10) do
		local var3_10 = arg0_10.achvAgency:GetGroup(iter1_10)

		for iter2_10, iter3_10 in ipairs(var3_10:GetSortAchvList()) do
			table.insert(var2_10, iter3_10)
		end
	end

	local var4_10 = underscore.any(var2_10, function(arg0_11)
		return arg0_11:GetStatus() == IslandAchievement.STATUS.GET
	end)

	setActive(arg2_10:Find("name/tip"), var4_10)
end

function var0_0.AddListeners(arg0_12)
	arg0_12:AddListener(GAME.ISLAND_GET_ACHV_AWARD_DONE, arg0_12.OnGetAchvAwardDone)
end

function var0_0.RemoveListeners(arg0_13)
	arg0_13:RemoveListener(GAME.ISLAND_GET_ACHV_AWARD_DONE, arg0_13.OnGetAchvAwardDone)
end

function var0_0.OnShow(arg0_14, arg1_14)
	arg0_14.showType = arg1_14 or pg.island_achievement_group.all[1]

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
	arg0_16.scrollRect:SetTotalCount(#arg0_16.showAchvList, -1)
end

function var0_0.OnInitItem(arg0_23, arg1_23)
	local var0_23 = IslandAchievementCard.New(arg1_23)

	arg0_23.cards[arg1_23] = var0_23

	onButton(arg0_23, var0_23.getBtn, function()
		var0_23._tf:GetComponent(typeof(Animation)):Play()
		arg0_23:emit(IslandMediator.GET_ACHIEVEMENT_AWARD, {
			var0_23.achv.id
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateItem(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.cards[arg2_25]

	if not var0_25 then
		arg0_25:OnInitItem(arg2_25)

		var0_25 = arg0_25.cards[arg2_25]
	end

	local var1_25 = arg0_25.showAchvList[arg1_25 + 1]

	if var1_25 then
		var0_25:Update(var1_25)
	end
end

function var0_0.OnGetAchvAwardDone(arg0_26, arg1_26)
	local var0_26 = arg1_26.id

	local function var1_26()
		for iter0_27, iter1_27 in pairs(arg0_26.cards) do
			if iter1_27.achv.id == var0_26 then
				return iter1_27
			end
		end
	end

	seriesAsync({
		function(arg0_28)
			local var0_28 = var1_26()

			if var0_28 then
				var0_28:PlayStageAnim(var0_26, arg0_28)
			else
				arg0_28()
			end
		end
	}, function()
		arg0_26.achvAgency = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

		setText(arg0_26.totalTF, #arg0_26.achvAgency:GetGotList() .. "/" .. arg0_26.achvAgency:GetTotalCnt())
		arg0_26.typeUIList:align(#arg0_26.typeIds)
		arg0_26:FlushDetail()
	end)
end

function var0_0.OnDestroy(arg0_30)
	ClearLScrollrect(arg0_30.scrollRect)

	for iter0_30, iter1_30 in pairs(arg0_30.cards) do
		iter1_30:Dispose()
	end

	arg0_30.cards = {}
end

return var0_0
