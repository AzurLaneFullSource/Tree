pg = pg or {}
pg.WorldToastMgr = singletonClass("WorldToastMgr")

local var0_0 = pg.WorldToastMgr

var0_0.Type2PictrueName = {
	[0] = "type_operation",
	"type_fight",
	"type_search",
	"type_build",
	"type_defience",
	"type_special",
	"type_collection",
	"type_boss"
}

function var0_0.Init(arg0_1, arg1_1)
	LoadAndInstantiateAsync("ui", "WorldTaskFloatUI", function(arg0_2)
		arg0_1._go = arg0_2

		arg0_1._go:SetActive(false)

		arg0_1._tf = arg0_1._go.transform

		arg0_1._tf:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		arg0_1.displayList = {}

		if arg1_1 then
			arg1_1()
		end
	end, true, true)
end

function var0_0.ShowToast(arg0_3, arg1_3, arg2_3)
	table.insert(arg0_3.displayList, {
		taskVO = arg1_3,
		isSubmitDone = arg2_3
	})

	if #arg0_3.displayList == 1 then
		arg0_3:StartToast()
	end
end

function var0_0.StartToast(arg0_4)
	setAnchoredPosition(arg0_4._tf, {
		y = arg0_4._tf.rect.height
	})
	setActive(arg0_4._tf, true)

	local var0_4 = arg0_4.displayList[1]

	setActive(arg0_4._tf:Find("accept_info"), not var0_4.isSubmitDone)
	setActive(arg0_4._tf:Find("submit_info"), var0_4.isSubmitDone)

	local var1_4 = var0_4.taskVO

	GetImageSpriteFromAtlasAsync("ui/worldtaskfloatui_atlas", var0_0.Type2PictrueName[var1_4.config.type], arg0_4._tf:Find("type_icon"), true)
	setText(arg0_4._tf:Find("desc"), setColorStr(shortenString(var1_4.config.name, 12), var0_4.isSubmitDone and COLOR_GREEN or COLOR_WHITE))

	local var2_4 = {}

	table.insert(var2_4, function(arg0_5)
		arg0_4.twId = LeanTween.moveY(arg0_4._tf, 0, 0.5):setOnComplete(System.Action(arg0_5))
	end)
	table.insert(var2_4, function(arg0_6)
		arg0_4.twId = LeanTween.moveY(arg0_4._tf, arg0_4._tf.rect.height, 0.5):setDelay(3):setOnComplete(System.Action(arg0_6))
	end)
	seriesAsync(var2_4, function()
		table.remove(arg0_4.displayList, 1)

		if #arg0_4.displayList > 0 then
			arg0_4:StartToast()
		else
			setActive(arg0_4._tf, false)
		end
	end)
end

function var0_0.Dispose(arg0_8)
	LeanTween.cancel(arg0_8.twId)

	arg0_8.displayList = nil
end
