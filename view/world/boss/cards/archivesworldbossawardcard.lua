local var0_0 = class("ArchivesWorldBossAwardCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.itemTF = arg0_1._tf:Find("item")
	arg0_1.itemMaskTF = arg0_1._tf:Find("item/mask")
	arg0_1.itemMaskGotTF = arg0_1._tf:Find("item/mask/Got")
	arg0_1.itemMaskLockTF = arg0_1._tf:Find("item/mask/Lock")
	arg0_1.pointText = arg0_1._tf:Find("point/text")
	arg0_1.lockTr = arg0_1._tf:Find("lock"):GetComponent(typeof(Text))
	arg0_1.gotTr = arg0_1._tf:Find("got"):GetComponent(typeof(Text))
	arg0_1.getTr = arg0_1._tf:Find("get"):GetComponent(typeof(Text))

	setText(arg0_1._tf:Find("point/label"), i18n("meta_pt_point"))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2.itemInfo
	local var1_2 = arg1_2.target
	local var2_2 = arg1_2.level
	local var3_2 = arg1_2.count
	local var4_2 = arg1_2.unlockPTNum

	arg0_2.dropInfo = {
		type = var0_2[1],
		id = var0_2[2],
		count = var0_2[3]
	}

	updateDrop(arg0_2.itemTF, arg0_2.dropInfo, {
		hideName = true
	})
	setText(arg0_2.pointText, var1_2)

	arg0_2.lockTr.text = ""
	arg0_2.getTr.text = ""
	arg0_2.gotTr.text = ""

	local var5_2 = 0

	if arg2_2 < var2_2 + 1 then
		var5_2 = 1
		arg0_2.gotTr.text = i18n("meta_award_got")
	elseif var3_2 < var1_2 then
		var5_2 = 2

		local var6_2 = math.floor(var1_2 / var4_2 * 100) .. "%"

		arg0_2.lockTr.text = "T-" .. arg2_2 .. " " .. var6_2
	else
		arg0_2.getTr.text = i18n("meta_award_get")
	end

	setActive(arg0_2.itemMaskTF, var5_2 ~= 0)
	setActive(arg0_2.itemMaskGotTF, var5_2 == 1)
	setActive(arg0_2.itemMaskLockTF, var5_2 == 2)
end

function var0_0.Dispose(arg0_3)
	return
end

return var0_0
