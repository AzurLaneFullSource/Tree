local var0_0 = class("MapBuilderAtelier", import(".MapBuilderNormal"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPEATELIER
end

function var0_0.ShowButtons(arg0_2)
	var0_0.super.ShowButtons(arg0_2)

	local var0_2 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_lianjin")

	setImageSprite(arg0_2.sceneParent.actEliteBtn, var0_2, true)

	local var1_2 = arg0_2.data:getConfig("type")

	setActive(arg0_2.sceneParent.actAtelierBuffBtn, var1_2 > Map.ACTIVITY_EASY)
end

function var0_0.HideButtons(arg0_3)
	local var0_3 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_elite")

	setImageSprite(arg0_3.sceneParent.actEliteBtn, var0_3, true)
	setActive(arg0_3.sceneParent.actAtelierBuffBtn, false)
	var0_0.super.HideButtons(arg0_3)
end

return var0_0
