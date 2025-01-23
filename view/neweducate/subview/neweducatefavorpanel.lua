local var0_0 = class("NewEducateFavorPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewEducateFavorPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.favorPanelTF = arg0_2._tf:Find("favor_panel")
	arg0_2.favorPanelAnim = arg0_2.favorPanelTF:GetComponent(typeof(Animation))
	arg0_2.favorPanelAnimEvent = arg0_2.favorPanelTF:GetComponent(typeof(DftAniEvent))

	arg0_2.favorPanelAnimEvent:SetEndEvent(function()
		setActive(arg0_2.favorPanelTF, false)
	end)
	setActive(arg0_2.favorPanelTF, false)

	local var0_2 = arg0_2._tf:Find("favor_panel/panel")
	local var1_2 = var0_2:Find("bg/view/content")

	arg0_2.favorUIList = UIItemList.New(var1_2, var1_2:Find("tpl"))
	arg0_2.favorCurTF = var0_2:Find("bg/cur")

	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_2._tf, {
		pbList = {
			var0_2:Find("bg")
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER
	})
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("favor_panel"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
	arg0_4.favorUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_4:UpdateItem(arg1_6, arg2_6)
		end
	end)
end

function var0_0.UpdateFavorPanel(arg0_7)
	local var0_7 = arg0_7.contextData.char:GetFavorInfo()

	setText(arg0_7.favorCurTF:Find("lv"), var0_7.lv)

	local var1_7 = arg0_7.contextData.char:getConfig("favor_exp")[var0_7.lv]
	local var2_7 = var0_7.value .. "/" .. (var1_7 or "Max")

	setText(arg0_7.favorCurTF:Find("progress"), i18n("child_favor_progress", var2_7))
	setSlider(arg0_7.favorCurTF:Find("slider"), 0, 1, var1_7 and var0_7.value / var1_7 or 1)
	arg0_7.favorUIList:align(arg0_7.contextData.char:getConfig("favor_level") - 1)
end

function var0_0.UpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8 + 1

	setText(arg2_8:Find("lv"), var0_8 + 1)

	local var1_8 = var0_8 < arg0_8.contextData.char:GetFavorInfo().lv

	setActive(arg2_8:Find("lock"), not var1_8)
	setActive(arg2_8:Find("award/got"), var1_8)
	setText(arg2_8:Find("Text"), i18n("child_favor_lock1", var0_8 + 1))
	setTextColor(arg2_8:Find("Text"), Color.NewHex(var1_8 and "393A3C" or "F5F5F5"))
	setTextColor(arg2_8:Find("lv"), Color.NewHex(var1_8 and "FFFFFF" or "F5F5F5"))

	local var2_8 = arg0_8.contextData.char:getConfig("favor_result_display")[var0_8]
	local var3_8 = NewEducateHelper.Config2Drop(var2_8)

	NewEducateHelper.UpdateItem(arg2_8:Find("award/item"), var3_8)
	onButton(arg0_8, arg2_8:Find("award"), function()
		arg0_8:emit(NewEducateBaseUI.ON_ITEM, {
			drop = var3_8
		})
	end, SFX_PANEL)
end

function var0_0.Show(arg0_10)
	var0_0.super.Show(arg0_10)
	setActive(arg0_10.favorPanelTF, true)
	arg0_10:UpdateFavorPanel()
end

function var0_0.Hide(arg0_11)
	arg0_11.favorPanelAnim:Play("anim_educate_educateUI_favor_out")
end

function var0_0.OnDestroy(arg0_12)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
end

return var0_0
