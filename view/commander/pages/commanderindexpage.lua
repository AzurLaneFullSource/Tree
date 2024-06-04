local var0 = class("CommanderIndexPage", import("...base.BaseSubView"))
local var1 = 1
local var2 = 2

var0.NATION_OTHER = -1

local var3 = {
	Nation.US,
	Nation.EN,
	Nation.JP,
	Nation.DE,
	Nation.CN,
	Nation.SN,
	Nation.FF,
	Nation.MNF
}
local var4 = {
	sort = {
		{
			i18n("word_achieved_item"),
			"id"
		},
		{
			i18n("word_level"),
			"Level"
		},
		{
			i18n("word_rarity"),
			"Rarity"
		}
	},
	nation = {},
	rarity = {
		{
			i18n("word_ssr"),
			5
		},
		{
			i18n("word_sr"),
			4
		},
		{
			i18n("word_r"),
			3
		}
	},
	name = {
		{
			i18n("commandercat_label_raw_name"),
			var1
		},
		{
			i18n("commandercat_label_custom_name"),
			var2
		}
	}
}

for iter0, iter1 in ipairs(var3) do
	table.insert(var4.nation, iter1)
end

table.insert(var4.nation, var0.NATION_OTHER)

function var0.IsOtherNation(arg0)
	if not var0.displayNations then
		var0.displayNations = {}

		for iter0, iter1 in ipairs(var3) do
			var0.displayNations[iter1] = true
		end
	end

	return var0.displayNations[arg0] ~= true
end

function var0.getUIName(arg0)
	return "CommanderIndexUI"
end

function var0.OnLoaded(arg0)
	arg0.sortPanel = arg0:findTF("frame/frame/frame/sort_panel/content")
	arg0.nationPanel = arg0:findTF("frame/frame/frame/nation_panel/content")
	arg0.rarityPanel = arg0:findTF("frame/frame/frame/rarity_panel/content")
	arg0.namePanel = arg0:findTF("frame/frame/frame/name_panel/content")
	arg0.sortTpl = arg0.sortPanel:Find("tpl")
	arg0.nationTpl = arg0.nationPanel:Find("tpl")
	arg0.rarityTpl = arg0.rarityPanel:Find("tpl")
	arg0.nameTpl = arg0.namePanel:Find("tpl")
	arg0.cancelBtn = arg0:findTF("frame/frame/cancel_btn")
	arg0.confirmBtn = arg0:findTF("frame/frame/confirm_btn")
	arg0.closeBtn = arg0:findTF("frame/close_btn")

	setText(arg0:findTF("frame/frame/frame/sort_panel/title/Text"), i18n("indexsort_sort"))
	setText(arg0:findTF("frame/frame/frame/nation_panel/title/Text"), i18n("indexsort_camp"))
	setText(arg0:findTF("frame/frame/frame/rarity_panel/title/Text"), i18n("indexsort_rarity"))
	setText(arg0:findTF("frame/frame/frame/name_panel/title/Text"), i18n("commandercat_label_display_name"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0.data.displayCustomName = arg0.displayName == var2

		arg0:emit(CommanderCatDockPage.ON_SORT, arg0.data.displayCustomName)
		arg0:Hide()
	end, SFX_PANEL)

	arg0.nationAllBtn = cloneTplTo(arg0.nationTpl, arg0.nationPanel)

	setText(arg0.nationAllBtn:Find("Text"), i18n("index_all"))
	onToggle(arg0, arg0.nationAllBtn, function(arg0)
		if arg0 then
			for iter0, iter1 in pairs(arg0.nationToggles) do
				triggerToggle(iter1, false)
			end

			arg0.data.nationData = {}
		end

		setToggleEnabled(arg0.nationAllBtn, not arg0)
	end, SFX_PANEL)

	arg0.rarityAllBtn = cloneTplTo(arg0.rarityTpl, arg0.rarityPanel)

	setText(arg0.rarityAllBtn:Find("Text"), i18n("index_all"))
	onToggle(arg0, arg0.rarityAllBtn, function(arg0)
		if arg0 then
			for iter0, iter1 in pairs(arg0.rarityToggles) do
				triggerToggle(iter1, false)
			end

			arg0.data.rarityData = {}
		end

		setToggleEnabled(arg0.rarityAllBtn, not arg0)
	end, SFX_PANEL)
	arg0:Reset()
	arg0:InitSort()
	arg0:InitNation()
	arg0:InitRarity()
	arg0:InitDisplayName()
end

function var0.InitSort(arg0)
	arg0.sortToggles = {}

	for iter0, iter1 in ipairs(var4.sort) do
		local var0 = cloneTplTo(arg0.sortTpl, arg0.sortPanel)

		onToggle(arg0, var0, function(arg0)
			if arg0 then
				arg0.data.sortData = iter1[2]
			end
		end, SFX_PANEL)
		setText(var0:Find("Text"), iter1[1])

		arg0.sortToggles[iter1[2]] = var0
	end
end

function var0.InitNation(arg0)
	arg0.nationToggles = {}

	for iter0, iter1 in pairs(var4.nation) do
		local var0 = cloneTplTo(arg0.nationTpl, arg0.nationPanel)

		onToggle(arg0, var0, function(arg0)
			if arg0 then
				if #arg0.data.nationData == 0 then
					triggerToggle(arg0.nationAllBtn, false)
				end

				table.insert(arg0.data.nationData, iter1)

				if #arg0.data.nationData == #var4.nation then
					triggerToggle(arg0.nationAllBtn, true)
				end
			elseif #arg0.data.nationData > 0 then
				local var0 = table.indexof(arg0.data.nationData, iter1)

				if var0 then
					table.remove(arg0.data.nationData, var0)

					if #arg0.data.nationData == 0 then
						triggerToggle(arg0.nationAllBtn, true)
					end
				end
			end
		end, SFX_PANEL)
		setText(var0:Find("Text"), arg0:Nation2Name(iter1))

		arg0.nationToggles[iter1] = var0
	end
end

function var0.Nation2Name(arg0, arg1)
	if arg1 == var0.NATION_OTHER then
		return i18n("index_other")
	else
		return Nation.Nation2Name(arg1)
	end
end

function var0.InitRarity(arg0)
	arg0.rarityToggles = {}

	for iter0, iter1 in pairs(var4.rarity) do
		local var0 = cloneTplTo(arg0.rarityTpl, arg0.rarityPanel)

		onToggle(arg0, var0, function(arg0)
			if arg0 then
				if #arg0.data.rarityData == 0 then
					triggerToggle(arg0.rarityAllBtn, false)
				end

				table.insert(arg0.data.rarityData, iter1[2])

				if #arg0.data.rarityData == #var4.rarity then
					triggerToggle(arg0.rarityAllBtn, true)
				end
			elseif #arg0.data.rarityData > 0 then
				local var0 = table.indexof(arg0.data.rarityData, iter1[2])

				if var0 then
					table.remove(arg0.data.rarityData, var0)

					if #arg0.data.rarityData == 0 then
						triggerToggle(arg0.rarityAllBtn, true)
					end
				end
			end
		end, SFX_PANEL)
		setText(var0:Find("Text"), iter1[1])

		arg0.rarityToggles[iter1[2]] = var0
	end
end

function var0.InitDisplayName(arg0)
	arg0.nameToggles = {}

	for iter0, iter1 in ipairs(var4.name) do
		local var0 = cloneTplTo(arg0.nameTpl, arg0.namePanel)

		setText(var0:Find("Text"), iter1[1])
		onToggle(arg0, var0, function(arg0)
			if arg0 then
				arg0.displayName = iter1[2]
			end
		end, SFX_PANEL)

		arg0.nameToggles[iter1[2]] = var0
	end
end

function var0.Show(arg0, arg1)
	setActive(arg0._tf, true)
	arg0:UpdateSelected(arg1)
	setParent(arg0._tf, pg.UIMgr.GetInstance().OverlayMain)
end

function var0.UpdateSelected(arg0, arg1)
	local var0 = arg1.sortData or "Level"

	triggerToggle(arg0.sortToggles[var0], true)

	local var1 = arg1.nationData or {}

	if #var1 > 0 then
		for iter0, iter1 in pairs(var1) do
			triggerToggle(arg0.nationToggles[iter1], true)
		end
	else
		triggerToggle(arg0.nationAllBtn, true)
	end

	local var2 = arg1.rarityData or {}

	if #var2 > 0 then
		for iter2, iter3 in pairs(var2) do
			triggerToggle(arg0.rarityToggles[iter3], true)
		end
	else
		triggerToggle(arg0.rarityAllBtn, true)
	end

	local var3 = defaultValue(arg1.displayCustomName, true) and var2 or var1

	triggerToggle(arg0.nameToggles[var3], true)
end

function var0.Reset(arg0)
	arg0.data = {
		sortData = "Level",
		displayCustomName = true,
		nationData = {},
		rarityData = {}
	}
end

function var0.Hide(arg0)
	setActive(arg0._tf, false)
	arg0:Reset()
	setParent(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	var0.displayNations = nil
end

return var0
