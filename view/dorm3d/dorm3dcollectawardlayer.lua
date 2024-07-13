local var0_0 = class("Dorm3dCollectAwardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dCollectAwardUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = pg.dorm3d_collection_template[arg0_2.contextData.itemId]

	GetSpriteFromAtlasAsync("dorm3dcollection/" .. var0_2.model, "", function(arg0_3)
		arg0_2.iconSprite = arg0_3

		arg1_2()
	end)
end

function var0_0.init(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.didEnter(arg0_6)
	local var0_6 = pg.dorm3d_collection_template[arg0_6.contextData.itemId]

	setText(arg0_6._tf:Find("panel/name/Text"), var0_6.name)
	setText(arg0_6._tf:Find("panel/desc"), var0_6.desc)

	local var1_6 = pg.dorm3d_favor_trigger[var0_6.award].num

	setText(arg0_6._tf:Find("panel/favor/Image/Text"), string.format("favor plus:%d", var1_6))
	setImageSprite(arg0_6._tf:Find("panel/icon"), arg0_6.iconSprite, true)
end

function var0_0.willExit(arg0_7)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf)
end

return var0_0
