local var0_0 = class("Dorm3dCollectAwardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dCollectAwardUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = var0_0.super.getResource(arg0_2)
	local var1_2 = pg.dorm3d_collection_template[arg0_2.contextData.itemId]

	table.insert(var0_2, "dorm3dcollection/" .. var1_2.icon)

	return var0_2
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = pg.dorm3d_collection_template[arg0_3.contextData.itemId]

	GetSpriteFromAtlasAsync("dorm3dcollection/" .. var0_3.icon, "", function(arg0_4)
		arg0_3.iconSprite = arg0_4

		arg1_3()
	end)
end

function var0_0.init(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("bg"), function()
		if arg0_5.isBlock then
			return
		end

		arg0_5:closeView()
	end, SFX_CANCEL)

	arg0_5.isBlock = true

	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
end

function var0_0.onBackPressed(arg0_7)
	if arg0_7.isBlock then
		return
	end

	var0_0.super.onBackPressed(arg0_7)
end

function var0_0.didEnter(arg0_8)
	local var0_8 = pg.dorm3d_collection_template[arg0_8.contextData.itemId]

	setText(arg0_8._tf:Find("panel/name/Text"), var0_8.name)
	setText(arg0_8._tf:Find("panel/desc/content/desc"), var0_8.desc)

	if var0_8.award > 0 then
		local var1_8 = pg.dorm3d_favor_trigger[var0_8.award].num

		setText(arg0_8._tf:Find("panel/favor/Text"), i18n("dorm3d_collect_favor_plus") .. var1_8)
		setActive(arg0_8._tf:Find("panel/favor"), arg0_8.contextData.isNew)
	else
		setActive(arg0_8._tf:Find("panel/favor"), false)
	end

	setImageSprite(arg0_8._tf:Find("panel/icon"), GetSpriteFromAtlas("dorm3dcollection/" .. var0_8.icon, ""), true)
	LeanTween.delayedCall(1.5, System.Action(function()
		arg0_8.isBlock = false
	end))
end

function var0_0.willExit(arg0_10)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10._tf)
end

return var0_0
