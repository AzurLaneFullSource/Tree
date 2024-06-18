local var0_0 = class("TowerClimbBgMgr")
local var1_0 = {
	{
		"1",
		"2",
		"3"
	},
	{
		"4",
		"5",
		"6"
	},
	{
		"7",
		"8",
		"9"
	}
}

var0_0.effects = {
	{
		{
			"pata_jiandan",
			{
				0,
				-179.5
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				46
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				61.5
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				-179.5
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				46
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				61.5
			}
		}
	},
	{
		{
			"pata_kunan",
			{
				0,
				-834.5
			}
		},
		{
			"pata_shandian01",
			{
				370,
				-47.5
			}
		},
		{
			"pata_shandian02",
			{
				370,
				601.5
			}
		}
	},
	{
		{
			"pata_shandian03",
			{
				-210,
				-764
			}
		},
		{
			"pata_shandian04",
			{
				220,
				-259
			}
		},
		{
			"pata_shandian03",
			{
				-210,
				252
			}
		},
		{
			"pata_shandian04",
			{
				252,
				639
			}
		}
	},
	{
		{
			"pata_shandian03",
			{
				-299,
				-99.50002
			}
		},
		{
			"pata_shandian04",
			{
				324,
				174.5
			}
		},
		{
			"pata_kunan",
			{
				0,
				52.5
			}
		}
	}
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tr = arg1_1
end

function var0_0.Init(arg0_2, arg1_2, arg2_2)
	var0_0.bgMaps = var1_0[arg1_2]

	assert(var0_0.bgMaps, arg1_2)

	arg0_2.list = {
		arg0_2.tr:Find("Image1"),
		arg0_2.tr:Find("Image2"),
		arg0_2.tr:Find("Image3")
	}
	arg0_2.names = {}

	local var0_2 = {}

	for iter0_2 = 1, 2 do
		setActive(arg0_2.list[iter0_2], false)
		table.insert(var0_2, function(arg0_3)
			local var0_3 = arg0_2:GetBg(iter0_2)

			arg0_2:LoadImage(var0_3, function(arg0_4)
				setActive(arg0_2.list[iter0_2], true)

				arg0_2.list[iter0_2]:GetComponent(typeof(Image)).sprite = arg0_4

				arg0_2.list[iter0_2]:GetComponent(typeof(Image)):SetNativeSize()
				arg0_3()
			end)

			arg0_2.names[arg0_2.list[iter0_2]] = var0_3

			arg0_2:LoadEffect(var0_3, arg0_2.list[iter0_2])
		end)
	end

	seriesAsync(var0_2, function()
		local var0_5 = 0

		for iter0_5, iter1_5 in ipairs(arg0_2.list) do
			local var1_5 = arg0_2.list[iter0_5 - 1]

			if var1_5 then
				var0_5 = var0_5 + var1_5.rect.height
			end

			setAnchoredPosition(iter1_5, {
				x = 0,
				z = 0,
				y = var0_5
			})
		end

		arg2_2()
	end)
end

function var0_0.DoMove(arg0_6, arg1_6, arg2_6)
	local var0_6 = {}
	local var1_6

	for iter0_6, iter1_6 in ipairs(arg0_6.list) do
		if iter1_6 then
			var1_6 = var1_6 or iter0_6

			table.insert(var0_6, function(arg0_7)
				local var0_7 = getAnchoredPosition(iter1_6)

				LeanTween.value(iter1_6.gameObject, iter1_6.anchoredPosition.y, var0_7.y - arg1_6 * 0.8, 0.2):setOnUpdate(System.Action_float(function(arg0_8)
					setAnchoredPosition(iter1_6, {
						y = arg0_8
					})
				end)):setEase(LeanTweenType.easeOutQuad):setOnComplete(System.Action(arg0_7))
			end)
		end
	end

	parallelAsync(var0_6, function()
		arg0_6:DoCheck(var1_6)
		arg2_6()
	end)
end

function var0_0.DoCheck(arg0_10, arg1_10)
	local var0_10 = arg0_10.list[arg1_10]
	local var1_10 = arg0_10.list[arg1_10 + 2]
	local var2_10 = getAnchoredPosition(var0_10)

	if var2_10.y + var0_10.rect.height + arg0_10.list[arg1_10 + 1].rect.height - arg0_10.tr.rect.height >= 50 then
		local var3_10 = var1_10:GetComponent(typeof(Image))
		local var4_10 = arg0_10:GetBg(arg1_10 + 2)

		if arg0_10.names[var1_10] ~= var4_10 then
			arg0_10:LoadImage(var4_10, function(arg0_11)
				setActive(var1_10, true)

				var3_10.sprite = arg0_11

				var3_10:SetNativeSize()
			end)
			arg0_10:LoadEffect(var4_10, var1_10)

			arg0_10.names[var1_10] = var4_10
		end
	end

	if math.abs(var2_10.y) >= var0_10.rect.height then
		var0_10:GetComponent(typeof(Image)).sprite = nil
		arg0_10.names[var0_10] = nil

		var0_10:SetAsFirstSibling()

		arg0_10.list[arg1_10 + 3] = var0_10
		arg0_10.list[arg1_10] = false

		local var5_10 = getAnchoredPosition(var1_10)

		setAnchoredPosition(var0_10, {
			y = var5_10.y + var1_10.rect.height
		})
		arg0_10:ReturnEffect(var0_10)
	end
end

function var0_0.GetBg(arg0_12, arg1_12)
	return var0_0.bgMaps[arg1_12] or var0_0.bgMaps[#var0_0.bgMaps]
end

function var0_0.LoadImage(arg0_13, arg1_13, arg2_13)
	LoadSpriteAtlasAsync("clutter/towerclimbing_bg" .. arg1_13, nil, function(arg0_14)
		arg2_13(arg0_14)
	end)
end

function var0_0.LoadEffect(arg0_15, arg1_15, arg2_15)
	local var0_15 = var0_0.effects[tonumber(arg1_15)]

	if var0_15 then
		for iter0_15, iter1_15 in ipairs(var0_15) do
			local var1_15 = iter1_15[1]
			local var2_15 = iter1_15[2]

			PoolMgr.GetInstance():GetUI(var1_15, true, function(arg0_16)
				if not arg0_15.list then
					PoolMgr.GetInstance():ReturnUI(var1_15, arg0_16)
				else
					arg0_16.name = var1_15

					SetParent(arg0_16, arg2_15)

					arg0_16.transform.anchoredPosition3D = Vector3(var2_15[1], var2_15[2], -200)

					setActive(arg0_16, true)
				end
			end)
		end
	end
end

function var0_0.ReturnEffect(arg0_17, arg1_17)
	local var0_17 = arg1_17.childCount

	if var0_17 > 0 then
		for iter0_17 = 1, var0_17 do
			local var1_17 = arg1_17:GetChild(iter0_17 - 1)

			PoolMgr.GetInstance():ReturnUI(var1_17.name, var1_17.gameObject)
		end
	end
end

function var0_0.Clear(arg0_18)
	eachChild(arg0_18.tr, function(arg0_19)
		arg0_19:GetComponent(typeof(Image)).sprite = nil

		arg0_18:ReturnEffect(arg0_19)
	end)

	arg0_18.list = nil
	arg0_18.names = nil
end

return var0_0
