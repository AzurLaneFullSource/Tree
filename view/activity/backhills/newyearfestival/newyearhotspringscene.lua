local var0_0 = class("NewYearHotSpringScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewYearHotSpringUI"
end

local var1_0 = 0.85

function var0_0.init(arg0_2)
	arg0_2.scrollRect = arg0_2._tf:Find("ScrollRect")
	arg0_2.scrollContent = arg0_2.scrollRect:GetComponent(typeof(ScrollRect)).content
	arg0_2.slotTFs = _.map(_.range(4, 13), function(arg0_3)
		return arg0_2.scrollRect:Find("Pool"):GetChild(arg0_3 - 1)
	end)
	arg0_2.slotOriginalPos = _.map(arg0_2.slotTFs, function(arg0_4)
		return arg0_4.anchoredPosition
	end)
	arg0_2.slotShipPos = Clone(arg0_2.slotOriginalPos)

	table.Foreach(arg0_2:GetRecordPos(), function(arg0_5, arg1_5)
		arg0_2.slotShipPos[arg0_5] = arg1_5
	end)

	arg0_2.poolItems = _.map(_.range(arg0_2.scrollRect:Find("Pool").childCount), function(arg0_6)
		return arg0_2.scrollRect:Find("Pool"):GetChild(arg0_6 - 1)
	end)

	Canvas.ForceUpdateCanvases()

	arg0_2.scrollBGs = _.map({
		{
			"1",
			0.5
		},
		{
			"2",
			0.6
		},
		{
			"3",
			var1_0
		},
		{
			"Pool",
			var1_0
		},
		{
			"4",
			1
		},
		{
			"5",
			1
		}
	}, function(arg0_7)
		local var0_7 = {
			arg0_2.scrollRect:Find(arg0_7[1]),
			arg0_7[2]
		}

		var0_7[3] = var0_7[1].anchoredPosition.x

		arg0_2:UpdateScrollContent(0, unpack(var0_7))

		return var0_7
	end)
	arg0_2.top = arg0_2._tf:Find("Top")

	pg.ViewUtils.SetSortingOrder(arg0_2._tf, -1001)

	arg0_2.spineRoles = {}
	arg0_2.washMaterial = Material.New(pg.ShaderMgr.GetInstance():GetShader("M02/Unlit_Colored_Semitransparent"))

	arg0_2.washMaterial:SetFloat("_Height", 0.5)
end

function var0_0.SetActivity(arg0_8, arg1_8)
	local var0_8 = arg0_8.activity

	arg0_8.activity = arg1_8

	if not var0_8 then
		return
	end

	table.Foreach(var0_8:GetShipIds(), function(arg0_9, arg1_9)
		if arg1_9 > 0 and (arg1_8:GetShipIds()[arg0_9] or 0) == 0 then
			arg0_8.slotShipPos[arg0_9] = Clone(arg0_8.slotOriginalPos[arg0_9])
		end
	end)
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10._tf:Find("Top/Back"), function()
		arg0_10:closeView()
	end, SOUND_BACK)
	onButton(arg0_10, arg0_10._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hotspring_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10._tf:Find("Top/Manage"), function()
		arg0_10:emit(NewYearHotSpringMediator.OPEN_INFO)
	end, SFX_PANEL)

	local var0_10 = string.split(i18n("hotspring_buff"), "|")

	assert(var0_10)
	onButton(arg0_10, arg0_10._tf:Find("Top/Buff"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideIconBG = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			iconPath = {
				"UI/NewYearHotSpringUI_atlas",
				"buff_hotspring"
			},
			name = var0_10[1],
			content = var0_10[2]
		})
	end, SFX_PANEL)
	onScroll(arg0_10, arg0_10.scrollRect, function(arg0_15)
		_.each(arg0_10.scrollBGs, function(arg0_16)
			arg0_10:UpdateScrollContent(arg0_10.scrollContent.anchoredPosition.x, unpack(arg0_16))
		end)
	end)
	arg0_10:InitSlots()
	arg0_10:UpdateView()

	arg0_10.timer = FrameTimer.New(function()
		local var0_17 = _.map(_.range(arg0_10.scrollRect:Find("Pool").childCount), function(arg0_18)
			return arg0_10.scrollRect:Find("Pool"):GetChild(arg0_18 - 1)
		end)

		mergeSort(var0_17, function(arg0_19, arg1_19)
			return arg0_19.anchoredPosition.y >= arg1_19.anchoredPosition.y
		end)
		table.Foreach(var0_17, function(arg0_20, arg1_20)
			arg1_20:SetSiblingIndex(arg0_20 - 1)
		end)
	end, 1, -1)

	arg0_10.timer:Start()
	onNextTick(function()
		local var0_21 = arg0_10.activity:GetSlotCount() + 1

		if var0_21 <= #arg0_10.slotTFs then
			local var1_21 = arg0_10.scrollRect.rect.width
			local var2_21 = arg0_10.scrollContent.rect.width
			local var3_21 = arg0_10.scrollRect:Find("Pool")
			local var4_21 = var3_21.anchoredPosition.x + arg0_10.slotTFs[var0_21].anchoredPosition.x + var3_21.rect.width * 0.5
			local var5_21 = math.clamp((var4_21 - var1_21 * 0.5) / var1_0, 0, var2_21 - var1_21)

			setAnchoredPosition(arg0_10.scrollContent, {
				x = var5_21
			})
			_.each(arg0_10.scrollBGs, function(arg0_22)
				arg0_10:UpdateScrollContent(-var5_21, unpack(arg0_22))
			end)
		end
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_10.top)
end

function var0_0.UpdateScrollContent(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	arg1_23 = arg1_23 * arg3_23

	setAnchoredPosition(arg2_23, {
		x = arg1_23 + arg4_23
	})
end

function var0_0.InitSlots(arg0_24)
	arg0_24:CleanSpines()
	table.Foreach(arg0_24.slotTFs, function(arg0_25, arg1_25)
		onButton(arg0_24, arg1_25:Find("Usable"), function()
			arg0_24:emit(NewYearHotSpringMediator.UNLOCK_SLOT, arg0_24.activity.id)
		end, SFX_PANEL)

		local function var0_25()
			local var0_27 = arg0_24.activity:GetShipIds()[arg0_25] or 0
			local var1_27 = var0_27 > 0 and getProxy(BayProxy):RawGetShipById(var0_27)

			arg0_24:emit(NewYearHotSpringMediator.OPEN_CHUANWU, arg0_25, var1_27)
		end

		onButton(arg0_24, arg1_25:Find("Enter"), var0_25, SFX_PANEL)
		onButton(arg0_24, arg1_25:Find("Ship/Click"), function()
			if arg0_24._modelDrag then
				return
			end

			var0_25()
		end, SFX_PANEL)

		local var1_25 = pg.UIMgr.GetInstance().uiCamera:GetComponent(typeof(Camera))
		local var2_25 = arg0_24.scrollRect:Find("Pool")
		local var3_25 = GetComponent(arg1_25:Find("Ship/Click"), "EventTriggerListener")

		var3_25:AddBeginDragFunc(function()
			if arg0_24._modelDrag then
				return
			end

			arg0_24._modelDrag = arg1_25
			arg0_24._currentDragDelegate = var3_25
			arg0_24._lastDragBeginPosition = arg1_25.anchoredPosition

			setParent(arg1_25, arg0_24._tf)

			local var0_29 = arg0_24.spineRoles[arg0_25]

			var0_29:RevertMaterial()
			var0_29:SetAction("tuozhuai")
			setActive(arg1_25:Find("wenquan_bowen"), false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_DRAG)
		end)
		var3_25:AddDragFunc(function(arg0_30, arg1_30)
			if arg0_24._modelDrag ~= arg1_25 then
				return
			end

			local var0_30 = LuaHelper.ScreenToLocal(arg0_24._tf, arg1_30.position, var1_25)

			arg1_25.anchoredPosition = var0_30
		end)
		var3_25:AddDragEndFunc(function(arg0_31, arg1_31)
			if arg0_24._modelDrag ~= arg1_25 then
				return
			end

			arg0_24._modelDrag = false

			local var0_31 = arg0_24._forceDropCharacter

			arg0_24._forceDropCharacter = nil
			arg0_24._currentDragDelegate = nil

			local var1_31 = arg0_24.spineRoles[arg0_25]

			setParent(arg1_25, var2_25, true)

			local function var2_31()
				if arg0_24._lastDragBeginPosition ~= nil then
					arg1_25.anchoredPosition = arg0_24._lastDragBeginPosition
				end
			end

			if var0_31 then
				var2_31()

				return
			end

			local var3_31 = var2_25.rect

			var3_31.center = var3_31.center + Vector2.New(-var3_31.size.x * 0.5)

			local var4_31 = arg1_25.anchoredPosition

			if not var3_31:Contains(var4_31) then
				var4_31 = Vector2.Min(Vector2.Max(var4_31, var3_31.min), var3_31.max)
				arg1_25.anchoredPosition = var4_31
			end

			arg0_24.slotShipPos[arg0_25] = var4_31

			arg0_24:SetSpineWash(var1_31)
			setActive(arg1_25:Find("wenquan_bowen"), true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_PUT)
		end)
	end)
end

function var0_0.UpdateView(arg0_33)
	arg0_33:UpdateSlots()
	setText(arg0_33.top:Find("Ticket/Text"), arg0_33.activity:GetCoins())
end

function var0_0.UpdateSlots(arg0_34)
	arg0_34:CleanSpines()
	table.Foreach(arg0_34.slotTFs, function(arg0_35, arg1_35)
		arg0_34:UpdateSlot(arg0_35, arg1_35)
	end)
end

function var0_0.RectContainsRect(arg0_36, arg1_36)
	return arg0_36:Contains(arg1_36.min) and arg0_36:Contains(arg1_36.max)
end

function var0_0.UpdateSlot(arg0_37, arg1_37, arg2_37)
	local var0_37 = math.clamp(arg1_37 - arg0_37.activity:GetSlotCount(), 0, 2)

	setActive(arg2_37:Find("Lock"), var0_37 == 2)
	setActive(arg2_37:Find("Usable"), var0_37 == 1)

	local var1_37 = arg0_37.activity:GetShipIds()[arg1_37] or 0
	local var2_37 = var0_37 == 0
	local var3_37 = var1_37 > 0 and getProxy(BayProxy):RawGetShipById(var1_37)
	local var4_37 = arg2_37:Find("Ship")

	setActive(arg2_37:Find("Enter"), var2_37 and not var3_37)
	setActive(var4_37, var2_37 and var3_37 and true)

	local var5_37 = (var3_37 and arg0_37.slotShipPos or arg0_37.slotOriginalPos)[arg1_37]

	setAnchoredPosition(arg2_37, var5_37)

	if var3_37 then
		local var6_37 = SpineRole.New()

		var6_37:SetData(var3_37:getPrefab())
		arg0_37:LoadingOn()
		var6_37:Load(function()
			var6_37:SetParent(var4_37:Find("Model"))
			arg0_37:SetSpineWash(var6_37)
			arg0_37:LoadingOff()
		end, true)

		arg0_37.spineRoles[arg1_37] = var6_37
	end
end

function var0_0.SetSpineWash(arg0_39, arg1_39)
	arg1_39:SetAction("wash")
	arg1_39:ChangeMaterial(Object.Instantiate(arg0_39.washMaterial))

	local var0_39 = arg1_39.model.transform.position.y

	arg1_39._modleGraphic.material:SetFloat("_PositionY", var0_39 + 1.5)
end

function var0_0.CleanSpines(arg0_40)
	arg0_40:ForceDropChar()
	table.Foreach(arg0_40.spineRoles, function(arg0_41, arg1_41)
		arg1_41:Dispose()
	end)

	arg0_40.spineRoles = {}
end

function var0_0.ForceDropChar(arg0_42)
	if arg0_42._currentDragDelegate then
		arg0_42._forceDropCharacter = true

		LuaHelper.triggerEndDrag(arg0_42._currentDragDelegate)
	end
end

function var0_0.GetRecordPos(arg0_43)
	local var0_43 = PlayerPrefs.GetString("hotspring_ship_pos", "")
	local var1_43 = _.map(string.split(var0_43, ";"), function(arg0_44)
		return tonumber(arg0_44)
	end)
	local var2_43 = {}

	for iter0_43 = 1, #var1_43, 2 do
		table.insert(var2_43, Vector2.New(var1_43[iter0_43], var1_43[iter0_43 + 1]))
	end

	return var2_43
end

function var0_0.RecordPos(arg0_45, arg1_45)
	if not arg1_45 then
		return
	end

	local var0_45 = table.concat(_.reduce(arg1_45, {}, function(arg0_46, arg1_46)
		table.insert(arg0_46, arg1_46.x)
		table.insert(arg0_46, arg1_46.y)

		return arg0_46
	end), ";")

	PlayerPrefs.SetString("hotspring_ship_pos", var0_45)
end

function var0_0.LoadingOn(arg0_47)
	if arg0_47.animating then
		return
	end

	arg0_47.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0_0.LoadingOff(arg0_48)
	if not arg0_48.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0_48.animating = false
end

function var0_0.willExit(arg0_49)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_49.top, arg0_49._tf)
	Object.Destroy(arg0_49.washMaterial)
	arg0_49:RecordPos(arg0_49.slotShipPos)
	arg0_49:CleanSpines()
	arg0_49.timer:Stop()
	arg0_49:LoadingOff()
end

return var0_0
