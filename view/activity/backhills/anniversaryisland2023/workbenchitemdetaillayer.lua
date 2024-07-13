local var0_0 = class("WorkBenchItemDetailLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "WorkBenchItemDetailLayer"
end

function var0_0.init(arg0_2)
	arg0_2.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("BG"), function()
		arg0_3:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("Window/Close"), function()
		arg0_3:onBackPressed()
	end, SFX_CANCEL)
	arg0_3:UpdateItemDetail()
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, nil, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.UpdateItemDetail(arg0_6)
	local var0_6 = arg0_6.contextData.material

	arg0_6:UpdateItem(arg0_6._tf:Find("Window/IconBG"), var0_6)
	setText(arg0_6._tf:Find("Window/Name"), var0_6:GetName())
	setText(arg0_6._tf:Find("Window/Description/Text"), var0_6:GetDesc())

	local var1_6 = var0_6:GetSource()

	setText(arg0_6._tf:Find("Window/Source"), var1_6[1] or "")
	onButton(arg0_6, arg0_6._tf:Find("Window/Go"), function()
		arg0_6:emit(GAME.WORKBENCH_ITEM_GO, var0_6:GetConfigID())
	end, SFX_PANEL)
	setActive(arg0_6._tf:Find("Window/Go"), table.getCount(var0_6:GetSource()) > 1)
end

local var1_0 = "ui/AtelierCommonUI_atlas"

function var0_0.UpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = "icon_frame_" .. arg2_8:GetRarity()

	arg0_8.loader:GetSpriteQuiet(var1_0, var0_8, arg1_8)
	arg0_8.loader:GetSpriteQuiet(arg2_8:GetIconPath(), "", arg1_8:Find("Icon"))

	if not IsNil(arg1_8:Find("Text")) then
		setText(arg1_8:Find("Text"), arg2_8.count)
	end
end

function var0_0.willExit(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf)
	arg0_9.loader:Clear()
end

return var0_0
