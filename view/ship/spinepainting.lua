local var0_0 = class("SpinePainting")
local var1_0 = require("Mgr/Pool/PoolUtil")
local var2_0 = "spine_painting_idle_init_"

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

local function var3_0(arg0_7, arg1_7)
	arg0_7._go = arg1_7
	arg0_7._tf = tf(arg1_7)

	UIUtil.SetLayerRecursively(arg0_7._go, LayerMask.NameToLayer("UI"))
	arg0_7._tf:SetParent(arg0_7._spinePaintingData.parent, true)

	arg0_7._tf.localScale = arg0_7._spinePaintingData.scale
	arg0_7._tf.localPosition = arg0_7._spinePaintingData.pos
	arg0_7.spineAnimList = {}

	local var0_7 = arg0_7._tf:GetComponent(typeof(ItemList)).prefabItem

	for iter0_7 = 0, var0_7.Length - 1 do
		arg0_7.spineAnimList[#arg0_7.spineAnimList + 1] = GetOrAddComponent(var0_7[iter0_7], "SpineAnimUI")
	end

	local var1_7 = #arg0_7.spineAnimList

	assert(var1_7 > 0, "动态立绘至少要保证有一个spine动画，请检查" .. arg0_7._spinePaintingData:GetShipName())

	if var1_7 == 1 then
		arg0_7.mainSpineAnim = arg0_7.spineAnimList[1]
	else
		arg0_7.mainSpineAnim = arg0_7.spineAnimList[#arg0_7.spineAnimList]
	end

	arg0_7._skeletonGraphic = arg0_7.mainSpineAnim:GetComponent("SkeletonGraphic")
	arg0_7._idleName = arg0_7:getNormalName()
	arg0_7.shipDragData = SpinePaintingConst.ship_drag_datas[arg0_7._spinePaintingData:GetShipName()]
	arg0_7.shipEffectActionAble = SpinePaintingConst.ship_effect_action_able[arg0_7._spinePaintingData:GetShipName()]
	arg0_7._effectsTf = findTF(arg0_7._tf, "effects")

	arg0_7:checkActionShow()
end

function var0_0.getNormalName(arg0_8)
	return "normal"
end

local function var4_0(arg0_9, arg1_9)
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
				var3_0(arg0_10, arg0_12)
				arg0_11()
			end, var3_11)
		end,
		function(arg0_13)
			local var0_13 = arg0_10._spinePaintingData.bgEffectName

			if var0_13 ~= nil then
				local var1_13 = "ui/" .. var0_13

				arg0_10._loader:LoadPrefab(var1_13, "", function(arg0_14)
					var4_0(arg0_10, arg0_14)
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

	arg0_16:checkActionShow()
end

function var0_0.getInitFlag(arg0_17)
	return arg0_17._initFlag
end

function var0_0.checkActionShow(arg0_18)
	local var0_18 = arg0_18:getSpinePaintingInitIdle()
	local var1_18

	if var0_18 then
		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0_18._idleName ~= var0_18 then
			var1_18 = var0_18
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0_18._idleName ~= arg0_18:getNormalName() then
			var1_18 = arg0_18:getNormalName()
		end
	else
		var1_18 = arg0_18:getNormalName()
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
end

function var0_0.DoSpecialTouch(arg0_21)
	if not arg0_21.inAction then
		arg0_21.inAction = true

		arg0_21:SetActionWithFinishCallback("special", 0, function()
			arg0_21:SetAction(arg0_21:getNormalName(), 0)

			arg0_21.inAction = false
		end)
	end
end

function var0_0.DoDragClick(arg0_23)
	if arg0_23:isDragClickShip() then
		return arg0_23:updateDragClick()
	end

	return false
end

function var0_0.isDragClickShip(arg0_24)
	if arg0_24.shipDragData then
		return arg0_24.shipDragData.drag_click_data and arg0_24.shipDragData.drag_click_data.type
	end

	return false
end

function var0_0.updateDragClick(arg0_25)
	if arg0_25.inAction or arg0_25._displayWord then
		return false
	else
		arg0_25.inAction = true
	end

	local var0_25 = arg0_25.shipDragData.drag_click_data

	return arg0_25:checkSpecialDrag(var0_25)
end

function var0_0.checkListAction(arg0_26)
	if #arg0_26.clickActionList > 0 then
		local var0_26 = table.remove(arg0_26.clickActionList, 1)

		arg0_26:SetActionWithFinishCallback(var0_26, 0, function()
			arg0_26:checkListAction()
		end, true)
	else
		arg0_26.inAction = false
		arg0_26.lockLayer = false

		arg0_26:SetAction(arg0_26:getNormalName(), 0)
	end
end

function var0_0.displayWord(arg0_28, arg1_28)
	arg0_28._displayWord = arg1_28
end

function var0_0.DoDragTouch(arg0_29)
	if arg0_29.inAction or arg0_29._displayWord then
		return false
	else
		arg0_29.inAction = true
	end

	if arg0_29:isDragShip() then
		local var0_29 = arg0_29.shipDragData.drag_data

		arg0_29:checkSpecialDrag(var0_29)
	end
end

function var0_0.isDragShip(arg0_30)
	if arg0_30.shipDragData then
		return arg0_30.shipDragData.drag_data and arg0_30.shipDragData.drag_data.type
	end

	return false
end

function var0_0.checkSpecialDrag(arg0_31, arg1_31)
	local var0_31 = arg1_31.type

	if var0_31 == SpinePaintingConst.drag_type_normal or var0_31 == SpinePaintingConst.drag_type_rgb then
		arg0_31:doDragChange(arg1_31)
	elseif var0_31 == SpinePaintingConst.drag_type_list then
		arg0_31.clickActionList = Clone(arg1_31.list)
		arg0_31.lockLayer = arg1_31.lock_layer

		arg0_31:checkListAction()

		return true
	end

	return false
end

function var0_0.doDragChange(arg0_32, arg1_32)
	local var0_32 = arg0_32:getIdleName()

	if not var0_32 or var0_32 ~= "ex" then
		var0_32 = "ex"

		arg0_32:setIdleName(var0_32)

		local var1_32 = arg1_32.type
		local var2_32 = arg1_32.name

		if var1_32 == SpinePaintingConst.drag_type_normal then
			arg0_32:SetActionWithFinishCallback("drag", 0, function()
				arg0_32:changeSpecialIdle(var0_32)
			end)
		elseif var1_32 == SpinePaintingConst.drag_type_rgb then
			arg0_32._baseMaterial = arg0_32._skeletonGraphic.material

			arg0_32:getSpineMaterial("SkeletonGraphicDefaultRGBSplit", function(arg0_34)
				arg0_32._skeletonGraphic.material = arg0_34

				LeanTween.delayedCall(go(arg0_32._tf), 0.5, System.Action(function()
					arg0_32._skeletonGraphic.material = arg0_32._baseMaterial

					arg0_32:changeSpecialIdle(var0_32)
				end))
			end)
		end
	elseif var0_32 == "ex" then
		var0_32 = "normal"

		arg0_32:setIdleName(var0_32)

		local var3_32 = arg1_32.type
		local var4_32 = arg1_32.name

		if var3_32 == SpinePaintingConst.drag_type_normal then
			arg0_32:SetActionWithFinishCallback("drag_ex", 0, function()
				arg0_32:changeSpecialIdle(var0_32)
			end)
		elseif var3_32 == SpinePaintingConst.drag_type_rgb then
			arg0_32._baseMaterial = arg0_32._skeletonGraphic.material

			arg0_32:getSpineMaterial("SkeletonGraphicDefaultRGBSplit", function(arg0_37)
				arg0_32._skeletonGraphic.material = arg0_37

				LeanTween.delayedCall(go(arg0_32._tf), 0.5, System.Action(function()
					arg0_32._skeletonGraphic.material = arg0_32._baseMaterial

					arg0_32:changeSpecialIdle(var0_32)
				end))
			end)
		end
	end
end

function var0_0.getSpineMaterial(arg0_39, arg1_39, arg2_39)
	if not arg0_39._materialDic then
		arg0_39._materialDic = {}
	end

	if arg0_39._materialDic[arg1_39] then
		arg2_39(arg0_39._materialDic[arg1_39])
	else
		arg0_39._materialDic[arg1_39] = LoadAny("spinematerials", arg1_39, typeof(Material))

		arg2_39(arg0_39._materialDic[arg1_39])
	end
end

function var0_0.changeSpecialIdle(arg0_40, arg1_40)
	arg0_40:SetAction(arg1_40, 0)
	arg0_40:setSpinePaintingInitIdle(arg1_40)

	arg0_40.inAction = false
end

function var0_0.SetAction(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41, var1_41 = arg0_41:getMultipFaceFlag()

	if var0_41 then
		arg1_41 = arg0_41:getMultipFaceAction(arg1_41, arg2_41)
	end

	if arg0_41.lockLayer and not arg3_41 then
		return
	end

	if not arg1_41 then
		return
	end

	arg1_41 = arg1_41 == arg0_41:getNormalName() and arg0_41._idleName and arg0_41._idleName or arg1_41

	if arg0_41.shipEffectActionAble and arg0_41._effectsTf then
		if table.contains(arg0_41.shipEffectActionAble, arg1_41) then
			if isActive(arg0_41._effectsTf) then
				setActive(arg0_41._effectsTf, false)
				print("特效层级隐藏生效")
			end
		elseif not isActive(arg0_41._effectsTf) then
			setActive(arg0_41._effectsTf, true)
			print("特效层级显示生效")
		end
	end

	for iter0_41, iter1_41 in ipairs(arg0_41.spineAnimList) do
		iter1_41:SetAction(arg1_41, arg2_41)
	end
end

function var0_0.isInAction(arg0_42)
	return arg0_42.inAction
end

function var0_0.SetActionWithFinishCallback(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43, arg5_43)
	arg0_43.inAction = true

	print("播放动作" .. arg1_43)
	arg0_43:SetAction(arg1_43, arg2_43, arg4_43)

	if arg0_43.mainSpineAnim then
		arg0_43.mainSpineAnim:SetActionCallBack(function(arg0_44)
			if arg0_44 == "finish" and arg3_43 then
				arg0_43.inAction = false

				arg0_43.mainSpineAnim:SetActionCallBack(nil)
				arg3_43()
			elseif arg0_44 == "action" and arg5_43 then
				arg5_43()
			end
		end)
	end
end

function var0_0.SetOnceAction(arg0_45, arg1_45, arg2_45, arg3_45, arg4_45)
	arg0_45:SetActionWithFinishCallback(arg1_45, 0, function()
		arg0_45:SetMainAction(arg0_45:getIdleName(), 0)

		if arg2_45 then
			arg2_45()
		end
	end, arg4_45, function()
		if arg3_45 then
			arg3_45()
		end
	end)
end

function var0_0.SetMainAction(arg0_48, arg1_48, arg2_48)
	if arg0_48.mainSpineAnim then
		arg0_48:SetAction(arg1_48, 0)
	end
end

function var0_0.getAnimationExist(arg0_49, arg1_49)
	if not arg0_49._mainAnimationData then
		arg0_49._mainAnimationData = arg0_49.mainSpineAnim:GetAnimationState()
	end

	local var0_49

	if arg0_49._skeletonGraphic then
		var0_49 = arg0_49._skeletonGraphic.SkeletonData:FindAnimation(arg1_49)
	end

	return var0_49
end

function var0_0.SetEmptyAction(arg0_50, arg1_50)
	for iter0_50, iter1_50 in ipairs(arg0_50.spineAnimList) do
		local var0_50 = iter1_50:GetAnimationState()

		if var0_50 then
			var0_50:SetEmptyAnimation(arg1_50, 0)
			GetComponent(iter1_50.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.getMultipFaceFlag(arg0_51)
	local var0_51 = false
	local var1_51 = 0

	if arg0_51.shipDragData and arg0_51.shipDragData.multiple_face then
		var0_51 = table.contains(arg0_51.shipDragData.multiple_face, arg0_51.mainSpineAnim.name)
	end

	if arg0_51.shipDragData and arg0_51.shipDragData.multiple_count then
		var1_51 = arg0_51.shipDragData.multiple_count
	end

	return var0_51, var1_51
end

function var0_0.getMultipFaceAction(arg0_52, arg1_52, arg2_52)
	local var0_52, var1_52 = arg0_52:getMultipFaceFlag()

	if var0_52 and arg0_52._idleName == "ex" and arg2_52 == 1 then
		if arg0_52.inAction then
			return nil
		end

		local var2_52 = tonumber(arg1_52)

		if var2_52 then
			arg1_52 = tostring(var2_52 + var1_52)
		end
	end

	return arg1_52
end

function var0_0.Dispose(arg0_53)
	arg0_53._materialDic = {}

	if arg0_53._spinePaintingData then
		arg0_53._spinePaintingData:Clear()
	end

	arg0_53._loader:Clear()

	if arg0_53._go ~= nil then
		var1_0.Destroy(arg0_53._go)
	end

	if arg0_53._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_53._bgEffectGo)
	end

	arg0_53._go = nil
	arg0_53._tf = nil
	arg0_53._bgEffectGo = nil
	arg0_53._bgEffectTf = nil

	if arg0_53.spineAnim then
		arg0_53.spineAnim:SetActionCallBack(nil)
	end
end

function var0_0.setSpinePaintingInitIdle(arg0_54, arg1_54)
	local var0_54 = var2_0 .. tostring(arg0_54.mainSpineAnim.name) .. tostring(arg0_54._spinePaintingData.ship.id)

	PlayerPrefs.SetString(var0_54, arg1_54)
end

function var0_0.getSpinePaintingInitIdle(arg0_55)
	local var0_55 = var2_0 .. tostring(arg0_55.mainSpineAnim.name) .. tostring(arg0_55._spinePaintingData.ship.id)
	local var1_55 = PlayerPrefs.GetString(var0_55)

	if var1_55 and #var1_55 > 0 then
		return var1_55
	end

	return nil
end

function var0_0.getPaintingName(arg0_56)
	return arg0_56._spinePaintingData:GetShipName()
end

return var0_0
