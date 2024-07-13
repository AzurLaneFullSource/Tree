local var0_0 = class("SVScannerPanel", import("view.base.BaseSubView"))

var0_0.ShowView = "SVScannerPanel.ShowView"
var0_0.HideView = "SVScannerPanel.HideView"
var0_0.HideGoing = "SVScannerPanel.HideGoing"

function var0_0.getUIName(arg0_1)
	return "SVScannerPanel"
end

function var0_0.getBGM(arg0_2)
	return "echo-loop"
end

function var0_0.OnLoaded(arg0_3)
	return
end

function var0_0.OnInit(arg0_4)
	arg0_4.camera = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

	local var0_4 = arg0_4._tf

	arg0_4.canvas = GetOrAddComponent(var0_4, "CanvasGroup")
	arg0_4.rtExit = var0_4:Find("adapt/exit")
	arg0_4.rtPanel = var0_4:Find("adapt/selected_panel")

	setActive(arg0_4.rtPanel, false)

	arg0_4.rtWindow = arg0_4.rtPanel:Find("window")
	arg0_4.rtTitle = arg0_4.rtWindow:Find("base_info/title")
	arg0_4.rtMark = arg0_4.rtWindow:Find("base_info/mark")
	arg0_4.rtBuffContent = arg0_4.rtWindow:Find("base_info/content")
	arg0_4.rtMapBuffContent = arg0_4.rtWindow:Find("base_info/map_buffs")
	arg0_4.rtInfo = arg0_4.rtWindow:Find("base_info/info")
	arg0_4.rtWeaknessContent = arg0_4.rtWindow:Find("weakness_info/content")
	arg0_4.rtRadiation = arg0_4.rtWindow:Find("radiation_info")
	arg0_4.rtAnim = var0_4:Find("adapt/anim")
	arg0_4.rtClick = arg0_4.rtPanel:Find("click")
	arg0_4.buffUIItemList = UIItemList.New(arg0_4.rtBuffContent, arg0_4.rtBuffContent:Find("buff"))

	arg0_4.buffUIItemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_4.buffList[arg1_5]

			if #var0_5.config.icon > 0 then
				GetImageSpriteFromAtlasAsync("world/buff/" .. var0_5.config.icon, "", arg2_5:Find("icon"))
			else
				setImageSprite(arg2_5:Find("icon"), nil)
			end

			setText(arg2_5:Find("Text"), var0_5.config.desc)
		end
	end)

	arg0_4.mapBuffItemList = UIItemList.New(arg0_4.rtMapBuffContent, arg0_4.rtMapBuffContent:Find("buff"))

	arg0_4.mapBuffItemList:make(function(arg0_6, arg1_6, arg2_6)
		arg1_6 = arg1_6 + 1

		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg0_4.mapBuffList[arg1_6]

			if #var0_6.config.icon > 0 then
				GetImageSpriteFromAtlasAsync("world/buff/" .. var0_6.config.icon, "", arg2_6:Find("icon"))
			else
				setImageSprite(arg2_6:Find("icon"), nil)
			end

			setText(arg2_6:Find("Text"), var0_6.config.desc)
		end
	end)

	arg0_4.weaknessUIItemList = UIItemList.New(arg0_4.rtWeaknessContent, arg0_4.rtWeaknessContent:Find("buff"))

	arg0_4.weaknessUIItemList:make(function(arg0_7, arg1_7, arg2_7)
		arg1_7 = arg1_7 + 1

		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg0_4.weaknessList[arg1_7]

			setText(arg2_7:Find("Text"), var0_7.config.desc)
		end
	end)
	onButton(arg0_4, arg0_4.rtExit, function()
		arg0_4:Hide()
	end, SFX_UI_CANCEL)
	onButton(arg0_4, arg0_4.rtClick:Find("enemy"), function()
		arg0_4:Hide(true)
	end, SFX_CONFIRM)
	onButton(arg0_4, arg0_4.rtClick:Find("other"), function()
		arg0_4:Hide(true)
	end, SFX_CONFIRM)
end

function var0_0.OnDestroy(arg0_11)
	return
end

function var0_0.Show(arg0_12, arg1_12, arg2_12)
	arg0_12:emit(var0_0.ShowView)

	if arg1_12 then
		arg0_12:DisplayWindow(arg1_12, arg2_12)
	else
		arg0_12:HideWindow()
	end

	function arg0_12.wsDragProxy.onDragFunction()
		if isActive(arg0_12.rtPanel) then
			arg0_12:HideWindow()
		end
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0_12._tf)
	setActive(arg0_12._tf, true)
	arg0_12:EaseInOut(true)
	var0_0.super.Show(arg0_12)
end

function var0_0.Hide(arg0_14, arg1_14)
	if LeanTween.isTweening(arg0_14.alphaLT) then
		return
	end

	local var0_14 = {}

	if not arg1_14 then
		table.insert(var0_14, function(arg0_15)
			arg0_14:EaseInOut(false, arg0_15)
		end)
	end

	seriesAsync(var0_14, function()
		arg0_14.wsDragProxy.onDragFunction = nil

		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf, arg0_14._parentTf)

		if arg1_14 then
			arg0_14:emit(var0_0.HideGoing, arg0_14.attachment.row, arg0_14.attachment.column)
		else
			arg0_14:emit(var0_0.HideView)
		end

		var0_0.super.Hide(arg0_14)
	end)
end

function var0_0.Setup(arg0_17, arg1_17, arg2_17)
	arg0_17.map = arg1_17
	arg0_17.wsDragProxy = arg2_17
end

function var0_0.DisplayWindow(arg0_18, arg1_18, arg2_18)
	if isActive(arg0_18.rtPanel) and arg0_18.attachment == arg1_18 then
		arg0_18:HideWindow()
	else
		arg0_18:Update(arg1_18)

		arg0_18.rtPanel.position = arg0_18.camera:ScreenToWorldPoint(arg2_18)
		arg0_18.rtPanel.anchoredPosition3D = Vector3.New(arg0_18.rtPanel.anchoredPosition.x, arg0_18.rtPanel.anchoredPosition.y, 0)
		arg0_18.rtAnim.anchoredPosition = arg0_18.rtPanel.anchoredPosition
		arg0_18.rtWindow.anchorMin = Vector2.New(arg0_18.rtPanel.anchoredPosition.x > 0 and 0 or 1, arg0_18.rtPanel.anchoredPosition.y > 0 and 1 or 0)
		arg0_18.rtWindow.anchorMax = arg0_18.rtWindow.anchorMin
		arg0_18.rtWindow.pivot = Vector2.New(arg0_18.rtPanel.anchoredPosition.x > 0 and 1 or 0, arg0_18.rtPanel.anchoredPosition.y > 0 and 1 or 0)
		arg0_18.rtWindow.anchoredPosition = Vector2.zero
		arg0_18.rtClick.anchorMin = Vector2.New(arg0_18.rtPanel.anchoredPosition.x > 0 and 1 or 0, 0)
		arg0_18.rtClick.anchorMax = arg0_18.rtClick.anchorMin
		arg0_18.rtWindow.anchoredPosition = Vector2.zero

		local var0_18 = WorldMapAttachment.IsEnemyType(arg1_18.type) or arg1_18:GetSpEventType() == WorldMapAttachment.SpEventEnemy

		setActive(arg0_18.rtClick:Find("enemy"), var0_18)
		setActive(arg0_18.rtClick:Find("other"), not var0_18)
		setActive(arg0_18.rtPanel, true)
	end
end

function var0_0.HideWindow(arg0_19)
	setAnchoredPosition(arg0_19.rtAnim, Vector2.zero)
	setActive(arg0_19.rtPanel, false)
end

function var0_0.EaseInOut(arg0_20, arg1_20, arg2_20)
	if arg0_20.alphaLT then
		LeanTween.cancel(arg0_20.alphaLT)
	end

	arg0_20.canvas.alpha = arg1_20 and 0 or 1
	arg0_20.alphaLT = LeanTween.alphaCanvas(arg0_20.canvas, arg1_20 and 1 or 0, 1):setOnComplete(System.Action(arg2_20 or function()
		return
	end)).uniqueId
end

function var0_0.Update(arg0_22, arg1_22)
	if arg0_22.attachment ~= arg1_22 then
		arg0_22.attachment = arg1_22

		arg0_22:OnUpdate()
	end
end

function var0_0.OnUpdate(arg0_23)
	local var0_23 = arg0_23.map
	local var1_23 = arg0_23.attachment
	local var2_23 = arg0_23.rtTitle:Find("Text")
	local var3_23 = {}
	local var4_23 = {}
	local var5_23 = false
	local var6_23 = false
	local var7_23 = var1_23.config.name or ""

	if WorldMapAttachment.IsEnemyType(var1_23.type) then
		var5_23 = true
		var6_23 = false
		var3_23 = var1_23:GetBuffList()
		var4_23 = var0_23:GetBuffList(WorldMap.FactionEnemy, var1_23)

		if var1_23.config.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
			var7_23 = var7_23 .. " LV." .. WorldConst.WorldLevelCorrect(var0_23.config.expedition_level, var1_23.config.type)
		else
			var7_23 = var7_23 .. " LV." .. var1_23.config.level
		end
	elseif var1_23.type == WorldMapAttachment.TypeEvent then
		var3_23 = var1_23:GetBuffList()
		var4_23 = var0_23:GetBuffList(WorldMap.FactionEnemy, var1_23)

		local var8_23 = var1_23.config.is_scanevent

		if var8_23 == 1 or var8_23 == 3 then
			var5_23 = var8_23 == 3
			var6_23 = true

			setActive(arg0_23.rtInfo:Find("Image"), false)
			setText(arg0_23.rtInfo:Find("Text"), var1_23.config.scan_desc)
		elseif var8_23 == 2 or var8_23 == 4 then
			var5_23 = var8_23 == 4
			var6_23 = true

			setActive(arg0_23.rtInfo:Find("Image"), true)
			GetImageSpriteFromAtlasAsync("icondesc/" .. var1_23.config.icon, "", arg0_23.rtInfo:Find("Image"))
			setText(arg0_23.rtInfo:Find("Text"), var1_23.config.scan_desc)
		end
	elseif var1_23.type == WorldMapAttachment.TypeTrap then
		var5_23 = true
		var6_23 = true

		setActive(arg0_23.rtInfo:Find("Image"), true)

		local var9_23 = WorldBuff.GetTemplate(var1_23.config.buff_id)

		GetImageSpriteFromAtlasAsync("world/buff/" .. var9_23.icon, "", arg0_23.rtInfo:Find("Image"))
		setText(arg0_23.rtInfo:Find("Text"), var1_23.config.desc)
	elseif var1_23.type == WorldMapAttachment.TypePort then
		local var10_23 = var1_23.config.port_camp

		var5_23 = var10_23 > 0 and var10_23 ~= nowWorld():GetRealm()
		var6_23 = true

		setActive(arg0_23.rtInfo:Find("Image"), false)
		setText(arg0_23.rtInfo:Find("Text"), var1_23.config.scan_desc)
	end

	setText(var2_23, var7_23)

	local var11_23 = var1_23:GetWeaknessBuffId()

	arg0_23.buffList = {}
	arg0_23.weaknessList = {}

	for iter0_23, iter1_23 in ipairs(var3_23) do
		if iter1_23.id == var11_23 then
			table.insert(arg0_23.weaknessList, iter1_23)
		else
			table.insert(arg0_23.buffList, iter1_23)
		end
	end

	arg0_23.buffUIItemList:align(#arg0_23.buffList)
	arg0_23.weaknessUIItemList:align(#arg0_23.weaknessList)

	arg0_23.mapBuffList = var4_23

	arg0_23.mapBuffItemList:align(#arg0_23.mapBuffList)
	setActive(arg0_23.rtInfo, var6_23)
	setActive(arg0_23.rtMark, var6_23 and var5_23)
	setActive(arg0_23.rtTitle:Find("red"), var5_23)
	setActive(arg0_23.rtTitle:Find("yellow"), not var5_23)

	local var12_23 = var1_23:GetRadiationBuffs()

	setActive(arg0_23.rtRadiation, #var12_23 > 0)

	if #var12_23 > 0 then
		local var13_23, var14_23, var15_23 = unpack(var12_23[1])

		GetImageSpriteFromAtlasAsync("world/mapbuff/" .. pg.world_SLGbuff_data[var14_23].icon, "", arg0_23.rtRadiation:Find("info/map_buff/Image"))
		setText(arg0_23.rtRadiation:Find("info/Text"), i18n("world_mapbuff_tip"))
	end
end

return var0_0
