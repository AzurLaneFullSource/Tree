local var0_0 = class("ItemUsagePanel")

var0_0.SINGLE = 1
var0_0.BATCH = 2
var0_0.INFO = 3
var0_0.SEE = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1

	setActive(arg0_1._go, false)

	arg0_1._parent = arg2_1
	arg0_1.backBtn = findTF(arg0_1._go, "window/top/btnBack")
	arg0_1.itemTF = findTF(arg0_1._go, "window/item")
	arg0_1.itemIntro = findTF(arg0_1.itemTF, "display_panel/desc/Text")
	arg0_1.itemName = findTF(arg0_1.itemTF, "display_panel/name_container/name/Text")
	arg0_1.resetBtn = findTF(arg0_1.itemTF, "reset_btn")
	arg0_1.useBtn = findTF(arg0_1._go, "window/actions/use_one_button")

	setActive(arg0_1.useBtn, false)

	arg0_1.batchUseBtn = findTF(arg0_1._go, "window/actions/batch_use_button")

	setActive(arg0_1.batchUseBtn, false)

	arg0_1.useOneBtn = findTF(arg0_1._go, "window/actions/use_button")

	setActive(arg0_1.useOneBtn, false)

	arg0_1.confirmBtn = findTF(arg0_1._go, "window/actions/confirm_button")

	setActive(arg0_1.confirmBtn, false)

	arg0_1.seeBtn = findTF(arg0_1._go, "window/actions/see_button")

	setActive(arg0_1.seeBtn, false)

	arg0_1.batchText = arg0_1.batchUseBtn:Find("text")

	onButton(arg0_1, arg0_1.backBtn, function()
		arg0_1:Close()
	end, SFX_PANEL)
	onButton(arg0_1, findTF(arg0_1._go, "bg"), function()
		arg0_1:Close()
	end, SFX_PANEL)
end

function var0_0.Open(arg0_4, arg1_4)
	arg0_4.settings = arg1_4 or {}

	local var0_4 = arg0_4.settings.item

	arg0_4:Update(var0_4)
	arg0_4:UpdateAction(var0_4)
	setActive(arg0_4.resetBtn, true)
	setActive(arg0_4._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._go)
end

function var0_0.Close(arg0_5)
	arg0_5.settings = nil

	setActive(arg0_5._go, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_5._go, arg0_5._parent)
end

function var0_0.Update(arg0_6, arg1_6)
	local var0_6 = Drop.New({
		type = DROP_TYPE_WORLD_ITEM,
		id = arg1_6.id,
		count = arg1_6.count
	})

	updateDrop(arg0_6.itemTF:Find("left/IconTpl"), var0_6)
	UpdateOwnDisplay(arg0_6.itemTF:Find("left/own"), var0_6)
	RegisterDetailButton(arg0_6, arg0_6.itemTF:Find("left/detail"), var0_6)
	setText(arg0_6.itemIntro, arg1_6:getConfig("display"))
	setText(arg0_6.itemName, arg1_6:getConfig("name"))
	onButton(arg0_6, arg0_6.resetBtn, function()
		assert(arg0_6.settings.onResetInfo, "without reset info callback")
		arg0_6.settings.onResetInfo(Drop.New({
			count = 1,
			type = DROP_TYPE_WORLD_ITEM,
			id = arg1_6.id
		}))
	end, SFX_PANEL)
end

function var0_0.UpdateAction(arg0_8, arg1_8)
	local var0_8 = arg0_8.settings
	local var1_8 = arg0_8.settings.mode or var0_0.SINGLE

	setActive(arg0_8.useBtn, var1_8 == var0_0.SINGLE)
	setActive(arg0_8.batchUseBtn, var1_8 == var0_0.BATCH)
	setActive(arg0_8.useOneBtn, var1_8 == var0_0.BATCH)
	setActive(arg0_8.confirmBtn, var1_8 == var0_0.INFO)
	setActive(arg0_8.seeBtn, var1_8 == var0_0.SEE)

	if var1_8 == var0_0.SINGLE then
		onButton(arg0_8, arg0_8.useBtn, function()
			if arg1_8.count == 0 then
				return
			end

			if var0_8.onUse then
				var0_8.onUse()
			end

			arg0_8:Close()
		end, SFX_PANEL)
	elseif var1_8 == var0_0.BATCH then
		local var2_8 = math.min(arg1_8.count, 10)

		setText(arg0_8.batchText, var2_8)
		onButton(arg0_8, arg0_8.batchUseBtn, function()
			if arg1_8.count == 0 then
				return
			end

			if var0_8.onUseBatch then
				var0_8.onUseBatch(var2_8)
			end

			arg0_8:Close()
		end, SFX_PANEL)
		onButton(arg0_8, arg0_8.useOneBtn, function()
			if arg1_8.count == 0 then
				return
			end

			if var0_8.onUseOne then
				var0_8.onUseOne()
			end

			arg0_8:Close()
		end, SFX_PANEL)
		setActive(arg0_8.batchUseBtn, var2_8 > 1)
	elseif var1_8 == var0_0.INFO then
		onButton(arg0_8, arg0_8.confirmBtn, function()
			arg0_8:Close()
		end, SFX_PANEL)
	elseif var1_8 == var0_0.SEE then
		onButton(arg0_8, arg0_8.seeBtn, function()
			if arg1_8.count == 0 then
				return
			end

			if var0_8.onUse then
				var0_8.onUse()
			end

			arg0_8:Close()
		end, SFX_PANEL)
	end
end

function var0_0.Dispose(arg0_14)
	pg.DelegateInfo.Dispose(arg0_14)
	arg0_14:Close()
end

return var0_0
