local var0_0 = class("IslandTechTreePanel", import("view.base.BaseSubView"))

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
	return "IslandTechTreePanel"
end

function var0_0.OnLoaded(arg0_2)
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
end

function var0_0.OnInit(arg0_3)
	arg0_3.itemUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_4, arg2_4)
		end
	end)

	arg0_3.lineDatas = {}
	arg0_3.displays = pg.island_technology_template.get_id_list_by_tech_belong[arg0_3.contextData.type]
	arg0_3.maxX, arg0_3.maxY = 0, 0

	for iter0_3, iter1_3 in ipairs(arg0_3.displays) do
		local var0_3 = pg.island_technology_template[iter1_3].axis

		arg0_3.maxX = math.max(arg0_3.maxX, var0_3[1])
		arg0_3.maxY = math.max(arg0_3.maxY, var0_3[2])
	end

	arg0_3.maxX = arg0_3.maxX + 1
	arg0_3.maxY = math.max(var0_0.DEFAULT_MAX_Y, arg0_3.maxY + 1)

	arg0_3:InitTreeCS(arg0_3.maxX, arg0_3.maxY)
end

function var0_0.UpdateItem(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.displays[arg1_5 + 1]

	arg2_5.name = var0_5

	local var1_5 = arg0_5.techAgency:GetTechnology(var0_5)

	setAnchoredPosition(arg2_5, arg0_5:GetPositionById(var1_5.id))
	setActive(arg2_5:Find("selected"), false)
	setText(arg2_5:Find("name"), var1_5:getConfig("tech_name"))

	local var2_5 = var1_5:GetStatus()
	local var3_5 = var2_5 == IslandTechnology.STATUS.FINISHED

	setTextColor(arg2_5:Find("name"), Color.NewHex(var3_5 and "1b3650" or "ffffff"))
	LoadImageSpriteAsync("island/IslandTechnology/" .. var1_5:getConfig("tech_icon"), arg2_5:Find("icon"), true)
	setImageColor(arg2_5:Find("icon"), Color.NewHex(var3_5 and "455a81" or "ffffff"))
	setActive(arg2_5:Find("icon"), var2_5 ~= IslandTechnology.STATUS.STUDYING and var2_5 ~= IslandTechnology.STATUS.RECEIVE)
	eachChild(arg2_5:Find("back"), function(arg0_6)
		setActive(arg0_6, arg0_6.name == var2_5)
	end)
	setActive(arg2_5:Find("back/normal"), not var3_5 and var2_5 ~= IslandTechnology.STATUS.STUDYING)
	eachChild(arg2_5:Find("front"), function(arg0_7)
		setActive(arg0_7, arg0_7.name == var2_5)
	end)
	onButton(arg0_5, arg2_5, function()
		local var0_8 = arg0_5._tf:InverseTransformPoint(arg2_5.position)

		existCall(arg0_5.contextData.onItemClick, var1_5.id, var0_8)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_9)
	arg0_9.super.Show(arg0_9)
	arg0_9:Flush()
end

function var0_0.Flush(arg0_10)
	arg0_10.techAgency = getProxy(IslandProxy):GetIsland():GetTechnologyAgency()

	arg0_10.itemUIList:align(#arg0_10.displays)
end

function var0_0.InitTreeCS(arg0_11, arg1_11, arg2_11)
	arg0_11.gridSize = {
		x = var0_0.ELEMENT_SIZE.x / 2,
		y = var0_0.ELEMENT_SIZE.y / 2
	}

	setSizeDelta(arg0_11.showContent, {
		x = arg0_11.gridSize.x * arg1_11 + var0_0.VIEW_PADDING,
		y = arg0_11.gridSize.y * arg2_11
	})

	arg0_11.idx2pos = {}

	for iter0_11 = 0, arg1_11 do
		for iter1_11 = 0, arg2_11 do
			local var0_11 = iter0_11 .. "_" .. iter1_11

			arg0_11.idx2pos[var0_11] = {
				x = arg0_11.gridSize.x * iter0_11,
				y = -arg0_11.gridSize.y * iter1_11
			}

			local var1_11 = cloneTplTo(arg0_11.debugContainer:Find("tpl"), arg0_11.debugContainer)

			var1_11.name = var0_11

			setLocalPosition(var1_11, arg0_11.idx2pos[var0_11])
		end
	end

	for iter2_11, iter3_11 in pairs(arg0_11:GetTechTreeLineData()) do
		for iter4_11, iter5_11 in ipairs(iter3_11) do
			arg0_11:UpdateLineTpl(iter2_11, iter5_11)
		end
	end
end

function var0_0.GetPositionById(arg0_12, arg1_12)
	local var0_12 = pg.island_technology_template[arg1_12].axis

	return {
		x = arg0_12.gridSize.x * var0_12[1],
		y = -arg0_12.gridSize.y * var0_12[2]
	}
end

function var0_0.UpdateLineTpl(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13:GetPositionById(arg1_13)
	local var1_13 = arg0_13:GetPositionById(arg2_13)
	local var2_13 = arg0_13:GetLineOutPutPos(var0_13)
	local var3_13 = arg0_13:GetLineInPutPos(var1_13)

	if var0_13.y == var1_13.y then
		local var4_13 = cloneTplTo(arg0_13.lineTpls[var0_0.LINE_TYPE.S], arg0_13.lineContainer)

		setLocalPosition(var4_13, var2_13)
		setSizeDelta(var4_13, {
			x = var3_13.x - var2_13.x,
			y = var4_13.sizeDelta.y
		})
	else
		local var5_13 = math.abs(var3_13.y - var2_13.y)
		local var6_13 = var5_13 <= var0_0.ELEMENT_SIZE.y / 2 and var0_0.LINE_TYPE.C1 or var0_0.LINE_TYPE.C2
		local var7_13 = cloneTplTo(arg0_13.lineTpls[var6_13], arg0_13.lineContainer)

		setLocalScale(var7_13, {
			y = var1_13.y > var0_13.y and -1 or 1
		})
		setLocalPosition(var7_13, var2_13)
		setSizeDelta(var7_13, {
			x = var3_13.x - var2_13.x,
			y = var5_13 + 6
		})
	end
end

function var0_0.GetLineOutPutPos(arg0_14, arg1_14)
	return {
		x = arg1_14.x + 205,
		y = arg1_14.y
	}
end

function var0_0.GetLineInPutPos(arg0_15, arg1_15)
	return {
		x = arg1_15.x - 210,
		y = arg1_15.y
	}
end

function var0_0.GetTechTreeLineData(arg0_16)
	local var0_16 = pg.island_technology_template
	local var1_16 = {}

	for iter0_16, iter1_16 in ipairs(var0_16.get_id_list_by_tech_belong[arg0_16.contextData.type]) do
		local var2_16 = var0_16[iter1_16]

		for iter2_16, iter3_16 in ipairs(var2_16.ex_tech) do
			assert(var0_16[iter3_16], "配置了不存在的ex_tech: " .. iter3_16)

			if not var1_16[iter3_16] then
				var1_16[iter3_16] = {}
			end

			if not table.contains(var1_16[iter3_16], iter1_16) then
				table.insert(var1_16[iter3_16], iter1_16)
			end
		end

		if not var1_16[iter1_16] then
			var1_16[iter1_16] = {}
		end

		var1_16[iter1_16] = table.mergeArray(var1_16[iter1_16], var2_16.next_tech, true)

		local var3_16 = var2_16.axis[1]

		for iter4_16, iter5_16 in ipairs(var1_16[iter1_16]) do
			assert(var0_16[iter5_16], "配置了不存在的next_tech: " .. iter5_16)

			local var4_16 = var0_16[iter5_16].axis[1]

			assert(var4_16 - var3_16 > 2, string.format("岛屿科技树框体点位间隔过近,请检查配置: %d->%d", iter1_16, iter5_16))
		end
	end

	return var1_16
end

function var0_0.OnDestroy(arg0_17)
	return
end

return var0_0
