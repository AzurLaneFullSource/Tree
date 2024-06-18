local var0_0 = class("CommanderIndexPage", import("...base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2

var0_0.NATION_OTHER = -1

local var3_0 = {
	Nation.US,
	Nation.EN,
	Nation.JP,
	Nation.DE,
	Nation.CN,
	Nation.SN,
	Nation.FF,
	Nation.MNF
}
local var4_0 = {
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
			var1_0
		},
		{
			i18n("commandercat_label_custom_name"),
			var2_0
		}
	}
}

for iter0_0, iter1_0 in ipairs(var3_0) do
	table.insert(var4_0.nation, iter1_0)
end

table.insert(var4_0.nation, var0_0.NATION_OTHER)

function var0_0.IsOtherNation(arg0_1)
	if not var0_0.displayNations then
		var0_0.displayNations = {}

		for iter0_1, iter1_1 in ipairs(var3_0) do
			var0_0.displayNations[iter1_1] = true
		end
	end

	return var0_0.displayNations[arg0_1] ~= true
end

function var0_0.getUIName(arg0_2)
	return "CommanderIndexUI"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.sortPanel = arg0_3:findTF("frame/frame/frame/sort_panel/content")
	arg0_3.nationPanel = arg0_3:findTF("frame/frame/frame/nation_panel/content")
	arg0_3.rarityPanel = arg0_3:findTF("frame/frame/frame/rarity_panel/content")
	arg0_3.namePanel = arg0_3:findTF("frame/frame/frame/name_panel/content")
	arg0_3.sortTpl = arg0_3.sortPanel:Find("tpl")
	arg0_3.nationTpl = arg0_3.nationPanel:Find("tpl")
	arg0_3.rarityTpl = arg0_3.rarityPanel:Find("tpl")
	arg0_3.nameTpl = arg0_3.namePanel:Find("tpl")
	arg0_3.cancelBtn = arg0_3:findTF("frame/frame/cancel_btn")
	arg0_3.confirmBtn = arg0_3:findTF("frame/frame/confirm_btn")
	arg0_3.closeBtn = arg0_3:findTF("frame/close_btn")

	setText(arg0_3:findTF("frame/frame/frame/sort_panel/title/Text"), i18n("indexsort_sort"))
	setText(arg0_3:findTF("frame/frame/frame/nation_panel/title/Text"), i18n("indexsort_camp"))
	setText(arg0_3:findTF("frame/frame/frame/rarity_panel/title/Text"), i18n("indexsort_rarity"))
	setText(arg0_3:findTF("frame/frame/frame/name_panel/title/Text"), i18n("commandercat_label_display_name"))
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.cancelBtn, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.closeBtn, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.confirmBtn, function()
		arg0_4.data.displayCustomName = arg0_4.displayName == var2_0

		arg0_4:emit(CommanderCatDockPage.ON_SORT, arg0_4.data.displayCustomName)
		arg0_4:Hide()
	end, SFX_PANEL)

	arg0_4.nationAllBtn = cloneTplTo(arg0_4.nationTpl, arg0_4.nationPanel)

	setText(arg0_4.nationAllBtn:Find("Text"), i18n("index_all"))
	onToggle(arg0_4, arg0_4.nationAllBtn, function(arg0_9)
		if arg0_9 then
			for iter0_9, iter1_9 in pairs(arg0_4.nationToggles) do
				triggerToggle(iter1_9, false)
			end

			arg0_4.data.nationData = {}
		end

		setToggleEnabled(arg0_4.nationAllBtn, not arg0_9)
	end, SFX_PANEL)

	arg0_4.rarityAllBtn = cloneTplTo(arg0_4.rarityTpl, arg0_4.rarityPanel)

	setText(arg0_4.rarityAllBtn:Find("Text"), i18n("index_all"))
	onToggle(arg0_4, arg0_4.rarityAllBtn, function(arg0_10)
		if arg0_10 then
			for iter0_10, iter1_10 in pairs(arg0_4.rarityToggles) do
				triggerToggle(iter1_10, false)
			end

			arg0_4.data.rarityData = {}
		end

		setToggleEnabled(arg0_4.rarityAllBtn, not arg0_10)
	end, SFX_PANEL)
	arg0_4:Reset()
	arg0_4:InitSort()
	arg0_4:InitNation()
	arg0_4:InitRarity()
	arg0_4:InitDisplayName()
end

function var0_0.InitSort(arg0_11)
	arg0_11.sortToggles = {}

	for iter0_11, iter1_11 in ipairs(var4_0.sort) do
		local var0_11 = cloneTplTo(arg0_11.sortTpl, arg0_11.sortPanel)

		onToggle(arg0_11, var0_11, function(arg0_12)
			if arg0_12 then
				arg0_11.data.sortData = iter1_11[2]
			end
		end, SFX_PANEL)
		setText(var0_11:Find("Text"), iter1_11[1])

		arg0_11.sortToggles[iter1_11[2]] = var0_11
	end
end

function var0_0.InitNation(arg0_13)
	arg0_13.nationToggles = {}

	for iter0_13, iter1_13 in pairs(var4_0.nation) do
		local var0_13 = cloneTplTo(arg0_13.nationTpl, arg0_13.nationPanel)

		onToggle(arg0_13, var0_13, function(arg0_14)
			if arg0_14 then
				if #arg0_13.data.nationData == 0 then
					triggerToggle(arg0_13.nationAllBtn, false)
				end

				table.insert(arg0_13.data.nationData, iter1_13)

				if #arg0_13.data.nationData == #var4_0.nation then
					triggerToggle(arg0_13.nationAllBtn, true)
				end
			elseif #arg0_13.data.nationData > 0 then
				local var0_14 = table.indexof(arg0_13.data.nationData, iter1_13)

				if var0_14 then
					table.remove(arg0_13.data.nationData, var0_14)

					if #arg0_13.data.nationData == 0 then
						triggerToggle(arg0_13.nationAllBtn, true)
					end
				end
			end
		end, SFX_PANEL)
		setText(var0_13:Find("Text"), arg0_13:Nation2Name(iter1_13))

		arg0_13.nationToggles[iter1_13] = var0_13
	end
end

function var0_0.Nation2Name(arg0_15, arg1_15)
	if arg1_15 == var0_0.NATION_OTHER then
		return i18n("index_other")
	else
		return Nation.Nation2Name(arg1_15)
	end
end

function var0_0.InitRarity(arg0_16)
	arg0_16.rarityToggles = {}

	for iter0_16, iter1_16 in pairs(var4_0.rarity) do
		local var0_16 = cloneTplTo(arg0_16.rarityTpl, arg0_16.rarityPanel)

		onToggle(arg0_16, var0_16, function(arg0_17)
			if arg0_17 then
				if #arg0_16.data.rarityData == 0 then
					triggerToggle(arg0_16.rarityAllBtn, false)
				end

				table.insert(arg0_16.data.rarityData, iter1_16[2])

				if #arg0_16.data.rarityData == #var4_0.rarity then
					triggerToggle(arg0_16.rarityAllBtn, true)
				end
			elseif #arg0_16.data.rarityData > 0 then
				local var0_17 = table.indexof(arg0_16.data.rarityData, iter1_16[2])

				if var0_17 then
					table.remove(arg0_16.data.rarityData, var0_17)

					if #arg0_16.data.rarityData == 0 then
						triggerToggle(arg0_16.rarityAllBtn, true)
					end
				end
			end
		end, SFX_PANEL)
		setText(var0_16:Find("Text"), iter1_16[1])

		arg0_16.rarityToggles[iter1_16[2]] = var0_16
	end
end

function var0_0.InitDisplayName(arg0_18)
	arg0_18.nameToggles = {}

	for iter0_18, iter1_18 in ipairs(var4_0.name) do
		local var0_18 = cloneTplTo(arg0_18.nameTpl, arg0_18.namePanel)

		setText(var0_18:Find("Text"), iter1_18[1])
		onToggle(arg0_18, var0_18, function(arg0_19)
			if arg0_19 then
				arg0_18.displayName = iter1_18[2]
			end
		end, SFX_PANEL)

		arg0_18.nameToggles[iter1_18[2]] = var0_18
	end
end

function var0_0.Show(arg0_20, arg1_20)
	setActive(arg0_20._tf, true)
	arg0_20:UpdateSelected(arg1_20)
	setParent(arg0_20._tf, pg.UIMgr.GetInstance().OverlayMain)
end

function var0_0.UpdateSelected(arg0_21, arg1_21)
	local var0_21 = arg1_21.sortData or "Level"

	triggerToggle(arg0_21.sortToggles[var0_21], true)

	local var1_21 = arg1_21.nationData or {}

	if #var1_21 > 0 then
		for iter0_21, iter1_21 in pairs(var1_21) do
			triggerToggle(arg0_21.nationToggles[iter1_21], true)
		end
	else
		triggerToggle(arg0_21.nationAllBtn, true)
	end

	local var2_21 = arg1_21.rarityData or {}

	if #var2_21 > 0 then
		for iter2_21, iter3_21 in pairs(var2_21) do
			triggerToggle(arg0_21.rarityToggles[iter3_21], true)
		end
	else
		triggerToggle(arg0_21.rarityAllBtn, true)
	end

	local var3_21 = defaultValue(arg1_21.displayCustomName, true) and var2_0 or var1_0

	triggerToggle(arg0_21.nameToggles[var3_21], true)
end

function var0_0.Reset(arg0_22)
	arg0_22.data = {
		sortData = "Level",
		displayCustomName = true,
		nationData = {},
		rarityData = {}
	}
end

function var0_0.Hide(arg0_23)
	setActive(arg0_23._tf, false)
	arg0_23:Reset()
	setParent(arg0_23._tf, arg0_23._parentTf)
end

function var0_0.OnDestroy(arg0_24)
	var0_0.displayNations = nil
end

return var0_0
