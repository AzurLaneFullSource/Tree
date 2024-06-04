local var0 = class("AttireFramePanel", import("...base.BaseSubView"))

function var0.Card(arg0)
	local var0 = {}

	local function var1(arg0)
		arg0._go = arg0
		arg0._tf = tf(arg0)
		arg0.mark = arg0._tf:Find("info/mark")
		arg0.print5 = arg0._tf:Find("prints/line5")
		arg0.print6 = arg0._tf:Find("prints/line6")
		arg0.emptyTF = arg0._tf:Find("empty")
		arg0.infoTF = arg0._tf:Find("info")
		arg0.tags = {
			arg0._tf:Find("info/tags/e"),
			arg0._tf:Find("info/tags/new")
		}
		arg0.icon = arg0._tf:Find("info/icon")
		arg0.mask = arg0._tf:Find("info/mask")
	end

	function var0.isEmpty(arg0)
		return not arg0.attireFrame or arg0.attireFrame.id == -1
	end

	local function var2(arg0, arg1, arg2)
		arg0.state = arg1:getState()

		_.each(arg0.tags, function(arg0)
			setActive(arg0, false)
		end)
		setActive(arg0.mask, arg0.state == AttireFrame.STATE_LOCK)

		local var0 = arg2:getAttireByType(arg1:getType())

		setActive(arg0.tags[1], arg0.state == AttireFrame.STATE_UNLOCK and var0 == arg1.id)
		setActive(arg0.tags[2], arg0.state == AttireFrame.STATE_UNLOCK and arg1:isNew())
	end

	function var0.Update(arg0, arg1, arg2, arg3)
		arg0:UpdateSelected(false)

		arg0.attireFrame = arg1

		local var0 = arg0:isEmpty()

		if not var0 then
			var2(arg0, arg1, arg2)
		end

		setActive(arg0.infoTF, not var0)
		setActive(arg0.emptyTF, var0)
		setActive(arg0.print5, not arg3)
		setActive(arg0.print6, not arg3)
	end

	function var0.LoadPrefab(arg0, arg1, arg2)
		local var0 = arg1:getType()
		local var1 = arg1:getIcon()
		local var2 = arg1:getPrefabName()

		PoolMgr.GetInstance():GetPrefab(var1, var2, true, function(arg0)
			if not arg0.icon then
				local var0

				if var0 == AttireConst.TYPE_ICON_FRAME then
					var0 = IconFrame.GetIcon(var2)
				elseif var0 == AttireConst.TYPE_CHAT_FRAME then
					var0 = ChatFrame.GetIcon(var2)
				end

				PoolMgr.GetInstance():ReturnPrefab(var0, var2, arg0)
			else
				arg0.name = var2

				setParent(arg0, arg0.icon, false)

				local var1

				var1 = arg1:getState() == AttireFrame.STATE_LOCK

				arg2(arg0)
			end
		end)
	end

	function var0.ReturnIconFrame(arg0, arg1)
		eachChild(arg0.icon, function(arg0)
			local var0 = arg0.gameObject.name
			local var1

			if arg1 == AttireConst.TYPE_ICON_FRAME then
				var1 = IconFrame.GetIcon(var0)
			elseif arg1 == AttireConst.TYPE_CHAT_FRAME then
				var1 = ChatFrame.GetIcon(var0)
			end

			assert(var1)
			PoolMgr.GetInstance():ReturnPrefab(var1, var0, arg0.gameObject)
		end)
	end

	function var0.UpdateSelected(arg0, arg1)
		setActive(arg0.mark, arg1)
	end

	function var0.Dispose(arg0)
		return
	end

	var1(var0)

	return var0
end

function var0.getUIName(arg0)
	assert(false)
end

function var0.GetData(arg0)
	assert(false)
end

function var0.OnInit(arg0)
	arg0.listPanel = arg0:findTF("list_panel")
	arg0.scolrect = arg0:findTF("scrollrect", arg0.listPanel):GetComponent("LScrollRect")

	function arg0.scolrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scolrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	arg0.cards = {}

	local var0 = arg0:findTF("desc_panel")

	arg0.descPanel = AttireDescPanel.New(var0)
	arg0.totalCount = arg0:findTF("total_count/Text"):GetComponent(typeof(Text))
end

function var0.OnInitItem(arg0, arg1)
	assert(false)
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displayVOs[arg1 + 1]
	local var2 = arg1 < arg0.scolrect.content:GetComponent(typeof(GridLayoutGroup)).constraintCount

	var0:Update(var1, arg0.playerVO, var2)
end

function var0.Update(arg0, arg1, arg2)
	arg0.playerVO = arg2
	arg0.rawAttireVOs = arg1

	local var0, var1 = arg0:GetDisplayVOs()

	arg0.displayVOs = var0

	arg0:Filter()

	arg0.totalCount.text = var1
end

function var0.GetDisplayVOs(arg0)
	local var0 = {}
	local var1 = 0

	for iter0, iter1 in pairs(arg0:GetData()) do
		table.insert(var0, iter1)

		if iter1:getState() == AttireFrame.STATE_UNLOCK and iter1.id > 0 then
			var1 = var1 + 1
		end
	end

	return var0, var1
end

function var0.Filter(arg0)
	if #arg0.displayVOs == 0 then
		return
	end

	local var0 = arg0.playerVO:getAttireByType(arg0.displayVOs[1]:getType())

	table.sort(arg0.displayVOs, function(arg0, arg1)
		local var0 = var0 == arg0.id and 1 or 0
		local var1 = var0 == arg1.id and 1 or 0

		if var0 == 1 then
			return true
		elseif var1 == 1 then
			return false
		end

		local var2 = arg0:getState()
		local var3 = arg1:getState()

		if var2 == var3 then
			return arg0.id < arg1.id
		else
			return var3 < var2
		end
	end)

	local var1 = arg0.scolrect.content:GetComponent(typeof(GridLayoutGroup)).constraintCount
	local var2 = var1 - #arg0.displayVOs % var1

	if var2 == var1 then
		var2 = 0
	end

	local var3 = var1 * arg0:GetColumn()

	if var3 > #arg0.displayVOs then
		var2 = var3 - #arg0.displayVOs
	end

	for iter0 = 1, var2 do
		table.insert(arg0.displayVOs, {
			id = -1
		})
	end

	arg0.scolrect:SetTotalCount(#arg0.displayVOs, 0)
end

function var0.UpdateDesc(arg0, arg1)
	if arg1:isEmpty() then
		return
	end

	if not arg0.descPanel then
		arg0.descPanel = AttireDescPanel.New(arg0.descPanelTF)
	end

	arg0.descPanel:Update(arg1.attireFrame, arg0.playerVO)
	onButton(arg0, arg0.descPanel.applyBtn, function()
		local var0 = arg1.attireFrame:getType()

		arg0:emit(AttireMediator.ON_APPLY, var0, arg1.attireFrame.id)
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	arg0.descPanel:Dispose()
end

return var0
