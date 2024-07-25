local var0_0 = class("MapBuilderAtelier", import(".MapBuilderNormal"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPEATELIER
end

function var0_0.OnShow(arg0_2)
	var0_0.super.OnShow(arg0_2)

	local var0_2 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_lianjin")

	setImageSprite(arg0_2.sceneParent.actEliteBtn, var0_2, true)
end

function var0_0.OnHide(arg0_3)
	local var0_3 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_elite")

	setImageSprite(arg0_3.sceneParent.actEliteBtn, var0_3, true)
	var0_0.super.OnHide(arg0_3)
end

function var0_0.UpdateButtons(arg0_4)
	var0_0.super.UpdateButtons(arg0_4)

	local var0_4 = arg0_4.data:getConfig("type")

	setActive(arg0_4.sceneParent.actAtelierBuffBtn, var0_4 > Map.ACTIVITY_EASY)
end

return var0_0
