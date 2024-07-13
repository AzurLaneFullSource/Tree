local var0_0 = class("BackYardDecorationPutlistPage", import(".BackYardDecorationBasePage"))

var0_0.SELECTED_FURNITRUE = "BackYardDecorationPutlistPage:SELECTED_FURNITRUE"

function var0_0.getUIName(arg0_1)
	return "BackYardPutListPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2:bind(BackYardDecrationLayer.INNER_SELECTED_FURNITRUE, function(arg0_3, arg1_3)
		arg0_2:Selected(arg1_3)
	end)

	arg0_2._bg = arg0_2:findTF("frame")
	arg0_2.scrollRect = arg0_2:findTF("frame/frame/scrollrect"):GetComponent("LScrollRect")
	arg0_2.scrollRectTF = arg0_2:findTF("frame/frame/scrollrect")
	arg0_2.emptyTF = arg0_2:findTF("frame/frame/empty")
	arg0_2.arr = arg0_2:findTF("frame/frame/arr")

	setText(arg0_2:findTF("frame/title/Text"), i18n("courtyard_label_putlist_title"))
end

function var0_0.OnInit(arg0_4)
	var0_0.super.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.arr, function()
		arg0_4:Hide()
	end, SFX_PANEL)

	local function var0_4()
		if arg0_4.timer then
			arg0_4.timer:Stop()

			arg0_4.timer = nil
		end
	end

	local function var1_4(arg0_8)
		arg0_4.timer = Timer.New(arg0_8, 0.8, 1)

		arg0_4.timer:Start()
	end

	local function var2_4(arg0_9)
		local var0_9 = var0_0.change2ScrPos(arg0_4.scrollRectTF:Find("content"), arg0_9.position)
		local var1_9

		for iter0_9, iter1_9 in pairs(arg0_4.cards) do
			local var2_9 = iter1_9._tf
			local var3_9 = var2_9.localPosition.x
			local var4_9 = var2_9.localPosition.y
			local var5_9 = Vector2(var3_9 + var2_9.rect.width / 2, var4_9 + var2_9.rect.height / 2)
			local var6_9 = Vector2(var3_9 + var2_9.rect.width / 2, var4_9 - var2_9.rect.height / 2)
			local var7_9 = Vector2(var3_9 - var2_9.rect.width / 2, var4_9 - var2_9.rect.height / 2)

			if var0_9.x > var7_9.x and var0_9.x < var6_9.x and var0_9.y > var6_9.y and var0_9.y < var5_9.y then
				var1_9 = iter1_9

				break
			end
		end

		return var1_9
	end

	local var3_4 = GetOrAddComponent(arg0_4.scrollRectTF, typeof(EventTriggerListener))

	var3_4:AddPointDownFunc(function(arg0_10, arg1_10)
		local var0_10 = var2_4(arg1_10)

		arg0_4.downPosition = arg1_10.position

		if var0_10 then
			var0_4()
			var1_4(function()
				arg0_4.lock = true

				local var0_11 = var0_10._tf.position

				arg0_4.contextData.furnitureDescMsgBox:ExecuteAction("SetUp", var0_10.furniture, var0_11, true)
			end)
		end
	end)
	var3_4:AddPointUpFunc(function(arg0_12, arg1_12)
		var0_4()

		if arg0_4.lock then
			arg0_4.contextData.furnitureDescMsgBox:ExecuteAction("Hide")
			onNextTick(function()
				arg0_4.lock = false
			end)
		else
			local var0_12 = arg1_12.position

			if Vector2.Distance(var0_12, arg0_4.downPosition) > 1 then
				return
			end

			local var1_12 = var2_4(arg1_12)

			if var1_12 then
				arg0_4:emit(BackYardDecorationMediator.ON_SELECTED_FURNITRUE, var1_12.furniture.id)
				var1_12:MarkOrUnMark(arg0_4.card.furniture.id)

				arg0_4.selectedId = arg0_4.card.furniture.id

				arg0_4:emit(var0_0.SELECTED_FURNITRUE)
			end
		end
	end)
end

function var0_0.ClearMark(arg0_14)
	arg0_14.selectedId = nil

	for iter0_14, iter1_14 in pairs(arg0_14.cards) do
		iter1_14:MarkOrUnMark(arg0_14.selectedId)
	end
end

function var0_0.Selected(arg0_15, arg1_15)
	arg0_15:ClearMark()

	for iter0_15, iter1_15 in pairs(arg0_15.cards) do
		if iter1_15.furniture and iter1_15.furniture.id == arg1_15 then
			iter1_15:MarkOrUnMark(arg1_15)

			break
		end
	end

	arg0_15.selectedId = arg1_15
end

function var0_0.change2ScrPos(arg0_16, arg1_16)
	local var0_16 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_16 = arg0_16:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1_16, arg1_16, var0_16))
end

function var0_0.OnInitItem(arg0_17, arg1_17)
	local var0_17 = BackYardDecorationPutCard.New(arg1_17)

	arg0_17.cards[arg1_17] = var0_17
end

function var0_0.OnUpdateItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.cards[arg2_18]

	if not var0_18 then
		arg0_18:OnInitItem(arg2_18)

		var0_18 = arg0_18.cards[arg2_18]
	end

	local var1_18 = arg0_18.displays[arg1_18 + 1]

	var0_18:Update(var1_18, arg0_18.selectedId)
end

function var0_0.OnDisplayList(arg0_19)
	arg0_19.displays = {}

	local var0_19 = getProxy(DormProxy).floor
	local var1_19 = arg0_19.dorm:GetTheme(var0_19)
	local var2_19 = {}

	if var1_19 then
		var2_19 = var1_19:GetAllFurniture()
	end

	for iter0_19, iter1_19 in pairs(var2_19) do
		table.insert(arg0_19.displays, Furniture.New({
			count = 1,
			id = iter1_19.configId
		}))
	end

	table.sort(arg0_19.displays, function(arg0_20, arg1_20)
		return arg0_20:getConfig("type") < arg1_20:getConfig("type")
	end)
	setActive(arg0_19.emptyTF, #arg0_19.displays == 0)
	arg0_19.scrollRect:SetTotalCount(#arg0_19.displays)
end

function var0_0.Show(arg0_21)
	var0_0.super.Show(arg0_21)

	local var0_21 = arg0_21._bg.anchoredPosition.x

	LeanTween.value(arg0_21._bg.gameObject, var0_21, 0, 0.4):setOnUpdate(System.Action_float(function(arg0_22)
		setAnchoredPosition(arg0_21._bg, {
			x = arg0_22
		})
	end)):setOnComplete(System.Action(function()
		if arg0_21.OnShow then
			arg0_21.OnShow(true)
		end
	end))

	if arg0_21.OnShowImmediately then
		arg0_21.OnShowImmediately()
	end
end

function var0_0.Hide(arg0_24)
	local var0_24 = -arg0_24._bg.rect.width

	LeanTween.value(arg0_24._bg.gameObject, 0, var0_24, 0.4):setOnUpdate(System.Action_float(function(arg0_25)
		setAnchoredPosition(arg0_24._bg, {
			x = arg0_25
		})
	end)):setOnComplete(System.Action(function()
		var0_0.super.Hide(arg0_24)

		if arg0_24.OnShow then
			arg0_24.OnShow(false)
		end
	end))

	for iter0_24, iter1_24 in pairs(arg0_24.cards) do
		iter1_24:Clear()
	end
end

function var0_0.OnDormUpdated(arg0_27)
	arg0_27:OnDisplayList()
end

function var0_0.OnDestroy(arg0_28)
	if arg0_28.timer then
		arg0_28.timer:Stop()

		arg0_28.timer = nil
	end
end

return var0_0
