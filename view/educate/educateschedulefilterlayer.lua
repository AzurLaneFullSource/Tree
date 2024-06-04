local var0 = class("EducateScheduleFilterLayer", import(".base.EducateBaseUI"))

local function var1(arg0)
	local var0 = Clone(arg0)

	table.remove(var0, 1)

	return var0
end

var0.FILTER_CONFIG = {
	{
		tag = "typeIndex",
		dropdown = false,
		title = i18n("child_filter_type1"),
		options = var1(EducatePlanIndexConst.TypeIndexs),
		names = var1(EducatePlanIndexConst.TypeNames),
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
		options = var1(EducatePlanIndexConst.CostIndexs),
		names = var1(EducatePlanIndexConst.CostNames),
		default = EducatePlanIndexConst.CostAll
	}
}

function var0.getUIName(arg0)
	return "EducateScheduleIndexUI"
end

function var0.init(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.windowTF = arg0:findTF("anim_root/window")

	setText(arg0:findTF("top/title", arg0.windowTF), i18n("child_filter_title"))

	arg0.filterContainer = arg0:findTF("frame/filter_content", arg0.windowTF)
	arg0.filterTpl = arg0:findTF("anim_root/filter_tpl")
	arg0.itemTpl = arg0:findTF("anim_root/item_tpl")

	setActive(arg0.filterTpl, false)
	setActive(arg0.itemTpl, false)

	arg0.dropdownPanel = arg0:findTF("anim_root/dropdown_panel")
	arg0.dropdownUIList = UIItemList.New(arg0:findTF("dropdown/list", arg0.dropdownPanel), arg0:findTF("dropdown/list/tpl", arg0.dropdownPanel))

	setActive(arg0.dropdownPanel, false)
	setText(arg0:findTF("sure_btn/Text", arg0.windowTF), i18n("word_ok"))
	setText(arg0:findTF("reset_btn/Text", arg0.windowTF), i18n("word_reset"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("sure_btn", arg0.windowTF), function()
		if arg0.contextData.callback then
			arg0.contextData.callback(arg0.contextData.indexDatas)

			arg0.contextData.callback = nil
		end

		arg0:_close()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("reset_btn", arg0.windowTF), function()
		arg0.contextData.indexDatas = nil

		removeAllChildren(arg0.filterContainer)
		arg0:initFilters()
	end, SFX_PANEL)
	onButton(arg0, arg0.dropdownPanel, function()
		arg0:closeDropdownPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("anim_root/bg"), function()
		arg0:_close()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("top/close_btn", arg0.windowTF), function()
		arg0:_close()
	end, SFX_PANEL)
	arg0:initDropdownPanel()
	arg0:initFilters()
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER + 1
	})
end

function var0.initDropdownPanel(arg0)
	arg0.dropdownUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1 + 1
			local var1 = arg0.dropdownCfg.names[arg0.dropdownCfgIndex][var0]
			local var2 = arg0.dropdownCfg.options[arg0.dropdownCfgIndex][var0]
			local var3 = arg0.dropdownCfg.tags[arg0.dropdownCfgIndex]
			local var4 = arg0.dropdownCfg.defaults[arg0.dropdownCfgIndex]

			setActive(arg0:findTF("line", arg2), var0 ~= #arg0.dropdownCfg.options[arg0.dropdownCfgIndex])
			setText(arg0:findTF("Text", arg2), var1)
			onButton(arg0, arg2, function()
				if arg0.contextData.indexDatas[var3] == var2 then
					arg0.contextData.indexDatas[var3] = var4
				else
					arg0.contextData.indexDatas[var3] = var2
				end

				arg0:closeDropdownPanel()
				arg0.uiList[arg0.updateListIndex]:align(#arg0.dropdownCfg.options)
			end, SFX_PANEL)
		end
	end)
end

function var0.initFilters(arg0)
	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}
	arg0.uiList = {}

	for iter0, iter1 in ipairs(var0.FILTER_CONFIG) do
		local var0 = cloneTplTo(arg0.filterTpl, arg0.filterContainer)

		setText(arg0:findTF("title/title", var0), iter1.title)

		if not iter1.dropdown then
			arg0:initNormal(iter0, iter1, var0)
		else
			arg0:initDropdown(iter0, iter1, var0)
		end
	end
end

function var0.initNormal(arg0, arg1, arg2, arg3)
	local var0 = arg0:findTF("content/container", arg3)
	local var1 = UIItemList.New(var0, arg0.itemTpl)

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg1 + 1
			local var1 = arg2.names[var0]
			local var2 = arg2.options[var0]

			setText(arg0:findTF("Text", arg2), var1)
			setActive(arg0:findTF("line", arg2), var0 ~= #arg2.names)
			setActive(arg0:findTF("arrow", arg2), false)

			if not arg0.contextData.indexDatas[arg2.tag] then
				arg0.contextData.indexDatas[arg2.tag] = arg2.default
			end

			onButton(arg0, arg2, function()
				if arg0.contextData.indexDatas[arg2.tag] == arg2.default then
					arg0.contextData.indexDatas[arg2.tag] = var2
				else
					arg0.contextData.indexDatas[arg2.tag] = bit.bxor(arg0.contextData.indexDatas[arg2.tag], var2)
				end

				if arg0.contextData.indexDatas[arg2.tag] == 0 then
					arg0.contextData.indexDatas[arg2.tag] = arg2.default
				end

				var1:align(#arg2.options)
			end, SFX_PANEL)
		elseif arg0 == UIItemList.EventUpdate then
			local var3 = arg1 + 1
			local var4 = arg2.options[var3]
			local var5
			local var6 = (arg0.contextData.indexDatas[arg2.tag] ~= arg2.default or false) and bit.band(arg0.contextData.indexDatas[arg2.tag], var4) > 0

			setActive(arg0:findTF("selected", arg2), var6)
			setTextColor(arg0:findTF("Text", arg2), var6 and Color.white or Color.NewHex("393a3c"))
		end
	end)
	var1:align(#arg2.options)

	arg0.uiList[arg1] = var1
end

function var0.initDropdown(arg0, arg1, arg2, arg3)
	local var0 = arg0:findTF("content/container", arg3)
	local var1 = UIItemList.New(var0, arg0.itemTpl)

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg1 + 1
			local var1 = arg2.tags[var0]
			local var2 = arg2.defaults[var0]

			setActive(arg0:findTF("line", arg2), var0 ~= #arg2.tags)
			setActive(arg0:findTF("arrow", arg2), true)

			if not arg0.contextData.indexDatas[var1] then
				arg0.contextData.indexDatas[var1] = var2
			end

			onButton(arg0, arg2, function()
				arg0.dropdownCfg = arg2
				arg0.dropdownCfgIndex = var0
				arg0.updateListIndex = arg1

				local var0 = arg0._tf:InverseTransformPoint(arg2.position)

				arg0:showDropdownPanel(var0)
			end, SFX_PANEL)
		elseif arg0 == UIItemList.EventUpdate then
			local var3 = arg1 + 1
			local var4 = arg2.tags[var3]
			local var5 = arg2.defaults[var3]
			local var6 = ""
			local var7 = true

			if arg0.contextData.indexDatas[var4] == var5 then
				var7 = false
				var6 = arg2.names[var3][1]
			else
				local var8 = arg2.options[var3]

				for iter0, iter1 in ipairs(var8) do
					if arg0.contextData.indexDatas[var4] == iter1 then
						var6 = arg2.names[var3][iter0]

						break
					end
				end
			end

			setText(arg0:findTF("Text", arg2), var6)
			setActive(arg0:findTF("selected", arg2), var7)
			setTextColor(arg0:findTF("Text", arg2), var7 and Color.white or Color.NewHex("393a3c"))
			setImageColor(arg0:findTF("arrow", arg2), var7 and Color.white or Color.NewHex("393a3c"))
		end
	end)
	var1:align(#arg2.options)

	arg0.uiList[arg1] = var1
end

function var0.showDropdownPanel(arg0, arg1)
	setAnchoredPosition(arg0:findTF("dropdown", arg0.dropdownPanel), arg1)
	setActive(arg0.dropdownPanel, true)
	arg0.dropdownUIList:align(#arg0.dropdownCfg.options[arg0.dropdownCfgIndex] - 1)
end

function var0.closeDropdownPanel(arg0)
	setActive(arg0.dropdownPanel, false)
end

function var0._close(arg0)
	arg0.anim:Play("anim_educate_scheduleindex_out")
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
