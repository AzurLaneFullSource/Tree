local var0 = class("MapBuilderAtelier", import(".MapBuilderNormal"))

function var0.GetType(arg0)
	return MapBuilder.TYPEATELIER
end

function var0.ShowButtons(arg0)
	var0.super.ShowButtons(arg0)

	local var0 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_lianjin")

	setImageSprite(arg0.sceneParent.actEliteBtn, var0, true)

	local var1 = arg0.data:getConfig("type")

	setActive(arg0.sceneParent.actAtelierBuffBtn, var1 > Map.ACTIVITY_EASY)
end

function var0.HideButtons(arg0)
	local var0 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_elite")

	setImageSprite(arg0.sceneParent.actEliteBtn, var0, true)
	setActive(arg0.sceneParent.actAtelierBuffBtn, false)
	var0.super.HideButtons(arg0)
end

return var0
