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
			local var1_8, var2_8 = HXSet.autoHxShift("spinepainting/", var0_8)
			local var3_8 = var1_8 .. var2_8

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

	arg0_13:playPaintingInitIdle()
	arg0_13:playPaintingInitSkin()

	arg0_13.slotDic = {}
	arg0_13.stepSlotAlpha = {}
	arg0_13._slotAlphaTimer = Timer.New(function()
		arg0_13:updateSlotAlpha()
	end, 0.0333333333333333, -1)

	arg0_13._slotAlphaTimer:Start()
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
	arg0_22._visible = arg1_22

	if arg0_22._spinePaintingData.effectParent then
		setActive(arg0_22._spinePaintingData.effectParent, arg1_22)
	end

	pg.ViewUtils.SetLayer(arg0_22._tf, arg1_22 and Layer.UI or Layer.UIHidden)
	setActiveViaLayer(arg0_22._spinePaintingData.effectParent, arg1_22)

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
		arg0_23:SetActionWithFinishCallback(arg0_23._idleName, 0, nil, true, nil)

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

	if var1_24 and arg0_24._skeletonGraphic and arg0_24._skeletonGraphic.SkeletonData then
		if arg0_24._skeletonGraphic.SkeletonData:FindSkin(var1_24) ~= nil then
			arg0_24:SetSkeletonSkin(var1_24)
		elseif arg0_24._skeletonGraphic.SkeletonData:FindSkin("default") ~= nil then
			arg0_24:SetSkeletonSkin("default")
		end
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
						local var6_28 = true
						local var7_28 = true

						if var2_28.idle and type(var2_28.idle) == "string" then
							var6_28 = var2_28.idle == arg0_28._idleName
						elseif var2_28.idle and type(var2_28.idle) == "table" then
							var6_28 = table.contains(var2_28.idle, arg0_28._idleName)
						end

						if var2_28.skin and type(var2_28.skin) == "string" then
							var7_28 = var2_28.skin == arg0_28._skeletonSkin
						elseif var2_28.skin and type(var2_28.skin) == "table" then
							var7_28 = table.contains(var2_28.skin, arg0_28._skeletonSkin)
						end

						setActive(var5_28, var6_28 and var7_28)
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
	arg0_33:updateHitArea()
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
	local var0_40 = arg3_40.fold
	local var1_40 = arg3_40.effect_hide
	local var2_40 = arg3_40.action_cv
	local var3_40 = arg3_40.finish_cv
	local var4_40 = arg3_40.alpha_data and arg3_40.alpha_data or nil
	local var5_40 = arg3_40.skin_change and arg3_40.skin_change or nil
	local var6_40 = arg3_40.clear_track and arg3_40.clear_track or nil
	local var7_40 = arg3_40.idle and arg3_40.idle or nil
	local var8_40 = arg3_40.change_idle
	local var9_40 = arg3_40.action
	local var10_40 = arg3_40.event
	local var11_40 = var5_40
	local var12_40
	local var13_40
	local var14_40

	if type(var8_40) == "table" and type(var9_40) == "table" then
		local var15_40 = math.random(1, #var9_40)

		var12_40 = var9_40[var15_40]
		var14_40 = var8_40[var15_40]
	elseif type(var7_40) == "table" and type(var9_40) == "table" then
		local var16_40 = table.indexof(var7_40, arg0_40:getIdleName())

		var12_40 = var9_40[var16_40]

		if type(var8_40) == "table" then
			var14_40 = var8_40[var16_40]
		end
	end

	if not var12_40 then
		if type(var9_40) == "string" then
			var12_40 = var9_40
		elseif type(var9_40) == "table" then
			var12_40 = var9_40[math.random(1, #var9_40)]
		end
	end

	if not var14_40 then
		if type(var8_40) == "string" then
			var14_40 = var8_40
		elseif type(var8_40) == "table" then
			var14_40 = var8_40[math.random(1, #var8_40)]
		end
	end

	if not var13_40 then
		if type(var10_40) == "string" then
			var13_40 = var10_40
		elseif type(var10_40) == "table" then
			var13_40 = var10_40[math.random(1, #var10_40)]
		end
	end

	if arg1_40 == SpinePaintingConst.drag_type_normal then
		if var4_40 and #var4_40 > 0 then
			arg0_40:SetAlphaData(var4_40)
		end

		local var17_40 = arg3_40.material and arg3_40.material or nil
		local var18_40 = arg3_40.material_time and arg3_40.material_time or nil

		if var17_40 then
			if LeanTween.isTweening(go(arg0_40._tf)) then
				return false
			end

			arg0_40:getSpineMaterial(var17_40, function(arg0_41)
				arg0_40._skeletonGraphic.material = arg0_41

				if var18_40 then
					LeanTween.delayedCall(go(arg0_40._tf), var18_40, System.Action(function()
						arg0_40._skeletonGraphic.material = arg0_40._baseMaterial

						arg0_40:changePaintingIdle(var14_40)
					end))
				end
			end)
		end

		if var6_40 and #var6_40 > 0 then
			for iter0_40, iter1_40 in ipairs(var6_40) do
				arg0_40:SetEmptyAction(iter1_40)
			end
		end

		if var12_40 and var12_40 ~= "" and arg0_40:checkActionPlayAble(var12_40, false, 0) then
			print("播放动作 .." .. var12_40 .. "下一个待机动作 .. " .. var14_40)

			if var0_40 then
				pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, true)
			end

			arg0_40:setEffectVisible(var1_40, false)
			arg0_40:SetActionWithFinishCallback(var12_40, 0, function()
				if var11_40 and var11_40 ~= "" then
					arg0_40:changeSkeletonSkin(var11_40)
				end

				if var0_40 then
					pg.m02:sendNotification(NewMainMediator.HIDE_PANEL, false)
				end

				arg0_40:changePaintingIdle(var14_40 and var14_40 or arg0_40:getIdleName())
				arg0_40:setEffectVisible(var1_40, true)

				if var3_40 and var3_40 ~= "" then
					arg0_40:PlayCv(var3_40)
				end
			end, false, function()
				if var2_40 and var2_40 ~= "" then
					arg0_40:PlayCv(var2_40)
				end

				if var13_40 and type(var13_40) == "string" and arg0_40._eventTriggerCall then
					arg0_40._eventTriggerCall(var13_40)
				end
			end)
		end

		if not var12_40 or var12_40 == "" then
			if var11_40 and var11_40 ~= "" then
				arg0_40:changeSkeletonSkin(var11_40)
			end

			if var14_40 and var14_40 ~= "" then
				arg0_40:changePaintingIdle(var14_40)
			end

			if var13_40 and type(var13_40) == "string" and arg0_40._eventTriggerCall then
				arg0_40._eventTriggerCall(var13_40)
			end

			return false
		end
	end

	return true
end

function var0_0.SetAlphaData(arg0_45, arg1_45)
	for iter0_45, iter1_45 in ipairs(arg1_45) do
		local var0_45 = iter1_45[1]
		local var1_45 = iter1_45[2]
		local var2_45 = iter1_45[3]
		local var3_45 = arg0_45:getSlotAlpha(var0_45)

		if not arg0_45:getStepSlotAlha(var0_45) and var3_45 then
			local var4_45
			local var5_45

			for iter2_45, iter3_45 in ipairs(var1_45) do
				if math.abs(var3_45 - iter3_45) <= 0.1 then
					var5_45 = iter2_45 + 1
				end

				if var5_45 == iter2_45 then
					var4_45 = iter3_45
				end
			end

			var4_45 = var4_45 or var1_45[1]

			if var4_45 then
				arg0_45:setStepSlotAlpha(var0_45, var4_45, var2_45)
			end
		end
	end
end

function var0_0.PlayCv(arg0_46, arg1_46)
	local var0_46 = arg0_46._spinePaintingData.ship:getSkinId()
	local var1_46 = pg.CriMgr.GetCVBankName(ShipWordHelper.RawGetCVKey(var0_46))
	local var2_46 = pg.ship_skin_template[var0_46].group_index
	local var3_46 = arg1_46 .. "_" .. var2_46

	print("try playing cv" .. var1_46 .. ":" .. var3_46)
	pg.CriMgr.GetInstance():playCueSheetVoice(var1_46, var3_46, true, function(arg0_47)
		if arg0_47 then
			print("播放的语音长度为 = " .. arg0_47:GetLength())
		end
	end)
end

function var0_0.changeSkeletonSkin(arg0_48, arg1_48)
	if arg0_48._skeletonSkin == arg1_48 then
		arg0_48:SetDefaultSkeletonSkin()
	else
		arg0_48:SetSkeletonSkin(arg1_48)
	end

	SpinePaintingDrag.SetPaintingInitSkin(arg0_48.mainSpineAnim.name, arg0_48._spinePaintingData.ship.id, arg0_48._skeletonSkin)
end

function var0_0.setEffectVisible(arg0_49, arg1_49, arg2_49)
	if not arg1_49 or #arg1_49 == 0 then
		return
	end

	for iter0_49 = 1, #arg1_49 do
		local var0_49 = findTF(arg0_49._tf, arg1_49[iter0_49])

		if var0_49 then
			setActive(var0_49, arg2_49)
		end
	end
end

function var0_0.matchDragFlag(arg0_50, arg1_50, arg2_50, arg3_50)
	local var0_50 = arg2_50.hit

	if var0_50 and var0_50 ~= arg1_50 then
		return false
	end

	local var1_50 = arg2_50.skin

	if var1_50 and var1_50 ~= "" and arg0_50._skeletonSkin ~= var1_50 then
		return false
	end

	local var2_50 = arg2_50.idle

	if var2_50 and type(var2_50) == "string" and arg0_50:getIdleName() ~= var2_50 then
		return false
	elseif var2_50 and type(var2_50) == "table" and not table.contains(var2_50, arg0_50:getIdleName()) then
		return false
	end

	local var3_50 = arg2_50.favor

	if var3_50 and var3_50 >= 0 then
		local var4_50 = arg0_50._spinePaintingData.ship:getCVIntimacy()

		if var4_50 and var4_50 < var3_50 then
			return false
		end
	end

	if arg2_50.click and arg2_50.click == tobool(arg3_50) then
		return false
	end

	return true
end

function var0_0.OnDragMove(arg0_51, arg1_51, arg2_51)
	return
end

function var0_0.getSpineMaterial(arg0_52, arg1_52, arg2_52)
	if not arg0_52._materialDic then
		arg0_52._materialDic = {}
	end

	if arg0_52._materialDic[arg1_52] then
		arg2_52(arg0_52._materialDic[arg1_52])
	else
		arg0_52._materialDic[arg1_52] = LoadAny("spinematerials", arg1_52, typeof(Material))

		arg2_52(arg0_52._materialDic[arg1_52])
	end
end

function var0_0.changePaintingIdle(arg0_53, arg1_53)
	arg0_53:setIdleName(arg1_53)
	arg0_53:SetAction(arg1_53, 0, true)
	SpinePaintingDrag.SetPaintingInitIdle(arg0_53.mainSpineAnim.name, arg0_53._spinePaintingData.ship.id, arg1_53)

	arg0_53.inAction = false
end

function var0_0.SetShopHx(arg0_54, arg1_54)
	if arg1_54 and HXSet.isHx() then
		if arg0_54:getAnimationExist("shop_hx") then
			arg0_54:setIdleName("shop_hx")
			arg0_54:SetAction(arg0_54._idleName, 0, true)

			local var0_54 = arg0_54._tf.anchoredPosition

			arg0_54._tf.anchoredPosition = Vector2(100000, 0)

			arg0_54:updateSkeletonGraphicTime()
			onDelayTick(function()
				arg0_54._tf.anchoredPosition = var0_54
			end, 0.05)
		end
	else
		arg0_54:setIdleName(arg0_54:getNormalIdleName())
		arg0_54:SetAction(arg0_54._idleName, 0, true)
	end
end

function var0_0.SetAction(arg0_56, arg1_56, arg2_56, arg3_56)
	if not arg0_56:checkActionPlayAble(arg1_56, arg3_56, arg2_56) then
		return false
	end

	if arg2_56 and arg2_56 == 0 then
		arg0_56.lastPlayAction = arg1_56
	end

	if arg2_56 == 0 and arg1_56 ~= arg0_56:getIdleName() then
		arg0_56.inAction = true
	end

	if arg0_56.multipleFaceFlag and not arg0_56.inAction then
		arg1_56 = arg0_56:getMultipFaceAction(arg1_56)
	end

	local var0_56 = arg0_56._spinePaintingData.ship:getSkinId()
	local var1_56 = pg.ship_skin_template[var0_56].voice_lang

	if arg2_56 == 0 and var1_56 and #var1_56 > 0 then
		local var2_56 = ShipWordHelper.GetLanguageSetting(var0_56)

		if var2_56 <= 0 then
			var2_56 = 1
		end

		local var3_56 = var1_56[var2_56]
		local var4_56 = arg0_56:GetVoiceLandAction(arg1_56, var3_56)

		if arg0_56:getAnimationExist(var4_56) then
			arg1_56 = var4_56
		end
	end

	arg0_56:updateEffectVisible(arg1_56)

	for iter0_56, iter1_56 in ipairs(arg0_56.spineAnimList) do
		iter1_56:SetAction(arg1_56, arg2_56)

		if iter1_56:GetAnimationState() then
			GetComponent(iter1_56.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end

	return true
end

function var0_0.GetVoiceLandAction(arg0_57, arg1_57, arg2_57)
	local var0_57 = ""

	if arg2_57 == ShipSkin.VOICE_LANG_JP then
		var0_57 = "_jp"
	elseif arg2_57 == ShipSkin.VOICE_LANG_CN then
		var0_57 = "_cn"
	end

	return arg1_57 .. var0_57
end

function var0_0.checkActionPlayAble(arg0_58, arg1_58, arg2_58, arg3_58)
	if arg3_58 and arg3_58 == 0 and arg0_58.inAction and not arg2_58 then
		return false
	end

	if arg0_58.lockLayer and not arg2_58 and arg0_58.inAction and arg3_58 and arg3_58 > 0 then
		return false
	end

	if arg0_58.lastPlayAction and arg0_58.lastPlayAction ~= arg0_58._idleName and arg3_58 and arg3_58 > 0 then
		return false
	end

	if arg0_58._idleName ~= arg0_58:getNormalIdleName() and arg1_58 == "login" then
		return false
	end

	if arg0_58.dragShipFlag and arg0_58.shipDragData.action_enable then
		local var0_58 = arg0_58.shipDragData.action_enable

		for iter0_58 = 1, #var0_58 do
			local var1_58 = var0_58[iter0_58]

			if var1_58.name == arg0_58._idleName and table.contains(var1_58.ignore, arg1_58) then
				return false
			end
		end
	end

	return true
end

function var0_0.ClearAction(arg0_59)
	arg0_59.inAction = false
end

function var0_0.getSlotAlpha(arg0_60, arg1_60)
	local var0_60 = arg0_60._skeletonGraphic.Skeleton:FindSlot(arg1_60)

	if var0_60 then
		return ReflectionHelp.RefGetProperty(typeof("Spine.Slot"), "A", var0_60)
	end

	return nil
end

function var0_0.setSlotAlpha(arg0_61, arg1_61, arg2_61)
	ReflectionHelp.RefSetProperty(typeof("Spine.Slot"), "A", arg1_61, arg2_61)
end

function var0_0.setStepSlotAlpha(arg0_62, arg1_62, arg2_62, arg3_62)
	if not arg0_62.slotDic[arg1_62] then
		arg0_62.slotDic[arg1_62] = arg0_62._skeletonGraphic.Skeleton:FindSlot(arg1_62)
	end

	if arg0_62.slotDic[arg1_62] then
		if not arg3_62 or arg3_62 <= 0 then
			print("设置插槽 " .. arg1_62 .. " alpha = " .. arg2_62)
			arg0_62:setSlotAlpha(arg0_62.slotDic[arg1_62], arg2_62)
		else
			local var0_62 = arg0_62:getSlotAlpha(arg1_62)

			table.insert(arg0_62.stepSlotAlpha, {
				smooth = 0,
				name = arg1_62,
				slot = arg0_62.slotDic[arg1_62],
				current = var0_62,
				target = arg2_62,
				time = arg3_62
			})
		end
	end
end

function var0_0.getStepSlotAlha(arg0_63, arg1_63)
	for iter0_63, iter1_63 in ipairs(arg0_63.stepSlotAlpha) do
		if iter1_63.name == arg1_63 then
			return iter1_63
		end
	end

	return nil
end

function var0_0.updateSlotAlpha(arg0_64)
	for iter0_64 = #arg0_64.stepSlotAlpha, 1, -1 do
		local var0_64 = arg0_64.stepSlotAlpha[iter0_64]

		var0_64.current, var0_64.smooth = Mathf.SmoothDamp(var0_64.current, var0_64.target, var0_64.smooth, var0_64.time)

		if math.abs(var0_64.target - var0_64.current) <= 0.02 then
			print("设置插槽 " .. var0_64.name .. " alpha = " .. var0_64.target)
			arg0_64:setSlotAlpha(var0_64.slot, var0_64.target)

			table.remove(arg0_64.stepSlotAlpha, iter0_64).slot = nil
		else
			print("设置插槽 " .. var0_64.name .. " alpha = " .. var0_64.current)
			arg0_64:setSlotAlpha(var0_64.slot, var0_64.current)
		end
	end
end

function var0_0.updateEffectVisible(arg0_65, arg1_65)
	if arg0_65.shipEffectActionAble and arg0_65._effectsTf then
		if table.contains(arg0_65.shipEffectActionAble, arg1_65) then
			if isActive(arg0_65._effectsTf) then
				setActive(arg0_65._effectsTf, false)
			end
		elseif not isActive(arg0_65._effectsTf) then
			setActive(arg0_65._effectsTf, true)
		end
	end
end

function var0_0.isInAction(arg0_66)
	return arg0_66.inAction
end

function var0_0.SetActionWithFinishCallback(arg0_67, arg1_67, arg2_67, arg3_67, arg4_67, arg5_67)
	if not arg0_67:checkActionPlayAble(arg1_67, arg4_67, arg2_67) then
		return
	end

	if arg0_67.mainSpineAnim then
		arg0_67.mainSpineAnim:SetActionCallBack(function(arg0_68)
			if arg0_68 == "finish" and arg3_67 then
				arg0_67.inAction = false

				arg0_67.mainSpineAnim:SetActionCallBack(nil)
				arg3_67()

				arg3_67 = nil
			elseif arg0_68 == "action" and arg5_67 then
				arg5_67()

				arg5_67 = nil
			elseif (string.match(arg0_68, "^bgm_") or string.match(arg0_68, "^bgmsingle_")) and arg0_67._visible then
				local var0_68 = string.match(arg0_68, "^bgm_(.*)$") or string.match(arg0_68, "^bgmsingle_(.*)$")
				local var1_68 = string.split(var0_68, "_")
				local var2_68 = string.match(arg0_68, "^bgm_(.*)$") and true or false
				local var3_68 = "se-skin"
				local var4_68 = var1_68[1] .. "_" .. var1_68[2]
				local var5_68 = var1_68[3] and tonumber(var1_68[3]) or 1

				pg.CriMgr.GetInstance():PlayPaintingBgm(var3_68, var4_68, var2_68, var5_68, Live2dConst.GetPaintingBgmVolume(arg0_67._spinePaintingData.ship:getSkinId()))
			end
		end)
	end

	arg0_67:SetAction(arg1_67, arg2_67, arg4_67)
end

function var0_0.SetOnceAction(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69)
	if not arg0_69:checkActionPlayAble(arg1_69, arg4_69, 0) then
		return
	end

	arg0_69:SetActionWithFinishCallback(arg1_69, 0, function()
		arg0_69:SetAction(arg0_69:getIdleName(), 0)

		if arg2_69 then
			arg2_69()

			arg2_69 = nil
		end
	end, arg4_69, function()
		if arg3_69 then
			arg3_69()

			arg3_69 = nil
		end
	end)
end

function var0_0.pullInitCallback(arg0_72, arg1_72)
	table.insert(arg0_72._initCallback, arg1_72)
end

function var0_0.getAnimationExist(arg0_73, arg1_73)
	if not arg0_73._mainAnimationData then
		arg0_73._mainAnimationData = arg0_73.mainSpineAnim:GetAnimationState()
	end

	local var0_73

	if arg0_73._skeletonGraphic then
		var0_73 = arg0_73._skeletonGraphic.Skeleton.Data:FindAnimation(arg1_73)
	end

	return var0_73
end

function var0_0.SetEmptyAction(arg0_74, arg1_74)
	if not arg0_74.spineAnimList then
		return
	end

	for iter0_74, iter1_74 in ipairs(arg0_74.spineAnimList) do
		local var0_74 = iter1_74:GetAnimationState()

		if var0_74 then
			var0_74:SetEmptyAnimation(arg1_74, 0)
			GetComponent(iter1_74.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.GetSpineTransform(arg0_75)
	return arg0_75._tf
end

function var0_0.SetSkin(arg0_76, arg1_76)
	if arg0_76._skeletonGraphic and arg0_76._skeletonGraphic.SkeletonData and arg0_76._skeletonGraphic.SkeletonData:FindSkin(arg1_76) ~= nil then
		arg0_76._skeletonGraphic.Skeleton:SetSkin(arg1_76)
		arg0_76._skeletonGraphic.Skeleton:SetSlotsToSetupPose()
	end
end

function var0_0.updateSkeletonGraphicTime(arg0_77)
	if arg0_77._skeletonGraphic then
		arg0_77._skeletonGraphic:Update(Time.deltaTime)
	end
end

function var0_0.getMultipFaceAction(arg0_78, arg1_78)
	if arg0_78.multipleFaceFlag then
		local var0_78 = tonumber(arg1_78)

		if var0_78 and var0_78 >= 0 then
			for iter0_78, iter1_78 in ipairs(arg0_78.multipleFaceData) do
				if iter1_78[1] == arg0_78:getIdleName() then
					return tostring(var0_78 + iter1_78[2])
				end
			end
		end
	end

	return arg1_78
end

function var0_0.unloadCueSheet(arg0_79)
	if not arg0_79.loadSheets then
		return
	end

	for iter0_79, iter1_79 in ipairs(arg0_79.loadSheets) do
		pg.CriMgr.GetInstance():UnloadCueSheet(iter1_79)
	end

	arg0_79.loadSheets = {}
end

function var0_0.Dispose(arg0_80)
	arg0_80._materialDic = {}

	if arg0_80.updateLocal then
		arg0_80._skeletonGraphic.UpdateLocal = arg0_80._skeletonGraphic.UpdateLocal - arg0_80.updateLocal
		arg0_80.updateLocal = nil
	end

	if arg0_80._spinePaintingData then
		arg0_80._spinePaintingData:Clear()
	end

	for iter0_80, iter1_80 in pairs(arg0_80._loadSpineDic) do
		PoolMgr.GetInstance():ReturnSpinePainting(iter0_80, iter1_80)
	end

	for iter2_80, iter3_80 in pairs(arg0_80._loadUIDic) do
		PoolMgr.GetInstance():ReturnUI(iter2_80, iter3_80)
	end

	arg0_80._loadSpineDic = {}
	arg0_80._loadUIDic = {}

	arg0_80:unloadCueSheet()

	if arg0_80._go ~= nil then
		var1_0.Destroy(arg0_80._go)
	end

	if arg0_80._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_80._bgEffectGo)
	end

	arg0_80._go = nil
	arg0_80._tf = nil
	arg0_80._bgEffectGo = nil
	arg0_80._bgEffectTf = nil

	if arg0_80.spineAnim then
		arg0_80.spineAnim:SetActionCallBack(nil)
	end

	if arg0_80._slotAlphaTimer then
		arg0_80._slotAlphaTimer:Stop()

		arg0_80._slotAlphaTimer = nil
	end

	if arg0_80.stepSlotAlpha and #arg0_80.stepSlotAlpha > 0 then
		for iter4_80, iter5_80 in ipairs(arg0_80._slotAlphaTimer) do
			iter5_80.slot = nil
		end

		arg0_80._slotAlphaTimer = {}
	end
end

function var0_0.getPaintingName(arg0_81)
	return arg0_81._spinePaintingData:GetShipName()
end

return var0_0
