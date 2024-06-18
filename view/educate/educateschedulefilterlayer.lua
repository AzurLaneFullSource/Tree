local var0_0 = class("EducateScheduleFilterLayer", import(".base.EducateBaseUI"))

local function var1_0(arg0_1)
	local var0_1 = Clone(arg0_1)

	table.remove(var0_1, 1)

	return var0_1
end

var0_0.FILTER_CONFIG = {
	{
		tag = "typeIndex",
		dropdown = false,
		title = i18n("child_filter_type1"),
		options = var1_0(EducatePlanIndexConst.TypeIndexs),
		names = var1_0(EducatePlanIndexConst.TypeNames),
		default = EducatePlanIndexConst.TypeAll
	},
	{
		dropdown = true,
		title = i18n("child_filter_type2"),
		options = {
			EducatePlanIndexConst.AwardResIndexs,
			EducatePlanIndexConst.AwardNatureIndexs,
			EducatePlanIndexConst.AwardAttr1Indexs,
			EducatePlanIndexConst.AwardAttr2Indexs
		},
		names = {
			EducatePlanIndexConst.AwardResNames,
			EducatePlanIndexConst.AwardNatureNames,
			EducatePlanIndexConst.AwardAttr1Names,
			EducatePlanIndexConst.AwardAttr2Names
		},
		tags = {
			"awardResIndex",
			"awardNatureIndex",
			"awardAttr1Index",
			"awardAttr2Index"
		},
		defaults = {
			EducatePlanIndexConst.AwardResAll,
			EducatePlanIndexConst.AwardNatureAll,
			EducatePlanIndexConst.AwardAttr1All,
			EducatePlanIndexConst.AwardAttr2All
		}
	},
	{
		tag = "costIndex",
		dropdown = false,
		title = i18n("child_filter_type3"),
		options = var1_0(EducatePlanIndexConst.CostIndexs),
		names = var1_0(EducatePlanIndexConst.CostNames),
		default = EducatePlanIndexConst.CostAll
	}
}

function var0_0.getUIName(arg0_2)
	return "EducateScheduleIndexUI"
end

function var0_0.init(arg0_3)
	arg0_3.anim = arg0_3:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_3.animEvent = arg0_3:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_3.animEvent:SetEndEvent(function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end)

	arg0_3.windowTF = arg0_3:findTF("anim_root/window")

	setText(arg0_3:findTF("top/title", arg0_3.windowTF), i18n("child_filter_title"))

	arg0_3.filterContainer = arg0_3:findTF("frame/filter_content", arg0_3.windowTF)
	arg0_3.filterTpl = arg0_3:findTF("anim_root/filter_tpl")
	arg0_3.itemTpl = arg0_3:findTF("anim_root/item_tpl")

	setActive(arg0_3.filterTpl, false)
	setActive(arg0_3.itemTpl, false)

	arg0_3.dropdownPanel = arg0_3:findTF("anim_root/dropdown_panel")
	arg0_3.dropdownUIList = UIItemList.New(arg0_3:findTF("dropdown/list", arg0_3.dropdownPanel), arg0_3:findTF("dropdown/list/tpl", arg0_3.dropdownPanel))

	setActive(arg0_3.dropdownPanel, false)
	setText(arg0_3:findTF("sure_btn/Text", arg0_3.windowTF), i18n("word_ok"))
	setText(arg0_3:findTF("reset_btn/Text", arg0_3.windowTF), i18n("word_reset"))
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5:findTF("sure_btn", arg0_5.windowTF), function()
		if arg0_5.contextData.callback then
			arg0_5.contextData.callback(arg0_5.contextData.indexDatas)

			arg0_5.contextData.callback = nil
		end

		arg0_5:_close()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("reset_btn", arg0_5.windowTF), function()
		arg0_5.contextData.indexDatas = nil

		removeAllChildren(arg0_5.filterContainer)
		arg0_5:initFilters()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.dropdownPanel, function()
		arg0_5:closeDropdownPanel()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("anim_root/bg"), function()
		arg0_5:_close()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("top/close_btn", arg0_5.windowTF), function()
		arg0_5:_close()
	end, SFX_PANEL)
	arg0_5:initDropdownPanel()
	arg0_5:initFilters()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf, {
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER + 1
	})
end

function var0_0.initDropdownPanel(arg0_11)
	arg0_11.dropdownUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg1_12 + 1 + 1
			local var1_12 = arg0_11.dropdownCfg.names[arg0_11.dropdownCfgIndex][var0_12]
			local var2_12 = arg0_11.dropdownCfg.options[arg0_11.dropdownCfgIndex][var0_12]
			local var3_12 = arg0_11.dropdownCfg.tags[arg0_11.dropdownCfgIndex]
			local var4_12 = arg0_11.dropdownCfg.defaults[arg0_11.dropdownCfgIndex]

			setActive(arg0_11:findTF("line", arg2_12), var0_12 ~= #arg0_11.dropdownCfg.options[arg0_11.dropdownCfgIndex])
			setText(arg0_11:findTF("Text", arg2_12), var1_12)
			onButton(arg0_11, arg2_12, function()
				if arg0_11.contextData.indexDatas[var3_12] == var2_12 then
					arg0_11.contextData.indexDatas[var3_12] = var4_12
				else
					arg0_11.contextData.indexDatas[var3_12] = var2_12
				end

				arg0_11:closeDropdownPanel()
				arg0_11.uiList[arg0_11.updateListIndex]:align(#arg0_11.dropdownCfg.options)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.initFilters(arg0_14)
	arg0_14.contextData.indexDatas = arg0_14.contextData.indexDatas or {}
	arg0_14.uiList = {}

	for iter0_14, iter1_14 in ipairs(var0_0.FILTER_CONFIG) do
		local var0_14 = cloneTplTo(arg0_14.filterTpl, arg0_14.filterContainer)

		setText(arg0_14:findTF("title/title", var0_14), iter1_14.title)

		if not iter1_14.dropdown then
			arg0_14:initNormal(iter0_14, iter1_14, var0_14)
		else
			arg0_14:initDropdown(iter0_14, iter1_14, var0_14)
		end
	end
end

function var0_0.initNormal(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = arg0_15:findTF("content/container", arg3_15)
	local var1_15 = UIItemList.New(var0_15, arg0_15.itemTpl)

	var1_15:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventInit then
			local var0_16 = arg1_16 + 1
			local var1_16 = arg2_15.names[var0_16]
			local var2_16 = arg2_15.options[var0_16]

			setText(arg0_15:findTF("Text", arg2_16), var1_16)
			setActive(arg0_15:findTF("line", arg2_16), var0_16 ~= #arg2_15.names)
			setActive(arg0_15:findTF("arrow", arg2_16), false)

			if not arg0_15.contextData.indexDatas[arg2_15.tag] then
				arg0_15.contextData.indexDatas[arg2_15.tag] = arg2_15.default
			end

			onButton(arg0_15, arg2_16, function()
				if arg0_15.contextData.indexDatas[arg2_15.tag] == arg2_15.default then
					arg0_15.contextData.indexDatas[arg2_15.tag] = var2_16
				else
					arg0_15.contextData.indexDatas[arg2_15.tag] = bit.bxor(arg0_15.contextData.indexDatas[arg2_15.tag], var2_16)
				end

				if arg0_15.contextData.indexDatas[arg2_15.tag] == 0 then
					arg0_15.contextData.indexDatas[arg2_15.tag] = arg2_15.default
				end

				var1_15:align(#arg2_15.options)
			end, SFX_PANEL)
		elseif arg0_16 == UIItemList.EventUpdate then
			local var3_16 = arg1_16 + 1
			local var4_16 = arg2_15.options[var3_16]
			local var5_16
			local var6_16 = (arg0_15.contextData.indexDatas[arg2_15.tag] ~= arg2_15.default or false) and bit.band(arg0_15.contextData.indexDatas[arg2_15.tag], var4_16) > 0

			setActive(arg0_15:findTF("selected", arg2_16), var6_16)
			setTextColor(arg0_15:findTF("Text", arg2_16), var6_16 and Color.white or Color.NewHex("393a3c"))
		end
	end)
	var1_15:align(#arg2_15.options)

	arg0_15.uiList[arg1_15] = var1_15
end

function var0_0.initDropdown(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18:findTF("content/container", arg3_18)
	local var1_18 = UIItemList.New(var0_18, arg0_18.itemTpl)

	var1_18:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventInit then
			local var0_19 = arg1_19 + 1
			local var1_19 = arg2_18.tags[var0_19]
			local var2_19 = arg2_18.defaults[var0_19]

			setActive(arg0_18:findTF("line", arg2_19), var0_19 ~= #arg2_18.tags)
			setActive(arg0_18:findTF("arrow", arg2_19), true)

			if not arg0_18.contextData.indexDatas[var1_19] then
				arg0_18.contextData.indexDatas[var1_19] = var2_19
			end

			onButton(arg0_18, arg2_19, function()
				arg0_18.dropdownCfg = arg2_18
				arg0_18.dropdownCfgIndex = var0_19
				arg0_18.updateListIndex = arg1_18

				local var0_20 = arg0_18._tf:InverseTransformPoint(arg2_19.position)

				arg0_18:showDropdownPanel(var0_20)
			end, SFX_PANEL)
		elseif arg0_19 == UIItemList.EventUpdate then
			local var3_19 = arg1_19 + 1
			local var4_19 = arg2_18.tags[var3_19]
			local var5_19 = arg2_18.defaults[var3_19]
			local var6_19 = ""
			local var7_19 = true

			if arg0_18.contextData.indexDatas[var4_19] == var5_19 then
				var7_19 = false
				var6_19 = arg2_18.names[var3_19][1]
			else
				local var8_19 = arg2_18.options[var3_19]

				for iter0_19, iter1_19 in ipairs(var8_19) do
					if arg0_18.contextData.indexDatas[var4_19] == iter1_19 then
						var6_19 = arg2_18.names[var3_19][iter0_19]

						break
					end
				end
			end

			setText(arg0_18:findTF("Text", arg2_19), var6_19)
			setActive(arg0_18:findTF("selected", arg2_19), var7_19)
			setTextColor(arg0_18:findTF("Text", arg2_19), var7_19 and Color.white or Color.NewHex("393a3c"))
			setImageColor(arg0_18:findTF("arrow", arg2_19), var7_19 and Color.white or Color.NewHex("393a3c"))
		end
	end)
	var1_18:align(#arg2_18.options)

	arg0_18.uiList[arg1_18] = var1_18
end

function var0_0.showDropdownPanel(arg0_21, arg1_21)
	setAnchoredPosition(arg0_21:findTF("dropdown", arg0_21.dropdownPanel), arg1_21)
	setActive(arg0_21.dropdownPanel, true)
	arg0_21.dropdownUIList:align(#arg0_21.dropdownCfg.options[arg0_21.dropdownCfgIndex] - 1)
end

function var0_0.closeDropdownPanel(arg0_22)
	setActive(arg0_22.dropdownPanel, false)
end

function var0_0._close(arg0_23)
	arg0_23.anim:Play("anim_educate_scheduleindex_out")
end

function var0_0.onBackPressed(arg0_24)
	arg0_24:_close()
end

function var0_0.willExit(arg0_25)
	arg0_25.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_25._tf)
end

return var0_0
