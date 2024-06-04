local var0 = class("ArchivesWorldBossAwardCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.itemTF = arg0._tf:Find("item")
	arg0.itemMaskTF = arg0._tf:Find("item/mask")
	arg0.itemMaskGotTF = arg0._tf:Find("item/mask/Got")
	arg0.itemMaskLockTF = arg0._tf:Find("item/mask/Lock")
	arg0.pointText = arg0._tf:Find("point/text")
	arg0.lockTr = arg0._tf:Find("lock"):GetComponent(typeof(Text))
	arg0.gotTr = arg0._tf:Find("got"):GetComponent(typeof(Text))
	arg0.getTr = arg0._tf:Find("get"):GetComponent(typeof(Text))

	setText(arg0._tf:Find("point/label"), i18n("meta_pt_point"))
end

function var0.Update(arg0, arg1, arg2)
	local var0 = arg1.itemInfo
	local var1 = arg1.target
	local var2 = arg1.level
	local var3 = arg1.count
	local var4 = arg1.unlockPTNum

	arg0.dropInfo = {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}

	updateDrop(arg0.itemTF, arg0.dropInfo, {
		hideName = true
	})
	setText(arg0.pointText, var1)

	arg0.lockTr.text = ""
	arg0.getTr.text = ""
	arg0.gotTr.text = ""

	local var5 = 0

	if arg2 < var2 + 1 then
		var5 = 1
		arg0.gotTr.text = i18n("meta_award_got")
	elseif var3 < var1 then
		var5 = 2

		local var6 = math.floor(var1 / var4 * 100) .. "%"

		arg0.lockTr.text = "T-" .. arg2 .. " " .. var6
	else
		arg0.getTr.text = i18n("meta_award_get")
	end

	setActive(arg0.itemMaskTF, var5 ~= 0)
	setActive(arg0.itemMaskGotTF, var5 == 1)
	setActive(arg0.itemMaskLockTF, var5 == 2)
end

function var0.Dispose(arg0)
	return
end

return var0
