local var0_0 = class("AttireFramePanel", import("...base.BaseSubView"))

function var0_0.Card(arg0_1)
	local var0_1 = {}

	local function var1_1(arg0_2)
		arg0_2._go = arg0_1
		arg0_2._tf = tf(arg0_1)
		arg0_2.mark = arg0_2._tf:Find("info/mark")
		arg0_2.print5 = arg0_2._tf:Find("prints/line5")
		arg0_2.print6 = arg0_2._tf:Find("prints/line6")
		arg0_2.emptyTF = arg0_2._tf:Find("empty")
		arg0_2.infoTF = arg0_2._tf:Find("info")
		arg0_2.tags = {
			arg0_2._tf:Find("info/tags/e"),
			arg0_2._tf:Find("info/tags/new")
		}
		arg0_2.icon = arg0_2._tf:Find("info/icon")
		arg0_2.mask = arg0_2._tf:Find("info/mask")
	end

	function var0_1.isEmpty(arg0_3)
		return not arg0_3.attireFrame or arg0_3.attireFrame.id == -1
	end

	local function var2_1(arg0_4, arg1_4, arg2_4)
		arg0_4.state = arg1_4:getState()

		_.each(arg0_4.tags, function(arg0_5)
			setActive(arg0_5, false)
		end)
		setActive(arg0_4.mask, arg0_4.state == AttireFrame.STATE_LOCK)

		local var0_4 = arg2_4:getAttireByType(arg1_4:getType())

		setActive(arg0_4.tags[1], arg0_4.state == AttireFrame.STATE_UNLOCK and var0_4 == arg1_4.id)
		setActive(arg0_4.tags[2], arg0_4.state == AttireFrame.STATE_UNLOCK and arg1_4:isNew())
	end

	function var0_1.Update(arg0_6, arg1_6, arg2_6, arg3_6)
		arg0_6:UpdateSelected(false)

		arg0_6.attireFrame = arg1_6

		local var0_6 = arg0_6:isEmpty()

		if not var0_6 then
			var2_1(arg0_6, arg1_6, arg2_6)
		end

		setActive(arg0_6.infoTF, not var0_6)
		setActive(arg0_6.emptyTF, var0_6)
		setActive(arg0_6.print5, not arg3_6)
		setActive(arg0_6.print6, not arg3_6)
	end

	function var0_1.LoadPrefab(arg0_7, arg1_7, arg2_7)
		local var0_7 = arg1_7:getType()
		local var1_7 = arg1_7:getIcon()
		local var2_7 = arg1_7:getPrefabName()

		PoolMgr.GetInstance():GetPrefab(var1_7, var2_7, true, function(arg0_8)
			if not arg0_7.icon then
				local var0_8

				if var0_7 == AttireConst.TYPE_ICON_FRAME then
					var0_8 = IconFrame.GetIcon(var2_7)
				elseif var0_7 == AttireConst.TYPE_CHAT_FRAME then
					var0_8 = ChatFrame.GetIcon(var2_7)
				end

				PoolMgr.GetInstance():ReturnPrefab(var0_8, var2_7, arg0_8)
			else
				arg0_8.name = var2_7

				setParent(arg0_8, arg0_7.icon, false)

				local var1_8

				var1_8 = arg1_7:getState() == AttireFrame.STATE_LOCK

				arg2_7(arg0_8)
			end
		end)
	end

	function var0_1.ReturnIconFrame(arg0_9, arg1_9)
		eachChild(arg0_9.icon, function(arg0_10)
			local var0_10 = arg0_10.gameObject.name
			local var1_10

			if arg1_9 == AttireConst.TYPE_ICON_FRAME then
				var1_10 = IconFrame.GetIcon(var0_10)
			elseif arg1_9 == AttireConst.TYPE_CHAT_FRAME then
				var1_10 = ChatFrame.GetIcon(var0_10)
			end

			assert(var1_10)
			PoolMgr.GetInstance():ReturnPrefab(var1_10, var0_10, arg0_10.gameObject)
		end)
	end

	function var0_1.UpdateSelected(arg0_11, arg1_11)
		setActive(arg0_11.mark, arg1_11)
	end

	function var0_1.Dispose(arg0_12)
		return
	end

	var1_1(var0_1)

	return var0_1
end

function var0_0.getUIName(arg0_13)
	assert(false)
end

function var0_0.GetData(arg0_14)
	assert(false)
end

function var0_0.OnInit(arg0_15)
	arg0_15.listPanel = arg0_15:findTF("list_panel")
	arg0_15.scolrect = arg0_15:findTF("scrollrect", arg0_15.listPanel):GetComponent("LScrollRect")

	function arg0_15.scolrect.onInitItem(arg0_16)
		arg0_15:OnInitItem(arg0_16)
	end

	function arg0_15.scolrect.onUpdateItem(arg0_17, arg1_17)
		arg0_15:OnUpdateItem(arg0_17, arg1_17)
	end

	arg0_15.cards = {}

	local var0_15 = arg0_15:findTF("desc_panel")

	arg0_15.descPanel = AttireDescPanel.New(var0_15)
	arg0_15.totalCount = arg0_15:findTF("total_count/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInitItem(arg0_18, arg1_18)
	assert(false)
end

function var0_0.OnUpdateItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.cards[arg2_19]

	if not var0_19 then
		arg0_19:OnInitItem(arg2_19)

		var0_19 = arg0_19.cards[arg2_19]
	end

	local var1_19 = arg0_19.displayVOs[arg1_19 + 1]
	local var2_19 = arg0_19.scolrect.content:GetComponent(typeof(GridLayoutGroup))
	local var3_19 = arg1_19 < var2_19.constraintCount

	var0_19:Update(var1_19, arg0_19.playerVO, var3_19, arg1_19, var2_19.constraintCount)
end

function var0_0.Update(arg0_20, arg1_20, arg2_20)
	arg0_20.playerVO = arg2_20
	arg0_20.rawAttireVOs = arg1_20

	local var0_20, var1_20 = arg0_20:GetDisplayVOs()

	arg0_20.displayVOs = var0_20

	arg0_20:Filter()

	arg0_20.totalCount.text = var1_20
end

function var0_0.GetDisplayVOs(arg0_21)
	local var0_21 = {}
	local var1_21 = 0

	for iter0_21, iter1_21 in pairs(arg0_21:GetData()) do
		table.insert(var0_21, iter1_21)

		if iter1_21:getState() == AttireFrame.STATE_UNLOCK and iter1_21.id > 0 then
			var1_21 = var1_21 + 1
		end
	end

	return var0_21, var1_21
end

function var0_0.Filter(arg0_22)
	if #arg0_22.displayVOs == 0 then
		return
	end

	local var0_22 = arg0_22.playerVO:getAttireByType(arg0_22.displayVOs[1]:getType())

	table.sort(arg0_22.displayVOs, function(arg0_23, arg1_23)
		local var0_23 = var0_22 == arg0_23.id and 1 or 0
		local var1_23 = var0_22 == arg1_23.id and 1 or 0

		if var0_23 == 1 then
			return true
		elseif var1_23 == 1 then
			return false
		end

		local var2_23 = arg0_23:getState()
		local var3_23 = arg1_23:getState()

		if var2_23 == var3_23 then
			return arg0_23.id < arg1_23.id
		else
			return var3_23 < var2_23
		end
	end)

	local var1_22 = arg0_22.scolrect.content:GetComponent(typeof(GridLayoutGroup)).constraintCount
	local var2_22 = var1_22 - #arg0_22.displayVOs % var1_22

	if var2_22 == var1_22 then
		var2_22 = 0
	end

	local var3_22 = var1_22 * arg0_22:GetColumn()

	if var3_22 > #arg0_22.displayVOs then
		var2_22 = var3_22 - #arg0_22.displayVOs
	end

	for iter0_22 = 1, var2_22 do
		table.insert(arg0_22.displayVOs, {
			id = -1
		})
	end

	arg0_22.scolrect:SetTotalCount(#arg0_22.displayVOs, 0)
end

function var0_0.UpdateDesc(arg0_24, arg1_24)
	if arg1_24:isEmpty() then
		return
	end

	if not arg0_24.descPanel then
		arg0_24.descPanel = AttireDescPanel.New(arg0_24.descPanelTF)
	end

	arg0_24.descPanel:Update(arg1_24.attireFrame, arg0_24.playerVO)
	onButton(arg0_24, arg0_24.descPanel.applyBtn, function()
		local var0_25 = arg1_24.attireFrame:getType()

		arg0_24:emit(AttireMediator.ON_APPLY, var0_25, arg1_24.attireFrame.id)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_26)
	arg0_26.descPanel:Dispose()
end

return var0_0
