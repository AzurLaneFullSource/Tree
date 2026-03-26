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
	arg0_7:playPaintingInitSkin()

	arg0_7.slotDic = {}
	arg0_7.stepSlotAlpha = {}
	arg0_7._slotAlphaTimer = Timer.New(function()
		arg0_7:updateSlotAlpha()
	end, 0.0333333333333333, -1)

	arg0_7._slotAlphaTimer:Start()
end

function var0_0.getNormalIdleName(arg0_10)
	return "normal"
end

local function var3_0(arg0_11, arg1_11)
	arg0_11._bgEffectGo = arg1_11
	arg0_11._bgEffectTf = tf(arg1_11)

	HotfixHelper.SetLayerRecursively(arg0_11._bgEffectGo, LayerMask.NameToLayer("UI"))
	arg0_11._bgEffectTf:SetParent(arg0_11._spinePaintingData.effectParent, true)

	arg0_11._bgEffectTf.localScale = arg0_11._spinePaintingData.bgEffectScale
	arg0_11._bgEffectTf.localPosition = arg0_11._spinePaintingData.bgEffectPos
end

function var0_0.Ctor(arg0_12, arg1_12, arg2_12)
	arg0_12._spinePaintingData = arg1_12
	arg0_12._loadSpineDic = {}
	arg0_12._loadUIDic = {}
	arg0_12._initCallback = {}

	parallelAsync({
		function(arg0_13)
			local var0_13 = arg0_12._spinePaintingData:GetShipName()
			local var1_13, var2_13 = HXSet.autoHxShift("spinepainting/", var0_13)
			local var3_13 = var1_13 .. var2_13

			PoolMgr.GetInstance():GetSpinePainting(var0_13, true, function(arg0_14)
				arg0_12._loadSpineDic[var0_13] = arg0_14

				var2_0(arg0_12, arg0_14)
				arg0_13()
			end)
		end,
		function(arg0_15)
			local var0_15 = arg0_12._spinePaintingData.bgEffectName

			if var0_15 ~= nil then
				PoolMgr.GetInstance():GetUI(var0_15, true, function(arg0_16)
					arg0_12._loadUIDic[var0_15] = arg0_16

					var3_0(arg0_12, arg0_16)
					arg0_15()
				end)
			else
				arg0_15()
			end
		end
	}, function()
		setActive(arg0_12._spinePaintingData.parent, true)
		setActive(arg0_12._spinePaintingData.effectParent, true)

		arg0_12._initFlag = true

		arg0_12:updateLink()

		for iter0_17, iter1_17 in ipairs(arg0_12._initCallback) do
			iter1_17()
		end

		arg0_12._initCallback = {}

		if arg2_12 then
			arg2_12(arg0_12)
		end
	end)
end

function var0_0.updateLink(arg0_18)
	arg0_18.slotOverride = {}

	local var0_18 = arg0_18._spinePaintingData.ship:getSkinId()
	local var1_18 = ChangeSkinLink.CHANGE_SKIN_LINK_DATA[var0_18]

	if var1_18 then
		local var2_18 = var1_18.link_id
		local var3_18 = var1_18.relations

		if var1_18.link_type == ChangeSkinLink.L2D_TYPE then
			local var4_18

			if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 then
				var4_18 = ChangeSkinLink.GetSaveL2dData(arg0_18._spinePaintingData.ship.id, var2_18)
			else
				var4_18 = ChangeSkinLink.L2D_PARAMETER_DIC[arg0_18._spinePaintingData.ship.id]
			end

			var4_18 = var4_18 or {}

			for iter0_18, iter1_18 in ipairs(var3_18) do
				local var5_18 = iter1_18.type

				if var5_18 == ChangeSkinLink.change_parameter_link_slot then
					local var6_18 = true
					local var7_18 = iter1_18.link_parameter
					local var8_18 = iter1_18.slot_list

					for iter2_18, iter3_18 in ipairs(var7_18) do
						local var9_18 = iter3_18.name
						local var10_18 = iter3_18.num

						if (var4_18[var9_18] and var4_18[var9_18] or 0) ~= var10_18 then
							var6_18 = false
						end
					end

					if var6_18 then
						for iter4_18, iter5_18 in ipairs(var8_18) do
							table.insert(arg0_18.slotOverride, iter5_18)
						end
					end
				elseif var5_18 == ChangeSkinLink.change_parameter_link_skin then
					local var11_18 = true
					local var12_18 = iter1_18.link_parameter
					local var13_18 = iter1_18.skeleton_skin

					for iter6_18, iter7_18 in ipairs(var12_18) do
						local var14_18 = iter7_18.name
						local var15_18 = iter7_18.num

						if (var4_18[var14_18] and var4_18[var14_18] or 0) ~= var15_18 then
							var11_18 = false
						end
					end

					if var11_18 then
						arg0_18:SetSkeletonSkin(var13_18)
					end
				end
			end
		end
	end
end

function var0_0.setL2dSlot(arg0_19, arg1_19, arg2_19)
	arg0_19._skeletonGraphic.Skeleton:SetAttachment(arg1_19, arg2_19)
end

function var0_0.onUpdateLocal(arg0_20)
	if arg0_20.slotOverride then
		for iter0_20, iter1_20 in ipairs(arg0_20.slotOverride) do
			arg0_20:setL2dSlot(iter1_20[1], iter1_20[2])
		end
	end
end

function var0_0.SetVisible(arg0_21, arg1_21)
	if arg0_21._spinePaintingData.effectParent then
		setActive(arg0_21._spinePaintingData.effectParent, arg1_21)
	end

	pg.ViewUtils.SetLayer(arg0_21._tf, arg1_21 and Layer.UI or Layer.UIHidden)
	setActiveViaLayer(arg0_21._spinePaintingData.effectParent, arg1_21)

	if arg0_21._skeletonGraphic then
		arg0_21._skeletonGraphic.timeScale = arg1_21 and 1 or 0
	end

	if not arg1_21 then
		arg0_21.mainSpineAnim:SetActionCallBack(nil)

		arg0_21.inAction = false
		arg0_21.clickActionList = {}

		if LeanTween.isTweening(go(arg0_21._tf)) then
			LeanTween.cancel(go(arg0_21._tf))
		end

		if arg0_21._baseShader then
			if arg0_21._skeletonGraphic then
				arg0_21._skeletonGraphic.material.shader = arg0_21._baseShader
			end

			arg0_21._baseShader = nil
		end

		arg0_21._displayWord = false
	else
		arg0_21._skeletonGraphic:Update(Time.deltaTime)
	end

	arg0_21:playPaintingInitIdle()
	arg0_21:playPaintingInitSkin()
end

function var0_0.getInitFlag(arg0_22)
	return arg0_22._initFlag
end

function var0_0.playPaintingInitIdle(arg0_23)
	local var0_23 = SpinePaintingDrag.GetPaintingInitIdle(arg0_23.mainSpineAnim.name, arg0_23._spinePaintingData.ship.id)
	local var1_23 = arg0_23:getNormalIdleName()

	if var0_23 then
		local var2_23 = PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1)

		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0_23._idleName ~= var0_23 then
			var1_23 = var0_23
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0_23._idleName ~= arg0_23:getNormalIdleName() then
			var1_23 = arg0_23:getNormalIdleName()
		end
	else
		var1_23 = arg0_23:getNormalIdleName()
	end

	if var1_23 then
		arg0_23:setIdleName(var1_23)
		arg0_23:SetAction(arg0_23._idleName, 0, true)

		arg0_23.inAction = false
	end
end

function var0_0.playPaintingInitSkin(arg0_24)
	local var0_24 = SpinePaintingDrag.GetPaintingInitSkin(arg0_24.mainSpineAnim.name, arg0_24._spinePaintingData.ship.id)
	local var1_24 = arg0_24:GetDefaultSkeletonSkin()

	if var0_24 then
		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0_24:GetDefaultSkeletonSkin() ~= var0_24 then
			var1_24 = var0_24
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0_24._skeletonSkin ~= arg0_24:GetDefaultSkeletonSkin() then
			var1_24 = arg0_24:GetDefaultSkeletonSkin()
		end
	else
		var1_24 = arg0_24:GetDefaultSkeletonSkin()
	end

	if var1_24 and arg0_24._skeletonGraphic and arg0_24._skeletonGraphic.SkeletonData and arg0_24._skeletonGraphic.SkeletonData:FindSkin(var1_24) ~= nil then
		arg0_24:SetSkeletonSkin(var1_24)
	end
end

function var0_0.getIdleName(arg0_25)
	return arg0_25._idleName
end

function var0_0.setIdleName(arg0_26, arg1_26)
	arg0_26._idleName = arg1_26

	arg0_26:updateHitArea()
end

function var0_0.getReplaceWord(arg0_27)
	if arg0_27.replaceWord and table.contains(arg0_27.replaceWord, arg0_27._idleName) then
		return true
	end

	return false
end

function var0_0.updateHitArea(arg0_28)
	if arg0_28.dragShipFlag then
		local var0_28 = arg0_28.shipDragData.drag_data.type
		local var1_28 = arg0_28.shipDragData.drag_data.config_client

		if var0_28 == SpinePaintingConst.drag_type_normal then
			for iter0_28 = 1, #var1_28 do
				local var2_28 = var1_28[iter0_28]
				local var3_28 = var2_28.hit
				local var4_28 = var2_28.active

				if var3_28 and not var4_28 then
					local var5_28 = findTF(arg0_28._tf, "hitArea/" .. var3_28)

					if var5_28 then
						setActive(var5_28, var2_28.idle == arg0_28._idleName)
					else
						print("hit area " .. var3_28 .. "is not exist")
					end
				end
			end
		end
	end
end

function var0_0.checkListAction(arg0_29)
	if #arg0_29.clickActionList > 0 then
		local var0_29 = table.remove(arg0_29.clickActionList, 1)

		arg0_29:SetActionWithFinishCallback(var0_29, 0, function()
			arg0_29:checkListAction()
		end, true)
	else
		arg0_29:SetAction(arg0_29:getNormalIdleName(), 0, true)

		arg0_29.inAction = false
	end
end

function var0_0.displayWord(arg0_31, arg1_31)
	arg0_31._displayWord = arg1_31
end

function var0_0.readyDragAction(arg0_32, arg1_32, arg2_32)
	if arg0_32.inAction or arg0_32._displayWord then
		return false
	end

	if arg0_32.dragShipFlag then
		return arg0_32:startDragAction(arg1_32, arg2_32)
	end

	return false
end

function var0_0.SetSkeletonSkin(arg0_33, arg1_33)
	arg0_33._skeletonSkin = arg1_33

	arg0_33:SetSkin(arg1_33)
	arg0_33:updateSkeletonGraphicTime()
end

function var0_0.SetDefaultSkeletonSkin(arg0_34)
	local var0_34 = arg0_34._spinePaintingData:GetShipSkinConfig().skeleton_default_skin

	if not var0_34 or var0_34 == "" then
		var0_34 = "1"
	end

	local var1_34 = arg0_34._skeletonGraphic.SkeletonData:FindSkin(var0_34)

	if var1_34 and var1_34 ~= nil then
		arg0_34:SetSkeletonSkin(var0_34)
	end
end

function var0_0.GetDefaultSkeletonSkin(arg0_35)
	local var0_35 = arg0_35._spinePaintingData:GetShipSkinConfig().skeleton_default_skin

	if not var0_35 or var0_35 == "" then
		var0_35 = "1"
	end

	return var0_35
end

function var0_0.startDragAction(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36.shipDragData.drag_data
	local var1_36 = var0_36.type

	if var1_36 == SpinePaintingConst.drag_type_normal then
		return arg0_36:changePaintingNormal(var0_36, arg1_36, arg2_36)
	elseif var1_36 == SpinePaintingConst.drag_type_list then
		arg0_36.clickActionList = Clone(var0_36.config_client)

		return arg0_36:checkListAction()
	end

	return false
end

function var0_0.GetDragDataConfig(arg0_37, arg1_37)
	if arg0_37.shipDragData then
		return arg0_37.shipDragData[arg1_37]
	end

	return nil
end

function var0_0.setEventTriggerCallback(arg0_38, arg1_38)
	arg0_38._eventTriggerCall = arg1_38
end

function var0_0.changePaintingNormal(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = arg1_39.config_client
	local var1_39 = arg1_39.type

	for iter0_39, iter1_39 in ipairs(var0_39) do
		if arg0_39:matchDragFlag(arg2_39, iter1_39, arg3_39) then
			return arg0_39:doDragAction(var1_39, arg1_39, iter1_39, arg3_39)
		end
	end

	return false
end

function var0_0.doDragAction(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40)
	local var0_40 = arg3_40.change_idle
	local var1_40 = arg3_40.fold
	local var2_40 = arg3_40.effect_hide
	local var3_40 = arg3_40.cv
	local var4_40 = arg3_40.alpha_data and arg3_40.alpha_data or nil
	local var5_40 = arg3_40.skin_change and arg3_40.skin_change or nil
	local var6_40 = arg3_40.clear_track and arg3_40.clear_track or nil
	local var7_40

	if type(arg3_40.action) == "string" then
		var7_40 = arg3_40.action
	elseif type(arg3_40.action) == "table" then
		var7_40 = arg3_40.action[math.random(1, #arg3_40.action)]
	end

	local var8_40

	if type(arg3_40.event) == "string" then
		var8_40 = arg3_40.event
	elseif type(arg3_40.event) == "table" then
		var8_40 = arg3_40.event[math.random(1, #arg3_40.event)]
	end

	if arg1_40 == SpinePaintingConst.drag_type_normal then
		if var4_40 and #var4_40 > 0 then
			for iter0_40, iter1_40 in ipairs(var4_40) do
				local var9_40 = iter1_40[1]
				local var10_40 = iter1_40[2]
				local var11_40 = iter1_40[3]
				local var12_40 = arg0_40:getSlotAlpha(var9_40)

				if not arg0_40:getStepSlotAlha(var9_40) and var12_40 then
					local var13_40
					local var14_40

					for iter2_40, iter3_40 in ipairs(var10_40) do
						if math.abs(var12_40 - iter3_40) <= 0.1 then
							var14_40 = iter2_40 + 1
						end

						if var14_40 == iter2_40 then
							var13_40 = iter3_40
						end
					end

					var13_40 = var13_40 or var10_40[1]

					if var13_40 then
						arg0_40:setStepSlotAlpha(var9_40, var13_40, var11_40)
					end
				end
			end
		end

		local var15_40 = arg3_40.material and arg3_40.material or nil
		local var16_40 = arg3_40.material_time and arg3_40.material_time or nil

		if var15_40 then
			if LeanTween.isTweening(go(arg0_40._tf)) then
				return false
			end

			arg0_40:getSpineMaterial(var15_40, function(arg0_41)
				arg0_40._skeletonGraphic.material = arg0_41

				if var16_40 then
					LeanTween.delayedCall(go(arg0_40._tf), var16_40, System.Action(function()
						arg0_40._skeletonGraphic.material = arg0_40._baseMaterial

						arg0_40:changePaintingIdle(var0_40)
					end))
				end
			end)
		end

		if var6_40 and #var6_40 > 0 then
			for iter4_40, iter5_40 in ipairs(var6_40) do
				arg0_40:SetEmptyAction(iter5_40)
			end
		end

		if var7_40 and var7_40 ~= "" and arg0_40:checkActionPlayAble(var7_40, false, 0) then
			if var1_40 then
				pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, true)
			end

			arg0_40:setEffectVisible(var2_40, false)
			arg0_40:SetActionWithFinishCallback(var7_40, 0, function()
				if var5_40 and var5_40 ~= "" then
					arg0_40:changeSkeletonSkin(var5_40)
				end

				if var1_40 then
					pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, false)
				end

				arg0_40:changePaintingIdle(var0_40 and var0_40 or arg0_40:getIdleName())
				arg0_40:setEffectVisible(var2_40, true)
			end, false, function()
				if var3_40 and var3_40 ~= "" then
					local var0_44 = arg0_40._spinePaintingData.ship:getSkinId()
					local var1_44 = pg.CriMgr.GetCVBankName(ShipWordHelper.RawGetCVKey(var0_44))
					local var2_44 = pg.ship_skin_template[var0_44].group_index
					local var3_44 = var3_40 .. "_" .. var2_44

					print("try playing cv" .. var1_44 .. ":" .. var3_44)
					pg.CriMgr.GetInstance():playCueSheetVoice(var1_44, var3_44, true, function(arg0_45)
						if arg0_45 then
							print("播放的语音长度为 = " .. arg0_45:GetLength())
						end
					end)
				end

				if var8_40 and type(var8_40) == "string" and arg0_40._eventTriggerCall then
					arg0_40._eventTriggerCall(var8_40)
				end
			end)
		end

		if not var7_40 or var7_40 == "" then
			if var5_40 and var5_40 ~= "" then
				arg0_40:changeSkeletonSkin(var5_40)
			end

			if var0_40 and var0_40 ~= "" then
				arg0_40:changePaintingIdle(var0_40)
			end

			if var8_40 and type(var8_40) == "string" and arg0_40._eventTriggerCall then
				arg0_40._eventTriggerCall(var8_40)
			end

			return false
		end
	end

	return true
end

function var0_0.changeSkeletonSkin(arg0_46, arg1_46)
	if arg0_46._skeletonSkin == arg1_46 then
		arg0_46:SetDefaultSkeletonSkin()
	else
		arg0_46:SetSkeletonSkin(arg1_46)
	end

	SpinePaintingDrag.SetPaintingInitSkin(arg0_46.mainSpineAnim.name, arg0_46._spinePaintingData.ship.id, arg0_46._skeletonSkin)
end

function var0_0.setEffectVisible(arg0_47, arg1_47, arg2_47)
	if not arg1_47 or #arg1_47 == 0 then
		return
	end

	for iter0_47 = 1, #arg1_47 do
		local var0_47 = findTF(arg0_47._tf, arg1_47[iter0_47])

		if var0_47 then
			setActive(var0_47, arg2_47)
		end
	end
end

function var0_0.matchDragFlag(arg0_48, arg1_48, arg2_48, arg3_48)
	local var0_48 = arg2_48.hit

	if var0_48 and var0_48 ~= arg1_48 then
		return false
	end

	local var1_48 = arg2_48.skin

	if var1_48 and var1_48 ~= "" and arg0_48._skeletonSkin ~= var1_48 then
		return false
	end

	local var2_48 = arg2_48.idle

	if var2_48 and var2_48 ~= "" and arg0_48:getIdleName() ~= var2_48 then
		return false
	end

	local var3_48 = arg2_48.is_default

	if arg0_48:getIdleName() ~= arg0_48:getNormalIdleName() and var3_48 and var3_48 ~= "" then
		return false
	end

	local var4_48 = arg2_48.favor

	if var4_48 and var4_48 >= 0 then
		local var5_48 = arg0_48._spinePaintingData.ship:getCVIntimacy()

		if var5_48 and var5_48 < var4_48 then
			return false
		end
	end

	if arg2_48.click and arg2_48.click == tobool(arg3_48) then
		return false
	end

	return true
end

function var0_0.OnDragMove(arg0_49, arg1_49, arg2_49)
	return
end

function var0_0.getSpineMaterial(arg0_50, arg1_50, arg2_50)
	if not arg0_50._materialDic then
		arg0_50._materialDic = {}
	end

	if arg0_50._materialDic[arg1_50] then
		arg2_50(arg0_50._materialDic[arg1_50])
	else
		arg0_50._materialDic[arg1_50] = LoadAny("spinematerials", arg1_50, typeof(Material))

		arg2_50(arg0_50._materialDic[arg1_50])
	end
end

function var0_0.changePaintingIdle(arg0_51, arg1_51)
	arg0_51:setIdleName(arg1_51)
	arg0_51:SetAction(arg1_51, 0, true)
	SpinePaintingDrag.SetPaintingInitIdle(arg0_51.mainSpineAnim.name, arg0_51._spinePaintingData.ship.id, arg1_51)

	arg0_51.inAction = false
end

function var0_0.SetShopHx(arg0_52, arg1_52)
	if arg1_52 and HXSet.isHx() then
		if arg0_52:getAnimationExist("shop_hx") then
			arg0_52:setIdleName("shop_hx")
			arg0_52:SetAction(arg0_52._idleName, 0, true)

			local var0_52 = arg0_52._tf.anchoredPosition

			arg0_52._tf.anchoredPosition = Vector2(100000, 0)

			arg0_52:updateSkeletonGraphicTime()
			onDelayTick(function()
				arg0_52._tf.anchoredPosition = var0_52
			end, 0.05)
		end
	else
		arg0_52:setIdleName(arg0_52:getNormalIdleName())
		arg0_52:SetAction(arg0_52._idleName, 0, true)
	end
end

function var0_0.SetAction(arg0_54, arg1_54, arg2_54, arg3_54)
	if not arg0_54:checkActionPlayAble(arg1_54, arg3_54, arg2_54) then
		return false
	end

	if arg2_54 and arg2_54 == 0 then
		arg0_54.lastPlayAction = arg1_54
	end

	if arg2_54 == 0 and arg1_54 ~= arg0_54:getIdleName() then
		arg0_54.inAction = true
	end

	if arg0_54.multipleFaceFlag and not arg0_54.inAction then
		arg1_54 = arg0_54:getMultipFaceAction(arg1_54)
	end

	local var0_54 = arg0_54._spinePaintingData.ship:getSkinId()
	local var1_54 = pg.ship_skin_template[var0_54].voice_lang

	if arg2_54 == 0 and var1_54 and #var1_54 > 0 then
		local var2_54 = ShipWordHelper.GetLanguageSetting(var0_54)

		if var2_54 <= 0 then
			var2_54 = 1
		end

		local var3_54 = var1_54[var2_54]
		local var4_54 = arg0_54:GetVoiceLandAction(arg1_54, var3_54)

		if arg0_54:getAnimationExist(var4_54) then
			arg1_54 = var4_54
		end
	end

	arg0_54:updateEffectVisible(arg1_54)

	for iter0_54, iter1_54 in ipairs(arg0_54.spineAnimList) do
		iter1_54:SetAction(arg1_54, arg2_54)

		if iter1_54:GetAnimationState() then
			GetComponent(iter1_54.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end

	return true
end

function var0_0.GetVoiceLandAction(arg0_55, arg1_55, arg2_55)
	local var0_55 = ""

	if arg2_55 == ShipSkin.VOICE_LANG_JP then
		var0_55 = "_jp"
	elseif arg2_55 == ShipSkin.VOICE_LANG_CN then
		var0_55 = "_cn"
	end

	return arg1_55 .. var0_55
end

function var0_0.checkActionPlayAble(arg0_56, arg1_56, arg2_56, arg3_56)
	if arg3_56 and arg3_56 == 0 and arg0_56.inAction and not arg2_56 then
		return false
	end

	if arg0_56.lockLayer and not arg2_56 and arg0_56.inAction and arg3_56 and arg3_56 > 0 then
		return false
	end

	if arg0_56.lastPlayAction and arg0_56.lastPlayAction ~= arg0_56._idleName and arg3_56 and arg3_56 > 0 then
		return false
	end

	if arg0_56._idleName ~= arg0_56:getNormalIdleName() and arg1_56 == "login" then
		return false
	end

	if arg0_56.dragShipFlag and arg0_56.shipDragData.action_enable then
		local var0_56 = arg0_56.shipDragData.action_enable

		for iter0_56 = 1, #var0_56 do
			local var1_56 = var0_56[iter0_56]

			if var1_56.name == arg0_56._idleName and table.contains(var1_56.ignore, arg1_56) then
				return false
			end
		end
	end

	return true
end

function var0_0.ClearAction(arg0_57)
	arg0_57.inAction = false
end

function var0_0.getSlotAlpha(arg0_58, arg1_58)
	local var0_58 = arg0_58._skeletonGraphic.Skeleton:FindSlot(arg1_58)

	if var0_58 then
		return ReflectionHelp.RefGetProperty(typeof("Spine.Slot"), "A", var0_58)
	end

	return nil
end

function var0_0.setSlotAlpha(arg0_59, arg1_59, arg2_59)
	ReflectionHelp.RefSetProperty(typeof("Spine.Slot"), "A", arg1_59, arg2_59)
end

function var0_0.setStepSlotAlpha(arg0_60, arg1_60, arg2_60, arg3_60)
	if not arg0_60.slotDic[arg1_60] then
		arg0_60.slotDic[arg1_60] = arg0_60._skeletonGraphic.Skeleton:FindSlot(arg1_60)
	end

	if arg0_60.slotDic[arg1_60] then
		if not arg3_60 or arg3_60 <= 0 then
			print("设置插槽 " .. arg1_60 .. " alpha = " .. arg2_60)
			arg0_60:setSlotAlpha(arg0_60.slotDic[arg1_60], arg2_60)
		else
			local var0_60 = arg0_60:getSlotAlpha(arg1_60)

			table.insert(arg0_60.stepSlotAlpha, {
				smooth = 0,
				name = arg1_60,
				slot = arg0_60.slotDic[arg1_60],
				current = var0_60,
				target = arg2_60,
				time = arg3_60
			})
		end
	end
end

function var0_0.getStepSlotAlha(arg0_61, arg1_61)
	for iter0_61, iter1_61 in ipairs(arg0_61.stepSlotAlpha) do
		if iter1_61.name == arg1_61 then
			return iter1_61
		end
	end

	return nil
end

function var0_0.updateSlotAlpha(arg0_62)
	for iter0_62 = #arg0_62.stepSlotAlpha, 1, -1 do
		local var0_62 = arg0_62.stepSlotAlpha[iter0_62]

		var0_62.current, var0_62.smooth = Mathf.SmoothDamp(var0_62.current, var0_62.target, var0_62.smooth, var0_62.time)

		if math.abs(var0_62.target - var0_62.current) <= 0.02 then
			print("设置插槽 " .. var0_62.name .. " alpha = " .. var0_62.target)
			arg0_62:setSlotAlpha(var0_62.slot, var0_62.target)

			table.remove(arg0_62.stepSlotAlpha, iter0_62).slot = nil
		else
			print("设置插槽 " .. var0_62.name .. " alpha = " .. var0_62.current)
			arg0_62:setSlotAlpha(var0_62.slot, var0_62.current)
		end
	end
end

function var0_0.updateEffectVisible(arg0_63, arg1_63)
	if arg0_63.shipEffectActionAble and arg0_63._effectsTf then
		if table.contains(arg0_63.shipEffectActionAble, arg1_63) then
			if isActive(arg0_63._effectsTf) then
				setActive(arg0_63._effectsTf, false)
			end
		elseif not isActive(arg0_63._effectsTf) then
			setActive(arg0_63._effectsTf, true)
		end
	end
end

function var0_0.isInAction(arg0_64)
	return arg0_64.inAction
end

function var0_0.SetActionWithFinishCallback(arg0_65, arg1_65, arg2_65, arg3_65, arg4_65, arg5_65)
	if not arg0_65:checkActionPlayAble(arg1_65, arg4_65, arg2_65) then
		return
	end

	if arg0_65.mainSpineAnim then
		arg0_65.mainSpineAnim:SetActionCallBack(function(arg0_66)
			if arg0_66 == "finish" and arg3_65 then
				arg0_65.inAction = false

				arg0_65.mainSpineAnim:SetActionCallBack(nil)
				arg3_65()

				arg3_65 = nil
			elseif arg0_66 == "action" and arg5_65 then
				arg5_65()

				arg5_65 = nil
			end
		end)
	end

	arg0_65:SetAction(arg1_65, arg2_65, arg4_65)
end

function var0_0.SetOnceAction(arg0_67, arg1_67, arg2_67, arg3_67, arg4_67)
	if not arg0_67:checkActionPlayAble(arg1_67, arg4_67, 0) then
		return
	end

	arg0_67:SetActionWithFinishCallback(arg1_67, 0, function()
		arg0_67:SetAction(arg0_67:getIdleName(), 0)

		if arg2_67 then
			arg2_67()

			arg2_67 = nil
		end
	end, arg4_67, function()
		if arg3_67 then
			arg3_67()

			arg3_67 = nil
		end
	end)
end

function var0_0.pullInitCallback(arg0_70, arg1_70)
	table.insert(arg0_70._initCallback, arg1_70)
end

function var0_0.getAnimationExist(arg0_71, arg1_71)
	if not arg0_71._mainAnimationData then
		arg0_71._mainAnimationData = arg0_71.mainSpineAnim:GetAnimationState()
	end

	local var0_71

	if arg0_71._skeletonGraphic then
		var0_71 = arg0_71._skeletonGraphic.Skeleton.Data:FindAnimation(arg1_71)
	end

	return var0_71
end

function var0_0.SetEmptyAction(arg0_72, arg1_72)
	if not arg0_72.spineAnimList then
		return
	end

	for iter0_72, iter1_72 in ipairs(arg0_72.spineAnimList) do
		local var0_72 = iter1_72:GetAnimationState()

		if var0_72 then
			var0_72:SetEmptyAnimation(arg1_72, 0)
			GetComponent(iter1_72.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.GetSpineTrasform(arg0_73)
	return arg0_73._tf
end

function var0_0.SetSkin(arg0_74, arg1_74)
	if arg0_74._skeletonGraphic and arg0_74._skeletonGraphic.SkeletonData and arg0_74._skeletonGraphic.SkeletonData:FindSkin(arg1_74) ~= nil then
		arg0_74._skeletonGraphic.Skeleton:SetSkin(arg1_74)
		arg0_74._skeletonGraphic.Skeleton:SetSlotsToSetupPose()
	end
end

function var0_0.updateSkeletonGraphicTime(arg0_75)
	if arg0_75._skeletonGraphic then
		arg0_75._skeletonGraphic:Update(Time.deltaTime)
	end
end

function var0_0.getMultipFaceAction(arg0_76, arg1_76)
	if arg0_76.multipleFaceFlag then
		local var0_76 = tonumber(arg1_76)

		if var0_76 and var0_76 >= 0 then
			for iter0_76, iter1_76 in ipairs(arg0_76.multipleFaceData) do
				if iter1_76[1] == arg0_76:getIdleName() then
					return tostring(var0_76 + iter1_76[2])
				end
			end
		end
	end

	return arg1_76
end

function var0_0.Dispose(arg0_77)
	arg0_77._materialDic = {}

	if arg0_77.updateLocal then
		arg0_77._skeletonGraphic.UpdateLocal = arg0_77._skeletonGraphic.UpdateLocal - arg0_77.updateLocal
		arg0_77.updateLocal = nil
	end

	if arg0_77._spinePaintingData then
		arg0_77._spinePaintingData:Clear()
	end

	for iter0_77, iter1_77 in pairs(arg0_77._loadSpineDic) do
		PoolMgr.GetInstance():ReturnSpinePainting(iter0_77, iter1_77)
	end

	for iter2_77, iter3_77 in pairs(arg0_77._loadUIDic) do
		PoolMgr.GetInstance():ReturnUI(iter2_77, iter3_77)
	end

	arg0_77._loadSpineDic = {}
	arg0_77._loadUIDic = {}

	if arg0_77._go ~= nil then
		var1_0.Destroy(arg0_77._go)
	end

	if arg0_77._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_77._bgEffectGo)
	end

	arg0_77._go = nil
	arg0_77._tf = nil
	arg0_77._bgEffectGo = nil
	arg0_77._bgEffectTf = nil

	if arg0_77.spineAnim then
		arg0_77.spineAnim:SetActionCallBack(nil)
	end

	if arg0_77._slotAlphaTimer then
		arg0_77._slotAlphaTimer:Stop()

		arg0_77._slotAlphaTimer = nil
	end

	if arg0_77.stepSlotAlpha and #arg0_77.stepSlotAlpha > 0 then
		for iter4_77, iter5_77 in ipairs(arg0_77._slotAlphaTimer) do
			iter5_77.slot = nil
		end

		arg0_77._slotAlphaTimer = {}
	end
end

function var0_0.getPaintingName(arg0_78)
	return arg0_78._spinePaintingData:GetShipName()
end

return var0_0
