local var0_0 = class("FurnitureSystem", import("view.dorm3d.Core.BaseSystem"))

var0_0.REFRESH_SLOTS = "FurnitureSystem.REFRESH_SLOTS"
var0_0.REFRESH_SLOTS_EMPTY = "FurnitureSystem.REFRESH_SLOTS_EMPTY"
var0_0.DISPLAY_SLOTS = "FurnitureSystem.DISPLAY_SLOTS"
var0_0.HIDE_SLOTS = "FurnitureSystem.HIDE_SLOTS"
var0_0.UPDATE_DISPLAY_SLOTS = "FurnitureSystem.UPDATE_DISPLAY_SLOTS"
var0_0.REFRESH_DONE = "FurnitureSystem.REFRESH_DONE"

function var0_0.OnInit(arg0_1)
	arg0_1.slotRoot = arg0_1:GetFurnitureSlotRoot()

	assert(arg0_1.slotRoot, "FurnitureSystem requires FurnitureSlots root")

	arg0_1.slotDict = {}
	arg0_1.displaySlots = nil
	arg0_1.slotTriggers = {}
	arg0_1.artSceneChanging = false

	arg0_1:InitSlots()
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.REFRESH_SLOTS, function(arg0_3, arg1_3, arg2_3)
		arg0_2:RefreshSlots(arg1_3, arg2_3)
	end)
	arg0_2:Bind(var0_0.REFRESH_SLOTS_EMPTY, function(arg0_4, arg1_4)
		arg0_2:RefreshSlotsEmpty(arg1_4)
	end)
	arg0_2:Bind(var0_0.DISPLAY_SLOTS, function(arg0_5, arg1_5)
		arg0_2:DisplayFurnitureSlots(arg1_5)
	end)
	arg0_2:Bind(var0_0.HIDE_SLOTS, function()
		arg0_2:HideFurnitureSlots()
	end)
	arg0_2:Bind(var0_0.UPDATE_DISPLAY_SLOTS, function(arg0_7, arg1_7)
		arg0_2:UpdateDisplaySlots(arg1_7)
	end)
	arg0_2:Bind(Dorm3dRoomTemplateScene.ART_SCENE_WILL_CHANGE, function()
		arg0_2.artSceneChanging = true

		for iter0_8, iter1_8 in pairs(arg0_2.slotDict or {}) do
			iter1_8.model = nil
			iter1_8.sceneHides = {}
		end
	end)
	arg0_2:Bind(Dorm3dRoomTemplateScene.ART_SCENE_CHANGED, function()
		arg0_2.artSceneChanging = false

		arg0_2:RebindModels()
	end)
end

function var0_0.InitSlots(arg0_10)
	local var0_10 = arg0_10:GetRoom()

	assert(var0_10, "FurnitureSystem requires room")

	local var1_10 = arg0_10:GetModelRoot()
	local var2_10 = var0_10:GetSlots()
	local var3_10 = var1_10:GetComponentsInChildren(typeof(Transform), true):ToTable()

	_.each(var2_10, function(arg0_11)
		local var0_11 = arg0_11:GetFurnitureName()
		local var1_11 = arg0_11:GetConfigID()
		local var2_11 = arg0_10.slotRoot:Find(tostring(var1_11))

		if not var2_11 then
			errorMsg("Not Find Slot: " .. var1_11)

			return
		end

		local var3_11 = {
			trans = var2_11,
			name = var0_11,
			sceneHides = {}
		}
		local var4_11 = var2_11:Find("Selector")

		if var4_11 then
			local var5_11 = GetOrAddComponent(var4_11, typeof(EventTriggerListener))

			var5_11:AddPointClickFunc(function()
				arg0_10:Emit(Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT, var1_11)
			end)
			setActive(var4_11, false)

			arg0_10.slotTriggers[var1_11] = var5_11
		end

		for iter0_11, iter1_11 in ipairs(var3_10) do
			if iter1_11.name == var0_11 then
				var3_11.model = iter1_11

				break
			end
		end

		arg0_10.slotDict[var1_11] = var3_11
	end)
end

function var0_0.RefreshSlots(arg0_13, arg1_13, arg2_13)
	if arg0_13.artSceneChanging then
		existCall(arg2_13)

		return
	end

	arg1_13 = arg1_13 or arg0_13:GetRoom()

	assert(arg1_13, "FurnitureSystem requires room")

	local var0_13 = arg1_13:GetSlots()
	local var1_13 = arg1_13:GetFurnitures()
	local var2_13 = arg0_13:GetModelRoot()
	local var3_13 = arg0_13:GetLoader()

	arg0_13:Emit(Dorm3dRoomTemplateScene.SHOW_BLOCK)
	table.ParallelIpairsAsync(var0_13, function(arg0_14, arg1_14, arg2_14)
		local var0_14 = arg1_14:GetConfigID()
		local var1_14 = arg0_13.slotDict[var0_14]

		if not var1_14 then
			return arg2_14()
		end

		local var2_14 = _.detect(var1_13, function(arg0_15)
			return arg0_15:GetSlotID() == var0_14
		end)
		local var3_14 = var2_14 and var2_14:GetModel(arg0_13:GetTimeIndex()) or false
		local var4_14 = var1_14.model

		var1_14.displayModelName = var3_14
		var1_14.furnitureId = var2_14 and var2_14:GetConfigID()

		local function var5_14(arg0_16)
			if var4_14 then
				setActive(var4_14, var3_14 == "")
			end

			table.Foreach(var1_14.sceneHides or {}, function(arg0_17, arg1_17)
				setActive(arg1_17.trans, arg1_17.visible)
			end)

			var1_14.sceneHides = {}

			if not arg0_16 then
				return
			end

			local var0_16 = arg0_16:getConfig("scene_hides")

			if type(var0_16) == "table" and #var0_16 > 0 then
				table.Ipairs(var0_16, function(arg0_18, arg1_18)
					local var0_18 = var2_13:Find(arg1_18)

					assert(var0_18, string.format("dorm3d_furniture_template:%d scene_hides missing scene item :%s", arg0_16:GetConfigID(), arg1_18))
					table.insert(var1_14.sceneHides, {
						name = arg1_18,
						trans = var0_18,
						visible = isActive(var0_18)
					})
					setActive(var0_18, false)
				end)
			end
		end

		if var3_14 == false or var3_14 == "" then
			var3_13:ClearRequest("slot_" .. var0_14)
			var5_14()

			return arg2_14()
		end

		local var6_14 = var1_14.trans

		if var3_13:GetLoadingRP("slot_" .. var0_14) then
			arg0_13:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)
		end

		var3_13:GetPrefabBYStopLoading("dorm3d/furniture/prefabs/" .. var3_14, "", function(arg0_19)
			assert(arg0_19)
			setParent(arg0_19, var6_14)
			var5_14(var2_14)
			arg2_14()
		end, "slot_" .. var0_14)
	end, function()
		arg0_13:Emit(Dorm3dRoomTemplateScene.HIDE_BLOCK)
		existCall(arg2_13)
		warning("RefreshSlots", "Done")
		arg0_13:Emit(var0_0.REFRESH_DONE)
	end)
end

function var0_0.RefreshSlotsEmpty(arg0_21, arg1_21)
	local var0_21 = Clone(arg0_21:GetRoom())

	var0_21.furnitures = {}

	arg0_21:RefreshSlots(var0_21, arg1_21)
end

function var0_0.CheckSceneItemActive(arg0_22, arg1_22)
	local var0_22 = true
	local var1_22

	table.Checkout(arg0_22.slotDict, function(arg0_23, arg1_23)
		if underscore.detect(arg1_23.sceneHides, function(arg0_24)
			return arg0_24.trans == arg1_22
		end) then
			var0_22 = false
			var1_22 = arg1_23.furnitureId

			return false
		end
	end)

	return var0_22, var1_22
end

function var0_0.GetSlotByID(arg0_25, arg1_25)
	assert(arg0_25.isInitialized, "FurnitureSystem is not initialized")

	return arg0_25.displaySlots and arg0_25.displaySlots[arg1_25] and arg0_25.displaySlots[arg1_25].trans
end

function var0_0.HideFurnitureSlots(arg0_26)
	if not arg0_26.displaySlots then
		return
	end

	arg0_26:UpdateDisplaySlots({})
	table.Foreach(arg0_26.displaySlots, function(arg0_27, arg1_27)
		local var0_27 = arg1_27.trans:Find("Selector")

		if not IsNil(var0_27) then
			setActive(var0_27, false)
		end
	end)

	arg0_26.displaySlots = nil
end

function var0_0.DisplayFurnitureSlots(arg0_28, arg1_28)
	arg0_28:HideFurnitureSlots()

	arg0_28.displaySlots = {}

	_.each(arg1_28, function(arg0_29)
		local var0_29 = arg0_28.slotDict[arg0_29]

		arg0_28.displaySlots[arg0_29] = var0_29

		if not var0_29 then
			errorMsg("Slot " .. arg0_29 .. " Not Binding Scene Object")

			return
		end

		local var1_29 = var0_29.trans:Find("Selector")

		if var1_29 then
			setActive(var1_29, true)
		end
	end)
end

function var0_0.UpdateDisplaySlots(arg0_30, arg1_30)
	table.Foreach(arg0_30.displaySlots, function(arg0_31, arg1_31)
		local var0_31 = arg1_31.trans
		local var1_31 = var0_31:Find("Selector")

		if not IsNil(var1_31) then
			setActive(var0_31:Find("Selector/Normal"), arg1_30[arg0_31] == 0)
			setActive(var0_31:Find("Selector/Active"), arg1_30[arg0_31] == 1)
			setActive(var0_31:Find("Selector/Ban"), arg1_30[arg0_31] == 2)
		end

		local var2_31 = arg1_31.model

		if arg1_31.displayModelName and arg1_31.displayModelName ~= "" then
			var2_31 = var0_31:GetChild(var0_31.childCount - 1)
		end

		if not var2_31 then
			return
		end

		local var3_31 = arg1_30[arg0_31] == 1 and Color.NewHex("3F83AE73") or Color.New(0, 0, 0, 0)
		local var4_31 = var2_31:GetComponentsInChildren(typeof(Renderer), true)

		table.IpairsCArray(var4_31, function(arg0_32, arg1_32)
			local var0_32 = arg1_32.material

			if var0_32 and var0_32:HasProperty("_FinalTint") then
				var0_32:SetColor("_FinalTint", var3_31)
			end
		end)
	end)
end

function var0_0.OnDispose(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33.slotTriggers or {}) do
		iter1_33:RemovePointClickFunc()
	end

	arg0_33.slotTriggers = nil
	arg0_33.displaySlots = nil
	arg0_33.slotDict = nil
	arg0_33.slotRoot = nil
end

function var0_0.RebindModels(arg0_34)
	if not arg0_34.slotDict then
		return
	end

	local var0_34 = arg0_34:GetModelRoot():GetComponentsInChildren(typeof(Transform), true):ToTable()

	table.Foreach(arg0_34.slotDict, function(arg0_35, arg1_35)
		arg1_35.model = nil
		arg1_35.sceneHides = {}

		for iter0_35, iter1_35 in ipairs(var0_34) do
			if iter1_35.name == arg1_35.name then
				arg1_35.model = iter1_35

				break
			end
		end
	end)
end

return var0_0
