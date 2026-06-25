local var0_0 = class("Dorm3dStockingMgr", import("view.dorm3d.Extra.BaseExtraSystem"))

var0_0.SET_STOCKING_STATUS = "Dorm3dStockingMgr.SET_STOCKING_STATUS"
var0_0.EXIT_STOCKING_STATUS = "Dorm3dStockingMgr.EXIT_STOCKING_STATUS"
var0_0.GET_TIP_SHOW_INFO = "Dorm3dStockingMgr.GET_TIP_SHOW_INFO"
var0_0.ON_BEGIN_DRAG = "Dorm3dStockingMgr.ON_BEGIN_DRAG"
var0_0.ON_DRAG = "Dorm3dStockingMgr.ON_DRAG"
var0_0.ON_END_DRAG = "Dorm3dStockingMgr.ON_END_DRAG"
var0_0.ON_EXIT_TOUCH_MODE = "Dorm3dStockingMgr.ON_EXIT_TOUCH_MODE"
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

function var0_0.OnInit(arg0_1)
	local var0_1 = arg0_1:GetCurrentLadyEnv()

	if var0_1 then
		for iter0_1, iter1_1 in pairs(var0_1.skinIdList) do
			local var1_1 = arg0_1:Get("skinDict")[iter1_1].ladyGameObject

			arg0_1:InitDormStocking(var1_1.transform, iter1_1)
		end
	end
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.SET_STOCKING_STATUS, function(arg0_3, arg1_3)
		arg0_2:SetStockingStatus(arg1_3)
	end)
	arg0_2:Bind(var0_0.EXIT_STOCKING_STATUS, function(arg0_4)
		arg0_2:ExitStockingStatus()
	end)
	arg0_2:Bind(var0_0.GET_TIP_SHOW_INFO, function(arg0_5, arg1_5)
		return arg0_2:GetTipShowInfo(arg1_5)
	end)
	arg0_2:Bind(var0_0.ON_BEGIN_DRAG, function(arg0_6, arg1_6, arg2_6)
		arg0_2:OnBeginDrag(arg1_6, arg2_6)
	end)
	arg0_2:Bind(var0_0.ON_DRAG, function(arg0_7, arg1_7, arg2_7)
		arg0_2:OnDrag(arg1_7, arg2_7)
	end)
	arg0_2:Bind(var0_0.ON_END_DRAG, function(arg0_8, arg1_8, arg2_8)
		arg0_2:OnEndDrag(arg1_8, arg2_8)
	end)
	arg0_2:Bind(var0_0.ON_EXIT_TOUCH_MODE, function(arg0_9)
		arg0_2:OnExitTouchMode()
	end)
end

function var0_0.OnHandleNotification(arg0_10, arg1_10, arg2_10)
	if arg1_10 == GAME.APARTMENT_REPLACE_FURNITURE_DONE then
		local var0_10 = arg0_10:GetCurrentLadyEnv()

		if not var0_10 then
			return
		end

		for iter0_10, iter1_10 in pairs(var0_10.skinIdList) do
			local var1_10 = arg0_10:Get("skinDict")[iter1_10].ladyGameObject

			arg0_10:InitDormStocking(var1_10.transform, iter1_10)
		end
	end
end

function var0_0.GetInterests()
	return {
		GAME.APARTMENT_REPLACE_FURNITURE_DONE
	}
end

function var0_0.OnBeginDrag(arg0_12, arg1_12, arg2_12)
	if arg0_12.blockingDrag then
		return
	end

	local var0_12 = arg2_12.position
	local var1_12 = CameraMgr.instance:Raycast(arg0_12:Get("sceneRaycaster"), var0_12):ToTable()

	if #var1_12 > 0 then
		local var2_12 = var1_12[1].gameObject.transform
		local var3_12, var4_12 = table.Find(var0_0.L_COLLIDERS, function(arg0_13, arg1_13)
			return var2_12.name == arg1_13
		end)
		local var5_12, var6_12 = table.Find(var0_0.R_COLLIDERS, function(arg0_14, arg1_14)
			return var2_12.name == arg1_14
		end)
		local var7_12 = var4_12 and 1 or var6_12 and 2 or nil

		warning(var2_12, var7_12)

		if not var7_12 or var1_0.enable_drag[var7_12] == 0 or not arg0_12.isShow[var7_12] then
			return
		end

		arg0_12.inDragStocking = var7_12

		if arg0_12.inDragStocking then
			arg0_12.startStockingPos = GraphicsInterface.Instance:GetStockingPos(arg0_12.stockingTFs[arg0_12.inDragStocking].gameObject)
			arg0_12.preMin, arg0_12.preMax = arg0_12.startStockingPos, arg0_12.startStockingPos

			GraphicsInterface.Instance:StockingMouseDown(arg0_12.stockingTFs[arg0_12.inDragStocking].gameObject, arg2_12.position, arg0_12.mainCamera)
		end
	end
end

function var0_0.OnDrag(arg0_15, arg1_15, arg2_15)
	if arg0_15.blockingDrag then
		return
	end

	if arg0_15.inDragStocking then
		GraphicsInterface.Instance:StockingMouseDrag(arg0_15.stockingTFs[arg0_15.inDragStocking].gameObject, arg2_15.position, arg0_15.mainCamera)

		local var0_15 = GraphicsInterface.Instance:GetStockingPos(arg0_15.stockingTFs[arg0_15.inDragStocking].gameObject)

		arg0_15.preMin = math.min(arg0_15.preMin, var0_15)
		arg0_15.preMax = math.max(arg0_15.preMax, var0_15)

		return
	end

	local var1_15 = arg2_15.delta

	arg0_15:Emit(Dorm3dRoomTemplateScene.ON_STICK_MOVE, var1_15)
end

function var0_0.OnEndDrag(arg0_16, arg1_16, arg2_16)
	if arg0_16.blockingDrag then
		return
	end

	if arg0_16.inDragStocking then
		GraphicsInterface.Instance:StockingMouseUp(arg0_16.stockingTFs[arg0_16.inDragStocking].gameObject)

		arg0_16.endStockingPos = GraphicsInterface.Instance:GetStockingPos(arg0_16.stockingTFs[arg0_16.inDragStocking].gameObject)

		arg0_16:TryTriggerEvent()
		arg0_16:CheckStockingShow()
	end

	arg0_16.inDragStocking = nil
end

function var0_0.TryTriggerEvent(arg0_17)
	warning("TryTriggerEvent", arg0_17.inDragStocking, arg0_17.startStockingPos, arg0_17.endStockingPos, arg0_17.preMin, arg0_17.preMax)

	local var0_17 = arg0_17.inDragStocking

	if arg0_17.endStockingPos > arg0_17.startStockingPos then
		var0_17 = var0_17 * 2 - 1
	else
		var0_17 = var0_17 * 2
	end

	for iter0_17, iter1_17 in ipairs(arg0_17.triggerDic[var0_17]) do
		if iter1_17:Check(arg0_17.endStockingPos, arg0_17.preMax, arg0_17.preMin) then
			local var1_17, var2_17, var3_17 = iter1_17:Trigger()

			arg0_17:TriggerEvent(var1_17, var2_17, var3_17)

			break
		end
	end
end

function var0_0.TriggerEvent(arg0_18, arg1_18, arg2_18, arg3_18)
	warning("TriggerEvent", arg1_18, arg2_18, arg3_18)

	arg0_18.blockingDrag = true

	local function var0_18()
		arg0_18.blockingDrag = false

		if arg3_18 then
			arg0_18:ExitStockingStatus()
		else
			arg0_18:ResetLady()
		end
	end

	switch(arg1_18, {
		function()
			arg0_18:Func("DoTalk", arg2_18[1], var0_18)
		end
	})
end

function var0_0.CheckStockingShow(arg0_21)
	if not arg0_21.useHideMode then
		return
	end

	if arg0_21.endStockingPos <= 0.01 then
		arg0_21.isShow[arg0_21.inDragStocking] = false

		setActive(arg0_21.stockingTFs[arg0_21.inDragStocking], false)
		setActive(arg0_21.sceneStockingTFs[arg0_21.inDragStocking], true)
	end
end

function var0_0.InitStatus(arg0_22, arg1_22)
	arg0_22.ladyEnv = arg0_22:GetCurrentLadyEnv()
	var1_0 = pg.dorm3d_stocking[arg1_22]
	arg0_22.cacheIkStatus = arg0_22.ladyEnv.currentIkStatus
	arg0_22.inDragStocking = false
	arg0_22.stockingL, arg0_22.stockingR = var0_0.GetStockingGeo(arg0_22.ladyEnv.lady, var1_0.skin_id)
	arg0_22.stockingTFs = {
		arg0_22.stockingL,
		arg0_22.stockingR
	}
	arg0_22.mainCamera = arg0_22:Get("mainCameraTF"):GetComponent(typeof(Camera))
	arg0_22.tiptransforms = {
		arg0_22.ladyEnv.lady:Find(var1_0.tip_show_path[1]),
		arg0_22.ladyEnv.lady:Find(var1_0.tip_show_path[2])
	}
	arg0_22.tipDirections = {
		{
			arg0_22.ladyEnv.lady:Find(var1_0.l_tip_bone_path[1]),
			arg0_22.ladyEnv.lady:Find(var1_0.l_tip_bone_path[2])
		},
		{
			arg0_22.ladyEnv.lady:Find(var1_0.r_tip_bone_path[1]),
			arg0_22.ladyEnv.lady:Find(var1_0.r_tip_bone_path[2])
		}
	}
	arg0_22.triggerDic = {
		{},
		{},
		{},
		{}
	}

	local function var0_22(arg0_23, arg1_23)
		local var0_23 = {}
		local var1_23 = {}

		for iter0_23, iter1_23 in ipairs(arg1_23) do
			local var2_23 = StockingTrigger.New(iter1_23)

			if var2_23:GetCompareType() == 0 then
				table.insert(var0_23, var2_23)
			else
				table.insert(var1_23, var2_23)
			end
		end

		StockingTrigger.Sort(var0_23)
		StockingTrigger.Sort(var1_23)

		arg0_22.triggerDic[arg0_23 * 2 - 1] = var0_23
		arg0_22.triggerDic[arg0_23 * 2] = var1_23
	end

	for iter0_22, iter1_22 in ipairs({
		var1_0.l_trigger,
		var1_0.r_trigger
	}) do
		var0_22(iter0_22, iter1_22)
	end

	arg0_22.inited = true
end

function var0_0.InitHideMode(arg0_24)
	arg0_24.useHideMode = var1_0.scene_stocking_path ~= "" and #var1_0.scene_stocking_path == 2
	arg0_24.isShow = {
		isActive(arg0_24.stockingL),
		isActive(arg0_24.stockingR)
	}

	if arg0_24.useHideMode then
		arg0_24.sceneStockingTFs = {
			arg0_24:GetSceneItem(var1_0.scene_stocking_path[1]),
			arg0_24:GetSceneItem(var1_0.scene_stocking_path[2])
		}

		local function var0_24(arg0_25, arg1_25)
			GetOrAddComponent(arg1_25, typeof(EventTriggerListener)):AddPointClickFunc(function(arg0_26, arg1_26)
				arg0_24.isShow[arg0_25] = true

				setActive(arg0_24.stockingTFs[arg0_25], true)
				setActive(arg0_24.sceneStockingTFs[arg0_25], false)
				GraphicsInterface.Instance:SetStockingPos(arg0_24.stockingTFs[arg0_25].gameObject, var1_0.wear_initial_pos[arg0_25])
			end)
		end

		for iter0_24, iter1_24 in ipairs(arg0_24.sceneStockingTFs) do
			var0_24(iter0_24, iter1_24)
			setActive(iter1_24, not arg0_24.isShow[iter0_24])
		end
	end
end

function var0_0.ResetLady(arg0_27)
	local var0_27 = arg0_27:Get("furnitures"):Find(var1_0.character_position)

	assert(var0_27, "找不到角色位置点 " .. var1_0.character_position)

	local var1_27 = var0_27:Find("StayPoint")

	arg0_27.ladyEnv:SetPosition(var1_27.position)
	arg0_27.ladyEnv:SetRotation(var1_27.rotation)
	arg0_27.ladyEnv:PlaySingleAction(var1_0.character_action)
end

function var0_0.SetStockingStatus(arg0_28, arg1_28)
	arg0_28:InitStatus(arg1_28)
	arg0_28:InitHideMode()
	warning(">>>>>>>>>>> enter stocking mode <<<<<<<<<<", arg1_28)
	seriesAsync({
		function(arg0_29)
			arg0_28:Emit(RoomIKSystem.SET_IK_STATE, false, arg0_29, {
				ignoreResetExtraItem = true
			})
		end,
		function(arg0_30)
			arg0_28:Func("SetUI", arg0_30, "stocking")
		end,
		function(arg0_31)
			arg0_28:ResetLady()
			arg0_28:Func("ActiveCameraByName", var1_0.camera)

			local var0_31 = arg0_28:Get("cameraRoot"):Find(var1_0.camera):GetComponent(typeof(Cinemachine.CinemachineFreeLook))

			if var0_31 then
				arg0_28:Func("RegisterOrbits", var0_31)
			end

			arg0_28:Func("PlayEnterSceneAnim", var1_0.enter_scene_anim)
			arg0_28:Func("PlayEnterExtraItem", arg0_28.ladyEnv, var1_0.enter_extra_item)
			arg0_28:Func("HideSceneItem", arg0_28.ladyEnv, var1_0.hide_scene_item)
			setActive(arg0_28.ladyEnv.ladyCollider, false)
			_.each(arg0_28.ladyEnv.ladyTouchColliders, function(arg0_32)
				setActive(arg0_32, true)
			end)
			arg0_31()
		end
	})
end

function var0_0.ExitStockingStatus(arg0_33)
	seriesAsync({
		function(arg0_34)
			arg0_33:Func("SetUI", arg0_34, "back")
		end,
		function(arg0_35)
			warning(">>>>>>>>>>> exit stocking mode <<<<<<<<<<")

			if arg0_33.useHideMode then
				for iter0_35, iter1_35 in ipairs(arg0_33.sceneStockingTFs) do
					GetOrAddComponent(iter1_35, typeof(EventTriggerListener)):RemovePointClickFunc()
				end
			end

			setActive(arg0_33.ladyEnv.ladyCollider, true)
			_.each(arg0_33.ladyEnv.ladyTouchColliders, function(arg0_36)
				setActive(arg0_36, false)
			end)
			arg0_33:Func("ResetSceneItemAnimators")
			arg0_33:Func("ResetTempHideSceneItems", arg0_33.ladyEnv)
			arg0_33:Func("RevertCameraOrbit")
			arg0_33:Emit(RoomIKSystem.SET_IK_CONFIG, arg0_33.ladyEnv, arg0_33.cacheIkStatus)
			arg0_33:Emit(RoomIKSystem.SET_IK_STATE, true)
			arg0_35()
		end
	})
end

function var0_0.OnExitTouchMode(arg0_37)
	if arg0_37.inited then
		arg0_37.inited = false
	end
end

function var0_0.GetTipShowInfo(arg0_38, arg1_38)
	local var0_38 = {}

	for iter0_38, iter1_38 in ipairs(var1_0.enable_drag) do
		if iter1_38 == 1 then
			local var1_38 = arg0_38:Func("GetScreenPosition", arg0_38.tipDirections[iter0_38][1].position, arg0_38.mainCamera)
			local var2_38 = arg0_38:Func("GetScreenPosition", arg0_38.tipDirections[iter0_38][2].position, arg0_38.mainCamera)

			table.insert(var0_38, {
				pos = arg0_38:Func("GetScreenPosition", arg0_38.tiptransforms[iter0_38].position, arg0_38.mainCamera),
				dir = var2_38 - var1_38
			})
		end
	end

	local var3_38 = {}

	if arg0_38.useHideMode then
		for iter2_38, iter3_38 in ipairs(arg0_38.sceneStockingTFs) do
			if not arg0_38.isShow[iter2_38] then
				table.insert(var3_38, {
					pos = arg0_38:Func("GetScreenPosition", iter3_38.position, arg0_38.mainCamera)
				})
			end
		end
	end

	if arg1_38 then
		table.insert(arg1_38, var0_38)
		table.insert(arg1_38, var3_38)
	end

	return var0_38, var3_38
end

function var0_0.GetStockingGeo(arg0_39, arg1_39)
	local var0_39 = pg.dorm3d_resource[arg1_39].stocking_geo_path

	if var0_39 == "" then
		return nil, nil
	end

	local var1_39 = arg0_39:Find(var0_39[1])
	local var2_39 = arg0_39:Find(var0_39[2])

	return var1_39, var2_39
end

function var0_0.InitDormStocking(arg0_40, arg1_40, arg2_40)
	local var0_40, var1_40 = arg0_40:IsUnlockStocking(arg2_40)

	if not var0_40 then
		return
	end

	local var2_40 = pg.dorm3d_resource[arg2_40].stocking_pos
	local var3_40, var4_40 = var0_0.GetStockingGeo(arg1_40, arg2_40)

	if var1_40 then
		setActive(var3_40, true)
		setActive(var4_40, true)
		GraphicsInterface.Instance:SetStockingPos(var3_40.gameObject, var2_40[1])
		GraphicsInterface.Instance:SetStockingPos(var4_40.gameObject, var2_40[2])
	else
		setActive(var3_40, false)
		setActive(var4_40, false)

		local var5_40 = arg1_40:Find("all/body_geo"):GetComponent(typeof(SkinnedMeshRenderer))

		var5_40:SetBlendShapeWeight(0, 0)
		var5_40:SetBlendShapeWeight(1, 0)
	end
end

function var0_0.IsUnlockStocking(arg0_41, arg1_41)
	if not var0_0.UNLOCK_CONFIG[arg1_41] then
		return false, false
	end

	return true, arg0_41:GetRoom():IsFurnitureSetIn(var0_0.UNLOCK_CONFIG[arg1_41])
end

return var0_0
