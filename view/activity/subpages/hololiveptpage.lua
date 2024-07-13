local var0_0 = class("HoloLivePtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.charImg = arg0_1:findTF("charImg", arg0_1.bg)
	arg0_1.numImg = arg0_1:findTF("numImg", arg0_1.bg)
	arg0_1.chapterImg = arg0_1:findTF("chapterImg", arg0_1.bg)
	arg0_1.spineCharContainer = arg0_1:findTF("SpineChar", arg0_1.bg)
	arg0_1.scrollTextMask = arg0_1:findTF("ScrollText", arg0_1.bg)
	arg0_1.scrollTextContainer = arg0_1:findTF("ScrollText/TextList", arg0_1.bg)
	arg0_1.scrollTextTpl = arg0_1:findTF("TextTpl", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	var0_0.super.OnDataSetting(arg0_2)

	arg0_2.ptCount = arg0_2.ptData:GetResProgress()
	arg0_2.ptRank = pg.activity_event_pt[arg0_2.activity.id].pt_list
	arg0_2.picNameList = pg.activity_event_pt[arg0_2.activity.id].pic_list
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	arg0_3:initScrollTextList()

	local var0_3 = arg0_3.ptRank[2] - arg0_3.ptRank[1]
	local var1_3 = math.floor(arg0_3.ptCount / var0_3) + 1

	if var1_3 > #arg0_3.picNameList then
		var1_3 = #arg0_3.picNameList
	end

	local var2_3 = arg0_3.picNameList[var1_3]

	LoadSpriteAtlasAsync("ui/activityuipage/hololiveptpage", var2_3, function(arg0_4)
		setImageSprite(arg0_3.charImg, arg0_4)
	end)
	LoadSpriteAtlasAsync("ui/activityuipage/hololiveptpage", "#" .. var1_3, function(arg0_5)
		setImageSprite(arg0_3.numImg, arg0_5)
	end)
	LoadSpriteAtlasAsync("ui/activityuipage/hololiveptpage", "jiaobiao_" .. var1_3, function(arg0_6)
		setImageSprite(arg0_3.chapterImg, arg0_6)
	end)

	local var3_3 = "vtuber_shion"

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var3_3, true, function(arg0_7)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_3.prefab = var3_3
		arg0_3.model = arg0_7
		tf(arg0_7).localScale = Vector3(1, 1, 1)

		arg0_7:GetComponent("SpineAnimUI"):SetAction("stand", 0)
		setParent(arg0_7, arg0_3.spineCharContainer)
	end)
end

function var0_0.OnDestroy(arg0_8)
	if arg0_8.scrollTextTimer then
		arg0_8.scrollTextTimer:Stop()

		arg0_8.scrollTextTimer = nil
	end

	if arg0_8.prefab and arg0_8.model then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_8.prefab, arg0_8.model)

		arg0_8.prefab = nil
		arg0_8.model = nil
	end
end

function var0_0.initScrollTextList(arg0_9)
	setText(arg0_9.scrollTextTpl, arg0_9.activity:getConfig("config_client").scrollStr)

	local var0_9 = GetComponent(arg0_9.scrollTextTpl, "Text").preferredWidth + arg0_9.scrollTextMask.rect.width + 50
	local var1_9 = arg0_9.scrollTextContainer.localPosition.x - var0_9
	local var2_9 = 50
	local var3_9 = 0.0166666666666667

	UIItemList.New(arg0_9.scrollTextContainer, arg0_9.scrollTextTpl):align(2)

	local var4_9 = arg0_9.scrollTextContainer:GetChild(1)

	arg0_9.scrollTextTimer = Timer.New(function()
		local var0_10 = arg0_9.scrollTextContainer.localPosition.x - var2_9 * var3_9

		if var0_10 <= var1_9 then
			var0_10 = var4_9.localPosition.x + arg0_9.scrollTextContainer.localPosition.x
		end

		arg0_9.scrollTextContainer.localPosition = Vector3(var0_10, 0, 0)
	end, var3_9, -1, true)

	arg0_9.scrollTextTimer:Start()
end

return var0_0
