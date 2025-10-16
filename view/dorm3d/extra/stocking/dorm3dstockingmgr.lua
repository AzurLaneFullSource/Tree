local var0_0 = class("Dorm3dStockingMgr", import("view.dorm3d.Extra.BaseExtraSystem"))

var0_0.L_COLLIDERS = {
	"LeftThighCollider",
	"LeftCalfCollider",
	"LeftFootCollider"
}
var0_0.R_COLLIDERS = {
	"RightThighCollider",
	"RightCalfCollider",
	"RightFootCollider"
}
var0_0.UNLOCK_CONFIG = {
	[307071] = 1222
}

local var1_0

function var0_0.OnBeginDrag(arg0_1, arg1_1, arg2_1)
	if arg0_1.blockingDrag then
		return
	end

	local var0_1 = arg2_1.position
	local var1_1 = CameraMgr.instance:Raycast(arg0_1:Get("sceneRaycaster"), var0_1):ToTable()

	if #var1_1 > 0 then
		local var2_1 = var1_1[1].gameObject.transform
		local var3_1, var4_1 = table.Find(var0_0.L_COLLIDERS, function(arg0_2, arg1_2)
			return var2_1.name == arg1_2
		end)
		local var5_1, var6_1 = table.Find(var0_0.R_COLLIDERS, function(arg0_3, arg1_3)
			return var2_1.name == arg1_3
		end)
		local var7_1 = var4_1 and 1 or var6_1 and 2 or nil

		warning(var2_1, var7_1)

		if not var7_1 or var1_0.enable_drag[var7_1] == 0 or not arg0_1.isShow[var7_1] then
			return
		end

		arg0_1.inDragStocking = var7_1

		if arg0_1.inDragStocking then
			arg0_1.startStockingPos = GraphicsInterface.Instance:GetStockingPos(arg0_1.stockingTFs[arg0_1.inDragStocking].gameObject)
			arg0_1.preMin, arg0_1.preMax = arg0_1.startStockingPos, arg0_1.startStockingPos

			GraphicsInterface.Instance:StockingMouseDown(arg0_1.stockingTFs[arg0_1.inDragStocking].gameObject, arg2_1.position, arg0_1.mainCamera)
		end
	end
end

function var0_0.OnDrag(arg0_4, arg1_4, arg2_4)
	if arg0_4.blockingDrag then
		return
	end

	if arg0_4.inDragStocking then
		GraphicsInterface.Instance:StockingMouseDrag(arg0_4.stockingTFs[arg0_4.inDragStocking].gameObject, arg2_4.position, arg0_4.mainCamera)

		local var0_4 = GraphicsInterface.Instance:GetStockingPos(arg0_4.stockingTFs[arg0_4.inDragStocking].gameObject)

		arg0_4.preMin = math.min(arg0_4.preMin, var0_4)
		arg0_4.preMax = math.max(arg0_4.preMax, var0_4)

		return
	end

	local var1_4 = arg2_4.delta

	arg0_4:Emit(Dorm3dRoomTemplateScene.ON_STICK_MOVE, var1_4)
end

function var0_0.OnEndDrag(arg0_5, arg1_5, arg2_5)
	if arg0_5.blockingDrag then
		return
	end

	if arg0_5.inDragStocking then
		GraphicsInterface.Instance:StockingMouseUp(arg0_5.stockingTFs[arg0_5.inDragStocking].gameObject)

		arg0_5.endStockingPos = GraphicsInterface.Instance:GetStockingPos(arg0_5.stockingTFs[arg0_5.inDragStocking].gameObject)

		arg0_5:TryTriggerEvent()
		arg0_5:CheckStockingShow()
	end

	arg0_5.inDragStocking = nil
end

function var0_0.TryTriggerEvent(arg0_6)
	warning("TryTriggerEvent", arg0_6.inDragStocking, arg0_6.startStockingPos, arg0_6.endStockingPos, arg0_6.preMin, arg0_6.preMax)

	local var0_6 = arg0_6.inDragStocking

	if arg0_6.endStockingPos > arg0_6.startStockingPos then
		var0_6 = var0_6 * 2 - 1
	else
		var0_6 = var0_6 * 2
	end

	for iter0_6, iter1_6 in ipairs(arg0_6.triggerDic[var0_6]) do
		if iter1_6:Check(arg0_6.endStockingPos, arg0_6.preMax, arg0_6.preMin) then
			local var1_6, var2_6, var3_6 = iter1_6:Trigger()

			arg0_6:TriggerEvent(var1_6, var2_6, var3_6)

			break
		end
	end
end

function var0_0.TriggerEvent(arg0_7, arg1_7, arg2_7, arg3_7)
	warning("TriggerEvent", arg1_7, arg2_7, arg3_7)

	arg0_7.blockingDrag = true

	local function var0_7()
		arg0_7.blockingDrag = false

		if arg3_7 then
			arg0_7:ExitStockingStatus()
		else
			arg0_7:ResetLady()
		end
	end

	switch(arg1_7, {
		function()
			arg0_7:Func("DoTalk", arg2_7[1], var0_7)
		end
	})
end

function var0_0.CheckStockingShow(arg0_10)
	if not arg0_10.useHideMode then
		return
	end

	if arg0_10.endStockingPos <= 0.01 then
		arg0_10.isShow[arg0_10.inDragStocking] = false

		setActive(arg0_10.stockingTFs[arg0_10.inDragStocking], false)
		setActive(arg0_10.sceneStockingTFs[arg0_10.inDragStocking], true)
	end
end

function var0_0.InitStatus(arg0_11, arg1_11)
	arg0_11.ladyEnv = arg0_11:Func("GetCurrentLadyEnv")
	var1_0 = pg.dorm3d_stocking[arg1_11]
	arg0_11.cacheIkStatus = arg0_11.ladyEnv.currentIkStatus
	arg0_11.inDragStocking = false
	arg0_11.stockingL, arg0_11.stockingR = var0_0.GetStockingGeo(arg0_11.ladyEnv.lady, var1_0.skin_id)
	arg0_11.stockingTFs = {
		arg0_11.stockingL,
		arg0_11.stockingR
	}
	arg0_11.mainCamera = arg0_11:Get("mainCameraTF"):GetComponent(typeof(Camera))
	arg0_11.tiptransforms = {
		arg0_11.ladyEnv.lady:Find(var1_0.tip_show_path[1]),
		arg0_11.ladyEnv.lady:Find(var1_0.tip_show_path[2])
	}
	arg0_11.tipDirections = {
		{
			arg0_11.ladyEnv.lady:Find(var1_0.l_tip_bone_path[1]),
			arg0_11.ladyEnv.lady:Find(var1_0.l_tip_bone_path[2])
		},
		{
			arg0_11.ladyEnv.lady:Find(var1_0.r_tip_bone_path[1]),
			arg0_11.ladyEnv.lady:Find(var1_0.r_tip_bone_path[2])
		}
	}
	arg0_11.triggerDic = {
		{},
		{},
		{},
		{}
	}

	local function var0_11(arg0_12, arg1_12)
		local var0_12 = {}
		local var1_12 = {}

		for iter0_12, iter1_12 in ipairs(arg1_12) do
			local var2_12 = StockingTrigger.New(iter1_12)

			if var2_12:GetCompareType() == 0 then
				table.insert(var0_12, var2_12)
			else
				table.insert(var1_12, var2_12)
			end
		end

		StockingTrigger.Sort(var0_12)
		StockingTrigger.Sort(var1_12)

		arg0_11.triggerDic[arg0_12 * 2 - 1] = var0_12
		arg0_11.triggerDic[arg0_12 * 2] = var1_12
	end

	for iter0_11, iter1_11 in ipairs({
		var1_0.l_trigger,
		var1_0.r_trigger
	}) do
		var0_11(iter0_11, iter1_11)
	end

	arg0_11.inited = true
end

function var0_0.InitHideMode(arg0_13)
	arg0_13.useHideMode = var1_0.scene_stocking_path ~= "" and #var1_0.scene_stocking_path == 2
	arg0_13.isShow = {
		isActive(arg0_13.stockingL),
		isActive(arg0_13.stockingR)
	}

	if arg0_13.useHideMode then
		arg0_13.sceneStockingTFs = {
			arg0_13:Func("GetSceneItem", var1_0.scene_stocking_path[1]),
			arg0_13:Func("GetSceneItem", var1_0.scene_stocking_path[2])
		}

		local function var0_13(arg0_14, arg1_14)
			GetOrAddComponent(arg1_14, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_15, arg1_15)
				arg0_13.isShow[arg0_14] = true

				setActive(arg0_13.stockingTFs[arg0_14], true)
				setActive(arg0_13.sceneStockingTFs[arg0_14], false)
			end)
		end

		for iter0_13, iter1_13 in ipairs(arg0_13.sceneStockingTFs) do
			var0_13(iter0_13, iter1_13)
			setActive(iter1_13, not arg0_13.isShow[iter0_13])
		end
	end
end

function var0_0.ResetLady(arg0_16)
	local var0_16 = arg0_16:Get("furnitures"):Find(var1_0.character_position)

	assert(var0_16, "找不到角色位置点 " .. var1_0.character_position)

	local var1_16 = var0_16:Find("StayPoint")

	arg0_16.ladyEnv:SetPosition(var1_16.position)
	arg0_16.ladyEnv:SetRotation(var1_16.rotation)
	arg0_16.ladyEnv:PlaySingleAction(var1_0.character_action)
end

function var0_0.SetStockingStatus(arg0_17, arg1_17)
	arg0_17:InitStatus(arg1_17)
	arg0_17:InitHideMode()
	warning(">>>>>>>>>>> enter stocking mode <<<<<<<<<<", arg1_17)
	seriesAsync({
		function(arg0_18)
			arg0_17:Func("SetIKState", false, arg0_18, {
				ignoreResetExtraItem = true
			})
		end,
		function(arg0_19)
			arg0_17:Func("SetUI", arg0_19, "stocking")
		end,
		function(arg0_20)
			arg0_17:ResetLady()
			arg0_17:Func("ActiveCameraByName", var1_0.camera)

			local var0_20 = arg0_17:Get("cameraRoot"):Find(var1_0.camera):GetComponent(typeof(Cinemachine.CinemachineFreeLook))

			if var0_20 then
				arg0_17:Func("RegisterOrbits", var0_20)
			end

			arg0_17:Func("PlayEnterSceneAnim", var1_0.enter_scene_anim)
			arg0_17:Func("PlayEnterExtraItem", arg0_17.ladyEnv, var1_0.enter_extra_item)
			arg0_17:Func("HideSceneItem", arg0_17.ladyEnv, var1_0.hide_scene_item)
			setActive(arg0_17.ladyEnv.ladyCollider, false)
			_.each(arg0_17.ladyEnv.ladyTouchColliders, function(arg0_21)
				setActive(arg0_21, true)
			end)
			arg0_20()
		end
	})
end

function var0_0.ExitStockingStatus(arg0_22)
	seriesAsync({
		function(arg0_23)
			arg0_22:Func("SetUI", arg0_23, "back")
		end,
		function(arg0_24)
			warning(">>>>>>>>>>> exit stocking mode <<<<<<<<<<")

			if arg0_22.useHideMode then
				for iter0_24, iter1_24 in ipairs(arg0_22.sceneStockingTFs) do
					GetOrAddComponent(iter1_24, typeof(EventTriggerListener)):RemovePointClickFunc()
				end
			end

			setActive(arg0_22.ladyEnv.ladyCollider, true)
			_.each(arg0_22.ladyEnv.ladyTouchColliders, function(arg0_25)
				setActive(arg0_25, false)
			end)
			arg0_22:Func("ResetSceneItemAnimators")
			arg0_22:Func("ResetTempHideSceneItems", arg0_22.ladyEnv)
			arg0_22:Func("RevertCameraOrbit")
			arg0_22:Func("SwitchIKConfig", arg0_22.ladyEnv, arg0_22.cacheIkStatus)
			arg0_22:Func("SetIKState", true)
			arg0_24()
		end
	})
end

function var0_0.OnExitTouchMode(arg0_26)
	if arg0_26.inited then
		arg0_26.inited = false
	end
end

function var0_0.GetTipShowInfo(arg0_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in ipairs(var1_0.enable_drag) do
		if iter1_27 == 1 then
			local var1_27 = arg0_27:Func("GetScreenPosition", arg0_27.tipDirections[iter0_27][1].position, arg0_27.mainCamera)
			local var2_27 = arg0_27:Func("GetScreenPosition", arg0_27.tipDirections[iter0_27][2].position, arg0_27.mainCamera)

			table.insert(var0_27, {
				pos = arg0_27:Func("GetScreenPosition", arg0_27.tiptransforms[iter0_27].position, arg0_27.mainCamera),
				dir = var2_27 - var1_27
			})
		end
	end

	local var3_27 = {}

	if arg0_27.useHideMode then
		for iter2_27, iter3_27 in ipairs(arg0_27.sceneStockingTFs) do
			if not arg0_27.isShow[iter2_27] then
				table.insert(var3_27, {
					pos = arg0_27:Func("GetScreenPosition", iter3_27.position, arg0_27.mainCamera)
				})
			end
		end
	end

	return var0_27, var3_27
end

function var0_0.GetStockingGeo(arg0_28, arg1_28)
	local var0_28 = pg.dorm3d_resource[arg1_28].stocking_geo_path

	if var0_28 == "" then
		return nil, nil
	end

	local var1_28 = arg0_28:Find(var0_28[1])
	local var2_28 = arg0_28:Find(var0_28[2])

	return var1_28, var2_28
end

function var0_0.Init(arg0_29)
	local var0_29 = arg0_29:Func("GetCurrentLadyEnv")

	if var0_29 then
		for iter0_29, iter1_29 in pairs(var0_29.skinIdList) do
			local var1_29 = arg0_29:Get("skinDict")[iter1_29].ladyGameObject

			arg0_29:InitDormStocking(var1_29.transform, iter1_29)
		end
	end
end

function var0_0.InitDormStocking(arg0_30, arg1_30, arg2_30)
	local var0_30, var1_30 = arg0_30:IsUnlockStocking(arg2_30)

	if not var0_30 then
		return
	end

	local var2_30 = pg.dorm3d_resource[arg2_30].stocking_pos
	local var3_30, var4_30 = var0_0.GetStockingGeo(arg1_30, arg2_30)

	if var1_30 then
		setActive(var3_30, true)
		setActive(var4_30, true)
		GraphicsInterface.Instance:SetStockingPos(var3_30.gameObject, var2_30[1])
		GraphicsInterface.Instance:SetStockingPos(var4_30.gameObject, var2_30[2])
	else
		setActive(var3_30, false)
		setActive(var4_30, false)

		local var5_30 = arg1_30:Find("all/body_geo"):GetComponent(typeof(SkinnedMeshRenderer))

		var5_30:SetBlendShapeWeight(0, 0)
		var5_30:SetBlendShapeWeight(1, 0)
	end
end

function var0_0.IsUnlockStocking(arg0_31, arg1_31)
	if not var0_0.UNLOCK_CONFIG[arg1_31] then
		return false, false
	end

	return true, arg0_31:Get("room"):IsFurnitureSetIn(var0_0.UNLOCK_CONFIG[arg1_31])
end

function var0_0.GetInterests()
	return {
		GAME.APARTMENT_REPLACE_FURNITURE_DONE
	}
end

function var0_0.HandleNotification(arg0_33, arg1_33, arg2_33)
	if arg1_33 == GAME.APARTMENT_REPLACE_FURNITURE_DONE then
		local var0_33 = arg0_33:Func("GetCurrentLadyEnv")

		for iter0_33, iter1_33 in pairs(var0_33.skinIdList) do
			local var1_33 = arg0_33:Get("skinDict")[iter1_33].ladyGameObject

			arg0_33:InitDormStocking(var1_33.transform, iter1_33)
		end
	end
end

return var0_0
