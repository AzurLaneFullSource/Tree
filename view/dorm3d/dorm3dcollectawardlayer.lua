local var0_0 = class("Dorm3dCollectAwardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dCollectAwardUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = pg.dorm3d_collection_template[arg0_2.contextData.itemId]

	GetSpriteFromAtlasAsync("dorm3dcollection/" .. var0_2.icon, "", function(arg0_3)
		arg0_2.iconSprite = arg0_3

		arg1_2()
	end)
end

function var0_0.init(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		if arg0_4.isBlock then
			return
		end

		arg0_4:closeView()
	end, SFX_CANCEL)

	arg0_4.isBlock = true

	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
end

function var0_0.onBackPressed(arg0_6)
	if arg0_6.isBlock then
		return
	end

	var0_0.super.onBackPressed(arg0_6)
end

function var0_0.didEnter(arg0_7)
	local var0_7 = pg.dorm3d_collection_template[arg0_7.contextData.itemId]

	setText(arg0_7._tf:Find("panel/name/Text"), var0_7.name)
	setText(arg0_7._tf:Find("panel/desc/content/desc"), var0_7.desc)

	if var0_7.award > 0 then
		local var1_7 = pg.dorm3d_favor_trigger[var0_7.award].num

		setText(arg0_7._tf:Find("panel/favor/Text"), i18n("dorm3d_collect_favor_plus") .. var1_7)
		setActive(arg0_7._tf:Find("panel/favor"), arg0_7.contextData.isNew)
	else
		setActive(arg0_7._tf:Find("panel/favor"), false)
	end

	setImageSprite(arg0_7._tf:Find("panel/icon"), arg0_7.iconSprite, true)
	LeanTween.delayedCall(1.5, System.Action(function()
		arg0_7.isBlock = false
	end))
end

function var0_0.willExit(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf)
end

return var0_0
