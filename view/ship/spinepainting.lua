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
		GetShipId = function(arg0_5)
			return arg0_5.ship.id
		end,
		isEmpty = function(arg0_6)
			return arg0_6.ship == nil
		end,
		Clear = function(arg0_7)
			arg0_7.ship = nil
			arg0_7.parent = nil
			arg0_7.scale = nil
			arg0_7.pos = nil
			arg0_7.bgEffectName = nil
			arg0_7.bgEffectPos = nil
			arg0_7.bgEffectScale = nil
			arg0_7.effectParent = nil
		end
	}

	var0_1:SetData(arg0_1)

	return var0_1
end

function var0_0.Ctor(arg0_8, arg1_8, arg2_8)
	arg0_8._spinePaintingData = arg1_8
	arg0_8._loadSpineDic = {}
	arg0_8._loadUIDic = {}
	arg0_8._initCallback = {}
	arg0_8.loadSheets = {}
	arg0_8._visible = true

	parallelAsync({
		function(arg0_9)
			local var0_9 = arg0_8._spinePaintingData:GetShipName()

			PoolMgr.GetInstance():GetSpinePainting(var0_9, true, function(arg0_10)
				arg0_8._loadSpineDic[var0_9] = arg0_10

				arg0_8:init(arg0_10)
				arg0_9()
			end)
		end,
		function(arg0_11)
			local var0_11 = arg0_8._spinePaintingData.bgEffectName

			if var0_11 ~= nil then
				PoolMgr.GetInstance():GetUI(var0_11, true, function(arg0_12)
					arg0_8._loadUIDic[var0_11] = arg0_12

					arg0_8:initBgEffect(arg0_12)
					arg0_11()
				end)
			else
				arg0_11()
			end
		end
	}, function()
		setActive(arg0_8._spinePaintingData.parent, true)
		setActive(arg0_8._spinePaintingData.effectParent, true)

		arg0_8._initFlag = true

		arg0_8:updateLink()

		for iter0_13, iter1_13 in ipairs(arg0_8._initCallback) do
			iter1_13()
		end

		arg0_8._initCallback = {}

		if arg2_8 then
			arg2_8(arg0_8)
		end
	end)
end

function var0_0.init(arg0_14, arg1_14)
	arg0_14._go = arg1_14
	arg0_14._tf = tf(arg1_14)

	HotfixHelper.SetLayerRecursively(arg0_14._go, LayerMask.NameToLayer("UI"))
	arg0_14._tf:SetParent(arg0_14._spinePaintingData.parent, true)

	arg0_14._tf.localScale = arg0_14._spinePaintingData.scale
	arg0_14._tf.localPosition = arg0_14._spinePaintingData.pos
	arg0_14.spineAnimList = {}

	local var0_14 = arg0_14._tf:GetComponent(typeof(ItemList)).prefabItem:ToTable()

	for iter0_14, iter1_14 in ipairs(var0_14) do
		arg0_14.spineAnimList[#arg0_14.spineAnimList + 1] = GetOrAddComponent(iter1_14, "SpineAnimUI")
	end

	local var1_14 = #arg0_14.spineAnimList

	assert(var1_14 > 0, "动态立绘至少要保证有一个spine动画，请检查" .. arg0_14._spinePaintingData:GetShipName())

	if var1_14 == 1 then
		arg0_14.mainSpineAnim = arg0_14.spineAnimList[1]
	else
		arg0_14.mainSpineAnim = arg0_14.spineAnimList[#arg0_14.spineAnimList]
	end

	arg0_14._skeletonGraphic = arg0_14.mainSpineAnim:GetComponent("SkeletonGraphic")

	function arg0_14.updateLocal()
		arg0_14:onUpdateLocal()
	end

	arg0_14._skeletonGraphic.UpdateLocal = arg0_14._skeletonGraphic.UpdateLocal + arg0_14.updateLocal
	arg0_14._baseMaterial = arg0_14._skeletonGraphic.material
	arg0_14._idleName = arg0_14:getNormalIdleName()
	arg0_14.shipDragData = SpinePaintingConst.ship_drag_datas[arg0_14._spinePaintingData:GetShipName()]
	arg0_14.dragShipFlag = false
	arg0_14.lockLayer = false

	if arg0_14.shipDragData then
		arg0_14.dragShipFlag = arg0_14.shipDragData.drag_data and arg0_14.shipDragData.drag_data.type
		arg0_14.lockLayer = arg0_14.shipDragData.drag_data.lock_layer
		arg0_14.replaceWord = arg0_14.shipDragData.replace_word
		arg0_14.dragDataConfigClient = arg0_14.shipDragData.drag_data.config_client
	end

	arg0_14.multipleFaceFlag = false

	if arg0_14.shipDragData and arg0_14.shipDragData.multiple_face and arg0_14.shipDragData.multiple_face ~= "" then
		local var2_14 = arg0_14.shipDragData.multiple_face.name

		arg0_14.multipleFaceFlag = table.contains(var2_14, arg0_14.mainSpineAnim.name)
		arg0_14.multipleFaceData = arg0_14.shipDragData.multiple_face.data
	end

	arg0_14.shipEffectActionAble = SpinePaintingConst.ship_effect_action_able[arg0_14._spinePaintingData:GetShipName()]
	arg0_14._effectsTf = findTF(arg0_14._tf, "effects")
	arg0_14._effectShowFlag = true
	arg0_14._dragPassFlag = true
	arg0_14._lightTf = findTF(arg0_14._tf, "light")

	if arg0_14._lightTf then
		arg0_14._lightAnimator = arg0_14._lightTf:GetComponent(typeof(Animator))
		arg0_14._lightAnimationName = arg0_14._lightAnimator.runtimeAnimatorController.animationClips[0].name

		arg0_14._lightAnimator:Play(arg0_14._lightAnimationName, -1, SpinePaintingConst.painting_lit_value)
	end

	arg0_14:playPaintingInitIdle()
	arg0_14:playPaintingInitSkin()

	arg0_14.slotDic = {}
	arg0_14.stepSlotAlpha = {}
	arg0_14._slotAlphaTimer = Timer.New(function()
		arg0_14:updateSlotAlpha()
		arg0_14:updateLight()
	end, 0.0166666666666667, -1)

	arg0_14._slotAlphaTimer:Start()
end

function var0_0.initBgEffect(arg0_17, arg1_17)
	arg0_17._bgEffectGo = arg1_17
	arg0_17._bgEffectTf = tf(arg1_17)

	HotfixHelper.SetLayerRecursively(arg0_17._bgEffectGo, LayerMask.NameToLayer("UI"))
	arg0_17._bgEffectTf:SetParent(arg0_17._spinePaintingData.effectParent, true)

	arg0_17._bgEffectTf.localScale = arg0_17._spinePaintingData.bgEffectScale
	arg0_17._bgEffectTf.localPosition = arg0_17._spinePaintingData.bgEffectPos
end

function var0_0.getInitFlag(arg0_18)
	return arg0_18._initFlag
end

function var0_0.getNormalIdleName(arg0_19)
	if HXSet.isHx() and arg0_19.shipDragData and arg0_19.shipDragData.hx_idle then
		return arg0_19.shipDragData.hx_idle
	end

	return "normal"
end

function var0_0.updateLink(arg0_20)
	arg0_20.slotOverride = {}

	local var0_20 = arg0_20._spinePaintingData.ship:getSkinId()
	local var1_20 = ChangeSkinLink.CHANGE_SKIN_LINK_DATA[var0_20]

	if var1_20 then
		local var2_20 = var1_20.link_id
		local var3_20 = var1_20.relations

		if var1_20.link_type == ChangeSkinLink.L2D_TYPE then
			local var4_20

			if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 then
				var4_20 = ChangeSkinLink.GetSaveL2dData(arg0_20._spinePaintingData.ship.id, var2_20)
			else
				var4_20 = ChangeSkinLink.L2D_PARAMETER_DIC[arg0_20._spinePaintingData.ship.id]
			end

			var4_20 = var4_20 or {}

			for iter0_20, iter1_20 in ipairs(var3_20) do
				local var5_20 = iter1_20.type

				if var5_20 == ChangeSkinLink.change_parameter_link_slot then
					local var6_20 = true
					local var7_20 = iter1_20.link_parameter
					local var8_20 = iter1_20.slot_list

					for iter2_20, iter3_20 in ipairs(var7_20) do
						local var9_20 = iter3_20.name
						local var10_20 = iter3_20.num

						if (var4_20[var9_20] and var4_20[var9_20] or 0) ~= var10_20 then
							var6_20 = false
						end
					end

					if var6_20 then
						for iter4_20, iter5_20 in ipairs(var8_20) do
							table.insert(arg0_20.slotOverride, iter5_20)
						end
					end
				elseif var5_20 == ChangeSkinLink.change_parameter_link_skin then
					local var11_20 = true
					local var12_20 = iter1_20.link_parameter
					local var13_20 = iter1_20.skeleton_skin

					for iter6_20, iter7_20 in ipairs(var12_20) do
						local var14_20 = iter7_20.name
						local var15_20 = iter7_20.num

						if (var4_20[var14_20] and var4_20[var14_20] or 0) ~= var15_20 then
							var11_20 = false
						end
					end

					if var11_20 then
						arg0_20:SetSkeletonSkin(var13_20)
					end
				end
			end
		end
	end
end

function var0_0.setL2dSlot(arg0_21, arg1_21, arg2_21)
	arg0_21._skeletonGraphic.Skeleton:SetAttachment(arg1_21, arg2_21)
end

function var0_0.onUpdateLocal(arg0_22)
	if arg0_22.slotOverride then
		for iter0_22, iter1_22 in ipairs(arg0_22.slotOverride) do
			arg0_22:setL2dSlot(iter1_22[1], iter1_22[2])
		end
	end
end

function var0_0.SetVisible(arg0_23, arg1_23)
	if not arg1_23 and arg0_23.dragDataConfigClient then
		local var0_23 = arg0_23:getIdleName()

		for iter0_23, iter1_23 in ipairs(arg0_23.dragDataConfigClient) do
			if iter1_23.idle == var0_23 and iter1_23.lit_start and iter1_23.lit_start >= 0 then
				SpinePaintingConst.painting_lit_value = iter1_23.lit_start

				if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 then
					SpinePaintingDrag.SetPaintingLite(arg0_23._spinePaintingData:GetShipName(), arg0_23._spinePaintingData:GetShipId(), SpinePaintingConst.painting_lit_value)
				else
					SpinePaintingDrag.SetPaintingLite(arg0_23._spinePaintingData:GetShipName(), arg0_23._spinePaintingData:GetShipId(), 0)
				end
			end
		end
	end

	SpinePaintingConst.spine_painting_action = false

	if arg1_23 then
		arg0_23._slotAlphaTimer:Start()
	else
		arg0_23._slotAlphaTimer:Stop()
	end

	arg0_23._visible = arg1_23

	local function var1_23()
		if arg0_23._isDisposed then
			return
		end

		if arg0_23._lightTf then
			setActive(arg0_23._lightTf, arg0_23._visible)
		end

		if arg0_23._spinePaintingData.effectParent then
			setActive(arg0_23._spinePaintingData.effectParent, arg0_23._visible)
		end

		pg.ViewUtils.SetLayer(arg0_23._tf, arg0_23._visible and Layer.UI or Layer.UIHidden)
		setActiveViaLayer(arg0_23._spinePaintingData.effectParent, arg0_23._visible)

		arg0_23._lightValue = nil
		arg0_23._effectShowFlag = true
		arg0_23._dragPassFlag = true

		if arg0_23._skeletonGraphic then
			arg0_23._skeletonGraphic.timeScale = arg0_23._visible and 1 or 0
		end

		if not arg0_23._visible then
			arg0_23.mainSpineAnim:SetActionCallBack(nil)
			arg0_23:changeInAction(false)

			arg0_23.clickActionList = {}

			if LeanTween.isTweening(go(arg0_23._tf)) then
				LeanTween.cancel(go(arg0_23._tf))
			end

			if arg0_23._baseShader then
				if arg0_23._skeletonGraphic then
					arg0_23._skeletonGraphic.material.shader = arg0_23._baseShader
				end

				arg0_23._baseShader = nil
			end

			arg0_23._displayWord = false
		else
			arg0_23._skeletonGraphic:Update(Time.deltaTime)
		end

		arg0_23:playPaintingInitIdle()
		arg0_23:playPaintingInitSkin()
		arg0_23:updateLink()

		if not arg1_23 then
			arg0_23:unloadCueSheet()
			pg.CriMgr.GetInstance():DisposePaintingBgm()
		end
	end

	onNextTick(var1_23)
end

function var0_0.playPaintingInitIdle(arg0_25)
	local var0_25 = SpinePaintingDrag.GetPaintingInitIdle(arg0_25.mainSpineAnim.name, arg0_25._spinePaintingData.ship.id)
	local var1_25 = arg0_25:getNormalIdleName()

	if var0_25 then
		local var2_25 = PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1)

		if var2_25 == 1 and arg0_25._idleName ~= var0_25 then
			var1_25 = var0_25
		elseif var2_25 ~= 1 and arg0_25._idleName ~= arg0_25:getNormalIdleName() then
			var1_25 = arg0_25:getNormalIdleName()
		end
	else
		var1_25 = arg0_25:getNormalIdleName()
	end

	if var1_25 then
		arg0_25:setIdleName(var1_25)
		arg0_25:SetActionWithFinishCallback(arg0_25._idleName, 0, nil, true, nil)
		arg0_25:changeInAction(false)
	end
end

function var0_0.changeInAction(arg0_26, arg1_26)
	arg0_26.inAction = arg1_26
	SpinePaintingConst.spine_painting_action = arg1_26

	if SpinePaintingConst.painting_lit_action_callback then
		SpinePaintingConst.painting_lit_action_callback(arg1_26)
	end
end

function var0_0.playPaintingInitSkin(arg0_27)
	local var0_27 = SpinePaintingDrag.GetPaintingInitSkin(arg0_27.mainSpineAnim.name, arg0_27._spinePaintingData.ship.id)
	local var1_27 = arg0_27:GetDefaultSkeletonSkin()

	if var0_27 then
		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0_27:GetDefaultSkeletonSkin() ~= var0_27 then
			var1_27 = var0_27
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0_27._skeletonSkin ~= arg0_27:GetDefaultSkeletonSkin() then
			var1_27 = arg0_27:GetDefaultSkeletonSkin()
		end
	else
		var1_27 = arg0_27:GetDefaultSkeletonSkin()
	end

	if var1_27 then
		if arg0_27._skeletonGraphic and arg0_27._skeletonGraphic.SkeletonData then
			if arg0_27._skeletonGraphic.SkeletonData:FindSkin(var1_27) ~= nil then
				arg0_27:SetSkeletonSkin(var1_27)
			elseif arg0_27._skeletonGraphic.SkeletonData:FindSkin("default") ~= nil then
				arg0_27:SetSkeletonSkin("default")
			end
		end
	else
		arg0_27:SetDefaultSkeletonSkin()
	end
end

function var0_0.getIdleName(arg0_28)
	return arg0_28._idleName
end

function var0_0.setIdleName(arg0_29, arg1_29)
	arg0_29._idleName = arg1_29

	arg0_29:updateHitArea()
end

function var0_0.getReplaceWord(arg0_30)
	if arg0_30.replaceWord and table.contains(arg0_30.replaceWord, arg0_30._idleName) then
		return true
	end

	return false
end

function var0_0.updateHitArea(arg0_31)
	if arg0_31.dragShipFlag then
		local var0_31 = arg0_31.shipDragData.drag_data.type
		local var1_31 = arg0_31.shipDragData.drag_data.config_client

		if var0_31 == SpinePaintingConst.drag_type_normal then
			for iter0_31 = 1, #var1_31 do
				local var2_31 = var1_31[iter0_31]
				local var3_31 = var2_31.hit
				local var4_31 = var2_31.active

				if var3_31 and not var4_31 then
					local var5_31 = findTF(arg0_31._tf, "hitArea/" .. var3_31)

					if var5_31 then
						local var6_31 = true
						local var7_31 = true

						if var2_31.idle and type(var2_31.idle) == "string" then
							var6_31 = var2_31.idle == arg0_31._idleName
						elseif var2_31.idle and type(var2_31.idle) == "table" then
							var6_31 = table.contains(var2_31.idle, arg0_31._idleName)
						end

						if var2_31.skin and type(var2_31.skin) == "string" then
							var7_31 = var2_31.skin == arg0_31._skeletonSkin
						elseif var2_31.skin and type(var2_31.skin) == "table" then
							var7_31 = table.contains(var2_31.skin, arg0_31._skeletonSkin)
						end

						setActive(var5_31, var6_31 and var7_31)
					else
						print("hit area " .. var3_31 .. "is not exist")
					end
				end
			end
		end
	end
end

function var0_0.checkListAction(arg0_32)
	if #arg0_32.clickActionList > 0 then
		local var0_32 = table.remove(arg0_32.clickActionList, 1)

		arg0_32:SetActionWithFinishCallback(var0_32, 0, function()
			arg0_32:checkListAction()
		end, true)
	else
		arg0_32:SetAction(arg0_32:getNormalIdleName(), 0, true)
		arg0_32:changeInAction(false)
	end
end

function var0_0.displayWord(arg0_34, arg1_34)
	arg0_34._displayWord = arg1_34
end

function var0_0.readyDragAction(arg0_35, arg1_35, arg2_35)
	if arg0_35.inAction or arg0_35._displayWord then
		return false
	end

	if arg0_35.dragShipFlag then
		return arg0_35:startDragAction(arg1_35, arg2_35)
	end

	return false
end

function var0_0.SetSkeletonSkin(arg0_36, arg1_36)
	arg0_36._skeletonSkin = arg1_36

	arg0_36:SetSkin(arg1_36)
	arg0_36:updateSkeletonGraphicTime()
	arg0_36:updateHitArea()
end

function var0_0.SetDefaultSkeletonSkin(arg0_37)
	arg0_37:SetSkeletonSkin(arg0_37:GetDefaultSkeletonSkin())
end

function var0_0.GetDefaultSkeletonSkin(arg0_38)
	local var0_38 = arg0_38._spinePaintingData:GetShipSkinConfig().skeleton_default_skin

	if not var0_38 or var0_38 == "" then
		var0_38 = arg0_38._skeletonGraphic.SkeletonData:FindSkin("1") and "1" or "default"
	end

	return var0_38
end

function var0_0.startDragAction(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39.shipDragData.drag_data
	local var1_39 = var0_39.type

	if var1_39 == SpinePaintingConst.drag_type_normal then
		return arg0_39:changePaintingNormal(var0_39, arg1_39, arg2_39)
	elseif var1_39 == SpinePaintingConst.drag_type_list then
		arg0_39.clickActionList = Clone(var0_39.config_client)

		return arg0_39:checkListAction()
	end

	return false
end

function var0_0.GetDragDataConfig(arg0_40, arg1_40)
	if arg0_40.shipDragData then
		return arg0_40.shipDragData[arg1_40]
	end

	return nil
end

function var0_0.setEventTriggerCallback(arg0_41, arg1_41)
	arg0_41._eventTriggerCall = arg1_41
end

function var0_0.changePaintingNormal(arg0_42, arg1_42, arg2_42, arg3_42)
	local var0_42 = arg1_42.config_client
	local var1_42 = arg1_42.type

	for iter0_42, iter1_42 in ipairs(var0_42) do
		if arg0_42:matchDragFlag(arg2_42, iter1_42, arg3_42) then
			return arg0_42:doDragAction(var1_42, arg1_42, iter1_42, arg3_42)
		end
	end

	return false
end

function var0_0.doDragAction(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43)
	local var0_43 = arg3_43.fold
	local var1_43 = arg3_43.fold_chat and arg3_43.fold_chat or nil
	local var2_43 = arg3_43.effect_hide
	local var3_43 = arg3_43.action_cv
	local var4_43 = arg3_43.finish_cv
	local var5_43 = arg3_43.alpha_data and arg3_43.alpha_data or nil
	local var6_43 = arg3_43.skin_change and arg3_43.skin_change or nil
	local var7_43 = arg3_43.clear_track and arg3_43.clear_track or nil
	local var8_43 = arg3_43.idle and arg3_43.idle or nil
	local var9_43 = arg3_43.change_idle
	local var10_43 = arg3_43.action
	local var11_43 = arg3_43.event
	local var12_43 = var6_43
	local var13_43
	local var14_43
	local var15_43

	if type(var9_43) == "table" and type(var10_43) == "table" then
		local var16_43 = math.random(1, #var10_43)

		var13_43 = var10_43[var16_43]
		var15_43 = var9_43[var16_43]
	elseif type(var8_43) == "table" and type(var10_43) == "table" then
		local var17_43 = table.indexof(var8_43, arg0_43:getIdleName())

		var13_43 = var10_43[var17_43]

		if type(var9_43) == "table" then
			var15_43 = var9_43[var17_43]
		end
	end

	if not var13_43 then
		if type(var10_43) == "string" then
			var13_43 = var10_43
		elseif type(var10_43) == "table" then
			var13_43 = var10_43[math.random(1, #var10_43)]
		end
	end

	if not var15_43 then
		if type(var9_43) == "string" then
			var15_43 = var9_43
		elseif type(var9_43) == "table" then
			var15_43 = var9_43[math.random(1, #var9_43)]
		end
	end

	if not var14_43 then
		if type(var11_43) == "string" then
			var14_43 = var11_43
		elseif type(var11_43) == "table" then
			var14_43 = var11_43[math.random(1, #var11_43)]
		end
	end

	if arg1_43 == SpinePaintingConst.drag_type_normal then
		if var5_43 and #var5_43 > 0 then
			arg0_43:SetAlphaData(var5_43)
		end

		local var18_43 = arg3_43.material and arg3_43.material or nil
		local var19_43 = arg3_43.material_time and arg3_43.material_time or nil

		if var18_43 then
			if LeanTween.isTweening(go(arg0_43._tf)) then
				return false
			end

			arg0_43:getSpineMaterial(var18_43, function(arg0_44)
				arg0_43._skeletonGraphic.material = arg0_44

				if var19_43 then
					LeanTween.delayedCall(go(arg0_43._tf), var19_43, System.Action(function()
						arg0_43._skeletonGraphic.material = arg0_43._baseMaterial

						arg0_43:changePaintingIdle(var15_43)
					end))
				end
			end)
		end

		if var7_43 and #var7_43 > 0 then
			for iter0_43, iter1_43 in ipairs(var7_43) do
				arg0_43:SetEmptyAction(iter1_43)
			end
		end

		if var13_43 and var13_43 ~= "" and arg0_43:checkActionPlayAble(var13_43, false, 0) then
			print("播放动作 .." .. var13_43 .. "下一个待机动作 .. " .. var15_43)

			if var0_43 then
				pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, {
					flag = true,
					content = {
						chat = var1_43
					}
				})
			end

			arg0_43:setEffectVisible(var2_43, false)
			arg0_43:SetActionWithFinishCallback(var13_43, 0, function()
				if var12_43 and var12_43 ~= "" then
					arg0_43:changeSkeletonSkin(var12_43)
				end

				if var0_43 then
					pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, {
						flag = false,
						content = {
							chat = var1_43
						}
					})
				end

				arg0_43:changePaintingIdle(var15_43 and var15_43 or arg0_43:getIdleName())
				arg0_43:setEffectVisible(var2_43, true)

				if var4_43 and var4_43 ~= "" then
					arg0_43:PlayCv(var4_43)
				end
			end, false, function()
				if var3_43 and var3_43 ~= "" then
					arg0_43:PlayCv(var3_43)
				end

				if var14_43 and type(var14_43) == "string" and arg0_43._eventTriggerCall then
					arg0_43._eventTriggerCall(var14_43)
				end
			end)
		end

		if not var13_43 or var13_43 == "" then
			if var12_43 and var12_43 ~= "" then
				arg0_43:changeSkeletonSkin(var12_43)
			end

			if var15_43 and var15_43 ~= "" then
				arg0_43:changePaintingIdle(var15_43)
			end

			if var14_43 and type(var14_43) == "string" and arg0_43._eventTriggerCall then
				arg0_43._eventTriggerCall(var14_43)
			end

			return false
		end
	end

	return true
end

function var0_0.SetAlphaData(arg0_48, arg1_48)
	for iter0_48, iter1_48 in ipairs(arg1_48) do
		local var0_48 = iter1_48[1]
		local var1_48 = iter1_48[2]
		local var2_48 = iter1_48[3]
		local var3_48 = arg0_48:getSlotAlpha(var0_48)

		if not arg0_48:getStepSlotAlpha(var0_48) and var3_48 then
			local var4_48
			local var5_48

			for iter2_48, iter3_48 in ipairs(var1_48) do
				if math.abs(var3_48 - iter3_48) <= 0.1 then
					var5_48 = iter2_48 + 1
				end

				if var5_48 == iter2_48 then
					var4_48 = iter3_48
				end
			end

			var4_48 = var4_48 or var1_48[1]

			if var4_48 then
				arg0_48:setStepSlotAlpha(var0_48, var4_48, var2_48)
			end
		end
	end
end

function var0_0.PlayCv(arg0_49, arg1_49)
	local var0_49 = arg0_49._spinePaintingData.ship:getSkinId()
	local var1_49 = pg.CriMgr.GetCVBankName(ShipWordHelper.RawGetCVKey(var0_49))
	local var2_49 = pg.ship_skin_template[var0_49].group_index
	local var3_49 = arg1_49 .. "_" .. var2_49

	print("try playing cv" .. var1_49 .. ":" .. var3_49)
	pg.CriMgr.GetInstance():playCueSheetVoice(var1_49, var3_49, true, function(arg0_50)
		if arg0_50 then
			print("播放的语音长度为 = " .. arg0_50:GetLength())
		end
	end)
end

function var0_0.changeSkeletonSkin(arg0_51, arg1_51)
	if arg0_51._skeletonSkin == arg1_51 then
		arg0_51:SetDefaultSkeletonSkin()
	else
		arg0_51:SetSkeletonSkin(arg1_51)
	end

	SpinePaintingDrag.SetPaintingInitSkin(arg0_51.mainSpineAnim.name, arg0_51._spinePaintingData.ship.id, arg0_51._skeletonSkin)
end

function var0_0.setEffectVisible(arg0_52, arg1_52, arg2_52)
	if not arg1_52 or #arg1_52 == 0 then
		return
	end

	for iter0_52 = 1, #arg1_52 do
		local var0_52 = findTF(arg0_52._tf, arg1_52[iter0_52])

		if var0_52 then
			setActive(var0_52, arg2_52)
		end
	end
end

function var0_0.matchDragFlag(arg0_53, arg1_53, arg2_53, arg3_53)
	local var0_53 = arg2_53.hit

	if var0_53 and var0_53 ~= arg1_53 then
		return false
	end

	local var1_53 = arg2_53.skin

	if var1_53 and var1_53 ~= "" and arg0_53._skeletonSkin ~= var1_53 then
		return false
	end

	local var2_53 = arg2_53.idle

	if var2_53 and type(var2_53) == "string" and arg0_53:getIdleName() ~= var2_53 then
		return false
	elseif var2_53 and type(var2_53) == "table" and not table.contains(var2_53, arg0_53:getIdleName()) then
		return false
	end

	local var3_53 = arg2_53.favor

	if var3_53 and var3_53 >= 0 then
		local var4_53 = arg0_53._spinePaintingData.ship:getCVIntimacy()

		if var4_53 and var4_53 < var3_53 then
			return false
		end
	end

	if arg2_53.click and arg2_53.click == tobool(arg3_53) then
		return false
	end

	return true
end

function var0_0.OnDragMove(arg0_54, arg1_54, arg2_54)
	return
end

function var0_0.getSpineMaterial(arg0_55, arg1_55, arg2_55)
	if not arg0_55._materialDic then
		arg0_55._materialDic = {}
	end

	if arg0_55._materialDic[arg1_55] then
		arg2_55(arg0_55._materialDic[arg1_55])
	else
		arg0_55._materialDic[arg1_55] = LoadAny("spinematerials", arg1_55, typeof(Material))

		arg2_55(arg0_55._materialDic[arg1_55])
	end
end

function var0_0.changePaintingIdle(arg0_56, arg1_56)
	arg0_56:setIdleName(arg1_56)
	arg0_56:SetAction(arg1_56, 0, true)
	SpinePaintingDrag.SetPaintingInitIdle(arg0_56.mainSpineAnim.name, arg0_56._spinePaintingData.ship.id, arg1_56)
	arg0_56:changeInAction(false)
end

function var0_0.SetShopHx(arg0_57, arg1_57)
	if arg1_57 and HXSet.isHx() then
		if arg0_57:getAnimationExist("shop_hx", arg0_57._skeletonGraphic) then
			arg0_57:setIdleName("shop_hx")
			arg0_57:SetAction(arg0_57._idleName, 0, true)

			local var0_57 = arg0_57._tf.anchoredPosition

			arg0_57._tf.anchoredPosition = Vector2(100000, 0)

			arg0_57:updateSkeletonGraphicTime()
			onDelayTick(function()
				arg0_57._tf.anchoredPosition = var0_57
			end, 0.05)
		end
	else
		arg0_57:setIdleName(arg0_57:getNormalIdleName())
		arg0_57:SetAction(arg0_57._idleName, 0, true)
	end
end

function var0_0.SetAction(arg0_59, arg1_59, arg2_59, arg3_59)
	if not arg0_59:checkActionPlayAble(arg1_59, arg3_59, arg2_59) then
		return false
	end

	if arg2_59 and arg2_59 == 0 then
		arg0_59.lastPlayAction = arg1_59
	end

	if arg2_59 == 0 and arg1_59 ~= arg0_59:getIdleName() then
		arg0_59:changeInAction(true)
	end

	if arg0_59.multipleFaceFlag and not arg0_59.inAction then
		arg1_59 = arg0_59:getMultipFaceAction(arg1_59)
	end

	local var0_59 = arg0_59._spinePaintingData.ship:getSkinId()
	local var1_59 = pg.ship_skin_template[var0_59].voice_lang

	if arg2_59 == 0 and var1_59 and #var1_59 > 0 then
		local var2_59 = ShipWordHelper.GetLanguageSetting(var0_59)

		if var2_59 <= 0 then
			var2_59 = 1
		end

		local var3_59 = var1_59[var2_59]
		local var4_59 = arg0_59:GetVoiceLandAction(arg1_59, var3_59)

		if arg0_59:getAnimationExist(var4_59, arg0_59._skeletonGraphic) then
			arg1_59 = var4_59
		end
	end

	arg0_59:updateEffectVisible(arg1_59)

	if HXSet.isHx() and arg0_59:getAnimationExist(arg1_59 .. "_hx") then
		arg1_59 = arg1_59 .. "_hx"
	elseif HXSet.isHx() and arg0_59:getAnimationExist("hx/" .. arg1_59 .. "_hx") then
		arg1_59 = "hx/" .. arg1_59 .. "_hx"
	end

	for iter0_59, iter1_59 in ipairs(arg0_59.spineAnimList) do
		local var5_59 = iter1_59:GetComponent("SkeletonGraphic")

		if arg0_59:getAnimationExist(arg1_59, var5_59) then
			iter1_59:SetAction(arg1_59, arg2_59)
		end

		if iter1_59:GetAnimationState() then
			GetComponent(iter1_59.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end

	return true
end

function var0_0.GetVoiceLandAction(arg0_60, arg1_60, arg2_60)
	local var0_60 = ""

	if arg2_60 == ShipSkin.VOICE_LANG_JP then
		var0_60 = "_jp"
	elseif arg2_60 == ShipSkin.VOICE_LANG_CN then
		var0_60 = "_cn"
	end

	return arg1_60 .. var0_60
end

function var0_0.checkActionPlayAble(arg0_61, arg1_61, arg2_61, arg3_61)
	if arg3_61 and arg3_61 == 0 and arg0_61.inAction and not arg2_61 then
		return false
	end

	if arg0_61.lockLayer and not arg2_61 and arg0_61.inAction and arg3_61 and arg3_61 > 0 then
		return false
	end

	if arg0_61.lastPlayAction and arg0_61.lastPlayAction ~= arg0_61._idleName and arg3_61 and arg3_61 > 0 then
		return false
	end

	if arg0_61._idleName ~= arg0_61:getNormalIdleName() and arg1_61 == "login" then
		return false
	end

	if not arg0_61._dragPassFlag then
		return false
	end

	if arg0_61.dragShipFlag and arg0_61.shipDragData.action_enable then
		local var0_61 = arg0_61.shipDragData.action_enable

		for iter0_61 = 1, #var0_61 do
			local var1_61 = var0_61[iter0_61]

			if var1_61.name == arg0_61._idleName and table.contains(var1_61.ignore, arg1_61) then
				return false
			end
		end
	end

	return true
end

function var0_0.ClearAction(arg0_62)
	arg0_62:changeInAction(false)
end

function var0_0.getSlotAlpha(arg0_63, arg1_63)
	local var0_63 = arg0_63._skeletonGraphic.Skeleton:FindSlot(arg1_63)

	if var0_63 then
		return ReflectionHelp.RefGetProperty(typeof("Spine.Slot"), "A", var0_63)
	end

	return nil
end

function var0_0.setSlotAlpha(arg0_64, arg1_64, arg2_64)
	ReflectionHelp.RefSetProperty(typeof("Spine.Slot"), "A", arg1_64, arg2_64)
end

function var0_0.setStepSlotAlpha(arg0_65, arg1_65, arg2_65, arg3_65)
	if not arg0_65.slotDic[arg1_65] then
		arg0_65.slotDic[arg1_65] = arg0_65._skeletonGraphic.Skeleton:FindSlot(arg1_65)
	end

	if arg0_65.slotDic[arg1_65] then
		if not arg3_65 or arg3_65 <= 0 then
			print("设置插槽 " .. arg1_65 .. " alpha = " .. arg2_65)
			arg0_65:setSlotAlpha(arg0_65.slotDic[arg1_65], arg2_65)
		else
			local var0_65 = arg0_65:getSlotAlpha(arg1_65)

			table.insert(arg0_65.stepSlotAlpha, {
				smooth = 0,
				name = arg1_65,
				slot = arg0_65.slotDic[arg1_65],
				current = var0_65,
				target = arg2_65,
				time = arg3_65
			})
		end
	end
end

function var0_0.getStepSlotAlpha(arg0_66, arg1_66)
	for iter0_66, iter1_66 in ipairs(arg0_66.stepSlotAlpha) do
		if iter1_66.name == arg1_66 then
			return iter1_66
		end
	end

	return nil
end

function var0_0.updateSlotAlpha(arg0_67)
	for iter0_67 = #arg0_67.stepSlotAlpha, 1, -1 do
		local var0_67 = arg0_67.stepSlotAlpha[iter0_67]

		var0_67.current, var0_67.smooth = Mathf.SmoothDamp(var0_67.current, var0_67.target, var0_67.smooth, var0_67.time)

		if math.abs(var0_67.target - var0_67.current) <= 0.02 then
			print("设置插槽 " .. var0_67.name .. " alpha = " .. var0_67.target)
			arg0_67:setSlotAlpha(var0_67.slot, var0_67.target)

			table.remove(arg0_67.stepSlotAlpha, iter0_67).slot = nil
		else
			print("设置插槽 " .. var0_67.name .. " alpha = " .. var0_67.current)
			arg0_67:setSlotAlpha(var0_67.slot, var0_67.current)
		end
	end
end

function var0_0.updateLight(arg0_68)
	if arg0_68._lightAnimator and arg0_68._lightAnimationName and (not arg0_68._lightValue or math.abs(arg0_68._lightValue - SpinePaintingConst.painting_lit_value) > 0.001) then
		arg0_68._lightAnimator:Play(arg0_68._lightAnimationName, -1, SpinePaintingConst.painting_lit_value)

		arg0_68._lightValue = SpinePaintingConst.painting_lit_value
	end

	arg0_68._paintingLitOpening = SpinePaintingConst.painting_lit_opening

	if arg0_68._paintingLitOpening and arg0_68.dragDataConfigClient and #arg0_68.dragDataConfigClient > 0 and not arg0_68:isInAction() then
		for iter0_68, iter1_68 in ipairs(arg0_68.dragDataConfigClient) do
			if iter1_68.lit and #iter1_68.lit > 0 and SpinePaintingConst.painting_lit_value >= iter1_68.lit[1] and SpinePaintingConst.painting_lit_value <= iter1_68.lit[2] then
				local var0_68 = arg0_68:startDragAction(iter1_68.hit, not iter1_68.click)
			end
		end
	end
end

function var0_0.updateEffectVisible(arg0_69, arg1_69)
	if not arg0_69._effectsTf then
		return
	end

	if isActive(arg0_69._effectsTf) ~= arg0_69._effectShowFlag then
		setActive(arg0_69._effectsTf, arg0_69._effectShowFlag)
	end

	if arg0_69.shipEffectActionAble then
		if table.contains(arg0_69.shipEffectActionAble, arg1_69) then
			if arg0_69._effectsTf and isActive(arg0_69._effectsTf) then
				setActive(arg0_69._effectsTf, false)
			end

			if arg0_69._lightEffects and isActive(arg0_69._lightEffects) then
				setActive(arg0_69._lightEffects, false)
			end
		else
			if arg0_69._effectsTf and not isActive(arg0_69._effectsTf) then
				setActive(arg0_69._effectsTf, true)
			end

			if arg0_69._lightEffects and not isActive(arg0_69._lightEffects) then
				setActive(arg0_69._lightEffects, true)
			end
		end
	end
end

function var0_0.isInAction(arg0_70)
	return arg0_70.inAction
end

function var0_0.SetActionWithFinishCallback(arg0_71, arg1_71, arg2_71, arg3_71, arg4_71, arg5_71)
	if not arg0_71:checkActionPlayAble(arg1_71, arg4_71, arg2_71) then
		return
	end

	if arg0_71.mainSpineAnim then
		arg0_71.mainSpineAnim:SetActionCallBack(nil)
		arg0_71.mainSpineAnim:SetActionCallBack(function(arg0_72)
			if arg0_72 == "finish" and arg3_71 then
				arg0_71:changeInAction(false)
				arg3_71()

				arg3_71 = nil
			elseif arg0_72 == "action" and arg5_71 then
				arg5_71()

				arg5_71 = nil
			elseif string.match(arg0_72, "^bgm_") or string.match(arg0_72, "^bgmsingle_") then
				if arg0_71._visible then
					local var0_72 = string.match(arg0_72, "^bgm_(.*)$") or string.match(arg0_72, "^bgmsingle_(.*)$")
					local var1_72 = string.split(var0_72, "_")
					local var2_72 = string.match(arg0_72, "^bgm_(.*)$") and true or false
					local var3_72 = "se-skin"
					local var4_72 = var1_72[1] .. "_" .. var1_72[2]
					local var5_72 = var1_72[3] and tonumber(var1_72[3]) or 1

					pg.CriMgr.GetInstance():PlayPaintingBgm(var3_72, var4_72, var2_72, var5_72, Live2dConst.GetPaintingBgmVolume(arg0_71._spinePaintingData.ship:getSkinId()))
				end
			elseif string.match(arg0_72, "^effect_") then
				if string.match(arg0_72, "^effect_on") then
					arg0_71._effectShowFlag = false
				elseif string.match(arg0_72, "^effect_off") then
					arg0_71._effectShowFlag = true
				end

				arg0_71:updateEffectVisible(arg1_71)
				print("change effect " .. tostring(arg0_71._effectShowFlag))
			elseif string.match(arg0_72, "^drag_") then
				if string.match(arg0_72, "^drag_on") then
					arg0_71._dragPassFlag = false
				elseif string.match(arg0_72, "^drag_off") then
					arg0_71._dragPassFlag = true
				end

				print("change drag pass " .. tostring(arg0_71._dragPassFlag))
			end
		end)
	end

	arg0_71:SetAction(arg1_71, arg2_71, arg4_71)
end

function var0_0.SetOnceAction(arg0_73, arg1_73, arg2_73, arg3_73, arg4_73)
	if not arg0_73:checkActionPlayAble(arg1_73, arg4_73, 0) then
		return
	end

	arg0_73:SetActionWithFinishCallback(arg1_73, 0, function()
		arg0_73:SetAction(arg0_73:getIdleName(), 0)

		if arg2_73 then
			arg2_73()

			arg2_73 = nil
		end
	end, arg4_73, function()
		if arg3_73 then
			arg3_73()

			arg3_73 = nil
		end
	end)
end

function var0_0.pullInitCallback(arg0_76, arg1_76)
	table.insert(arg0_76._initCallback, arg1_76)
end

function var0_0.getAnimationExist(arg0_77, arg1_77, arg2_77)
	local var0_77

	arg2_77 = arg2_77 or arg0_77._skeletonGraphic

	if arg2_77 then
		var0_77 = arg2_77.Skeleton.Data:FindAnimation(arg1_77)
	end

	return var0_77
end

function var0_0.SetEmptyAction(arg0_78, arg1_78)
	if not arg0_78.spineAnimList then
		return
	end

	for iter0_78, iter1_78 in ipairs(arg0_78.spineAnimList) do
		local var0_78 = iter1_78:GetAnimationState()

		if var0_78 then
			var0_78:SetEmptyAnimation(arg1_78, 0)
			GetComponent(iter1_78.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.GetSpineTransform(arg0_79)
	return arg0_79._tf
end

function var0_0.SetSkin(arg0_80, arg1_80)
	if arg0_80._skeletonGraphic and arg0_80._skeletonGraphic.SkeletonData and arg0_80._skeletonGraphic.SkeletonData:FindSkin(arg1_80) ~= nil then
		arg0_80._skeletonGraphic.Skeleton:SetSkin(arg1_80)
		arg0_80._skeletonGraphic.Skeleton:SetSlotsToSetupPose()
	end
end

function var0_0.updateSkeletonGraphicTime(arg0_81)
	if arg0_81._skeletonGraphic then
		arg0_81._skeletonGraphic:Update(Time.deltaTime)
	end
end

function var0_0.getMultipFaceAction(arg0_82, arg1_82)
	if arg0_82.multipleFaceFlag then
		local var0_82 = tonumber(arg1_82)

		if var0_82 and var0_82 >= 0 then
			for iter0_82, iter1_82 in ipairs(arg0_82.multipleFaceData) do
				if iter1_82[1] == arg0_82:getIdleName() then
					return tostring(var0_82 + iter1_82[2])
				end
			end
		end
	end

	return arg1_82
end

function var0_0.unloadCueSheet(arg0_83)
	if not arg0_83.loadSheets then
		return
	end

	for iter0_83, iter1_83 in ipairs(arg0_83.loadSheets) do
		pg.CriMgr.GetInstance():UnloadCueSheet(iter1_83)
	end

	arg0_83.loadSheets = {}
end

function var0_0.Dispose(arg0_84)
	arg0_84._isDisposed = true

	arg0_84:changeInAction(false)

	arg0_84._materialDic = {}

	if arg0_84.updateLocal then
		arg0_84._skeletonGraphic.UpdateLocal = arg0_84._skeletonGraphic.UpdateLocal - arg0_84.updateLocal
		arg0_84.updateLocal = nil
	end

	if arg0_84._spinePaintingData then
		arg0_84._spinePaintingData:Clear()
	end

	for iter0_84, iter1_84 in pairs(arg0_84._loadSpineDic) do
		PoolMgr.GetInstance():ReturnSpinePainting(iter0_84, iter1_84)
	end

	for iter2_84, iter3_84 in pairs(arg0_84._loadUIDic) do
		PoolMgr.GetInstance():ReturnUI(iter2_84, iter3_84)
	end

	arg0_84._loadSpineDic = {}
	arg0_84._loadUIDic = {}

	arg0_84:unloadCueSheet()

	if arg0_84._go ~= nil then
		var1_0.Destroy(arg0_84._go)
	end

	if arg0_84._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_84._bgEffectGo)
	end

	arg0_84._go = nil
	arg0_84._tf = nil
	arg0_84._bgEffectGo = nil
	arg0_84._bgEffectTf = nil

	if arg0_84.spineAnim then
		arg0_84.spineAnim:SetActionCallBack(nil)
	end

	if arg0_84._slotAlphaTimer then
		arg0_84._slotAlphaTimer:Stop()

		arg0_84._slotAlphaTimer = nil
	end

	if arg0_84.stepSlotAlpha and #arg0_84.stepSlotAlpha > 0 then
		for iter4_84, iter5_84 in ipairs(arg0_84.stepSlotAlpha) do
			iter5_84.slot = nil
		end

		arg0_84.stepSlotAlpha = {}
	end
end

function var0_0.getPaintingName(arg0_85)
	return arg0_85._spinePaintingData:GetShipName()
end

return var0_0
