pg = pg or {}

local var0_0 = pg

var0_0.TrophyReminderMgr = singletonClass("TrophyReminderMgr")

local var1_0 = var0_0.TrophyReminderMgr

function var1_0.Ctor(arg0_1)
	arg0_1._go = nil
end

function var1_0.Init(arg0_2, arg1_2)
	print("initializing tip manager...")

	arg0_2._count = 0
	arg0_2._tipTable = {}

	PoolMgr.GetInstance():GetUI("TrophyRemindPanel", true, function(arg0_3)
		arg0_2._go = arg0_3

		arg0_2._go:SetActive(false)

		local var0_3 = GameObject.Find("Overlay/UIOverlay")

		arg0_2._go.transform:SetParent(var0_3.transform, false)

		arg0_2._tips = arg0_2._go.transform:Find("trophyRemind")
		arg0_2._grid = arg0_2._go.transform:Find("Grid_trophy")

		arg1_2()
	end)
end

function var1_0.ShowTips(arg0_4, arg1_4)
	var0_0.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_TIP)
	arg0_4._go.transform:SetAsLastSibling()
	SetActive(arg0_4._go, true)

	arg0_4._count = arg0_4._count + 1

	local var0_4 = cloneTplTo(arg0_4._tips, arg0_4._grid)
	local var1_4 = var0_0.medal_template[arg1_4]

	LoadImageSpriteAsync("medal/s_" .. var1_4.icon, var0_4.transform:Find("content/icon"), true)
	setText(var0_4.transform:Find("content/name"), var1_4.name)
	setText(var0_4.transform:Find("content/label"), i18n("trophy_achieved"))

	local var2_4 = var0_4.transform:Find("content")

	var2_4.localPosition = Vector3(-850, 0, 0)

	;(function(arg0_5)
		LeanTween.moveX(rtf(var2_4), -275, 0.5)
		LeanTween.moveX(rtf(var2_4), -850, 0.5):setDelay(5):setOnComplete(System.Action(function()
			Destroy(arg0_5)

			arg0_4._count = arg0_4._count - 1

			if arg0_4._count == 0 then
				SetActive(arg0_4._go, false)
			end
		end))
	end)(var0_4)
end
