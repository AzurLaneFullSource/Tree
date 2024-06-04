local var0 = class("SVScannerPanel", import("view.base.BaseSubView"))

var0.ShowView = "SVScannerPanel.ShowView"
var0.HideView = "SVScannerPanel.HideView"
var0.HideGoing = "SVScannerPanel.HideGoing"

function var0.getUIName(arg0)
	return "SVScannerPanel"
end

function var0.getBGM(arg0)
	return "echo-loop"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.camera = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

	local var0 = arg0._tf

	arg0.canvas = GetOrAddComponent(var0, "CanvasGroup")
	arg0.rtExit = var0:Find("adapt/exit")
	arg0.rtPanel = var0:Find("adapt/selected_panel")

	setActive(arg0.rtPanel, false)

	arg0.rtWindow = arg0.rtPanel:Find("window")
	arg0.rtTitle = arg0.rtWindow:Find("base_info/title")
	arg0.rtMark = arg0.rtWindow:Find("base_info/mark")
	arg0.rtBuffContent = arg0.rtWindow:Find("base_info/content")
	arg0.rtMapBuffContent = arg0.rtWindow:Find("base_info/map_buffs")
	arg0.rtInfo = arg0.rtWindow:Find("base_info/info")
	arg0.rtWeaknessContent = arg0.rtWindow:Find("weakness_info/content")
	arg0.rtRadiation = arg0.rtWindow:Find("radiation_info")
	arg0.rtAnim = var0:Find("adapt/anim")
	arg0.rtClick = arg0.rtPanel:Find("click")
	arg0.buffUIItemList = UIItemList.New(arg0.rtBuffContent, arg0.rtBuffContent:Find("buff"))

	arg0.buffUIItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.buffList[arg1]

			if #var0.config.icon > 0 then
				GetImageSpriteFromAtlasAsync("world/buff/" .. var0.config.icon, "", arg2:Find("icon"))
			else
				setImageSprite(arg2:Find("icon"), nil)
			end

			setText(arg2:Find("Text"), var0.config.desc)
		end
	end)

	arg0.mapBuffItemList = UIItemList.New(arg0.rtMapBuffContent, arg0.rtMapBuffContent:Find("buff"))

	arg0.mapBuffItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.mapBuffList[arg1]

			if #var0.config.icon > 0 then
				GetImageSpriteFromAtlasAsync("world/buff/" .. var0.config.icon, "", arg2:Find("icon"))
			else
				setImageSprite(arg2:Find("icon"), nil)
			end

			setText(arg2:Find("Text"), var0.config.desc)
		end
	end)

	arg0.weaknessUIItemList = UIItemList.New(arg0.rtWeaknessContent, arg0.rtWeaknessContent:Find("buff"))

	arg0.weaknessUIItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.weaknessList[arg1]

			setText(arg2:Find("Text"), var0.config.desc)
		end
	end)
	onButton(arg0, arg0.rtExit, function()
		arg0:Hide()
	end, SFX_UI_CANCEL)
	onButton(arg0, arg0.rtClick:Find("enemy"), function()
		arg0:Hide(true)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.rtClick:Find("other"), function()
		arg0:Hide(true)
	end, SFX_CONFIRM)
end

function var0.OnDestroy(arg0)
	return
end

function var0.Show(arg0, arg1, arg2)
	arg0:emit(var0.ShowView)

	if arg1 then
		arg0:DisplayWindow(arg1, arg2)
	else
		arg0:HideWindow()
	end

	function arg0.wsDragProxy.onDragFunction()
		if isActive(arg0.rtPanel) then
			arg0:HideWindow()
		end
	end

	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
	setActive(arg0._tf, true)
	arg0:EaseInOut(true)
	var0.super.Show(arg0)
end

function var0.Hide(arg0, arg1)
	if LeanTween.isTweening(arg0.alphaLT) then
		return
	end

	local var0 = {}

	if not arg1 then
		table.insert(var0, function(arg0)
			arg0:EaseInOut(false, arg0)
		end)
	end

	seriesAsync(var0, function()
		arg0.wsDragProxy.onDragFunction = nil

		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)

		if arg1 then
			arg0:emit(var0.HideGoing, arg0.attachment.row, arg0.attachment.column)
		else
			arg0:emit(var0.HideView)
		end

		var0.super.Hide(arg0)
	end)
end

function var0.Setup(arg0, arg1, arg2)
	arg0.map = arg1
	arg0.wsDragProxy = arg2
end

function var0.DisplayWindow(arg0, arg1, arg2)
	if isActive(arg0.rtPanel) and arg0.attachment == arg1 then
		arg0:HideWindow()
	else
		arg0:Update(arg1)

		arg0.rtPanel.position = arg0.camera:ScreenToWorldPoint(arg2)
		arg0.rtPanel.anchoredPosition3D = Vector3.New(arg0.rtPanel.anchoredPosition.x, arg0.rtPanel.anchoredPosition.y, 0)
		arg0.rtAnim.anchoredPosition = arg0.rtPanel.anchoredPosition
		arg0.rtWindow.anchorMin = Vector2.New(arg0.rtPanel.anchoredPosition.x > 0 and 0 or 1, arg0.rtPanel.anchoredPosition.y > 0 and 1 or 0)
		arg0.rtWindow.anchorMax = arg0.rtWindow.anchorMin
		arg0.rtWindow.pivot = Vector2.New(arg0.rtPanel.anchoredPosition.x > 0 and 1 or 0, arg0.rtPanel.anchoredPosition.y > 0 and 1 or 0)
		arg0.rtWindow.anchoredPosition = Vector2.zero
		arg0.rtClick.anchorMin = Vector2.New(arg0.rtPanel.anchoredPosition.x > 0 and 1 or 0, 0)
		arg0.rtClick.anchorMax = arg0.rtClick.anchorMin
		arg0.rtWindow.anchoredPosition = Vector2.zero

		local var0 = WorldMapAttachment.IsEnemyType(arg1.type) or arg1:GetSpEventType() == WorldMapAttachment.SpEventEnemy

		setActive(arg0.rtClick:Find("enemy"), var0)
		setActive(arg0.rtClick:Find("other"), not var0)
		setActive(arg0.rtPanel, true)
	end
end

function var0.HideWindow(arg0)
	setAnchoredPosition(arg0.rtAnim, Vector2.zero)
	setActive(arg0.rtPanel, false)
end

function var0.EaseInOut(arg0, arg1, arg2)
	if arg0.alphaLT then
		LeanTween.cancel(arg0.alphaLT)
	end

	arg0.canvas.alpha = arg1 and 0 or 1
	arg0.alphaLT = LeanTween.alphaCanvas(arg0.canvas, arg1 and 1 or 0, 1):setOnComplete(System.Action(arg2 or function()
		return
	end)).uniqueId
end

function var0.Update(arg0, arg1)
	if arg0.attachment ~= arg1 then
		arg0.attachment = arg1

		arg0:OnUpdate()
	end
end

function var0.OnUpdate(arg0)
	local var0 = arg0.map
	local var1 = arg0.attachment
	local var2 = arg0.rtTitle:Find("Text")
	local var3 = {}
	local var4 = {}
	local var5 = false
	local var6 = false
	local var7 = var1.config.name or ""

	if WorldMapAttachment.IsEnemyType(var1.type) then
		var5 = true
		var6 = false
		var3 = var1:GetBuffList()
		var4 = var0:GetBuffList(WorldMap.FactionEnemy, var1)

		if var1.config.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
			var7 = var7 .. " LV." .. WorldConst.WorldLevelCorrect(var0.config.expedition_level, var1.config.type)
		else
			var7 = var7 .. " LV." .. var1.config.level
		end
	elseif var1.type == WorldMapAttachment.TypeEvent then
		var3 = var1:GetBuffList()
		var4 = var0:GetBuffList(WorldMap.FactionEnemy, var1)

		local var8 = var1.config.is_scanevent

		if var8 == 1 or var8 == 3 then
			var5 = var8 == 3
			var6 = true

			setActive(arg0.rtInfo:Find("Image"), false)
			setText(arg0.rtInfo:Find("Text"), var1.config.scan_desc)
		elseif var8 == 2 or var8 == 4 then
			var5 = var8 == 4
			var6 = true

			setActive(arg0.rtInfo:Find("Image"), true)
			GetImageSpriteFromAtlasAsync("icondesc/" .. var1.config.icon, "", arg0.rtInfo:Find("Image"))
			setText(arg0.rtInfo:Find("Text"), var1.config.scan_desc)
		end
	elseif var1.type == WorldMapAttachment.TypeTrap then
		var5 = true
		var6 = true

		setActive(arg0.rtInfo:Find("Image"), true)

		local var9 = WorldBuff.GetTemplate(var1.config.buff_id)

		GetImageSpriteFromAtlasAsync("world/buff/" .. var9.icon, "", arg0.rtInfo:Find("Image"))
		setText(arg0.rtInfo:Find("Text"), var1.config.desc)
	elseif var1.type == WorldMapAttachment.TypePort then
		local var10 = var1.config.port_camp

		var5 = var10 > 0 and var10 ~= nowWorld():GetRealm()
		var6 = true

		setActive(arg0.rtInfo:Find("Image"), false)
		setText(arg0.rtInfo:Find("Text"), var1.config.scan_desc)
	end

	setText(var2, var7)

	local var11 = var1:GetWeaknessBuffId()

	arg0.buffList = {}
	arg0.weaknessList = {}

	for iter0, iter1 in ipairs(var3) do
		if iter1.id == var11 then
			table.insert(arg0.weaknessList, iter1)
		else
			table.insert(arg0.buffList, iter1)
		end
	end

	arg0.buffUIItemList:align(#arg0.buffList)
	arg0.weaknessUIItemList:align(#arg0.weaknessList)

	arg0.mapBuffList = var4

	arg0.mapBuffItemList:align(#arg0.mapBuffList)
	setActive(arg0.rtInfo, var6)
	setActive(arg0.rtMark, var6 and var5)
	setActive(arg0.rtTitle:Find("red"), var5)
	setActive(arg0.rtTitle:Find("yellow"), not var5)

	local var12 = var1:GetRadiationBuffs()

	setActive(arg0.rtRadiation, #var12 > 0)

	if #var12 > 0 then
		local var13, var14, var15 = unpack(var12[1])

		GetImageSpriteFromAtlasAsync("world/mapbuff/" .. pg.world_SLGbuff_data[var14].icon, "", arg0.rtRadiation:Find("info/map_buff/Image"))
		setText(arg0.rtRadiation:Find("info/Text"), i18n("world_mapbuff_tip"))
	end
end

return var0
