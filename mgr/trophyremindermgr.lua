pg = pg or {}

local var0 = pg

var0.TrophyReminderMgr = singletonClass("TrophyReminderMgr")

local var1 = var0.TrophyReminderMgr

function var1.Ctor(arg0)
	arg0._go = nil
end

function var1.Init(arg0, arg1)
	print("initializing tip manager...")

	arg0._count = 0
	arg0._tipTable = {}

	PoolMgr.GetInstance():GetUI("TrophyRemindPanel", true, function(arg0)
		arg0._go = arg0

		arg0._go:SetActive(false)

		local var0 = GameObject.Find("Overlay/UIOverlay")

		arg0._go.transform:SetParent(var0.transform, false)

		arg0._tips = arg0._go.transform:Find("trophyRemind")
		arg0._grid = arg0._go.transform:Find("Grid_trophy")

		arg1()
	end)
end

function var1.ShowTips(arg0, arg1)
	var0.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_TIP)
	arg0._go.transform:SetAsLastSibling()
	SetActive(arg0._go, true)

	arg0._count = arg0._count + 1

	local var0 = cloneTplTo(arg0._tips, arg0._grid)
	local var1 = var0.medal_template[arg1]

	LoadImageSpriteAsync("medal/s_" .. var1.icon, var0.transform:Find("content/icon"), true)
	setText(var0.transform:Find("content/name"), var1.name)
	setText(var0.transform:Find("content/label"), i18n("trophy_achieved"))

	local var2 = var0.transform:Find("content")

	var2.localPosition = Vector3(-850, 0, 0)

	;(function(arg0)
		LeanTween.moveX(rtf(var2), -275, 0.5)
		LeanTween.moveX(rtf(var2), -850, 0.5):setDelay(5):setOnComplete(System.Action(function()
			Destroy(arg0)

			arg0._count = arg0._count - 1

			if arg0._count == 0 then
				SetActive(arg0._go, false)
			end
		end))
	end)(var0)
end
