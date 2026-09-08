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

function var0_0.Ctor(arg0_7, arg1_7, arg2_7)
	arg0_7._spinePaintingData = arg1_7
	arg0_7._loadSpineDic = {}
	arg0_7._loadUIDic = {}
	arg0_7._initCallback = {}
	arg0_7.loadSheets = {}
	arg0_7._visible = true

	parallelAsync({
		function(arg0_8)
			local var0_8 = arg0_7._spinePaintingData:GetShipName()

			PoolMgr.GetInstance():GetSpinePainting(var0_8, true, function(arg0_9)
				arg0_7._loadSpineDic[var0_8] = arg0_9

				arg0_7:init(arg0_9)
				arg0_8()
			end)
		end,
		function(arg0_10)
			local var0_10 = arg0_7._spinePaintingData.bgEffectName

			if var0_10 ~= nil then
				PoolMgr.GetInstance():GetUI(var0_10, true, function(arg0_11)
					arg0_7._loadUIDic[var0_10] = arg0_11

					arg0_7:initBgEffect(arg0_11)
					arg0_10()
				end)
			else
				arg0_10()
			end
		end
	}, function()
		setActive(arg0_7._spinePaintingData.parent, true)
		setActive(arg0_7._spinePaintingData.effectParent, true)

		arg0_7._initFlag = true

		arg0_7:updateLink()

		for iter0_12, iter1_12 in ipairs(arg0_7._initCallback) do
			iter1_12()
		end

		arg0_7._initCallback = {}

		if arg2_7 then
			arg2_7(arg0_7)
		end
	end)
end

function var0_0.init(arg0_13, arg1_13)
	arg0_13._go = arg1_13
	arg0_13._tf = tf(arg1_13)

	HotfixHelper.SetLayerRecursively(arg0_13._go, LayerMask.NameToLayer("UI"))
	arg0_13._tf:SetParent(arg0_13._spinePaintingData.parent, true)

	arg0_13._tf.localScale = arg0_13._spinePaintingData.scale
	arg0_13._tf.localPosition = arg0_13._spinePaintingData.pos
	arg0_13.spineAnimList = {}

	local var0_13 = arg0_13._tf:GetComponent(typeof(ItemList)).prefabItem:ToTable()

	for iter0_13, iter1_13 in ipairs(var0_13) do
		arg0_13.spineAnimList[#arg0_13.spineAnimList + 1] = GetOrAddComponent(iter1_13, "SpineAnimUI")
	end

	local var1_13 = #arg0_13.spineAnimList

	assert(var1_13 > 0, "动态立绘至少要保证有一个spine动画，请检查" .. arg0_13._spinePaintingData:GetShipName())

	if var1_13 == 1 then
		arg0_13.mainSpineAnim = arg0_13.spineAnimList[1]
	else
		arg0_13.mainSpineAnim = arg0_13.spineAnimList[#arg0_13.spineAnimList]
	end

	arg0_13._skeletonGraphic = arg0_13.mainSpineAnim:GetComponent("SkeletonGraphic")

	function arg0_13.updateLocal()
		arg0_13:onUpdateLocal()
	end

	arg0_13._skeletonGraphic.UpdateLocal = arg0_13._skeletonGraphic.UpdateLocal + arg0_13.updateLocal
	arg0_13._baseMaterial = arg0_13._skeletonGraphic.material
	arg0_13._idleName = arg0_13:getNormalIdleName()
	arg0_13.shipDragData = SpinePaintingConst.ship_drag_datas[arg0_13._spinePaintingData:GetShipName()]
	arg0_13.dragShipFlag = false
	arg0_13.lockLayer = false

	if arg0_13.shipDragData then
		arg0_13.dragShipFlag = arg0_13.shipDragData.drag_data and arg0_13.shipDragData.drag_data.type
		arg0_13.lockLayer = arg0_13.shipDragData.drag_data.lock_layer
		arg0_13.replaceWord = arg0_13.shipDragData.replace_word
	end

	arg0_13.multipleFaceFlag = false

	if arg0_13.shipDragData and arg0_13.shipDragData.multiple_face and arg0_13.shipDragData.multiple_face ~= "" then
		local var2_13 = arg0_13.shipDragData.multiple_face.name

		arg0_13.multipleFaceFlag = table.contains(var2_13, arg0_13.mainSpineAnim.name)
		arg0_13.multipleFaceData = arg0_13.shipDragData.multiple_face.data
	end

	arg0_13.shipEffectActionAble = SpinePaintingConst.ship_effect_action_able[arg0_13._spinePaintingData:GetShipName()]
	arg0_13._effectsTf = findTF(arg0_13._tf, "effects")
	arg0_13._effectShowFlag = true
	arg0_13._dragPassFlag = true
	arg0_13._lightTf = findTF(arg0_13._tf, "light")

	if arg0_13._lightTf then
		arg0_13._lightAnimator = arg0_13._lightTf:GetComponent(typeof(Animator))
		arg0_13._lightAnimationName = arg0_13._lightAnimator.runtimeAnimatorController.animationClips[0].name

		arg0_13._lightAnimator:Play(arg0_13._lightAnimationName, -1, SpinePaintingConst.painting_lit_value)

		arg0_13._lightEffectsTf = findTF(arg0_13._tf, "light/effects")
		arg0_13._lightSliderEffectsTf = findTF(arg0_13._tf, "light/slider_effects")
		arg0_13._lightSliderTf = findTF(arg0_13._tf, "light/slider")
	end

	arg0_13:playPaintingInitIdle()
	arg0_13:playPaintingInitSkin()

	arg0_13.slotDic = {}
	arg0_13.stepSlotAlpha = {}
	arg0_13._slotAlphaTimer = Timer.New(function()
		arg0_13:updateSlotAlpha()
	end, 0.0166666666666667, -1)

	arg0_13._slotAlphaTimer:Start()
	arg0_13:SetDefaultSkeletonSkin()
end

function var0_0.initBgEffect(arg0_16, arg1_16)
	arg0_16._bgEffectGo = arg1_16
	arg0_16._bgEffectTf = tf(arg1_16)

	HotfixHelper.SetLayerRecursively(arg0_16._bgEffectGo, LayerMask.NameToLayer("UI"))
	arg0_16._bgEffectTf:SetParent(arg0_16._spinePaintingData.effectParent, true)

	arg0_16._bgEffectTf.localScale = arg0_16._spinePaintingData.bgEffectScale
	arg0_16._bgEffectTf.localPosition = arg0_16._spinePaintingData.bgEffectPos
end

function var0_0.getInitFlag(arg0_17)
	return arg0_17._initFlag
end

function var0_0.getNormalIdleName(arg0_18)
	if HXSet.isHx() and arg0_18.shipDragData and arg0_18.shipDragData.hx_idle then
		return arg0_18.shipDragData.hx_idle
	end

	return "normal"
end

function var0_0.updateLink(arg0_19)
	arg0_19.slotOverride = {}

	local var0_19 = arg0_19._spinePaintingData.ship:getSkinId()
	local var1_19 = ChangeSkinLink.CHANGE_SKIN_LINK_DATA[var0_19]

	if var1_19 then
		local var2_19 = var1_19.link_id
		local var3_19 = var1_19.relations

		if var1_19.link_type == ChangeSkinLink.L2D_TYPE then
			local var4_19

			if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 then
				var4_19 = ChangeSkinLink.GetSaveL2dData(arg0_19._spinePaintingData.ship.id, var2_19)
			else
				var4_19 = ChangeSkinLink.L2D_PARAMETER_DIC[arg0_19._spinePaintingData.ship.id]
			end

			var4_19 = var4_19 or {}

			for iter0_19, iter1_19 in ipairs(var3_19) do
				local var5_19 = iter1_19.type

				if var5_19 == ChangeSkinLink.change_parameter_link_slot then
					local var6_19 = true
					local var7_19 = iter1_19.link_parameter
					local var8_19 = iter1_19.slot_list

					for iter2_19, iter3_19 in ipairs(var7_19) do
						local var9_19 = iter3_19.name
						local var10_19 = iter3_19.num

						if (var4_19[var9_19] and var4_19[var9_19] or 0) ~= var10_19 then
							var6_19 = false
						end
					end

					if var6_19 then
						for iter4_19, iter5_19 in ipairs(var8_19) do
							table.insert(arg0_19.slotOverride, iter5_19)
						end
					end
				elseif var5_19 == ChangeSkinLink.change_parameter_link_skin then
					local var11_19 = true
					local var12_19 = iter1_19.link_parameter
					local var13_19 = iter1_19.skeleton_skin

					for iter6_19, iter7_19 in ipairs(var12_19) do
						local var14_19 = iter7_19.name
						local var15_19 = iter7_19.num

						if (var4_19[var14_19] and var4_19[var14_19] or 0) ~= var15_19 then
							var11_19 = false
						end
					end

					if var11_19 then
						arg0_19:SetSkeletonSkin(var13_19)
					end
				end
			end
		end
	end
end

function var0_0.setL2dSlot(arg0_20, arg1_20, arg2_20)
	arg0_20._skeletonGraphic.Skeleton:SetAttachment(arg1_20, arg2_20)
end

function var0_0.onUpdateLocal(arg0_21)
	if arg0_21.slotOverride then
		for iter0_21, iter1_21 in ipairs(arg0_21.slotOverride) do
			arg0_21:setL2dSlot(iter1_21[1], iter1_21[2])
		end
	end
end

function var0_0.SetVisible(arg0_22, arg1_22)
	local function var0_22()
		arg0_22._visible = arg1_22

		if arg0_22._spinePaintingData.effectParent then
			setActive(arg0_22._spinePaintingData.effectParent, arg1_22)
		end

		pg.ViewUtils.SetLayer(arg0_22._tf, arg1_22 and Layer.UI or Layer.UIHidden)
		setActiveViaLayer(arg0_22._spinePaintingData.effectParent, arg1_22)

		arg0_22._lightValue = nil
		arg0_22._effectShowFlag = true
		arg0_22._dragPassFlag = true

		if arg0_22._skeletonGraphic then
			arg0_22._skeletonGraphic.timeScale = arg1_22 and 1 or 0
		end

		if not arg1_22 then
			arg0_22.mainSpineAnim:SetActionCallBack(nil)

			arg0_22.inAction = false
			arg0_22.clickActionList = {}

			if LeanTween.isTweening(go(arg0_22._tf)) then
				LeanTween.cancel(go(arg0_22._tf))
			end

			if arg0_22._baseShader then
				if arg0_22._skeletonGraphic then
					arg0_22._skeletonGraphic.material.shader = arg0_22._baseShader
				end

				arg0_22._baseShader = nil
			end

			arg0_22._displayWord = false
		else
			arg0_22._skeletonGraphic:Update(Time.deltaTime)
		end

		arg0_22:playPaintingInitIdle()
		arg0_22:playPaintingInitSkin()
		arg0_22:updateLink()

		if not arg1_22 then
			arg0_22:unloadCueSheet()
			pg.CriMgr.GetInstance():DisposePaintingBgm()
		end
	end

	onDelayTick(var0_22, 0.05)
end

function var0_0.playPaintingInitIdle(arg0_24)
	local var0_24 = SpinePaintingDrag.GetPaintingInitIdle(arg0_24.mainSpineAnim.name, arg0_24._spinePaintingData.ship.id)
	local var1_24 = arg0_24:getNormalIdleName()

	if var0_24 then
		local var2_24 = PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1)

		if var2_24 == 1 and arg0_24._idleName ~= var0_24 then
			var1_24 = var0_24
		elseif var2_24 ~= 1 and arg0_24._idleName ~= arg0_24:getNormalIdleName() then
			var1_24 = arg0_24:getNormalIdleName()
		end
	else
		var1_24 = arg0_24:getNormalIdleName()
	end

	if var1_24 then
		arg0_24:setIdleName(var1_24)
		arg0_24:SetActionWithFinishCallback(arg0_24._idleName, 0, nil, true, nil)

		arg0_24.inAction = false
	end
end

function var0_0.playPaintingInitSkin(arg0_25)
	local var0_25 = SpinePaintingDrag.GetPaintingInitSkin(arg0_25.mainSpineAnim.name, arg0_25._spinePaintingData.ship.id)
	local var1_25 = arg0_25:GetDefaultSkeletonSkin()

	if var0_25 then
		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0_25:GetDefaultSkeletonSkin() ~= var0_25 then
			var1_25 = var0_25
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0_25._skeletonSkin ~= arg0_25:GetDefaultSkeletonSkin() then
			var1_25 = arg0_25:GetDefaultSkeletonSkin()
		end
	else
		var1_25 = arg0_25:GetDefaultSkeletonSkin()
	end

	if var1_25 and arg0_25._skeletonGraphic and arg0_25._skeletonGraphic.SkeletonData then
		if arg0_25._skeletonGraphic.SkeletonData:FindSkin(var1_25) ~= nil then
			arg0_25:SetSkeletonSkin(var1_25)
		elseif arg0_25._skeletonGraphic.SkeletonData:FindSkin("default") ~= nil then
			arg0_25:SetSkeletonSkin("default")
		end
	end
end

function var0_0.getIdleName(arg0_26)
	return arg0_26._idleName
end

function var0_0.setIdleName(arg0_27, arg1_27)
	arg0_27._idleName = arg1_27

	arg0_27:updateHitArea()
end

function var0_0.getReplaceWord(arg0_28)
	if arg0_28.replaceWord and table.contains(arg0_28.replaceWord, arg0_28._idleName) then
		return true
	end

	return false
end

function var0_0.updateHitArea(arg0_29)
	if arg0_29.dragShipFlag then
		local var0_29 = arg0_29.shipDragData.drag_data.type
		local var1_29 = arg0_29.shipDragData.drag_data.config_client

		if var0_29 == SpinePaintingConst.drag_type_normal then
			for iter0_29 = 1, #var1_29 do
				local var2_29 = var1_29[iter0_29]
				local var3_29 = var2_29.hit
				local var4_29 = var2_29.active

				if var3_29 and not var4_29 then
					local var5_29 = findTF(arg0_29._tf, "hitArea/" .. var3_29)

					if var5_29 then
						local var6_29 = true
						local var7_29 = true

						if var2_29.idle and type(var2_29.idle) == "string" then
							var6_29 = var2_29.idle == arg0_29._idleName
						elseif var2_29.idle and type(var2_29.idle) == "table" then
							var6_29 = table.contains(var2_29.idle, arg0_29._idleName)
						end

						if var2_29.skin and type(var2_29.skin) == "string" then
							var7_29 = var2_29.skin == arg0_29._skeletonSkin
						elseif var2_29.skin and type(var2_29.skin) == "table" then
							var7_29 = table.contains(var2_29.skin, arg0_29._skeletonSkin)
						end

						setActive(var5_29, var6_29 and var7_29)
					else
						print("hit area " .. var3_29 .. "is not exist")
					end
				end
			end
		end
	end
end

function var0_0.checkListAction(arg0_30)
	if #arg0_30.clickActionList > 0 then
		local var0_30 = table.remove(arg0_30.clickActionList, 1)

		arg0_30:SetActionWithFinishCallback(var0_30, 0, function()
			arg0_30:checkListAction()
		end, true)
	else
		arg0_30:SetAction(arg0_30:getNormalIdleName(), 0, true)

		arg0_30.inAction = false
	end
end

function var0_0.displayWord(arg0_32, arg1_32)
	arg0_32._displayWord = arg1_32
end

function var0_0.readyDragAction(arg0_33, arg1_33, arg2_33)
	if arg0_33.inAction or arg0_33._displayWord then
		return false
	end

	if arg0_33.dragShipFlag then
		return arg0_33:startDragAction(arg1_33, arg2_33)
	end

	return false
end

function var0_0.SetSkeletonSkin(arg0_34, arg1_34)
	arg0_34._skeletonSkin = arg1_34

	arg0_34:SetSkin(arg1_34)
	arg0_34:updateSkeletonGraphicTime()
	arg0_34:updateHitArea()
end

function var0_0.SetDefaultSkeletonSkin(arg0_35)
	arg0_35:SetSkeletonSkin(arg0_35:GetDefaultSkeletonSkin())
end

function var0_0.GetDefaultSkeletonSkin(arg0_36)
	local var0_36 = arg0_36._spinePaintingData:GetShipSkinConfig().skeleton_default_skin

	if not var0_36 or var0_36 == "" then
		var0_36 = arg0_36._skeletonGraphic.SkeletonData:FindSkin("1") and "1" or "default"
	end

	return var0_36
end

function var0_0.startDragAction(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37.shipDragData.drag_data
	local var1_37 = var0_37.type

	if var1_37 == SpinePaintingConst.drag_type_normal then
		return arg0_37:changePaintingNormal(var0_37, arg1_37, arg2_37)
	elseif var1_37 == SpinePaintingConst.drag_type_list then
		arg0_37.clickActionList = Clone(var0_37.config_client)

		return arg0_37:checkListAction()
	end

	return false
end

function var0_0.GetDragDataConfig(arg0_38, arg1_38)
	if arg0_38.shipDragData then
		return arg0_38.shipDragData[arg1_38]
	end

	return nil
end

function var0_0.setEventTriggerCallback(arg0_39, arg1_39)
	arg0_39._eventTriggerCall = arg1_39
end

function var0_0.changePaintingNormal(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40 = arg1_40.config_client
	local var1_40 = arg1_40.type

	for iter0_40, iter1_40 in ipairs(var0_40) do
		if arg0_40:matchDragFlag(arg2_40, iter1_40, arg3_40) then
			return arg0_40:doDragAction(var1_40, arg1_40, iter1_40, arg3_40)
		end
	end

	return false
end

function var0_0.doDragAction(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	local var0_41 = arg3_41.fold
	local var1_41 = arg3_41.fold_chat and arg3_41.fold_chat or nil
	local var2_41 = arg3_41.effect_hide
	local var3_41 = arg3_41.action_cv
	local var4_41 = arg3_41.finish_cv
	local var5_41 = arg3_41.alpha_data and arg3_41.alpha_data or nil
	local var6_41 = arg3_41.skin_change and arg3_41.skin_change or nil
	local var7_41 = arg3_41.clear_track and arg3_41.clear_track or nil
	local var8_41 = arg3_41.idle and arg3_41.idle or nil
	local var9_41 = arg3_41.change_idle
	local var10_41 = arg3_41.action
	local var11_41 = arg3_41.event
	local var12_41 = var6_41
	local var13_41
	local var14_41
	local var15_41

	if type(var9_41) == "table" and type(var10_41) == "table" then
		local var16_41 = math.random(1, #var10_41)

		var13_41 = var10_41[var16_41]
		var15_41 = var9_41[var16_41]
	elseif type(var8_41) == "table" and type(var10_41) == "table" then
		local var17_41 = table.indexof(var8_41, arg0_41:getIdleName())

		var13_41 = var10_41[var17_41]

		if type(var9_41) == "table" then
			var15_41 = var9_41[var17_41]
		end
	end

	if not var13_41 then
		if type(var10_41) == "string" then
			var13_41 = var10_41
		elseif type(var10_41) == "table" then
			var13_41 = var10_41[math.random(1, #var10_41)]
		end
	end

	if not var15_41 then
		if type(var9_41) == "string" then
			var15_41 = var9_41
		elseif type(var9_41) == "table" then
			var15_41 = var9_41[math.random(1, #var9_41)]
		end
	end

	if not var14_41 then
		if type(var11_41) == "string" then
			var14_41 = var11_41
		elseif type(var11_41) == "table" then
			var14_41 = var11_41[math.random(1, #var11_41)]
		end
	end

	if arg1_41 == SpinePaintingConst.drag_type_normal then
		if var5_41 and #var5_41 > 0 then
			arg0_41:SetAlphaData(var5_41)
		end

		local var18_41 = arg3_41.material and arg3_41.material or nil
		local var19_41 = arg3_41.material_time and arg3_41.material_time or nil

		if var18_41 then
			if LeanTween.isTweening(go(arg0_41._tf)) then
				return false
			end

			arg0_41:getSpineMaterial(var18_41, function(arg0_42)
				arg0_41._skeletonGraphic.material = arg0_42

				if var19_41 then
					LeanTween.delayedCall(go(arg0_41._tf), var19_41, System.Action(function()
						arg0_41._skeletonGraphic.material = arg0_41._baseMaterial

						arg0_41:changePaintingIdle(var15_41)
					end))
				end
			end)
		end

		if var7_41 and #var7_41 > 0 then
			for iter0_41, iter1_41 in ipairs(var7_41) do
				arg0_41:SetEmptyAction(iter1_41)
			end
		end

		if var13_41 and var13_41 ~= "" and arg0_41:checkActionPlayAble(var13_41, false, 0) then
			print("播放动作 .." .. var13_41 .. "下一个待机动作 .. " .. var15_41)

			if var0_41 then
				pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, {
					flag = true,
					content = {
						chat = var1_41
					}
				})
			end

			arg0_41:setEffectVisible(var2_41, false)
			arg0_41:SetActionWithFinishCallback(var13_41, 0, function()
				if var12_41 and var12_41 ~= "" then
					arg0_41:changeSkeletonSkin(var12_41)
				end

				if var0_41 then
					pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, {
						flag = false,
						content = {
							chat = var1_41
						}
					})
				end

				arg0_41:changePaintingIdle(var15_41 and var15_41 or arg0_41:getIdleName())
				arg0_41:setEffectVisible(var2_41, true)

				if var4_41 and var4_41 ~= "" then
					arg0_41:PlayCv(var4_41)
				end
			end, false, function()
				if var3_41 and var3_41 ~= "" then
					arg0_41:PlayCv(var3_41)
				end

				if var14_41 and type(var14_41) == "string" and arg0_41._eventTriggerCall then
					arg0_41._eventTriggerCall(var14_41)
				end
			end)
		end

		if not var13_41 or var13_41 == "" then
			if var12_41 and var12_41 ~= "" then
				arg0_41:changeSkeletonSkin(var12_41)
			end

			if var15_41 and var15_41 ~= "" then
				arg0_41:changePaintingIdle(var15_41)
			end

			if var14_41 and type(var14_41) == "string" and arg0_41._eventTriggerCall then
				arg0_41._eventTriggerCall(var14_41)
			end

			return false
		end
	end

	return true
end

function var0_0.SetAlphaData(arg0_46, arg1_46)
	for iter0_46, iter1_46 in ipairs(arg1_46) do
		local var0_46 = iter1_46[1]
		local var1_46 = iter1_46[2]
		local var2_46 = iter1_46[3]
		local var3_46 = arg0_46:getSlotAlpha(var0_46)

		if not arg0_46:getStepSlotAlpha(var0_46) and var3_46 then
			local var4_46
			local var5_46

			for iter2_46, iter3_46 in ipairs(var1_46) do
				if math.abs(var3_46 - iter3_46) <= 0.1 then
					var5_46 = iter2_46 + 1
				end

				if var5_46 == iter2_46 then
					var4_46 = iter3_46
				end
			end

			var4_46 = var4_46 or var1_46[1]

			if var4_46 then
				arg0_46:setStepSlotAlpha(var0_46, var4_46, var2_46)
			end
		end
	end
end

function var0_0.PlayCv(arg0_47, arg1_47)
	local var0_47 = arg0_47._spinePaintingData.ship:getSkinId()
	local var1_47 = pg.CriMgr.GetCVBankName(ShipWordHelper.RawGetCVKey(var0_47))
	local var2_47 = pg.ship_skin_template[var0_47].group_index
	local var3_47 = arg1_47 .. "_" .. var2_47

	print("try playing cv" .. var1_47 .. ":" .. var3_47)
	pg.CriMgr.GetInstance():playCueSheetVoice(var1_47, var3_47, true, function(arg0_48)
		if arg0_48 then
			print("播放的语音长度为 = " .. arg0_48:GetLength())
		end
	end)
end

function var0_0.changeSkeletonSkin(arg0_49, arg1_49)
	if arg0_49._skeletonSkin == arg1_49 then
		arg0_49:SetDefaultSkeletonSkin()
	else
		arg0_49:SetSkeletonSkin(arg1_49)
	end

	SpinePaintingDrag.SetPaintingInitSkin(arg0_49.mainSpineAnim.name, arg0_49._spinePaintingData.ship.id, arg0_49._skeletonSkin)
end

function var0_0.setEffectVisible(arg0_50, arg1_50, arg2_50)
	if not arg1_50 or #arg1_50 == 0 then
		return
	end

	for iter0_50 = 1, #arg1_50 do
		local var0_50 = findTF(arg0_50._tf, arg1_50[iter0_50])

		if var0_50 then
			setActive(var0_50, arg2_50)
		end
	end
end

function var0_0.matchDragFlag(arg0_51, arg1_51, arg2_51, arg3_51)
	local var0_51 = arg2_51.hit

	if var0_51 and var0_51 ~= arg1_51 then
		return false
	end

	local var1_51 = arg2_51.skin

	if var1_51 and var1_51 ~= "" and arg0_51._skeletonSkin ~= var1_51 then
		return false
	end

	local var2_51 = arg2_51.idle

	if var2_51 and type(var2_51) == "string" and arg0_51:getIdleName() ~= var2_51 then
		return false
	elseif var2_51 and type(var2_51) == "table" and not table.contains(var2_51, arg0_51:getIdleName()) then
		return false
	end

	local var3_51 = arg2_51.favor

	if var3_51 and var3_51 >= 0 then
		local var4_51 = arg0_51._spinePaintingData.ship:getCVIntimacy()

		if var4_51 and var4_51 < var3_51 then
			return false
		end
	end

	if arg2_51.click and arg2_51.click == tobool(arg3_51) then
		return false
	end

	return true
end

function var0_0.OnDragMove(arg0_52, arg1_52, arg2_52)
	return
end

function var0_0.getSpineMaterial(arg0_53, arg1_53, arg2_53)
	if not arg0_53._materialDic then
		arg0_53._materialDic = {}
	end

	if arg0_53._materialDic[arg1_53] then
		arg2_53(arg0_53._materialDic[arg1_53])
	else
		arg0_53._materialDic[arg1_53] = LoadAny("spinematerials", arg1_53, typeof(Material))

		arg2_53(arg0_53._materialDic[arg1_53])
	end
end

function var0_0.changePaintingIdle(arg0_54, arg1_54)
	arg0_54:setIdleName(arg1_54)
	arg0_54:SetAction(arg1_54, 0, true)
	SpinePaintingDrag.SetPaintingInitIdle(arg0_54.mainSpineAnim.name, arg0_54._spinePaintingData.ship.id, arg1_54)

	arg0_54.inAction = false
end

function var0_0.SetShopHx(arg0_55, arg1_55)
	if arg1_55 and HXSet.isHx() then
		if arg0_55:getAnimationExist("shop_hx", arg0_55._skeletonGraphic) then
			arg0_55:setIdleName("shop_hx")
			arg0_55:SetAction(arg0_55._idleName, 0, true)

			local var0_55 = arg0_55._tf.anchoredPosition

			arg0_55._tf.anchoredPosition = Vector2(100000, 0)

			arg0_55:updateSkeletonGraphicTime()
			onDelayTick(function()
				arg0_55._tf.anchoredPosition = var0_55
			end, 0.05)
		end
	else
		arg0_55:setIdleName(arg0_55:getNormalIdleName())
		arg0_55:SetAction(arg0_55._idleName, 0, true)
	end
end

function var0_0.SetAction(arg0_57, arg1_57, arg2_57, arg3_57)
	if not arg0_57:checkActionPlayAble(arg1_57, arg3_57, arg2_57) then
		return false
	end

	if arg2_57 and arg2_57 == 0 then
		arg0_57.lastPlayAction = arg1_57
	end

	if arg2_57 == 0 and arg1_57 ~= arg0_57:getIdleName() then
		arg0_57.inAction = true
	end

	if arg0_57.multipleFaceFlag and not arg0_57.inAction then
		arg1_57 = arg0_57:getMultipFaceAction(arg1_57)
	end

	local var0_57 = arg0_57._spinePaintingData.ship:getSkinId()
	local var1_57 = pg.ship_skin_template[var0_57].voice_lang

	if arg2_57 == 0 and var1_57 and #var1_57 > 0 then
		local var2_57 = ShipWordHelper.GetLanguageSetting(var0_57)

		if var2_57 <= 0 then
			var2_57 = 1
		end

		local var3_57 = var1_57[var2_57]
		local var4_57 = arg0_57:GetVoiceLandAction(arg1_57, var3_57)

		if arg0_57:getAnimationExist(var4_57, arg0_57._skeletonGraphic) then
			arg1_57 = var4_57
		end
	end

	arg0_57:updateEffectVisible(arg1_57)

	if HXSet.isHx() and arg0_57:getAnimationExist(arg1_57 .. "_hx") then
		arg1_57 = arg1_57 .. "_hx"
	end

	for iter0_57, iter1_57 in ipairs(arg0_57.spineAnimList) do
		local var5_57 = iter1_57:GetComponent("SkeletonGraphic")

		if arg0_57:getAnimationExist(arg1_57, var5_57) then
			iter1_57:SetAction(arg1_57, arg2_57)
		end

		if iter1_57:GetAnimationState() then
			GetComponent(iter1_57.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end

	return true
end

function var0_0.GetVoiceLandAction(arg0_58, arg1_58, arg2_58)
	local var0_58 = ""

	if arg2_58 == ShipSkin.VOICE_LANG_JP then
		var0_58 = "_jp"
	elseif arg2_58 == ShipSkin.VOICE_LANG_CN then
		var0_58 = "_cn"
	end

	return arg1_58 .. var0_58
end

function var0_0.checkActionPlayAble(arg0_59, arg1_59, arg2_59, arg3_59)
	if arg3_59 and arg3_59 == 0 and arg0_59.inAction and not arg2_59 then
		return false
	end

	if arg0_59.lockLayer and not arg2_59 and arg0_59.inAction and arg3_59 and arg3_59 > 0 then
		return false
	end

	if arg0_59.lastPlayAction and arg0_59.lastPlayAction ~= arg0_59._idleName and arg3_59 and arg3_59 > 0 then
		return false
	end

	if arg0_59._idleName ~= arg0_59:getNormalIdleName() and arg1_59 == "login" then
		return false
	end

	if not arg0_59._dragPassFlag then
		return false
	end

	if arg0_59.dragShipFlag and arg0_59.shipDragData.action_enable then
		local var0_59 = arg0_59.shipDragData.action_enable

		for iter0_59 = 1, #var0_59 do
			local var1_59 = var0_59[iter0_59]

			if var1_59.name == arg0_59._idleName and table.contains(var1_59.ignore, arg1_59) then
				return false
			end
		end
	end

	return true
end

function var0_0.ClearAction(arg0_60)
	arg0_60.inAction = false
end

function var0_0.getSlotAlpha(arg0_61, arg1_61)
	local var0_61 = arg0_61._skeletonGraphic.Skeleton:FindSlot(arg1_61)

	if var0_61 then
		return ReflectionHelp.RefGetProperty(typeof("Spine.Slot"), "A", var0_61)
	end

	return nil
end

function var0_0.setSlotAlpha(arg0_62, arg1_62, arg2_62)
	ReflectionHelp.RefSetProperty(typeof("Spine.Slot"), "A", arg1_62, arg2_62)
end

function var0_0.setStepSlotAlpha(arg0_63, arg1_63, arg2_63, arg3_63)
	if not arg0_63.slotDic[arg1_63] then
		arg0_63.slotDic[arg1_63] = arg0_63._skeletonGraphic.Skeleton:FindSlot(arg1_63)
	end

	if arg0_63.slotDic[arg1_63] then
		if not arg3_63 or arg3_63 <= 0 then
			print("设置插槽 " .. arg1_63 .. " alpha = " .. arg2_63)
			arg0_63:setSlotAlpha(arg0_63.slotDic[arg1_63], arg2_63)
		else
			local var0_63 = arg0_63:getSlotAlpha(arg1_63)

			table.insert(arg0_63.stepSlotAlpha, {
				smooth = 0,
				name = arg1_63,
				slot = arg0_63.slotDic[arg1_63],
				current = var0_63,
				target = arg2_63,
				time = arg3_63
			})
		end
	end
end

function var0_0.getStepSlotAlpha(arg0_64, arg1_64)
	for iter0_64, iter1_64 in ipairs(arg0_64.stepSlotAlpha) do
		if iter1_64.name == arg1_64 then
			return iter1_64
		end
	end

	return nil
end

function var0_0.updateSlotAlpha(arg0_65)
	for iter0_65 = #arg0_65.stepSlotAlpha, 1, -1 do
		local var0_65 = arg0_65.stepSlotAlpha[iter0_65]

		var0_65.current, var0_65.smooth = Mathf.SmoothDamp(var0_65.current, var0_65.target, var0_65.smooth, var0_65.time)

		if math.abs(var0_65.target - var0_65.current) <= 0.02 then
			print("设置插槽 " .. var0_65.name .. " alpha = " .. var0_65.target)
			arg0_65:setSlotAlpha(var0_65.slot, var0_65.target)

			table.remove(arg0_65.stepSlotAlpha, iter0_65).slot = nil
		else
			print("设置插槽 " .. var0_65.name .. " alpha = " .. var0_65.current)
			arg0_65:setSlotAlpha(var0_65.slot, var0_65.current)
		end
	end
end

function var0_0.updateLight(arg0_66)
	if arg0_66._lightAnimator and arg0_66._lightAnimationName and (not arg0_66._lightValue or math.abs(arg0_66._lightValue - SpinePaintingConst.painting_lit_value) > 0.001) then
		arg0_66._lightAnimator:Play(arg0_66._lightAnimationName, -1, SpinePaintingConst.painting_lit_value)

		arg0_66._lightValue = SpinePaintingConst.painting_lit_value
	end

	arg0_66._litSettingFlag = SpinePaintingConst.painting_lit_setting

	if arg0_66._lightEffectsTf and isActive(arg0_66._lightEffectsTf) ~= arg0_66._effectShowFlag then
		setActive(arg0_66._lightEffectsTf, arg0_66._effectShowFlag)
	end

	if arg0_66._lightSliderTf and isActive(arg0_66._lightSliderTf) ~= arg0_66._litSettingFlag then
		setActive(arg0_66._lightSliderTf, arg0_66._litSettingFlag)
	end

	if arg0_66._lightSliderEffectsTf then
		local var0_66 = arg0_66._effectShowFlag and arg0_66._litSettingFlag

		if isActive(arg0_66._lightSliderEffectsTf) ~= var0_66 then
			setActive(arg0_66._lightSliderEffectsTf, var0_66)
		end
	end
end

function var0_0.updateEffectVisible(arg0_67, arg1_67)
	if not arg0_67._effectsTf then
		return
	end

	if isActive(arg0_67._effectsTf) ~= arg0_67._effectShowFlag then
		setActive(arg0_67._effectsTf, arg0_67._effectShowFlag)
	end

	if arg0_67.shipEffectActionAble then
		if table.contains(arg0_67.shipEffectActionAble, arg1_67) then
			if arg0_67._effectsTf and isActive(arg0_67._effectsTf) then
				setActive(arg0_67._effectsTf, false)
			end
		elseif arg0_67._effectsTf and not isActive(arg0_67._effectsTf) then
			setActive(arg0_67._effectsTf, true)
		end
	end
end

function var0_0.isInAction(arg0_68)
	return arg0_68.inAction
end

function var0_0.SetActionWithFinishCallback(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69, arg5_69)
	if not arg0_69:checkActionPlayAble(arg1_69, arg4_69, arg2_69) then
		return
	end

	if arg0_69.mainSpineAnim then
		arg0_69.mainSpineAnim:SetActionCallBack(nil)
		arg0_69.mainSpineAnim:SetActionCallBack(function(arg0_70)
			if arg0_70 == "finish" and arg3_69 then
				arg0_69.inAction = false

				arg3_69()

				arg3_69 = nil
			elseif arg0_70 == "action" and arg5_69 then
				arg5_69()

				arg5_69 = nil
			elseif string.match(arg0_70, "^bgm_") or string.match(arg0_70, "^bgmsingle_") then
				if arg0_69._visible then
					local var0_70 = string.match(arg0_70, "^bgm_(.*)$") or string.match(arg0_70, "^bgmsingle_(.*)$")
					local var1_70 = string.split(var0_70, "_")
					local var2_70 = string.match(arg0_70, "^bgm_(.*)$") and true or false
					local var3_70 = "se-skin"
					local var4_70 = var1_70[1] .. "_" .. var1_70[2]
					local var5_70 = var1_70[3] and tonumber(var1_70[3]) or 1

					pg.CriMgr.GetInstance():PlayPaintingBgm(var3_70, var4_70, var2_70, var5_70, Live2dConst.GetPaintingBgmVolume(arg0_69._spinePaintingData.ship:getSkinId()))
				end
			elseif string.match(arg0_70, "^effect_") then
				if string.match(arg0_70, "^effect_on") then
					arg0_69._effectShowFlag = false
				elseif string.match(arg0_70, "^effect_off") then
					arg0_69._effectShowFlag = true
				end

				arg0_69:updateEffectVisible(arg1_69)
				print("change effect " .. tostring(arg0_69._effectShowFlag))
			elseif string.match(arg0_70, "^drag_") then
				if string.match(arg0_70, "^drag_on") then
					arg0_69._dragPassFlag = false
				elseif string.match(arg0_70, "^drag_off") then
					arg0_69._dragPassFlag = true
				end

				print("change drag pass " .. tostring(arg0_69._dragPassFlag))
			end
		end)
	end

	arg0_69:SetAction(arg1_69, arg2_69, arg4_69)
end

function var0_0.SetOnceAction(arg0_71, arg1_71, arg2_71, arg3_71, arg4_71)
	if not arg0_71:checkActionPlayAble(arg1_71, arg4_71, 0) then
		return
	end

	arg0_71:SetActionWithFinishCallback(arg1_71, 0, function()
		arg0_71:SetAction(arg0_71:getIdleName(), 0)

		if arg2_71 then
			arg2_71()

			arg2_71 = nil
		end
	end, arg4_71, function()
		if arg3_71 then
			arg3_71()

			arg3_71 = nil
		end
	end)
end

function var0_0.pullInitCallback(arg0_74, arg1_74)
	table.insert(arg0_74._initCallback, arg1_74)
end

function var0_0.getAnimationExist(arg0_75, arg1_75, arg2_75)
	local var0_75

	arg2_75 = arg2_75 or arg0_75._skeletonGraphic

	if arg2_75 then
		var0_75 = arg2_75.Skeleton.Data:FindAnimation(arg1_75)
	end

	return var0_75
end

function var0_0.SetEmptyAction(arg0_76, arg1_76)
	if not arg0_76.spineAnimList then
		return
	end

	for iter0_76, iter1_76 in ipairs(arg0_76.spineAnimList) do
		local var0_76 = iter1_76:GetAnimationState()

		if var0_76 then
			var0_76:SetEmptyAnimation(arg1_76, 0)
			GetComponent(iter1_76.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.GetSpineTransform(arg0_77)
	return arg0_77._tf
end

function var0_0.SetSkin(arg0_78, arg1_78)
	if arg0_78._skeletonGraphic and arg0_78._skeletonGraphic.SkeletonData and arg0_78._skeletonGraphic.SkeletonData:FindSkin(arg1_78) ~= nil then
		arg0_78._skeletonGraphic.Skeleton:SetSkin(arg1_78)
		arg0_78._skeletonGraphic.Skeleton:SetSlotsToSetupPose()
	end
end

function var0_0.updateSkeletonGraphicTime(arg0_79)
	if arg0_79._skeletonGraphic then
		arg0_79._skeletonGraphic:Update(Time.deltaTime)
	end
end

function var0_0.getMultipFaceAction(arg0_80, arg1_80)
	if arg0_80.multipleFaceFlag then
		local var0_80 = tonumber(arg1_80)

		if var0_80 and var0_80 >= 0 then
			for iter0_80, iter1_80 in ipairs(arg0_80.multipleFaceData) do
				if iter1_80[1] == arg0_80:getIdleName() then
					return tostring(var0_80 + iter1_80[2])
				end
			end
		end
	end

	return arg1_80
end

function var0_0.unloadCueSheet(arg0_81)
	if not arg0_81.loadSheets then
		return
	end

	for iter0_81, iter1_81 in ipairs(arg0_81.loadSheets) do
		pg.CriMgr.GetInstance():UnloadCueSheet(iter1_81)
	end

	arg0_81.loadSheets = {}
end

function var0_0.Dispose(arg0_82)
	arg0_82._materialDic = {}

	if arg0_82.updateLocal then
		arg0_82._skeletonGraphic.UpdateLocal = arg0_82._skeletonGraphic.UpdateLocal - arg0_82.updateLocal
		arg0_82.updateLocal = nil
	end

	if arg0_82._spinePaintingData then
		arg0_82._spinePaintingData:Clear()
	end

	for iter0_82, iter1_82 in pairs(arg0_82._loadSpineDic) do
		PoolMgr.GetInstance():ReturnSpinePainting(iter0_82, iter1_82)
	end

	for iter2_82, iter3_82 in pairs(arg0_82._loadUIDic) do
		PoolMgr.GetInstance():ReturnUI(iter2_82, iter3_82)
	end

	arg0_82._loadSpineDic = {}
	arg0_82._loadUIDic = {}

	arg0_82:unloadCueSheet()

	if arg0_82._go ~= nil then
		var1_0.Destroy(arg0_82._go)
	end

	if arg0_82._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_82._bgEffectGo)
	end

	arg0_82._go = nil
	arg0_82._tf = nil
	arg0_82._bgEffectGo = nil
	arg0_82._bgEffectTf = nil

	if arg0_82.spineAnim then
		arg0_82.spineAnim:SetActionCallBack(nil)
	end

	if arg0_82._slotAlphaTimer then
		arg0_82._slotAlphaTimer:Stop()

		arg0_82._slotAlphaTimer = nil
	end

	if arg0_82.stepSlotAlpha and #arg0_82.stepSlotAlpha > 0 then
		for iter4_82, iter5_82 in ipairs(arg0_82._slotAlphaTimer) do
			iter5_82.slot = nil
		end

		arg0_82._slotAlphaTimer = {}
	end
end

function var0_0.getPaintingName(arg0_83)
	return arg0_83._spinePaintingData:GetShipName()
end

return var0_0
