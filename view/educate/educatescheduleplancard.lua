local var0_0 = class("EducateSchedulePlanCard")
local var1_0 = {
	top = 0,
	spacing = 8,
	size = {
		x = 216,
		y = 142
	}
}
local var2_0 = {
	top = 4,
	spacing = 14,
	size = {
		x = 216,
		y = 328
	}
}
local var3_0 = {
	x = 0,
	y = 87
}
local var4_0 = {
	x = 0,
	y = 110
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg0_1._go)
	arg0_1.viewComponent = arg2_1
	arg0_1.selectedTF = arg0_1._tf:Find("selected")
	arg0_1.iconBgTF = arg0_1._tf:Find("icon_bg")
	arg0_1.iconTF = arg0_1.iconBgTF:Find("icon")
	arg0_1.progressTF = arg0_1._tf:Find("progress")
	arg0_1.sliderTF = arg0_1._tf:Find("slider")
	arg0_1.nameTF = arg0_1._tf:Find("name_mask")
	arg0_1.nameTextTF = arg0_1.nameTF:Find("name")
	arg0_1.enNameTF = arg0_1._tf:Find("name_en")
	arg0_1.limitTF = arg0_1._tf:Find("limit")
	arg0_1.limitUIList = UIItemList.New(arg0_1.limitTF, arg0_1.limitTF:Find("tpl"))

	arg0_1.limitUIList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg0_1:updateLimitItem(arg1_2, arg2_2)
		end
	end)

	arg0_1.costTF = arg0_1._tf:Find("cost")
	arg0_1.costEmptyTF = arg0_1._tf:Find("cost_empty")

	setText(arg0_1.costEmptyTF:Find("Text"), i18n("child_plan_no_cost"))

	arg0_1.costUIList = UIItemList.New(arg0_1.costTF, arg0_1.costTF:Find("tpl"))

	arg0_1.costUIList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg0_1:updateCostItem(arg1_3, arg2_3)
		end
	end)

	arg0_1.awardTF = arg0_1._tf:Find("award")
	arg0_1.awardUIList = UIItemList.New(arg0_1.awardTF:Find("content"), arg0_1.awardTF:Find("content/tpl"))

	arg0_1.awardUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_1:updateAwardItem(arg1_4, arg2_4)
		end
	end)

	arg0_1.foldBtn = arg0_1.awardTF:Find("fold_btn")
	arg0_1.unfoldBtn = arg0_1.awardTF:Find("unfold_btn")
	arg0_1.awardLayouCom = arg0_1.awardTF:Find("content"):GetComponent(typeof(VerticalLayoutGroup))
	arg0_1.char = getProxy(EducateProxy):GetCharData()
end

function var0_0.updateLimitItem(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.limitCfg[arg1_5 + 1]
	local var1_5 = var0_5[2]

	LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var1_5, findTF(arg2_5, "icon_bg/icon"), true)
	setText(findTF(arg2_5, "value"), var0_5[3])
	setText(findTF(arg2_5, "name"), pg.child_attr[var1_5].name)

	local var2_5 = var0_5[4] and "606064" or "ed7373"

	setTextColor(findTF(arg2_5, "value"), Color.NewHex(var2_5))
	setTextColor(findTF(arg2_5, "name"), Color.NewHex(var2_5))
end

function var0_0.updateCostItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.costCfg[arg1_6 + 1]

	LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", "res_" .. var0_6.id, findTF(arg2_6, "icon"), true)
	setText(findTF(arg2_6, "value"), "-" .. var0_6.num)
	setText(findTF(arg2_6, "name"), pg.child_resource[var0_6.id].name)
end

function var0_0.updateAwardItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.awardCfg[arg1_7 + 1]
	local var1_7 = {
		type = var0_7[1],
		id = var0_7[2],
		number = var0_7[3]
	}

	EducateHelper.UpdateDropShowForAttr(arg2_7, var1_7)
end

function var0_0.update(arg0_8, arg1_8, arg2_8)
	setActive(arg0_8.selectedTF, arg1_8.id == arg2_8)
	GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", arg1_8:GetIconBgName(), arg0_8.iconBgTF, true)
	LoadImageSpriteAsync("educateprops/" .. arg1_8:getConfig("icon"), arg0_8.iconTF, true)

	local var0_8 = arg1_8:getConfig("pre_next")

	setActive(arg0_8.progressTF, var0_8 ~= 0)
	setActive(arg0_8.sliderTF, var0_8 ~= 0)
	setActive(arg0_8.enNameTF, var0_8 == 0)

	if var0_8 ~= 0 then
		assert(pg.child_plan[var0_8], "no exist next plan id" .. var0_8)

		local var1_8 = pg.child_plan[var0_8].pre[2]
		local var2_8 = getProxy(EducateProxy):GetPlanProxy():GetHistoryCntById(arg1_8.id)
		local var3_8 = var2_8 / var1_8

		setSlider(arg0_8.sliderTF, 0, 1, var3_8)
		setText(arg0_8.progressTF, var3_8 >= 1 and "MAX" or var2_8 .. "/" .. var1_8)
	end

	setScrollText(arg0_8.nameTextTF, arg1_8:getConfig("name"))
	setLocalPosition(arg0_8.nameTF, var0_8 == 0 and var4_0 or var3_0)

	local var4_8 = not arg1_8:IsMatchAttr(arg0_8.char)

	setActive(arg0_8.limitTF, var4_8)

	local var5_8 = arg1_8:getConfig("ability")

	arg0_8.limitCfg = {}

	for iter0_8 = 1, #var5_8 do
		local var6_8 = Clone(var5_8[iter0_8])
		local var7_8 = arg0_8.char:GetAttrById(var6_8[2]) >= var6_8[3]

		table.insert(var6_8, var7_8)
		table.insert(arg0_8.limitCfg, var6_8)
	end

	table.sort(arg0_8.limitCfg, CompareFuncs({
		function(arg0_9)
			return arg0_9[4] and 1 or 0
		end
	}))
	arg0_8.limitUIList:align(#arg0_8.limitCfg)

	arg0_8.costCfg = {}

	local var8_8, var9_8 = arg1_8:GetCost()

	if var8_8 > 0 then
		table.insert(arg0_8.costCfg, {
			id = EducateChar.RES_MONEY_ID,
			num = var8_8
		})
	end

	if var9_8 > 0 then
		table.insert(arg0_8.costCfg, {
			id = EducateChar.RES_MOOD_ID,
			num = var9_8
		})
	end

	setActive(arg0_8.costTF, not var4_8)
	setActive(arg0_8.costEmptyTF, not var4_8 and #arg0_8.costCfg == 0)
	arg0_8.costUIList:align(#arg0_8.costCfg)

	arg0_8.awardCfg = arg1_8:GetResult()

	arg0_8:setAwardParam(var1_0)
	arg0_8.awardUIList:align(#arg0_8.awardCfg > 2 and 2 or #arg0_8.awardCfg)
	setActive(arg0_8.unfoldBtn, #arg0_8.awardCfg > 2)
	setActive(arg0_8.foldBtn, false)
	onButton(arg0_8, arg0_8.unfoldBtn, function()
		arg0_8:setAwardParam(var2_0)
		setActive(arg0_8.foldBtn, true)
		setActive(arg0_8.unfoldBtn, false)
		setActive(arg0_8.limitTF, false)
		setActive(arg0_8.costTF, false)
		setActive(arg0_8.costEmptyTF, false)
		arg0_8.awardUIList:align(#arg0_8.awardCfg)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.foldBtn, function()
		arg0_8:setAwardParam(var1_0)
		setActive(arg0_8.foldBtn, false)
		setActive(arg0_8.unfoldBtn, true)
		setActive(arg0_8.limitTF, var4_8)
		setActive(arg0_8.costTF, not var4_8)
		setActive(arg0_8.costEmptyTF, not var4_8 and #arg0_8.costCfg == 0)
		arg0_8.awardUIList:align(#arg0_8.awardCfg > 2 and 2 or #arg0_8.awardCfg)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf, function()
		arg0_8.viewComponent:OnPlanCardClick(arg1_8)
	end, SFX_PANEL)
end

function var0_0.setAwardParam(arg0_13, arg1_13)
	setSizeDelta(arg0_13.awardTF, arg1_13.size)

	arg0_13.awardLayouCom.spacing = arg1_13.spacing
	arg0_13.awardLayouCom.padding.top = arg1_13.top
end

function var0_0.dispose(arg0_14)
	pg.DelegateInfo.Dispose(arg0_14)
end

return var0_0
