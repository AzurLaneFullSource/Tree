local var0 = class("AnniversaryIslandHotSpringScene", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringScene"))

function var0.getUIName(arg0)
	return "AnniversaryIslandHotSpringUI"
end

local var1 = 0.85

function var0.init(arg0)
	arg0.scrollRect = arg0._tf:Find("ScrollRect")
	arg0.scrollContent = arg0.scrollRect:GetComponent(typeof(ScrollRect)).content
	arg0.slotTFs = _.map(_.range(4, 15), function(arg0)
		return arg0.scrollRect:Find("Pool"):GetChild(arg0 - 1)
	end)

	local var0 = table.remove(arg0.slotTFs, 12)
	local var1 = table.remove(arg0.slotTFs, 11)

	table.insert(arg0.slotTFs, 1, var1)
	table.insert(arg0.slotTFs, 7, var0)

	arg0.slotOriginalPos = _.map(arg0.slotTFs, function(arg0)
		return arg0.anchoredPosition
	end)
	arg0.slotShipPos = Clone(arg0.slotOriginalPos)

	table.Foreach(arg0:GetRecordPos(), function(arg0, arg1)
		arg0.slotShipPos[arg0] = arg1
	end)

	arg0.poolItems = _.map(_.range(arg0.scrollRect:Find("Pool").childCount), function(arg0)
		return arg0.scrollRect:Find("Pool"):GetChild(arg0 - 1)
	end)

	Canvas.ForceUpdateCanvases()

	arg0.scrollBGs = _.map({
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
			var1
		},
		{
			"Pool",
			var1
		},
		{
			"4",
			1
		},
		{
			"5",
			1
		}
	}, function(arg0)
		local var0 = {
			arg0.scrollRect:Find(arg0[1]),
			arg0[2]
		}

		var0[3] = var0[1].anchoredPosition.x

		arg0:UpdateScrollContent(0, unpack(var0))

		return var0
	end)
	arg0.top = arg0._tf:Find("Top")

	pg.ViewUtils.SetSortingOrder(arg0._tf, -1001)

	arg0.spineRoles = {}
	arg0.washMaterial = Material.New(pg.ShaderMgr.GetInstance():GetShader("M02/Unlit_Colored_Semitransparent"))

	arg0.washMaterial:SetFloat("_Height", 0.5)
end

function var0.SetActivity(arg0, arg1)
	local var0 = arg0.activity

	arg0.activity = arg1

	if not var0 then
		return
	end

	table.Foreach(var0.data1_list, function(arg0, arg1)
		if arg1 > 0 and (arg1.data1_list[arg0] or 0) == 0 then
			arg0.slotShipPos[arg0] = Clone(arg0.slotOriginalPos[arg0])
		end
	end)
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	pg.NewStoryMgr.GetInstance():Play(arg0.activity:getConfig("config_client").unlockstory)
end

function var0.UpdateView(arg0)
	arg0:UpdateSlots()
end

function var0.GetRecordPos(arg0)
	local var0 = PlayerPrefs.GetString("hotspring_ship_pos_2023", "")
	local var1 = _.map(string.split(var0, ";"), function(arg0)
		return tonumber(arg0)
	end)
	local var2 = {}

	for iter0 = 1, #var1, 2 do
		table.insert(var2, Vector2.New(var1[iter0], var1[iter0 + 1]))
	end

	return var2
end

function var0.RecordPos(arg0, arg1)
	if not arg1 then
		return
	end

	local var0 = table.concat(_.reduce(arg1, {}, function(arg0, arg1)
		table.insert(arg0, arg1.x)
		table.insert(arg0, arg1.y)

		return arg0
	end), ";")

	PlayerPrefs.SetString("hotspring_ship_pos_2023", var0)
end

return var0
