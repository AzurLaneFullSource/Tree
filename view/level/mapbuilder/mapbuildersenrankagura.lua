local var0_0 = class("MapBuilderSenrankagura", import(".MapBuilderNormal"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPESENRANKAGURA
end

function var0_0.OnShow(arg0_2)
	var0_0.super.OnShow(arg0_2)

	local var0_2 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_challenge")

	setImageSprite(arg0_2.sceneParent.actEliteBtn, var0_2, true)
end

function var0_0.OnHide(arg0_3)
	local var0_3 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_elite")

	setImageSprite(arg0_3.sceneParent.actEliteBtn, var0_3, true)
	var0_0.super.OnHide(arg0_3)
end

return var0_0
