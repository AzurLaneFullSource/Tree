local var0_0 = class("PacGameEditorController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneMask = arg1_1
	arg0_1._event = arg2_1
	arg0_1._runningData = arg3_1
	arg0_1._content = findTF(arg0_1._sceneMask, "sceneContainer/scene/content/editor")
	arg0_1._mapTF = findTF(arg0_1._sceneMask, "sceneContainer/scene/content/map")
	arg0_1._editorUI = findTF(arg0_1._sceneMask, "sceneContainer/scene/content/editor_ui")
	arg0_1._editorGrids = {}
	arg0_1._editorGridDic = {}
	arg0_1._mapCreateGridDic = {}
end

function var0_0.SetParent(arg0_2)
	return
end

function var0_0.SetPosition(arg0_3)
	return
end

function var0_0.SetScale(arg0_4)
	return
end

function var0_0.SetGridIndex(arg0_5)
	return
end

function var0_0.Prepare(arg0_6)
	arg0_6._editorFlag = arg0_6._runningData:GetEditor()
	arg0_6._content.anchoredPosition = arg0_6._mapTF.anchoredPosition
end

function var0_0.Start(arg0_7)
	setActive(arg0_7._content, arg0_7._editorFlag)
	setActive(arg0_7._editorUI, arg0_7._editorFlag)

	if arg0_7._editorFlag then
		arg0_7:instanceEditorUI()
		arg0_7:createEditorGrid()
	end
end

function var0_0.Step(arg0_8, arg1_8)
	if not arg0_8._editorFlag then
		return
	end

	arg0_8._deltaTime = arg1_8
end

function var0_0.updateReflashTime(arg0_9)
	return
end

function var0_0.Clear(arg0_10)
	arg0_10._editorFlag = nil

	for iter0_10, iter1_10 in pairs(arg0_10._mapCreateGridDic) do
		iter1_10:Dispose()
	end

	arg0_10._mapCreateGridDic = {}
end

function var0_0.Stop(arg0_11)
	return
end

function var0_0.Resume(arg0_12)
	return
end

function var0_0.Dispose(arg0_13)
	for iter0_13 = 1, #arg0_13._editorGrids do
		local var0_13 = arg0_13._editorGrids[iter0_13]
		local var1_13 = GetOrAddComponent(var0_13, typeof(EventTriggerListener))

		ClearEventTrigger(var1_13)
	end

	if arg0_13._btnOpenTrigger then
		ClearEventTrigger(arg0_13._btnOpenTrigger)

		arg0_13._btnOpenTrigger = nil
	end

	if arg0_13._btnExportTrigger then
		ClearEventTrigger(arg0_13._btnExportTrigger)

		arg0_13._btnExportTrigger = nil
	end

	for iter1_13 = 1, #arg0_13._btnChapters do
		ClearEventTrigger(arg0_13._btnChapters[iter1_13])
	end

	for iter2_13 = 1, #arg0_13._gridPanelTFS do
		local var2_13 = arg0_13._gridPanelTFS[iter2_13]
		local var3_13 = GetOrAddComponent(tf, typeof(EventTriggerListener))

		ClearEventTrigger(var3_13)
	end

	arg0_13._editorGridDic = {}
end

function var0_0.instanceEditorUI(arg0_14)
	if arg0_14._initFlag then
		return
	end

	arg0_14._inputPanel = findTF(arg0_14._editorUI, "exportPanel")

	setActive(arg0_14._inputPanel, false)

	arg0_14._inputField = GetOrAddComponent(findTF(arg0_14._editorUI, "exportPanel/text"), typeof(InputField))
	arg0_14._initFlag = true
	arg0_14._gridList = findTF(arg0_14._editorUI, "gridList")
	arg0_14._gridContent = findTF(arg0_14._gridList, "content")
	arg0_14._gridPanelTFS = {}

	for iter0_14, iter1_14 in pairs(PacGameConst.grid_data) do
		if not iter1_14.editor_ignore then
			local var0_14 = iter1_14.prefab
			local var1_14 = arg0_14._runningData:GetTplItemFromPool(var0_14, arg0_14._gridContent)

			setActive(findTF(var1_14, "ad/bottom"), true)
			setActive(findTF(var1_14, "ad/select"), false)
			GetOrAddComponent(var1_14, typeof(EventTriggerListener)):AddPointDownFunc(function()
				print("grid = " .. iter1_14.prefab)

				if arg0_14._selectGridTF then
					setActive(findTF(arg0_14._selectGridTF, "ad/select"), false)
				end

				arg0_14._selectGridData = iter1_14
				arg0_14._selectGridTF = var1_14

				setActive(findTF(arg0_14._selectGridTF, "ad/select"), true)
			end)
			table.insert(arg0_14._gridPanelTFS, var1_14)
		end
	end

	arg0_14._btnOpenTrigger = GetOrAddComponent(findTF(arg0_14._editorUI, "btnOpen"), typeof(EventTriggerListener))

	arg0_14._btnOpenTrigger:AddPointDownFunc(function()
		setActive(arg0_14._gridList, not isActive(arg0_14._gridList) and true or false)
	end)

	arg0_14._btnExportTrigger = GetOrAddComponent(findTF(arg0_14._editorUI, "btnExport"), typeof(EventTriggerListener))

	arg0_14._btnExportTrigger:AddPointDownFunc(function()
		setActive(arg0_14._inputPanel, not isActive(arg0_14._inputPanel) and true or false)
		setInputText(arg0_14._inputField, arg0_14:getExportText())
		print("export")
	end)

	arg0_14._btnChapters = {}

	for iter2_14 = 1, 7 do
		local var2_14 = GetOrAddComponent(findTF(arg0_14._editorUI, "btnChapter_" .. iter2_14), typeof(EventTriggerListener))

		table.insert(arg0_14._btnChapters, var2_14)
		var2_14:AddPointDownFunc(function()
			arg0_14:importChapter(iter2_14)
		end)
	end
end

function var0_0.importChapter(arg0_19, arg1_19)
	local var0_19 = PacGameConst.chapter_data[arg1_19].map
	local var1_19 = PacGameConst.map_data[var0_19].grid_list

	for iter0_19 = 1, #var1_19 do
		local var2_19 = var1_19[iter0_19]

		for iter1_19 = 1, #var2_19 do
			local var3_19 = var2_19[iter1_19]
			local var4_19 = iter1_19 + (iter0_19 - 1) * #var2_19

			arg0_19:setCreateGridDic(var4_19, var3_19)
		end
	end
end

function var0_0.getExportText(arg0_20)
	local var0_20 = arg0_20._runningData:GetGrids()
	local var1_20, var2_20 = arg0_20._runningData:GetGridWH()
	local var3_20 = {}

	for iter0_20 = 1, #var0_20 do
		local var4_20 = math.floor((iter0_20 - 1) / var2_20) + 1
		local var5_20 = (iter0_20 - 1) % var2_20
		local var6_20 = var0_20[iter0_20]:GetIndex()
		local var7_20 = arg0_20._mapCreateGridDic[var6_20]
		local var8_20 = 0

		if var7_20 then
			var8_20 = var7_20:GetId()
		end

		if not var3_20[var4_20] then
			var3_20[var4_20] = {}
		end

		if var8_20 == PacGameConst.default_grid then
			var8_20 = 0
		end

		table.insert(var3_20[var4_20], var8_20)
	end

	local var9_20 = ""

	for iter1_20 = 1, #var3_20 do
		local var10_20 = var3_20[iter1_20]

		var9_20 = var9_20 .. "{"

		for iter2_20 = 1, #var10_20 do
			if iter2_20 == 1 then
				var9_20 = var9_20 .. var10_20[iter2_20]
			else
				var9_20 = var9_20 .. "," .. var10_20[iter2_20]
			end
		end

		if iter1_20 ~= #var3_20 then
			var9_20 = var9_20 .. "},\n"
		else
			var9_20 = var9_20 .. "},"
		end
	end

	return var9_20
end

function var0_0.createEditorGrid(arg0_21)
	if not arg0_21._editorGrids or #arg0_21._editorGrids <= 0 then
		local function var0_21(arg0_22, arg1_22)
			GetOrAddComponent(arg0_22, typeof(EventTriggerListener)):AddPointDownFunc(function()
				if arg0_21._selectGridData then
					arg0_21:setCreateGridDic(arg1_22, arg0_21._selectGridData.id)
				else
					arg0_21:setCreateGridDic(arg1_22, PacGameConst.default_grid)
				end
			end)
		end

		local var1_21 = arg0_21._runningData:GetGridDic()

		for iter0_21, iter1_21 in pairs(var1_21) do
			local var2_21 = iter1_21:GetIndex()
			local var3_21 = iter1_21:GetPosition()
			local var4_21 = PacGameConst.grid_data[PacGameConst.editor_grid].prefab
			local var5_21 = arg0_21._runningData:GetTplItemFromPool(var4_21, arg0_21._content)

			setActive(findTF(var5_21, "ad/select"), false)
			setActive(var5_21, true)

			var5_21.anchoredPosition = var3_21

			setText(findTF(var5_21, "ad/text"), var2_21)
			setActive(findTF(var5_21, "ad/red"), false)
			var0_21(var5_21, var2_21)
			table.insert(arg0_21._editorGrids, var5_21)

			arg0_21._editorGridDic[var2_21] = var5_21
		end
	end
end

function var0_0.setCreateGridDic(arg0_24, arg1_24, arg2_24)
	if arg0_24._mapCreateGridDic[arg1_24] then
		local var0_24 = arg0_24._mapCreateGridDic[arg1_24]:GetId()

		arg0_24._mapCreateGridDic[arg1_24]:Dispose()

		arg0_24._mapCreateGridDic[arg1_24] = nil

		setActive(findTF(arg0_24._editorGridDic[arg1_24], "ad/red"), false)

		if var0_24 ~= 0 and var0_24 ~= PacGameConst.default_grid then
			return
		end
	end

	if arg2_24 then
		if arg2_24 == 0 then
			arg2_24 = PacGameConst.default_grid
		end

		local var1_24 = PacGameConst.grid_data[arg2_24]
		local var2_24 = arg0_24._runningData:GetTplItemFromPool(var1_24.prefab, arg0_24._mapTF)
		local var3_24 = PacGameGrid.New(var2_24, arg1_24, arg2_24)
		local var4_24 = arg0_24._editorGridDic[arg1_24].anchoredPosition

		var3_24:SetPosition(var4_24)
		var3_24:SetActive(true)
		setActive(findTF(arg0_24._editorGridDic[arg1_24], "ad/red"), not var1_24.pass)

		arg0_24._mapCreateGridDic[arg1_24] = var3_24
	end
end

return var0_0
