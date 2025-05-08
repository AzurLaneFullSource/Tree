local var0_0 = class("SpinePainting")
local var1_0 = require("Mgr/Pool/PoolUtil")

function var0_0.GenerateData(arg0_1)
	local var0_1 = {
		SetData = function(arg0_2, arg1_2)
			arg0_2.ship = arg1_2.ship
			arg0_2.parent = arg1_2.parent
			arg0_2.effectParent = arg1_2.effectParent

			local var0_2 = arg0_2:GetShipSkinConfig()

			arg0_2.pos = arg1_2.position + BuildVector3(var0_2.spine_offset[1])

			local var1_2 = var0_2.spine_offset[2][1]

			arg0_2.scale = Vector3(var1_2, var1_2, var1_2)

			if #var0_2.special_effects > 0 then
				arg0_2.bgEffectName = var0_2.special_effects[1]
				arg0_2.bgEffectPos = arg1_2.position + BuildVector3(var0_2.special_effects[2])

				local var2_2 = var0_2.special_effects[3][1]

				arg0_2.bgEffectScale = Vector3(var2_2, var2_2, var2_2)
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

	UIUtil.SetLayerRecursively(arg0_7._go, LayerMask.NameToLayer("UI"))
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
	arg0_7._idleName = arg0_7:getNormalIdleName()
	arg0_7.shipDragData = SpinePaintingConst.ship_drag_datas[arg0_7._spinePaintingData:GetShipName()]
	arg0_7.dragShipFlag = false

	if arg0_7.shipDragData then
		arg0_7.dragShipFlag = arg0_7.shipDragData.drag_data and arg0_7.shipDragData.drag_data.type
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

function var0_0.getNormalIdleName(arg0_8)
	return "normal"
end

local function var3_0(arg0_9, arg1_9)
	arg0_9._bgEffectGo = arg1_9
	arg0_9._bgEffectTf = tf(arg1_9)

	UIUtil.SetLayerRecursively(arg0_9._bgEffectGo, LayerMask.NameToLayer("UI"))
	arg0_9._bgEffectTf:SetParent(arg0_9._spinePaintingData.effectParent, true)

	arg0_9._bgEffectTf.localScale = arg0_9._spinePaintingData.bgEffectScale
	arg0_9._bgEffectTf.localPosition = arg0_9._spinePaintingData.bgEffectPos
end

function var0_0.Ctor(arg0_10, arg1_10, arg2_10)
	arg0_10._spinePaintingData = arg1_10
	arg0_10._loader = AutoLoader.New()

	parallelAsync({
		function(arg0_11)
			local var0_11 = arg0_10._spinePaintingData:GetShipName()
			local var1_11, var2_11 = HXSet.autoHxShift("spinepainting/", var0_11)
			local var3_11 = var1_11 .. var2_11

			arg0_10._loader:LoadPrefab(var3_11, nil, function(arg0_12)
				var2_0(arg0_10, arg0_12)
				arg0_11()
			end, var3_11)
		end,
		function(arg0_13)
			local var0_13 = arg0_10._spinePaintingData.bgEffectName

			if var0_13 ~= nil then
				local var1_13 = "ui/" .. var0_13

				arg0_10._loader:LoadPrefab(var1_13, "", function(arg0_14)
					var3_0(arg0_10, arg0_14)
					arg0_13()
				end, var1_13)
			else
				arg0_13()
			end
		end
	}, function()
		setActive(arg0_10._spinePaintingData.parent, true)
		setActive(arg0_10._spinePaintingData.effectParent, true)

		arg0_10._initFlag = true

		if arg2_10 then
			arg2_10(arg0_10)
		end
	end)
end

function var0_0.SetVisible(arg0_16, arg1_16)
	setActive(arg0_16._spinePaintingData.effectParent, arg1_16)
	pg.ViewUtils.SetLayer(arg0_16._tf, arg1_16 and Layer.UI or Layer.UIHidden)
	setActiveViaLayer(arg0_16._spinePaintingData.effectParent, arg1_16)

	if arg0_16._skeletonGraphic then
		arg0_16._skeletonGraphic.timeScale = arg1_16 and 1 or 0
	end

	if not arg1_16 then
		arg0_16.mainSpineAnim:SetActionCallBack(nil)

		arg0_16.inAction = false
		arg0_16.lockLayer = false
		arg0_16.clickActionList = {}

		if LeanTween.isTweening(go(arg0_16._tf)) then
			LeanTween.cancel(go(arg0_16._tf))
		end

		if arg0_16._baseShader then
			if arg0_16._skeletonGraphic then
				arg0_16._skeletonGraphic.material.shader = arg0_16._baseShader
			end

			arg0_16._baseShader = nil
		end

		arg0_16._displayWord = false
	end

	arg0_16:playPaintingInitIdle()
end

function var0_0.getInitFlag(arg0_17)
	return arg0_17._initFlag
end

function var0_0.playPaintingInitIdle(arg0_18)
	local var0_18 = SpinePaintingDrag.GetPaintingInitIdle(arg0_18.mainSpineAnim.name, arg0_18._spinePaintingData.ship.id)
	local var1_18 = arg0_18:getNormalIdleName()

	if var0_18 then
		local var2_18 = PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1)

		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0_18._idleName ~= var0_18 then
			var1_18 = var0_18
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0_18._idleName ~= arg0_18:getNormalIdleName() then
			var1_18 = arg0_18:getNormalIdleName()
		end
	else
		var1_18 = arg0_18:getNormalIdleName()
	end

	if var1_18 then
		arg0_18:setIdleName(var1_18)
		arg0_18:SetAction(arg0_18._idleName, 0)
	end
end

function var0_0.getIdleName(arg0_19)
	return arg0_19._idleName
end

function var0_0.setIdleName(arg0_20, arg1_20)
	arg0_20._idleName = arg1_20

	arg0_20:updateHitArea()
end

function var0_0.updateHitArea(arg0_21)
	if arg0_21.dragShipFlag then
		local var0_21 = arg0_21.shipDragData.drag_data.type
		local var1_21 = arg0_21.shipDragData.drag_data.config_client

		if var0_21 == SpinePaintingConst.drag_type_normal then
			for iter0_21 = 1, #var1_21 do
				local var2_21 = var1_21[iter0_21]
				local var3_21 = var2_21.hit

				if var3_21 then
					setActive(findTF(arg0_21._tf, "hitArea/" .. var3_21), var2_21.idle == arg0_21._idleName)
				end
			end
		end
	end
end

function var0_0.checkListAction(arg0_22)
	if #arg0_22.clickActionList > 0 then
		local var0_22 = table.remove(arg0_22.clickActionList, 1)

		arg0_22:SetActionWithFinishCallback(var0_22, 0, function()
			arg0_22:checkListAction()
		end, true)
	else
		arg0_22.inAction = false
		arg0_22.lockLayer = false

		arg0_22:SetAction(arg0_22:getNormalIdleName(), 0)
	end
end

function var0_0.displayWord(arg0_24, arg1_24)
	arg0_24._displayWord = arg1_24
end

function var0_0.readyDragAction(arg0_25, arg1_25)
	if arg0_25.inAction or arg0_25._displayWord then
		return false
	end

	arg0_25.inAction = true

	if arg0_25.dragShipFlag then
		local var0_25 = arg0_25:startDragAction(arg1_25)

		arg0_25.inAction = var0_25

		return var0_25
	end

	return false
end

function var0_0.startDragAction(arg0_26, arg1_26)
	local var0_26 = arg0_26.shipDragData.drag_data
	local var1_26 = var0_26.type

	if var1_26 == SpinePaintingConst.drag_type_normal or var1_26 == SpinePaintingConst.drag_type_rgb then
		return arg0_26:changePaintingNormal(var0_26, arg1_26)
	elseif var1_26 == SpinePaintingConst.drag_type_list then
		arg0_26.clickActionList = Clone(var0_26.config_client)
		arg0_26.lockLayer = var0_26.lock_layer

		return arg0_26:checkListAction()
	elseif var1_26 == SpinePaintingConst.drag_type_once then
		-- block empty
	end

	return false
end

function var0_0.setEventTriggerCallback(arg0_27, arg1_27)
	arg0_27._eventTriggerCall = arg1_27
end

function var0_0.changePaintingNormal(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28:getIdleName()
	local var1_28 = arg1_28.config_client
	local var2_28 = arg1_28.type

	for iter0_28, iter1_28 in ipairs(var1_28) do
		if arg0_28:matchDragFlag(var0_28, arg2_28, iter1_28) then
			return arg0_28:doDragAction(var2_28, arg1_28, iter1_28)
		end
	end

	return false
end

function var0_0.doDragAction(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = arg3_29.change_idle
	local var1_29 = arg3_29.action
	local var2_29 = arg3_29.event

	if arg1_29 == SpinePaintingConst.drag_type_normal then
		if var1_29 and var1_29 ~= "" then
			arg0_29:SetActionWithFinishCallback(var1_29, 0, function()
				arg0_29:changePaintingIdle(var0_29)
			end, false, function()
				if var2_29 and var2_29 ~= "" and arg0_29._eventTriggerCall then
					arg0_29._eventTriggerCall(var2_29)
				end
			end)
		else
			if var0_29 and var0_29 ~= "" then
				arg0_29:changePaintingIdle(var0_29)
			end

			if var2_29 and var2_29 ~= "" and arg0_29._eventTriggerCall then
				arg0_29._eventTriggerCall(var2_29)
			end

			return false
		end
	elseif arg1_29 == SpinePaintingConst.drag_type_rgb then
		arg0_29._baseMaterial = arg0_29._skeletonGraphic.material

		local var3_29 = arg2_29.material

		arg0_29:getSpineMaterial(var3_29, function(arg0_32)
			arg0_29._skeletonGraphic.material = arg0_32

			LeanTween.delayedCall(go(arg0_29._tf), 0.5, System.Action(function()
				arg0_29._skeletonGraphic.material = arg0_29._baseMaterial

				arg0_29:changePaintingIdle(var0_29)
			end))
		end)
	end

	return true
end

function var0_0.matchDragFlag(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = arg3_34.hit

	if var0_34 and var0_34 ~= arg2_34 then
		return false
	end

	local var1_34 = arg3_34.is_default
	local var2_34 = arg3_34.idle

	if not arg1_34 and var1_34 then
		return true
	elseif arg1_34 == var2_34 then
		return true
	end

	return false
end

function var0_0.getSpineMaterial(arg0_35, arg1_35, arg2_35)
	if not arg0_35._materialDic then
		arg0_35._materialDic = {}
	end

	if arg0_35._materialDic[arg1_35] then
		arg2_35(arg0_35._materialDic[arg1_35])
	else
		arg0_35._materialDic[arg1_35] = LoadAny("spinematerials", arg1_35, typeof(Material))

		arg2_35(arg0_35._materialDic[arg1_35])
	end
end

function var0_0.changePaintingIdle(arg0_36, arg1_36)
	arg0_36:setIdleName(arg1_36)
	arg0_36:SetAction(arg1_36, 0)
	SpinePaintingDrag.SetPaintingInitIdle(arg0_36.mainSpineAnim.name, arg0_36._spinePaintingData.ship.id, arg1_36)

	arg0_36.inAction = false
end

function var0_0.SetAction(arg0_37, arg1_37, arg2_37, arg3_37)
	if arg0_37.lockLayer and not arg3_37 then
		return
	end

	if arg0_37._idleName ~= arg0_37:getNormalIdleName() and arg1_37 == "login" then
		return
	end

	if arg0_37.multipleFaceFlag and not arg0_37.inAction then
		arg1_37 = arg0_37:getMultipFaceAction(arg1_37)
	end

	arg0_37:updateEffectVisible(arg1_37)

	for iter0_37, iter1_37 in ipairs(arg0_37.spineAnimList) do
		iter1_37:SetAction(arg1_37, arg2_37)
	end
end

function var0_0.updateEffectVisible(arg0_38, arg1_38)
	if arg0_38.shipEffectActionAble and arg0_38._effectsTf then
		if table.contains(arg0_38.shipEffectActionAble, arg1_38) then
			if isActive(arg0_38._effectsTf) then
				setActive(arg0_38._effectsTf, false)
			end
		elseif not isActive(arg0_38._effectsTf) then
			setActive(arg0_38._effectsTf, true)
		end
	end
end

function var0_0.isInAction(arg0_39)
	return arg0_39.inAction
end

function var0_0.SetActionWithFinishCallback(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40, arg5_40)
	arg0_40.inAction = true

	arg0_40:SetAction(arg1_40, arg2_40, arg4_40)

	if arg0_40.mainSpineAnim then
		arg0_40.mainSpineAnim:SetActionCallBack(function(arg0_41)
			if arg0_41 == "finish" and arg3_40 then
				arg0_40.inAction = false

				arg0_40.mainSpineAnim:SetActionCallBack(nil)
				arg3_40()
			elseif arg0_41 == "action" and arg5_40 then
				arg5_40()
			end
		end)
	end
end

function var0_0.SetOnceAction(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42)
	arg0_42:SetActionWithFinishCallback(arg1_42, 0, function()
		arg0_42.lockLayer = false

		arg0_42:SetMainAction(arg0_42:getIdleName(), 0)

		if arg2_42 then
			arg2_42()
		end
	end, arg4_42, function()
		if arg3_42 then
			arg3_42()
		end
	end)

	arg0_42.lockLayer = true
end

function var0_0.SetMainAction(arg0_45, arg1_45, arg2_45)
	if arg0_45.mainSpineAnim then
		arg0_45:SetAction(arg1_45, 0)
	end
end

function var0_0.getAnimationExist(arg0_46, arg1_46)
	if not arg0_46._mainAnimationData then
		arg0_46._mainAnimationData = arg0_46.mainSpineAnim:GetAnimationState()
	end

	local var0_46

	if arg0_46._skeletonGraphic then
		var0_46 = arg0_46._skeletonGraphic.Skeleton.Data:FindAnimation(arg1_46)
	end

	return var0_46
end

function var0_0.SetEmptyAction(arg0_47, arg1_47)
	for iter0_47, iter1_47 in ipairs(arg0_47.spineAnimList) do
		local var0_47 = iter1_47:GetAnimationState()

		if var0_47 then
			var0_47:SetEmptyAnimation(arg1_47, 0)
			GetComponent(iter1_47.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.getMultipFaceAction(arg0_48, arg1_48)
	if arg0_48.multipleFaceFlag then
		local var0_48 = tonumber(arg1_48)

		if var0_48 and var0_48 >= 0 then
			for iter0_48, iter1_48 in ipairs(arg0_48.multipleFaceData) do
				if iter1_48[1] == arg0_48:getIdleName() then
					return tostring(var0_48 + iter1_48[2])
				end
			end
		end
	end

	return arg1_48
end

function var0_0.Dispose(arg0_49)
	arg0_49._materialDic = {}

	if arg0_49._spinePaintingData then
		arg0_49._spinePaintingData:Clear()
	end

	arg0_49._loader:Clear()

	if arg0_49._go ~= nil then
		var1_0.Destroy(arg0_49._go)
	end

	if arg0_49._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_49._bgEffectGo)
	end

	arg0_49._go = nil
	arg0_49._tf = nil
	arg0_49._bgEffectGo = nil
	arg0_49._bgEffectTf = nil

	if arg0_49.spineAnim then
		arg0_49.spineAnim:SetActionCallBack(nil)
	end
end

function var0_0.getPaintingName(arg0_50)
	return arg0_50._spinePaintingData:GetShipName()
end

return var0_0
