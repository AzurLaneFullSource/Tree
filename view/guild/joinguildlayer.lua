local var0_0 = class("JoinGuildLayer", import("..base.BaseUI"))
local var1_0 = 30
local var2_0 = i18n("guild_search_list_max_count", var1_0)

function var0_0.getUIName(arg0_1)
	return "JoinGuildUI"
end

function var0_0.setGuildVOs(arg0_2, arg1_2)
	arg0_2.guildVOs = arg1_2
end

function var0_0.setPlayerVO(arg0_3, arg1_3)
	arg0_3.playerVO = arg1_3
end

function var0_0.init(arg0_4)
	arg0_4.guildViewRect = arg0_4:findTF("add_panel/view")
	arg0_4.refreshBtn = arg0_4:findTF("add_panel/center/refresh")
	arg0_4.searchBtn = arg0_4:findTF("add_panel/center/search")
	arg0_4.searchBar = arg0_4:findTF("add_panel/center/search_bar"):GetComponent(typeof(InputField))
	arg0_4.backBtn = arg0_4:findTF("blur_panel/adapt/top/back")
	arg0_4.sortBtn = arg0_4:findTF("add_panel/center/sort_button")
	arg0_4.sortBtnContainer = arg0_4:findTF("add_panel/sort_panel/mask/content")
	arg0_4.sortBtnTpl = arg0_4:getTpl("add_panel/sort_panel/mask/content/tpl")
	arg0_4.sortPanel = arg0_4:findTF("add_panel/sort_panel")
	arg0_4.applyRedPage = GuildApplyRedPage.New(arg0_4._tf, arg0_4.event)
	arg0_4.applyBluePage = GuildApplyBluePage.New(arg0_4._tf, arg0_4.event)
	arg0_4.listEmptyTF = arg0_4:findTF("empty")

	setActive(arg0_4.listEmptyTF, false)

	arg0_4.listEmptyTxt = arg0_4:findTF("Text", arg0_4.listEmptyTF)

	setText(arg0_4.listEmptyTxt, i18n("list_empty_tip_joinguildui"))
	setText(arg0_4:findTF("tip"), var2_0)

	arg0_4.viewRect = arg0_4.guildViewRect:GetComponent("LScrollRect")

	function arg0_4.viewRect.onInitItem(arg0_5)
		arg0_4:onInitItem(arg0_5)
	end

	function arg0_4.viewRect.onUpdateItem(arg0_6, arg1_6)
		arg0_4:onUpdateItem(arg0_6, arg1_6)
	end

	arg0_4.items = {}
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.refreshBtn, function()
		arg0_7:emit(JoinGuildMediator.REFRESH)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0_7, arg0_7.searchBtn, function()
		local var0_10 = arg0_7.searchBar.text

		arg0_7:emit(JoinGuildMediator.SEARCH, var0_10)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.sortBtn, function()
		if go(arg0_7.sortPanel).activeSelf then
			arg0_7:closeSortPanel()
		else
			arg0_7:openSortPanel()
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.sortPanel, function()
		arg0_7:closeSortPanel()
	end, SFX_PANEL)
end

function var0_0.openSortPanel(arg0_13)
	arg0_13.isOpenSortPanel = true

	setActive(arg0_13.sortPanel, true)

	if not arg0_13.isInitSort then
		arg0_13.isInitSort = true

		arg0_13:initSort()
	end
end

local var3_0 = {
	{
		"index_all"
	},
	{
		"index_blhx",
		{
			"faction",
			GuildConst.FACTION_TYPE_BLHX
		}
	},
	{
		"index_cszz",
		{
			"faction",
			GuildConst.FACTION_TYPE_CSZZ
		}
	},
	{
		"index_power",
		{
			"policy",
			GuildConst.POLICY_TYPE_POWER
		}
	},
	{
		"index_relax",
		{
			"policy",
			GuildConst.POLICY_TYPE_RELAXATION
		}
	}
}
local var4_0 = {}

function var0_0.initSort(arg0_14)
	for iter0_14, iter1_14 in ipairs(var3_0) do
		local var0_14 = cloneTplTo(arg0_14.sortBtnTpl, arg0_14.sortBtnContainer)
		local var1_14 = GetSpriteFromAtlas("ui/joinguildui_atlas", iter1_14[1])

		setImageSprite(var0_14:Find("Image"), var1_14, true)
		onToggle(arg0_14, var0_14, function(arg0_15)
			if arg0_15 then
				arg0_14:filter(iter1_14)
				setActive(arg0_14.sortPanel, false)
			end
		end)
	end

	for iter2_14, iter3_14 in ipairs(var4_0) do
		local var2_14 = cloneTplTo(arg0_14.sortBtnTpl, arg0_14.sortBtnContainer)

		setText(var2_14:Find("Text"), iter3_14[2])
		onToggle(arg0_14, var2_14, function(arg0_16)
			if arg0_16 then
				arg0_14:sortGuilds(iter3_14[1])
			end
		end)
	end
end

function var0_0.closeSortPanel(arg0_17)
	arg0_17.isOpenSortPanel = nil

	setActive(arg0_17.sortPanel, false)
end

function var0_0.onInitItem(arg0_18, arg1_18)
	arg0_18.items[arg1_18] = GuildApplyCard.New(arg1_18)

	onButton(arg0_18, arg0_18.items[arg1_18].applyBtn, function()
		if arg0_18.playerVO:inGuildCDTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_leave_cd_time"))

			return
		end

		arg0_18:showApply(arg0_18.items[arg1_18].guildVO)
	end, SFX_PANEL)
end

function var0_0.onUpdateItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.items[arg2_20]

	if not var0_20 then
		arg0_20:onInitItem(arg2_20)

		var0_20 = arg0_20.items[arg2_20]
	end

	local var1_20 = arg0_20.sortVOs[arg1_20 + 1]

	var0_20:Update(var1_20)
end

function var0_0.sortGuilds(arg0_21, arg1_21)
	arg0_21.sortVOs = arg0_21.guildVOs or {}

	table.sort(arg0_21.sortVOs, function(arg0_22, arg1_22)
		if not arg1_21 then
			return arg0_22.id < arg1_22.id
		elseif arg0_22[arg1_21] == arg1_22[arg1_21] then
			return arg0_22.id < arg1_22.id
		else
			return arg0_22[arg1_21] > arg1_22[arg1_21]
		end
	end)
	arg0_21.viewRect:SetTotalCount(#arg0_21.sortVOs, 0)
	setActive(arg0_21.listEmptyTF, #arg0_21.sortVOs <= 0)
end

function var0_0.filter(arg0_23, arg1_23)
	local var0_23 = arg1_23 or arg0_23.contextData.filterData

	arg0_23.sortVOs = {}

	if not var0_23 or #var0_23 < 2 then
		arg0_23.sortVOs = arg0_23.guildVOs or {}

		local var1_23 = GetSpriteFromAtlas("ui/joinguildui_atlas", "index_all")

		setImageSprite(arg0_23:findTF("Image", arg0_23.sortBtn), var1_23, true)
	else
		for iter0_23, iter1_23 in ipairs(arg0_23.guildVOs) do
			if iter1_23[var0_23[2][1]] == var0_23[2][2] then
				table.insert(arg0_23.sortVOs, iter1_23)
			end
		end

		local var2_23 = GetSpriteFromAtlas("ui/joinguildui_atlas", var0_23[1])

		setImageSprite(arg0_23:findTF("Image", arg0_23.sortBtn), var2_23, true)
	end

	local var3_23 = _.all(arg0_23.sortVOs, function(arg0_24)
		return arg0_24:getFaction() == GuildConst.FACTION_TYPE_CSZZ
	end)
	local var4_23 = _.all(arg0_23.sortVOs, function(arg0_25)
		return arg0_25:getFaction() == GuildConst.FACTION_TYPE_BLHX
	end)

	arg0_23.contextData.filterData = var0_23

	arg0_23.viewRect:SetTotalCount(#arg0_23.sortVOs, 0)
	setActive(arg0_23.listEmptyTF, #arg0_23.sortVOs <= 0)
end

function var0_0.showApply(arg0_26, arg1_26)
	local var0_26 = arg1_26:getFaction()

	if var0_26 == GuildConst.FACTION_TYPE_BLHX then
		arg0_26.page = arg0_26.applyBluePage
	elseif var0_26 == GuildConst.FACTION_TYPE_CSZZ then
		arg0_26.page = arg0_26.applyRedPage
	end

	arg0_26.page:ExecuteAction("Show", arg1_26)
end

function var0_0.CloseApply(arg0_27)
	if arg0_27.page and arg0_27.page:GetLoaded() and arg0_27.page:isShowing() then
		arg0_27.page:Hide()
	end
end

function var0_0.onBackPressed(arg0_28)
	if arg0_28.isOpenSortPanel then
		arg0_28:closeSortPanel()
	elseif arg0_28.page and arg0_28.page:GetLoaded() and arg0_28.page:isShowing() then
		arg0_28.page:Hide()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0_28:emit(var0_0.ON_CLOSE)
	end
end

function var0_0.willExit(arg0_29)
	arg0_29.applyBluePage:Destroy()
	arg0_29.applyRedPage:Destroy()
	PoolMgr.GetInstance():DestroySprite("ui/JoinGuildUI_atlas")
end

return var0_0
