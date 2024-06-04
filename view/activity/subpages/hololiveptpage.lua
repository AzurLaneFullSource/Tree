local var0 = class("HoloLivePtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.charImg = arg0:findTF("charImg", arg0.bg)
	arg0.numImg = arg0:findTF("numImg", arg0.bg)
	arg0.chapterImg = arg0:findTF("chapterImg", arg0.bg)
	arg0.spineCharContainer = arg0:findTF("SpineChar", arg0.bg)
	arg0.scrollTextMask = arg0:findTF("ScrollText", arg0.bg)
	arg0.scrollTextContainer = arg0:findTF("ScrollText/TextList", arg0.bg)
	arg0.scrollTextTpl = arg0:findTF("TextTpl", arg0.bg)
end

function var0.OnDataSetting(arg0)
	var0.super.OnDataSetting(arg0)

	arg0.ptCount = arg0.ptData:GetResProgress()
	arg0.ptRank = pg.activity_event_pt[arg0.activity.id].pt_list
	arg0.picNameList = pg.activity_event_pt[arg0.activity.id].pic_list
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	arg0:initScrollTextList()

	local var0 = arg0.ptRank[2] - arg0.ptRank[1]
	local var1 = math.floor(arg0.ptCount / var0) + 1

	if var1 > #arg0.picNameList then
		var1 = #arg0.picNameList
	end

	local var2 = arg0.picNameList[var1]

	LoadSpriteAtlasAsync("ui/activityuipage/hololiveptpage", var2, function(arg0)
		setImageSprite(arg0.charImg, arg0)
	end)
	LoadSpriteAtlasAsync("ui/activityuipage/hololiveptpage", "#" .. var1, function(arg0)
		setImageSprite(arg0.numImg, arg0)
	end)
	LoadSpriteAtlasAsync("ui/activityuipage/hololiveptpage", "jiaobiao_" .. var1, function(arg0)
		setImageSprite(arg0.chapterImg, arg0)
	end)

	local var3 = "vtuber_shion"

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var3, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.prefab = var3
		arg0.model = arg0
		tf(arg0).localScale = Vector3(1, 1, 1)

		arg0:GetComponent("SpineAnimUI"):SetAction("stand", 0)
		setParent(arg0, arg0.spineCharContainer)
	end)
end

function var0.OnDestroy(arg0)
	if arg0.scrollTextTimer then
		arg0.scrollTextTimer:Stop()

		arg0.scrollTextTimer = nil
	end

	if arg0.prefab and arg0.model then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefab, arg0.model)

		arg0.prefab = nil
		arg0.model = nil
	end
end

function var0.initScrollTextList(arg0)
	setText(arg0.scrollTextTpl, arg0.activity:getConfig("config_client").scrollStr)

	local var0 = GetComponent(arg0.scrollTextTpl, "Text").preferredWidth + arg0.scrollTextMask.rect.width + 50
	local var1 = arg0.scrollTextContainer.localPosition.x - var0
	local var2 = 50
	local var3 = 0.0166666666666667

	UIItemList.New(arg0.scrollTextContainer, arg0.scrollTextTpl):align(2)

	local var4 = arg0.scrollTextContainer:GetChild(1)

	arg0.scrollTextTimer = Timer.New(function()
		local var0 = arg0.scrollTextContainer.localPosition.x - var2 * var3

		if var0 <= var1 then
			var0 = var4.localPosition.x + arg0.scrollTextContainer.localPosition.x
		end

		arg0.scrollTextContainer.localPosition = Vector3(var0, 0, 0)
	end, var3, -1, true)

	arg0.scrollTextTimer:Start()
end

return var0
