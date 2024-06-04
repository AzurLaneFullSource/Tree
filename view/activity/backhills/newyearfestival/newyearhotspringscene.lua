local var0 = class("NewYearHotSpringScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "NewYearHotSpringUI"
end

local var1 = 0.85

function var0.init(arg0)
	arg0.scrollRect = arg0._tf:Find("ScrollRect")
	arg0.scrollContent = arg0.scrollRect:GetComponent(typeof(ScrollRect)).content
	arg0.slotTFs = _.map(_.range(4, 13), function(arg0)
		return arg0.scrollRect:Find("Pool"):GetChild(arg0 - 1)
	end)
	arg0.slotOriginalPos = _.map(arg0.slotTFs, function(arg0)
		return arg0.anchoredPosition
	end)
	arg0.slotShipPos = Clone(arg0.slotOriginalPos)

	table.Foreach(arg0:GetRecordPos(), function(arg0, arg1)
		arg0.slotShipPos[arg0] = arg1
	end)

	arg0.poolItems = _.map(_.range(arg0.scrollRect:Find("Pool").childCount), function(arg0)
		return arg0.scrollRect:Find("Pool"):GetChild(arg0 - 1)
	end)

	Canvas.ForceUpdateCanvases()

	arg0.scrollBGs = _.map({
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
			var1
		},
		{
			"Pool",
			var1
		},
		{
			"4",
			1
		},
		{
			"5",
			1
		}
	}, function(arg0)
		local var0 = {
			arg0.scrollRect:Find(arg0[1]),
			arg0[2]
		}

		var0[3] = var0[1].anchoredPosition.x

		arg0:UpdateScrollContent(0, unpack(var0))

		return var0
	end)
	arg0.top = arg0._tf:Find("Top")

	pg.ViewUtils.SetSortingOrder(arg0._tf, -1001)

	arg0.spineRoles = {}
	arg0.washMaterial = Material.New(pg.ShaderMgr.GetInstance():GetShader("M02/Unlit_Colored_Semitransparent"))

	arg0.washMaterial:SetFloat("_Height", 0.5)
end

function var0.SetActivity(arg0, arg1)
	local var0 = arg0.activity

	arg0.activity = arg1

	if not var0 then
		return
	end

	table.Foreach(var0:GetShipIds(), function(arg0, arg1)
		if arg1 > 0 and (arg1:GetShipIds()[arg0] or 0) == 0 then
			arg0.slotShipPos[arg0] = Clone(arg0.slotOriginalPos[arg0])
		end
	end)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Top/Back"), function()
		arg0:closeView()
	end, SOUND_BACK)
	onButton(arg0, arg0._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hotspring_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Top/Manage"), function()
		arg0:emit(NewYearHotSpringMediator.OPEN_INFO)
	end, SFX_PANEL)

	local var0 = string.split(i18n("hotspring_buff"), "|")

	assert(var0)
	onButton(arg0, arg0._tf:Find("Top/Buff"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideIconBG = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			iconPath = {
				"UI/NewYearHotSpringUI_atlas",
				"buff_hotspring"
			},
			name = var0[1],
			content = var0[2]
		})
	end, SFX_PANEL)
	onScroll(arg0, arg0.scrollRect, function(arg0)
		_.each(arg0.scrollBGs, function(arg0)
			arg0:UpdateScrollContent(arg0.scrollContent.anchoredPosition.x, unpack(arg0))
		end)
	end)
	arg0:InitSlots()
	arg0:UpdateView()

	arg0.timer = FrameTimer.New(function()
		local var0 = _.map(_.range(arg0.scrollRect:Find("Pool").childCount), function(arg0)
			return arg0.scrollRect:Find("Pool"):GetChild(arg0 - 1)
		end)

		mergeSort(var0, function(arg0, arg1)
			return arg0.anchoredPosition.y >= arg1.anchoredPosition.y
		end)
		table.Foreach(var0, function(arg0, arg1)
			arg1:SetSiblingIndex(arg0 - 1)
		end)
	end, 1, -1)

	arg0.timer:Start()
	onNextTick(function()
		local var0 = arg0.activity:GetSlotCount() + 1

		if var0 <= #arg0.slotTFs then
			local var1 = arg0.scrollRect.rect.width
			local var2 = arg0.scrollContent.rect.width
			local var3 = arg0.scrollRect:Find("Pool")
			local var4 = var3.anchoredPosition.x + arg0.slotTFs[var0].anchoredPosition.x + var3.rect.width * 0.5
			local var5 = math.clamp((var4 - var1 * 0.5) / var1, 0, var2 - var1)

			setAnchoredPosition(arg0.scrollContent, {
				x = var5
			})
			_.each(arg0.scrollBGs, function(arg0)
				arg0:UpdateScrollContent(-var5, unpack(arg0))
			end)
		end
	end)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top)
end

function var0.UpdateScrollContent(arg0, arg1, arg2, arg3, arg4)
	arg1 = arg1 * arg3

	setAnchoredPosition(arg2, {
		x = arg1 + arg4
	})
end

function var0.InitSlots(arg0)
	arg0:CleanSpines()
	table.Foreach(arg0.slotTFs, function(arg0, arg1)
		onButton(arg0, arg1:Find("Usable"), function()
			arg0:emit(NewYearHotSpringMediator.UNLOCK_SLOT, arg0.activity.id)
		end, SFX_PANEL)

		local function var0()
			local var0 = arg0.activity:GetShipIds()[arg0] or 0
			local var1 = var0 > 0 and getProxy(BayProxy):RawGetShipById(var0)

			arg0:emit(NewYearHotSpringMediator.OPEN_CHUANWU, arg0, var1)
		end

		onButton(arg0, arg1:Find("Enter"), var0, SFX_PANEL)
		onButton(arg0, arg1:Find("Ship/Click"), function()
			if arg0._modelDrag then
				return
			end

			var0()
		end, SFX_PANEL)

		local var1 = pg.UIMgr.GetInstance().uiCamera:GetComponent(typeof(Camera))
		local var2 = arg0.scrollRect:Find("Pool")
		local var3 = GetComponent(arg1:Find("Ship/Click"), "EventTriggerListener")

		var3:AddBeginDragFunc(function()
			if arg0._modelDrag then
				return
			end

			arg0._modelDrag = arg1
			arg0._currentDragDelegate = var3
			arg0._lastDragBeginPosition = arg1.anchoredPosition

			setParent(arg1, arg0._tf)

			local var0 = arg0.spineRoles[arg0]

			var0:RevertMaterial()
			var0:SetAction("tuozhuai")
			setActive(arg1:Find("wenquan_bowen"), false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_DRAG)
		end)
		var3:AddDragFunc(function(arg0, arg1)
			if arg0._modelDrag ~= arg1 then
				return
			end

			local var0 = LuaHelper.ScreenToLocal(arg0._tf, arg1.position, var1)

			arg1.anchoredPosition = var0
		end)
		var3:AddDragEndFunc(function(arg0, arg1)
			if arg0._modelDrag ~= arg1 then
				return
			end

			arg0._modelDrag = false

			local var0 = arg0._forceDropCharacter

			arg0._forceDropCharacter = nil
			arg0._currentDragDelegate = nil

			local var1 = arg0.spineRoles[arg0]

			setParent(arg1, var2, true)

			local function var2()
				if arg0._lastDragBeginPosition ~= nil then
					arg1.anchoredPosition = arg0._lastDragBeginPosition
				end
			end

			if var0 then
				var2()

				return
			end

			local var3 = var2.rect

			var3.center = var3.center + Vector2.New(-var3.size.x * 0.5)

			local var4 = arg1.anchoredPosition

			if not var3:Contains(var4) then
				var4 = Vector2.Min(Vector2.Max(var4, var3.min), var3.max)
				arg1.anchoredPosition = var4
			end

			arg0.slotShipPos[arg0] = var4

			arg0:SetSpineWash(var1)
			setActive(arg1:Find("wenquan_bowen"), true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_PUT)
		end)
	end)
end

function var0.UpdateView(arg0)
	arg0:UpdateSlots()
	setText(arg0.top:Find("Ticket/Text"), arg0.activity:GetCoins())
end

function var0.UpdateSlots(arg0)
	arg0:CleanSpines()
	table.Foreach(arg0.slotTFs, function(arg0, arg1)
		arg0:UpdateSlot(arg0, arg1)
	end)
end

function var0.RectContainsRect(arg0, arg1)
	return arg0:Contains(arg1.min) and arg0:Contains(arg1.max)
end

function var0.UpdateSlot(arg0, arg1, arg2)
	local var0 = math.clamp(arg1 - arg0.activity:GetSlotCount(), 0, 2)

	setActive(arg2:Find("Lock"), var0 == 2)
	setActive(arg2:Find("Usable"), var0 == 1)

	local var1 = arg0.activity:GetShipIds()[arg1] or 0
	local var2 = var0 == 0
	local var3 = var1 > 0 and getProxy(BayProxy):RawGetShipById(var1)
	local var4 = arg2:Find("Ship")

	setActive(arg2:Find("Enter"), var2 and not var3)
	setActive(var4, var2 and var3 and true)

	local var5 = (var3 and arg0.slotShipPos or arg0.slotOriginalPos)[arg1]

	setAnchoredPosition(arg2, var5)

	if var3 then
		local var6 = SpineRole.New()

		var6:SetData(var3:getPrefab())
		arg0:LoadingOn()
		var6:Load(function()
			var6:SetParent(var4:Find("Model"))
			arg0:SetSpineWash(var6)
			arg0:LoadingOff()
		end, true)

		arg0.spineRoles[arg1] = var6
	end
end

function var0.SetSpineWash(arg0, arg1)
	arg1:SetAction("wash")
	arg1:ChangeMaterial(Object.Instantiate(arg0.washMaterial))

	local var0 = arg1.model.transform.position.y

	arg1._modleGraphic.material:SetFloat("_PositionY", var0 + 1.5)
end

function var0.CleanSpines(arg0)
	arg0:ForceDropChar()
	table.Foreach(arg0.spineRoles, function(arg0, arg1)
		arg1:Dispose()
	end)

	arg0.spineRoles = {}
end

function var0.ForceDropChar(arg0)
	if arg0._currentDragDelegate then
		arg0._forceDropCharacter = true

		LuaHelper.triggerEndDrag(arg0._currentDragDelegate)
	end
end

function var0.GetRecordPos(arg0)
	local var0 = PlayerPrefs.GetString("hotspring_ship_pos", "")
	local var1 = _.map(string.split(var0, ";"), function(arg0)
		return tonumber(arg0)
	end)
	local var2 = {}

	for iter0 = 1, #var1, 2 do
		table.insert(var2, Vector2.New(var1[iter0], var1[iter0 + 1]))
	end

	return var2
end

function var0.RecordPos(arg0, arg1)
	if not arg1 then
		return
	end

	local var0 = table.concat(_.reduce(arg1, {}, function(arg0, arg1)
		table.insert(arg0, arg1.x)
		table.insert(arg0, arg1.y)

		return arg0
	end), ";")

	PlayerPrefs.SetString("hotspring_ship_pos", var0)
end

function var0.LoadingOn(arg0)
	if arg0.animating then
		return
	end

	arg0.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0.LoadingOff(arg0)
	if not arg0.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0.animating = false
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.top, arg0._tf)
	Object.Destroy(arg0.washMaterial)
	arg0:RecordPos(arg0.slotShipPos)
	arg0:CleanSpines()
	arg0.timer:Stop()
	arg0:LoadingOff()
end

return var0
