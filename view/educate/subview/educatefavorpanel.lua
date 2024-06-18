local var0_0 = class("EducateFavorPanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "EducateFavorPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.favorPanelTF = arg0_2:findTF("favor_panel")
	arg0_2.favorPanelAnim = arg0_2.favorPanelTF:GetComponent(typeof(Animation))
	arg0_2.favorPanelAnimEvent = arg0_2.favorPanelTF:GetComponent(typeof(DftAniEvent))

	arg0_2.favorPanelAnimEvent:SetEndEvent(function()
		setActive(arg0_2.favorPanelTF, false)
	end)
	setActive(arg0_2.favorPanelTF, false)

	arg0_2.favorUIList = UIItemList.New(arg0_2:findTF("panel/bg/view/content", arg0_2.favorPanelTF), arg0_2:findTF("panel/bg/view/content/tpl", arg0_2.favorPanelTF))
	arg0_2.favorCurTF = arg0_2:findTF("panel/bg/cur", arg0_2.favorPanelTF)

	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_2._tf, {
		pbList = {
			arg0_2:findTF("panel/bg", arg0_2.favorPanelTF)
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER
	})
	arg0_2:addListener()
	arg0_2:Flush()
end

function var0_0.addListener(arg0_4)
	onButton(arg0_4, arg0_4.favorPanelTF, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	arg0_4.favorUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_4:updateFavorItem(arg1_6, arg2_6)
		end
	end)
end

function var0_0.updateFavorPanel(arg0_7)
	arg0_7.char = getProxy(EducateProxy):GetCharData()

	local var0_7 = arg0_7.char:GetFavor()

	setText(arg0_7:findTF("lv", arg0_7.favorCurTF), var0_7.lv)

	local var1_7 = arg0_7.char:GetFavorUpgradExp(var0_7.lv)
	local var2_7 = var0_7.exp .. "/" .. var1_7

	setText(arg0_7:findTF("progress", arg0_7.favorCurTF), i18n("child_favor_progress", var2_7))
	setSlider(arg0_7:findTF("slider", arg0_7.favorCurTF), 0, 1, var0_7.exp / var1_7)
	arg0_7.favorUIList:align(arg0_7.char:getConfig("favor_level") - 1)
end

function var0_0.updateFavorItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8 + 1

	setText(arg0_8:findTF("lv", arg2_8), var0_8 + 1)

	local var1_8 = var0_8 < arg0_8.char:GetFavor().lv

	setActive(arg0_8:findTF("lock", arg2_8), not var1_8)
	setActive(arg0_8:findTF("unlock", arg2_8), var1_8)

	if not var1_8 then
		local var2_8 = arg0_8.char:GetFavorUpgradExp(var0_8)

		setText(arg0_8:findTF("Text", arg2_8), i18n("child_favor_lock1", var0_8 + 1))
		setTextColor(arg0_8:findTF("Text", arg2_8), Color.NewHex("F5F5F5"))
		setTextColor(arg0_8:findTF("lv", arg2_8), Color.NewHex("F5F5F5"))
	else
		local var3_8 = arg0_8.char:GetPerformByReplace(var0_8)

		if var3_8[1] then
			local var4_8 = pg.child_performance[var3_8[1]].param
			local var5_8 = arg0_8:getStoryTitle(var4_8)

			setText(arg0_8:findTF("Text", arg2_8), var5_8)
		end

		setTextColor(arg0_8:findTF("Text", arg2_8), Color.NewHex("393A3C"))
		setTextColor(arg0_8:findTF("lv", arg2_8), Color.NewHex("FFFFFF"))
		onButton(arg0_8, arg0_8:findTF("unlock", arg2_8), function()
			pg.PerformMgr.GetInstance():PlayOne(var3_8[1])
		end, SFX_PANEL)
	end
end

function var0_0.getStoryTitle(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(pg.memory_template.all) do
		local var0_10 = pg.memory_template[iter1_10]

		if var0_10.story == arg1_10 then
			return var0_10.title
		end
	end

	return arg1_10
end

function var0_0.Show(arg0_11)
	if not arg0_11:GetLoaded() then
		return
	end

	setActive(arg0_11.favorPanelTF, true)
	arg0_11:updateFavorPanel()
end

function var0_0.Hide(arg0_12)
	arg0_12.favorPanelAnim:Play("anim_educate_educateUI_favor_out")
end

function var0_0.Flush(arg0_13)
	if not arg0_13:GetLoaded() then
		return
	end

	arg0_13:updateFavorPanel()
end

function var0_0.OnDestroy(arg0_14)
	arg0_14.favorPanelAnimEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf)
end

return var0_0
