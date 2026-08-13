local var0_0 = class("CrossRoadItemMgr")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tpl = arg1_1
	arg0_1._runningData = arg2_1
	arg0_1._event = arg3_1
	arg0_1.time = 0
	arg0_1.itemListTF = arg2_1:GetItemListTF()
	arg0_1.itemListTpl = arg2_1:GetAllItemTpl()
	arg0_1.xuanWoLifeTime = CrossRoadGameConst.XUANWO_LIFE_TIME
	arg0_1.binLifeTime = CrossRoadGameConst.BINGMIAN_LIFE_TIME
	arg0_1.makeHongChaTime = CrossRoadGameConst.GAME_TIME
	arg0_1.hongChaTF = arg2_1:GetHongChaTF()
	arg0_1.hongChaItem = arg0_1.itemListTpl[1]
	arg0_1.sceneContent = arg2_1:GetItemScene()
	arg0_1.itemGoList = {}
end

function var0_0.Step(arg0_2, arg1_2)
	arg0_2.time = arg0_2.time + arg1_2

	for iter0_2 = 1, CrossRoadGameConst.GAME_TRACK_COUNT do
		if arg0_2.itemGoList[iter0_2] ~= nil and arg0_2:CheckItemResTime(arg0_2.itemGoList[iter0_2]) then
			arg0_2:DisposeItemByIndex(iter0_2)
		end
	end

	if arg0_2.time > arg0_2.makeHongChaTime + CrossRoadGameConst.HONGCHA_MISS_TIME then
		arg0_2:ClearHongcha()
	end
end

function var0_0.DisposeItemByIndex(arg0_3, arg1_3)
	arg0_3:DisposeGoInList(arg0_3.itemGoList[arg1_3])

	arg0_3.itemGoList[arg1_3] = nil

	arg0_3._runningData:SetItemGoList(arg0_3.itemGoList)
end

function var0_0.DisposeGoInList(arg0_4, arg1_4)
	if arg1_4.go then
		destroy(arg1_4.go)
	end

	arg1_4.makeTime = nil
	arg1_4.id = nil
end

function var0_0.MakeHongcha(arg0_5)
	if math.random(1, 100) > CrossRoadGameConst.HONGCHA_PERCENT then
		return
	end

	setParent(arg0_5.hongChaItem, arg0_5.sceneContent, false)

	arg0_5.hongChaItem.anchoredPosition = arg0_5.hongChaTF.anchoredPosition

	setActive(arg0_5.hongChaItem, true)

	arg0_5.makeHongChaTime = arg0_5.time
end

function var0_0.ClearHongcha(arg0_6)
	SetActive(arg0_6.hongChaItem, false)
	setParent(arg0_6.hongChaItem, arg0_6._tpl, false)

	arg0_6.makeHongChaTime = CrossRoadGameConst.GAME_TIME + arg0_6.time
end

function var0_0.MakeXuanWo(arg0_7, arg1_7)
	arg0_7:MakeItemInList(arg1_7, CrossRoadGameConst.XUAN_WO)
end

function var0_0.MakeBingMain(arg0_8, arg1_8)
	local var0_8, var1_8 = arg0_8:GetNearTrackId(arg1_8)

	arg0_8:MakeItemInList(var0_8, CrossRoadGameConst.BING_MIAN)
	arg0_8:MakeItemInList(var1_8, CrossRoadGameConst.BING_MIAN)
end

function var0_0.MakeItemInList(arg0_9, arg1_9, arg2_9)
	if arg1_9 == nil or arg0_9.itemGoList[arg1_9] ~= nil then
		return
	end

	local var0_9 = arg0_9.itemListTpl[arg2_9]
	local var1_9 = tf(instantiate(var0_9))

	if arg2_9 == CrossRoadGameConst.BING_MIAN then
		local var2_9 = var1_9:GetComponent(typeof(RectTransform))
		local var3_9 = var2_9.sizeDelta

		var3_9.x = CrossRoadGameConst.BINGMIAN_DISTANCE
		var2_9.sizeDelta = var3_9
	end

	setParent(var1_9, arg0_9.sceneContent, false)

	var1_9.anchoredPosition = arg0_9.itemListTF[arg1_9].anchoredPosition
	arg0_9.itemGoList[arg1_9] = {
		id = arg2_9,
		go = var1_9,
		makeTime = arg0_9.time
	}

	arg0_9._runningData:SetItemGoList(arg0_9.itemGoList)
end

function var0_0.GetNearTrackId(arg0_10, arg1_10)
	if arg1_10 == 1 or arg1_10 == 3 then
		return 2, nil
	end

	if arg1_10 == 4 or arg1_10 == 6 then
		return 5, nil
	end

	return arg1_10 - 1, arg1_10 + 1
end

function var0_0.CheckItemResTime(arg0_11, arg1_11)
	local var0_11 = 0

	if arg1_11.id == CrossRoadGameConst.BING_MIAN then
		var0_11 = arg0_11.binLifeTime
	elseif arg1_11.id == CrossRoadGameConst.XUAN_WO then
		var0_11 = arg0_11.xuanWoLifeTime
	end

	return arg1_11.makeTime + var0_11 < arg0_11.time
end

function var0_0.Clear(arg0_12)
	arg0_12:ClearHongcha()

	arg0_12.time = 0

	for iter0_12 = 1, CrossRoadGameConst.GAME_TRACK_COUNT do
		if arg0_12.itemGoList[iter0_12] ~= nil then
			arg0_12:DisposeGoInList(arg0_12.itemGoList[iter0_12])

			arg0_12.itemGoList[iter0_12] = nil
		end
	end

	arg0_12.itemGoList = {}
end

function var0_0.Dispose(arg0_13)
	return
end

return var0_0
