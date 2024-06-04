local var0 = class("EducateFavorPanel", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "EducateFavorPanel"
end

function var0.OnInit(arg0)
	arg0.favorPanelTF = arg0:findTF("favor_panel")
	arg0.favorPanelAnim = arg0.favorPanelTF:GetComponent(typeof(Animation))
	arg0.favorPanelAnimEvent = arg0.favorPanelTF:GetComponent(typeof(DftAniEvent))

	arg0.favorPanelAnimEvent:SetEndEvent(function()
		setActive(arg0.favorPanelTF, false)
	end)
	setActive(arg0.favorPanelTF, false)

	arg0.favorUIList = UIItemList.New(arg0:findTF("panel/bg/view/content", arg0.favorPanelTF), arg0:findTF("panel/bg/view/content/tpl", arg0.favorPanelTF))
	arg0.favorCurTF = arg0:findTF("panel/bg/cur", arg0.favorPanelTF)

	pg.UIMgr.GetInstance():OverlayPanelPB(arg0._tf, {
		pbList = {
			arg0:findTF("panel/bg", arg0.favorPanelTF)
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER
	})
	arg0:addListener()
	arg0:Flush()
end

function var0.addListener(arg0)
	onButton(arg0, arg0.favorPanelTF, function()
		arg0:Hide()
	end, SFX_PANEL)
	arg0.favorUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateFavorItem(arg1, arg2)
		end
	end)
end

function var0.updateFavorPanel(arg0)
	arg0.char = getProxy(EducateProxy):GetCharData()

	local var0 = arg0.char:GetFavor()

	setText(arg0:findTF("lv", arg0.favorCurTF), var0.lv)

	local var1 = arg0.char:GetFavorUpgradExp(var0.lv)
	local var2 = var0.exp .. "/" .. var1

	setText(arg0:findTF("progress", arg0.favorCurTF), i18n("child_favor_progress", var2))
	setSlider(arg0:findTF("slider", arg0.favorCurTF), 0, 1, var0.exp / var1)
	arg0.favorUIList:align(arg0.char:getConfig("favor_level") - 1)
end

function var0.updateFavorItem(arg0, arg1, arg2)
	local var0 = arg1 + 1

	setText(arg0:findTF("lv", arg2), var0 + 1)

	local var1 = var0 < arg0.char:GetFavor().lv

	setActive(arg0:findTF("lock", arg2), not var1)
	setActive(arg0:findTF("unlock", arg2), var1)

	if not var1 then
		local var2 = arg0.char:GetFavorUpgradExp(var0)

		setText(arg0:findTF("Text", arg2), i18n("child_favor_lock1", var0 + 1))
		setTextColor(arg0:findTF("Text", arg2), Color.NewHex("F5F5F5"))
		setTextColor(arg0:findTF("lv", arg2), Color.NewHex("F5F5F5"))
	else
		local var3 = arg0.char:GetPerformByReplace(var0)

		if var3[1] then
			local var4 = pg.child_performance[var3[1]].param
			local var5 = arg0:getStoryTitle(var4)

			setText(arg0:findTF("Text", arg2), var5)
		end

		setTextColor(arg0:findTF("Text", arg2), Color.NewHex("393A3C"))
		setTextColor(arg0:findTF("lv", arg2), Color.NewHex("FFFFFF"))
		onButton(arg0, arg0:findTF("unlock", arg2), function()
			pg.PerformMgr.GetInstance():PlayOne(var3[1])
		end, SFX_PANEL)
	end
end

function var0.getStoryTitle(arg0, arg1)
	for iter0, iter1 in ipairs(pg.memory_template.all) do
		local var0 = pg.memory_template[iter1]

		if var0.story == arg1 then
			return var0.title
		end
	end

	return arg1
end

function var0.Show(arg0)
	if not arg0:GetLoaded() then
		return
	end

	setActive(arg0.favorPanelTF, true)
	arg0:updateFavorPanel()
end

function var0.Hide(arg0)
	arg0.favorPanelAnim:Play("anim_educate_educateUI_favor_out")
end

function var0.Flush(arg0)
	if not arg0:GetLoaded() then
		return
	end

	arg0:updateFavorPanel()
end

function var0.OnDestroy(arg0)
	arg0.favorPanelAnimEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
