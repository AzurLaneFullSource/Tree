local var0 = class("MapBuilderSenrankagura", import(".MapBuilderNormal"))

function var0.GetType(arg0)
	return MapBuilder.TYPESENRANKAGURA
end

function var0.ShowButtons(arg0)
	var0.super.ShowButtons(arg0)

	local var0 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_challenge")

	setImageSprite(arg0.sceneParent.actEliteBtn, var0, true)
end

function var0.HideButtons(arg0)
	local var0 = GetSpriteFromAtlas("ui/levelmainscene_atlas", "btn_elite")

	setImageSprite(arg0.sceneParent.actEliteBtn, var0, true)
	var0.super.HideButtons(arg0)
end

return var0
