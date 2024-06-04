local var0 = class("EducateSchedulePlanCard")
local var1 = {
	top = 0,
	spacing = 8,
	size = {
		x = 216,
		y = 142
	}
}
local var2 = {
	top = 4,
	spacing = 14,
	size = {
		x = 216,
		y = 328
	}
}
local var3 = {
	x = 0,
	y = 87
}
local var4 = {
	x = 0,
	y = 110
}

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._go = arg1
	arg0._tf = tf(arg0._go)
	arg0.viewComponent = arg2
	arg0.selectedTF = arg0._tf:Find("selected")
	arg0.iconBgTF = arg0._tf:Find("icon_bg")
	arg0.iconTF = arg0.iconBgTF:Find("icon")
	arg0.progressTF = arg0._tf:Find("progress")
	arg0.sliderTF = arg0._tf:Find("slider")
	arg0.nameTF = arg0._tf:Find("name_mask")
	arg0.nameTextTF = arg0.nameTF:Find("name")
	arg0.enNameTF = arg0._tf:Find("name_en")
	arg0.limitTF = arg0._tf:Find("limit")
	arg0.limitUIList = UIItemList.New(arg0.limitTF, arg0.limitTF:Find("tpl"))

	arg0.limitUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateLimitItem(arg1, arg2)
		end
	end)

	arg0.costTF = arg0._tf:Find("cost")
	arg0.costEmptyTF = arg0._tf:Find("cost_empty")

	setText(arg0.costEmptyTF:Find("Text"), i18n("child_plan_no_cost"))

	arg0.costUIList = UIItemList.New(arg0.costTF, arg0.costTF:Find("tpl"))

	arg0.costUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateCostItem(arg1, arg2)
		end
	end)

	arg0.awardTF = arg0._tf:Find("award")
	arg0.awardUIList = UIItemList.New(arg0.awardTF:Find("content"), arg0.awardTF:Find("content/tpl"))

	arg0.awardUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateAwardItem(arg1, arg2)
		end
	end)

	arg0.foldBtn = arg0.awardTF:Find("fold_btn")
	arg0.unfoldBtn = arg0.awardTF:Find("unfold_btn")
	arg0.awardLayouCom = arg0.awardTF:Find("content"):GetComponent(typeof(VerticalLayoutGroup))
	arg0.char = getProxy(EducateProxy):GetCharData()
end

function var0.updateLimitItem(arg0, arg1, arg2)
	local var0 = arg0.limitCfg[arg1 + 1]
	local var1 = var0[2]

	LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var1, findTF(arg2, "icon_bg/icon"), true)
	setText(findTF(arg2, "value"), var0[3])
	setText(findTF(arg2, "name"), pg.child_attr[var1].name)

	local var2 = var0[4] and "606064" or "ed7373"

	setTextColor(findTF(arg2, "value"), Color.NewHex(var2))
	setTextColor(findTF(arg2, "name"), Color.NewHex(var2))
end

function var0.updateCostItem(arg0, arg1, arg2)
	local var0 = arg0.costCfg[arg1 + 1]

	LoadImageSpriteAtlasAsync("ui/educatecommonui_atlas", "res_" .. var0.id, findTF(arg2, "icon"), true)
	setText(findTF(arg2, "value"), "-" .. var0.num)
	setText(findTF(arg2, "name"), pg.child_resource[var0.id].name)
end

function var0.updateAwardItem(arg0, arg1, arg2)
	local var0 = arg0.awardCfg[arg1 + 1]
	local var1 = {
		type = var0[1],
		id = var0[2],
		number = var0[3]
	}

	EducateHelper.UpdateDropShowForAttr(arg2, var1)
end

function var0.update(arg0, arg1, arg2)
	setActive(arg0.selectedTF, arg1.id == arg2)
	GetImageSpriteFromAtlasAsync("ui/educatescheduleui_atlas", arg1:GetIconBgName(), arg0.iconBgTF, true)
	LoadImageSpriteAsync("educateprops/" .. arg1:getConfig("icon"), arg0.iconTF, true)

	local var0 = arg1:getConfig("pre_next")

	setActive(arg0.progressTF, var0 ~= 0)
	setActive(arg0.sliderTF, var0 ~= 0)
	setActive(arg0.enNameTF, var0 == 0)

	if var0 ~= 0 then
		assert(pg.child_plan[var0], "no exist next plan id" .. var0)

		local var1 = pg.child_plan[var0].pre[2]
		local var2 = getProxy(EducateProxy):GetPlanProxy():GetHistoryCntById(arg1.id)
		local var3 = var2 / var1

		setSlider(arg0.sliderTF, 0, 1, var3)
		setText(arg0.progressTF, var3 >= 1 and "MAX" or var2 .. "/" .. var1)
	end

	setScrollText(arg0.nameTextTF, arg1:getConfig("name"))
	setLocalPosition(arg0.nameTF, var0 == 0 and var4 or var3)

	local var4 = not arg1:IsMatchAttr(arg0.char)

	setActive(arg0.limitTF, var4)

	local var5 = arg1:getConfig("ability")

	arg0.limitCfg = {}

	for iter0 = 1, #var5 do
		local var6 = Clone(var5[iter0])
		local var7 = arg0.char:GetAttrById(var6[2]) >= var6[3]

		table.insert(var6, var7)
		table.insert(arg0.limitCfg, var6)
	end

	table.sort(arg0.limitCfg, CompareFuncs({
		function(arg0)
			return arg0[4] and 1 or 0
		end
	}))
	arg0.limitUIList:align(#arg0.limitCfg)

	arg0.costCfg = {}

	local var8, var9 = arg1:GetCost()

	if var8 > 0 then
		table.insert(arg0.costCfg, {
			id = EducateChar.RES_MONEY_ID,
			num = var8
		})
	end

	if var9 > 0 then
		table.insert(arg0.costCfg, {
			id = EducateChar.RES_MOOD_ID,
			num = var9
		})
	end

	setActive(arg0.costTF, not var4)
	setActive(arg0.costEmptyTF, not var4 and #arg0.costCfg == 0)
	arg0.costUIList:align(#arg0.costCfg)

	arg0.awardCfg = arg1:GetResult()

	arg0:setAwardParam(var1)
	arg0.awardUIList:align(#arg0.awardCfg > 2 and 2 or #arg0.awardCfg)
	setActive(arg0.unfoldBtn, #arg0.awardCfg > 2)
	setActive(arg0.foldBtn, false)
	onButton(arg0, arg0.unfoldBtn, function()
		arg0:setAwardParam(var2)
		setActive(arg0.foldBtn, true)
		setActive(arg0.unfoldBtn, false)
		setActive(arg0.limitTF, false)
		setActive(arg0.costTF, false)
		setActive(arg0.costEmptyTF, false)
		arg0.awardUIList:align(#arg0.awardCfg)
	end, SFX_PANEL)
	onButton(arg0, arg0.foldBtn, function()
		arg0:setAwardParam(var1)
		setActive(arg0.foldBtn, false)
		setActive(arg0.unfoldBtn, true)
		setActive(arg0.limitTF, var4)
		setActive(arg0.costTF, not var4)
		setActive(arg0.costEmptyTF, not var4 and #arg0.costCfg == 0)
		arg0.awardUIList:align(#arg0.awardCfg > 2 and 2 or #arg0.awardCfg)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0.viewComponent:OnPlanCardClick(arg1)
	end, SFX_PANEL)
end

function var0.setAwardParam(arg0, arg1)
	setSizeDelta(arg0.awardTF, arg1.size)

	arg0.awardLayouCom.spacing = arg1.spacing
	arg0.awardLayouCom.padding.top = arg1.top
end

function var0.dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
