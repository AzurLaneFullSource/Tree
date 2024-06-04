local var0 = class("BackYardDecorationPutlistPage", import(".BackYardDecorationBasePage"))

var0.SELECTED_FURNITRUE = "BackYardDecorationPutlistPage:SELECTED_FURNITRUE"

function var0.getUIName(arg0)
	return "BackYardPutListPage"
end

function var0.OnLoaded(arg0)
	arg0:bind(BackYardDecrationLayer.INNER_SELECTED_FURNITRUE, function(arg0, arg1)
		arg0:Selected(arg1)
	end)

	arg0._bg = arg0:findTF("frame")
	arg0.scrollRect = arg0:findTF("frame/frame/scrollrect"):GetComponent("LScrollRect")
	arg0.scrollRectTF = arg0:findTF("frame/frame/scrollrect")
	arg0.emptyTF = arg0:findTF("frame/frame/empty")
	arg0.arr = arg0:findTF("frame/frame/arr")

	setText(arg0:findTF("frame/title/Text"), i18n("courtyard_label_putlist_title"))
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.arr, function()
		arg0:Hide()
	end, SFX_PANEL)

	local function var0()
		if arg0.timer then
			arg0.timer:Stop()

			arg0.timer = nil
		end
	end

	local function var1(arg0)
		arg0.timer = Timer.New(arg0, 0.8, 1)

		arg0.timer:Start()
	end

	local function var2(arg0)
		local var0 = var0.change2ScrPos(arg0.scrollRectTF:Find("content"), arg0.position)
		local var1

		for iter0, iter1 in pairs(arg0.cards) do
			local var2 = iter1._tf
			local var3 = var2.localPosition.x
			local var4 = var2.localPosition.y
			local var5 = Vector2(var3 + var2.rect.width / 2, var4 + var2.rect.height / 2)
			local var6 = Vector2(var3 + var2.rect.width / 2, var4 - var2.rect.height / 2)
			local var7 = Vector2(var3 - var2.rect.width / 2, var4 - var2.rect.height / 2)

			if var0.x > var7.x and var0.x < var6.x and var0.y > var6.y and var0.y < var5.y then
				var1 = iter1

				break
			end
		end

		return var1
	end

	local var3 = GetOrAddComponent(arg0.scrollRectTF, typeof(EventTriggerListener))

	var3:AddPointDownFunc(function(arg0, arg1)
		local var0 = var2(arg1)

		arg0.downPosition = arg1.position

		if var0 then
			var0()
			var1(function()
				arg0.lock = true

				local var0 = var0._tf.position

				arg0.contextData.furnitureDescMsgBox:ExecuteAction("SetUp", var0.furniture, var0, true)
			end)
		end
	end)
	var3:AddPointUpFunc(function(arg0, arg1)
		var0()

		if arg0.lock then
			arg0.contextData.furnitureDescMsgBox:ExecuteAction("Hide")
			onNextTick(function()
				arg0.lock = false
			end)
		else
			local var0 = arg1.position

			if Vector2.Distance(var0, arg0.downPosition) > 1 then
				return
			end

			local var1 = var2(arg1)

			if var1 then
				arg0:emit(BackYardDecorationMediator.ON_SELECTED_FURNITRUE, var1.furniture.id)
				var1:MarkOrUnMark(arg0.card.furniture.id)

				arg0.selectedId = arg0.card.furniture.id

				arg0:emit(var0.SELECTED_FURNITRUE)
			end
		end
	end)
end

function var0.ClearMark(arg0)
	arg0.selectedId = nil

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:MarkOrUnMark(arg0.selectedId)
	end
end

function var0.Selected(arg0, arg1)
	arg0:ClearMark()

	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.furniture and iter1.furniture.id == arg1 then
			iter1:MarkOrUnMark(arg1)

			break
		end
	end

	arg0.selectedId = arg1
end

function var0.change2ScrPos(arg0, arg1)
	local var0 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1 = arg0:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1, arg1, var0))
end

function var0.OnInitItem(arg0, arg1)
	local var0 = BackYardDecorationPutCard.New(arg1)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	var0:Update(var1, arg0.selectedId)
end

function var0.OnDisplayList(arg0)
	arg0.displays = {}

	local var0 = getProxy(DormProxy).floor
	local var1 = arg0.dorm:GetTheme(var0)
	local var2 = {}

	if var1 then
		var2 = var1:GetAllFurniture()
	end

	for iter0, iter1 in pairs(var2) do
		table.insert(arg0.displays, Furniture.New({
			count = 1,
			id = iter1.configId
		}))
	end

	table.sort(arg0.displays, function(arg0, arg1)
		return arg0:getConfig("type") < arg1:getConfig("type")
	end)
	setActive(arg0.emptyTF, #arg0.displays == 0)
	arg0.scrollRect:SetTotalCount(#arg0.displays)
end

function var0.Show(arg0)
	var0.super.Show(arg0)

	local var0 = arg0._bg.anchoredPosition.x

	LeanTween.value(arg0._bg.gameObject, var0, 0, 0.4):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0._bg, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		if arg0.OnShow then
			arg0.OnShow(true)
		end
	end))

	if arg0.OnShowImmediately then
		arg0.OnShowImmediately()
	end
end

function var0.Hide(arg0)
	local var0 = -arg0._bg.rect.width

	LeanTween.value(arg0._bg.gameObject, 0, var0, 0.4):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0._bg, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		var0.super.Hide(arg0)

		if arg0.OnShow then
			arg0.OnShow(false)
		end
	end))

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Clear()
	end
end

function var0.OnDormUpdated(arg0)
	arg0:OnDisplayList()
end

function var0.OnDestroy(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

return var0
