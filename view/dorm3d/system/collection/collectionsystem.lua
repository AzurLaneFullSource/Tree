local var0_0 = class("CollectionSystem", import("view.dorm3d.Core.BaseSystem"))

var0_0.TEMP_HIDE = "CollectionSystem.TEMP_HIDE"
var0_0.UPDATE_CONTACT_STATE = "CollectionSystem.UPDATE_CONTACT_STATE"

function var0_0.OnInit(arg0_1)
	arg0_1.contactStateDic = {}
	arg0_1.hideContactStateDic = {}
	arg0_1.contactInRangeDic = {}
	arg0_1.transRangeDic = {
		list = {}
	}
	arg0_1.uiHidden = false
	arg0_1.tempHidden = false
	arg0_1.contactTriggers = {}
	arg0_1.artSceneChanging = false
	arg0_1.artSceneBlocked = false

	arg0_1:UpdateContactState()
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.UPDATE_CONTACT_STATE, function(arg0_3, arg1_3)
		arg0_2:UpdateContactState(arg1_3)
	end)
	arg0_2:Bind(var0_0.TEMP_HIDE, function(arg0_4, arg1_4)
		arg0_2.tempHidden = arg1_4

		arg0_2:ActiveContact()
	end)
	arg0_2:Bind(FurnitureSystem.REFRESH_DONE, function()
		arg0_2:ActiveContact()
	end)
	arg0_2:Bind(Dorm3dRoomTemplateScene.ART_SCENE_WILL_CHANGE, function(arg0_6, arg1_6, arg2_6)
		arg0_2.artSceneChanging = true
		arg0_2.artSceneBlocked = not arg2_6

		arg0_2:ClearContactBindings()
	end)
	arg0_2:Bind(Dorm3dRoomTemplateScene.ART_SCENE_CHANGED, function(arg0_7, arg1_7, arg2_7)
		arg0_2.artSceneChanging = false
		arg0_2.artSceneBlocked = not arg2_7

		if arg2_7 then
			arg0_2:UpdateContactState()
		end
	end)
end

function var0_0.OnHandleNotification(arg0_8, arg1_8, arg2_8)
	if arg1_8 == GAME.APARTMENT_COLLECTION_ITEM_DONE then
		arg0_8:UpdateContactState()
	elseif arg1_8 == Dorm3dRoomScene.NOTIFY_UI_STATE then
		arg0_8.uiHidden = arg2_8 ~= "base"

		arg0_8:ActiveContact()
	end
end

function var0_0.GetInterests()
	return {
		GAME.APARTMENT_COLLECTION_ITEM_DONE,
		Dorm3dRoomScene.NOTIFY_UI_STATE
	}
end

function var0_0.OnUpdate(arg0_10)
	if arg0_10.artSceneChanging or arg0_10.artSceneBlocked or not arg0_10.transformFilter or not arg0_10.contactInRangeDic then
		return
	end

	local var0_10 = arg0_10.transformFilter:Execute():ToTable()

	for iter0_10, iter1_10 in pairs(arg0_10.contactInRangeDic) do
		local var1_10 = arg0_10.transRangeDic[iter0_10]
		local var2_10 = false

		if var1_10 then
			var2_10 = underscore(var0_10):chain():slice(unpack(var1_10)):any(function(arg0_11)
				return arg0_11
			end):value()
		end

		if tobool(iter1_10) ~= var2_10 then
			arg0_10.contactInRangeDic[iter0_10] = var2_10

			arg0_10:UpdateContactDisplay(iter0_10, arg0_10:GetDisplayState(iter0_10))
		end
	end
end

function var0_0.UpdateContactState(arg0_12, arg1_12)
	if arg0_12.artSceneChanging or arg0_12.artSceneBlocked then
		return
	end

	local var0_12 = arg0_12:GetRoom()

	if not var0_12 then
		warning("CollectionSystem cannot update without room")

		return
	end

	arg1_12 = arg1_12 or arg0_12:GetTimeIndex()

	arg0_12:SetContactStateDic(var0_12:getTriggerableCollectItemDic(arg1_12))
end

function var0_0.SetContactStateDic(arg0_13, arg1_13)
	arg0_13.contactStateDic = arg1_13 or {}
	arg0_13.hideContactStateDic = {}
	arg0_13.contactInRangeDic = {}
	arg0_13.transRangeDic = {
		list = {}
	}
	arg0_13.transformFilter = arg0_13.transformFilter or BLHX.Rendering.TransformFilter.New()

	local var0_13 = arg0_13:GetModelRoot()

	for iter0_13, iter1_13 in pairs(arg0_13.contactStateDic) do
		arg0_13.hideContactStateDic[iter0_13] = math.min(iter1_13, ApartmentRoom.ITEM_UNLOCK)
		arg0_13.contactInRangeDic[iter0_13] = false

		local var1_13 = pg.dorm3d_collection_template[iter0_13].vfx_prefab or {}

		arg0_13.transRangeDic[iter0_13] = {
			#arg0_13.transRangeDic.list + 1,
			#arg0_13.transRangeDic.list + #var1_13
		}

		table.insertto(arg0_13.transRangeDic.list, underscore.map(var1_13, function(arg0_14)
			return var0_13:Find(arg0_14)
		end))
	end

	arg0_13.transformFilter:Init(arg0_13:GetMainCameraTF(), arg0_13.transRangeDic.list, 2, 60)
	arg0_13:ActiveContact()
end

function var0_0.GetDisplayState(arg0_15, arg1_15)
	if arg0_15.contactInRangeDic[arg1_15] and not arg0_15.uiHidden and not arg0_15.tempHidden then
		return arg0_15.contactStateDic[arg1_15]
	end

	return arg0_15.hideContactStateDic[arg1_15]
end

function var0_0.ActiveContact(arg0_16)
	if arg0_16.artSceneChanging or arg0_16.artSceneBlocked then
		return
	end

	for iter0_16 in pairs(arg0_16.contactInRangeDic) do
		arg0_16:UpdateContactDisplay(iter0_16, arg0_16:GetDisplayState(iter0_16))
	end
end

function var0_0.UpdateContactDisplay(arg0_17, arg1_17, arg2_17)
	local var0_17 = pg.dorm3d_collection_template[arg1_17]
	local var1_17 = arg0_17:GetModelRoot()

	for iter0_17, iter1_17 in ipairs(var0_17.vfx_prefab or {}) do
		local var2_17 = var1_17:Find(iter1_17)

		if arg0_17:IsModeInHidePending(iter1_17) then
			-- block empty
		elseif not var2_17 then
			warning("cannot find", arg1_17, iter1_17)
		else
			setActive(var2_17, arg2_17 == ApartmentRoom.ITEM_FIRST)
		end
	end

	for iter2_17, iter3_17 in ipairs(var0_17.model or {}) do
		local var3_17 = var1_17:Find(iter3_17)

		if arg0_17:IsModeInHidePending(iter3_17) then
			arg0_17:DisableContactTrigger(var3_17)
		elseif not var3_17 then
			warning("cannot find", arg1_17, iter3_17)
		elseif not arg0_17:CheckSceneItemActive(var3_17) then
			arg0_17:DisableContactTrigger(var3_17)
		else
			if arg2_17 == ApartmentRoom.ITEM_FIRST then
				arg0_17:GetContactTrigger(var3_17, arg1_17).enabled = true
			else
				arg0_17:DisableContactTrigger(var3_17)
			end

			setActive(var3_17, arg2_17 > ApartmentRoom.ITEM_LOCK)
		end
	end
end

function var0_0.GetContactTrigger(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.contactTriggers[arg1_18]

	if var0_18 then
		return var0_18
	end

	local var1_18 = GetComponent(arg1_18, typeof(EventTriggerListener)) or GetOrAddComponent(arg1_18, typeof(EventTriggerListener))

	var1_18:AddPointClickFunc(function()
		arg0_18:OnContactClick(arg2_18)
	end)

	arg0_18.contactTriggers[arg1_18] = var1_18

	return var1_18
end

function var0_0.DisableContactTrigger(arg0_20, arg1_20)
	if not arg1_20 then
		return
	end

	local var0_20 = arg0_20.contactTriggers[arg1_20]

	if var0_20 then
		var0_20.enabled = false
	end
end

function var0_0.OnContactClick(arg0_21, arg1_21)
	if arg0_21.uiHidden or arg0_21.tempHidden then
		return
	end

	local var0_21 = arg0_21:GetRoom()

	if not var0_21 then
		return
	end

	local var1_21 = arg0_21:GetApartment()

	arg0_21:Emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_21,
		roomId = var0_21:GetConfigID(),
		groupId = var0_21:isPersonalRoom() and var1_21:GetConfigID() or 0
	})
end

function var0_0.OnDispose(arg0_22)
	arg0_22:ClearContactBindings()

	arg0_22.artSceneChanging = true
	arg0_22.contactTriggers = nil
	arg0_22.transformFilter = nil
end

function var0_0.ClearContactBindings(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23.contactTriggers or {}) do
		iter1_23.enabled = false

		iter1_23:RemovePointClickFunc()
	end

	arg0_23.contactTriggers = {}
	arg0_23.transformFilter = nil
end

return var0_0
