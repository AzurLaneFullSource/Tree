local var0_0 = class("RoomIKSession")

function var0_0.Ctor(arg0_1)
	arg0_1.generation = 0
	arg0_1.active = false
	arg0_1.mode = nil
	arg0_1.currentIkStatus = nil
	arg0_1.currentIkConfig = nil
	arg0_1.currentIkTimelineStatus = nil
	arg0_1.stockingCachedIkStatus = nil
	arg0_1.ikSpecialCall = nil
	arg0_1.ikActionDict = nil
	arg0_1.readyIKLayers = nil
	arg0_1.ikTouchDatas = nil
	arg0_1.ikSettings = nil
	arg0_1.ladyEnv = nil
	arg0_1.ikRoot = nil
	arg0_1.boneMaps = nil
	arg0_1.controllers = nil
	arg0_1.ikHandler = nil
	arg0_1.ikTimelineColliderStates = nil
	arg0_1.ikNextCheckStamp = nil
	arg0_1.nextTipIKTime = nil
	arg0_1.enableIKTip = false
	arg0_1.blockIK = nil
	arg0_1.uiBlockHeld = false
	arg0_1.blockReasons = {}
	arg0_1.ikSwitchSkinId = nil
	arg0_1.spec = nil
end

function var0_0.Start(arg0_2, arg1_2)
	arg0_2.generation = arg0_2.generation + 1
	arg0_2.active = true
	arg0_2.mode = arg1_2
	arg0_2.blockReasons = {}
	arg0_2.blockIK = nil

	return arg0_2.generation
end

function var0_0.IsCurrent(arg0_3, arg1_3)
	return arg0_3.active and arg0_3.generation == arg1_3
end

function var0_0.ApplySpec(arg0_4, arg1_4)
	assert(arg1_4, "Missing RoomIK session spec")

	arg0_4.spec = arg1_4
	arg0_4.mode = arg1_4.mode
	arg0_4.currentIkStatus = arg1_4.mode == "normal" and arg1_4.statusId or nil
	arg0_4.currentIkConfig = arg1_4.mode == "normal" and arg1_4.config or nil
	arg0_4.currentIkTimelineStatus = arg1_4.mode == "timeline" and arg1_4.statusId or nil
	arg0_4.ladyEnv = arg1_4.ladyEnv
	arg0_4.ikActionDict = arg1_4.actionDict
	arg0_4.readyIKLayers = arg1_4.layers
	arg0_4.ikTouchDatas = arg1_4.touchDatas
	arg0_4.ikRoot = arg1_4.ikRoot
	arg0_4.boneMaps = arg1_4.boneMaps
	arg0_4.controllers = arg1_4.controllers
	arg0_4.ikSettings = {
		Colliders = arg1_4.colliders,
		CameraRaycaster = arg1_4.raycaster
	}
end

function var0_0.IsBlocked(arg0_5)
	return next(arg0_5.blockReasons) ~= nil
end

function var0_0.RefreshBlockState(arg0_6)
	arg0_6.blockIK = arg0_6:IsBlocked() or nil
end

function var0_0.AcquireBlock(arg0_7, arg1_7)
	arg0_7.blockReasons[arg1_7 or "legacy"] = true

	arg0_7:RefreshBlockState()
end

function var0_0.ReleaseBlock(arg0_8, arg1_8)
	arg0_8.blockReasons[arg1_8 or "legacy"] = nil

	arg0_8:RefreshBlockState()
end

function var0_0.SetLegacyBlock(arg0_9, arg1_9)
	if arg1_9 then
		arg0_9:AcquireBlock("legacy")
	else
		arg0_9:ReleaseBlock("legacy")
	end
end

function var0_0.ClearBlocks(arg0_10)
	arg0_10.blockReasons = {}

	arg0_10:RefreshBlockState()
end

function var0_0.ClearRuntime(arg0_11)
	arg0_11.generation = arg0_11.generation + 1
	arg0_11.active = false
	arg0_11.mode = nil
	arg0_11.currentIkStatus = nil
	arg0_11.currentIkConfig = nil
	arg0_11.currentIkTimelineStatus = nil
	arg0_11.spec = nil
	arg0_11.ikActionDict = nil
	arg0_11.readyIKLayers = nil
	arg0_11.ikTouchDatas = nil
	arg0_11.ikSettings = nil
	arg0_11.ladyEnv = nil
	arg0_11.ikRoot = nil
	arg0_11.boneMaps = nil
	arg0_11.controllers = nil
	arg0_11.ikHandler = nil
	arg0_11.ikNextCheckStamp = nil
	arg0_11.nextTipIKTime = nil
	arg0_11.enableIKTip = false
	arg0_11.blockIK = nil
	arg0_11.blockReasons = {}
end

function var0_0.Invalidate(arg0_12)
	arg0_12:ClearRuntime()

	arg0_12.stockingCachedIkStatus = nil
	arg0_12.ikSpecialCall = nil
	arg0_12.ikTimelineColliderStates = nil
	arg0_12.ikSwitchSkinId = nil
	arg0_12.uiBlockHeld = false
end

return var0_0
