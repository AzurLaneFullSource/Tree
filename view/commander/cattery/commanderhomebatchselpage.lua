local var0 = class("CommanderHomeBatchSelPage", import(".CommanderHomeBaseSelPage"))

function var0.getUIName(arg0)
	return "CatteryBatchSelPage"
end

function var0.OnLoaded(arg0)
	arg0.scrollrect = arg0:findTF("page/frame/scrollrect"):GetComponent("LScrollRect")
	arg0.okBtn = arg0:findTF("page/frame/ok_button")
	arg0.uiList = UIItemList.New(arg0:findTF("page/frame/list/content"), arg0:findTF("page/frame/comanderTF"))
	arg0.closeBtn = arg0:findTF("page/close_btn")
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.okBtn, function()
		arg0:Filter()
	end, SFX_PANEL)
end

function var0.Filter(arg0)
	local var0 = arg0.home:GetCatteries()
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.displayCatteries) do
		local var2 = var0[iter0]
		local var3 = var2:ExistCommander()
		local var4 = var2:GetCommanderId()
		local var5 = var2:IsLocked()

		if not var5 and var3 and iter1.commanderId == var4 then
			-- block empty
		elseif not var5 and not var3 and iter1.commanderId == 0 then
			-- block empty
		else
			table.insert(var1, {
				pos = iter0,
				id = iter1.commanderId
			})
		end
	end

	local var6 = {}

	for iter2, iter3 in ipairs(var1) do
		table.insert(var6, function(arg0)
			arg0:emit(CommanderHomeMediator.ON_SEL_COMMANDER, iter3.pos, iter3.id, false, arg0)
		end)
	end

	seriesAsync(var6)
end

function var0.Update(arg0, arg1)
	arg0:Show()

	arg0.home = arg1

	arg0:InitList()
	var0.super.Update(arg0)
	arg0:UpdateSelectedList()
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	arg0:emit(CommanderHomeLayer.DESC_PAGE_OPEN)
end

function var0.InitList(arg0)
	local var0 = arg0.home:GetCatteries()

	arg0.maxCnt = 0
	arg0.displayCatteries = {}

	for iter0, iter1 in pairs(var0) do
		local var1 = iter1:GetState()
		local var2 = iter1:ExistCommander()
		local var3 = var1 == Cattery.STATE_LOCK

		table.insert(arg0.displayCatteries, {
			isLock = var3,
			commanderId = var2 and iter1:GetCommanderId() or 0
		})

		if not var3 then
			arg0.maxCnt = arg0.maxCnt + 1
		end
	end

	arg0.uiList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateSelectedCard(arg1 + 1, arg2)
		end
	end)
end

function var0.UpdateSelectedList(arg0)
	arg0.uiList:align(#arg0.displayCatteries)
end

function var0.UpdateSelectedCard(arg0, arg1, arg2)
	local var0 = arg0.displayCatteries[arg1]
	local var1 = var0.commanderId
	local var2 = getProxy(CommanderProxy):RawGetCommanderById(var1)

	if var2 then
		CommanderCard.New(arg2):update(var2)

		local var3 = arg0:CheckIncludeSelf(var2.id)

		setActive(arg2:Find("info/home"), not var3)
	end

	if not var0.isLock then
		onButton(arg0, arg2, function()
			if var2 then
				var0.commanderId = 0

				arg0:UpdateSelectedCard(arg1, arg2)
				arg0:UpdateCardSelected()
			end
		end, SFX_PANEL)
	end

	setActive(arg2:Find("info"), var2 ~= nil)
	setActive(arg2:Find("lock_b"), var0.isLock)
	setActive(arg2:Find("empty_b"), var2 == nil)
	setActive(arg2:Find("tip"), false)
	setActive(arg2:Find("up"), false)
end

function var0.CheckIncludeSelf(arg0, arg1)
	local var0 = arg0.home:GetCatteries()

	for iter0, iter1 in ipairs(var0) do
		if iter1:GetCommanderId() == arg1 then
			return false
		end
	end

	return true
end

function var0.GetSelectedCommanderList(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.displayCatteries) do
		if not iter1.isLock and iter1.commanderId ~= 0 then
			table.insert(var0, iter1.commanderId)
		end
	end

	return var0
end

function var0.GetEmptyPosIndex(arg0)
	for iter0, iter1 in pairs(arg0.displayCatteries) do
		if not iter1.isLock and iter1.commanderId == 0 then
			return iter0
		end
	end

	return -1
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	var0.super.OnUpdateItem(arg0, arg1, arg2)

	local var0 = arg1 + 1
	local var1 = arg0.displays[var0]
	local var2 = arg0.cards[arg2]
	local var3 = var2.commanderVO and var2.commanderVO.id or 0
	local var4 = arg0:GetSelectedCommanderList()

	setActive(var2._tf:Find("sel_b"), table.contains(var4, var3))

	if var3 > 0 then
		local var5 = arg0:CheckIncludeSelf(var3)

		setActive(var2._tf:Find("info/home"), not var5)
	end
end

function var0.OnSelected(arg0, arg1)
	local var0 = arg0:GetEmptyPosIndex()

	if var0 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_selected_max", arg0.maxCnt))

		return
	end

	local var1 = arg1.commanderVO

	if not var1 then
		return
	end

	local var2 = arg0:GetSelectedCommanderList()

	if not table.contains(var2, var1.id) then
		arg0.displayCatteries[var0].commanderId = var1.id
	else
		for iter0, iter1 in ipairs(arg0.displayCatteries) do
			if iter1.commanderId == var1.id then
				arg0.displayCatteries[iter0].commanderId = 0

				break
			end
		end
	end

	arg0:UpdateCardSelected()
	arg0:UpdateSelectedList()
end

function var0.UpdateCardSelected(arg0)
	local var0 = arg0:GetSelectedCommanderList()

	for iter0, iter1 in pairs(arg0.cards) do
		local var1 = iter1.commanderVO and iter1.commanderVO.id or 0

		setActive(iter1._tf:Find("sel_b"), table.contains(var0, var1))
	end
end

function var0.Hide(arg0)
	arg0:emit(CommanderHomeLayer.DESC_PAGE_CLOSE)
	var0.super.Hide(arg0)
end

return var0
