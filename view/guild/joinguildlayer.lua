local var0 = class("JoinGuildLayer", import("..base.BaseUI"))
local var1 = 30
local var2 = i18n("guild_search_list_max_count", var1)

function var0.getUIName(arg0)
	return "JoinGuildUI"
end

function var0.setGuildVOs(arg0, arg1)
	arg0.guildVOs = arg1
end

function var0.setPlayerVO(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.init(arg0)
	arg0.guildViewRect = arg0:findTF("add_panel/view")
	arg0.refreshBtn = arg0:findTF("add_panel/center/refresh")
	arg0.searchBtn = arg0:findTF("add_panel/center/search")
	arg0.searchBar = arg0:findTF("add_panel/center/search_bar"):GetComponent(typeof(InputField))
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back")
	arg0.sortBtn = arg0:findTF("add_panel/center/sort_button")
	arg0.sortBtnContainer = arg0:findTF("add_panel/sort_panel/mask/content")
	arg0.sortBtnTpl = arg0:getTpl("add_panel/sort_panel/mask/content/tpl")
	arg0.sortPanel = arg0:findTF("add_panel/sort_panel")
	arg0.applyRedPage = GuildApplyRedPage.New(arg0._tf, arg0.event)
	arg0.applyBluePage = GuildApplyBluePage.New(arg0._tf, arg0.event)
	arg0.listEmptyTF = arg0:findTF("empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)

	setText(arg0.listEmptyTxt, i18n("list_empty_tip_joinguildui"))
	setText(arg0:findTF("tip"), var2)

	arg0.viewRect = arg0.guildViewRect:GetComponent("LScrollRect")

	function arg0.viewRect.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.viewRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end

	arg0.items = {}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.refreshBtn, function()
		arg0:emit(JoinGuildMediator.REFRESH)
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0, arg0.searchBtn, function()
		local var0 = arg0.searchBar.text

		arg0:emit(JoinGuildMediator.SEARCH, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.sortBtn, function()
		if go(arg0.sortPanel).activeSelf then
			arg0:closeSortPanel()
		else
			arg0:openSortPanel()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.sortPanel, function()
		arg0:closeSortPanel()
	end, SFX_PANEL)
end

function var0.openSortPanel(arg0)
	arg0.isOpenSortPanel = true

	setActive(arg0.sortPanel, true)

	if not arg0.isInitSort then
		arg0.isInitSort = true

		arg0:initSort()
	end
end

local var3 = {
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
local var4 = {}

function var0.initSort(arg0)
	for iter0, iter1 in ipairs(var3) do
		local var0 = cloneTplTo(arg0.sortBtnTpl, arg0.sortBtnContainer)
		local var1 = GetSpriteFromAtlas("ui/joinguildui_atlas", iter1[1])

		setImageSprite(var0:Find("Image"), var1, true)
		onToggle(arg0, var0, function(arg0)
			if arg0 then
				arg0:filter(iter1)
				setActive(arg0.sortPanel, false)
			end
		end)
	end

	for iter2, iter3 in ipairs(var4) do
		local var2 = cloneTplTo(arg0.sortBtnTpl, arg0.sortBtnContainer)

		setText(var2:Find("Text"), iter3[2])
		onToggle(arg0, var2, function(arg0)
			if arg0 then
				arg0:sortGuilds(iter3[1])
			end
		end)
	end
end

function var0.closeSortPanel(arg0)
	arg0.isOpenSortPanel = nil

	setActive(arg0.sortPanel, false)
end

function var0.onInitItem(arg0, arg1)
	arg0.items[arg1] = GuildApplyCard.New(arg1)

	onButton(arg0, arg0.items[arg1].applyBtn, function()
		if arg0.playerVO:inGuildCDTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_leave_cd_time"))

			return
		end

		arg0:showApply(arg0.items[arg1].guildVO)
	end, SFX_PANEL)
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.items[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.items[arg2]
	end

	local var1 = arg0.sortVOs[arg1 + 1]

	var0:Update(var1)
end

function var0.sortGuilds(arg0, arg1)
	arg0.sortVOs = arg0.guildVOs or {}

	table.sort(arg0.sortVOs, function(arg0, arg1)
		if not arg1 then
			return arg0.id < arg1.id
		elseif arg0[arg1] == arg1[arg1] then
			return arg0.id < arg1.id
		else
			return arg0[arg1] > arg1[arg1]
		end
	end)
	arg0.viewRect:SetTotalCount(#arg0.sortVOs, 0)
	setActive(arg0.listEmptyTF, #arg0.sortVOs <= 0)
end

function var0.filter(arg0, arg1)
	local var0 = arg1 or arg0.contextData.filterData

	arg0.sortVOs = {}

	if not var0 or #var0 < 2 then
		arg0.sortVOs = arg0.guildVOs or {}

		local var1 = GetSpriteFromAtlas("ui/joinguildui_atlas", "index_all")

		setImageSprite(arg0:findTF("Image", arg0.sortBtn), var1, true)
	else
		for iter0, iter1 in ipairs(arg0.guildVOs) do
			if iter1[var0[2][1]] == var0[2][2] then
				table.insert(arg0.sortVOs, iter1)
			end
		end

		local var2 = GetSpriteFromAtlas("ui/joinguildui_atlas", var0[1])

		setImageSprite(arg0:findTF("Image", arg0.sortBtn), var2, true)
	end

	local var3 = _.all(arg0.sortVOs, function(arg0)
		return arg0:getFaction() == GuildConst.FACTION_TYPE_CSZZ
	end)
	local var4 = _.all(arg0.sortVOs, function(arg0)
		return arg0:getFaction() == GuildConst.FACTION_TYPE_BLHX
	end)

	arg0.contextData.filterData = var0

	arg0.viewRect:SetTotalCount(#arg0.sortVOs, 0)
	setActive(arg0.listEmptyTF, #arg0.sortVOs <= 0)
end

function var0.showApply(arg0, arg1)
	local var0 = arg1:getFaction()

	if var0 == GuildConst.FACTION_TYPE_BLHX then
		arg0.page = arg0.applyBluePage
	elseif var0 == GuildConst.FACTION_TYPE_CSZZ then
		arg0.page = arg0.applyRedPage
	end

	arg0.page:ExecuteAction("Show", arg1)
end

function var0.CloseApply(arg0)
	if arg0.page and arg0.page:GetLoaded() and arg0.page:isShowing() then
		arg0.page:Hide()
	end
end

function var0.onBackPressed(arg0)
	if arg0.isOpenSortPanel then
		arg0:closeSortPanel()
	elseif arg0.page and arg0.page:GetLoaded() and arg0.page:isShowing() then
		arg0.page:Hide()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0:emit(var0.ON_CLOSE)
	end
end

function var0.willExit(arg0)
	arg0.applyBluePage:Destroy()
	arg0.applyRedPage:Destroy()
	PoolMgr.GetInstance():DestroySprite("ui/JoinGuildUI_atlas")
end

return var0
