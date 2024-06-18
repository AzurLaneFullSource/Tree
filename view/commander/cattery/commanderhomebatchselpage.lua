local var0_0 = class("CommanderHomeBatchSelPage", import(".CommanderHomeBaseSelPage"))

function var0_0.getUIName(arg0_1)
	return "CatteryBatchSelPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scrollrect = arg0_2:findTF("page/frame/scrollrect"):GetComponent("LScrollRect")
	arg0_2.okBtn = arg0_2:findTF("page/frame/ok_button")
	arg0_2.uiList = UIItemList.New(arg0_2:findTF("page/frame/list/content"), arg0_2:findTF("page/frame/comanderTF"))
	arg0_2.closeBtn = arg0_2:findTF("page/close_btn")
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.okBtn, function()
		arg0_3:Filter()
	end, SFX_PANEL)
end

function var0_0.Filter(arg0_7)
	local var0_7 = arg0_7.home:GetCatteries()
	local var1_7 = {}

	for iter0_7, iter1_7 in ipairs(arg0_7.displayCatteries) do
		local var2_7 = var0_7[iter0_7]
		local var3_7 = var2_7:ExistCommander()
		local var4_7 = var2_7:GetCommanderId()
		local var5_7 = var2_7:IsLocked()

		if not var5_7 and var3_7 and iter1_7.commanderId == var4_7 then
			-- block empty
		elseif not var5_7 and not var3_7 and iter1_7.commanderId == 0 then
			-- block empty
		else
			table.insert(var1_7, {
				pos = iter0_7,
				id = iter1_7.commanderId
			})
		end
	end

	local var6_7 = {}

	for iter2_7, iter3_7 in ipairs(var1_7) do
		table.insert(var6_7, function(arg0_8)
			arg0_7:emit(CommanderHomeMediator.ON_SEL_COMMANDER, iter3_7.pos, iter3_7.id, false, arg0_8)
		end)
	end

	seriesAsync(var6_7)
end

function var0_0.Update(arg0_9, arg1_9)
	arg0_9:Show()

	arg0_9.home = arg1_9

	arg0_9:InitList()
	var0_0.super.Update(arg0_9)
	arg0_9:UpdateSelectedList()
end

function var0_0.Show(arg0_10)
	var0_0.super.Show(arg0_10)
	arg0_10:emit(CommanderHomeLayer.DESC_PAGE_OPEN)
end

function var0_0.InitList(arg0_11)
	local var0_11 = arg0_11.home:GetCatteries()

	arg0_11.maxCnt = 0
	arg0_11.displayCatteries = {}

	for iter0_11, iter1_11 in pairs(var0_11) do
		local var1_11 = iter1_11:GetState()
		local var2_11 = iter1_11:ExistCommander()
		local var3_11 = var1_11 == Cattery.STATE_LOCK

		table.insert(arg0_11.displayCatteries, {
			isLock = var3_11,
			commanderId = var2_11 and iter1_11:GetCommanderId() or 0
		})

		if not var3_11 then
			arg0_11.maxCnt = arg0_11.maxCnt + 1
		end
	end

	arg0_11.uiList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			arg0_11:UpdateSelectedCard(arg1_12 + 1, arg2_12)
		end
	end)
end

function var0_0.UpdateSelectedList(arg0_13)
	arg0_13.uiList:align(#arg0_13.displayCatteries)
end

function var0_0.UpdateSelectedCard(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.displayCatteries[arg1_14]
	local var1_14 = var0_14.commanderId
	local var2_14 = getProxy(CommanderProxy):RawGetCommanderById(var1_14)

	if var2_14 then
		CommanderCard.New(arg2_14):update(var2_14)

		local var3_14 = arg0_14:CheckIncludeSelf(var2_14.id)

		setActive(arg2_14:Find("info/home"), not var3_14)
	end

	if not var0_14.isLock then
		onButton(arg0_14, arg2_14, function()
			if var2_14 then
				var0_14.commanderId = 0

				arg0_14:UpdateSelectedCard(arg1_14, arg2_14)
				arg0_14:UpdateCardSelected()
			end
		end, SFX_PANEL)
	end

	setActive(arg2_14:Find("info"), var2_14 ~= nil)
	setActive(arg2_14:Find("lock_b"), var0_14.isLock)
	setActive(arg2_14:Find("empty_b"), var2_14 == nil)
	setActive(arg2_14:Find("tip"), false)
	setActive(arg2_14:Find("up"), false)
end

function var0_0.CheckIncludeSelf(arg0_16, arg1_16)
	local var0_16 = arg0_16.home:GetCatteries()

	for iter0_16, iter1_16 in ipairs(var0_16) do
		if iter1_16:GetCommanderId() == arg1_16 then
			return false
		end
	end

	return true
end

function var0_0.GetSelectedCommanderList(arg0_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.displayCatteries) do
		if not iter1_17.isLock and iter1_17.commanderId ~= 0 then
			table.insert(var0_17, iter1_17.commanderId)
		end
	end

	return var0_17
end

function var0_0.GetEmptyPosIndex(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.displayCatteries) do
		if not iter1_18.isLock and iter1_18.commanderId == 0 then
			return iter0_18
		end
	end

	return -1
end

function var0_0.OnUpdateItem(arg0_19, arg1_19, arg2_19)
	var0_0.super.OnUpdateItem(arg0_19, arg1_19, arg2_19)

	local var0_19 = arg1_19 + 1
	local var1_19 = arg0_19.displays[var0_19]
	local var2_19 = arg0_19.cards[arg2_19]
	local var3_19 = var2_19.commanderVO and var2_19.commanderVO.id or 0
	local var4_19 = arg0_19:GetSelectedCommanderList()

	setActive(var2_19._tf:Find("sel_b"), table.contains(var4_19, var3_19))

	if var3_19 > 0 then
		local var5_19 = arg0_19:CheckIncludeSelf(var3_19)

		setActive(var2_19._tf:Find("info/home"), not var5_19)
	end
end

function var0_0.OnSelected(arg0_20, arg1_20)
	local var0_20 = arg0_20:GetEmptyPosIndex()

	if var0_20 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_selected_max", arg0_20.maxCnt))

		return
	end

	local var1_20 = arg1_20.commanderVO

	if not var1_20 then
		return
	end

	local var2_20 = arg0_20:GetSelectedCommanderList()

	if not table.contains(var2_20, var1_20.id) then
		arg0_20.displayCatteries[var0_20].commanderId = var1_20.id
	else
		for iter0_20, iter1_20 in ipairs(arg0_20.displayCatteries) do
			if iter1_20.commanderId == var1_20.id then
				arg0_20.displayCatteries[iter0_20].commanderId = 0

				break
			end
		end
	end

	arg0_20:UpdateCardSelected()
	arg0_20:UpdateSelectedList()
end

function var0_0.UpdateCardSelected(arg0_21)
	local var0_21 = arg0_21:GetSelectedCommanderList()

	for iter0_21, iter1_21 in pairs(arg0_21.cards) do
		local var1_21 = iter1_21.commanderVO and iter1_21.commanderVO.id or 0

		setActive(iter1_21._tf:Find("sel_b"), table.contains(var0_21, var1_21))
	end
end

function var0_0.Hide(arg0_22)
	arg0_22:emit(CommanderHomeLayer.DESC_PAGE_CLOSE)
	var0_0.super.Hide(arg0_22)
end

return var0_0
