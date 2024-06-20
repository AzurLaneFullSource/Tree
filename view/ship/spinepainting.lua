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
	arg0_7.idleName = arg0_7:getNormalName()
	arg0_7.shipDragData = SpinePaintingConst.ship_drag_datas[arg0_7._spinePaintingData:GetShipName()]

	arg0_7:checkActionShow()
end

function var0_0.getNormalName(arg0_8)
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

				arg0_10._loader:LoadPrefab(var1_13, var0_13, function(arg0_14)
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

		if arg2_10 then
			arg2_10(arg0_10)
		end
	end)
end

function var0_0.SetVisible(arg0_16, arg1_16)
	setActive(arg0_16._spinePaintingData.effectParent, arg1_16)
	setActiveViaLayer(arg0_16._spinePaintingData.effectParent, arg1_16)

	if not arg1_16 then
		arg0_16.mainSpineAnim:SetActionCallBack(nil)

		arg0_16.inAction = false

		if LeanTween.isTweening(go(arg0_16._tf)) then
			LeanTween.cancel(go(arg0_16._tf))
		end

		if arg0_16._baseShader then
			arg0_16._skeletonGraphic.material.shader = arg0_16._baseShader
			arg0_16._baseShader = nil
		end
	end

	arg0_16:checkActionShow()
end

function var0_0.checkActionShow(arg0_17)
	local var0_17 = tostring(arg0_17.mainSpineAnim.name) .. "_" .. tostring(arg0_17._spinePaintingData.ship.id)
	local var1_17 = PlayerPrefs.GetString(var0_17)

	if var1_17 and #var1_17 > 0 then
		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0_17.idleName ~= var1_17 then
			arg0_17.idleName = var1_17

			arg0_17:SetAction(var1_17, 0)
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0_17.idleName ~= arg0_17:getNormalName() then
			arg0_17.idleName = arg0_17:getNormalName()

			arg0_17:SetAction(arg0_17.idleName, 0)
		end
	end
end

function var0_0.DoSpecialTouch(arg0_18)
	if not arg0_18.inAction then
		arg0_18.inAction = true

		arg0_18:SetActionWithFinishCallback("special", 0, function()
			arg0_18:SetAction(arg0_18:getNormalName(), 0)

			arg0_18.inAction = false
		end)
	end
end

function var0_0.DoDragClick(arg0_20)
	if arg0_20:isDragClickShip() then
		arg0_20:updateDragClick()
	end
end

function var0_0.isDragClickShip(arg0_21)
	if arg0_21.shipDragData then
		return arg0_21.shipDragData.drag_click_data and arg0_21.shipDragData.drag_click_data.type
	end

	return false
end

function var0_0.updateDragClick(arg0_22)
	if arg0_22.inAction then
		return
	else
		arg0_22.inAction = true
	end

	local var0_22 = arg0_22.shipDragData.drag_click_data

	if var0_22.type == SpinePaintingConst.click_type_list then
		arg0_22.clickActionList = Clone(var0_22.list)
		arg0_22.lockLayer = var0_22.lock_layer

		arg0_22:checkListAction()
	end
end

function var0_0.checkListAction(arg0_23)
	if #arg0_23.clickActionList > 0 then
		local var0_23 = table.remove(arg0_23.clickActionList, 1)

		arg0_23.lockLayer = clickData.lock_layer

		arg0_23:SetActionWithFinishCallback(var0_23, 0, function()
			arg0_23:checkListAction()
		end)
	elseif arg0_23.inAction then
		arg0_23.inAction = false
		arg0_23.lockLayer = false
	end
end

function var0_0.DoDragTouch(arg0_25)
	if arg0_25:isDragShip() then
		arg0_25:updateDragTouch()
	end
end

function var0_0.isDragShip(arg0_26)
	if arg0_26.shipDragData then
		return arg0_26.shipDragData.drag_data and arg0_26.shipDragData.drag_data.type
	end

	return false
end

function var0_0.updateDragTouch(arg0_27)
	if arg0_27.inAction then
		return
	else
		arg0_27.inAction = true
	end

	local var0_27 = arg0_27.shipDragData.drag_data

	if not arg0_27.idleName or arg0_27.idleName ~= "ex" then
		arg0_27.idleName = "ex"

		local var1_27 = var0_27.type
		local var2_27 = var0_27.name

		if var1_27 == SpinePaintingConst.drag_type_normal then
			arg0_27:SetActionWithFinishCallback("drag", 0, function()
				arg0_27:changeSpecialIdle(arg0_27.idleName)
			end)
		elseif var1_27 == SpinePaintingConst.drag_type_rgb then
			arg0_27._baseMaterial = arg0_27._skeletonGraphic.material

			arg0_27:getSpineMaterial("SkeletonGraphicDefaultRGBSplit", function(arg0_29)
				arg0_27._skeletonGraphic.material = arg0_29

				LeanTween.delayedCall(go(arg0_27._tf), 0.5, System.Action(function()
					arg0_27._skeletonGraphic.material = arg0_27._baseMaterial

					arg0_27:changeSpecialIdle(arg0_27.idleName)
				end))
			end)
		end
	elseif arg0_27.idleName == "ex" then
		arg0_27.idleName = "normal"

		local var3_27 = var0_27.type
		local var4_27 = var0_27.name

		if var3_27 == SpinePaintingConst.drag_type_normal then
			arg0_27:SetActionWithFinishCallback("drag_ex", 0, function()
				arg0_27:changeSpecialIdle(arg0_27.idleName)
			end)
		elseif var3_27 == SpinePaintingConst.drag_type_rgb then
			arg0_27._baseMaterial = arg0_27._skeletonGraphic.material

			arg0_27:getSpineMaterial("SkeletonGraphicDefaultRGBSplit", function(arg0_32)
				arg0_27._skeletonGraphic.material = arg0_32

				LeanTween.delayedCall(go(arg0_27._tf), 0.5, System.Action(function()
					arg0_27._skeletonGraphic.material = arg0_27._baseMaterial

					arg0_27:changeSpecialIdle(arg0_27.idleName)
				end))
			end)
		end
	end
end

function var0_0.getSpineMaterial(arg0_34, arg1_34, arg2_34)
	if not arg0_34._materialDic then
		arg0_34._materialDic = {}
	end

	if arg0_34._materialDic[arg1_34] then
		arg2_34(arg0_34._materialDic[arg1_34])
	end

	PoolMgr:GetInstance():LoadAsset("spinematerials", arg1_34, false, typeof(Material), function(arg0_35)
		arg0_34._materialDic[arg1_34] = arg0_35

		arg2_34(arg0_34._materialDic[arg1_34])
	end, false)
end

function var0_0.changeSpecialIdle(arg0_36, arg1_36)
	arg0_36:SetAction(arg1_36, 0)

	local var0_36 = tostring(arg0_36.mainSpineAnim.name) .. "_" .. tostring(arg0_36._spinePaintingData.ship.id)

	PlayerPrefs.SetString(var0_36, arg1_36)

	arg0_36.inAction = false
end

function var0_0.SetAction(arg0_37, arg1_37, arg2_37)
	if arg0_37:getMultipFaceFlag() then
		arg1_37 = arg0_37:getMultipFaceAction(arg1_37, arg2_37)
	end

	if arg0_37.lockLayer and arg2_37 ~= 0 then
		return
	end

	if not arg1_37 then
		return
	end

	if arg0_37.idleName and arg1_37 == arg0_37:getNormalName() then
		arg1_37 = arg0_37.idleName
	end

	for iter0_37, iter1_37 in ipairs(arg0_37.spineAnimList) do
		iter1_37:SetAction(arg1_37, arg2_37)
	end
end

function var0_0.isInAction(arg0_38)
	return arg0_38.inAction
end

function var0_0.SetActionWithFinishCallback(arg0_39, arg1_39, arg2_39, arg3_39)
	arg0_39:SetAction(arg1_39, arg2_39)

	if arg0_39.mainSpineAnim then
		arg0_39.mainSpineAnim:SetActionCallBack(function(arg0_40)
			if arg0_40 == "finish" and arg3_39 then
				arg0_39.mainSpineAnim:SetActionCallBack(nil)
				arg3_39()
			end
		end)
		arg0_39.mainSpineAnim:SetAction(arg1_39, 0)
	end
end

function var0_0.SetEmptyAction(arg0_41, arg1_41)
	arg0_41:SetVisible(true)

	for iter0_41, iter1_41 in ipairs(arg0_41.spineAnimList) do
		local var0_41 = iter1_41:GetAnimationState()

		if var0_41 then
			var0_41:SetEmptyAnimation(arg1_41, 0)
			GetComponent(iter1_41.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.getMultipFaceFlag(arg0_42)
	if arg0_42.shipDragData and arg0_42.shipDragData.multiple_face then
		return table.contains(arg0_42.shipDragData.multiple_face, arg0_42.mainSpineAnim.name)
	end

	return false
end

function var0_0.getMultipFaceAction(arg0_43, arg1_43, arg2_43)
	if arg0_43:getMultipFaceFlag() and arg0_43.idleName == "ex" and arg2_43 == 1 then
		if arg0_43.inAction then
			return nil
		end

		local var0_43 = tonumber(arg1_43)

		if var0_43 then
			arg1_43 = tostring(var0_43 + 5)
		end
	end

	return arg1_43
end

function var0_0.Dispose(arg0_44)
	arg0_44._materialDic = {}

	if arg0_44._spinePaintingData then
		arg0_44._spinePaintingData:Clear()
	end

	arg0_44._loader:Clear()

	if arg0_44._go ~= nil then
		var1_0.Destroy(arg0_44._go)
	end

	if arg0_44._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_44._bgEffectGo)
	end

	arg0_44._go = nil
	arg0_44._tf = nil
	arg0_44._bgEffectGo = nil
	arg0_44._bgEffectTf = nil

	if arg0_44.spineAnim then
		arg0_44.spineAnim:SetActionCallBack(nil)
	end
end

return var0_0
