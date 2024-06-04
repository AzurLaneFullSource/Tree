local var0 = class("IndexLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "IndexUI"
end

var0.panelNames = {
	{
		"indexsort_sort",
		"indexsort_sorteng"
	},
	{
		"indexsort_index",
		"indexsort_indexeng"
	},
	{
		"indexsort_camp",
		"indexsort_campeng"
	},
	{
		"indexsort_rarity",
		"indexsort_rarityeng"
	},
	{
		"indexsort_extraindex",
		"indexsort_indexeng"
	}
}

function var0.init(arg0)
	arg0.panel = arg0:findTF("index_panel")
	arg0.displayTFs = {
		arg0:findTF("layout/sort", arg0.panel),
		arg0:findTF("layout/index", arg0.panel),
		arg0:findTF("layout/camp", arg0.panel),
		arg0:findTF("layout/rarity", arg0.panel),
		arg0:findTF("layout/extra", arg0.panel),
		arg0:findTF("layout/EquipSkinSort", arg0.panel),
		arg0:findTF("layout/EquipSkinIndex", arg0.panel),
		arg0:findTF("layout/EquipSkinTheme", arg0.panel)
	}

	_.each(arg0.displayTFs, function(arg0)
		setActive(arg0, false)
	end)

	for iter0 = 1, #var0.panelNames do
		setText(arg0.displayTFs[iter0]:Find("title1/Image"), i18n(var0.panelNames[iter0][1]))
		setText(arg0.displayTFs[iter0]:Find("title1/Image_en"), i18n(var0.panelNames[iter0][2]))
	end

	arg0.displayList = {}
	arg0.typeList = {}
	arg0.btnConfirm = arg0:findTF("layout/btns/ok", arg0.panel)
	arg0.btnCancel = arg0:findTF("layout/btns/cancel", arg0.panel)
	arg0.greySprite = arg0:findTF("resource/grey", arg0.panel):GetComponent(typeof(Image)).sprite
	arg0.blueSprite = arg0:findTF("resource/blue", arg0.panel):GetComponent(typeof(Image)).sprite
	arg0.yellowSprite = arg0:findTF("resource/yellow", arg0.panel):GetComponent(typeof(Image)).sprite
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnConfirm, function()
		if arg0.contextData.callback then
			arg0.contextData.callback({
				sort = Clone(arg0.contextData.sort),
				index = Clone(arg0.contextData.index),
				camp = Clone(arg0.contextData.camp),
				rarity = Clone(arg0.contextData.rarity),
				extra = Clone(arg0.contextData.extra),
				equipSkinSort = Clone(arg0.contextData.equipSkinSort),
				equipSkinIndex = Clone(arg0.contextData.equipSkinIndex),
				equipSkinTheme = Clone(arg0.contextData.equipSkinTheme)
			})

			arg0.contextData.callback = nil
		end

		arg0:emit(var0.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.btnCancel, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("btn", arg0.panel), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)

	arg0.panel.localScale = Vector3.zero

	LeanTween.scale(arg0.panel, Vector3(1, 1, 1), 0.2)
	arg0:initDisplays()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.initDisplays(arg0)
	local var0 = {
		"sort",
		"index",
		"camp",
		"rarity",
		"extra",
		"equipSkinSort",
		"equipSkinIndex",
		"equipSkinTheme"
	}

	for iter0, iter1 in ipairs(arg0.displayTFs) do
		local var1 = tobool(arg0.contextData.display[var0[iter0]])

		setActive(iter1, var1)

		if var1 then
			if iter0 == IndexConst.DisplayEquipSkinSort then
				arg0:initEquipSkinSort()
				arg0:updateEquipSkinSort()
			elseif iter0 == IndexConst.DisplayEquipSkinIndex then
				arg0:initEquipSkinIndex()
				arg0:updateEquipSkinIndex()
			elseif iter0 == IndexConst.DisplayEquipSkinTheme then
				arg0:initEquipSkinTheme()
				arg0:updateEquipSkinTheme()
			end
		end
	end
end

function var0.initEquipSkinSort(arg0)
	local var0 = {}

	_.each(IndexConst.EquipSkinSortTypes, function(arg0)
		local var0 = bit.lshift(1, arg0)

		if bit.band(arg0.contextData.display.equipSkinSort, var0) > 0 then
			table.insert(var0, arg0)
		end
	end)

	arg0.typeList[IndexConst.DisplayEquipSkinSort] = var0

	local var1 = arg0.displayTFs[IndexConst.DisplayEquipSkinSort]
	local var2 = UIItemList.New(arg0:findTF("panel", var1), arg0:findTF("panel/tpl", var1))

	var2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = table.indexof(IndexConst.EquipSkinSortTypes, var0)
			local var2 = IndexConst.EquipSkinSortNames[var1]
			local var3 = findTF(arg2, "Image")

			setText(var3, var2)
			setImageSprite(arg2, arg0.greySprite)
			GetOrAddComponent(arg2, typeof(Button))
			onButton(arg0, arg2, function()
				arg0.contextData.equipSkinSort = var0

				arg0:updateEquipSkinSort()
			end, SFX_UI_TAG)
		end
	end)
	var2:align(#var0)

	arg0.displayList[IndexConst.DisplayEquipSkinSort] = var2
end

function var0.updateEquipSkinSort(arg0)
	local var0 = arg0.displayList[IndexConst.DisplayEquipSkinSort]
	local var1 = arg0.typeList[IndexConst.DisplayEquipSkinSort]

	var0:each(function(arg0, arg1)
		local var0 = arg0.contextData.equipSkinSort == var1[arg0 + 1]
		local var1 = findTF(arg1, "Image")

		setImageSprite(arg1, var0 and arg0.yellowSprite or arg0.greySprite)
	end)
end

function var0.initEquipSkinIndex(arg0)
	local var0 = {}

	_.each(IndexConst.EquipSkinIndexTypes, function(arg0)
		local var0 = bit.lshift(1, arg0)

		if bit.band(arg0.contextData.display.equipSkinIndex, var0) > 0 then
			table.insert(var0, arg0)
		end
	end)

	arg0.typeList[IndexConst.DisplayEquipSkinIndex] = var0

	local var1 = arg0.displayTFs[IndexConst.DisplayEquipSkinIndex]
	local var2 = UIItemList.New(arg0:findTF("panel", var1), arg0:findTF("panel/tpl", var1))

	var2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = table.indexof(IndexConst.EquipSkinIndexTypes, var0)
			local var2 = IndexConst.EquipSkinIndexNames[var1]
			local var3 = findTF(arg2, "Image")

			setText(var3, var2)
			setImageSprite(arg2, arg0.greySprite)
			GetOrAddComponent(arg2, typeof(Button))
			onButton(arg0, arg2, function()
				arg0.contextData.equipSkinIndex = IndexConst.ToggleBits(arg0.contextData.equipSkinIndex, var0, IndexConst.EquipSkinIndexAll, var0)

				arg0:updateEquipSkinIndex()
			end, SFX_UI_TAG)
		end
	end)
	var2:align(#var0)

	arg0.displayList[IndexConst.DisplayEquipSkinIndex] = var2
end

function var0.updateEquipSkinIndex(arg0)
	local var0 = arg0.displayList[IndexConst.DisplayEquipSkinIndex]
	local var1 = arg0.typeList[IndexConst.DisplayEquipSkinIndex]

	var0:each(function(arg0, arg1)
		local var0 = var1[arg0 + 1]
		local var1 = bit.band(arg0.contextData.equipSkinIndex, bit.lshift(1, var0)) > 0
		local var2 = findTF(arg1, "Image")

		setImageSprite(arg1, var1 and arg0.yellowSprite or arg0.greySprite)
	end)
end

function var0.initEquipSkinTheme(arg0)
	local var0 = {}

	_.each(IndexConst.EquipSkinThemeTypes, function(arg0)
		local var0 = IndexConst.StrLShift("1", arg0)

		if string.find(IndexConst.StrAnd(arg0.contextData.display.equipSkinTheme, var0), "1") ~= nil then
			table.insert(var0, arg0)
		end
	end)

	arg0.typeList[IndexConst.DisplayEquipSkinTheme] = var0

	local var1 = arg0.displayTFs[IndexConst.DisplayEquipSkinTheme]
	local var2 = UIItemList.New(arg0:findTF("bg/panel", var1), arg0:findTF("bg/panel/tpl", var1))

	var2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = table.indexof(IndexConst.EquipSkinThemeTypes, var0)
			local var2 = IndexConst.EquipSkinThemeNames[var1]
			local var3 = findTF(arg2, "Image")

			setText(var3, var2)
			setImageSprite(arg2, arg0.greySprite)
			GetOrAddComponent(arg2, typeof(Button))
			onButton(arg0, arg2, function()
				arg0.contextData.equipSkinTheme = IndexConst.ToggleStr(arg0.contextData.equipSkinTheme, var0, IndexConst.EquipSkinThemeAll, var0)

				arg0:updateEquipSkinTheme()
			end, SFX_UI_TAG)
		end
	end)
	var2:align(#var0)

	arg0.displayList[IndexConst.DisplayEquipSkinTheme] = var2
end

function var0.updateEquipSkinTheme(arg0)
	local var0 = arg0.displayList[IndexConst.DisplayEquipSkinTheme]
	local var1 = arg0.typeList[IndexConst.DisplayEquipSkinTheme]

	var0:each(function(arg0, arg1)
		local var0 = var1[arg0 + 1]
		local var1 = IndexConst.StrLShift("1", var0)
		local var2 = string.find(IndexConst.StrAnd(arg0.contextData.equipSkinTheme, var1), "1") ~= nil
		local var3 = findTF(arg1, "Image")

		setImageSprite(arg1, var2 and arg0.yellowSprite or arg0.greySprite)
	end)
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0.panel))
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
