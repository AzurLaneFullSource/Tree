local var0_0 = class("IslandIllustrationCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.bgTF = arg0_1._tf:Find("bg")
	arg0_1.bottomTF = arg0_1._tf:Find("bottom")
	arg0_1.nameTF = arg0_1._tf:Find("name")
	arg0_1.scrollNameTF = arg0_1._tf:Find("scrollName/Text")
	arg0_1.iconTF = arg0_1._tf:Find("mask/icon")
	arg0_1.selectedTF = arg0_1._tf:Find("selected")
	arg0_1.phaseTF = arg0_1._tf:Find("phase")
	arg0_1.lockTF = arg0_1._tf:Find("lock")
	arg0_1.canUnLockTF = arg0_1._tf:Find("can_unlock")

	setText(arg0_1.canUnLockTF:Find("Text"), i18n("island_guide_active"))

	arg0_1.tipTF = arg0_1._tf:Find("tip")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.illustration = arg1_2
	arg0_2._go.name = arg0_2.illustration.id

	GetImageSpriteFromAtlasAsync(arg0_2.illustration:GetIcon(), "", arg0_2.iconTF, true)

	local var0_2 = arg0_2.illustration:getConfig("type")
	local var1_2 = var0_2 == IslandIllustration.TYPES.ITEM

	if var1_2 then
		local var2_2 = arg0_2.illustration:getLinkConfig("rarity")

		GetImageSpriteFromAtlasAsync("ui/islandbookui_atlas", "item_bg_" .. var2_2, arg0_2.bgTF, true)
	end

	local var3_2 = arg0_2.illustration:GetStatus()
	local var4_2 = var3_2 == IslandIllustration.STATUS.LOCK

	setActive(arg0_2.lockTF, var4_2)
	setGray(arg0_2.iconTF, var4_2, true)
	setImageAlpha(arg0_2.iconTF, var4_2 and 0.5 or 1)
	setActive(arg0_2.bottomTF, not var4_2 and not var1_2 and var0_2 ~= IslandIllustration.TYPES.FISH)
	setActive(arg0_2.canUnLockTF, var3_2 == IslandIllustration.STATUS.CAN_UNLOCK)
	setActive(arg0_2.tipTF, arg0_2.illustration:IsTip())

	local var5_2 = var1_2 and not var4_2

	setActive(arg0_2.phaseTF, var5_2)

	if var5_2 then
		local var6_2 = arg0_2.illustration:GetCurPhase()

		setActive(arg0_2.phaseTF, var6_2 > 0)

		if var6_2 > 0 then
			GetImageSpriteFromAtlasAsync("ui/islandbookui_atlas", "item_phase_" .. var6_2, arg0_2.phaseTF, true)
		end
	end

	if not var4_2 and var3_2 ~= IslandIllustration.STATUS.CAN_UNLOCK then
		local var7_2 = arg0_2.illustration:GetName()

		if GetPerceptualSize(var7_2) < 7 then
			setActive(arg0_2.nameTF, true)
			setText(arg0_2.nameTF, var7_2)
			setActive(arg0_2.scrollNameTF, false)
		else
			setActive(arg0_2.scrollNameTF, true)
			setScrollText(arg0_2.scrollNameTF, var7_2)
			setActive(arg0_2.nameTF, false)
		end
	else
		setActive(arg0_2.nameTF, false)
		setActive(arg0_2.scrollNameTF, false)
	end

	arg0_2:UpdateSelected(arg2_2)
end

function var0_0.UpdateSelected(arg0_3, arg1_3)
	arg0_3.isSel = arg1_3 and arg1_3 == arg0_3.illustration.id

	setActive(arg0_3.selectedTF, arg0_3.isSel)
end

function var0_0.PlayUnlockAnim(arg0_4, arg1_4)
	if not table.contains(arg1_4, arg0_4.illustration.id) then
		return
	end

	arg0_4._tf:GetComponent(typeof(Animation)):Play()
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
