local var0_0 = class("ReversePacmanBuffControl")
local var1_0 = 155

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1._tpls = arg0_1._tf:Find("tpls")
	arg0_1.container = arg0_1._tf:Find("map")
	arg0_1.selectPanel = arg0_1._tf:Find("map/select")

	setActive(arg0_1.selectPanel, false)

	arg0_1.bubbleTF = arg0_1._tf:Find("map/bubble")

	setActive(arg0_1.bubbleTF, false)

	arg0_1.uiList = UIItemList.New(arg0_1._tf:Find("buffs/list"), arg0_1._tf:Find("buffs/list/tpl"))
end

function var0_0.SetUp(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.map = arg3_2
	arg0_2.gameController = arg4_2
	arg0_2.buffIds = {}
	arg0_2.buffCntDic = {}

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		if iter1_2 ~= 0 then
			table.insert(arg0_2.buffIds, iter1_2)

			arg0_2.buffCntDic[iter1_2] = arg2_2[iter0_2]
		end
	end

	arg0_2.uiList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg0_2.buffIds[arg1_3 + 1]

			arg0_2:UpdataBuffTpl(var0_3, arg2_3)
		end
	end)
	arg0_2.uiList:align(#arg0_2.buffIds)
	arg0_2:AddListener()
end

function var0_0.AddListener(arg0_4)
	onButton(arg0_4.binder, arg0_4.selectPanel:Find("cancel"), function()
		arg0_4:HideSelectPanel()
	end)
	onButton(arg0_4.binder, arg0_4.selectPanel:Find("ok/sure"), function()
		if not arg0_4.gameController:CanCastBuff(arg0_4.selectedId, arg0_4.selectCell) then
			return
		end

		arg0_4:CastBuff(arg0_4.selectedId, arg0_4.selectCell)
		arg0_4.binder:emit(ReversePacmanConst.EVENT.CAST, {
			buffId = arg0_4.selectedId,
			cell = arg0_4.selectCell
		})
	end)
	arg0_4.binder:bind(ReversePacmanConst.EVENT.PICK, function(arg0_7, arg1_7)
		local var0_7 = arg0_4.map:GetCellByLocalPos({
			x = arg1_7.ship.x,
			y = arg1_7.ship.y
		})

		arg0_4:ShowBubble(arg1_7.buff.id, var0_7)
	end)
	arg0_4:AddDragMove()
end

function var0_0.AddDragMove(arg0_8)
	local var0_8 = arg0_8.selectPanel:Find("move")
	local var1_8 = GetOrAddComponent(var0_8, typeof(EventTriggerListener))
	local var2_8 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))

	local function var3_8(arg0_9)
		local var0_9 = LuaHelper.ScreenToLocal(arg0_8.container, arg0_9, var2_8)
		local var1_9 = arg0_8.map:GetCellByLocalPos({
			x = var0_9.x,
			y = var0_9.y + var1_0
		})

		if not var1_9 then
			return
		end

		arg0_8:SetSelectCell(var1_9)
	end

	var1_8:AddBeginDragFunc(function(arg0_10, arg1_10)
		var3_8(arg1_10.position)
	end)
	var1_8:AddDragFunc(function(arg0_11, arg1_11)
		var3_8(arg1_11.position)
	end)
end

function var0_0.SetSelectCell(arg0_12, arg1_12)
	arg0_12.selectCell = arg1_12

	setLocalPosition(arg0_12.selectPanel, arg0_12.map:GetLocalPosInMap(arg1_12.x, arg1_12.y))

	local var0_12 = arg0_12.gameController:CanCastBuff(arg0_12.selectedId, arg1_12)

	setActive(arg0_12.selectPanel:Find("ok"), var0_12)
	setActive(arg0_12.selectPanel:Find("no"), not var0_12)
end

function var0_0.UpdataBuffTpl(arg0_13, arg1_13, arg2_13)
	arg2_13.name = arg1_13

	local var0_13 = pg.activity_chasing_skill[arg1_13]

	setText(arg2_13:Find("name"), var0_13.name)
	LoadImageSpriteAsync(var0_13.icon, arg2_13:Find("icon"))

	local var1_13 = arg0_13.buffCntDic[arg1_13]

	setText(arg2_13:Find("icon/corner/Text"), arg0_13.buffCntDic[arg1_13])
	setTextColor(arg2_13:Find("icon/corner/Text"), var1_13 > 0 and Color.NewHex("#FFFFFF") or Color.NewHex("#FF6D6D"))
	setTextColor(arg2_13:Find("name"), var1_13 > 0 and Color.NewHex("#FFFFFF") or Color.NewHex("#7C7E81"))
	onButton(arg0_13.binder, arg2_13, function()
		if var1_13 <= 0 then
			return
		end

		if LeanTween.isTweening(go(arg2_13:Find("icon/mask"))) then
			return
		end

		arg0_13:ShowSelectPanel(arg1_13)
	end)
end

function var0_0.ShowSelectPanel(arg0_15, arg1_15)
	arg0_15.selectedId = arg1_15

	local var0_15 = arg0_15.selectPanel:Find("icon")

	LoadImageSpriteAtlasAsync("ui/reversepacmanui_atlas", "game_icon_buff_" .. arg0_15.selectedId, var0_15, true)
	setImageAlpha(var0_15, 1)
	blinkAni(go(var0_15), 0.2)
	arg0_15:SetSelectCell(arg0_15.map:GetCenterCell())
	setActive(arg0_15.selectPanel, true)
end

function var0_0.HideSelectPanel(arg0_16)
	setActive(arg0_16.selectPanel, false)

	local var0_16 = arg0_16.selectPanel:Find("icon")

	if LeanTween.isTweening(go(var0_16)) then
		LeanTween.cancel(go(var0_16))
	end
end

function var0_0.CastBuff(arg0_17, arg1_17, arg2_17)
	if arg1_17 == ReversePacmanConst.BUFF.BLOCK then
		arg0_17:ShowBubble(arg1_17, arg2_17)
	end

	arg0_17:SetBuffCD(arg1_17)
	arg0_17:HideSelectPanel()
end

function var0_0.GetBubbleTip(arg0_18, arg1_18)
	if arg1_18 == ReversePacmanConst.BUFF.BLOCK then
		return i18n("reverse_pacman_cast_block")
	elseif arg1_18 == ReversePacmanConst.BUFF.SPEED then
		return i18n("reverse_pacman_pick_speed")
	elseif arg1_18 == ReversePacmanConst.BUFF.GIANT then
		return i18n("reverse_pacman_pick_giant")
	end

	return ""
end

function var0_0.ShowBubble(arg0_19, arg1_19, arg2_19, arg3_19)
	if LeanTween.isTweening(go(arg0_19.bubbleTF)) then
		LeanTween.cancel(go(arg0_19.bubbleTF))
	end

	setActive(arg0_19.bubbleTF, true)
	setText(arg0_19.bubbleTF:Find("Text"), arg0_19:GetBubbleTip(arg1_19))

	local var0_19 = arg0_19.map:GetLocalPosInMap(arg2_19.x, arg2_19.y)

	setLocalPosition(arg0_19.bubbleTF, var0_19)
	setCanvasGroupAlpha(arg0_19.bubbleTF, 1)

	local var1_19 = 80
	local var2_19 = arg0_19.gameController:GetGameplayDuration(1)

	LeanTween.moveLocalY(go(arg0_19.bubbleTF), var0_19.y + var1_19, var2_19):setEase(LeanTweenType.easeOutCubic)

	local var3_19 = GetOrAddComponent(arg0_19.bubbleTF, typeof(CanvasGroup))

	LeanTween.alphaCanvas(var3_19, 0, var2_19 * 0.6):setDelay(var2_19 * 0.4):setOnComplete(System.Action(function()
		setActive(arg0_19.bubbleTF, false)
	end))
end

function var0_0.SetBuffCD(arg0_21, arg1_21)
	arg0_21.buffCntDic[arg1_21] = arg0_21.buffCntDic[arg1_21] - 1

	local var0_21 = arg0_21.uiList.container:Find(tostring(arg1_21))

	if arg0_21.buffCntDic[arg1_21] <= 0 then
		arg0_21:UpdataBuffTpl(arg1_21, var0_21)

		return
	end

	local var1_21 = arg0_21.gameController:GetGameplayDuration(pg.activity_chasing_skill[arg1_21].cd)
	local var2_21 = var0_21:Find("icon/mask")
	local var3_21 = var2_21:GetComponent(typeof(Image))

	setActive(var2_21, true)
	setTextColor(var0_21:Find("name"), Color.NewHex("#7C7E81"))
	LeanTween.value(go(var2_21), 1, 0, var1_21):setOnUpdate(System.Action_float(function(arg0_22)
		var3_21.fillAmount = arg0_22
	end)):setOnComplete(System.Action(function()
		setActive(var2_21, false)
		arg0_21:UpdataBuffTpl(arg1_21, var0_21)
	end))
end

function var0_0.Update(arg0_24, arg1_24)
	return
end

function var0_0.Dispose(arg0_25)
	arg0_25.uiList:eachActive(function(arg0_26, arg1_26)
		if LeanTween.isTweening(go(arg1_26:Find("icon/mask"))) then
			LeanTween.cancel(go(arg1_26:Find("icon/mask")))
		end
	end)

	if LeanTween.isTweening(go(arg0_25.bubbleTF)) then
		LeanTween.cancel(go(arg0_25.bubbleTF))
	end
end

return var0_0
