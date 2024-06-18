pg = pg or {}

local var0_0 = pg

var0_0.TipsMgr = singletonClass("TipsMgr")

local var1_0 = var0_0.TipsMgr

function var1_0.Ctor(arg0_1)
	arg0_1._go = nil
end

function var1_0.Init(arg0_2, arg1_2)
	print("initializing tip manager...")

	arg0_2._count = 0
	arg0_2._tipTable = {}

	PoolMgr.GetInstance():GetUI("TipPanel", true, function(arg0_3)
		arg0_2._go = arg0_3

		arg0_2._go:SetActive(false)

		local var0_3 = GameObject.Find("Overlay/UIOverlay")

		arg0_2._go.transform:SetParent(var0_3.transform, false)

		arg0_2._tips = arg0_2._go.transform:Find("toolTip")
		arg0_2._picTips = arg0_2._go.transform:Find("toolPicTip")
		arg0_2._grid = arg0_2._go.transform:Find("Grid")

		arg1_2()
	end)
end

function var1_0.ShowTips(arg0_4, arg1_4, arg2_4, arg3_4)
	var0_0.CriMgr.GetInstance():PlaySoundEffect_V3(arg3_4 or SFX_UI_TIP)
	arg0_4._go.transform:SetAsLastSibling()
	SetActive(arg0_4._go, true)

	arg0_4._count = arg0_4._count + 1

	local var0_4 = cloneTplTo(arg0_4._tips, arg0_4._grid)
	local var1_4 = arg2_4 or "white"

	setText(var0_4.transform:Find("Text"), "<color=" .. var1_4 .. ">" .. arg1_4 .. "</color>")

	var0_4.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(var0_4, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(var0_4, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	local function var2_4(arg0_5, arg1_5)
		local var0_5 = GetOrAddComponent(arg0_5, "CanvasGroup")

		Timer.New(function()
			if IsNil(arg0_5) then
				return
			end

			LeanTween.scale(arg0_5, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
				LeanTween.scale(arg0_5, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
					Destroy(arg0_5)

					for iter0_8, iter1_8 in pairs(arg0_4._tipTable) do
						if iter1_8 == arg0_5 then
							table.remove(arg0_4._tipTable, iter0_8)
						end
					end

					arg0_4._count = arg0_4._count - 1

					if arg0_4._count == 0 then
						SetActive(arg0_4._go, false)
					end
				end))
			end))
		end, 3):Start()
	end

	if arg0_4._count <= 3 then
		arg0_4._tipTable[arg0_4._count] = var0_4

		var2_4(var0_4, arg0_4._count)
	else
		Destroy(arg0_4._tipTable[1])
		table.remove(arg0_4._tipTable, 1)

		arg0_4._count = 3
		arg0_4._tipTable[3] = var0_4

		var2_4(var0_4, arg0_4._count)
	end
end

function var1_0.ShowPicTips(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	var0_0.CriMgr.GetInstance():PlaySoundEffect_V3(arg4_9 or SFX_UI_TIP)
	arg0_9._go.transform:SetAsLastSibling()
	SetActive(arg0_9._go, true)

	arg0_9._count = arg0_9._count + 1

	local var0_9 = cloneTplTo(arg0_9._picTips, arg0_9._grid)
	local var1_9 = arg3_9 or "white"

	setText(var0_9.transform:Find("Text"), "<color=" .. var1_9 .. ">\"" .. arg1_9 .. "\" x" .. arg2_9 .. "</color>")

	local function var2_9(arg0_10)
		local var0_10 = GetOrAddComponent(arg0_10, "CanvasGroup")

		var0_10.alpha = 1

		local var1_10 = LeanTween.alphaCanvas(var0_10, 0, 5):setUseEstimatedTime(true):setOnComplete(System.Action(function()
			Destroy(arg0_10)

			for iter0_11, iter1_11 in pairs(arg0_9._tipTable) do
				if iter1_11 == arg0_10 then
					table.remove(arg0_9._tipTable, iter0_11)
				end
			end

			arg0_9._count = arg0_9._count - 1

			if arg0_9._count == 0 then
				SetActive(arg0_9._go, false)
			end
		end))
	end

	if arg0_9._count <= 3 then
		arg0_9._tipTable[arg0_9._count] = var0_9

		var2_9(var0_9)
	else
		Destroy(arg0_9._tipTable[1])
		table.remove(arg0_9._tipTable, 1)

		arg0_9._count = 3
		arg0_9._tipTable[3] = var0_9

		var2_9(var0_9)
	end
end
