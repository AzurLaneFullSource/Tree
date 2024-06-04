pg = pg or {}

local var0 = pg

var0.TipsMgr = singletonClass("TipsMgr")

local var1 = var0.TipsMgr

function var1.Ctor(arg0)
	arg0._go = nil
end

function var1.Init(arg0, arg1)
	print("initializing tip manager...")

	arg0._count = 0
	arg0._tipTable = {}

	PoolMgr.GetInstance():GetUI("TipPanel", true, function(arg0)
		arg0._go = arg0

		arg0._go:SetActive(false)

		local var0 = GameObject.Find("Overlay/UIOverlay")

		arg0._go.transform:SetParent(var0.transform, false)

		arg0._tips = arg0._go.transform:Find("toolTip")
		arg0._picTips = arg0._go.transform:Find("toolPicTip")
		arg0._grid = arg0._go.transform:Find("Grid")

		arg1()
	end)
end

function var1.ShowTips(arg0, arg1, arg2, arg3)
	var0.CriMgr.GetInstance():PlaySoundEffect_V3(arg3 or SFX_UI_TIP)
	arg0._go.transform:SetAsLastSibling()
	SetActive(arg0._go, true)

	arg0._count = arg0._count + 1

	local var0 = cloneTplTo(arg0._tips, arg0._grid)
	local var1 = arg2 or "white"

	setText(var0.transform:Find("Text"), "<color=" .. var1 .. ">" .. arg1 .. "</color>")

	var0.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(var0, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(var0, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	local function var2(arg0, arg1)
		local var0 = GetOrAddComponent(arg0, "CanvasGroup")

		Timer.New(function()
			if IsNil(arg0) then
				return
			end

			LeanTween.scale(arg0, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
				LeanTween.scale(arg0, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function()
					Destroy(arg0)

					for iter0, iter1 in pairs(arg0._tipTable) do
						if iter1 == arg0 then
							table.remove(arg0._tipTable, iter0)
						end
					end

					arg0._count = arg0._count - 1

					if arg0._count == 0 then
						SetActive(arg0._go, false)
					end
				end))
			end))
		end, 3):Start()
	end

	if arg0._count <= 3 then
		arg0._tipTable[arg0._count] = var0

		var2(var0, arg0._count)
	else
		Destroy(arg0._tipTable[1])
		table.remove(arg0._tipTable, 1)

		arg0._count = 3
		arg0._tipTable[3] = var0

		var2(var0, arg0._count)
	end
end

function var1.ShowPicTips(arg0, arg1, arg2, arg3, arg4)
	var0.CriMgr.GetInstance():PlaySoundEffect_V3(arg4 or SFX_UI_TIP)
	arg0._go.transform:SetAsLastSibling()
	SetActive(arg0._go, true)

	arg0._count = arg0._count + 1

	local var0 = cloneTplTo(arg0._picTips, arg0._grid)
	local var1 = arg3 or "white"

	setText(var0.transform:Find("Text"), "<color=" .. var1 .. ">\"" .. arg1 .. "\" x" .. arg2 .. "</color>")

	local function var2(arg0)
		local var0 = GetOrAddComponent(arg0, "CanvasGroup")

		var0.alpha = 1

		local var1 = LeanTween.alphaCanvas(var0, 0, 5):setUseEstimatedTime(true):setOnComplete(System.Action(function()
			Destroy(arg0)

			for iter0, iter1 in pairs(arg0._tipTable) do
				if iter1 == arg0 then
					table.remove(arg0._tipTable, iter0)
				end
			end

			arg0._count = arg0._count - 1

			if arg0._count == 0 then
				SetActive(arg0._go, false)
			end
		end))
	end

	if arg0._count <= 3 then
		arg0._tipTable[arg0._count] = var0

		var2(var0)
	else
		Destroy(arg0._tipTable[1])
		table.remove(arg0._tipTable, 1)

		arg0._count = 3
		arg0._tipTable[3] = var0

		var2(var0)
	end
end
