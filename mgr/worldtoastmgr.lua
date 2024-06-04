pg = pg or {}
pg.WorldToastMgr = singletonClass("WorldToastMgr")

local var0 = pg.WorldToastMgr

var0.Type2PictrueName = {
	[0] = "type_operation",
	"type_fight",
	"type_search",
	"type_build",
	"type_defience",
	"type_special",
	"type_collection",
	"type_boss"
}

function var0.Init(arg0, arg1)
	PoolMgr.GetInstance():GetUI("WorldTaskFloatUI", true, function(arg0)
		arg0._go = arg0

		arg0._go:SetActive(false)

		arg0._tf = arg0._go.transform

		arg0._tf:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		arg0.displayList = {}

		if arg1 then
			arg1()
		end
	end)
end

function var0.ShowToast(arg0, arg1, arg2)
	table.insert(arg0.displayList, {
		taskVO = arg1,
		isSubmitDone = arg2
	})

	if #arg0.displayList == 1 then
		arg0:StartToast()
	end
end

function var0.StartToast(arg0)
	setAnchoredPosition(arg0._tf, {
		y = arg0._tf.rect.height
	})
	setActive(arg0._tf, true)

	local var0 = arg0.displayList[1]

	setActive(arg0._tf:Find("accept_info"), not var0.isSubmitDone)
	setActive(arg0._tf:Find("submit_info"), var0.isSubmitDone)

	local var1 = var0.taskVO

	GetImageSpriteFromAtlasAsync("ui/worldtaskfloatui_atlas", var0.Type2PictrueName[var1.config.type], arg0._tf:Find("type_icon"), true)
	setText(arg0._tf:Find("desc"), setColorStr(shortenString(var1.config.name, 12), var0.isSubmitDone and COLOR_GREEN or COLOR_WHITE))

	local var2 = {}

	table.insert(var2, function(arg0)
		arg0.twId = LeanTween.moveY(arg0._tf, 0, 0.5):setOnComplete(System.Action(arg0))
	end)
	table.insert(var2, function(arg0)
		arg0.twId = LeanTween.moveY(arg0._tf, arg0._tf.rect.height, 0.5):setDelay(3):setOnComplete(System.Action(arg0))
	end)
	seriesAsync(var2, function()
		table.remove(arg0.displayList, 1)

		if #arg0.displayList > 0 then
			arg0:StartToast()
		else
			setActive(arg0._tf, false)
		end
	end)
end

function var0.Dispose(arg0)
	LeanTween.cancel(arg0.twId)

	arg0.displayList = nil

	PoolMgr.GetInstance():ReturnUI("WorldTaskFloatUI", arg0._go)
end
