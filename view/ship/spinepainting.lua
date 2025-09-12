local var0_0 = class("SpinePainting")
local var1_0 = require("Mgr/Pool/PoolUtil")

function var0_0.GenerateData(arg0_1)
	local var0_1 = {
		SetData = function(arg0_2, arg1_2)
			arg0_2.ship = arg1_2.ship
			arg0_2.parent = arg1_2.parent
			arg0_2.effectParent = arg1_2.effectParent

			local var0_2 = arg0_2:GetShipSkinConfig()
			local var1_2
			local var2_2

			if arg1_2.offset and #arg1_2.offset >= 3 then
				var1_2 = BuildVector3({
					arg1_2.offset[1],
					arg1_2.offset[2],
					arg1_2.offset[3]
				})
			elseif var0_2.spine_offset and #var0_2.spine_offset >= 3 then
				var1_2 = BuildVector3({
					var0_2.spine_offset[1],
					var0_2.spine_offset[2],
					var0_2.spine_offset[3]
				})
			else
				var1_2 = BuildVector3({
					0,
					0,
					0
				})
			end

			if arg1_2.offset and #arg1_2.offset >= 4 then
				var2_2 = arg1_2.offset[4]
			elseif var0_2.spine_offset and #var0_2.spine_offset >= 4 then
				var2_2 = var0_2.spine_offset[4]
			else
				var2_2 = 1
			end

			arg0_2.pos = arg1_2.position + var1_2
			arg0_2.scale = Vector3(var2_2, var2_2, var2_2)

			if #var0_2.special_effects > 0 then
				arg0_2.bgEffectName = var0_2.special_effects[1]
				arg0_2.bgEffectPos = arg1_2.position + BuildVector3(var0_2.special_effects[2])

				local var3_2 = var0_2.special_effects[3][1]

				arg0_2.bgEffectScale = Vector3(var3_2, var3_2, var3_2)
			end
		end,
		GetShipName = function(arg0_3)
			return arg0_3.ship:getPainting()
		end,
		GetShipSkinConfig = function(arg0_4)
			return arg0_4.ship:GetSkinConfig()
		end,
		isEmpty = function(arg0_5)
			return arg0_5.ship == nil
		end,
		Clear = function(arg0_6)
			arg0_6.ship = nil
			arg0_6.parent = nil
			arg0_6.scale = nil
			arg0_6.pos = nil
			arg0_6.bgEffectName = nil
			arg0_6.bgEffectPos = nil
			arg0_6.bgEffectScale = nil
			arg0_6.effectParent = nil
		end
	}

	var0_1:SetData(arg0_1)

	return var0_1
end

local function var2_0(arg0_7, arg1_7)
	arg0_7._go = arg1_7
	arg0_7._tf = tf(arg1_7)

	HotfixHelper.SetLayerRecursively(arg0_7._go, LayerMask.NameToLayer("UI"))
	arg0_7._tf:SetParent(arg0_7._spinePaintingData.parent, true)

	arg0_7._tf.localScale = arg0_7._spinePaintingData.scale
	arg0_7._tf.localPosition = arg0_7._spinePaintingData.pos
	arg0_7.spineAnimList = {}

	local var0_7 = arg0_7._tf:GetComponent(typeof(ItemList)).prefabItem:ToTable()

	for iter0_7, iter1_7 in ipairs(var0_7) do
		arg0_7.spineAnimList[#arg0_7.spineAnimList + 1] = GetOrAddComponent(iter1_7, "SpineAnimUI")
	end

	local var1_7 = #arg0_7.spineAnimList

	assert(var1_7 > 0, "动态立绘至少要保证有一个spine动画，请检查" .. arg0_7._spinePaintingData:GetShipName())

	if var1_7 == 1 then
		arg0_7.mainSpineAnim = arg0_7.spineAnimList[1]
	else
		arg0_7.mainSpineAnim = arg0_7.spineAnimList[#arg0_7.spineAnimList]
	end

	arg0_7._skeletonGraphic = arg0_7.mainSpineAnim:GetComponent("SkeletonGraphic")

	function arg0_7.updateLocal()
		arg0_7:onUpdateLocal()
	end

	arg0_7._skeletonGraphic.UpdateLocal = arg0_7._skeletonGraphic.UpdateLocal + arg0_7.updateLocal
	arg0_7._baseMaterial = arg0_7._skeletonGraphic.material
	arg0_7._idleName = arg0_7:getNormalIdleName()
	arg0_7.shipDragData = SpinePaintingConst.ship_drag_datas[arg0_7._spinePaintingData:GetShipName()]
	arg0_7.dragShipFlag = false
	arg0_7.lockLayer = false

	if arg0_7.shipDragData then
		arg0_7.dragShipFlag = arg0_7.shipDragData.drag_data and arg0_7.shipDragData.drag_data.type
		arg0_7.lockLayer = arg0_7.shipDragData.drag_data.lock_layer
		arg0_7.replaceWord = arg0_7.shipDragData.replace_word
	end

	arg0_7.multipleFaceFlag = false

	if arg0_7.shipDragData and arg0_7.shipDragData.multiple_face and arg0_7.shipDragData.multiple_face ~= "" then
		local var2_7 = arg0_7.shipDragData.multiple_face.name

		arg0_7.multipleFaceFlag = table.contains(var2_7, arg0_7.mainSpineAnim.name)
		arg0_7.multipleFaceData = arg0_7.shipDragData.multiple_face.data
	end

	arg0_7.shipEffectActionAble = SpinePaintingConst.ship_effect_action_able[arg0_7._spinePaintingData:GetShipName()]
	arg0_7._effectsTf = findTF(arg0_7._tf, "effects")

	arg0_7:playPaintingInitIdle()
end

function var0_0.getNormalIdleName(arg0_9)
	return "normal"
end

local function var3_0(arg0_10, arg1_10)
	arg0_10._bgEffectGo = arg1_10
	arg0_10._bgEffectTf = tf(arg1_10)

	HotfixHelper.SetLayerRecursively(arg0_10._bgEffectGo, LayerMask.NameToLayer("UI"))
	arg0_10._bgEffectTf:SetParent(arg0_10._spinePaintingData.effectParent, true)

	arg0_10._bgEffectTf.localScale = arg0_10._spinePaintingData.bgEffectScale
	arg0_10._bgEffectTf.localPosition = arg0_10._spinePaintingData.bgEffectPos
end

function var0_0.Ctor(arg0_11, arg1_11, arg2_11)
	arg0_11._spinePaintingData = arg1_11
	arg0_11._loader = AutoLoader.New()

	parallelAsync({
		function(arg0_12)
			local var0_12 = arg0_11._spinePaintingData:GetShipName()
			local var1_12, var2_12 = HXSet.autoHxShift("spinepainting/", var0_12)
			local var3_12 = var1_12 .. var2_12

			arg0_11._loader:LoadPrefab(var3_12, nil, function(arg0_13)
				var2_0(arg0_11, arg0_13)
				arg0_12()
			end, var3_12)
		end,
		function(arg0_14)
			local var0_14 = arg0_11._spinePaintingData.bgEffectName

			if var0_14 ~= nil then
				local var1_14 = "ui/" .. var0_14

				arg0_11._loader:LoadPrefab(var1_14, "", function(arg0_15)
					var3_0(arg0_11, arg0_15)
					arg0_14()
				end, var1_14)
			else
				arg0_14()
			end
		end
	}, function()
		setActive(arg0_11._spinePaintingData.parent, true)
		setActive(arg0_11._spinePaintingData.effectParent, true)

		arg0_11._initFlag = true

		arg0_11:updateLink()

		if arg2_11 then
			arg2_11(arg0_11)
		end
	end)
end

function var0_0.updateLink(arg0_17)
	arg0_17.slotOverride = {}

	local var0_17 = arg0_17._spinePaintingData.ship:getSkinId()
	local var1_17 = ChangeSkinLink.CHANGE_SKIN_LINK_DATA[var0_17]

	if var1_17 then
		local var2_17 = var1_17.link_id
		local var3_17 = var1_17.relations

		if var1_17.link_type == ChangeSkinLink.L2D_TYPE then
			local var4_17

			if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 then
				var4_17 = ChangeSkinLink.GetSaveL2dData(arg0_17._spinePaintingData.ship.id, var2_17)
			else
				var4_17 = ChangeSkinLink.L2D_PARAMETER_DIC[arg0_17._spinePaintingData.ship.id]
			end

			var4_17 = var4_17 or {}

			for iter0_17, iter1_17 in ipairs(var3_17) do
				if iter1_17.type == ChangeSkinLink.change_parameter_link_slot then
					local var5_17 = true
					local var6_17 = iter1_17.link_parameter
					local var7_17 = iter1_17.slot_list

					for iter2_17, iter3_17 in ipairs(var6_17) do
						local var8_17 = iter3_17.name
						local var9_17 = iter3_17.num

						if (var4_17[var8_17] and var4_17[var8_17] or 0) ~= var9_17 then
							var5_17 = false
						end
					end

					if var5_17 then
						for iter4_17, iter5_17 in ipairs(var7_17) do
							table.insert(arg0_17.slotOverride, iter5_17)
						end
					end
				end
			end
		end
	end
end

function var0_0.setL2dSlot(arg0_18, arg1_18, arg2_18)
	arg0_18._skeletonGraphic.Skeleton:SetAttachment(arg1_18, arg2_18)
end

function var0_0.onUpdateLocal(arg0_19)
	if arg0_19.slotOverride then
		for iter0_19, iter1_19 in ipairs(arg0_19.slotOverride) do
			arg0_19:setL2dSlot(iter1_19[1], iter1_19[2])
		end
	end
end

function var0_0.SetVisible(arg0_20, arg1_20)
	setActive(arg0_20._spinePaintingData.effectParent, arg1_20)
	pg.ViewUtils.SetLayer(arg0_20._tf, arg1_20 and Layer.UI or Layer.UIHidden)
	setActiveViaLayer(arg0_20._spinePaintingData.effectParent, arg1_20)

	if arg0_20._skeletonGraphic then
		arg0_20._skeletonGraphic.timeScale = arg1_20 and 1 or 0
	end

	if not arg1_20 then
		arg0_20.mainSpineAnim:SetActionCallBack(nil)

		arg0_20.inAction = false
		arg0_20.clickActionList = {}

		if LeanTween.isTweening(go(arg0_20._tf)) then
			LeanTween.cancel(go(arg0_20._tf))
		end

		if arg0_20._baseShader then
			if arg0_20._skeletonGraphic then
				arg0_20._skeletonGraphic.material.shader = arg0_20._baseShader
			end

			arg0_20._baseShader = nil
		end

		arg0_20._displayWord = false
	else
		arg0_20._skeletonGraphic:Update(Time.deltaTime)
	end

	arg0_20:playPaintingInitIdle()
end

function var0_0.getInitFlag(arg0_21)
	return arg0_21._initFlag
end

function var0_0.playPaintingInitIdle(arg0_22)
	local var0_22 = SpinePaintingDrag.GetPaintingInitIdle(arg0_22.mainSpineAnim.name, arg0_22._spinePaintingData.ship.id)
	local var1_22 = arg0_22:getNormalIdleName()

	if var0_22 then
		local var2_22 = PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1)

		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0_22._idleName ~= var0_22 then
			var1_22 = var0_22
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0_22._idleName ~= arg0_22:getNormalIdleName() then
			var1_22 = arg0_22:getNormalIdleName()
		end
	else
		var1_22 = arg0_22:getNormalIdleName()
	end

	if var1_22 then
		arg0_22:setIdleName(var1_22)
		arg0_22:SetAction(arg0_22._idleName, 0, true)

		arg0_22.inAction = false
	end
end

function var0_0.getIdleName(arg0_23)
	return arg0_23._idleName
end

function var0_0.setIdleName(arg0_24, arg1_24)
	arg0_24._idleName = arg1_24

	arg0_24:updateHitArea()
end

function var0_0.getReplaceWord(arg0_25)
	if arg0_25.replaceWord and table.contains(arg0_25.replaceWord, arg0_25._idleName) then
		return true
	end

	return false
end

function var0_0.updateHitArea(arg0_26)
	if arg0_26.dragShipFlag then
		local var0_26 = arg0_26.shipDragData.drag_data.type
		local var1_26 = arg0_26.shipDragData.drag_data.config_client

		if var0_26 == SpinePaintingConst.drag_type_normal then
			for iter0_26 = 1, #var1_26 do
				local var2_26 = var1_26[iter0_26]
				local var3_26 = var2_26.hit
				local var4_26 = var2_26.active

				if var3_26 and not var4_26 then
					local var5_26 = findTF(arg0_26._tf, "hitArea/" .. var3_26)

					if var5_26 then
						setActive(var5_26, var2_26.idle == arg0_26._idleName)
					else
						print("hit area " .. var3_26 .. "is not exist")
					end
				end
			end
		end
	end
end

function var0_0.checkListAction(arg0_27)
	if #arg0_27.clickActionList > 0 then
		local var0_27 = table.remove(arg0_27.clickActionList, 1)

		arg0_27:SetActionWithFinishCallback(var0_27, 0, function()
			arg0_27:checkListAction()
		end, true)
	else
		arg0_27:SetAction(arg0_27:getNormalIdleName(), 0, true)

		arg0_27.inAction = false
	end
end

function var0_0.displayWord(arg0_29, arg1_29)
	arg0_29._displayWord = arg1_29
end

function var0_0.readyDragAction(arg0_30, arg1_30, arg2_30)
	if arg0_30.inAction or arg0_30._displayWord then
		return false
	end

	if arg0_30.dragShipFlag then
		return (arg0_30:startDragAction(arg1_30))
	end

	return false
end

function var0_0.startDragAction(arg0_31, arg1_31)
	local var0_31 = arg0_31.shipDragData.drag_data
	local var1_31 = var0_31.type

	if var1_31 == SpinePaintingConst.drag_type_normal or var1_31 == SpinePaintingConst.drag_type_rgb then
		return arg0_31:changePaintingNormal(var0_31, arg1_31)
	elseif var1_31 == SpinePaintingConst.drag_type_list then
		arg0_31.clickActionList = Clone(var0_31.config_client)

		return arg0_31:checkListAction()
	end

	return false
end

function var0_0.setEventTriggerCallback(arg0_32, arg1_32)
	arg0_32._eventTriggerCall = arg1_32
end

function var0_0.changePaintingNormal(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33:getIdleName()
	local var1_33 = arg1_33.config_client
	local var2_33 = arg1_33.type

	for iter0_33, iter1_33 in ipairs(var1_33) do
		if arg0_33:matchDragFlag(var0_33, arg2_33, iter1_33) then
			return arg0_33:doDragAction(var2_33, arg1_33, iter1_33)
		end
	end

	return false
end

function var0_0.doDragAction(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = arg3_34.change_idle
	local var1_34

	if type(arg3_34.action) == "string" then
		var1_34 = arg3_34.action
	elseif type(arg3_34.action) == "table" then
		var1_34 = arg3_34.action[math.random(1, #arg3_34.action)]
	end

	local var2_34 = arg3_34.event
	local var3_34 = arg3_34.fold
	local var4_34 = arg3_34.effect_hide

	if arg1_34 == SpinePaintingConst.drag_type_normal then
		if var1_34 and var1_34 ~= "" and arg0_34:ablePlayAction(var1_34, false, 0) then
			if var3_34 then
				pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, true)
			end

			arg0_34:setEffectVisible(var4_34, false)
			arg0_34:SetActionWithFinishCallback(var1_34, 0, function()
				if var3_34 then
					pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, false)
				end

				arg0_34:changePaintingIdle(var0_34)
				arg0_34:setEffectVisible(var4_34, true)
			end, false, function()
				if var2_34 and var2_34 ~= "" and arg0_34._eventTriggerCall then
					arg0_34._eventTriggerCall(var2_34)
				end
			end)
		else
			if var0_34 and var0_34 ~= "" then
				arg0_34:changePaintingIdle(var0_34)
			end

			if var2_34 and var2_34 ~= "" and arg0_34._eventTriggerCall then
				arg0_34._eventTriggerCall(var2_34)
			end

			return false
		end
	elseif arg1_34 == SpinePaintingConst.drag_type_rgb then
		local var5_34 = arg2_34.material

		if LeanTween.isTweening(go(arg0_34._tf)) then
			return false
		end

		arg0_34:getSpineMaterial(var5_34, function(arg0_37)
			arg0_34._skeletonGraphic.material = arg0_37

			LeanTween.delayedCall(go(arg0_34._tf), 0.5, System.Action(function()
				arg0_34._skeletonGraphic.material = arg0_34._baseMaterial

				arg0_34:changePaintingIdle(var0_34)
			end))
		end)
	end

	return true
end

function var0_0.setEffectVisible(arg0_39, arg1_39, arg2_39)
	if not arg1_39 or #arg1_39 == 0 then
		return
	end

	for iter0_39 = 1, #arg1_39 do
		local var0_39 = findTF(arg0_39._tf, arg1_39[iter0_39])

		if var0_39 then
			setActive(var0_39, arg2_39)
		end
	end
end

function var0_0.matchDragFlag(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40 = arg3_40.hit

	if var0_40 and var0_40 ~= arg2_40 then
		return false
	end

	local var1_40 = arg3_40.is_default
	local var2_40 = arg3_40.idle

	if not arg1_40 and var1_40 then
		return true
	elseif arg1_40 == var2_40 then
		return true
	end

	return false
end

function var0_0.getSpineMaterial(arg0_41, arg1_41, arg2_41)
	if not arg0_41._materialDic then
		arg0_41._materialDic = {}
	end

	if arg0_41._materialDic[arg1_41] then
		arg2_41(arg0_41._materialDic[arg1_41])
	else
		arg0_41._materialDic[arg1_41] = LoadAny("spinematerials", arg1_41, typeof(Material))

		arg2_41(arg0_41._materialDic[arg1_41])
	end
end

function var0_0.changePaintingIdle(arg0_42, arg1_42)
	arg0_42:setIdleName(arg1_42)
	arg0_42:SetAction(arg1_42, 0, true)
	SpinePaintingDrag.SetPaintingInitIdle(arg0_42.mainSpineAnim.name, arg0_42._spinePaintingData.ship.id, arg1_42)

	arg0_42.inAction = false
end

function var0_0.SetAction(arg0_43, arg1_43, arg2_43, arg3_43)
	if not arg0_43:ablePlayAction(arg1_43, arg3_43, arg2_43) then
		return false
	end

	if arg2_43 and arg2_43 == 0 then
		arg0_43.lastPlayAction = arg1_43
	end

	if arg2_43 == 0 and arg1_43 ~= arg0_43:getIdleName() then
		arg0_43.inAction = true
	end

	if arg0_43.multipleFaceFlag and not arg0_43.inAction then
		arg1_43 = arg0_43:getMultipFaceAction(arg1_43)
	end

	arg0_43:updateEffectVisible(arg1_43)

	for iter0_43, iter1_43 in ipairs(arg0_43.spineAnimList) do
		iter1_43:SetAction(arg1_43, arg2_43)

		if iter1_43:GetAnimationState() then
			GetComponent(iter1_43.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end

	return true
end

function var0_0.ablePlayAction(arg0_44, arg1_44, arg2_44, arg3_44)
	if arg3_44 and arg3_44 == 0 and arg0_44.inAction and not arg2_44 then
		return false
	end

	if arg0_44.lockLayer and not arg2_44 and arg0_44.inAction and arg3_44 and arg3_44 > 0 then
		return false
	end

	if arg0_44.lastPlayAction and arg0_44.lastPlayAction ~= arg0_44._idleName and arg3_44 and arg3_44 > 0 then
		return false
	end

	if arg0_44._idleName ~= arg0_44:getNormalIdleName() and arg1_44 == "login" then
		return false
	end

	if arg0_44.dragShipFlag and arg0_44.shipDragData.action_enable then
		local var0_44 = arg0_44.shipDragData.action_enable

		for iter0_44 = 1, #var0_44 do
			local var1_44 = var0_44[iter0_44]

			if var1_44.name == arg0_44._idleName and table.contains(var1_44.ignore, arg1_44) then
				return false
			end
		end
	end

	return true
end

function var0_0.updateEffectVisible(arg0_45, arg1_45)
	if arg0_45.shipEffectActionAble and arg0_45._effectsTf then
		if table.contains(arg0_45.shipEffectActionAble, arg1_45) then
			if isActive(arg0_45._effectsTf) then
				setActive(arg0_45._effectsTf, false)
			end
		elseif not isActive(arg0_45._effectsTf) then
			setActive(arg0_45._effectsTf, true)
		end
	end
end

function var0_0.isInAction(arg0_46)
	return arg0_46.inAction
end

function var0_0.SetActionWithFinishCallback(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47, arg5_47)
	if not arg0_47:ablePlayAction(arg1_47, arg4_47, arg2_47) then
		return
	end

	if arg0_47.mainSpineAnim then
		arg0_47.mainSpineAnim:SetActionCallBack(function(arg0_48)
			if arg0_48 == "finish" and arg3_47 then
				arg0_47.inAction = false

				arg0_47.mainSpineAnim:SetActionCallBack(nil)
				arg3_47()
			elseif arg0_48 == "action" and arg5_47 then
				arg5_47()
			end
		end)
	end

	arg0_47:SetAction(arg1_47, arg2_47, arg4_47)
end

function var0_0.SetOnceAction(arg0_49, arg1_49, arg2_49, arg3_49, arg4_49)
	if not arg0_49:ablePlayAction(arg1_49, arg4_49, 0) then
		return
	end

	arg0_49:SetActionWithFinishCallback(arg1_49, 0, function()
		arg0_49:SetAction(arg0_49:getIdleName(), 0)

		if arg2_49 then
			arg2_49()
		end
	end, arg4_49, function()
		if arg3_49 then
			arg3_49()
		end
	end)
end

function var0_0.getAnimationExist(arg0_52, arg1_52)
	if not arg0_52._mainAnimationData then
		arg0_52._mainAnimationData = arg0_52.mainSpineAnim:GetAnimationState()
	end

	local var0_52

	if arg0_52._skeletonGraphic then
		var0_52 = arg0_52._skeletonGraphic.Skeleton.Data:FindAnimation(arg1_52)
	end

	return var0_52
end

function var0_0.SetEmptyAction(arg0_53, arg1_53)
	if not arg0_53.spineAnimList then
		return
	end

	for iter0_53, iter1_53 in ipairs(arg0_53.spineAnimList) do
		local var0_53 = iter1_53:GetAnimationState()

		if var0_53 then
			var0_53:SetEmptyAnimation(arg1_53, 0)
			GetComponent(iter1_53.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.GetSpineTrasform(arg0_54)
	return arg0_54._tf
end

function var0_0.SetSkin(arg0_55, arg1_55)
	if arg0_55._skeletonGraphic and arg0_55._skeletonGraphic.SkeletonData and arg0_55._skeletonGraphic.SkeletonData:FindSkin(arg1_55) ~= nil then
		arg0_55._skeletonGraphic.Skeleton:SetSkin(arg1_55)
		arg0_55._skeletonGraphic.Skeleton:SetSlotsToSetupPose()
	end
end

function var0_0.getMultipFaceAction(arg0_56, arg1_56)
	if arg0_56.multipleFaceFlag then
		local var0_56 = tonumber(arg1_56)

		if var0_56 and var0_56 >= 0 then
			for iter0_56, iter1_56 in ipairs(arg0_56.multipleFaceData) do
				if iter1_56[1] == arg0_56:getIdleName() then
					return tostring(var0_56 + iter1_56[2])
				end
			end
		end
	end

	return arg1_56
end

function var0_0.Dispose(arg0_57)
	arg0_57._materialDic = {}

	if arg0_57.updateLocal then
		arg0_57._skeletonGraphic.UpdateLocal = arg0_57._skeletonGraphic.UpdateLocal - arg0_57.updateLocal
		arg0_57.updateLocal = nil
	end

	if arg0_57._spinePaintingData then
		arg0_57._spinePaintingData:Clear()
	end

	arg0_57._loader:Clear()

	if arg0_57._go ~= nil then
		var1_0.Destroy(arg0_57._go)
	end

	if arg0_57._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_57._bgEffectGo)
	end

	arg0_57._go = nil
	arg0_57._tf = nil
	arg0_57._bgEffectGo = nil
	arg0_57._bgEffectTf = nil

	if arg0_57.spineAnim then
		arg0_57.spineAnim:SetActionCallBack(nil)
	end
end

function var0_0.getPaintingName(arg0_58)
	return arg0_58._spinePaintingData:GetShipName()
end

return var0_0
