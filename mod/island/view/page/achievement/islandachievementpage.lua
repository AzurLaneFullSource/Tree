local var0_0 = class("IslandAchievementPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandAchievementUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_achievement_title"))
	setText(arg0_2._tf:Find("top/total/Text"), i18n("island_achv_total"))

	arg0_2.totalTF = arg0_2._tf:Find("top/total/value")

	local var0_2 = arg0_2._tf:Find("view/content")

	arg0_2.uiList = UIItemList.New(var0_2, var0_2:Find("tpl"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.uiList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			arg0_3:InitItem(arg1_5, arg2_5)
		elseif arg0_5 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_5, arg2_5)
		end
	end)

	arg0_3.typeIds = pg.island_achievement_group.all
end

function var0_0.OnShow(arg0_6)
	arg0_6:Flush()
end

function var0_0.AddListeners(arg0_7)
	arg0_7:AddListener(GAME.ISLAND_GET_ACHV_AWARD_DONE, arg0_7.Flush)
end

function var0_0.RemoveListeners(arg0_8)
	arg0_8:RemoveListener(GAME.ISLAND_GET_ACHV_AWARD_DONE, arg0_8.Flush)
end

function var0_0.Flush(arg0_9)
	arg0_9.achvAgency = getProxy(IslandProxy):GetIsland():GetAchievementAgency()

	setText(arg0_9.totalTF, #arg0_9.achvAgency:GetGotList() .. "/" .. arg0_9.achvAgency:GetTotalCnt())
	arg0_9.uiList:align(#arg0_9.typeIds)
end

function var0_0.InitItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.typeIds[arg1_10 + 1]

	arg2_10.name = var0_10

	local var1_10 = pg.island_achievement_group[var0_10]

	LoadImageSpriteAtlasAsync("island/islandachievement", var1_10.icon, arg2_10:Find("icon"), true)
	setText(arg2_10:Find("name"), var1_10.name)
	onButton(arg0_10, arg2_10, function()
		arg0_10:OpenPage(IslandAchvDetailPage, var0_10)
	end, SFX_PANEL)
end

function var0_0.UpdateItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.typeIds[arg1_12 + 1]
	local var1_12 = pg.island_achievement_group[var0_12].achievement_list
	local var2_12 = {}

	for iter0_12, iter1_12 in ipairs(var1_12) do
		local var3_12 = arg0_12.achvAgency:GetGroup(iter1_12)

		for iter2_12, iter3_12 in ipairs(var3_12:GetSortAchvList()) do
			table.insert(var2_12, iter3_12)
		end
	end

	local var4_12 = underscore.reduce(var2_12, 0, function(arg0_13, arg1_13)
		return arg0_13 + (arg1_13:GetStatus() == IslandAchievement.STATUS.GOT and 1 or 0)
	end)
	local var5_12 = underscore.reduce(var2_12, 0, function(arg0_14, arg1_14)
		return arg0_14 + (arg1_14:IsHideType() and 0 or 1)
	end)

	setText(arg2_12:Find("progress/cur"), var4_12)
	setText(arg2_12:Find("progress/all"), "/" .. var5_12)

	arg2_12:Find("bar"):GetComponent(typeof(Image)).fillAmount = var4_12 / var5_12

	local var6_12 = var4_12 == var5_12

	setActive(arg2_12:Find("bg"), not var6_12)
	setActive(arg2_12:Find("bg_all"), var6_12)

	local var7_12 = underscore.any(var2_12, function(arg0_15)
		return arg0_15:GetStatus() == IslandAchievement.STATUS.GET
	end)

	setActive(arg2_12:Find("name/tip"), var7_12)
end

return var0_0
