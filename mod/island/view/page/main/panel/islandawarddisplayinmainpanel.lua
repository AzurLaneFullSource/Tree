local var0_0 = class("IslandAwardDisplayInMainPanel", import("view.base.BaseSubView"))
local var1_0 = 3
local var2_0 = 5

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplayInMainPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameTf = arg0_2._tf:Find("title/name")
	arg0_2.container = arg0_2:findTF("content")
	arg0_2.item = arg0_2:findTF("tpl")
	arg0_2.poolContainer = arg0_2:findTF("pool")
end

function var0_0.OnInit(arg0_3)
	arg0_3.showItemQueue = {}
	arg0_3.poolList = {}
	arg0_3.timers = {}
	arg0_3.showCount = 0

	setText(arg0_3.nameTf, "获得")
	setActive(arg0_3.item, false)
end

function var0_0.Show(arg0_4, arg1_4)
	var0_0.super.Show(arg0_4)

	arg0_4.isShow = true
end

function var0_0.Hide(arg0_5)
	var0_0.super.Hide(arg0_5)

	arg0_5.isShow = false
end

function var0_0.ShowAwards(arg0_6, arg1_6)
	local var0_6 = arg1_6.awards

	for iter0_6, iter1_6 in ipairs(var0_6) do
		local var1_6 = arg0_6:CreateItem()
		local var2_6 = iter1_6:getIcon()
		local var3_6 = iter1_6:getName()

		setText(findTF(var1_6, "name"), string.format(var3_6))
		GetImageSpriteFromAtlasAsync(var2_6, "", findTF(var1_6, "icon"))
		setText(findTF(var1_6, "name/count"), iter1_6:getCount())
	end
end

function var0_0.CreateItem(arg0_7)
	arg0_7.showCount = arg0_7.showCount + 1

	if arg0_7.showCount > 0 and not arg0_7.isShow then
		arg0_7:Show()
	end

	local var0_7

	if arg0_7.showCount > var2_0 then
		var0_7 = arg0_7.showItemQueue[1]

		table.remove(arg0_7.showItemQueue, 1)

		arg0_7.showCount = arg0_7.showCount - 1
	elseif #arg0_7.poolList > 0 then
		var0_7 = arg0_7.poolList[1]

		table.remove(arg0_7.poolList, 1)
		var0_7:SetParent(arg0_7.container, false)

		GetOrAddComponent(var0_7, typeof(CanvasGroup)).alpha = 1
	else
		var0_7 = cloneTplTo(arg0_7.item, arg0_7.container)
	end

	local var1_7 = arg0_7.showCount - 1

	var0_7.transform:SetSiblingIndex(var1_7)
	table.insert(arg0_7.showItemQueue, var0_7)

	if arg0_7.timers[var0_7] then
		arg0_7.timers[var0_7]:Stop()
	end

	arg0_7.timers[var0_7] = Timer.New(function()
		arg0_7:DeleteItem(var0_7)
	end, var1_0, 1)

	arg0_7.timers[var0_7]:Start()

	return var0_7
end

function var0_0.DeleteItem(arg0_9, arg1_9)
	arg0_9.showCount = arg0_9.showCount - 1

	if arg0_9.showCount <= 0 and arg0_9.isShow then
		arg0_9:Hide()
	end

	GetOrAddComponent(arg1_9, typeof(CanvasGroup)).alpha = 0

	table.insert(arg0_9.poolList, arg1_9)
	arg1_9:SetParent(arg0_9.poolContainer, false)
end

function var0_0.OnDestroy(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.timers) do
		if iter1_10 then
			iter1_10:Stop()
		end
	end
end

return var0_0
