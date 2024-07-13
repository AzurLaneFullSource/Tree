local var0_0 = class("WSAtlasOverall", import(".WSAtlas"))

var0_0.windowSize = Vector2(1747, 776)
var0_0.Fields = {
	tfMarkScene = "userdata",
	tfActiveMarkRect = "userdata"
}
var0_0.Listeners = {
	onUpdateActiveEntrance = "OnUpdateActiveEntrance"
}

function var0_0.Dispose(arg0_1)
	if arg0_1.tfActiveMarkRect then
		arg0_1:RemoveExtraMarkPrefab(arg0_1.tfActiveMarkRect)
		Destroy(arg0_1.tfActiveMarkRect)
	end

	arg0_1:RemoveExtraMarkPrefab(arg0_1.tfMarkScene)
	var0_0.super.Dispose(arg0_1)
end

function var0_0.LoadScene(arg0_2, arg1_2)
	SceneOpMgr.Inst:LoadSceneAsync("scenes/worldoverview", "worldoverview", LoadSceneMode.Additive, function(arg0_3, arg1_3)
		arg0_2.transform = tf(arg0_3:GetRootGameObjects()[0])

		setActive(arg0_2.transform, false)

		arg0_2.tfEntity = arg0_2.transform:Find("entity")
		arg0_2.tfMapScene = arg0_2.tfEntity:Find("map_scene")
		arg0_2.tfMapSelect = arg0_2.tfMapScene:Find("selected_layer")
		arg0_2.tfSpriteScene = arg0_2.tfEntity:Find("sprite_scene")
		arg0_2.tfMarkScene = arg0_2.tfEntity:Find("mark_scene")
		arg0_2.defaultSprite = arg0_2.tfEntity:Find("decolation_layer/edge"):GetComponent("SpriteRenderer").material
		arg0_2.addSprite = arg0_2.tfEntity:Find("map_scene/mask_layer"):GetComponent("SpriteRenderer").material

		arg0_2:UpdateCenterEffectDisplay()
		arg0_2:BuildActiveMark()

		arg0_2.cmPointer = arg0_2.tfEntity:Find("Plane"):GetComponent(typeof(PointerInfo))

		local var0_3 = nowWorld()

		arg0_2.cmPointer:AddColorMaskClickListener(function(arg0_4, arg1_4)
			local var0_4 = var0_3:ColorToEntrance(arg0_4)

			if var0_4 then
				arg0_2.onClickColor(var0_4, arg1_4.position)
			end
		end)

		arg0_2.tfCamera = arg0_2.transform:Find("Main Camera")

		CameraFittingSettin(arg0_2.tfCamera)

		return existCall(arg1_2)
	end)
end

function var0_0.ReturnScene(arg0_5)
	if arg0_5.tfEntity then
		SceneOpMgr.Inst:UnloadSceneAsync("scenes/worldoverview", "worldoverview")

		arg0_5.cmPointer = nil
	end
end

function var0_0.BuildActiveMark(arg0_6)
	var0_0.super.BuildActiveMark(arg0_6)
	arg0_6:DoUpdatExtraMark(arg0_6.tfActiveMark, "overview_player", true)

	arg0_6.tfActiveMarkRect = tf(GameObject.New())
	arg0_6.tfActiveMarkRect.gameObject.layer = Layer.UI
	arg0_6.tfActiveMarkRect.name = "active_mark_rect"

	arg0_6.tfActiveMarkRect:SetParent(arg0_6.tfSpriteScene, false)
	setActive(arg0_6.tfActiveMarkRect, false)
	arg0_6:DoUpdatExtraMark(arg0_6.tfActiveMarkRect, "overview_player_rect", true)
end

function var0_0.OnUpdateActiveEntrance(arg0_7, arg1_7, arg2_7, arg3_7)
	var0_0.super.OnUpdateActiveEntrance(arg0_7, arg1_7, arg2_7, arg3_7)

	if arg3_7 then
		arg0_7.tfActiveMarkRect.localPosition = arg0_7.tfActiveMark.localPosition
	end

	setActive(arg0_7.tfActiveMarkRect, arg3_7)
end

function var0_0.UpdateStaticMark(arg0_8, arg1_8, arg2_8)
	arg0_8:RemoveExtraMarkPrefab(arg0_8.tfMarkScene)

	for iter0_8, iter1_8 in pairs(arg1_8 or {}) do
		if iter1_8 then
			local var0_8 = arg0_8.atlas:GetEntrance(iter0_8)
			local var1_8 = var0_8:HasPort() and arg2_8[1] or arg2_8[2]

			if var1_8 then
				arg0_8:LoadExtraMarkPrefab(arg0_8.tfMarkScene, var1_8, function(arg0_9)
					tf(arg0_9).localPosition = WorldConst.CalcModelPosition(var0_8, arg0_8.spriteBaseSize)
				end)
			end
		end
	end

	var0_0.super.UpdateStaticMark(arg0_8, arg1_8)
end

function var0_0.UpdateTargetEntrance(arg0_10, arg1_10)
	local var0_10 = arg0_10.atlas:GetEntrance(arg1_10)
	local var1_10 = arg0_10.atlas:GetActiveEntrance()
	local var2_10 = calcPositionAngle(var0_10.config.area_pos[1] - var1_10.config.area_pos[1], var0_10.config.area_pos[2] - var1_10.config.area_pos[2])

	arg0_10.tfActiveMark.localEulerAngles = Vector3(0, var2_10, 0)
end

return var0_0
