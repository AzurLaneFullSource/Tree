local var0 = class("Dorm3dCollectAwardLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "Dorm3dCollectAwardUI"
end

function var0.preload(arg0, arg1)
	local var0 = pg.dorm3d_collection_template[arg0.contextData.itemId]

	GetSpriteFromAtlasAsync("dorm3dcollection/" .. var0.model, "", function(arg0)
		arg0.iconSprite = arg0

		arg1()
	end)
end

function var0.init(arg0)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0.didEnter(arg0)
	local var0 = pg.dorm3d_collection_template[arg0.contextData.itemId]

	setText(arg0._tf:Find("panel/name/Text"), var0.name)
	setText(arg0._tf:Find("panel/desc"), var0.desc)

	local var1 = pg.dorm3d_favor_trigger[var0.award].num

	setText(arg0._tf:Find("panel/favor/Image/Text"), string.format("favor plus:%d", var1))
	setImageSprite(arg0._tf:Find("panel/icon"), arg0.iconSprite, true)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
