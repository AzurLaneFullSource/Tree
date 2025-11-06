local var0_0 = class("IslandAwardDisplayInMainPanel", import("view.base.BaseSubView"))
local var1_0 = 3
local var2_0 = 5

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplayInMainPanel"
end

local var3_0 = "UICamera/Canvas/UIMain/UIIsland/layer1/ui/IslandUI(Clone)/track_container/Island3dTaskTrackPanel(Clone)"

function var0_0.OnLoaded(arg0_2)
	arg0_2.tileTF = arg0_2._tf:Find("title")
	arg0_2.nameTf = arg0_2._tf:Find("title/name")

	setText(arg0_2.nameTf, i18n("word_get"))

	arg0_2.container = arg0_2._tf:Find("content")
	arg0_2.item = arg0_2._tf:Find("tpl")
	arg0_2.poolContainer = arg0_2._tf:Find("pool")
end

function var0_0.OnInit(arg0_3)
	arg0_3.showItemQueue = {}
	arg0_3.poolList = {}
	arg0_3.timers = {}
	arg0_3.showCount = 0

	setActive(arg0_3.item, false)
end

function var0_0.Show(arg0_4, arg1_4)
	var0_0.super.Show(arg0_4)

	arg0_4.trackPanelTF = tf(GameObject.Find(var3_0))

	local var0_4 = 0

	if arg0_4.contextData and arg0_4.contextData.needAdapt and not IsNil(arg0_4.trackPanelTF) then
		local var1_4 = arg0_4.trackPanelTF.rect.height

		setAnchoredPosition(arg0_4.tileTF, {
			y = -256 - var1_4
		})
		setAnchoredPosition(arg0_4.container, {
			y = -306 - var1_4
		})
	else
		setAnchoredPosition(arg0_4.tileTF, {
			y = -410
		})
		setAnchoredPosition(arg0_4.container, {
			y = -450
		})
	end

	arg0_4.isShow = true
end

function var0_0.Hide(arg0_5)
	var0_0.super.Hide(arg0_5)

	arg0_5.isShow = false
end

function var0_0.OnHide(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.timers) do
		if iter1_6 then
			iter1_6:Stop()
		end
	end
end

function var0_0.ShowAwards(arg0_7, arg1_7)
	setActive(arg0_7.nameTf, not arg1_7.shipExp)

	if not arg1_7.shipExp then
		local var0_7 = arg1_7.awards

		for iter0_7, iter1_7 in ipairs(var0_7) do
			local var1_7 = arg0_7:CreateItem()

			setActive(findTF(var1_7, "name"), true)
			setActive(findTF(var1_7, "exp"), false)

			local var2_7 = iter1_7:getIcon()
			local var3_7 = iter1_7:getName()

			setText(findTF(var1_7, "name"), string.format(var3_7))
			GetImageSpriteFromAtlasAsync(var2_7, "", findTF(var1_7, "icon"))
			setText(findTF(var1_7, "name/count"), iter1_7:getCount())
		end
	else
		local var4_7 = arg0_7:CreateItem()

		setActive(findTF(var4_7, "name"), false)
		setActive(findTF(var4_7, "exp"), true)
		GetImageSpriteFromAtlasAsync(arg1_7.icon, "", findTF(var4_7, "icon"))
		setText(findTF(var4_7, "exp/count"), arg1_7.num)
	end
end

function var0_0.CreateItem(arg0_8)
	arg0_8.showCount = arg0_8.showCount + 1

	if arg0_8.showCount > 0 and not arg0_8.isShow then
		arg0_8:Show()
	end

	local var0_8

	if arg0_8.showCount > var2_0 then
		var0_8 = arg0_8.showItemQueue[1]

		table.remove(arg0_8.showItemQueue, 1)

		arg0_8.showCount = arg0_8.showCount - 1
	elseif #arg0_8.poolList > 0 then
		var0_8 = arg0_8.poolList[1]

		table.remove(arg0_8.poolList, 1)
		var0_8:SetParent(arg0_8.container, false)

		GetOrAddComponent(var0_8, typeof(CanvasGroup)).alpha = 1
	else
		var0_8 = cloneTplTo(arg0_8.item, arg0_8.container)
	end

	local var1_8 = arg0_8.showCount - 1

	var0_8.transform:SetSiblingIndex(var1_8)
	table.insert(arg0_8.showItemQueue, var0_8)

	if arg0_8.timers[var0_8] then
		arg0_8.timers[var0_8]:Stop()
	end

	arg0_8.timers[var0_8] = Timer.New(function()
		arg0_8:DeleteItem(var0_8)
	end, var1_0, 1)

	arg0_8.timers[var0_8]:Start()

	return var0_8
end

function var0_0.DeleteItem(arg0_10, arg1_10)
	arg0_10.showCount = arg0_10.showCount - 1

	if arg0_10.showCount <= 0 and arg0_10.isShow then
		arg0_10:Hide()
	end

	GetOrAddComponent(arg1_10, typeof(CanvasGroup)).alpha = 0

	table.insert(arg0_10.poolList, arg1_10)
	arg1_10:SetParent(arg0_10.poolContainer, false)
end

function var0_0.OnDestroy(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.timers) do
		if iter1_11 then
			iter1_11:Stop()
		end
	end
end

return var0_0
