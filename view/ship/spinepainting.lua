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
	arg0_7:SetDefaultSkeletonSkin()
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
	arg0_11._loadSpineDic = {}
	arg0_11._loadUIDic = {}

	parallelAsync({
		function(arg0_12)
			local var0_12 = arg0_11._spinePaintingData:GetShipName()
			local var1_12, var2_12 = HXSet.autoHxShift("spinepainting/", var0_12)
			local var3_12 = var1_12 .. var2_12

			PoolMgr.GetInstance():GetSpinePainting(var0_12, true, function(arg0_13)
				arg0_11._loadSpineDic[var0_12] = arg0_13

				var2_0(arg0_11, arg0_13)
				arg0_12()
			end)
		end,
		function(arg0_14)
			local var0_14 = arg0_11._spinePaintingData.bgEffectName

			if var0_14 ~= nil then
				PoolMgr.GetInstance():GetUI(var0_14, true, function(arg0_15)
					arg0_11._loadUIDic[var0_14] = arg0_15

					var3_0(arg0_11, arg0_15)
					arg0_14()
				end)
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
				local var5_17 = iter1_17.type

				if var5_17 == ChangeSkinLink.change_parameter_link_slot then
					local var6_17 = true
					local var7_17 = iter1_17.link_parameter
					local var8_17 = iter1_17.slot_list

					for iter2_17, iter3_17 in ipairs(var7_17) do
						local var9_17 = iter3_17.name
						local var10_17 = iter3_17.num

						if (var4_17[var9_17] and var4_17[var9_17] or 0) ~= var10_17 then
							var6_17 = false
						end
					end

					if var6_17 then
						for iter4_17, iter5_17 in ipairs(var8_17) do
							table.insert(arg0_17.slotOverride, iter5_17)
						end
					end
				elseif var5_17 == ChangeSkinLink.change_parameter_link_skin then
					local var11_17 = true
					local var12_17 = iter1_17.link_parameter
					local var13_17 = iter1_17.skeleton_skin

					for iter6_17, iter7_17 in ipairs(var12_17) do
						local var14_17 = iter7_17.name
						local var15_17 = iter7_17.num

						if (var4_17[var14_17] and var4_17[var14_17] or 0) ~= var15_17 then
							var11_17 = false
						end
					end

					if var11_17 then
						arg0_17:SetSkeletonSkin(var13_17)
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

function var0_0.SetSkeletonSkin(arg0_31, arg1_31)
	arg0_31._skeletonSkin = arg1_31

	arg0_31._skeletonGraphic.Skeleton:SetSkin(arg1_31)
	arg0_31:updateSkeletonGraphicTime()
end

function var0_0.SetDefaultSkeletonSkin(arg0_32)
	local var0_32 = arg0_32._spinePaintingData:GetShipSkinConfig().skeleton_default_skin

	if not var0_32 or var0_32 == "" then
		var0_32 = "1"
	end

	local var1_32 = arg0_32._skeletonGraphic.SkeletonData:FindSkin(var0_32)

	if var1_32 and var1_32 ~= nil then
		arg0_32:SetSkeletonSkin(var0_32)
	end
end

function var0_0.startDragAction(arg0_33, arg1_33)
	local var0_33 = arg0_33.shipDragData.drag_data
	local var1_33 = var0_33.type

	if var1_33 == SpinePaintingConst.drag_type_normal or var1_33 == SpinePaintingConst.drag_type_rgb then
		return arg0_33:changePaintingNormal(var0_33, arg1_33)
	elseif var1_33 == SpinePaintingConst.drag_type_list then
		arg0_33.clickActionList = Clone(var0_33.config_client)

		return arg0_33:checkListAction()
	end

	return false
end

function var0_0.setEventTriggerCallback(arg0_34, arg1_34)
	arg0_34._eventTriggerCall = arg1_34
end

function var0_0.changePaintingNormal(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg0_35:getIdleName()
	local var1_35 = arg1_35.config_client
	local var2_35 = arg1_35.type

	for iter0_35, iter1_35 in ipairs(var1_35) do
		if arg0_35:matchDragFlag(var0_35, arg2_35, iter1_35) then
			return arg0_35:doDragAction(var2_35, arg1_35, iter1_35)
		end
	end

	return false
end

function var0_0.doDragAction(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = arg3_36.change_idle
	local var1_36

	if type(arg3_36.action) == "string" then
		var1_36 = arg3_36.action
	elseif type(arg3_36.action) == "table" then
		var1_36 = arg3_36.action[math.random(1, #arg3_36.action)]
	end

	local var2_36 = arg3_36.event
	local var3_36 = arg3_36.fold
	local var4_36 = arg3_36.effect_hide

	if arg1_36 == SpinePaintingConst.drag_type_normal then
		if var1_36 and var1_36 ~= "" and arg0_36:ablePlayAction(var1_36, false, 0) then
			if var3_36 then
				pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, true)
			end

			arg0_36:setEffectVisible(var4_36, false)
			arg0_36:SetActionWithFinishCallback(var1_36, 0, function()
				if var3_36 then
					pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, false)
				end

				arg0_36:changePaintingIdle(var0_36)
				arg0_36:setEffectVisible(var4_36, true)
			end, false, function()
				if var2_36 and var2_36 ~= "" and arg0_36._eventTriggerCall then
					arg0_36._eventTriggerCall(var2_36)
				end
			end)
		else
			if var0_36 and var0_36 ~= "" then
				arg0_36:changePaintingIdle(var0_36)
			end

			if var2_36 and var2_36 ~= "" and arg0_36._eventTriggerCall then
				arg0_36._eventTriggerCall(var2_36)
			end

			return false
		end
	elseif arg1_36 == SpinePaintingConst.drag_type_rgb then
		local var5_36 = arg2_36.material

		if LeanTween.isTweening(go(arg0_36._tf)) then
			return false
		end

		arg0_36:getSpineMaterial(var5_36, function(arg0_39)
			arg0_36._skeletonGraphic.material = arg0_39

			LeanTween.delayedCall(go(arg0_36._tf), 0.5, System.Action(function()
				arg0_36._skeletonGraphic.material = arg0_36._baseMaterial

				arg0_36:changePaintingIdle(var0_36)
			end))
		end)
	end

	return true
end

function var0_0.setEffectVisible(arg0_41, arg1_41, arg2_41)
	if not arg1_41 or #arg1_41 == 0 then
		return
	end

	for iter0_41 = 1, #arg1_41 do
		local var0_41 = findTF(arg0_41._tf, arg1_41[iter0_41])

		if var0_41 then
			setActive(var0_41, arg2_41)
		end
	end
end

function var0_0.matchDragFlag(arg0_42, arg1_42, arg2_42, arg3_42)
	local var0_42 = arg3_42.hit

	if var0_42 and var0_42 ~= arg2_42 then
		return false
	end

	local var1_42 = arg3_42.is_default
	local var2_42 = arg3_42.idle

	if not arg1_42 and var1_42 then
		return true
	elseif arg1_42 == var2_42 then
		return true
	end

	return false
end

function var0_0.getSpineMaterial(arg0_43, arg1_43, arg2_43)
	if not arg0_43._materialDic then
		arg0_43._materialDic = {}
	end

	if arg0_43._materialDic[arg1_43] then
		arg2_43(arg0_43._materialDic[arg1_43])
	else
		arg0_43._materialDic[arg1_43] = LoadAny("spinematerials", arg1_43, typeof(Material))

		arg2_43(arg0_43._materialDic[arg1_43])
	end
end

function var0_0.changePaintingIdle(arg0_44, arg1_44)
	arg0_44:setIdleName(arg1_44)
	arg0_44:SetAction(arg1_44, 0, true)
	SpinePaintingDrag.SetPaintingInitIdle(arg0_44.mainSpineAnim.name, arg0_44._spinePaintingData.ship.id, arg1_44)

	arg0_44.inAction = false
end

function var0_0.SetAction(arg0_45, arg1_45, arg2_45, arg3_45)
	if not arg0_45:ablePlayAction(arg1_45, arg3_45, arg2_45) then
		return false
	end

	if arg2_45 and arg2_45 == 0 then
		arg0_45.lastPlayAction = arg1_45
	end

	if arg2_45 == 0 and arg1_45 ~= arg0_45:getIdleName() then
		arg0_45.inAction = true
	end

	if arg0_45.multipleFaceFlag and not arg0_45.inAction then
		arg1_45 = arg0_45:getMultipFaceAction(arg1_45)
	end

	arg0_45:updateEffectVisible(arg1_45)

	for iter0_45, iter1_45 in ipairs(arg0_45.spineAnimList) do
		iter1_45:SetAction(arg1_45, arg2_45)

		if iter1_45:GetAnimationState() then
			GetComponent(iter1_45.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end

	return true
end

function var0_0.ablePlayAction(arg0_46, arg1_46, arg2_46, arg3_46)
	if arg3_46 and arg3_46 == 0 and arg0_46.inAction and not arg2_46 then
		return false
	end

	if arg0_46.lockLayer and not arg2_46 and arg0_46.inAction and arg3_46 and arg3_46 > 0 then
		return false
	end

	if arg0_46.lastPlayAction and arg0_46.lastPlayAction ~= arg0_46._idleName and arg3_46 and arg3_46 > 0 then
		return false
	end

	if arg0_46._idleName ~= arg0_46:getNormalIdleName() and arg1_46 == "login" then
		return false
	end

	if arg0_46.dragShipFlag and arg0_46.shipDragData.action_enable then
		local var0_46 = arg0_46.shipDragData.action_enable

		for iter0_46 = 1, #var0_46 do
			local var1_46 = var0_46[iter0_46]

			if var1_46.name == arg0_46._idleName and table.contains(var1_46.ignore, arg1_46) then
				return false
			end
		end
	end

	return true
end

function var0_0.updateEffectVisible(arg0_47, arg1_47)
	if arg0_47.shipEffectActionAble and arg0_47._effectsTf then
		if table.contains(arg0_47.shipEffectActionAble, arg1_47) then
			if isActive(arg0_47._effectsTf) then
				setActive(arg0_47._effectsTf, false)
			end
		elseif not isActive(arg0_47._effectsTf) then
			setActive(arg0_47._effectsTf, true)
		end
	end
end

function var0_0.isInAction(arg0_48)
	return arg0_48.inAction
end

function var0_0.SetActionWithFinishCallback(arg0_49, arg1_49, arg2_49, arg3_49, arg4_49, arg5_49)
	if not arg0_49:ablePlayAction(arg1_49, arg4_49, arg2_49) then
		return
	end

	if arg0_49.mainSpineAnim then
		arg0_49.mainSpineAnim:SetActionCallBack(function(arg0_50)
			if arg0_50 == "finish" and arg3_49 then
				arg0_49.inAction = false

				arg0_49.mainSpineAnim:SetActionCallBack(nil)
				arg3_49()
			elseif arg0_50 == "action" and arg5_49 then
				arg5_49()
			end
		end)
	end

	arg0_49:SetAction(arg1_49, arg2_49, arg4_49)
end

function var0_0.SetOnceAction(arg0_51, arg1_51, arg2_51, arg3_51, arg4_51)
	if not arg0_51:ablePlayAction(arg1_51, arg4_51, 0) then
		return
	end

	arg0_51:SetActionWithFinishCallback(arg1_51, 0, function()
		arg0_51:SetAction(arg0_51:getIdleName(), 0)

		if arg2_51 then
			arg2_51()
		end
	end, arg4_51, function()
		if arg3_51 then
			arg3_51()
		end
	end)
end

function var0_0.getAnimationExist(arg0_54, arg1_54)
	if not arg0_54._mainAnimationData then
		arg0_54._mainAnimationData = arg0_54.mainSpineAnim:GetAnimationState()
	end

	local var0_54

	if arg0_54._skeletonGraphic then
		var0_54 = arg0_54._skeletonGraphic.Skeleton.Data:FindAnimation(arg1_54)
	end

	return var0_54
end

function var0_0.SetEmptyAction(arg0_55, arg1_55)
	if not arg0_55.spineAnimList then
		return
	end

	for iter0_55, iter1_55 in ipairs(arg0_55.spineAnimList) do
		local var0_55 = iter1_55:GetAnimationState()

		if var0_55 then
			var0_55:SetEmptyAnimation(arg1_55, 0)
			GetComponent(iter1_55.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.GetSpineTrasform(arg0_56)
	return arg0_56._tf
end

function var0_0.SetSkin(arg0_57, arg1_57)
	if arg0_57._skeletonGraphic and arg0_57._skeletonGraphic.SkeletonData and arg0_57._skeletonGraphic.SkeletonData:FindSkin(arg1_57) ~= nil then
		arg0_57._skeletonGraphic.Skeleton:SetSkin(arg1_57)
		arg0_57._skeletonGraphic.Skeleton:SetSlotsToSetupPose()
	end
end

function var0_0.updateSkeletonGraphicTime(arg0_58)
	if arg0_58._skeletonGraphic then
		arg0_58._skeletonGraphic:Update(Time.deltaTime)
	end
end

function var0_0.getMultipFaceAction(arg0_59, arg1_59)
	if arg0_59.multipleFaceFlag then
		local var0_59 = tonumber(arg1_59)

		if var0_59 and var0_59 >= 0 then
			for iter0_59, iter1_59 in ipairs(arg0_59.multipleFaceData) do
				if iter1_59[1] == arg0_59:getIdleName() then
					return tostring(var0_59 + iter1_59[2])
				end
			end
		end
	end

	return arg1_59
end

function var0_0.Dispose(arg0_60)
	arg0_60._materialDic = {}

	if arg0_60.updateLocal then
		arg0_60._skeletonGraphic.UpdateLocal = arg0_60._skeletonGraphic.UpdateLocal - arg0_60.updateLocal
		arg0_60.updateLocal = nil
	end

	if arg0_60._spinePaintingData then
		arg0_60._spinePaintingData:Clear()
	end

	for iter0_60, iter1_60 in pairs(arg0_60._loadSpineDic) do
		PoolMgr.GetInstance():ReturnSpinePainting(iter0_60, iter1_60)
	end

	for iter2_60, iter3_60 in pairs(arg0_60._loadUIDic) do
		PoolMgr.GetInstance():ReturnUI(iter2_60, iter3_60)
	end

	arg0_60._loadSpineDic = {}
	arg0_60._loadUIDic = {}

	if arg0_60._go ~= nil then
		var1_0.Destroy(arg0_60._go)
	end

	if arg0_60._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_60._bgEffectGo)
	end

	arg0_60._go = nil
	arg0_60._tf = nil
	arg0_60._bgEffectGo = nil
	arg0_60._bgEffectTf = nil

	if arg0_60.spineAnim then
		arg0_60.spineAnim:SetActionCallBack(nil)
	end
end

function var0_0.getPaintingName(arg0_61)
	return arg0_61._spinePaintingData:GetShipName()
end

return var0_0
