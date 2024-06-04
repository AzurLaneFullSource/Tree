local var0 = class("WorkBenchItemDetailLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "WorkBenchItemDetailLayer"
end

function var0.init(arg0)
	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Window/Close"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	arg0:UpdateItemDetail()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, nil, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.UpdateItemDetail(arg0)
	local var0 = arg0.contextData.material

	arg0:UpdateItem(arg0._tf:Find("Window/IconBG"), var0)
	setText(arg0._tf:Find("Window/Name"), var0:GetName())
	setText(arg0._tf:Find("Window/Description/Text"), var0:GetDesc())

	local var1 = var0:GetSource()

	setText(arg0._tf:Find("Window/Source"), var1[1] or "")
	onButton(arg0, arg0._tf:Find("Window/Go"), function()
		arg0:emit(GAME.WORKBENCH_ITEM_GO, var0:GetConfigID())
	end, SFX_PANEL)
	setActive(arg0._tf:Find("Window/Go"), table.getCount(var0:GetSource()) > 1)
end

local var1 = "ui/AtelierCommonUI_atlas"

function var0.UpdateItem(arg0, arg1, arg2)
	local var0 = "icon_frame_" .. arg2:GetRarity()

	arg0.loader:GetSpriteQuiet(var1, var0, arg1)
	arg0.loader:GetSpriteQuiet(arg2:GetIconPath(), "", arg1:Find("Icon"))

	if not IsNil(arg1:Find("Text")) then
		setText(arg1:Find("Text"), arg2.count)
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0.loader:Clear()
end

return var0
