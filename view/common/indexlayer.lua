local var0_0 = class("IndexLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "IndexUI"
end

var0_0.panelNames = {
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

function var0_0.init(arg0_2)
	arg0_2.panel = arg0_2:findTF("index_panel")
	arg0_2.displayTFs = {
		arg0_2:findTF("layout/sort", arg0_2.panel),
		arg0_2:findTF("layout/index", arg0_2.panel),
		arg0_2:findTF("layout/camp", arg0_2.panel),
		arg0_2:findTF("layout/rarity", arg0_2.panel),
		arg0_2:findTF("layout/extra", arg0_2.panel),
		arg0_2:findTF("layout/EquipSkinSort", arg0_2.panel),
		arg0_2:findTF("layout/EquipSkinIndex", arg0_2.panel),
		arg0_2:findTF("layout/EquipSkinTheme", arg0_2.panel)
	}

	_.each(arg0_2.displayTFs, function(arg0_3)
		setActive(arg0_3, false)
	end)

	for iter0_2 = 1, #var0_0.panelNames do
		setText(arg0_2.displayTFs[iter0_2]:Find("title1/Image"), i18n(var0_0.panelNames[iter0_2][1]))
		setText(arg0_2.displayTFs[iter0_2]:Find("title1/Image_en"), i18n(var0_0.panelNames[iter0_2][2]))
	end

	arg0_2.displayList = {}
	arg0_2.typeList = {}
	arg0_2.btnConfirm = arg0_2:findTF("layout/btns/ok", arg0_2.panel)
	arg0_2.btnCancel = arg0_2:findTF("layout/btns/cancel", arg0_2.panel)
	arg0_2.greySprite = arg0_2:findTF("resource/grey", arg0_2.panel):GetComponent(typeof(Image)).sprite
	arg0_2.blueSprite = arg0_2:findTF("resource/blue", arg0_2.panel):GetComponent(typeof(Image)).sprite
	arg0_2.yellowSprite = arg0_2:findTF("resource/yellow", arg0_2.panel):GetComponent(typeof(Image)).sprite
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.btnConfirm, function()
		if arg0_4.contextData.callback then
			arg0_4.contextData.callback({
				sort = Clone(arg0_4.contextData.sort),
				index = Clone(arg0_4.contextData.index),
				camp = Clone(arg0_4.contextData.camp),
				rarity = Clone(arg0_4.contextData.rarity),
				extra = Clone(arg0_4.contextData.extra),
				equipSkinSort = Clone(arg0_4.contextData.equipSkinSort),
				equipSkinIndex = Clone(arg0_4.contextData.equipSkinIndex),
				equipSkinTheme = Clone(arg0_4.contextData.equipSkinTheme)
			})

			arg0_4.contextData.callback = nil
		end

		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(arg0_4, arg0_4.btnCancel, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4:findTF("btn", arg0_4.panel), function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)

	arg0_4.panel.localScale = Vector3.zero

	LeanTween.scale(arg0_4.panel, Vector3(1, 1, 1), 0.2)
	arg0_4:initDisplays()
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.initDisplays(arg0_8)
	local var0_8 = {
		"sort",
		"index",
		"camp",
		"rarity",
		"extra",
		"equipSkinSort",
		"equipSkinIndex",
		"equipSkinTheme"
	}

	for iter0_8, iter1_8 in ipairs(arg0_8.displayTFs) do
		local var1_8 = tobool(arg0_8.contextData.display[var0_8[iter0_8]])

		setActive(iter1_8, var1_8)

		if var1_8 then
			if iter0_8 == IndexConst.DisplayEquipSkinSort then
				arg0_8:initEquipSkinSort()
				arg0_8:updateEquipSkinSort()
			elseif iter0_8 == IndexConst.DisplayEquipSkinIndex then
				arg0_8:initEquipSkinIndex()
				arg0_8:updateEquipSkinIndex()
			elseif iter0_8 == IndexConst.DisplayEquipSkinTheme then
				arg0_8:initEquipSkinTheme()
				arg0_8:updateEquipSkinTheme()
			end
		end
	end
end

function var0_0.initEquipSkinSort(arg0_9)
	local var0_9 = {}

	_.each(IndexConst.EquipSkinSortTypes, function(arg0_10)
		local var0_10 = bit.lshift(1, arg0_10)

		if bit.band(arg0_9.contextData.display.equipSkinSort, var0_10) > 0 then
			table.insert(var0_9, arg0_10)
		end
	end)

	arg0_9.typeList[IndexConst.DisplayEquipSkinSort] = var0_9

	local var1_9 = arg0_9.displayTFs[IndexConst.DisplayEquipSkinSort]
	local var2_9 = UIItemList.New(arg0_9:findTF("panel", var1_9), arg0_9:findTF("panel/tpl", var1_9))

	var2_9:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = var0_9[arg1_11 + 1]
			local var1_11 = table.indexof(IndexConst.EquipSkinSortTypes, var0_11)
			local var2_11 = IndexConst.EquipSkinSortNames[var1_11]
			local var3_11 = findTF(arg2_11, "Image")

			setText(var3_11, var2_11)
			setImageSprite(arg2_11, arg0_9.greySprite)
			GetOrAddComponent(arg2_11, typeof(Button))
			onButton(arg0_9, arg2_11, function()
				arg0_9.contextData.equipSkinSort = var0_11

				arg0_9:updateEquipSkinSort()
			end, SFX_UI_TAG)
		end
	end)
	var2_9:align(#var0_9)

	arg0_9.displayList[IndexConst.DisplayEquipSkinSort] = var2_9
end

function var0_0.updateEquipSkinSort(arg0_13)
	local var0_13 = arg0_13.displayList[IndexConst.DisplayEquipSkinSort]
	local var1_13 = arg0_13.typeList[IndexConst.DisplayEquipSkinSort]

	var0_13:each(function(arg0_14, arg1_14)
		local var0_14 = arg0_13.contextData.equipSkinSort == var1_13[arg0_14 + 1]
		local var1_14 = findTF(arg1_14, "Image")

		setImageSprite(arg1_14, var0_14 and arg0_13.yellowSprite or arg0_13.greySprite)
	end)
end

function var0_0.initEquipSkinIndex(arg0_15)
	local var0_15 = {}

	_.each(IndexConst.EquipSkinIndexTypes, function(arg0_16)
		local var0_16 = bit.lshift(1, arg0_16)

		if bit.band(arg0_15.contextData.display.equipSkinIndex, var0_16) > 0 then
			table.insert(var0_15, arg0_16)
		end
	end)

	arg0_15.typeList[IndexConst.DisplayEquipSkinIndex] = var0_15

	local var1_15 = arg0_15.displayTFs[IndexConst.DisplayEquipSkinIndex]
	local var2_15 = UIItemList.New(arg0_15:findTF("panel", var1_15), arg0_15:findTF("panel/tpl", var1_15))

	var2_15:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = var0_15[arg1_17 + 1]
			local var1_17 = table.indexof(IndexConst.EquipSkinIndexTypes, var0_17)
			local var2_17 = IndexConst.EquipSkinIndexNames[var1_17]
			local var3_17 = findTF(arg2_17, "Image")

			setText(var3_17, var2_17)
			setImageSprite(arg2_17, arg0_15.greySprite)
			GetOrAddComponent(arg2_17, typeof(Button))
			onButton(arg0_15, arg2_17, function()
				arg0_15.contextData.equipSkinIndex = IndexConst.ToggleBits(arg0_15.contextData.equipSkinIndex, var0_15, IndexConst.EquipSkinIndexAll, var0_17)

				arg0_15:updateEquipSkinIndex()
			end, SFX_UI_TAG)
		end
	end)
	var2_15:align(#var0_15)

	arg0_15.displayList[IndexConst.DisplayEquipSkinIndex] = var2_15
end

function var0_0.updateEquipSkinIndex(arg0_19)
	local var0_19 = arg0_19.displayList[IndexConst.DisplayEquipSkinIndex]
	local var1_19 = arg0_19.typeList[IndexConst.DisplayEquipSkinIndex]

	var0_19:each(function(arg0_20, arg1_20)
		local var0_20 = var1_19[arg0_20 + 1]
		local var1_20 = bit.band(arg0_19.contextData.equipSkinIndex, bit.lshift(1, var0_20)) > 0
		local var2_20 = findTF(arg1_20, "Image")

		setImageSprite(arg1_20, var1_20 and arg0_19.yellowSprite or arg0_19.greySprite)
	end)
end

function var0_0.initEquipSkinTheme(arg0_21)
	local var0_21 = {}

	_.each(IndexConst.EquipSkinThemeTypes, function(arg0_22)
		local var0_22 = IndexConst.StrLShift("1", arg0_22)

		if string.find(IndexConst.StrAnd(arg0_21.contextData.display.equipSkinTheme, var0_22), "1") ~= nil then
			table.insert(var0_21, arg0_22)
		end
	end)

	arg0_21.typeList[IndexConst.DisplayEquipSkinTheme] = var0_21

	local var1_21 = arg0_21.displayTFs[IndexConst.DisplayEquipSkinTheme]
	local var2_21 = UIItemList.New(arg0_21:findTF("bg/panel", var1_21), arg0_21:findTF("bg/panel/tpl", var1_21))

	var2_21:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = var0_21[arg1_23 + 1]
			local var1_23 = table.indexof(IndexConst.EquipSkinThemeTypes, var0_23)
			local var2_23 = IndexConst.EquipSkinThemeNames[var1_23]
			local var3_23 = findTF(arg2_23, "Image")

			setText(var3_23, var2_23)
			setImageSprite(arg2_23, arg0_21.greySprite)
			GetOrAddComponent(arg2_23, typeof(Button))
			onButton(arg0_21, arg2_23, function()
				arg0_21.contextData.equipSkinTheme = IndexConst.ToggleStr(arg0_21.contextData.equipSkinTheme, var0_21, IndexConst.EquipSkinThemeAll, var0_23)

				arg0_21:updateEquipSkinTheme()
			end, SFX_UI_TAG)
		end
	end)
	var2_21:align(#var0_21)

	arg0_21.displayList[IndexConst.DisplayEquipSkinTheme] = var2_21
end

function var0_0.updateEquipSkinTheme(arg0_25)
	local var0_25 = arg0_25.displayList[IndexConst.DisplayEquipSkinTheme]
	local var1_25 = arg0_25.typeList[IndexConst.DisplayEquipSkinTheme]

	var0_25:each(function(arg0_26, arg1_26)
		local var0_26 = var1_25[arg0_26 + 1]
		local var1_26 = IndexConst.StrLShift("1", var0_26)
		local var2_26 = string.find(IndexConst.StrAnd(arg0_25.contextData.equipSkinTheme, var1_26), "1") ~= nil
		local var3_26 = findTF(arg1_26, "Image")

		setImageSprite(arg1_26, var2_26 and arg0_25.yellowSprite or arg0_25.greySprite)
	end)
end

function var0_0.willExit(arg0_27)
	LeanTween.cancel(go(arg0_27.panel))
	pg.UIMgr.GetInstance():UnblurPanel(arg0_27._tf)
end

return var0_0
