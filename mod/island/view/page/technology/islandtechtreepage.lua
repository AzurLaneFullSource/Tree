local var0_0 = class("IslandTechTreePage", import("...base.IslandBasePage"))

var0_0.VIEW_PADDING = 200
var0_0.ELEMENT_SIZE = {
	x = 410,
	y = 180
}
var0_0.LINE_TYPE = {
	C2 = 3,
	S = 1,
	C1 = 2
}
var0_0.DEFAULT_MAX_Y = 10

function var0_0.getUIName(arg0_1)
	return "IslandTechTreeUI"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("types/content")

	arg0_2.typeUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))
	arg0_2.treeView = arg0_2._tf:Find("view")
	arg0_2.showContent = arg0_2.treeView:Find("content")
	arg0_2.debugContainer = arg0_2.showContent:Find("debug")
	arg0_2.itemUIList = UIItemList.New(arg0_2.showContent:Find("items"), arg0_2.showContent:Find("items/tpl"))
	arg0_2.lineContainer = arg0_2.showContent:Find("lines")
	arg0_2.lineTpls = {
		[var0_0.LINE_TYPE.S] = arg0_2._tf:Find("line_tpls/s"),
		[var0_0.LINE_TYPE.C1] = arg0_2._tf:Find("line_tpls/c1"),
		[var0_0.LINE_TYPE.C2] = arg0_2._tf:Find("line_tpls/c2")
	}
	arg0_2.quickPanel = IslandTechQuickPanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.detailPanel = IslandTechDetailPanel.New(arg0_2._tf, arg0_2.event, setmetatable({
		onSelecteShip = function()
			arg0_2:OpenPage(IslandShipSelectPage, nil, function(arg0_4)
				arg0_2.detailPanel:ExecuteAction("OnShipSelected", arg0_4)
			end)
		end
	}, {
		__index = arg0_2.contextData
	}))
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("top/back"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("top/home"), function()
		arg0_5:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)

	arg0_5.types = IslandTechBelong.COMMON_SHOW_TYPES

	arg0_5.typeUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventInit then
			local var0_8 = arg0_5.types[arg1_8 + 1]

			arg2_8.name = var0_8

			local var1_8 = IslandTechBelong.Names[var0_8]

			setText(arg2_8:Find("sel/content/Text"), var1_8)
			setText(arg2_8:Find("unsel"), var1_8)
			onToggle(arg0_5, arg2_8, function()
				if arg0_5.curType and arg0_5.curType == var0_8 then
					return
				end

				arg0_5.curType = var0_8

				arg0_5:Flush()
			end, SFX_PANEL)
		end
	end)
	arg0_5.typeUIList:align(#arg0_5.types)
	arg0_5.itemUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg0_5:UpdateItem(arg1_10, arg2_10)
		end
	end)

	arg0_5.lineDatas = {}
end

function var0_0.AddListeners(arg0_11)
	arg0_11:AddListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_11.Flush)
	arg0_11:AddListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_11.Flush)
	arg0_11:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_11.Flush)
	arg0_11:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_11.Flush)
	arg0_11:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_11.Flush)
end

function var0_0.RemoveListeners(arg0_12)
	arg0_12:RemoveListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_12.Flush)
	arg0_12:RemoveListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_12.Flush)
	arg0_12:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_12.Flush)
	arg0_12:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_12.Flush)
	arg0_12:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_12.Flush)
end

function var0_0.OnShow(arg0_13, arg1_13)
	arg0_13.quickPanel:ExecuteAction("Show")

	arg0_13.curType = nil

	triggerToggle(arg0_13.typeUIList.container:Find(tostring(arg1_13)), true)
end

function var0_0.UpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.displays[arg1_14 + 1]

	arg2_14.name = var0_14

	local var1_14 = arg0_14.techAgency:GetTechnology(var0_14)

	setAnchoredPosition(arg2_14, arg0_14:GetPositionById(var1_14.id))
	setText(arg2_14:Find("name"), var1_14:getConfig("tech_name"))

	local var2_14 = var1_14:GetStatus()
	local var3_14 = var2_14 == IslandTechnology.STATUS.FINISHED

	setTextColor(arg2_14:Find("name"), Color.NewHex(var3_14 and "1b3650" or "ffffff"))
	LoadImageSpriteAsync("IslandTechnology/" .. var1_14:getConfig("tech_icon"), arg2_14:Find("icon"), true)
	setImageColor(arg2_14:Find("icon"), Color.NewHex(var3_14 and "455a81" or "ffffff"))
	eachChild(arg2_14:Find("back"), function(arg0_15)
		setActive(arg0_15, arg0_15.name == var2_14)
	end)
	setActive(arg2_14:Find("back/normal"), not var3_14 and var2_14 ~= IslandTechnology.STATUS.STUDYING)
	eachChild(arg2_14:Find("front"), function(arg0_16)
		setActive(arg0_16, arg0_16.name == var2_14)
	end)
	onButton(arg0_14, arg2_14, function()
		local var0_17 = arg0_14._tf:InverseTransformPoint(arg2_14.position)

		arg0_14.detailPanel:ExecuteAction("Show", var0_14, var0_17)
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_18)
	arg0_18.techAgency = getProxy(IslandProxy):GetIsland():GetTechnologyAgency()
	arg0_18.displays = pg.island_technology_template.get_id_list_by_tech_belong[arg0_18.curType]
	arg0_18.maxX, arg0_18.maxY = 0, 0

	for iter0_18, iter1_18 in ipairs(arg0_18.displays) do
		local var0_18 = pg.island_technology_template[iter1_18].axis

		arg0_18.maxX = math.max(arg0_18.maxX, var0_18[1])
		arg0_18.maxY = math.max(arg0_18.maxY, var0_18[2])
	end

	arg0_18.maxX = arg0_18.maxX + 1
	arg0_18.maxY = math.max(var0_0.DEFAULT_MAX_Y, arg0_18.maxY + 1)

	arg0_18:InitTreeCS(arg0_18.maxX, arg0_18.maxY)
	arg0_18.itemUIList:align(#arg0_18.displays)
	arg0_18:UpdateLines()

	if arg0_18.detailPanel:isShowing() then
		arg0_18.detailPanel:ExecuteAction("Flush")
	end

	arg0_18.quickPanel:ExecuteAction("Flush")
end

function var0_0.InitTreeCS(arg0_19, arg1_19, arg2_19)
	local var0_19 = {
		x = var0_0.ELEMENT_SIZE.x / 2,
		y = var0_0.ELEMENT_SIZE.y / 2
	}

	setSizeDelta(arg0_19.treeView, {
		x = var0_19.x * arg1_19 + var0_0.VIEW_PADDING,
		y = var0_19.y * arg2_19
	})

	arg0_19.idx2pos = {}

	for iter0_19 = 0, arg1_19 do
		for iter1_19 = 0, arg2_19 do
			local var1_19 = iter0_19 .. "_" .. iter1_19

			arg0_19.idx2pos[var1_19] = {
				x = var0_19.x * iter0_19,
				y = -var0_19.y * iter1_19
			}

			local var2_19 = cloneTplTo(arg0_19.debugContainer:Find("tpl"), arg0_19.debugContainer)

			var2_19.name = var1_19

			setLocalPosition(var2_19, arg0_19.idx2pos[var1_19])
		end
	end
end

function var0_0.GetPositionById(arg0_20, arg1_20)
	local var0_20 = pg.island_technology_template[arg1_20].axis

	return arg0_20.idx2pos[var0_20[1] .. "_" .. var0_20[2]] or {
		x = 0,
		y = 0
	}
end

function var0_0.UpdateLines(arg0_21)
	removeAllChildren(arg0_21.lineContainer)

	for iter0_21, iter1_21 in pairs(arg0_21:GetTechTreeLineData(arg0_21.curType)) do
		for iter2_21, iter3_21 in ipairs(iter1_21) do
			arg0_21:UpdateLineTpl(iter0_21, iter3_21)
		end
	end
end

function var0_0.UpdateLineTpl(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22:GetPositionById(arg1_22)
	local var1_22 = arg0_22:GetPositionById(arg2_22)
	local var2_22 = arg0_22:GetLineOutPutPos(var0_22)
	local var3_22 = arg0_22:GetLineInPutPos(var1_22)

	if var0_22.y == var1_22.y then
		local var4_22 = cloneTplTo(arg0_22.lineTpls[var0_0.LINE_TYPE.S], arg0_22.lineContainer)

		setLocalPosition(var4_22, var2_22)
		setSizeDelta(var4_22, {
			x = var3_22.x - var2_22.x,
			y = var4_22.sizeDelta.y
		})
	else
		local var5_22 = math.abs(var3_22.y - var2_22.y) <= var0_0.ELEMENT_SIZE.y / 2 and var0_0.LINE_TYPE.C1 or var0_0.LINE_TYPE.C2
		local var6_22 = cloneTplTo(arg0_22.lineTpls[var5_22], arg0_22.lineContainer)

		setLocalScale(var6_22, {
			y = var1_22.y > var0_22.y and -1 or 1
		})
		setLocalPosition(var6_22, var2_22)
	end
end

function var0_0.GetLineOutPutPos(arg0_23, arg1_23)
	return {
		x = arg1_23.x + 205,
		y = arg1_23.y
	}
end

function var0_0.GetLineInPutPos(arg0_24, arg1_24)
	return {
		x = arg1_24.x - 210,
		y = arg1_24.y
	}
end

function var0_0.GetTechTreeLineData(arg0_25, arg1_25)
	if arg0_25.lineDatas[arg1_25] then
		return arg0_25.lineDatas[arg1_25]
	end

	local var0_25 = pg.island_technology_template
	local var1_25 = {}

	for iter0_25, iter1_25 in ipairs(var0_25.get_id_list_by_tech_belong[arg1_25]) do
		local var2_25 = var0_25[iter1_25]

		for iter2_25, iter3_25 in ipairs(var2_25.ex_tech) do
			if not var1_25[iter3_25] then
				var1_25[iter3_25] = {}
			end

			if not table.contains(var1_25[iter3_25], iter1_25) then
				table.insert(var1_25[iter3_25], iter1_25)
			end
		end

		if not var1_25[iter1_25] then
			var1_25[iter1_25] = {}
		end

		var1_25[iter1_25] = table.mergeArray(var1_25[iter1_25], var2_25.next_tech, true)

		local var3_25 = var2_25.axis[1]

		for iter4_25, iter5_25 in ipairs(var1_25[iter1_25]) do
			local var4_25 = var0_25[iter5_25].axis[1]

			assert(var4_25 - var3_25 > 2, string.format("岛屿科技树框体点位间隔过近,请检查配置: %d->%d", iter1_25, iter5_25))
		end
	end

	arg0_25.lineDatas[arg1_25] = var1_25

	return arg0_25.lineDatas[arg1_25]
end

function var0_0.OnHide(arg0_26)
	arg0_26.quickPanel:ExecuteAction("OffToggle")
	arg0_26.quickPanel:ExecuteAction("Hide")
end

function var0_0.OnDestroy(arg0_27)
	if arg0_27.detailPanel then
		arg0_27.detailPanel:Destroy()

		arg0_27.detailPanel = nil
	end

	if arg0_27.quickPanel then
		arg0_27.quickPanel:Destroy()

		arg0_27.quickPanel = nil
	end
end

return var0_0
