local var0 = class("ItemUsagePanel")

var0.SINGLE = 1
var0.BATCH = 2
var0.INFO = 3
var0.SEE = 4

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._go = arg1

	setActive(arg0._go, false)

	arg0._parent = arg2
	arg0.backBtn = findTF(arg0._go, "window/top/btnBack")
	arg0.itemTF = findTF(arg0._go, "window/item")
	arg0.itemIntro = findTF(arg0.itemTF, "display_panel/desc/Text")
	arg0.itemName = findTF(arg0.itemTF, "display_panel/name_container/name/Text")
	arg0.resetBtn = findTF(arg0.itemTF, "reset_btn")
	arg0.useBtn = findTF(arg0._go, "window/actions/use_one_button")

	setActive(arg0.useBtn, false)

	arg0.batchUseBtn = findTF(arg0._go, "window/actions/batch_use_button")

	setActive(arg0.batchUseBtn, false)

	arg0.useOneBtn = findTF(arg0._go, "window/actions/use_button")

	setActive(arg0.useOneBtn, false)

	arg0.confirmBtn = findTF(arg0._go, "window/actions/confirm_button")

	setActive(arg0.confirmBtn, false)

	arg0.seeBtn = findTF(arg0._go, "window/actions/see_button")

	setActive(arg0.seeBtn, false)

	arg0.batchText = arg0.batchUseBtn:Find("text")

	onButton(arg0, arg0.backBtn, function()
		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0._go, "bg"), function()
		arg0:Close()
	end, SFX_PANEL)
end

function var0.Open(arg0, arg1)
	arg0.settings = arg1 or {}

	local var0 = arg0.settings.item

	arg0:Update(var0)
	arg0:UpdateAction(var0)
	setActive(arg0.resetBtn, true)
	setActive(arg0._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._go)
end

function var0.Close(arg0)
	arg0.settings = nil

	setActive(arg0._go, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._go, arg0._parent)
end

function var0.Update(arg0, arg1)
	local var0 = Drop.New({
		type = DROP_TYPE_WORLD_ITEM,
		id = arg1.id,
		count = arg1.count
	})

	updateDrop(arg0.itemTF:Find("left/IconTpl"), var0)
	UpdateOwnDisplay(arg0.itemTF:Find("left/own"), var0)
	RegisterDetailButton(arg0, arg0.itemTF:Find("left/detail"), var0)
	setText(arg0.itemIntro, arg1:getConfig("display"))
	setText(arg0.itemName, arg1:getConfig("name"))
	onButton(arg0, arg0.resetBtn, function()
		assert(arg0.settings.onResetInfo, "without reset info callback")
		arg0.settings.onResetInfo(Drop.New({
			count = 1,
			type = DROP_TYPE_WORLD_ITEM,
			id = arg1.id
		}))
	end, SFX_PANEL)
end

function var0.UpdateAction(arg0, arg1)
	local var0 = arg0.settings
	local var1 = arg0.settings.mode or var0.SINGLE

	setActive(arg0.useBtn, var1 == var0.SINGLE)
	setActive(arg0.batchUseBtn, var1 == var0.BATCH)
	setActive(arg0.useOneBtn, var1 == var0.BATCH)
	setActive(arg0.confirmBtn, var1 == var0.INFO)
	setActive(arg0.seeBtn, var1 == var0.SEE)

	if var1 == var0.SINGLE then
		onButton(arg0, arg0.useBtn, function()
			if arg1.count == 0 then
				return
			end

			if var0.onUse then
				var0.onUse()
			end

			arg0:Close()
		end, SFX_PANEL)
	elseif var1 == var0.BATCH then
		local var2 = math.min(arg1.count, 10)

		setText(arg0.batchText, var2)
		onButton(arg0, arg0.batchUseBtn, function()
			if arg1.count == 0 then
				return
			end

			if var0.onUseBatch then
				var0.onUseBatch(var2)
			end

			arg0:Close()
		end, SFX_PANEL)
		onButton(arg0, arg0.useOneBtn, function()
			if arg1.count == 0 then
				return
			end

			if var0.onUseOne then
				var0.onUseOne()
			end

			arg0:Close()
		end, SFX_PANEL)
		setActive(arg0.batchUseBtn, var2 > 1)
	elseif var1 == var0.INFO then
		onButton(arg0, arg0.confirmBtn, function()
			arg0:Close()
		end, SFX_PANEL)
	elseif var1 == var0.SEE then
		onButton(arg0, arg0.seeBtn, function()
			if arg1.count == 0 then
				return
			end

			if var0.onUse then
				var0.onUse()
			end

			arg0:Close()
		end, SFX_PANEL)
	end
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Close()
end

return var0
