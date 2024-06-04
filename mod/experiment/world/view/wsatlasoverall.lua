local var0 = class("WSAtlasOverall", import(".WSAtlas"))

var0.windowSize = Vector2(1747, 776)
var0.Fields = {
	tfMarkScene = "userdata",
	tfActiveMarkRect = "userdata"
}
var0.Listeners = {
	onUpdateActiveEntrance = "OnUpdateActiveEntrance"
}

function var0.Dispose(arg0)
	if arg0.tfActiveMarkRect then
		arg0:RemoveExtraMarkPrefab(arg0.tfActiveMarkRect)
		Destroy(arg0.tfActiveMarkRect)
	end

	arg0:RemoveExtraMarkPrefab(arg0.tfMarkScene)
	var0.super.Dispose(arg0)
end

function var0.LoadScene(arg0, arg1)
	SceneOpMgr.Inst:LoadSceneAsync("scenes/worldoverview", "worldoverview", LoadSceneMode.Additive, function(arg0, arg1)
		arg0.transform = tf(arg0:GetRootGameObjects()[0])

		setActive(arg0.transform, false)

		arg0.tfEntity = arg0.transform:Find("entity")
		arg0.tfMapScene = arg0.tfEntity:Find("map_scene")
		arg0.tfMapSelect = arg0.tfMapScene:Find("selected_layer")
		arg0.tfSpriteScene = arg0.tfEntity:Find("sprite_scene")
		arg0.tfMarkScene = arg0.tfEntity:Find("mark_scene")
		arg0.defaultSprite = arg0.tfEntity:Find("decolation_layer/edge"):GetComponent("SpriteRenderer").material
		arg0.addSprite = arg0.tfEntity:Find("map_scene/mask_layer"):GetComponent("SpriteRenderer").material

		arg0:UpdateCenterEffectDisplay()
		arg0:BuildActiveMark()

		arg0.cmPointer = arg0.tfEntity:Find("Plane"):GetComponent(typeof(PointerInfo))

		local var0 = nowWorld()

		arg0.cmPointer:AddColorMaskClickListener(function(arg0, arg1)
			local var0 = var0:ColorToEntrance(arg0)

			if var0 then
				arg0.onClickColor(var0, arg1.position)
			end
		end)

		arg0.tfCamera = arg0.transform:Find("Main Camera")

		CameraFittingSettin(arg0.tfCamera)

		return existCall(arg1)
	end)
end

function var0.ReturnScene(arg0)
	if arg0.tfEntity then
		SceneOpMgr.Inst:UnloadSceneAsync("scenes/worldoverview", "worldoverview")

		arg0.cmPointer = nil
	end
end

function var0.BuildActiveMark(arg0)
	var0.super.BuildActiveMark(arg0)
	arg0:DoUpdatExtraMark(arg0.tfActiveMark, "overview_player", true)

	arg0.tfActiveMarkRect = tf(GameObject.New())
	arg0.tfActiveMarkRect.gameObject.layer = Layer.UI
	arg0.tfActiveMarkRect.name = "active_mark_rect"

	arg0.tfActiveMarkRect:SetParent(arg0.tfSpriteScene, false)
	setActive(arg0.tfActiveMarkRect, false)
	arg0:DoUpdatExtraMark(arg0.tfActiveMarkRect, "overview_player_rect", true)
end

function var0.OnUpdateActiveEntrance(arg0, arg1, arg2, arg3)
	var0.super.OnUpdateActiveEntrance(arg0, arg1, arg2, arg3)

	if arg3 then
		arg0.tfActiveMarkRect.localPosition = arg0.tfActiveMark.localPosition
	end

	setActive(arg0.tfActiveMarkRect, arg3)
end

function var0.UpdateStaticMark(arg0, arg1, arg2)
	arg0:RemoveExtraMarkPrefab(arg0.tfMarkScene)

	for iter0, iter1 in pairs(arg1 or {}) do
		if iter1 then
			local var0 = arg0.atlas:GetEntrance(iter0)
			local var1 = var0:HasPort() and arg2[1] or arg2[2]

			if var1 then
				arg0:LoadExtraMarkPrefab(arg0.tfMarkScene, var1, function(arg0)
					tf(arg0).localPosition = WorldConst.CalcModelPosition(var0, arg0.spriteBaseSize)
				end)
			end
		end
	end

	var0.super.UpdateStaticMark(arg0, arg1)
end

function var0.UpdateTargetEntrance(arg0, arg1)
	local var0 = arg0.atlas:GetEntrance(arg1)
	local var1 = arg0.atlas:GetActiveEntrance()
	local var2 = calcPositionAngle(var0.config.area_pos[1] - var1.config.area_pos[1], var0.config.area_pos[2] - var1.config.area_pos[2])

	arg0.tfActiveMark.localEulerAngles = Vector3(0, var2, 0)
end

return var0
