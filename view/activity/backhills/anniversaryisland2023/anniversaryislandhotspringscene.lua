local var0_0 = class("AnniversaryIslandHotSpringScene", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringScene"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryIslandHotSpringUI"
end

local var1_0 = 0.85

function var0_0.init(arg0_2)
	arg0_2.scrollRect = arg0_2._tf:Find("ScrollRect")
	arg0_2.scrollContent = arg0_2.scrollRect:GetComponent(typeof(ScrollRect)).content
	arg0_2.slotTFs = _.map(_.range(4, 15), function(arg0_3)
		return arg0_2.scrollRect:Find("Pool"):GetChild(arg0_3 - 1)
	end)

	local var0_2 = table.remove(arg0_2.slotTFs, 12)
	local var1_2 = table.remove(arg0_2.slotTFs, 11)

	table.insert(arg0_2.slotTFs, 1, var1_2)
	table.insert(arg0_2.slotTFs, 7, var0_2)

	arg0_2.slotOriginalPos = _.map(arg0_2.slotTFs, function(arg0_4)
		return arg0_4.anchoredPosition
	end)
	arg0_2.slotShipPos = Clone(arg0_2.slotOriginalPos)

	table.Foreach(arg0_2:GetRecordPos(), function(arg0_5, arg1_5)
		arg0_2.slotShipPos[arg0_5] = arg1_5
	end)

	arg0_2.poolItems = _.map(_.range(arg0_2.scrollRect:Find("Pool").childCount), function(arg0_6)
		return arg0_2.scrollRect:Find("Pool"):GetChild(arg0_6 - 1)
	end)

	Canvas.ForceUpdateCanvases()

	arg0_2.scrollBGs = _.map({
		{
			"1",
			0.5
		},
		{
			"2",
			0.6
		},
		{
			"3",
			var1_0
		},
		{
			"Pool",
			var1_0
		},
		{
			"4",
			1
		},
		{
			"5",
			1
		}
	}, function(arg0_7)
		local var0_7 = {
			arg0_2.scrollRect:Find(arg0_7[1]),
			arg0_7[2]
		}

		var0_7[3] = var0_7[1].anchoredPosition.x

		arg0_2:UpdateScrollContent(0, unpack(var0_7))

		return var0_7
	end)
	arg0_2.top = arg0_2._tf:Find("Top")

	pg.ViewUtils.SetSortingOrder(arg0_2._tf, -1001)

	arg0_2.spineRoles = {}
	arg0_2.washMaterial = Material.New(pg.ShaderMgr.GetInstance():GetShader("M02/Unlit_Colored_Semitransparent"))

	arg0_2.washMaterial:SetFloat("_Height", 0.5)
end

function var0_0.SetActivity(arg0_8, arg1_8)
	local var0_8 = arg0_8.activity

	arg0_8.activity = arg1_8

	if not var0_8 then
		return
	end

	table.Foreach(var0_8.data1_list, function(arg0_9, arg1_9)
		if arg1_9 > 0 and (arg1_8.data1_list[arg0_9] or 0) == 0 then
			arg0_8.slotShipPos[arg0_9] = Clone(arg0_8.slotOriginalPos[arg0_9])
		end
	end)
end

function var0_0.didEnter(arg0_10)
	var0_0.super.didEnter(arg0_10)
	pg.NewStoryMgr.GetInstance():Play(arg0_10.activity:getConfig("config_client").unlockstory)
end

function var0_0.UpdateView(arg0_11)
	arg0_11:UpdateSlots()
end

function var0_0.GetRecordPos(arg0_12)
	local var0_12 = PlayerPrefs.GetString("hotspring_ship_pos_2023", "")
	local var1_12 = _.map(string.split(var0_12, ";"), function(arg0_13)
		return tonumber(arg0_13)
	end)
	local var2_12 = {}

	for iter0_12 = 1, #var1_12, 2 do
		table.insert(var2_12, Vector2.New(var1_12[iter0_12], var1_12[iter0_12 + 1]))
	end

	return var2_12
end

function var0_0.RecordPos(arg0_14, arg1_14)
	if not arg1_14 then
		return
	end

	local var0_14 = table.concat(_.reduce(arg1_14, {}, function(arg0_15, arg1_15)
		table.insert(arg0_15, arg1_15.x)
		table.insert(arg0_15, arg1_15.y)

		return arg0_15
	end), ";")

	PlayerPrefs.SetString("hotspring_ship_pos_2023", var0_14)
end

return var0_0
